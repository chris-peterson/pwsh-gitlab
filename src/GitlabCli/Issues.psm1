function Get-GitlabIssue {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [Alias('issue')]
    [Alias('issues')]
    param(
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ByProjectId')]
        [string]
        $IssueId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [Parameter(Mandatory=$false, ParameterSetName='Mine')]
        [ValidateSet($null, 'opened', 'closed')]
        [string]
        $State = 'opened',

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [Parameter(Mandatory=$false, ParameterSetName='Mine')]
        [string]
        $CreatedAfter,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [Parameter(Mandatory=$false, ParameterSetName='Mine')]
        [string]
        $CreatedBefore,

        [Parameter(Mandatory=$true, ParameterSetName='Mine')]
        [switch]
        $Mine,


        [Parameter(Mandatory=$false)]
        [uint]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

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
            $MaxPages = 10
        } else {
            $Path = "projects/$ProjectId/issues"
            $MaxPages = 10
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

    Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Issue' |
        Sort-Object SortKey
}

# https://docs.gitlab.com/ee/api/issues.html#new-issue
function New-GitlabIssue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $Title,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $Description,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    Invoke-GitlabApi POST "projects/$ProjectId/issues" -Body @{
        title = $Title
        description = $Description
        assignee_id = $(Get-GitlabUser -Me).Id
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Issue'
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
        [ValidateScript({ValidateGitlabDateFormat $_})]
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

    Update-GitlabIssue -ProjectId $ProjectId $IssueId -StateEvent 'close' -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
