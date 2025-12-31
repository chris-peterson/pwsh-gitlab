function Get-GitlabPipelineSchedule {

    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [OutputType('Gitlab.PipelineSchedule')]
    [Alias('schedule')]
    [Alias('schedules')]
    param (
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='ByPipelineScheduleId')]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='ByPipelineScheduleId', Mandatory)]
        [Alias('Id')]
        [int]
        $PipelineScheduleId,

        [Parameter(ParameterSetName='ByProjectId')]
        [string]
        [ValidateSet('active', 'inactive')]
        $Scope,

        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [switch]
        $IncludeVariables,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'GET'
        # https://docs.gitlab.com/ee/api/pipeline_schedules.html#get-all-pipeline-schedules
        Path       = "projects/$($Project.Id)/pipeline_schedules"
        Query      = @{}
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByPipelineScheduleId {
            $GitlabApiArguments.Path += "/$PipelineScheduleId"
        }
        ByProjectId {
            if($Scope) {
                $GitlabApiArguments.Query.scope = $Scope
            }
        }
        default { throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"}
    }

    $Wrapper = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject 'Gitlab.PipelineSchedule'
    $Wrapper | Add-Member -NotePropertyMembers @{ Project = $Project }

    if ($IncludeVariables) {
        # only returned by the single schedule API so have to fetch them individually
        # (https://docs.gitlab.com/ee/api/pipeline_schedules.html#get-a-single-pipeline-schedule)
        $Wrapper = $Wrapper | ForEach-Object { Get-GitlabPipelineSchedule -ProjectId $_.ProjectId -PipelineScheduleId $_.Id }
    }

    $Wrapper | Sort-Object NextRunAtSortable
}

# https://docs.gitlab.com/ee/api/pipeline_schedules.html#create-a-new-pipeline-schedule
function New-GitlabPipelineSchedule {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineSchedule')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Branch')]
        [string]
        $Ref = '.',

        [Parameter(Mandatory)]
        [string]
        $Description,

        [Parameter(Mandatory)]
        [string]
        $Cron,

        [Parameter()]
        [ValidateSet([GitlabTimezone])]
        [string]
        $CronTimezone = 'UTC',

        [Parameter()]
        [TrueOrFalse()][bool]
        $Active,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Body = @{
        ref           = Resolve-GitlabBranch $Ref
        description   = $Description
        cron          = $Cron
        cron_timezone = $CronTimezone
    }
    if ($PSBoundParameters.ContainsKey('Active')) {
        $Body.active = $Active
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "create new schedule $($Body | ConvertTo-Json)")) {

        $GitlabApiArguments = @{
            HttpMethod = 'POST'
            Path       = "projects/$($Project.Id)/pipeline_schedules"
            Body       = $Body
        }
        $Wrapper = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject 'Gitlab.PipelineSchedule'
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId
        $Wrapper
    }
}

function Update-GitlabPipelineSchedule {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineSchedule')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $PipelineScheduleId,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $Cron,

        [Parameter()]
        [ValidateSet([GitlabTimezone])]
        [string]
        $CronTimezone,

        [Parameter()]
        [TrueOrFalse()][bool]
        $Active,

        [Parameter()]
        [string]
        $NewOwner,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/pipeline_schedules.html#edit-a-pipeline-schedule
    $GitlabApiArguments = @{
        HttpMethod = 'PUT'
        Path       = "projects/$ProjectId/pipeline_schedules/$PipelineScheduleId"
        Body       = @{}
    }

    if ($PSBoundParameters.ContainsKey('Active')) {
        $GitlabApiArguments.Body.active = $Active
    }
    if ($Description) {
        $GitlabApiArguments.Body.description = $Description
    }
    if ($Ref) {
        $GitlabApiArguments.Body.ref = Resolve-GitlabBranch $Ref
    }
    if ($Cron) {
        $GitlabApiArguments.Body.cron = $Cron
    }
    if ($CronTimezone) {
        $GitlabApiArguments.Body.cron_timezone = $CronTimezone
    }

    if ($GitlabApiArguments.Body.Count -gt 0) {
        if ($PSCmdlet.ShouldProcess("$($GitlabApiArguments.Path)", "update schedule $($GitlabApiArguments.Body | ConvertTo-Json)")) {
            Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject 'Gitlab.PipelineSchedule'
        }
    }

    if ($NewOwner) {
        if ($PSCmdlet.ShouldProcess("project $ProjectId", "transfer ownership of pipeline schedule $PipelineScheduleId to $NewOwner")) {
            $Owner = Get-GitlabUser $NewOwner
            Start-GitlabUserImpersonation -UserId $Owner.Id
            # https://docs.gitlab.com/ee/api/pipeline_schedules.html#take-ownership-of-a-pipeline-schedule
            Invoke-GitlabApi POST "projects/$ProjectId/pipeline_schedules/$PipelineScheduleId/take_ownership" | Out-Null
            Write-Host "Ownership of pipeline schedule $PipelineScheduleId transferred to $($Owner.Username)"
            Stop-GitlabUserImpersonation
        }
    }
}

function Enable-GitlabPipelineSchedule {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineSchedule')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $PipelineScheduleId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "enable pipeline schedule $PipelineScheduleId")) {
        Update-GitlabPipelineSchedule -ProjectId $ProjectId -PipelineScheduleId $PipelineScheduleId -Active true
    }
}

function Disable-GitlabPipelineSchedule {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineSchedule')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $PipelineScheduleId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "disable pipeline schedule $PipelineScheduleId")) {
        Update-GitlabPipelineSchedule -ProjectId $ProjectId -PipelineScheduleId $PipelineScheduleId -Active false
    }
}

