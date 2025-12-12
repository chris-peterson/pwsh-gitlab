function Get-GitlabMergeRequest {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [Alias('mrs')]
    param(
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, ParameterSetName='ByProjectId')]
        [Alias("Id")]
        [string]
        $MergeRequestId,

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId')]
        [string]
        $GroupId,

        [Parameter(Position=0, Mandatory, ParameterSetName='ByUrl')]
        [string]
        $Url,

        [Parameter()]
        [ValidateSet('all', 'opened', 'closed', 'locked', 'merged')]
        [string]
        $State = 'all',

        [Parameter()]
        [string]
        [ValidateScript({Test-GitlabDate $_})]
        $CreatedAfter,

        [Parameter()]
        [string]
        [ValidateScript({Test-GitlabDate $_})]
        $CreatedBefore,

        [ValidateSet($null, 'true', 'false')]
        [object]
        $IsDraft,

        [Parameter()]
        [Alias('Branch')]
        [string]
        $SourceBranch,

        [Parameter()]
        [Alias('ChangeSummary')]
        [switch]
        $IncludeChangeSummary,

        [Parameter()]
        [Alias('Approvals')]
        [switch]
        $IncludeApprovals,

        [Parameter(ParameterSetName='ByAuthor')]
        [string]
        $AuthorUsername,

        [Parameter(ParameterSetName='Mine')]
        [switch]
        $Mine,

        [Parameter()]
        [ValidateSet('created_by_me', 'assigned_to_me', 'reviews_for_me')]
        [string]
        $Scope = 'created_by_me',

        [Parameter()]
        [uint]
        $MaxPages,
    
        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    # https://docs.gitlab.com/api/merge_requests/#list-merge-requests
    $Path = 'merge_requests'
    $Query = @{
        state = $State
        scope = $Scope
    }

    switch ($PSCmdlet.ParameterSetName) {
        'Mine' {
        }
        'ByAuthor' {
            $Query.author_username = $Author
        }
        'ByUrl' {
            $Resource = $Url | Get-GitlabResourceFromUrl
            $ProjectId = $Resource.ProjectId
            $MergeRequestId = $Resource.ResourceId
        }
        'ByProjectId' {
            $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
            # https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests
            $Path = "projects/$ProjectId/merge_requests"
            if ($MergeRequestId) {
                $Path += "/$MergeRequestId"
            }
        }
        'ByGroupId' {
            $GroupId = $(Get-GitlabGroup -GroupId $GroupId).Id
            # https://docs.gitlab.com/ee/api/merge_requests.html#list-group-merge-requests
            $Path = "groups/$GroupId/merge_requests"
        }
    }

    if ($CreatedBefore) {
        $Query.created_before = $CreatedBefore
    }
    if ($CreatedAfter) {
        $Query.created_after = $CreatedAfter
    }
    if ($IsDraft) {
        $Query.wip = $IsDraft -eq 'true' ? 'yes' : 'no'
    }
    if ($SourceBranch) {
        if ($SourceBranch -eq '.') {
            $SourceBranch = Get-LocalGitContext | Select-Object -ExpandProperty Branch
        }
        $Query.source_branch = $SourceBranch
    }
    if ($AuthorUsername) {
        $Query.author_username = $AuthorUsername
    }

    $MergeRequests = Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages -SiteUrl $SiteUrl |
        Select-Object -ExcludeProperty approvals_before_merge | # https://docs.gitlab.com/ee/api/merge_requests.html#removals-in-api-v5
        New-WrapperObject 'Gitlab.MergeRequest'

    if ($IncludeChangeSummary) {
        $MergeRequests | ForEach-Object {
            $_ | Add-GitlabMergeRequestChangeSummary
        }
    }

    if ($IncludeApprovals) {
        $MergeRequests | ForEach-Object {
            $_ | Add-GitlabMergeRequestApprovals
        }
    }

    $MergeRequests | Sort-Object ProjectPath
}

function Add-GitlabMergeRequestApprovals {
    param(
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
        $MergeRequest
    )

    $Approval = Invoke-GitlabApi GET "projects/$($MergeRequest.SourceProjectId)/merge_requests/$($MergeRequest.MergeRequestId)/approvals"

    $MergeRequest | Add-Member -NotePropertyMembers @{
        ApprovalsRequired = $Approval.approvals_required
        ApprovalsLeft     = $Approval.approvals_left
        ApprovedBy        = $Approval.approved_by.user.name
    }
}

