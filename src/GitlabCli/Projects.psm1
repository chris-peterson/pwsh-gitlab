function Get-GitlabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
    param (
        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ById')]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroup', ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByUrl')]
        [string]
        $Url,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='ByGroup')]
        $IncludeArchived = $false,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    switch ($PSCmdlet.ParameterSetName) {
        ById {
            if ($ProjectId -eq '.') {
                $ProjectId = $(Get-LocalGitContext).Project
            }
            $Project = Invoke-GitlabApi GET "projects/$([System.Net.WebUtility]::UrlEncode($ProjectId))" -SiteUrl $SiteUrl -WhatIf:$WhatIf
            if ($Project) {
                return $Project | New-WrapperObject 'Gitlab.Project'
            }
        }
        ByGroup {
            $Group = Get-GitlabGroup $GroupId
            $Query = @{
                'include_subgroups' = 'true'
            }
            if (-not $IncludeArchived) {
                $Query['archived'] = 'false'
            }
            Invoke-GitlabApi GET "groups/$($Group.Id)/projects" $Query -MaxPage 10 -SiteUrl $SiteUrl -WhatIf:$WhatIf |
                Where-Object { $($_.path_with_namespace).StartsWith($Group.FullPath) } |
                New-WrapperObject 'Gitlab.Project' |
                Sort-Object -Property 'Name'
        }
        ByUrl {
            $Url -match "$($(Get-DefaultGitlabSite).Url)/(?<ProjectId>.*)" | Out-Null
            if ($Matches) {
                $ProjectId = $Matches.ProjectId
                Get-GitlabProject -ProjectId $ProjectId
            }
        }
    }
}

function Move-GitlabProject {
    [Alias("Transfer-GitlabProject")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true)]
        [string]
        $DestinationGroup,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    Invoke-GitlabApi PUT "projects/$($SourceProject.Id)/transfer" @{
        namespace = $Group.Id
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf -WhatIfContext @{
        SourceProjectName = $SourceProject.Name
        NamespacePath = $Group.FullPath
    } | New-WrapperObject 'Gitlab.Project'
}

function Rename-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true)]
        [string]
        $NewName,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Update-GitlabProject -ProjectId $ProjectId -Name $NewName -Path $NewName -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

function Copy-GitlabProject {
    [Alias("Fork-GitlabProject")]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $DestinationGroup,

        [bool]
        [Parameter(Mandatory=$false)]
        $PreserveForkRelationship = $true,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    if ($WhatIf) {
        Write-Host "WhatIf: forking '$($SourceProject.Name)' (project id: $($SourceProject.Id)) to '$($Group.FullPath)' (group id: $($Group.Id))"
    } else {
        $NewProject = Invoke-GitlabApi POST "projects/$($SourceProject.Id)/fork" @{
            namespace_id = $Group.Id
        } -SiteUrl $SiteUrl -WhatIf:$WhatIf
    }

    if (-not $PreserveForkRelationship) {
        Invoke-GitlabApi DELETE "projects/$($NewProject.id)/fork" -SiteUrl $SiteUrl -WhatIf:$WhatIf
    }
}
function New-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectName,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $DestinationGroup,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Group = Get-GitlabGroup -GroupId $DestinationGroup
    if(-not $Group) {
        throw "DestinationGroup '$DestinationGroup' not found"
    }

    Invoke-GitlabApi POST "projects" @{
        name = $ProjectName
        namespace_id = $Group.Id
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf -WhatIfContext @{
        DestinationGroupName = $Group.Name
    }
}

function Update-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $Path,

        [Parameter(Mandatory=$false)]
        [string []]
        $Topics,

        [Parameter(Mandatory=$false)]
        [bool]
        $CiForwardDeployment,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    $Query = @{}

    if($PSBoundParameters.ContainsKey("CiForwardDeployment")){
        $Query['ci_forward_deployment_enabled'] = $CiForwardDeployment
    }
    if ($Name) {
        $Query['name'] = $Name
    }
    if ($Path) {
        $Query['path'] = $Path
    }
    if ($Topics) {
        $Query['topics'] = $Topics -join ','
    }

    Invoke-GitlabApi PUT "projects/$($Project.Id)" $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Project'
}

function Invoke-GitlabProjectArchival {
    [Alias('Archive-GitlabProject')]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = $(Get-GitlabProject -ProjectId $ProjectId)
    
    Invoke-GitlabApi POST "projects/$($Project.Id)/archive" -SiteUrl $SiteUrl -WhatIf:$WhatIf -WhatIfContext @{
        ProjectName = $Project.Name
    } | New-WrapperObject 'Gitlab.Project'
}
