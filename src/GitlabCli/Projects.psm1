function Get-GitLabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
    param (
        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ById')]
        [string]
        $ProjectId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroup')]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='ByGroup')]
        $IncludeArchived = $false
    )

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $Project = gitlab -o json project get --id $ProjectId | ConvertFrom-Json
        if ($Project) {
            return $Project | New-WrapperObject -DisplayType 'GitLab.Project'
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'ByGroup') {
        $Group = $(gitlab -o json group get --id $GroupId | ConvertFrom-Json)
        $Projects = gitlab -o json group-project list --group-id $($Group.id) --include-subgroups true --all | ConvertFrom-Json
        if ($Projects) {
            if (-not $IncludeArchived) {
                $Projects = $Projects | Where-Object -not Archived
            }
            
            $Projects |
                Where-Object { $($_.path_with_namespace).StartsWith($Group.full_path) } |
                ForEach-Object { Get-GitLabProject -ProjectId $_.id } |
                Sort-Object -Property 'Name'
        }
    }
}

function Move-GitLabProject {
    [Alias("Transfer-GitLabProject")]
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

    $SourceProject = Get-GitLabProject -ProjectId $ProjectId
    $Group = Get-GitLabGroup -GroupId $DestinationGroup

    if ($WhatIf) {
        Write-Host "WhatIf: moving '$($SourceProject.Name)' (project id: $($SourceProject.Id)) to '$($Group.FullPath)' (group id: $($Group.Id))"
    } else {
        gitlab project transfer-project --id $SourceProject.Id --to-namespace $Group.Id
    }
}

function Copy-GitLabProject {
    [Alias("Fork-GitLabProject")]
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

    $SourceProject = Get-GitLabProject -ProjectId $ProjectId
    $Group = Get-GitLabGroup -GroupId $DestinationGroup

    if ($WhatIf) {
        Write-Host "WhatIf: forking '$($SourceProject.Name)' (project id: $($SourceProject.Id)) to '$($Group.FullPath)' (group id: $($Group.Id))"
    } else {
        $NewProject = gitlab -o json project-fork create --namespace $Group.Id --project-id $SourceProject.Id | ConvertFrom-Json
    }

    if (-not $PreserveForkRelationship) {
        if ($WhatIf) {
            Write-Host "WhatIf: removing fork relationship to $($SourceProject.Id)"
        } else {
            gitlab project delete-fork-relation --id $NewProject.id
        }
    }
}