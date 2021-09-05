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

        [Parameter(Position=0, Mandatory=$true, ParameterSetName="ByGroupId")]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false, ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [ValidateSet("opened", "closed")]
        [string]
        $State,

        [Parameter(Mandatory=$false, ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $CreatedAfter,

        [Parameter(Mandatory=$false, ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $CreatedBefore,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName="Mine")]
        [switch]
        $Mine,

        [Parameter(Mandatory=$false)]
        [switch]
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
            if (-not $ProjectId) {
                $ProjectId = $(Get-GitlabProject -ProjectId '.').Id
            }
            $Path = "projects/$ProjectId/issues"
            $MaxPages = 10
        }
    }

    if ($State) {
        $Query['state'] = $State
    }

    if ($CreatedBefore) {
        $Query['created_before'] = $CreatedBefore
    }

    if ($CreatedAfter) {
        $Query['created_after'] = $CreatedAfter
    }

    return Invoke-GitlabApi GET $Path $Query -MaxPages $MaxPages -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Issue'
        
}