function Get-GitlabProjectIntegration {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$false)]
        [ValidateSet($null, 'assana', 'assembla', 'bamboo', 'bugzilla', 'buildkite', 'campfire', 'datadog', 'unify-circuit', 'pumble', 'webex-teams', 'custom-issue-tracker', 'discord', 'drone-ci', 'emails-on-push', 'ewm', 'confluence', 'external-wiki', 'flowdock', 'github', 'hangouts-chat', 'irker', 'jira', 'slack-slash-commands', 'mattermost-slash-commands', 'packagist', 'pipelines-email', 'pivotaltracker', 'prometheus', 'pushover', 'redmine', 'slack', 'microsoft-teams', 'mattermost', 'teamcity', 'jenkins', 'jenkins-deprecated', 'mock-ci', 'youtrack')]
        [string]
        $Integration,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

    $Resource = "projects/$($Project.Id)/integrations"
    if ($Integration) {
        $Resource += "/$Integration"
    }
    Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProjectIntegration'
}
