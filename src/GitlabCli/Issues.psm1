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
        [ValidateSet('opened', 'closed')]
        [string]
        $State,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [string]
        $CreatedAfter,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroupId')]
        [Parameter(Mandatory=$false, ParameterSetName='ByProjectId')]
        [string]
        $CreatedBefore,

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
        New-WrapperObject 'Gitlab.Issue'
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

function Close-GitlabIssue {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $IssueId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    return Invoke-GitlabApi PUT "projects/$ProjectId/issues/$IssueId" @{
        state_event = 'close'
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Issue'
}