function Add-GitlabMergeRequestChangeSummary {
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
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
                      id
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
    $Notes = $Mr.notes.nodes | Sort-Object -Descending updatedAt

    $SpecialNotes = @{
        SelfAssigned         = @{ Regex="^assigned to @$($MergeRequest.Author.username)"; Notes=@() }
        Assigned             = @{ Regex='^assigned to @'; Notes=@() }
        DescriptionChanges   = @{ Regex='^changed the description'; Notes=@() }
        TitleChanges         = @{ Regex='^<div>changed title from'; Notes=@() }
        MarkedDraft          = @{ Regex='^marked this merge request as \*\*draft\*\*'; Notes=@() }
        MarkedReady          = @{ Regex='^marked this merge request as \*\*ready\*\*'; Notes=@() }
        ReviewRequested      = @{ Regex='^requested review from @'; Notes=@() }
        Approved             = @{ Regex='^approved this merge request'; Notes=@() }
        Commits              = @{ Regex='^added \d+ commit'; Notes=@() }
        MentionCommits       = @{ Regex="^mentioned in commit"; Notes=@() }
        MentionMergeRequests = @{ Regex="^mentioned in merge request"; Notes=@() }
        Edits                = @{ Regex="^changed this line in \[version"; Notes=@() }
        PostMergeCommits     = @{ Regex="^deleted the `.*` branch."; Notes=@() }
    }
    $SpecialNoteIds = @()
    foreach ($Key in $SpecialNotes.Keys) {
        $Special = $Notes | Where-Object body -Match $SpecialNotes[$Key].Regex
        if ($Special) {
            $SpecialNotes[$Key].Notes = $Special
            $SpecialNoteIds += $Special.id
        }
    }
    $RegularComments = $Notes | Where-Object {
        $SpecialNoteIds -notcontains $_.id
    }
    $SelfComments     = $RegularComments | Where-Object { $_.author.username -eq $MergeRequest.Author.username }
    $ReviewerComments = $RegularComments | Where-Object { $_.author.username -ne $MergeRequest.Author.username }

    $Summary = [PSCustomObject]@{
        Changes                 = $Mr.diffStatsSummary | New-WrapperObject
        Authors                 = $Mr.commitsWithoutMergeCommits.nodes.author.username | Select-Object -Unique | Sort-Object
        FirstCommittedAt        = @($Mr.commitsWithoutMergeCommits.nodes.authoredDate) + @($SpecialNotes.Commits.Notes.updatedAt) | Sort-Object | Select-Object -First 1
        ReviewRequestedAt       = $SpecialNotes.ReviewRequested.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        AssignedAt              = $SpecialNotes.SelfAssigned.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        MarkedReadyAt           = $SpecialNotes.MarkedReady.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        ApprovedAt              = $SpecialNotes.Approved.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        FirstNonAuthorCommentAt = $ReviewerComments | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        TimeToMerge             = '(computed below)'
    }
    if ($DebugPreference -eq 'Continue') {
        $Summary | Add-Member -NotePropertyMembers @{
            Commits         = $Mr.commitsWithoutMergeCommits.nodes
            SpecialNotes     = $SpecialNotes
            ReviewerComments = $ReviewerComments
            SelfComments     = $SelfComments
        }
    }

    $MergedAt = $MergeRequest.MergedAt
    if ($Summary.ReviewRequestedAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.ReviewRequestedAt; Measure='FromReviewRequested' }
    } elseif ($Summary.AssignedAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.AssignedAt; Measure='FromAssigned' }
    } else {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $MergeRequest.CreatedAt; Measure='FromCreated'}
    }

    $MergeRequest | Add-Member -NotePropertyMembers @{
        ChangeSummary = $Summary
    }
}

function New-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1)]
        [string]
        $SourceBranch,

        [Parameter(Position=2)]
        [string]
        $TargetBranch,

        [Parameter(Position=3)]
        [string]
        $Title,

        [Parameter()]
        [string]
        $MilestoneId,

        [Parameter()]
        [Alias('NoTodo')]
        [switch]
        $MarkTodoAsRead,

        [Parameter()]
        [switch]
        $Follow,

        [Parameter()]
        [string]
        $SiteUrl
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

    $Body = @{
        source_branch        = $SourceBranch
        target_branch        = $TargetBranch
        remove_source_branch = 'true'
        assignee_id          = $Me.Id
        title                = $Title
    }
    if ($MilestoneId) {
        $Body.milestone_id = $MilestoneId
    }

    $Request = @{
        Method = 'POST'
        # https://docs.gitlab.com/ee/api/merge_requests.html#create-mr
        Path = "projects/$($Project.Id)/merge_requests"
        Body = $Body
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "create merge request ($($Body | ConvertTo-Json))")) {
        $MergeRequest = Invoke-GitlabApi @Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.MergeRequest'
        if ($MarkTodoAsRead) {
            $Todo = Get-GitlabTodo -SiteUrl $SiteUrl | Where-Object TargetUrl -eq $MergeRequest.WebUrl
            Clear-GitlabTodo -TodoId $Todo.Id -SiteUrl $SiteUrl | Out-Null
        }
        if ($Follow) {
            Start-Process $MergeRequest.WebUrl
        }
        $MergeRequest
    }
}

