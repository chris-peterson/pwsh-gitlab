function Get-GitlabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
    param (
        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ById')]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroup')]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='ByGroup')]
        $IncludeArchived = $false
    )

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        if ($ProjectId -eq '.') {
            $ProjectId = $(Get-LocalGitContext).Repo
        }
        $Project = Invoke-GitlabApi GET "projects/$([System.Net.WebUtility]::UrlEncode($ProjectId))"
        if ($Project) {
            return $Project | New-WrapperObject 'Gitlab.Project'
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'ByGroup') {
        $Group = Get-GitlabGroup $GroupId
        $Query = @{
            'include_subgroups' = 'true'
        }
        if(-not $IncludeArchived) {
            $Query['archived'] = 'false'
        }
        Invoke-GitlabApi GET "groups/$($Group.Id)/projects" $Query -MaxPage 10 | 
        Where-Object { $($_.path_with_namespace).StartsWith($Group.FullPath) } |
        New-WrapperObject 'Gitlab.Project' |
        Sort-Object -Property 'Name'
    }
}

function Move-GitlabProject {
    [Alias("Transfer-GitlabProject")]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $DestinationGroup,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    Invoke-GitlabApi PUT "projects/$($SourceProject.Id)/transfer" @{
        namespace = $Group.Id
    } -WhatIf:$WhatIf -WhatIfContext @{
        SourceProjectName = $SourceProject.Name
        NamespacePath = $Group.FullPath
    } | Out-Null
}

function Rename-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $NewName,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    
    Invoke-GitlabApi PUT "projects/$($SourceProject.Id)" @{
        'name' = $NewName
        'path' = $NewName
    } -WhatIf:$WhatIf | Out-Null
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

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    if ($WhatIf) {
        Write-Host "WhatIf: forking '$($SourceProject.Name)' (project id: $($SourceProject.Id)) to '$($Group.FullPath)' (group id: $($Group.Id))"
    } else {
        $NewProject = Invoke-GitlabApi POST "projects/$($SourceProject.Id)/fork" @{
            namespace_id = $Group.Id
        }
    }

    if (-not $PreserveForkRelationship) {
        if ($WhatIf) {
            Write-Host "WhatIf: removing fork relationship to $($SourceProject.Id)"
        } else {
            Invoke-GitlabApi DELETE "projects/$($NewProject.id)/fork"
        }
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

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $Group = Get-GitlabGroup -GroupId $DestinationGroup
    if(-not $Group) {
        throw "DestinationGroup '$DestinationGroup' not found"
    }

    Invoke-GitlabApi POST "projects" @{
        name = $ProjectName
        namespace_id = $Group.Id
    } -WhatIf:$WhatIf -WhatIfContext @{
        DestinationGroupName = $Group.Name
    }
}

function Invoke-GitlabProjectArchival {
    [Alias('Archive-GitlabProject')]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $Project = $(Get-GitlabProject -ProjectId $ProjectId)
    
    Invoke-GitlabApi POST "projects/$($Project.Id)/archive" -WhatIf:$WhatIf -WhatIfContext @{
        ProjectName = $Project.Name
    }
}
