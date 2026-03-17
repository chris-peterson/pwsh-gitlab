function Get-GitlabMilestone {
    [CmdletBinding(DefaultParameterSetName = 'ByGroup')]
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

        [Parameter(ParameterSetName = 'ByGroup', Position = 0)]
        [Parameter(ParameterSetName = 'ByProject', Position = 0)]
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
                iid,
                group {
                    id
                }
                project {
                    id
                }
            }
        }
"@
        if ($Data.Milestone.group.id) {
            $GroupId = $Data.Milestone.group.id -split '/' | Select-Object -Last 1
        }
        elseif ($Data.Milestone.project.id) {
            $ProjectId = $Data.Milestone.project.id -split '/' | Select-Object -Last 1
        }
        $MilestoneId = $Data.Milestone.iid
    }

    $Resource = ''
    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        # https://docs.gitlab.com/api/group_milestones/#list-group-milestones
        $Resource = "groups/$GroupId/milestones"
    } elseif ($ProjectId) {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        # https://docs.gitlab.com/api/milestones/#list-all-project-milestones
        $Resource = "projects/$ProjectId/milestones"
    }
    if ($MilestoneId) {
        $Resource += "?iids[]=$MilestoneId"
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

# https://docs.gitlab.com/ee/api/milestones.html#create-new-milestone
function New-GitlabMilestone {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Milestone')]
    param (
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByGroup')]
        [string]
        $GroupId,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByProject')]
        [string]
        $ProjectId,

        [Parameter(Mandatory, Position=0)]
        [string]
        $Title,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [GitlabDate()][string]
        $DueDate,

        [Parameter()]
        [GitlabDate()][string]
        $StartDate,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/milestones"
        $Target = "group $GroupId"
    } elseif ($ProjectId) {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/milestones"
        $Target = "project $ProjectId"
    } else {
        throw 'Either -GroupId or -ProjectId is required'
    }

    $Body = @{
        title = $Title
    }
    if ($Description) {
        $Body.description = $Description
    }
    if ($DueDate) {
        $Body.due_date = $DueDate
    }
    if ($StartDate) {
        $Body.start_date = $StartDate
    }

    if ($PSCmdlet.ShouldProcess($Target, "create milestone '$Title'")) {
        Invoke-GitlabApi POST $Path -Body $Body | New-GitlabObject 'Gitlab.Milestone'
    }
}

# https://docs.gitlab.com/ee/api/milestones.html#edit-milestone
function Update-GitlabMilestone {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Milestone')]
    param (
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByGroup')]
        [string]
        $GroupId,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByProject')]
        [string]
        $ProjectId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $MilestoneId,

        [Parameter()]
        [string]
        $Title,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [GitlabDate()][string]
        $DueDate,

        [Parameter()]
        [GitlabDate()][string]
        $StartDate,

        [Parameter()]
        [ValidateSet('close', 'activate')]
        [string]
        $StateEvent,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/milestones/$MilestoneId"
        $Target = "group $GroupId"
    } elseif ($ProjectId) {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/milestones/$MilestoneId"
        $Target = "project $ProjectId"
    } else {
        throw 'Either -GroupId or -ProjectId is required'
    }

    $Body = @{}
    if ($Title) {
        $Body.title = $Title
    }
    if ($PSBoundParameters.ContainsKey('Description')) {
        $Body.description = $Description
    }
    if ($DueDate) {
        $Body.due_date = $DueDate
    }
    if ($StartDate) {
        $Body.start_date = $StartDate
    }
    if ($StateEvent) {
        $Body.state_event = $StateEvent
    }

    if ($Body.Count -eq 0) {
        Write-Warning 'No properties to update'
        return
    }

    if ($PSCmdlet.ShouldProcess($Target, "update milestone $MilestoneId")) {
        Invoke-GitlabApi PUT $Path -Body $Body | New-GitlabObject 'Gitlab.Milestone'
    }
}

# https://docs.gitlab.com/ee/api/milestones.html#delete-project-milestone
function Remove-GitlabMilestone {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByGroup')]
        [string]
        $GroupId,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByProject')]
        [string]
        $ProjectId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $MilestoneId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/milestones/$MilestoneId"
        $Target = "group $GroupId"
    } elseif ($ProjectId) {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/milestones/$MilestoneId"
        $Target = "project $ProjectId"
    } else {
        throw 'Either -GroupId or -ProjectId is required'
    }

    if ($PSCmdlet.ShouldProcess($Target, "delete milestone $MilestoneId")) {
        Invoke-GitlabApi DELETE $Path | Out-Null
    }
}
