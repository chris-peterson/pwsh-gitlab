function Get-GitlabMilestone {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByGroup')]
    [OutputType('Gitlab.Milestone')]
    param (

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ByGroup')]
        [string]
        $GroupId,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ByProject')]
        [string]
        $ProjectId,

        [Parameter()]
        [ValidateSet('active', 'closed')]
        [string]
        $State,

        [Parameter(ParameterSetName = 'ByGroup')]
        [Parameter(ParameterSetName = 'ByProject')]
        [Alias('Id')]
        [string]
        $MilestoneId,
        
        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($MilestoneId) {
        $Data = Invoke-GitlabGraphQL -Query @"
        {
            milestone(id: "gid://gitlab/Milestone/$MilestoneId") {
                groupMilestone,
                group {
                id
                }
                projectMilestone,
                project {
                id
                }
            }
        }
"@
        if ($Data.Milestone.groupMilestone) {
            $GroupId = $Data.Milestone.group.id -split '/' | Select-Object -Last 1
        }
        elseif ($Data.Milestone.projectMilestone) {
            $ProjectId = $Data.Milestone.project.id -split '/' | Select-Object -Last 1
        }

    }

    $Resource = ''
    if ($GroupId) {
         $Resource = "groups/$GroupId/milestones"
    } elseif ($ProjectId) {
         $Resource = "projects/$ProjectId/milestones"
    }

    $Request = @{
        HttpMethod = 'GET'
        Path       = $Resource
    }
    if ($State) {
        $Request.Query = @{ state = $State }
    }

    Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Milestone'
}
