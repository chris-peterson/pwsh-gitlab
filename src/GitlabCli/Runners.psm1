# https://docs.gitlab.com/ee/api/runners.html

function Get-GitlabRunner {
    [CmdletBinding(DefaultParameterSetName='ListAll')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='RunnerId')]
        [string]
        $RunnerId,

        [Parameter(ParameterSetName='ListAll')]
        [ValidateSet('instance_type', 'group_type', 'project_type')]
        [string]
        $Type,

        [Parameter(ParameterSetName='ListAll')]
        [ValidateSet('active', 'paused', 'online', 'offline')]
        [string]
        $Status,

        [Parameter(ParameterSetName='ListAll')]
        [string []]
        $Tags,

        [switch]
        [Parameter()]
        $FetchDetails,

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

    $Params = @{
        HttpMethod = 'GET'
        Query      = @{}
        MaxPages   = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
        SiteUrl    = $SiteUrl
    }

    switch ($PSCmdlet.ParameterSetName) {
        # https://docs.gitlab.com/ee/api/runners.html#get-runners-details
        RunnerId { 
            $Params.Path = "runners/$RunnerId"
        }
        # https://docs.gitlab.com/ee/api/runners.html#list-all-runners
        ListAll {
            $Params.Path = 'runners/all'
            $Params.Query.type = $Type
            $Params.Query.status = $Status
            $Params.Query.tag_list = $Tags -join ','
        }
        default { throw "Unsupported parameter combination" }
    }

    $Runners = Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.Runner'
    if ($FetchDetails) {
        $RunnerCount = $Runners.Count
        $i = 0
        $Runners | ForEach-Object {
            $PercentComplete = $($i++ / $RunnerCount * 100)
            Write-Progress "Fetching runner details ($i of $RunnerCount)" -PercentComplete $PercentComplete
            Get-GitlabRunner -RunnerId $_.Id -SiteUrl $SiteUrl
        }
    }
    $Runners
}

function Get-GitlabRunnerJob {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $RunnerId,

        [Parameter()]
        [uint]
        $MaxPages,

        [Parameter()]
        [switch]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    # https://docs.gitlab.com/ee/api/runners.html#list-runners-jobs
    $Params = @{
        HttpMethod = 'GET'
        Path       = "runners/$RunnerId/jobs"
        MaxPages   = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
        SiteUrl    = $SiteUrl
    }

    Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.RunnerJob'
}

function Update-GitlabRunner {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $RunnerId,

        [Parameter()]
        [string]
        $Id,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [TrueOrFalse()][bool]
        $Active,

        [Parameter()]
        [string]
        $Tags,

        [Parameter()]
        [TrueOrFalse()][bool]
        $RunUntaggedJobs,

        [Parameter()]
        [TrueOrFalse()][bool]
        $Locked,

        [Parameter()]
        [string]
        [ValidateSet('not_protected', 'ref_protected')]
        $AccessLevel,

        [Parameter()]
        [uint]
        $MaximumTimeoutSeconds,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Params = @{
        HttpMethod = 'PUT'
        Path       = "runners/$RunnerId"
        Query      = @{}
        SiteUrl    = $SiteUrl
    }
    if ($Description) {
        $Params.Query.description = $Description
    }
    if ($Tags) {
        $Params.Query.tag_list = $Tags
    }
    if ($AccessLevel) {
        $Params.Query.access_level = $Tags
    }
    if ($MaximumTimeoutSeconds) {
        if ($MaximumTimeoutSeconds -lt 600) {
            throw "maximum_timeout must be >= 600"
        }
        if ($MaximumTimeoutSeconds -gt [int]::MaxValue) {
            throw "maximum_timeout must be <= $([int]::MaxValue)"
        }
        $Params.Query.maximum_timeout = $MaximumTimeoutSeconds
    }

    if ($PSBoundParameters.ContainsKey('Active')) {
        $Params.Query.active = $Active
    }
    if ($PSBoundParameters.ContainsKey('RunUntaggedJobs')) {
        $Params.Query.run_untagged = $RunUntaggedJobs
    }
    if ($PSBoundParameters.ContainsKey('Locked')) {
        $Params.Query.locked = $Locked
    }

    if ($PSCmdlet.ShouldProcess("$($Params.Path)", "update ($($Params.Query | ConvertTo-Json))")) {
        # https://docs.gitlab.com/ee/api/runners.html#update-runners-details
        Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.Runner'
    }
}
function Suspend-GitlabRunner {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $RunnerId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    Update-GitlabRunner $RunnerId -Active $false -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference
}

