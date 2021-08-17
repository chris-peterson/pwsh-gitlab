function Get-GitlabIssues {
    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    [Alias("issues")]
    param(
        [Parameter(Position=0, Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $IssueId,

        [Parameter(Position=0, Mandatory=$true,ParameterSetName="ByGroupId")]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false, ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [ValidateSet("opened", "closed")]
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

        [Parameter(Mandatory=$false)]
        [switch]
        $Mine,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    if ($ProjectId) {
        $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
    }

    if ($GroupId) {
        $GroupId = $(Get-GitlabGroup -GroupId $GroupId).Id
    }

    $Path = $null
    $MaxPages = 1
    $Query = @{}

    if ($Mine) {
        $Path = 'issues'
    } elseif ($IssueId) {
        $Path = "projects/$ProjectId/issues/$IssueId"
    } elseif ($ProjectId) {
        $Path = "projects/$ProjectId/issues"
        $MaxPages = 10
    } elseif ($GroupId) {
        $Path = "groups/$GroupId/issues"
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

    return Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages -WhatIf:$WhatIf |
        ForEach-Object {
            $_ | New-WrapperObject -DisplayType 'Gitlab.Issue'
        }
}