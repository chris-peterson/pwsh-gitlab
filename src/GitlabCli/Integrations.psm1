function Get-GitlabProjectIntegration {

    [CmdletBinding()]
    [OutputType('Gitlab.ProjectIntegration')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [ValidateSet($null, 'assana', 'assembla', 'bamboo', 'bugzilla', 'buildkite', 'campfire', 'datadog', 'unify-circuit', 'pumble', 'webex-teams', 'custom-issue-tracker', 'discord', 'drone-ci', 'emails-on-push', 'ewm', 'confluence', 'external-wiki', 'flowdock', 'github', 'hangouts-chat', 'irker', 'jira', 'slack-slash-commands', 'mattermost-slash-commands', 'packagist', 'pipelines-email', 'pivotaltracker', 'prometheus', 'pushover', 'redmine', 'slack', 'gitlab-slack-application', 'microsoft-teams', 'mattermost', 'teamcity', 'jenkins', 'jenkins-deprecated', 'mock-ci', 'youtrack')]
        [string]
        $Integration,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Resource = "projects/$ProjectId/integrations"
    if ($Integration) {
        $Resource += "/$Integration"
    }
    # https://docs.gitlab.com/ee/api/integrations.html#list-all-active-integrations
    Invoke-GitlabApi GET $Resource |
        New-GitlabObject 'Gitlab.ProjectIntegration' |
        Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $ProjectId -PassThru
}

function Update-GitlabProjectIntegration {

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.ProjectIntegration')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Slug')]
        [ValidateSet('slack', 'gitlab-slack-application')]
        [string]
        $Integration,

        # NOTE: generally we don't want accept raw API semantics, but given each integration is modeled differently...
        [Parameter(Position=1, Mandatory)]
        [hashtable]
        $Settings,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    # https://docs.gitlab.com/api/project_integrations
    $Resource = "projects/$($Project.Id)/integrations/$Integration"

    if ($PSCmdlet.ShouldProcess("$Resource", "update $($Settings | ConvertTo-Json)")) {
        Invoke-GitlabApi PUT $Resource -Body $Settings | New-GitlabObject 'Gitlab.ProjectIntegration'
    }
}

function Remove-GitlabProjectIntegration {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Slug')]
        [ValidateSet('slack', 'gitlab-slack-application')]
        [string]
        $Integration,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    # https://docs.gitlab.com/api/project_integrations
    $Resource = "projects/$($Project.Id)/integrations/$Integration"

    if ($PSCmdlet.ShouldProcess("$Resource", "delete integration")) {
        Invoke-GitlabApi DELETE $Resource -Body $Settings | Out-Null
        Write-Host "Deleted $Integration integration from $($Project.PathWithNamespace)"
    }
}

# wraps Update-GitlabProjectIntegration but with an interface tailored for Slack
# defaults to newer 'gitlab-slack-application' integration.  for legacy support, use 'slack'
# https://docs.gitlab.com/api/project_integrations/#gitlab-for-slack-app
# https://docs.gitlab.com/api/project_integrations/#slack-notifications
function Enable-GitlabProjectSlackNotification {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='SpecificEvents')]
    [OutputType('Gitlab.ProjectIntegration')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, ParameterSetName='SpecificEvents')]
        [Parameter(Mandatory, ParameterSetName='AllEvents')]
        [string]
        $Channel,

        [Parameter()]
        [string]
        $Webhook,

        [Parameter()]
        [string]
        $Username,

        [Parameter()]
        [string]
        [ValidateSet('all', 'default', 'protected', 'default_and_protected')]
        $BranchesToBeNotified = 'default_and_protected',

        [Parameter()]
        [TrueOrFalse()][bool]
        $NotifyOnlyBrokenPipelines,

        [Parameter()]
        [TrueOrFalse()][bool]
        $JobEvents,

        [Parameter(ParameterSetName='SpecificEvents')]
        [ValidateSet('alert', 'commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')]
        [string []]
        $Enable,

        [Parameter(ParameterSetName='SpecificEvents')]
        [ValidateSet('alert', 'commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')]
        [string []]
        $Disable,

        [Parameter(ParameterSetName='AllEvents')]
        [switch]
        $AllEvents,

        [Parameter(ParameterSetName='NoEvents')]
        [switch]
        $NoEvents,

        [Parameter()]
        [ValidateSet('slack', 'gitlab-slack-application')]
        [string]
        $Integration = 'gitlab-slack-application',

        [Parameter()]
        [string]
        $SiteUrl
    )
    $ProjectId = Resolve-GitlabProjectId $ProjectId
    if ($Integration -eq 'slack') {
        Write-Warning "The 'slack' integration is deprecated.  Should use 'gitlab-slack-application' instead."
    }

    $KnownEvents = @('alert', 'commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')
    if ($AllEvents) {
        $Enable = $KnownEvents
    }
    if ($NoEvents) {
        $Disable = $KnownEvents
    }

    $Settings = @{
        # this seems to be necessary in all cases, otherwise the settings don't "stick"
        use_inherited_settings = 'false'
    }
    if ($Webhook) {
        $Settings.webhook = $Webhook
    }
    if ($Username) {
        $Settings.username = $Username
    }
    if ($BranchesToBeNotified) {
        $Settings.branches_to_be_notified = $BranchesToBeNotified
    }
    if ($PSBoundParameters.ContainsKey('NotifyOnlyBrokenPipelines')) {
        $Settings.notify_only_broken_pipelines = $NotifyOnlyBrokenPipelines
    }
    if ($PSBoundParameters.ContainsKey('JobEvents')) {
        $Settings.job_events = $JobEvents
    }

    $ShouldPluralize = @(
        'confidential_issue',
        'issue',
        'merge_request'
    )

    if ($Enable) {
        $Enable | ForEach-Object {
            $Settings."$_`_channel"  = $Channel
            $EventProperty           = $ShouldPluralize.Contains($_) ? "$($_)s_events" : "$($_)_events"
            $Settings.$EventProperty = 'true'
        }
    }
    if ($Disable) {
        $Disable | ForEach-Object {
            $Settings."$_`_channel"  = ''
            $EventProperty           = $ShouldPluralize.Contains($_) ? "$($_)s_events" : "$($_)_events"
            $Settings.$EventProperty = 'false'
        }
    }

    $Action = 'enable'

    $ExistingLegacyIntegration = $null
    try {
        $ExistingLegacyIntegration = Get-GitlabProjectIntegration -ProjectId $ProjectId -Integration 'slack' | Select-Object -Expand Active
        if ($ExistingLegacyIntegration) {
            $Action = 'disable legacy integration, then enable'
        }
    } catch {}

    if ($PSCmdlet.ShouldProcess("$Action slack notifications for $ProjectId", "notify $Channel ($($Settings | ConvertTo-Json)))")) {
        if ($ExistingLegacyIntegration) {
            Remove-GitlabProjectIntegration -ProjectId $ProjectId -Integration 'slack'
        }
        Update-GitlabProjectIntegration -ProjectId $ProjectId -Integration $Integration -Settings $Settings
    }
}
