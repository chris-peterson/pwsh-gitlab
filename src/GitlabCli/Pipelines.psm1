function Get-GitlabPipeline {

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

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        $All = $false
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($PipelineId) {
        Invoke-GitlabApi GET "projects/$($Project.Id)/pipelines/$PipelineId" |
            New-WrapperObject -DisplayType 'Gitlab.Pipeline'
    } else {
        $Query = @{}
        $MaxPages = 1
        if ($Recent) {
            # default behavior of CLI/API
        } elseif ($All) {
            $MaxPages = 10 #ok, not really all, but let's not DOS gitlab
        } else {
            throw "Must provide either an ID, or a range parameter (e.g. Recent/All)"
        }
        if($Ref) {
            if($Ref -eq '.') {
                $LocalContext = Get-LocalGitContext
                $Ref = $LocalContext.Branch
            }
            $Query['ref'] = $Ref
        }
        Invoke-GitlabApi GET "projects/$($Project.Id)/pipelines" $Query -MaxPages $MaxPages | 
            ForEach-Object { $_ | New-WrapperObject -DisplayType 'Gitlab.Pipeline'}
    }
}

function Get-GitlabPipelineSchedule {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId
    )

    throw "not implemented yet"
}

function Get-GitlabPipelineJobs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true,Position=1)]
        [string]
        $PipelineId,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet("created","pending","running","failed","success","canceled","skipped","manual")]
        $Scope,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeRetired
    )

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipelines/$PipelineId/jobs"
        Query=@{}
    }

    if($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }

    if($IncludeRetired) {
        $GitlabApiArguments['Query']['include_retired'] = $true
    }

    Invoke-GitlabApi @GitlabApiArguments
}