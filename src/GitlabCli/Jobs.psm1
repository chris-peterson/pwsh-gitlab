
function Get-GitlabJob {
    [Alias('job')]
    [Alias('jobs')]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='ByJobId', Mandatory=$false)]
        [Parameter(ParameterSetName='ByProjectId', Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ByPipeline', Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='ByPipeline', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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
        $IncludeTrace,

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
        HttpMethod="GET"
        Query=@{}
        Path = "projects/$ProjectId/jobs"
        SiteUrl = $SiteUrl
    }

    if ($PipelineId) {
        $GitlabApiArguments.Path = "projects/$ProjectId/pipelines/$PipelineId/jobs"
    }
    if ($JobId) {
        $GitlabApiArguments.Path = "projects/$ProjectId/jobs/$JobId"
    }

    if ($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }
    if ($IncludeRetried) {
        $GitlabApiArguments['Query']['include_retried'] = $true
    }

    $Jobs = Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Job'

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
                $Trace = $_ | Get-GitlabJobTrace -WhatIf:$WhatIf
            }
            catch {
                $Trace = $Null
            }
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'Trace' -Value $Trace
        }
    }

    $Jobs
}


function Get-GitlabJobTrace {
    [Alias('trace')]
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $JobId,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod = "POST"
        Path       = "projects/$ProjectId/jobs/$JobId/play"
        SiteUrl    = $SiteUrl
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

function Test-GitlabPipelineDefinition {

    [CmdletBinding(DefaultParameterSetName='Project')]
    param (
        [Parameter(Mandatory=$false, ParameterSetName='Project')]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ParameterSetName='Content')]
        [string]
        $Content,

        [Parameter(Mandatory=$false)]
        [string]
        $Select = '*',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId
    $ProjectId = $Project.Id

    $Params = @{
        Body    = @{}
        Query   = @{}
        SiteUrl = $SiteUrl
        WhatIf  = $WhatIf
    }

    switch ($PSCmdlet.ParameterSetName) {
        Content {
            if (Test-Path $Content) {
                $Content = Get-Content -Raw -Path $Content
            }
            # https://docs.gitlab.com/ee/api/lint.html#validate-the-ci-yaml-configuration
            $Params.HttpMethod                = 'POST'
            $Params.Path                      = 'ci/lint'
            $Params.Body.content              = $Content
            $Params.Query.include_merged_yaml = 'true'
        }
        Default {
            # https://docs.gitlab.com/ee/api/lint.html#validate-a-projects-ci-configuration
            $Params.HttpMethod = 'GET'
            $Params.Path = "projects/$ProjectId/ci/lint"
        }
    }

    $Result = Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.PipelineDefinition'
    if ($Select -eq '*') {
        $Result
    } elseif ($Select.Contains(',')) {
        $Result | Select-Object $($Select -split ',')
    } else {
        $Result | Select-Object -ExpandProperty $Select
    }
}

function Get-GitlabPipelineDefinition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Get-GitlabRepositoryYmlFileContent -ProjectId $ProjectId -FilePath '.gitlab-ci.yml' -Ref $Ref -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
