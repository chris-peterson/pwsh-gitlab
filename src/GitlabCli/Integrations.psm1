# https://docs.gitlab.com/ee/api/integrations.html#list-all-active-integrations
function Get-GitlabProjectIntegration {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [ValidateSet($null, 'assana', 'assembla', 'bamboo', 'bugzilla', 'buildkite', 'campfire', 'datadog', 'unify-circuit', 'pumble', 'webex-teams', 'custom-issue-tracker', 'discord', 'drone-ci', 'emails-on-push', 'ewm', 'confluence', 'external-wiki', 'flowdock', 'github', 'hangouts-chat', 'irker', 'jira', 'slack-slash-commands', 'mattermost-slash-commands', 'packagist', 'pipelines-email', 'pivotaltracker', 'prometheus', 'pushover', 'redmine', 'slack', 'microsoft-teams', 'mattermost', 'teamcity', 'jenkins', 'jenkins-deprecated', 'mock-ci', 'youtrack')]
        [string]
        $Integration,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

    $Resource = "projects/$($Project.Id)/integrations"
    if ($Integration) {
        $Resource += "/$Integration"
    }
    Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl |
        New-WrapperObject 'Gitlab.ProjectIntegration' |
        Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $Project.Id -PassThru
}

function Update-GitlabProjectIntegration {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Slug')]
        [ValidateSet('slack')]
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

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

    $Resource = "projects/$($Project.Id)/integrations/$Integration"

    if ($PSCmdlet.ShouldProcess("$Resource", "update $($Settings | ConvertTo-Json)")) {
        Invoke-GitlabApi PUT $Resource -Body $Settings -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.ProjectIntegration'
    }
}

function Remove-GitlabProjectIntegration {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Slug')]
        [ValidateSet('slack')]
        [string]
        $Integration,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

    $Resource = "projects/$($Project.Id)/integrations/$Integration"

    if ($PSCmdlet.ShouldProcess("$Resource", "delete integration")) {
        Invoke-GitlabApi DELETE $Resource -Body $Settings -SiteUrl $SiteUrl | Out-Null
        Write-Host "Deleted $Integration integration from $($Project.PathWithNamespace)"
    }
}

# wraps Update-GitlabProjectIntegration but with an interface tailored for Slack
# https://docs.gitlab.com/ee/api/integrations.html#createedit-slack-integration
function Enable-GitlabProjectSlackNotification {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='SpecificEvents')]
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
        [string]
        [ValidateSet($null, 'true', 'false')]
        $NotifyOnlyBrokenPipelines,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [string]
        $JobEvents,

        [Parameter(ParameterSetName='SpecificEvents')]
        [ValidateSet('commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')]
        [string []]
        $Enable,

        [Parameter(ParameterSetName='SpecificEvents')]
        [ValidateSet('commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')]
        [string []]
        $Disable,

        [Parameter(ParameterSetName='AllEvents')]
        [switch]
        $AllEvents,

        [Parameter(ParameterSetName='NoEvents')]
        [switch]
        $NoEvents,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

    $KnownEvents = @('commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')
    if ($AllEvents) {
        $Enable = $KnownEvents
    }
    if ($NoEvents) {
        $Disable = $KnownEvents
    }

    if (-not $Webhook) {
        try {
            $Webhook = $(Get-GitlabProjectIntegration -ProjectId $Project.Id -Integration 'slack').Properties.webhook
        }
        catch {
            throw "Webhook could not be derived from an existing integration (provide via -Webhook parameter)"
        }
    }

    $Settings = @{
        webhook = $Webhook
    }
    if ($PSBoundParameters.ContainsKey('Username')) {
        $Settings.username = $Username
    }
    if ($BranchesToBeNotified) {
        $Settings.branches_to_be_notified = $BranchesToBeNotified
    }
    if ($NotifyOnlyBrokenPipelines) {
        $Settings.notify_only_broken_pipelines = $NotifyOnlyBrokenPipelines
    }
    if ($JobEvents) {
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

    if ($PSCmdlet.ShouldProcess("slack notifications for $($Project.PathWithNamespace)", "notify $Channel ($($Settings | ConvertTo-Json)))")) {
        Update-GitlabProjectIntegration -ProjectId $Project.Id -Integration 'slack' -Settings $Settings
    }
}