function Resume-GitlabRunner {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $RunnerId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    Update-GitlabRunner $RunnerId -Active $true -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference
}

function Remove-GitlabRunner {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]
        $RunnerId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Runner = Get-GitlabRunner -RunnerId $RunnerId

    if ($PSCmdlet.ShouldProcess("runner $($Runner.Id) [$($Runner.Status)] ($($Runner.Summary))", "delete")) {
        # https://docs.gitlab.com/ee/api/runners.html#delete-a-runner-by-id
        if (Invoke-GitlabApi DELETE "runners/$($Runner.Id)") {
            Write-Host "Runner $($Runner.Id) deleted"
        }
    }
}

function Get-Percentile {
    param (
        [double[]]$Values,
        [double]$Percentile
    )
    if (-not $Values -or $Values.Count -eq 0) { return $null }
    $Sorted = $Values | Sort-Object
    $Rank = [math]::Ceiling($Percentile * $Sorted.Count) - 1
    $Rank = [math]::Max(0, [math]::Min($Rank, $Sorted.Count - 1))
    $Sorted[$Rank]
}

function Get-GitlabRunnerStats {
    [CmdletBinding(DefaultParameterSetName='ByTags')]
    param (
        [Parameter(ParameterSetName='ById', Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $RunnerId,

        [Parameter(ParameterSetName='ByTags', Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Tag')]
        [string[]]
        $RunnerTag,

        [Parameter()]
        [datetime]
        $Before,

        [Parameter()]
        [datetime]
        $After,

        [Parameter()]
        [int]
        $JobLimit = 100,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $RunnerIds = @($RunnerId) | ForEach-Object { "gid://gitlab/Ci::Runner/$($_)" }
    } elseif ($PSCmdlet.ParameterSetName -eq 'ByTags') {
        $TagList = $RunnerTag -join ','
        $GetRunners = @{
            Query = @"
            {
                runners(tagList: `"$TagList`") {
                    nodes {
                        id
                    }
                }
            }
"@
            SiteUrl = $SiteUrl
        }
        $Runners = Invoke-GitlabGraphQL @GetRunners
        $RunnerIds = $Runners.Runners.nodes.id
    }

    $Data = @()
    foreach ($RunnerId in $RunnerIds) {
        $GetJobs = @{
            Query = @"
        {
            runner(id: `"$RunnerId`") {
                id
                runnerType
                jobs(first: $JobLimit) {
                    nodes {
                        project {
                            webUrl
                        }
                        id
                        status
                        queuedDuration
                        startedAt
                    }
                }
            }
        }
"@
            SiteUrl = $SiteUrl
        }
        $Jobs = Invoke-GitlabGraphQL @GetJobs

        $Data += [pscustomobject]@{
            Runner = $RunnerId
            Jobs   = $Jobs.Runner.jobs.nodes
        }
    }

    $JobCountByStatus = [ordered]@{}
    $Data.Jobs | Group-Object -Property status -NoElement | Sort-Object -Descending Count | ForEach-Object {
        $JobCountByStatus[$_.Name.ToLower()] = $_.Count
    }
    $QueuedJobs = $Data.Jobs | Where-Object { $_.queuedDuration -ne $null -and $_.queuedDuration -gt 0 }
    $LongestQueuedJobs = $QueuedJobs | Sort-Object -Property queuedDuration -Descending | Select-Object -First 5 | ForEach-Object {
      $_ | Add-Member -MemberType NoteProperty -Name 'Uri' -Value "$($_.project.webUrl)/-/jobs/$(($_.id -split '/')[-1])" -PassThru
    }
    $Durations = $QueuedJobs.queuedDuration

    [PSCustomObject]@{
        RunnerCount                  = $RunnerIds.Count
        JobCount                     = $Data.Jobs.Count
        JobCountByStatus             = $JobCountByStatus
        JobQueuedDurationPercentiles = [ordered]@{
            '50' = Get-Percentile -Values $Durations -Percentile 0.50
            '80' = Get-Percentile -Values $Durations -Percentile 0.80
            '95' = Get-Percentile -Values $Durations -Percentile 0.95
            '99' = Get-Percentile -Values $Durations -Percentile 0.99
        }
        LongestQueuedJobs = $LongestQueuedJobs | Select-Object @{l='QueuedDuration'; e={$_.queuedDuration}}, Uri
    } | New-WrapperObject 'Gitlab.RunnerStats' -PreserveCasing
}
