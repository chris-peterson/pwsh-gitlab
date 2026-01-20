function Get-GitlabIssue {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [OutputType('Gitlab.Issue')]
    [Alias('issue')]
    [Alias('issues')]
    param(
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [Alias('Id')]
        [string]
        $IssueId,

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter()]
        [ValidateSet($null, 'opened', 'closed')]
        [string]
        $State = 'opened',

        [Parameter()]
        [string]
        $CreatedAfter,

        [Parameter()]
        [string]
        $CreatedBefore,

        [Parameter()]
        $AuthorUsername,

        [Parameter(Mandatory, ParameterSetName='Mine')]
        [switch]
        $Mine,

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

    # https://docs.gitlab.com/api/issues/#list-issues
    $Path = 'issues'
    $Query = @{}

    if ($Mine) {
        $AuthorUsername = (Get-GitlabUser -Me).Username
    }

    if ($AuthorUsername) {
        $Query.author_username = $AuthorUsername
    } else {
        if ($GroupId) {
            $GroupId = Resolve-GitlabGroupId $GroupId
            $Path = "groups/$GroupId/issues"
        }
        elseif ($ProjectId) {
            $ProjectId = Resolve-GitlabProjectId $ProjectId
            $Path = "projects/$ProjectId/issues"
        }
        if ($IssueId) {
            $Path += "/$IssueId"
        }
    }

    if ($Visibility) {
        $Query.visibility = $State
    }
    if ($State) {
        $Query.state = $State
    }
    if ($CreatedBefore) {
        $Query.created_before = $CreatedBefore
    }
    if ($CreatedAfter) {
        $Query.created_after = $CreatedAfter
    }

    Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages |
        New-GitlabObject 'Gitlab.Issue' |
        Sort-Object SortKey
}

function New-GitlabIssue {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Issue')]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory)]
        [string]
        $Title,

        [Parameter(Position=1)]
        [string]
        $Description,

        [Parameter()]
        [Alias('NoTodo')]
        [switch]
        $MarkTodoAsRead,

        [Parameter()]
        [string]
        $MilestoneId,

        [Parameter()]
        [switch]
        $Follow,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $Request = @{
        # https://docs.gitlab.com/ee/api/issues.html#new-issue
        Method = 'POST'
        Path   = "projects/$($Project.Id)/issues"
        Body   = @{
            title       = $Title
            description = $Description
            assignee_id = $(Get-GitlabUser -Me).Id
        }
    }
    if ($MilestoneId) {
        $Milestone = Get-GitlabMilestone -GroupId $Project.Group | Where-Object Iid -eq $MilestoneId
        $Request.Body.milestone_id = $Milestone.Id
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "Create new issue ($($Request | ConvertTo-Json))")) {
        $Issue = Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Issue'
        if ($MarkTodoAsRead) {
            $Todo = Get-GitlabTodo | Where-Object TargetUrl -eq $Issue.WebUrl
            Clear-GitlabTodo -TodoId $Todo.Id | Out-Null
        }
        if ($Follow) {
            Start-Process $Issue.WebUrl
        }
        $Issue
    }
}

function Update-GitlabIssue {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Issue')]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $IssueId,

        [Parameter(Mandatory=$false)]
        [string []]
        $AssigneeId,

        [Parameter(Mandatory=$false)]
        [switch]
        $Confidential,

        [Parameter(Mandatory=$false)]
        [string]
        $Description,

        [Parameter(Mandatory=$false)]
        [switch]
        $DiscussionLocked,

        [Parameter(Mandatory=$false)]
        [GitlabDate()][string]
        $DueDate,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet('issue', 'incident', 'test_case')]
        $IssueType,

        [Parameter(Mandatory=$false)]
        [string []]
        $Label,

        [Parameter(Mandatory=$false)]
        [switch]
        $LabelBehaviorAdd,

        [Parameter(Mandatory=$false)]
        [switch]
        $LabelBehaviorRemove,

        [Parameter(Mandatory=$false)]
        [string]
        $MilestoneId,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet('close', 'reopen')]
        $StateEvent,

        [Parameter(Mandatory=$false)]
        [string]
        $Title,

        [Parameter(Mandatory=$false)]
        [nullable[uint]]
        $Weight,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/issues.html#edit-issue
    $Request = @{
        Method   = 'PUT'
        Path     = "projects/$ProjectId/issues/$IssueId"
        Body     = @{}
    }

    if ($AssigneeId) {
        if ($AssigneeId -is [array]) {
            $Request.Body.assignee_ids = $AssigneeId -join ','
        } else {
            $Request.Body.assignee_id = $AssigneeId
        }
    }
    if ($Confidential.IsPresent) {
        $Request.Body.confidential = $Confidential.ToBool().ToString().ToLower()
    }
    if ($Description) {
        $Request.Body.description = $Description
    }
    if ($DiscussionLocked.IsPresent) {
        $Request.Body.discussion_locked = $DiscussionLocked.ToBool().ToString().ToLower()
    }
    if ($DueDate) {
        $Request.Body.due_date = $DueDate
    }
    if ($IssueType) {
        $Request.Body.issue_type = $IssueType
    }
    if ($Label) {
        $Labels = $Label -join ','
        if ($LabelBehaviorAdd) {
            $Request.Body.add_labels = $Labels
        } elseif ($LabelBehaviorRemove) {
            $Request.Body.remove_labels = $Labels
        } else {
            $Request.Body.labels = $Labels
        }
    }
    if ($MilestoneId) {
        $Milestone = Get-GitlabMilestone -GroupId $Project.Group | Where-Object Iid -eq $MilestoneId
        $Request.Body.milestone_id = $Milestone.Id
    }
    if ($StateEvent) {
        $Request.Body.state_event = $StateEvent
    }
    if ($Title) {
        $Request.Body.title = $Title
    }
    if ($Weight.HasValue) {
        $Request.Body.weight = $Weight.Value
    }

    $ProjectId = $Project.Id

    if ($PSCmdlet.ShouldProcess("issue #$IssueId", "update $($Request | ConvertTo-Json)")) {
        return Invoke-GitlabApi @Request|
            New-GitlabObject 'Gitlab.Issue'
    }
}

function Open-GitlabIssue {
    [Alias('Reopen-GitlabIssue')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Issue')]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $IssueId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("issue #$IssueId", "reopen")) {
        Update-GitlabIssue -ProjectId $ProjectId -IssueId $IssueId -StateEvent 'reopen'
    }
}

function Close-GitlabIssue {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Issue')]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $IssueId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("issue #$IssueId", "close")) {
        Update-GitlabIssue -ProjectId $ProjectId -IssueId $IssueId -StateEvent 'close'
    }
}
