# https://docs.gitlab.com/api/pipeline_triggers/

function Get-GitlabPipelineTrigger {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [OutputType('Gitlab.PipelineTrigger')]
    param (
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='ByTriggerId')]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='ByTriggerId', Mandatory)]
        [Alias('Id')]
        [int]
        $TriggerId,

        [Parameter(ParameterSetName='ByProjectId')]
        [string]
        $Description,

        [Parameter(ParameterSetName='ByProjectId')]
        [uint]
        $MaxPages,

        [switch]
        [Parameter(ParameterSetName='ByProjectId')]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Request = @{
        HttpMethod = 'GET'
        # https://docs.gitlab.com/api/pipeline_triggers/#list-project-trigger-tokens
        Path       = "projects/$ProjectId/triggers"
        # the API has no description filter, so a lookup by description reads every page
        MaxPages   = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:($All -or $Description)
    }
    if ($TriggerId) {
        # https://docs.gitlab.com/api/pipeline_triggers/#retrieve-trigger-token-details
        $Request.Path += "/$TriggerId"
        $Request.MaxPages = 1
    }

    $Triggers = Invoke-GitlabApi @Request |
        New-GitlabObject 'Gitlab.PipelineTrigger' |
        Add-Member -PassThru -NotePropertyMembers @{
            ProjectId = $ProjectId
        }

    if ($Description) {
        $Triggers |
            Where-Object Description -eq $Description |
            Sort-Object CreatedAt -Descending
    } else {
        $Triggers
    }
}

function New-GitlabPipelineTrigger {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineTrigger')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory)]
        [string]
        $Description,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Request = @{
        HttpMethod = 'POST'
        # https://docs.gitlab.com/api/pipeline_triggers/#create-a-trigger-token
        Path       = "projects/$ProjectId/triggers"
        Body       = @{
            description = $Description
        }
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "create pipeline trigger '$Description'")) {
        Invoke-GitlabApi @Request |
            New-GitlabObject 'Gitlab.PipelineTrigger' |
            Add-Member -PassThru -NotePropertyMembers @{
                ProjectId = $ProjectId
            }
    }
}

function Remove-GitlabPipelineTrigger {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $TriggerId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    )

    process {
        # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }

        $ProjectId = Resolve-GitlabProjectId $ProjectId

        $Request = @{
            HttpMethod = 'DELETE'
            # https://docs.gitlab.com/api/pipeline_triggers/#delete-a-pipeline-trigger-token
            Path       = "projects/$ProjectId/triggers/$TriggerId"
        }

        if ($PSCmdlet.ShouldProcess("project $ProjectId trigger $TriggerId", "delete pipeline trigger")) {
            Invoke-GitlabApi @Request | Out-Null
        }
    }
}
