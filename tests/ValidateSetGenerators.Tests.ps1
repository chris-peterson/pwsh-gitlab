BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/ValidateSetGenerators.ps1
}

Describe 'ValidateSetGenerators' {

    Context 'VisibilityLevel' {
        It 'Should return expected visibility values' {
            $generator = [VisibilityLevel]::new()
            $values = $generator.GetValidValues()
            
            $values | Should -Contain 'private'
            $values | Should -Contain 'internal'
            $values | Should -Contain 'public'
            $values.Count | Should -Be 3
        }

        It 'Should be usable in ValidateSet attribute' {
            $generator = [VisibilityLevel]::new()
            $generator | Should -BeOfType [System.Management.Automation.IValidateSetValuesGenerator]
        }
    }

    Context 'SupportedIntegrations' {
        It 'Should return expected Slack integration types' {
            $generator = [SupportedIntegrations]::new()
            $values = $generator.GetValidValues()
            
            $values | Should -Contain 'slack'
            $values | Should -Contain 'gitlab-slack-application'
            $values.Count | Should -Be 2
        }
    }

    Context 'SlackNotificationEvent' {
        It 'Should return all expected Slack notification events' {
            $generator = [SlackNotificationEvent]::new()
            $values = $generator.GetValidValues()
            
            $expectedEvents = @(
                'alert', 'commit', 'confidential_issue', 'confidential_note',
                'deployment', 'issue', 'merge_request', 'note', 'pipeline',
                'push', 'tag_push', 'vulnerability', 'wiki_page'
            )
            
            foreach ($event in $expectedEvents) {
                $values | Should -Contain $event
            }
            $values.Count | Should -Be 13
        }

        It 'Should include alert event (regression test for #70)' {
            $generator = [SlackNotificationEvent]::new()
            $values = $generator.GetValidValues()
            
            $values | Should -Contain 'alert'
        }
    }

    Context 'SortDirection' {
        It 'Should return expected sort directions' {
            $generator = [SortDirection]::new()
            $values = $generator.GetValidValues()
            
            $values | Should -Contain 'asc'
            $values | Should -Contain 'desc'
            $values.Count | Should -Be 2
        }
    }

    Context 'VariableType' {
        It 'Should return expected variable types' {
            $generator = [VariableType]::new()
            $values = $generator.GetValidValues()
            
            $values | Should -Contain 'env_var'
            $values | Should -Contain 'file'
            $values.Count | Should -Be 2
        }
    }

    Context 'GitlabTimezone' {
        It 'Should return a large number of timezone values' {
            $generator = [GitlabTimezone]::new()
            $values = $generator.GetValidValues()
            
            $values.Count | Should -BeGreaterThan 400
        }

        It 'Should include common timezones' {
            $generator = [GitlabTimezone]::new()
            $values = $generator.GetValidValues()
            
            $values | Should -Contain 'UTC'
            $values | Should -Contain 'America/New_York'
            $values | Should -Contain 'America/Los_Angeles'
            $values | Should -Contain 'Europe/London'
            $values | Should -Contain 'Asia/Tokyo'
        }
    }

}