function Merge-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]
        $MergeRequestId,

        [Parameter()]
        [string]
        $MergeCommitMessage,

        [Parameter()]
        [string]
        $SquashCommitMessage,

        [Parameter()]
        [string]
        $ConfirmSha,

        [Parameter()]
        [switch]
        $Squash,

        [Parameter()]
        [switch]
        $KeepSourceBranch,

        [Parameter()]
        [switch]
        $MergeWhenPipelineSucceeds,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/merge_requests.html#merge-a-merge-request
    $Request = @{
        Method = 'PUT'
        Path   = "projects/$($Project.Id)/merge_requests/$MergeRequestId/merge"
        Body   = @{}
    }
    if ($MergeCommitMessage) {
        $Request.Body.merge_commit_message = $MergeCommitMessage
    }
    if ($SquashCommitMessage) {
        $Request.Body.squash_commit_message = $SquashCommitMessage
    }
    if ($ConfirmSha) {
        $Request.Body.sha = $Sha
    }
    if ($Squash) {
        $Request.Body.squash = $Squash
    }
    if (-not $KeepSourceBranch) {
        $Request.Body.should_remove_source_branch = 'true'
    }
    if ($MergeWhenPipelineSucceeds) {
        $Request.Body.merge_when_pipeline_succeeds = $MergeWhenPipelineSucceeds
    }
    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "merge ($($Request.Body | ConvertTo-Json))")) {
        Invoke-GitlabApi @Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.MergeRequest'
    }
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
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $MergeRequestId,

        [Parameter()]
        [string]
        $Title,

        [Parameter()]
        [Alias('Wip')]
        [switch]
        $Draft,

        [Parameter()]
        [Alias('RemoveDraft')]
        [Alias('RemoveWip')]
        [switch]
        $MarkReady,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [string []]
        $AssignTo,

        [Parameter()]
        [switch]
        $Unassign,

        [Parameter()]
        [string []]
        $Reviewers,

        [Parameter()]
        [switch]
        $UnsetReviewers,

        [Parameter()]
        [switch]
        $Close,

        [Parameter()]
        [switch]
        $Reopen,

        [Parameter()]
        [string]
        $MilestoneId,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $Project = Get-GitlabProject -ProjectId $ProjectId
    $Request = @{}

    if ($Reopen) {
        $Request.state_event = 'reopen'
    }
    elseif ($Close) {
        $Request.state_event = 'close'
    }
    if ($Title) {
        $Request.title = $Title
    } else {
        $MergeRequest = Get-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId
        if ($Draft -and -not $MergeRequest.Draft) {
            $Request.title = "Draft: $($MergeRequest.Title)"
        } elseif ($MarkReady -and $MergeRequest.Draft) {
            $Request.title = $MergeRequest.Title -replace '^Draft:\s+', ''
        }
    }
    if ($Description) {
        $Request.description = $Description
    }
    if ($AssignTo) {
        $Request.assignee_ids = @($AssignTo | ForEach-Object {
            Get-GitlabUser $_
        } | Select-Object -ExpandProperty Id)
    } elseif ($Unassign) {
        $Request.assignee_ids = @()
    }
    if ($Reviewers) {
        $Request.reviewer_ids = @($Reviewers | ForEach-Object {
            Get-GitlabUser $_
        } | Select-Object -ExpandProperty Id)
    } elseif ($UnsetReviewers) {
        $Request.reviewer_ids = @()
    }
    if ($MilestoneId) {
        $Request.milestone_id = $MilestoneId
    }

    if ($PSCmdlet.ShouldProcess("MR $MergeRequestId in $($Project.PathWithNamespace)", "update $($Request | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/merge_requests.html#update-mr
        Invoke-GitlabApi PUT "projects/$ProjectId/merge_requests/$MergeRequestId" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.MergeRequest'
    }
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
        [ValidateSet($null, 'true', 'false')]
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

    # https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-project-level-rules
    # https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-a-single-project-level-rule
    Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl
        | New-WrapperObject 'Gitlab.MergeRequestApprovalRule'
        | Add-Member -PassThru -NotePropertyMembers @{
            ProjectId = $Project.Id
        }
}

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
        # https://docs.gitlab.com/ee/api/merge_request_approvals.html#create-project-level-rule
        Invoke-GitlabApi POST $Resource -Body $Rule -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.MergeRequestApprovalRule'
    }
}

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
        # https://docs.gitlab.com/ee/api/merge_request_approvals.html#delete-project-level-rule
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/approval_rules/$MergeRequestApprovalRuleId" -SiteUrl $SiteUrl
    }
}
