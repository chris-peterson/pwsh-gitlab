function Get-GitLabPipeline {

    [CmdletBinding(DefaultParameterSetName="ById")]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [string]
        [Parameter(Mandatory=$false, ParameterSetName="ById")]
        $PipelineId,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName="Recent")]
        $Recent = $false,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        $All = $false
    )

    $Project = Get-GitLabProject -ProjectId $ProjectId

    if ($PipelineId) {
        $Pipeline = gitlab -o json project-pipeline get --id $PipelineId --project-id $Project.Id | ConvertFrom-Json
        New-WrapperObject $Pipeline -DisplayType 'GitLab.Pipeline'
    } else {
        $Command = "gitlab -o json project-pipeline list --project-id $($Project.Id)"
        if ($Recent) {
            # default behavior of CLI/API
        } elseif ($All) {
            $Command += ' --all'
        } else {
            throw "Must provide either an ID, or a range parameter (e.g. Recent/All)"
        }
        $Pipelines = Invoke-Expression -Command $Command | ConvertFrom-Json
        $Pipelines | ForEach-Object {
            Get-GitLabPipeline -ProjectId $ProjectId -PipelineId $_.Id
        }
    }
}

function Get-GitLabPipelineSchedule {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId
    )

    throw "not implemented yet"
}