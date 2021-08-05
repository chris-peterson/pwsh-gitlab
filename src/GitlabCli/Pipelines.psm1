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

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        $All = $false
    )

    $Project = Get-GitLabProject -ProjectId $ProjectId

    if ($PipelineId) {
        Invoke-GitlabApi GET "projects/$($Project.Id)/pipelines/$PipelineId" |
            New-WrapperObject -DisplayType 'GitLab.Pipeline'
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
            ForEach-Object { $_ | New-WrapperObject -DisplayType 'GitLab.Pipeline'}
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