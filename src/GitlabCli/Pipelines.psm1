function Get-GitlabPipeline {

    [Alias('pipeline')]
    [Alias('pipelines')]
    [CmdletBinding()]
    [OutputType('Gitlab.Pipeline')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId='.',

        [Parameter()]
        [Alias('Branch')]
        [string]
        $Ref,

        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $PipelineId,

        [Parameter()]
        [string]
        $Url,

        [Parameter()]
        [ValidateSet('running', 'pending', 'finished', 'branches', 'tags')]
        [string]
        $Scope,

        [Parameter()]
        [ValidateSet('created', 'waiting_for_resource', 'preparing', 'pending', 'running', 'success', 'failed', 'canceled', 'skipped', 'manual', 'scheduled')]
        [string]
        $Status,

        [Parameter()]
        [ValidateSet('push', 'web', 'trigger', 'schedule', 'api', 'external', 'pipeline', 'chat', 'webide', 'merge_request_event', 'external_pull_request_event', 'parent_pipeline', 'ondemand_dast_scan', 'ondemand_dast_validation')]
        [string]
        $Source,

        [Parameter()]
        [string]
        $Username,

        [Parameter()]
        [switch]
        $Mine,

        [Parameter()]
        [switch]
        $Latest,

        [Parameter()]
        [switch]
        $IncludeTestReport,

        [Parameter()]
        [Alias('FetchUpstream')]
        [switch]
        $FetchDownstream,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $GitlabApiParameters = @{
        HttpMethod = 'GET'
        MaxPages   = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    }

    if ($Url) {
        $Resource   = $Url | Get-GitlabResourceFromUrl
        $ProjectId  = $Resource.ProjectId
        $PipelineId = $Resource.ResourceId
    } else {
        $Query = @{}

        if($Ref) {
            if($Ref -eq '.') {
                $LocalContext = Get-LocalGitContext
                $Ref = $LocalContext.Branch
            }
            $Query.ref = $Ref
        }
        if ($Scope) {
            $Query.scope = $Scope
        }
        if ($Status) {
            $Query.status = $Status
        }
        if ($Source) {
            $Query.source = $Source
        }
        if ($Mine) {
            $Query.username = $(Get-GitlabUser -Me).Username
        } elseif ($Username) {
            $Query.username = $Username
        }

        $GitlabApiParameters.Query = $Query
        $GitlabApiParameters.MaxPages = $MaxPages
    }

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiParameters.Path = if ($PipelineId) {
        # https://docs.gitlab.com/api/pipelines/#get-a-single-pipeline
        "projects/$($Project.Id)/pipelines/$PipelineId"
    } else {
        # https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines
        "projects/$($Project.Id)/pipelines"
    }

    $Pipelines = Invoke-GitlabApi @GitlabApiParameters | New-GitlabObject 'Gitlab.Pipeline'

    if ($IncludeTestReport) {
        $Pipelines | ForEach-Object {
            try {
                $TestReport = Invoke-GitlabApi GET "projects/$($_.ProjectId)/pipelines/$($_.Id)/test_report" | New-GitlabObject 'Gitlab.TestReport'
            }
            catch {
                $TestReport = $Null
            }

            $_ | Add-Member -MemberType 'NoteProperty' -Name 'TestReport' -Value $TestReport
        }
    }

    if ($Latest) {
        $Pipelines = $Pipelines | Sort-Object -Descending Id | Select-Object -First 1
    }

    if ($FetchDownstream) {
        # the API doesn't currently expose this, so working around using GraphQL
        # https://gitlab.com/gitlab-org/gitlab/-/issues/21495
        foreach ($Pipeline in $Pipelines) {

            # NOTE: have to stitch this together because of https://gitlab.com/gitlab-org/gitlab/-/issues/350686
            $Bridges = Get-GitlabPipelineBridge -ProjectId $Project.Id  -PipelineId $Pipeline.Id

            # NOTE: once 14.6 is more available, iid is included in pipeline APIs which would make this simpler (not have to search by sha)
            $Query = @"
            { project(fullPath: "$($Project.PathWithNamespace)") { id pipelines (sha: "$($Pipeline.Sha)") { nodes { id downstream { nodes { id project { fullPath } } } upstream { id project { fullPath } } } } } }
"@
            $Nodes = $(Invoke-GitlabGraphQL -Query $Query).Project.pipelines.nodes
            $MatchingResult = $Nodes | Where-Object id -Match "gid://gitlab/Ci::Pipeline/$($Pipeline.Id)"
            if ($MatchingResult.downstream) {
                $DownstreamList = $MatchingResult.downstream.nodes | ForEach-Object {
                    if ($_.id -match "/(?<PipelineId>\d+)") {
                        try {
                            Get-GitlabPipeline -ProjectId $_.project.fullPath -PipelineId $Matches.PipelineId
                        }
                        catch {
                            $Null
                        }
                    }
                } | Where-Object { $_ }
                $DownstreamMap = @{}

                foreach ($Downstream in $DownstreamList) {
                    $MatchingBridge = $Bridges | Where-Object { $_.DownstreamPipeline.id -eq $Downstream.Id }
                    if ($MatchingBridge) {
                        $DownstreamMap[$MatchingBridge.Name] = $Downstream
                    }
                    else {
                        Write-Debug -Message "No bridge found for $($Downstream.Id)"
                    }
                }
                $Pipeline | Add-Member -MemberType 'NoteProperty' -Name 'Downstream' -Value $DownstreamMap
            }
            if ($MatchingResult.upstream.id -match '\/(?<PipelineId>\d+)') {
                try {
                    $Upstream = Get-GitlabPipeline -ProjectId $MatchingResult.upstream.project.fullPath -PipelineId $Matches.PipelineId
                    $Pipeline | Add-Member -MemberType 'NoteProperty' -Name 'Upstream' -Value $Upstream
                }
                catch {
                }
            }
        }
    }

    $Pipelines
}

function Get-GitlabPipelineVariable {
    [CmdletBinding()]
    [OutputType('Gitlab.PipelineVariable')]
    param(
        [Parameter()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $PipelineId,

        [Parameter(Position=1)]
        [string]
        $Variable,

        [Parameter()]
        [ValidateSet('KeyValuePairs', 'Object')]
        [string]
        $As = 'KeyValuePairs',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/pipelines.html#get-variables-of-a-pipeline
    $KeyValues = Invoke-GitlabApi GET "projects/$ProjectId/pipelines/$PipelineId/variables"

    if ($Variable) {
        $KeyValues | Where-Object Key -eq $Variable | Select-Object -ExpandProperty Value
    } else {
        if ($As -eq 'KeyValuePairs') {
            $KeyValues | New-GitlabObject 'Gitlab.PipelineVariable'
        } elseif ($As -eq 'Object') {
            $Obj = New-Object PSObject
            $KeyValues.Key | ForEach-Object {
                $Obj | Add-Member -NotePropertyName $_ -NotePropertyValue $($KeyValues | Where-Object Key -eq $_ | Select-Object -ExpandProperty Value)
            }
            $Obj
        }
    }
}

# https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-bridges
function Get-GitlabPipelineBridge {
    [CmdletBinding()]
    [OutputType('Gitlab.PipelineBridge')]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $PipelineId,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet("created","pending","running","failed","success","canceled","skipped","manual")]
        $Scope,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )
    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = "GET"
        Path       = "projects/$ProjectId/pipelines/$PipelineId/bridges"
        Query      = @{}
    }

    if($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }

    Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject "Gitlab.PipelineBridge"
}

