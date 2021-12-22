# https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines
function Get-GitlabPipeline {

    [Alias('pipeline')]
    [Alias('pipelines')]
    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(ParameterSetName="ByProjectId", Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName="ByPipelineId", Position=0, Mandatory=$false)]
        [string]
        $ProjectId=".",

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter(ParameterSetName="ByPipelineId", Position=1, Mandatory=$false)]
        [string]
        $PipelineId,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [ValidateSet('created', 'waiting_for_resource', 'preparing', 'pending', 'running', 'success', 'failed', 'canceled', 'skipped', 'manual', 'scheduled')]
        [string]
        $Status,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [ValidateSet('push', 'web', 'trigger', 'schedule', 'api', 'external', 'pipeline', 'chat', 'webide', 'merge_request_event', 'external_pull_request_event', 'parent_pipeline', 'ondemand_dast_scan', 'ondemand_dast_validation')]
        [string]
        $Source,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [string]
        $Username,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [switch]
        $Mine,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [switch]
        $Latest,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeTestReport,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiParameters = @{
        HttpMethod = "GET"
        Path       = "projects/$($Project.Id)/pipelines"
        SiteUrl    = $SiteUrl
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByPipelineId {
            $GitlabApiParameters["Path"] += "/$PipelineId"
        }
        ByProjectId {
            $Query = @{}

            if($Ref) {
                if($Ref -eq '.') {
                    $LocalContext = Get-LocalGitContext
                    $Ref = $LocalContext.Branch
                }
                $Query['ref'] = $Ref
            }
            if ($Status) {
                $Query['status'] = $Status
            }
            if ($Source) {
                $Query['source'] = $Source
            }
            if ($Mine) {
                $Query['username'] = $(Get-GitlabUser -Me).Username
            } elseif ($Username) {
                $Query['username'] = $Username
            }
    
            $GitlabApiParameters["Query"] = $Query
            $GitlabApiParameters["MaxPages"] = $MaxPages

        }
        default {
            throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    if ($WhatIf) {
        $GitlabApiParameters["WhatIf"] = $True
    }
    $Pipelines = Invoke-GitlabApi @GitlabApiParameters -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Pipeline'

    if ($IncludeTestReport) {
        $Pipelines | ForEach-Object {
            try {
                $TestReport = Invoke-GitlabApi GET "projects/$($_.ProjectId)/pipelines/$($_.Id)/test_report" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.TestReport'
            }
            catch {
                $TestReport = $Null
            }

            $_ | Add-Member -MemberType 'NoteProperty' -Name 'TestReport' -Value $TestReport
        }
    }

    if ($Latest) {
        $Pipelines | Sort-Object -Descending Id | Select-Object -First 1
    } else {
        $Pipelines
    }
}

function Get-GitlabPipelineSchedule {

    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [Alias('schedule')]
    [Alias('schedules')]
    param (
        [Parameter(ParameterSetName='ByProjectId', Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ByPipelineScheduleId', Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='ByProjectId', Mandatory=$false)]
        [Parameter(ParameterSetName='ByPipelineScheduleId', Mandatory=$true)]
        [int]
        $PipelineScheduleId,

        [Parameter(ParameterSetName='ByProjectId', Mandatory=$false)]
        [string]
        [ValidateSet('active', 'inactive')]
        $Scope,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod = "GET"
        Path       = "projects/$ProjectId/pipeline_schedules"
        Query      = @{}
        SiteUrl    = $SiteUrl
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByPipelineId { 
            $GitlabApiArguments["Path"] += "/$PipelineScheduleId" 
        }
        ByProjectId {
            if($Scope) {
                $GitlabApiArguments["Query"]["scope"] = $Scope
            }
        }
        default { throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"}
    }

    $Wrapper = Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.PipelineSchedule'
    $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId
    $Wrapper
}

# https://docs.gitlab.com/ee/api/pipeline_schedules.html#edit-a-pipeline-schedule
function Update-GitlabPipelineSchedule {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]
        $PipelineScheduleId,

        [Parameter(Mandatory=$false)]
        [bool]
        $Active,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GitlabApiArguments = @{
        HttpMethod = "PUT"
        Path       = "projects/$ProjectId/pipeline_schedules/$PipelineScheduleId"
        Query      = @{}
        SiteUrl    = $SiteUrl
    }

    if ($PSBoundParameters.ContainsKey("Active")) {
        $GitlabApiArguments.Query['active'] = $Active.ToString().ToLower()
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.PipelineSchedule'
}

# https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-bridges
function Get-GitlabPipelineBridges {
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
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )
    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod = "GET"
        Path       = "projects/$ProjectId/pipelines/$PipelineId/bridges"
        Query      = @{}
        SiteUrl    = $SiteUrl
    }

    if($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject "Gitlab.PipelineBridge"
}

function New-GitlabPipeline {
    [CmdletBinding()]
    [Alias("build")]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref = '.',

        [Parameter(Mandatory=$false)]
        [switch]
        $Wait,

        [Parameter(Mandatory=$false)]
        [switch]
        $Follow,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $ProjectId = $Project.Id

    if ($Ref) {
        if ($Ref -eq '.') {
            $Ref = $(Get-LocalGitContext).Branch
        }
    } else {
        $Ref = $Project.DefaultBranch
    }

    $GitlabApiArguments = @{
        HttpMethod = "POST"
        Path       = "projects/$ProjectId/pipeline"
        Query      = @{'ref' = $Ref}
        SiteUrl    = $SiteUrl
    }

    $Pipeline = Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Pipeline'

    if ($Wait) {
        Write-Host "$($Pipeline.Id) created..."
        while ($True) {
            Start-Sleep -Seconds 5
            $Jobs = $Pipeline | Get-GitlabJob -IncludeTrace |
                Where-Object { $_.Status -ne 'manual' -and $_.Status -ne 'skipped' -and $_.Status -ne 'created' } |
                Sort-Object CreatedAt
            
            if ($Jobs) {
                Clear-Host
                Write-Host "$($Pipeline.WebUrl)"
                Write-Host
                $Jobs |
                    Where-Object { $_.Status -eq 'success' } |
                        ForEach-Object {
                            Write-Host "[$($_.Name)] ✅" -ForegroundColor DarkGreen
                        }
                $Jobs |
                    Where-Object { $_.Status -eq 'failed' } |
                        ForEach-Object {
                            Write-Host "[$($_.Name)] ❌" -ForegroundColor DarkRed
                    }
                Write-Host

                $InProgress = $Jobs |
                    Where-Object { $_.Status -ne 'success' -and $_.Status -ne 'failed' }
                if ($InProgress) {
                    $InProgress |
                        ForEach-Object {
                            Write-Host "[$($_.Name)] ⏳" -ForegroundColor DarkYellow
                            $RecentProgress = $_.Trace -split "`n" | Select-Object -Last 15
                            $RecentProgress | ForEach-Object {
                                Write-Host "  $_"
                        }
                    }
                }
                else {
                    break;
                }
            }
        }
    }

    if ($Follow) {
        Start-Process $Pipeline.WebUrl
    } else {
        $Pipeline
    }
}

function Remove-GitlabPipeline {

    [CmdletBinding()]
    param (
        [string]
        $ProjectId = '.',

        [string]
        $PipelineId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl
    $Pipeline = Get-GitlabPipeline -ProjectId $ProjectId -PipelineId $PipelineId -SiteUrl $SiteUrl

    Invoke-GitlabApi DELETE "projects/$($Project.Id)/pipelines/$($Pipeline.Id)" -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
