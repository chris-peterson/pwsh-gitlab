BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Globals.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/ObjectHelpers.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Validations.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    function Resolve-GitlabProjectId { param($ProjectId) return 123 }
    function Get-GitlabProject { param($ProjectId) [PSCustomObject]@{ Id = 123; PathWithNamespace = 'group/project' } }
    function Get-GitlabProjectIntegration { param($ProjectId, $Integration) [PSCustomObject]@{ Active = $false } }
    function Remove-GitlabProjectIntegration { param($ProjectId, $Integration) }
    function Update-GitlabProjectIntegration { param($ProjectId, $Integration, $Settings) [PSCustomObject]@{ Active = $true } }
    function Invoke-GitlabApi { param($Method, $Resource, $Body) [PSCustomObject]@{} }

    Import-Module $PSScriptRoot/../src/GitlabCli/Integrations.psm1 -Force
}

Describe 'Enable-GitlabProjectSlackNotification' {

    Context 'KnownEvents array' {
        It 'Should include alert in KnownEvents' {
            $KnownEvents = [SlackNotificationEvent]::new().GetValidValues()
            $KnownEvents | Should -Contain 'alert'
        }

        It 'Should include vulnerability in KnownEvents' {
            $KnownEvents = [SlackNotificationEvent]::new().GetValidValues()
            $KnownEvents | Should -Contain 'vulnerability'
        }

        It 'ValidateSet generator should provide consistent events' {
            $ExpectedEvents = @('alert', 'commit', 'confidential_issue', 'confidential_note', 'deployment', 'issue', 'merge_request', 'note', 'pipeline', 'push', 'tag_push', 'vulnerability', 'wiki_page')
            $KnownEvents = [SlackNotificationEvent]::new().GetValidValues()
            
            $ExpectedEvents | Sort-Object | Should -Be ($KnownEvents | Sort-Object)
        }
    }

    Context 'Event property naming' {
        It 'Should pluralize issue to issues_events' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'issue'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'issues_events'
        }

        It 'Should pluralize merge_request to merge_requests_events' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'merge_request'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'merge_requests_events'
        }

        It 'Should pluralize confidential_issue to confidential_issues_events' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'confidential_issue'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'confidential_issues_events'
        }

        It 'Should NOT pluralize alert' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'alert'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'alert_events'
        }

        It 'Should NOT pluralize vulnerability' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'vulnerability'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'vulnerability_events'
        }

        It 'Should NOT pluralize pipeline' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'pipeline'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'pipeline_events'
        }

        It 'Should NOT pluralize push' {
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            $Event = 'push'
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $EventProperty | Should -Be 'push_events'
        }
    }

    Context 'Settings generation' {
        BeforeEach {
            Mock Update-GitlabProjectIntegration { 
                param($ProjectId, $Integration, $Settings)
                $script:CapturedSettings = $Settings
                [PSCustomObject]@{ Active = $true }
            }
            Mock Get-GitlabProjectIntegration { [PSCustomObject]@{ Active = $false } }
        }

        It 'Should generate correct settings for alert event' {
            $Settings = @{ use_inherited_settings = 'false' }
            $Channel = '#alerts'
            $Event = 'alert'
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            
            $Settings."$Event`_channel" = $Channel
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $Settings.$EventProperty = 'true'

            $Settings.alert_channel | Should -Be '#alerts'
            $Settings.alert_events | Should -Be 'true'
        }

        It 'Should generate correct settings for vulnerability event' {
            $Settings = @{ use_inherited_settings = 'false' }
            $Channel = '#security'
            $Event = 'vulnerability'
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            
            $Settings."$Event`_channel" = $Channel
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $Settings.$EventProperty = 'true'

            $Settings.vulnerability_channel | Should -Be '#security'
            $Settings.vulnerability_events | Should -Be 'true'
        }

        It 'Should generate correct settings for issue event (pluralized)' {
            $Settings = @{ use_inherited_settings = 'false' }
            $Channel = '#issues'
            $Event = 'issue'
            $ShouldPluralize = @('confidential_issue', 'issue', 'merge_request')
            
            $Settings."$Event`_channel" = $Channel
            $EventProperty = $ShouldPluralize.Contains($Event) ? "$($Event)s_events" : "$($Event)_events"
            $Settings.$EventProperty = 'true'

            $Settings.issue_channel | Should -Be '#issues'
            $Settings.issues_events | Should -Be 'true'
        }
    }
}
