function Get-GitlabJob {
    [Alias('job')]
    [Alias('jobs')]
    [CmdletBinding(DefaultParameterSetName='Query')]
    [OutputType('Gitlab.Job')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='ByPipeline', Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $PipelineId,

        [Parameter(ParameterSetName='ById', Mandatory)]
        [Alias('Id')]
        [string]
        $JobId,

        [Parameter(ParameterSetName='Query')]
        [string]
        [ValidateSet('created', 'pending', 'running', 'failed', 'success', 'canceled', 'skipped', 'manual')]
        $Scope,

        [Parameter()]
        [string]
        $Stage,

        [Parameter()]
        [string]
        $Name,

        [Parameter(ParameterSetName='ByPipeline')]
        [switch]
        $IncludeRetried,

        [Parameter()]
        [switch]
        $IncludeTrace,

        [Parameter()]
        [switch]
        $IncludeVariables,

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

    $MaxPages  = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    $Project   = Get-GitlabProject -ProjectId $ProjectId
    $ProjectId = $Project.Id

    $Request = @{
        HttpMethod = 'GET'
        Query      = @{}
        MaxPages   = $MaxPages
    }

    if ($JobId) {
        # https://docs.gitlab.com/ee/api/jobs.html#get-a-single-job
        $Request.Path = "projects/$ProjectId/jobs/$JobId"
    }
    elseif ($PipelineId) {
        # https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-jobs
        $Request.Path = "projects/$ProjectId/pipelines/$PipelineId/jobs"
    }
    else {
        # https://docs.gitlab.com/ee/api/jobs.html#list-project-jobs
        $Request.Path = "projects/$ProjectId/jobs"
    }

    if ($Scope) {
        $Request.Query.scope = $Scope
    }
    if ($Name -or $IncludeRetried) {
        $Request.Query.include_retried = $true
    }

    $Jobs = Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Job'

    if ($Stage) {
        Write-Verbose "Filtering jobs by stage: $Stage"
        $Jobs = $Jobs |
            Where-Object Stage -match $Stage
    }
    if ($Name) {
        Write-Verbose "Filtering jobs by name: $Name"
        $Jobs = $Jobs | Where-Object Name -match $Name | Select-Object -First 1
    }
    if ($IncludeTrace) {
        $Jobs | ForEach-Object {
            try {
                $Trace = $_ | Get-GitlabJobTrace
            }
            catch {
                $Trace = $Null
            }
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'Trace' -Value $Trace
        }
    }
    if ($IncludeVariables) {
        $Jobs | ForEach-Object {
            $Data = Invoke-GitlabGraphQL @"
                {
                    project(fullPath: "$($Project.PathWithNamespace)") {
                        job(id: "gid://gitlab/Ci::Build/$($_.JobId)") {
                            manualVariables {
                                nodes {
                                  key, value
                                }
                            }
                        }
                    }
                }
"@
            $Variables = [PSCustomObject]@{}
            $Data.project.job.manualVariables.nodes | ForEach-Object {
                $Variables | Add-Member -MemberType 'NoteProperty' -Name $($_.key) -Value $_.value
            }
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'Variables' -Value $Variables
        }
    }

    $Jobs
}


function Get-GitlabJobTrace {
    [Alias('trace')]
    [CmdletBinding()]
    [OutputType([string])]
    param (

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $JobId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = "GET"
        Query      = @{}
        Path       = "projects/$ProjectId/jobs/$JobId/trace"
    }

    Invoke-GitlabApi @GitlabApiArguments
}

function Start-GitlabJob {
    [Alias('Play-GitlabJob')]
    [Alias('Retry-GitlabJob')]
    [Alias('play')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Job')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $JobId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [Alias('vars')]
        $Variables,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Wait
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = "POST"
        Path       = "projects/$($Project.Id)/jobs/$JobId/play"
        Body       = @{}
    }

    if ($Variables) {
        $GitlabApiArguments.Body.job_variables_attributes = $Variables | ConvertTo-GitlabVariables
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "start job $($GitlabApiArguments | ConvertTo-Json -Depth 3)")) {
        try {
            # https://docs.gitlab.com/ee/api/jobs.html#run-a-job
            $Job = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject "Gitlab.Job"
        }
        catch {
            if ($_.ErrorDetails.Message -match 'Unplayable Job') {
                Write-Verbose "Job $JobId is not playable, retrying instead"
                # https://docs.gitlab.com/ee/api/jobs.html#retry-a-job
                $GitlabApiArguments.Path = $GitlabApiArguments.Path -replace '/play', '/retry'
                $Job = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject "Gitlab.Job"
            } else {
                throw $_
            }
        }
        if ($Wait) {
            $ProgressArgs = @{
                Activity = "Running '$($Job.Name)'..."
                Id       = $Job.Id
            }
            Write-Progress @ProgressArgs
            do {
                Start-Sleep -Seconds 5
                # NOTE: we are intentionally getting by _name_ as the ID that we get from 'play' / 'retry' is the original job ID
                $Job = Get-GitlabJob -ProjectId $Project.Id -Name $Job.Name -IncludeTrace

                $JobTail = $Job.Trace -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Last 1
                Write-Progress @ProgressArgs -Status $JobTail
            } while ($Job.Status -eq 'running')
            Write-Progress @ProgressArgs -Completed
        }
        $Job
    }
}

