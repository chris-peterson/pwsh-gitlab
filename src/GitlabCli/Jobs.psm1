
function Get-GitlabJob {
    [Alias('jobs')]
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    param (

        [Parameter(ParameterSetName='ByJobId', Mandatory=$false)]
        [Parameter(ParameterSetName='ByProjectId', Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='ByPipelineId', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $PipelineId,

        [Parameter(ParameterSetName='ByJobId', Mandatory=$true)]
        [string]
        $JobId,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet("created","pending","running","failed","success","canceled","skipped","manual")]
        $Scope,

        [Parameter(Mandatory=$false)]
        [string]
        $Stage,

        [Parameter(Mandatory=$false)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeRetried,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeTrace
    )

    $Project = Get-GitlabProject $ProjectId
    $ProjectId = $Project.Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Query=@{}
        Path = "projects/$ProjectId/jobs"
    }

    if ($PipelineId) {
        GitlabApiArguments['Query'].Path = "projects/$ProjectId/pipelines/$PipelineId/jobs"
    }
    if ($JobId) {
        GitlabApiArguments['Query'].Path = "projects/$ProjectId/jobs/$JobId"
    }

    if ($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }
    if ($IncludeRetried) {
        $GitlabApiArguments['Query']['include_retried'] = $true
    }

    $Jobs = Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.Job'

    if ($Stage) {
        $Jobs = $Jobs |
            Where-Object Stage -match $Stage
    }
    if ($Name) {
        $Jobs = $Jobs |
            Where-Object Name -match $Name
    }

    if ($IncludeTrace) {
        $Jobs | ForEach-Object {
            try {
                $Trace = Invoke-GitlabApi GET "projects/$ProjectId/jobs/$($_.Id)/trace"
            }
            catch {
                $Trace = $Null
            }
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'Trace' -Value $Trace
        }
    }

    $Jobs
}

function Start-GitlabJob {
    [Alias('Play-GitlabJob')]
    [Alias('play')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $JobId,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf = $false
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="POST"
        Path="projects/$ProjectId/jobs/$JobId/play"
    }

    try {
        Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject "Gitlab.Job"
    }
    catch {
        if ($_.ErrorDetails.Message -match 'Unplayable Job') {
            $GitlabApiArguments.Path = $GitlabApiArguments.Path -replace '/play', '/retry'
            Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject "Gitlab.Job"
        }
    }
}