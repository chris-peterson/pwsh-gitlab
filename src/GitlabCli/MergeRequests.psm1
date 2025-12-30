function Get-GitlabMergeRequest {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [OutputType('Gitlab.MergeRequest')]
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

        [TrueOrFalse()][bool]
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
        [Alias('Diffs')]
        [switch]
        $IncludeDiffs,

        [Parameter()]
        [Alias('Approvals')]
        [switch]
        $IncludeApprovals,

        [Parameter(ParameterSetName='ByUser')]
        [string]
        $Username,

        [Parameter(ParameterSetName='ByUser')]
        [string]
        [ValidateSet('author', 'reviewer')]
        $Role = 'author',

        [Parameter(ParameterSetName='Mine')]
        [switch]
        $Mine,

        [Parameter()]
        [ValidateSet('created_by_me', 'assigned_to_me', 'reviews_for_me', 'all')]
        [string]
        $Scope = 'all',

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

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    # https://docs.gitlab.com/api/merge_requests/#list-merge-requests
    $Path = 'merge_requests'
    $Query = @{
        state = $State
        scope = $Scope
    }

    switch ($PSCmdlet.ParameterSetName) {
        'Mine' {
            # while we could use 'merge_requests?scope=created_by_me', that limits our ability to broaden scope
            $Query.author_username = Get-GitlabCurrentUser | Select-Object -ExpandProperty Username
        }
        'ByUser' {
            if ($Role -eq 'author') {
                $Query.author_username = $Username
            }
            elseif ($Role -eq 'reviewer') {
                $Query.reviewer_username = $Username
            }
        }
        'ByUrl' {
            $Resource = $Url | Get-GitlabResourceFromUrl
            $ProjectId = $Resource.ProjectId
            $MergeRequestId = $Resource.ResourceId
        }
        'ByProjectId' {
            $ProjectId = Resolve-GitlabProjectId $ProjectId
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
    if ($PSBoundParameters.ContainsKey('IsDraft')) {
        $Query.wip = $IsDraft ? 'yes' : 'no'
    }
    if ($SourceBranch) {
        if ($SourceBranch -eq '.') {
            $SourceBranch = Get-LocalGitContext | Select-Object -ExpandProperty Branch
        }
        $Query.source_branch = $SourceBranch
    }

    $MergeRequests = Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages |
        Select-Object -ExcludeProperty approvals_before_merge | # https://docs.gitlab.com/ee/api/merge_requests.html#removals-in-api-v5
        New-GitlabObject 'Gitlab.MergeRequest'

    if ($IncludeChangeSummary -or $IncludeDiffs) {
        $MergeRequests | ForEach-Object {
            $_ | Add-GitlabMergeRequestChangeSummary -IncludeDiffs:$IncludeDiffs
        }
    }

    if ($IncludeApprovals) {
        $MergeRequests | ForEach-Object {
            $_ | Add-GitlabMergeRequestApprovals
        }
    }

    $MergeRequests | Sort-Object ProjectPath
}

function New-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.MergeRequest')]
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
        $MergeRequest = Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.MergeRequest'
        if ($MarkTodoAsRead) {
            $Todo = Get-GitlabTodo | Where-Object TargetUrl -eq $MergeRequest.WebUrl
            Clear-GitlabTodo -TodoId $Todo.Id | Out-Null
        }
        if ($Follow) {
            Start-Process $MergeRequest.WebUrl
        }
        $MergeRequest
    }
}

function Merge-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.MergeRequest')]
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

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/merge_requests.html#merge-a-merge-request
    $Request = @{
        Method = 'PUT'
        Path   = "projects/$ProjectId/merge_requests/$MergeRequestId/merge"
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
    if ($PSCmdlet.ShouldProcess("project $ProjectId", "merge ($($Request.Body | ConvertTo-Json))")) {
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.MergeRequest'
    }
}

function Set-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    [OutputType('Gitlab.MergeRequest')]
    [Alias("mr")]

    param (
        # intentionally omit SiteUrl as this is meant to be used in a localized git context
        # [Parameter()]
        # [string]
        # $SiteUrl
    )

    $ProjectId = '.'
    $Branch = '.'

    $Existing = Get-GitlabMergeRequest -ProjectId $ProjectId -Branch $Branch -State 'opened'
    if ($Existing) {
        return $Existing
    }
    if ($PSCmdlet.ShouldProcess("MR in $ProjectId for branch $Branch", "create")) {
        New-GitlabMergeRequest -ProjectId $ProjectId -SourceBranch $Branch
    }
}

function Update-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.MergeRequest')]
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
    $ProjectId = Resolve-GitlabProjectId $ProjectId
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

    if ($PSCmdlet.ShouldProcess("MR $MergeRequestId in project $ProjectId", "update $($Request | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/merge_requests.html#update-mr
        Invoke-GitlabApi PUT "projects/$ProjectId/merge_requests/$MergeRequestId" -Body $Request | New-GitlabObject 'Gitlab.MergeRequest'
    }
}

