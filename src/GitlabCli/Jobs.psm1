function Get-GitlabJob {
    [Alias('job')]
    [Alias('jobs')]
    [CmdletBinding(DefaultParameterSetName='Query')]
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

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    $Project = Get-GitlabProject -ProjectId $ProjectId
    $ProjectId = $Project.Id

    $Request = @{
        HttpMethod = "GET"
        Query      = @{}
        SiteUrl    = $SiteUrl
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
    if ($IncludeRetried) {
        $Request.Query.include_retried = $true
    }

    $Jobs = Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.Job'

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
    param (

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $JobId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId
    $ProjectId = $Project.Id

    $GitlabApiArguments = @{
        HttpMethod = "GET"
        Query      = @{}
        Path       = "projects/$ProjectId/jobs/$JobId/trace"
        SiteUrl    = $SiteUrl
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf
}

function Start-GitlabJob {
    [Alias('Play-GitlabJob')]
    [Alias('play')]
    [CmdletBinding(SupportsShouldProcess)]
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
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = "POST"
        Path       = "projects/$($Project.Id)/jobs/$JobId/play"
        SiteUrl    = $SiteUrl
        Body       = @{}
    }

    if ($Variables) {
        $GitlabApiArguments.Body.job_variables_attributes = $Variables | ConvertTo-GitlabVariables
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "start job $($GitlabApiArguments | ConvertTo-Json -Depth 3)")) {
        try {
            # https://docs.gitlab.com/ee/api/jobs.html#run-a-job
            Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject "Gitlab.Job"
        }
        catch {
            Write-Verbose $_
            if ($_.ErrorDetails.Message -match 'Unplayable Job') {
                # https://docs.gitlab.com/ee/api/jobs.html#retry-a-job
                $GitlabApiArguments.Path = $GitlabApiArguments.Path -replace '/play', '/retry'
                Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject "Gitlab.Job"
            }
        }
    }
}

function Test-GitlabPipelineDefinition {

    [CmdletBinding(SupportsShouldProcess)]
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
        SiteUrl = $SiteUrl
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
            New-WrapperObject 'Gitlab.PipelineDefinition' |
            Get-FilteredObject $Select
    }
}

function Get-GitlabPipelineDefinition {
    [CmdletBinding()]
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

    Get-GitlabRepositoryFileContent -ProjectId $ProjectId -Ref $Ref -FilePath '.gitlab-ci.yml' -SiteUrl $SiteUrl |
        ConvertFrom-Yaml
}

<#
.SYNOPSIS
Produces a section that can be collapsed in the Gitlab CI output

.PARAMETER HeaderText
Name of the section

.PARAMETER Collapsed
Whether or not the section is pre-collapsed. Not currently supported. Has no affect

.EXAMPLE
Start-GitlabJobLogSection "Doing the thing"
try {
    #the things
}
finally {
    Stop-GitlabJobLogSection
}

.NOTES
for reference: https://docs.gitlab.com/ce/ci/jobs/index.html#custom-collapsible-sections
#>
function Start-GitlabJobLogSection {
    [CmdletBinding()]
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

<#
.SYNOPSIS
Closes out a previously declared collapsible section in Gitlab CI output

.DESCRIPTION
Long description

.EXAMPLE
Start-GitlabJobLogSection "Doing the thing"
try {
    #the things
}
finally {
    Stop-GitlabJobLogSection
}

.NOTES
for reference: https://docs.gitlab.com/ce/ci/jobs/index.html#custom-collapsible-sections
#>
function Stop-GitlabJobLogSection {
    [CmdletBinding()]
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

function Get-EpochTimestamp {
    [int] $(New-TimeSpan -Start $(Get-Date "01/01/1970") -End $(Get-Date)).TotalSeconds
}

function Write-GitlabJobTrace {
    [CmdletBinding()]
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
