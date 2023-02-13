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
    Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.ProjectIntegration'
}

function Update-GitlabProjectIntegration {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory)]
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

        [Parameter(Position=0, Mandatory)]
        [ValidateSet('slack')]
        [string]
        $Integration,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

    $Resource = "projects/$($Project.Id)/integrations/$Integration"

    if ($PSCmdlet.ShouldProcess("$Resource", "delete")) {
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

        [Parameter(Position=0, Mandatory)]
        [string]
        $Channel,

        [Parameter()]
        [string]
        $Webhook,

        [Parameter()]
        [string]
        $Username = '',

        [Parameter()]
        [string]
        [ValidateSet('all', 'default', 'protected', 'default_and_protected')]
        $BranchesToBeNotified = 'default_and_protected',

        [Parameter()]
        [string]
        [ValidateSet('true', 'false')]
        $NotifyOnlyBrokenPipelines = 'true',

        [Parameter()]
        [ValidateSet('true', 'false')]
        [string]
        $JobEvents = 'false',

        [Parameter(ParameterSetName='SpecificEvents', Position=1, Mandatory)]
        [ValidateSet('commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'wiki_page')]
        [string []]
        $OnEvent,

        [Parameter(ParameterSetName='AllEvents')]
        [switch]
        $AllEvents,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

    if ($AllEvents) {
        $OnEvent = @('commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'wiki_page')
    }

    if (-not $Webhook) {
        $ExistingIntegration = $null
        try {
            $ExistingIntegration = Get-GitlabProjectIntegration -ProjectId $Project.Id -Integration 'slack'
            $Webhook = $ExistingIntegration.Properties.webhook
        }
        catch {
            Write-Error "Webhook was not supplied and could not be derived from an existing integration"
        }
    }

    $Settings = @{
        channel                      = $Channel
        webhook                      = $Webhook
        username                     = $Username
        branches_to_be_notified      = $BranchesToBeNotified
        notify_only_broken_pipelines = $NotifyOnlyBrokenPipelines
        job_events                   = $JobEvents
    }

    $OnEvent | ForEach-Object {
        $Settings."$($_)_channel" = $Channel
        $Settings."$($_)_events"   = 'true'
        $Settings."$($_)s_events"  = 'true' # this GitLab API has plurality inconsistencies
    }

    if ($PSCmdlet.ShouldProcess("slack notifications for $($Project.PathWithNamespace)", "notify $Channel on ($($OnEvent -join ', '))")) {
        Update-GitlabProjectIntegration -ProjectId $Project.Id -Integration 'slack' -Settings $Settings
    }
}
