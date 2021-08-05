function Get-GitLabMergeRequest {
    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param(
        [Parameter(Position=0, Mandatory=$true, ParameterSetName="ByProjectId")]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $MergeRequestId,

        [Parameter(Position=0, Mandatory=$true,ParameterSetName="ByGroupId")]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false, ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [ValidateSet("closed", "opened", "merged")]
        [string]
        $State,

        [Parameter(Mandatory=$false,ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $CreatedAfter,

        [Parameter(Mandatory=$false,ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $CreatedBefore,

        [Parameter(Mandatory=$false,ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [ValidateSet($null, $true, $false)]
        [object]
        $IsDraft,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    if ($ProjectId) {
        $ProjectId = $(Get-GitLabProject -ProjectId $ProjectId).Id
    }

    if ($GroupId) {
        $GroupId = $(Get-GitLabGroup -GroupId $GroupId).Id
    }

    $Path = $null
    $MaxPages = 1
    $Query = @{}

    if ($MergeRequestId) {
        $Path = "projects/$ProjectId/merge_requests/$MergeRequestId"
    } elseif ($ProjectId) {
        $Path = "projects/$ProjectId/merge_requests"
        $MaxPages = 10
    } elseif ($GroupId) {
        $Path = "groups/$GroupId/merge_requests"
        $MaxPages = 10
    } else {
        throw "Unsupported parameter combination"
    }

    if($State) {
        $Query['state'] = $State
    }

    if ($CreatedBefore) {
        $Query['created_before'] = $CreatedBefore
    }

    if ($CreatedAfter) {
        $Query['created_after'] = $CreatedAfter
    }

    if ($IsDraft -ne $null) {
        $Query['wip'] = $IsDraft ? 'yes' : 'no'
    }
    
    return Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages -WhatIf:$WhatIf | 
        ForEach-Object {
            $_ | New-WrapperObject -DisplayType 'Gitlab.MergeRequest'
        }
}

function Get-GitLabMergeRequestChangeSummary {
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        $MergeRequest
    )
    $MrDiff = gitlab -o json project-merge-request-diff list --project-id $MergeRequest.ProjectId --mr-iid $MergeRequest.Iid |
        ConvertFrom-Json |
        Where-Object state -ieq 'collected'
    $Summary = gitlab -o json project-merge-request-diff get --project-id $MergeRequest.ProjectId --mr-iid $MergeRequest.Iid --id $MrDiff.id |
        ConvertFrom-Json |
        Select-Object -ExpandProperty commits |
        ForEach-Object {
            $Commit = gitlab -o json project-commit get --project-id $MergeRequest.ProjectId --id $_.id | ConvertFrom-Json
            [PSCustomObject]@{
                AuthorName = $Commit.author_name
                AuthoredDate = $Commit.authored_date
                Stats = $Commit.stats
            }
        }
    [PSCustomObject]@{
        Authors = [string]::Join(', ', $($Summary.AuthorName | Select-Object -Unique | Sort-Object))
        OldestChange = $Summary.AuthoredDate | Sort-Object | Select-Object -First 1
        Commits = $Summary.Stats | Measure-Object | Select-Object -ExpandProperty Count
        Additions = $Summary.Stats.additions | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        Deletions = $Summary.Stats.deletions | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        Total = $Summary.Stats.total | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    }
}

function New-GitLabMergeRequest {
    [CmdletBinding()]
    [Alias("new-mr")]
    param(
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $SourceBranch,

        [Parameter(Position=2, Mandatory=$false)]
        [string]
        $TargetBranch,

        [Parameter(Position=3, Mandatory=$false)]
        [string]
        $Title,

        [Parameter(Mandatory=$false)]
        [switch]
        $Follow,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    if (-not $ProjectId) {
        $ProjectId = '.'
    }

    $Project = Get-GitLabProject -ProjectId $ProjectId

    if (-not $TargetBranch) {
        $TargetBranch = $Project.DefaultBranch
    }
    if (-not $SourceBranch) {
        $SourceBranch = $(Get-LocalGitContext).Branch
    }
    if (-not $Title) {
        $Title = $SourceBranch.Replace('-', ' ').Replace('_', ' ')
    }

    $MergeRequest = Invoke-GitlabApi POST "projects/$($Project.Id)/merge_requests" @{
        source_branch = $SourceBranch
        target_branch = $TargetBranch
        title = $Title
    } -WhatIf:$WhatIf | New-WrapperObject $_ -DisplayType 'GitLab.MergeRequest'
    if ($Follow) {
        Start-Process $MergeRequest.WebUrl
    }

    $MergeRequest | Format-Table -AutoSize
}

function Update-GitLabMergeRequest {
    [CmdletBinding(DefaultParameterSetName="Update")]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $Title,

        [Parameter(Mandatory=$false)]
        [string]
        $Description,

        [Parameter(Mandatory=$false, ParameterSetName="Close")]
        [switch]
        $Close,

        [Parameter(Mandatory=$false, ParameterSetName="Reopen")]
        [switch]
        $Reopen,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $ProjectId = $(Get-GitLabProject -ProjectId $ProjectId).Id
    $Query = @{}

    if ($Close) {
        $Query['state_event'] = 'close'
    }

    if ($Reopen) {
        $Query['state_event'] = 'reopen'
    }
    
    if ($Title) {
        $Query['title'] = $Title
    }

    if ($Description) {
        $Query['description'] = $Description
    }

    Invoke-GitlabApi PUT "projects/$ProjectId/merge_requests/$MergeRequestId" $Query -WhatIf:$WhatIf |
        New-WrapperObject $_ -DisplayType 'GitLab.MergeRequest'
}

function Close-GitLabMergeRequest {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $ProjectId = $(Get-GitLabProject -ProjectId $ProjectId).Id

    Update-GitLabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -Close -WhatIf:$WhatIf
}
