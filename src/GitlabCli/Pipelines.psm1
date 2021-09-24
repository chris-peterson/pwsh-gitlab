function Get-GitlabPipeline {

    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(ParameterSetName="ByProjectId", Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName="ByPipelineId", Position=0, Mandatory=$false)]
        [string]
        $ProjectId=".",

        [Parameter(ParameterSetName="ByPipelineId", Position=1, Mandatory=$false)]
        [string]
        $PipelineId,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [ValidateSet('created', 'waiting_for_resource', 'preparing', 'pending', 'running', 'success', 'failed', 'canceled', 'skipped', 'manual', 'scheduled')]
        [string]
        $Status,

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
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiParameters = @{
        "HttpMethod" = "GET"
        "Path" = "projects/$($Project.Id)/pipelines"
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
    $Pipelines = Invoke-GitlabApi @GitlabApiParameters | New-WrapperObject 'Gitlab.Pipeline'

    if ($IncludeTestReport) {
        $Pipelines | ForEach-Object {
            try {
                $TestReport = Invoke-GitlabApi GET "projects/$($_.ProjectId)/pipelines/$($_.Id)/test_report" | New-WrapperObject 'Gitlab.TestReport'
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

    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(Position=0,ParameterSetName="ByProjectId", Mandatory=$true)]
        [Parameter(Position=0,ParameterSetName="ByPipelineId",Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(ParameterSetName="ByPipelineId",Mandatory=$true,Position=1)]
        [Parameter(Position=1, Mandatory=$false)]
        [int]
        $PipelineId,

        [Parameter(Position=1,ParameterSetName="ByProjectId", Mandatory=$false)]
        [string]
        [ValidateSet("active","inactive")]
        $Scope
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipeline_schedules"
        Query=@{}
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByPipelineId { 
            $GitlabApiArguments["Path"] += "/$PipelineId" 
        }
        ByProjectId {
            if($Scope) {
                $GitlabApiArguments["Query"]["scope"] = $Scope
            }
        }
        default { throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"}
    }

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.PipelineSchedule'

}

function Get-GitlabPipelineJobs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]
        [string]
        $PipelineId,

        [Parameter(Mandatory=$false, Position=1, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

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

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipelines/$PipelineId/jobs"
        Query=@{}
    }

    if ($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }
    if ($IncludeRetried) {
        $GitlabApiArguments['Query']['include_retried'] = $true
    }

    $Jobs = Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.PipelineJob'

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
        $Scope
    )
    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipelines/$PipelineId/bridges"
        Query=@{}
    }

    if($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject "Gitlab.PipelineJobBridge"
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
        [switch]
        $WhatIf = $false
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
        HttpMethod="POST"
        Path="projects/$ProjectId/pipeline"
        Query=@{'ref' = $Ref}
        WhatIf=$WhatIf
    }

    $Pipeline = Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.Pipeline'

    if ($Wait) {
        Write-Host "$($Pipeline.Id) created..."
        while ($True) {
            Start-Sleep -Seconds 5
            $Jobs = Get-GitlabPipelineJobs -ProjectId $Pipeline.ProjectId -PipelineId $Pipeline.Id -IncludeTrace |
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
        [switch]
        $WhatIf = $false
    )

    $Project = Get-GitlabProject $ProjectId
    $Pipeline = Get-GitlabPipeline -ProjectId $ProjectId -PipelineId $PipelineId

    Invoke-GitlabApi DELETE "projects/$($Project.Id)/pipelines/$($Pipeline.Id)" -WhatIf:$WhatIf
}
