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

    $CmdToExecute = "gitlab -o json"
    if ($MergeRequestId) {
        $CmdToExecute += " project-merge-request get --project-id $ProjectId --iid $MergeRequestId"
    } elseif ($ProjectId) {
        $CmdToExecute += " project-merge-request list --project-id $ProjectId --all"
    } elseif ($GroupId) {
        $CmdToExecute += " group-merge-request list --group-id $GroupId --all"
    } else {
        throw "Unsupported parameter combination"
    }

    if($State) {
        $CmdToExecute += " --state $State"
    }

    if ($CreatedBefore) {
        $CmdToExecute += " --created-before $CreatedBefore"
    }

    if ($CreatedAfter) {
        $CmdToExecute += " --created-after $CreatedAfter"
    }

    if ($IsDraft -ne $null) {
        $CmdToExecute += " --wip $($IsDraft ? 'yes' : 'no')"
    }
    
    if ($WhatIf) {
        Write-Host "WhatIf: $CmdToExecute"
    } else {
        $MergeRequests = Invoke-Expression $CmdToExecute | ConvertFrom-Json
        return $MergeRequests | ForEach-Object { New-WrapperObject $_ -DisplayType 'Gitlab.MergeRequest' }
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


    if ($WhatIf) {
        Write-Host "WhatIf: create merge request of '$SourceBranch' to '$TargetBranch' in '$($Project.PathWithNamespace)'"
    } else {
        $MergeRequest = $(gitlab -o json project-merge-request create --project-id $($Project.Id) --source-branch $SourceBranch --target-branch $TargetBranch --title "$Title") |
            ConvertFrom-Json |
            ForEach-Object { New-WrapperObject $_ -DisplayType 'GitLab.MergeRequest' }
        if ($Follow) {
            Start-Process $MergeRequest.WebUrl
        }

        $MergeRequest | Format-Table -AutoSize
    }
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

    $CmdToExecute += "gitlab -o json project-merge-request update --project-id $($ProjectId) --iid $($MergeRequestId)"

    if ($Close) {
        $CmdToExecute += " --state-event close"
    }

    if ($Reopen) {
        $CmdToExecute += " --state-event reopen"
    }
    
    if ($Title) {
        $CmdToExecute += " --title '$Title'"
    }

    if ($Description) {
        $CmdToExecute += " --description '$Description'"
    }

    if($WhatIf) {
        Write-Host "WhatIf: $CmdToExecute"
    } else {
        Invoke-Expression $CmdToExecute | ConvertFrom-Json | ForEach-Object { New-WrapperObject $_ -DisplayType 'GitLab.MergeRequest' }
    }
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

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $ProjectId = $(Get-GitLabProject -ProjectId $ProjectId).Id

    if ($WhatIf) {
        Write-Host "WhatIf: closing merge request $MergeRequestId for project $ProjectId"
    } else {
        Update-GitLabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -Close
    }
}