function Test-GitlabPipelineDefinition {

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineDefinition')]
    param (
        [Parameter()]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [string]
        $Content,

        [Parameter()]
        [string]
        $Select,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId
    $ProjectId = $Project.Id

    $Params = @{
        Path    = "projects/$ProjectId/ci/lint"
        Body    = @{}
        Query   = @{}
    }

    if ($Content) {
        if (Test-Path $Content) {
            $Content = Get-Content -Raw -Path $Content
        }
        # https://docs.gitlab.com/ee/api/lint.html#validate-the-ci-yaml-configuration
        $Params.HttpMethod                = 'POST'
        $Params.Body.content              = $Content
        $Params.Query.include_merged_yaml = 'true'
    }
    else {
        # https://docs.gitlab.com/ee/api/lint.html#validate-a-projects-ci-configuration
        $Params.HttpMethod = 'GET'
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "Validate CI definition ($($Params | ConvertTo-Json))")) {
        Invoke-GitlabApi @Params |
            New-GitlabObject 'Gitlab.PipelineDefinition' |
            Get-FilteredObject $Select
    }
}

function Get-GitlabPipelineDefinition {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter()]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $SiteUrl
    )

    Get-GitlabRepositoryFileContent -ProjectId $ProjectId -Ref $Ref -FilePath '.gitlab-ci.yml' |
        ConvertFrom-Yaml
}

function Start-GitlabJobLogSection {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes CI log markers to console, not a state-changing operation')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]
        $HeaderText,

        [Parameter()]
        [switch]
        $Collapsed
    )

    $Timestamp = Get-EpochTimestamp
    $CollapsedHeader = ''
    if ($Collapsed) {
        $CollapsedHeader = '[collapsed=true]'
    }

    # use timestamp as the section name (since we are hiding that in our API)
    $SectionId = "$([System.Guid]::NewGuid().ToString("N"))"
    Write-Host "`e[$($global:GitlabConsoleColors.White)m`e[0Ksection_start:$($Timestamp):$($SectionId)$($CollapsedHeader)`r`e[0K$HeaderText"
    $global:GitlabJobLogSections.Push($SectionId)
}

function Stop-GitlabJobLogSection {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes CI log markers to console, not a state-changing operation')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
    )

    if ($global:GitlabJobLogSections.Count -eq 0) {
        # explicitly do nothing
        # most likely case is if stop is called more than start
        return
    }
    $PreviousId = $global:GitlabJobLogSections.Pop()
    $Timestamp = Get-EpochTimestamp
    Write-Host "section_end:$($Timestamp):$PreviousId`r`e[0K"
}

function Write-GitlabJobTrace {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter()]
        [string]
        $Text,

        [Parameter()]
        [ValidateSet('Black', 'Red', 'Green', 'Orange', 'Blue', 'Purple', 'Cyan', 'LightGray', 'DarkGray', 'LightRed', 'LightGreen', 'Yellow', 'LightBlue', 'LightPurple', 'LightCyan', 'White')]
        [string]
        $Color
    )

    if ($Color) {
        $Text = "`e[$($global:GitlabConsoleColors[$Color])m$Text"
    }

    Write-Host $Text
}

function Get-GitlabJobArtifact {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $JobId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $ArtifactPath,

        [Parameter(Mandatory)]
        [string]
        $OutFile,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Resource = "projects/$ProjectId/jobs/$JobId/artifacts"
    if ($ArtifactPath) {
        $Resource += "/$ArtifactPath"
    }

    $GitlabApiArguments = @{
        HttpMethod       = "GET"
        Path             = $Resource
        OutFile          = $OutFile
    }

    Invoke-GitlabApi @GitlabApiArguments
}
