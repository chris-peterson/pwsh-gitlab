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
