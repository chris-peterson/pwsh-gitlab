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
            $Project = Invoke-GitlabApi GET "projects/$($ProjectId | ConvertTo-UrlEncoded)" -SiteUrl $SiteUrl -WhatIf:$WhatIf
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

# https://docs.gitlab.com/ee/api/projects.html#edit-project
function Update-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [ValidateSet('private', 'internal', 'public')]
        [string]
        $Visibility,

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
        [ValidateSet('disabled', 'private', 'enabled')]
        [string]
        $BuildsAccessLevel,

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
    if ($Visibility) {
        $Query['visibility'] = $Visibility
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
    if ($BuildsAccessLevel) {
        $Query['builds_access_level'] = $BuildsAccessLevel
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

# https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
function Get-GitlabProjectVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    if ($Key) {
        Invoke-GitlabApi GET "projects/$($Project.Id)/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        Invoke-GitlabApi GET "projects/$($Project.Id)/variables" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
}

# https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
function Set-GitlabProjectVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $Value,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Query = @{
        value = $Value
    }

    $ProjectId = $(Get-GitlabProject $ProjectId).Id

    try {
        Get-GitlabProjectVariable $ProjectId $Key
        $IsExistingVariable = $True
    }
    catch {
        $IsExistingVariable = $False
    }

    if ($IsExistingVariable) {
        Invoke-GitlabApi PUT "projects/$($ProjectId)/variables/$Key" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        $Query.Add('key', $Key)
        Invoke-GitlabApi POST "projects/$($ProjectId)/variables" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
}

# https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
function Remove-GitlabProjectVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    Invoke-GitlabApi DELETE "projects/$($Project.Id)/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
}