# https://docs.gitlab.com/ee/api/pipeline_schedules.html#delete-a-pipeline-schedule
function Remove-GitlabPipelineSchedule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $PipelineScheduleId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'DELETE'
        Path       = "projects/$ProjectId/pipeline_schedules/$PipelineScheduleId"
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId schedule #$PipelineScheduleId", "delete pipeline schedule")) {
        Invoke-GitlabApi @GitlabApiArguments
    }
}

#https://docs.gitlab.com/ee/api/pipeline_schedules.html#pipeline-schedule-variables
# This behavior isn't part of the api, but a nested structure on getting a PipelineSchedule itself JUST by Id
function Get-GitlabPipelineScheduleVariable {
    [CmdletBinding()]
    [OutputType('Gitlab.PipelineScheduleVariable')]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId="." ,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]
        $PipelineScheduleId,

        [Parameter(Mandatory=$false)]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId
    $PipelineSchedule = Get-GitlabPipelineSchedule -ProjectId $ProjectId -PipelineScheduleId $PipelineScheduleId

    $Wrapper = $PipelineSchedule.Variables | New-GitlabObject "Gitlab.PipelineScheduleVariable"
    $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId
    $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'PipelineScheduleId' -Value $PipelineSchedule.Id

    if($Key) {
        $Wrapper = $Wrapper | Where-Object { $_.Key -eq $Key }
    }

    $Wrapper
}

function New-GitlabPipelineScheduleVariable {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineScheduleVariable')]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId="." ,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]
        $PipelineScheduleId,

        [Parameter(Mandatory=$true)]
        [ValidatePattern("[A-Za-z0-9_]")]
        [string]
        $Key,

        [Parameter(Mandatory=$true)]
        [string]
        $Value,

        [Parameter(Mandatory=$false)]
        [ValidateSet([VariableType])]
        [string]
        $VariableType="env_var",

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId
    $PipelineSchedule = Get-GitlabPipelineSchedule -ProjectId $ProjectId -PipelineScheduleId $PipelineScheduleId

    $Body = @{
        "key"           = $Key
        "value"         = $Value
        "variable_type" = $VariableType
    }

    $GitlabApiArguments = @{
        HttpMethod = "POST"
        Path       = "projects/$ProjectId/pipeline_schedules/$($PipelineSchedule.Id)/variables"
        Body       = $Body
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId schedule #$PipelineScheduleId", "create variable '$Key'")) {
        $Wrapper = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject "Gitlab.PipelineScheduleVariable"
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'PipelineScheduleId' -Value $PipelineSchedule.Id
        $Wrapper
    }
}

function Update-GitlabPipelineScheduleVariable {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.PipelineScheduleVariable')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        $PipelineScheduleId,

        [Parameter(Mandatory)]
        [ValidateLength(1, 255)]
        [ValidatePattern('[A-Za-z0-9_]')]
        [string]
        $Key,

        [Parameter(Mandatory)]
        [string]
        $Value,

        [Parameter()]
        [ValidateSet([VariableType])]
        [string]
        $VariableType = 'env_var',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId
    $PipelineSchedule = Get-GitlabPipelineSchedule -ProjectId $ProjectId -PipelineScheduleId $PipelineScheduleId

    $Body = @{
        "key"           = $Key
        "value"         = $Value
        "variable_type" = $VariableType
    }

    $GitlabApiArguments = @{
        HttpMethod = "PUT"
        Path       = "projects/$ProjectId/pipeline_schedules/$($PipelineSchedule.Id)/variables/$($Key)"
        Body       = $Body
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId schedule #$PipelineScheduleId", "update variable '$Key'")) {
        $Wrapper = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject "Gitlab.PipelineScheduleVariable"
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'PipelineScheduleId' -Value $PipelineSchedule.Id
        $Wrapper
    }
}

function Remove-GitlabPipelineScheduleVariable {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType('Gitlab.PipelineScheduleVariable')]
    param (
        [Parameter()]
        [string]
        $ProjectId="." ,

        [Parameter(Mandatory)]
        [int]
        $PipelineScheduleId,

        [Parameter(Mandatory)]
        [string]
        $Key,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId
    $PipelineSchedule = Get-GitlabPipelineSchedule -ProjectId $ProjectId -PipelineScheduleId $PipelineScheduleId


    $GitlabApiArguments = @{
        HttpMethod = "DELETE"
        Path       = "projects/$ProjectId/pipeline_schedules/$($PipelineSchedule.Id)/variables/$($Key)"
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId schedule #$PipelineScheduleId", "delete variable '$Key'")) {
        $Wrapper = Invoke-GitlabApi @GitlabApiArguments | New-GitlabObject "Gitlab.PipelineScheduleVariable"
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId
        $Wrapper | Add-Member -MemberType 'NoteProperty' -Name 'PipelineScheduleId' -Value $PipelineSchedule.Id
        $Wrapper
    }
}

# https://docs.gitlab.com/ee/api/pipeline_schedules.html#run-a-scheduled-pipeline-immediately
function New-GitlabScheduledPipeline {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]
        $PipelineScheduleId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'POST'
        Path       = "projects/$ProjectId/pipeline_schedules/$PipelineScheduleId/play"
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId schedule #$PipelineScheduleId", "run scheduled pipeline")) {
        Invoke-GitlabApi @GitlabApiArguments | Select-Object -ExpandProperty 'message'
    }
}
