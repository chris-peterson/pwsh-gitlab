
function Get-GitlabMergeRequest {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [Alias('mrs')]
    param(
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ByProjectId')]
        [Alias("Id")]
        [string]
        $MergeRequestId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroupId')]
        [string]
        $GroupId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByUrl')]
        [string]
        $Url,

        [Parameter(Mandatory=$false)]
        [ValidateSet('', 'closed', 'opened', 'merged')]
        [string]
        $State = 'opened',

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [string]
        $CreatedAfter,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [string]
        $CreatedBefore,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [ValidateSet($null, $true, $false)]
        [object]
        $IsDraft,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [string]
        $Branch,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeApprovals,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeChangeSummary,

        [Parameter(Mandatory=$true, ParameterSetName='Mine')]
        [switch]
        $Mine,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Path = $null
    $MaxPages = 1
    $Query = @{}

    if ($Mine) {
        $Path = 'merge_requests'
    }
    else {
        if ($Url -and $Url -match "$($(Get-DefaultGitlabSite).Url)/(?<ProjectId>.*)/-/merge_requests/(?<MergeRequestId>\d+)") {
            $ProjectId = $Matches.ProjectId
            $MergeRequestId = $Matches.MergeRequestId
        }
        if ($ProjectId) {
            $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
        }
        if ($GroupId) {
            $GroupId = $(Get-GitlabGroup -GroupId $GroupId).Id
        }

        if ($MergeRequestId) {
            # https://docs.gitlab.com/ee/api/merge_requests.html#get-single-mr
            $Path = "projects/$ProjectId/merge_requests/$MergeRequestId"
        } elseif ($ProjectId) {
            # https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests
            $Path = "projects/$ProjectId/merge_requests"
            $MaxPages = 10
        } elseif ($GroupId) {
            # https://docs.gitlab.com/ee/api/merge_requests.html#list-group-merge-requests
            $Path = "groups/$GroupId/merge_requests"
            $MaxPages = 10
        } else {
            throw "Unsupported parameter combination"
        }
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

    if ($IsDraft) {
        $Query['wip'] = $IsDraft ? 'yes' : 'no'
    }

    if ($Branch) {
        if ($Branch -eq '.') {
            $Branch = Get-LocalGitContext | Select-Object -ExpandProperty Branch
        }
        $Query['source_branch'] = $Branch
    }
    
    $MergeRequests = Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.MergeRequest'

    if ($IncludeApprovals) {
        # GraphQL currently doesn't support award emoji.  as and when it does, we could merge IncludeApprovals and IncludeChangeSummary to both use GraphQL
        $MergeRequests | ForEach-Object {
            $Approvals = Invoke-GitlabApi GET "projects/$($_.ProjectId)/merge_requests/$($_.MergeRequestId)/approval_state" -SiteUrl $SiteUrl -WhatIf:$WhatIf
            
            if ($Approvals.rules.approved_by) {
                $_ | Add-Member -MemberType 'NoteProperty' -Name 'Approvals' -Value $($Approvals.rules.approved_by | New-WrapperObject 'Gitlab.User')
            }

            $ThumbsUp = Invoke-GitlabApi GET "projects/$($_.ProjectId)/merge_requests/$($_.MergeRequestId)/award_emoji" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Where-Object name -ieq 'thumbsup'
            if ($ThumbsUp.user) {
                $_ | Add-Member -MemberType 'NoteProperty' -Name 'ThumbsUp' -Value $($ThumbsUp.user | New-WrapperObject 'Gitlab.User')
            }
        }
    }
    if ($IncludeChangeSummary) {
        $MergeRequests | ForEach-Object {
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'ChangeSummary' -Value $($_ | Get-GitlabMergeRequestChangeSummary)
        }
    }

    $MergeRequests | Sort-Object ProjectPath
}

function Get-GitlabMergeRequestChangeSummary {
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        $MergeRequest
    )

    $Data = Invoke-GitlabGraphQL -Query @"
    {
        project(fullPath: "$($MergeRequest.ProjectPath)") {
            mergeRequest(iid: "$($MergeRequest.MergeRequestId)") {
                diffStatsSummary {
                    additions
                    deletions
                    files: fileCount
                }
                commitsWithoutMergeCommits {
                    nodes {
                      author {
                          username
                      }
                      authoredDate
                    }
                }
                notes {
                    nodes {
                      body
                      updatedAt
                    }
                }
            }
        }
    }
"@

    [PSCustomObject]@{
        Authors      = $Data.Project.mergeRequest.commitsWithoutMergeCommits.nodes.author.username | Select-Object -Unique
        Changes      = $Data.Project.mergeRequest.diffStatsSummary | New-WrapperObject
        AssignedAt   = $Data.Project.mergeRequest.notes.nodes | Where-Object body -Match '^assigned to @' | Sort-Object updatedAt | Select-Object -First 1 -ExpandProperty updatedAt
        OldestChange = $Data.Project.mergeRequest.commitsWithoutMergeCommits.nodes.authoredDate | Sort-Object | Select-Object -First 1
    }
}

function New-GitlabMergeRequest {
    [CmdletBinding()]
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
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if (-not $ProjectId) {
        $ProjectId = '.'
    }

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if (-not $TargetBranch) {
        $TargetBranch = $Project.DefaultBranch
    }
    if (-not $SourceBranch -or $SourceBranch -eq '.') {
        $SourceBranch = $(Get-LocalGitContext).Branch
    }
    if (-not $Title) {
        $Title = $SourceBranch.Replace('-', ' ').Replace('_', ' ')
    }

    $Me = Get-GitlabCurrentUser

    $MergeRequest = $(Invoke-GitlabApi POST "projects/$($Project.Id)/merge_requests" @{
        source_branch = $SourceBranch
        target_branch = $TargetBranch
        remove_source_branch = 'true'
        assignee_id = $Me.Id
        title = $Title
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf) | New-WrapperObject 'Gitlab.MergeRequest'
    if ($Follow) {
        Start-Process $MergeRequest.WebUrl
    }

    $MergeRequest
}

function Set-GitlabMergeRequest {
    [CmdletBinding()]
    [Alias("mr")]

    param (
    )

    $ProjectId = '.'
    $Branch = '.'

    $Existing = Get-GitlabMergeRequest -ProjectId $ProjectId -Branch $Branch -State 'opened'
    if ($Existing) {
        return $Existing
    }

    New-GitlabMergeRequest -ProjectId $ProjectId -SourceBranch $Branch
}

function Update-GitlabMergeRequest {
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

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
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

    Invoke-GitlabApi PUT "projects/$ProjectId/merge_requests/$MergeRequestId" $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.MergeRequest'
}

function Close-GitlabMergeRequest {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    Update-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -Close -WhatIf:$WhatIf
}

function Invoke-GitlabMergeRequestReview {
    [CmdletBinding()]
    [Alias('Review-GitlabMergeRequest')]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId '.').Id

    $MergeRequest = Get-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId

    git stash | Out-Null
    git pull -p | Out-Null
    git checkout $MergeRequest.SourceBranch
    git diff "origin/$($MergeRequest.TargetBranch)"
}

function Approve-GitlabMergeRequest {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId '.' -SiteUrl $SiteUrl).Id

    if (-not $MergeRequestId) {
        $MergeRequest = Get-GitlabMergeRequest -ProjectId $ProjectId -Branch '.' -State 'opened' -SiteUrl $SiteUrl
        if ($MergeRequest) {
            $MergeRequestId = $MergeRequest.MergeRequestId
        }
    }

    Invoke-GitlabApi POST "/projects/$ProjectId/merge_requests/$MergeRequestId/approve" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    Get-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -IncludeApprovals -SiteUrl $SiteUrl
}