function Close-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.MergeRequest')]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("MR #$MergeRequestId", "close")) {
        Update-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -Close
    }
}

function Invoke-GitlabMergeRequestReview {
    [CmdletBinding()]
    [OutputType([void])]
    [Alias('Review-GitlabMergeRequest')]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId '.'

    $MergeRequest = Get-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId

    git stash | Out-Null
    git pull -p | Out-Null
    git checkout $MergeRequest.SourceBranch
    git diff "origin/$($MergeRequest.TargetBranch)"
}

function Approve-GitlabMergeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.MergeRequest')]
    param(
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId '.'

    if (-not $MergeRequestId) {
        $MergeRequest = Get-GitlabMergeRequest -ProjectId $ProjectId -Branch '.' -State 'opened'
        if ($MergeRequest) {
            $MergeRequestId = $MergeRequest.MergeRequestId
        }
    }

    if ($PSCmdlet.ShouldProcess("MR #$MergeRequestId", "approve")) {
        Invoke-GitlabApi POST "projects/$ProjectId/merge_requests/$MergeRequestId/approve" | Out-Null
        Get-GitlabMergeRequest -ProjectId $ProjectId -MergeRequestId $MergeRequestId -IncludeApprovals
    }
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-configuration
function Get-GitlabMergeRequestApprovalConfiguration {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    Invoke-GitlabApi GET "projects/$ProjectId/approvals" | New-GitlabObject
}

# https://docs.gitlab.com/ee/api/merge_request_approvals.html#change-configuration
function Update-GitlabMergeRequestApprovalConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [TrueOrFalse()][bool]
        $DisableOverridingApproversPerMergeRequest,

        [Parameter()]
        [TrueOrFalse()][bool]
        $MergeRequestsAuthorApproval,

        [Parameter()]
        [TrueOrFalse()][bool]
        $MergeRequestsDisableCommittersApproval,

        [Parameter()]
        [TrueOrFalse()][bool]
        $RequirePasswordToApprove,

        [Parameter()]
        [TrueOrFalse()][bool]
        $ResetApprovalsOnPush,

        [Parameter()]
        [TrueOrFalse()][bool]
        $SelectiveCodeOwnerRemovals,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Request = @{}
    if ($PSBoundParameters.ContainsKey('DisableOverridingApproversPerMergeRequest')) {
        $Request.disable_overriding_approvers_per_merge_request = $DisableOverridingApproversPerMergeRequest
    }
    if ($PSBoundParameters.ContainsKey('MergeRequestsAuthorApproval')) {
        $Request.merge_requests_author_approval = $MergeRequestsAuthorApproval
    }
    if ($PSBoundParameters.ContainsKey('MergeRequestsDisableCommittersApproval')) {
        $Request.merge_requests_disable_committers_approval = $MergeRequestsDisableCommittersApproval
    }
    if ($PSBoundParameters.ContainsKey('RequirePasswordToApprove')) {
        $Request.require_password_to_approve = $RequirePasswordToApprove
    }
    if ($PSBoundParameters.ContainsKey('ResetApprovalsOnPush')) {
        $Request.reset_approvals_on_push = $ResetApprovalsOnPush
    }
    if ($PSBoundParameters.ContainsKey('SelectiveCodeOwnerRemovals')) {
        $Request.selective_code_owner_removals = $SelectiveCodeOwnerRemovals
    }

    if ($PSCmdlet.ShouldProcess($Project.PathWithNamespace, "update merge request approval settings to $($Request | ConvertTo-Json)")) {
        Invoke-GitlabApi POST "projects/$($Project.Id)/approvals" -Body $Request | New-GitlabObject
    }
}

function Get-GitlabMergeRequestApprovalRule {
    [CmdletBinding()]
    [OutputType('Gitlab.MergeRequestApprovalRule')]
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

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Resource = "projects/$ProjectId/approval_rules"
    if ($ApprovalRuleId) {
        $Resource += "/$ApprovalRuleId"
    }

    # https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-project-level-rules
    # https://docs.gitlab.com/ee/api/merge_request_approvals.html#get-a-single-project-level-rule
    Invoke-GitlabApi GET $Resource
        | New-GitlabObject 'Gitlab.MergeRequestApprovalRule'
        | Add-Member -PassThru -NotePropertyMembers @{
            ProjectId = $ProjectId
        }
}

function New-GitlabMergeRequestApprovalRule {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.MergeRequestApprovalRule')]
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
        Invoke-GitlabApi POST $Resource -Body $Rule | New-GitlabObject 'Gitlab.MergeRequestApprovalRule'
    }
}

function Remove-GitlabMergeRequestApprovalRule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
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
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/approval_rules/$MergeRequestApprovalRuleId"
    }
}