function New-GitlabPipeline {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Pipeline')]
    [Alias('build')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [Alias('Branch')]
        [string]
        $Ref,

        [Parameter()]
        [Alias('vars')]
        $Variables,

        [Parameter()]
        [switch]
        $Wait,

        [Parameter()]
        [switch]
        $Follow,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $ProjectId = $Project.Id

    if (-not $Ref) {
        $Local = Get-LocalGitContext
        if ($Local.Project -eq $Project.PathWithNamespace) {
            $Ref = $Local.Branch
        } else {
            $Ref = $Project.DefaultBranch
        }
    }

    $Request = @{
        ref = $Ref
    }

    if ($Variables) {
        $Request.variables = $Variables | ConvertTo-GitlabVariables -Type 'env_var'
    }

    $GitlabApiArguments = @{
        HttpMethod = "POST"
        Path       = "projects/$ProjectId/pipeline"
        Body       = $Request
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "create new pipeline $($Request | ConvertTo-Json)")) {
        $Pipeline = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject 'Gitlab.Pipeline'

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
}

function Remove-GitlabPipeline {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]
        $PipelineId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId
    $Pipeline = Get-GitlabPipeline -ProjectId $ProjectId -PipelineId $PipelineId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "delete pipeline $PipelineId")) {
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/pipelines/$($Pipeline.Id)" | Out-Null
        Write-Host "$PipelineId deleted from $($Project.Name)"
    }
}