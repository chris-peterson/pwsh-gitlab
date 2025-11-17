function Get-GitlabIssue {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [Alias('issue')]
    [Alias('issues')]
    param(
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, ParameterSetName='ByProjectId')]
        [string]
        $IssueId,

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(ParameterSetName='ByGroupId')]
        [Parameter(ParameterSetName='ByProjectId')]
        [Parameter(ParameterSetName='Mine')]
        [ValidateSet($null, 'opened', 'closed')]
        [string]
        $State = 'opened',

        [Parameter(ParameterSetName='ByGroupId')]
        [Parameter(ParameterSetName='ByProjectId')]
        [Parameter(ParameterSetName='Mine')]
        [string]
        $CreatedAfter,

        [Parameter(ParameterSetName='ByGroupId')]
        [Parameter(ParameterSetName='ByProjectId')]
        [Parameter(ParameterSetName='Mine')]
        [string]
        $CreatedBefore,

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

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $Path = $null
    $Query = @{}

    if ($Mine) {
        $Path = 'issues'
    } else {
        if ($ProjectId) {
            $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
        }
        if ($GroupId) {
            $GroupId = $(Get-GitlabGroup -GroupId $GroupId).Id
        }
        if ($IssueId) {
            $Path = "projects/$ProjectId/issues/$IssueId"
        } elseif ($GroupId) {
            $Path = "groups/$GroupId/issues"
        } else {
            $Path = "projects/$ProjectId/issues"
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

    Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages -SiteUrl $SiteUrl |
        New-WrapperObject 'Gitlab.Issue' |
        Sort-Object SortKey
}

function New-GitlabIssue {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
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
        [switch]
        $Follow,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $Request = @{
        title = $Title
        description = $Description
        assignee_id = $(Get-GitlabUser -Me).Id
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "Create new issue ($($Request | ConvertTo-Json))")) {
        # https://docs.gitlab.com/ee/api/issues.html#new-issue
        $Issue = Invoke-GitlabApi POST "projects/$($Project.Id)/issues" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Issue'
        if ($MarkTodoAsRead) {
            $Todo = Get-GitlabTodo -SiteUrl $SiteUrl | Where-Object TargetUrl -eq $Issue.WebUrl
            Clear-GitlabTodo -TodoId $Todo.Id -SiteUrl $SiteUrl | Out-Null
        }
        if ($Follow) {
            Start-Process $Issue.WebUrl
        }
        $Issue
    }
}

# https://docs.gitlab.com/ee/api/issues.html#edit-issue
function Update-GitlabIssue {
    [CmdletBinding()]
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
        [string]
        [ValidateScript({Test-GitlabDate $_})]
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
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Body = @{}

    if ($AssigneeId) {
        if ($AssigneeId -is [array]) {
            $Body.assignee_ids = $AssigneeId -join ','
        } else {
            $Body.assignee_id = $AssigneeId
        }
    }
    if ($Confidential.IsPresent) {
        $Body.confidential = $Confidential.ToBool().ToString().ToLower()
    }
    if ($Description) {
        $Body.description = $Description
    }
    if ($DiscussionLocked.IsPresent) {
        $Body.discussion_locked = $DiscussionLocked.ToBool().ToString().ToLower()
    }
    if ($DueDate) {
        $Body.due_date = $DueDate
    }
    if ($IssueType) {
        $Body.issue_type = $IssueType
    }
    if ($Label) {
        $Labels = $Label -join ','
        if ($LabelBehaviorAdd) {
            $Body.add_labels = $Labels
        } elseif ($LabelBehaviorRemove) {
            $Body.remove_labels = $Labels
        } else {
            $Body.labels = $Labels
        }
    }
    if ($MilestoneId) {
        $Body.milestone_id = $MilestoneId
    }
    if ($StateEvent) {
        $Body.state_event = $StateEvent
    }
    if ($Title) {
        $Body.title = $Title
    }
    if ($Weight.HasValue) {
        $Body.weight = $Weight.Value
    }

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    return Invoke-GitlabApi PUT "projects/$ProjectId/issues/$IssueId" -Body $Body -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Issue'
}

function Open-GitlabIssue {
    [Alias('Reopen-GitlabIssue')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $IssueId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Update-GitlabIssue -ProjectId $ProjectId $IssueId -StateEvent 'reopen' -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

function Close-GitlabIssue {
    [CmdletBinding(SupportsShouldProcess)]
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
        Update-GitlabIssue -ProjectId $ProjectId -IssueId $IssueId -StateEvent 'close' -SiteUrl $SiteUrl
    }
}
