
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
                      author {
                          username
                      }
                      body
                      updatedAt
                    }
                }
            }
        }
    }
"@

    $Mr = $Data.Project.mergeRequest
    $Notes = $Mr.notes.nodes | Where-Object body -NotMatch "^assigned to @$($MergeRequest.Author.username)" # filter out self-assignment
    $Summary = [PSCustomObject]@{
        Changes           = $Mr.diffStatsSummary | New-WrapperObject
        Authors           = $Mr.commitsWithoutMergeCommits.nodes.author.username        | Select-Object -Unique | Sort-Object
        FirstCommittedAt  = $Mr.commitsWithoutMergeCommits.nodes.authoredDate           | Sort-Object | Select-Object -First 1
        ReviewRequestedAt = $Notes | Where-Object body -Match '^requested review from @' | Sort-Object updatedAt | Select-Object -First 1 -ExpandProperty updatedAt
        AssignedAt        = $Notes | Where-Object body -Match '^assigned to @' | Sort-Object updatedAt | Select-Object -First 1 -ExpandProperty updatedAt
        MarkedReadyAt     = $Notes | Where-Object body -Match '^marked this merge request as \*\*ready\*\*' | Sort-Object updatedAt | Select-Object -First 1 -ExpandProperty updatedAt
        ApprovedAt        = $Notes | Where-Object body -Match '^approved this merge request' |
                                Sort-Object updatedAt | Select-Object -First 1 -ExpandProperty updatedAt
        TimeToMerge       = '(computed below)'
    }

    $MergedAt = $MergeRequest.MergedAt
    if ($Summary.ReviewRequestedAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.ReviewRequestedAt; Measure='FromReviewRequested' }
    } elseif ($Summary.AssignedAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.AssignedAt; Measure='FromAssigned' }
    } elseif ($Summary.MarkedReadyAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.MarkedReadyAt; Measure='FromMarkedReady' }
    } else {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $MergeRequest.CreatedAt; Measure='FromCreated'}
    }
    $Summary
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

function Merge-GitlabMergeRequest {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $MergeCommitMessage,

        [Parameter(Mandatory=$false)]
        [string]
        $SquashCommitMessage,

        [Parameter(Mandatory=$false)]
        [bool]
        $Squash = $false,

        [Parameter(Mandatory=$false)]
        [bool]
        $ShouldRemoveSourceBranch = $true,

        [Parameter(Mandatory=$false)]
        [bool]
        $MergeWhenPipelineSucceeds = $false,

        [Parameter(Mandatory=$false)]
        [string]
        $Sha,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $MergeRequest = $(Invoke-GitlabApi PUT "projects/$($Project.Id)/merge_requests/$MergeRequestId/merge" @{
        merge_commit_message = $MergeCommitMessage
        squash_commit_message = $SquashCommitMessage
        squash = $Squash
        should_remove_source_branch = $ShouldRemoveSourceBranch
        merge_when_pipeline_succeeds = $MergeWhenPipelineSucceeds
        sha = $Sha
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf) | New-WrapperObject 'Gitlab.MergeRequest'

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

    Invoke-GitlabApi POST "projects/$ProjectId/merge_requests/$MergeRequestId/approve" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    Get-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -IncludeApprovals -SiteUrl $SiteUrl
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-configuration
function Get-GitlabMergeRequestApprovalConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    Invoke-GitlabApi GET "projects/$($Project.Id)/approvals" -SiteUrl $SiteUrl | New-WrapperObject
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#change-configuration
function Update-GitlabMergeRequestApprovalConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $DisableOverridingApproversPerMergeRequest,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $MergeRequestsAuthorApproval,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $MergeRequestsDisableCommittersApproval,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $RequirePasswordToApprove,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $ResetApprovalsOnPush,

        [Parameter()]
        [ValidateSet($null, $true, $false)]
        [object]
        $SelectiveCodeOwnerRemovals,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Request = @{}
    if ($DisableOverridingApproversPerMergeRequest -ne $null) {
        $Request.disable_overriding_approvers_per_merge_request = $DisableOverridingApproversPerMergeRequest.ToLower()
    }
    if ($MergeRequestsAuthorApproval -ne $null) {
        $Request.merge_requests_author_approval = $MergeRequestsAuthorApproval.ToLower()
    }
    if ($MergeRequestsDisableCommittersApproval -ne $null) {
        $Request.merge_requests_disable_committers_approval = $MergeRequestsDisableCommittersApproval.ToLower()
    }
    if ($RequirePasswordToApprove -ne $null) {
        $Request.require_password_to_approve = $RequirePasswordToApprove.ToLower()
    }
    if ($ResetApprovalsOnPush -ne $null) {
        $Request.reset_approvals_on_push = $ResetApprovalsOnPush.ToLower()
    }
    if ($SelectiveCodeOwnerRemovals -ne $null) {
        $Request.selective_code_owner_removals = $SelectiveCodeOwnerRemovals.ToLower()
    }

    if ($PSCmdlet.ShouldProcess($Project.PathWithNamespace, "update merge request approval settings to $($Request | ConvertTo-Json)")) {
        Invoke-GitlabApi POST "projects/$($Project.Id)/approvals" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject
    }
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-project-level-rules
# https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-a-single-project-level-rule
function Get-GitlabMergeRequestApprovalRule {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, ValueFromPipelineByPropertyName)]
        [string]
        $ApprovalRuleId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Resource = "projects/$($Project.Id)/approval_rules"
    if ($ApprovalRuleId) {
        $Resource += "/$ApprovalRuleId"
    }

    Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl
        | New-WrapperObject 'Gitlab.MergeRequestApprovalRule'
        | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $Project.Id -PassThru
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#create-project-level-rule
function New-GitlabMergeRequestApprovalRule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, Mandatory)]
        [string]
        $Name,

        [Parameter(Position=2, Mandatory)]
        [uint]
        $ApprovalsRequired,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Resource = "projects/$($Project.Id)/approval_rules"
    $Rule = @{
        name                              = $Name
        approvals_required                = $ApprovalsRequired
        applies_to_all_protected_branches = 'true'
    }

    if ($PSCmdlet.ShouldProcess($Project.PathWithNamespace, "create new merge request approval rule $($Rule | ConvertTo-Json)")) {
        Invoke-GitlabApi POST $Resource -Body $Rule -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.MergeRequestApprovalRule'
    }
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#delete-project-level-rule
function Remove-GitlabMergeRequestApprovalRule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $MergeRequestApprovalRuleId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    if ($PSCmdlet.ShouldProcess($Project.PathWithNamespace, "remove merge request approval rule '$MergeRequestApprovalRuleId'")) {
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/approval_rules/$MergeRequestApprovalRuleId" -SiteUrl $SiteUrl
    }
}
