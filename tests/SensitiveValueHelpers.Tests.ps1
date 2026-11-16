BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/SensitiveValueHelpers.ps1
}

Describe "Hide-GitlabSensitiveValues" {

    Context "Credential-like keys" {

        It "Should redact an Authorization header" {
            $Request = @{
                Method = 'POST'
                Uri    = 'https://gitlab.example.com/api/v4/projects/1/hooks'
                Header = @{ Accept = 'application/json'; Authorization = 'Bearer glpat-SuperSecret123' }
            }

            $Json = $Request | Hide-GitlabSensitiveValues | ConvertTo-Json -Depth 5

            $Json | Should -Not -Match 'glpat-SuperSecret123'
            $Display = $Json | ConvertFrom-Json
            $Display.Header.Authorization | Should -Be '********'
            $Display.Header.Accept        | Should -Be 'application/json'
            $Display.Uri                  | Should -Be 'https://gitlab.example.com/api/v4/projects/1/hooks'
        }

        It "Should redact <Key>" -ForEach @(
            @{ Key = 'token' }
            @{ Key = 'runners_token' }
            @{ Key = 'password' }
            @{ Key = 'secret' }
            @{ Key = 'api_key' }
            @{ Key = 'webhook' }
        ) {
            (@{ $Key = 'sensitive' } | Hide-GitlabSensitiveValues).$Key | Should -Be '********'
        }

        It "Should not redact keys that merely contain a sensitive word" {
            (@{ token_expires_at = '2026-12-01' } | Hide-GitlabSensitiveValues).token_expires_at | Should -Be '2026-12-01'
        }

        It "Should leave empty values alone" {
            (@{ token = '' } | Hide-GitlabSensitiveValues).token | Should -Be ''
        }

        It "Should redact nested values" {
            $Result = @{ outer = @{ secret = 's3cr3t'; name = 'x' } } | Hide-GitlabSensitiveValues

            $Result.outer.secret | Should -Be '********'
            $Result.outer.name   | Should -Be 'x'
        }

        It "Should redact values inside arrays" {
            $Result = @{ items = @(@{ password = 'p1' }, @{ password = 'p2' }) } | Hide-GitlabSensitiveValues

            $Result.items | Should -HaveCount 2
            $Result.items[0].password | Should -Be '********'
            $Result.items[1].password | Should -Be '********'
        }
    }

    Context "Masked variables" {

        It "Should redact the value of a masked variable" {
            $Result = @{ key = 'DB_PASS'; value = 'p@ss'; masked = $true } | Hide-GitlabSensitiveValues

            $Result.value | Should -Be '********'
            $Result.key   | Should -Be 'DB_PASS'
        }

        It "Should show the value of an unmasked variable" {
            (@{ key = 'REGION'; value = 'us-west-2'; masked = $false } | Hide-GitlabSensitiveValues).value | Should -Be 'us-west-2'
        }

        It "Should redact an unmasked variable whose key looks like a secret" {
            $Result = @{ key = 'DEPLOY_TOKEN'; value = 'glpat-123'; masked = $false } | Hide-GitlabSensitiveValues

            $Result.value | Should -Be '********'
            $Result.key   | Should -Be 'DEPLOY_TOKEN'
        }

        It "Should redact hidden variables" {
            (@{ value = 'p@ss'; masked_and_hidden = $true } | Hide-GitlabSensitiveValues).value | Should -Be '********'
        }
    }

    Context "API responses" {

        It "Should redact a new access token" {
            $Response = '{"id": 42, "name": "ci", "token": "glpat-NEW", "token_expires_at": null}' | ConvertFrom-Json

            $Result = $Response | Hide-GitlabSensitiveValues

            $Result.token | Should -Be '********'
            $Result.id    | Should -Be 42
            $Result.name  | Should -Be 'ci'
        }

        It "Should redact masked variable values in a list" {
            $Response = '[{"key": "A", "value": "secret-a", "masked": true}, {"key": "B", "value": "plain-b", "masked": false}]' | ConvertFrom-Json

            $Json = $Response | Hide-GitlabSensitiveValues | ConvertTo-Json

            $Json | Should -Not -Match 'secret-a'
            $Json | Should -Match 'plain-b'
        }

        It "Should leave string properties intact" {
            $Response = '{"project": {"runners_token": "GR-123", "path": "group/project"}}' | ConvertFrom-Json

            $Result = $Response | Hide-GitlabSensitiveValues

            $Result.project.runners_token | Should -Be '********'
            $Result.project.path          | Should -Be 'group/project'
        }
    }

    Context "Input is never modified" {

        It "Should not modify a hashtable" {
            $Request = @{ Header = @{ Authorization = 'Bearer glpat-SuperSecret123' }; token = 'hook-secret' }

            $Request | Hide-GitlabSensitiveValues | Out-Null

            $Request.Header.Authorization | Should -Be 'Bearer glpat-SuperSecret123'
            $Request.token                | Should -Be 'hook-secret'
        }

        It "Should not modify a response object" {
            $Response = '{"token": "glpat-NEW"}' | ConvertFrom-Json

            $Response | Hide-GitlabSensitiveValues | Out-Null

            $Response.token | Should -Be 'glpat-NEW'
        }
    }
}

Describe "Test-GitlabSensitiveVariable" {

    It "Should treat <Key> as sensitive" -ForEach @(
        @{ Key = 'CI_TOKEN' }
        @{ Key = 'app_secret' }
        @{ Key = 'DB_PASSWORD' }
        @{ Key = 'FTP_PASSWD' }
        @{ Key = 'SSH_KEY' }
        @{ Key = 'AWS_CREDENTIALS' }
        @{ Key = 'PRIVATE_URL' }
    ) {
        Test-GitlabSensitiveVariable ([PSCustomObject]@{ key = $Key; value = 'v' }).PSObject.Properties | Should -BeTrue
    }

    It "Should treat <Key> as not sensitive" -ForEach @(
        @{ Key = 'REGION' }
        @{ Key = 'IMAGE_TAG' }
    ) {
        Test-GitlabSensitiveVariable ([PSCustomObject]@{ key = $Key; value = 'v' }).PSObject.Properties | Should -BeFalse
    }

    It "Should treat a <Flag> variable as sensitive" -ForEach @(
        @{ Flag = 'Masked' }
        @{ Flag = 'Hidden' }
    ) {
        Test-GitlabSensitiveVariable ([PSCustomObject]@{ Key = 'REGION'; Value = 'v'; $Flag = $true }).PSObject.Properties | Should -BeTrue
    }
}

Describe "Add-GitlabDisplayProperty" {

    It "Should hide a sensitive value and keep Value intact" {
        $Variable = [PSCustomObject]@{ Key = 'DEPLOY_TOKEN'; Value = 'glpat-123'; Masked = $false }

        $Variable | Add-GitlabDisplayProperty -Name Value

        $Variable.DisplayValue | Should -Be '********'
        $Variable.Value         | Should -Be 'glpat-123'
    }

    It "Should show a non-sensitive value" {
        $Variable = [PSCustomObject]@{ Key = 'REGION'; Value = 'us-west-2'; Masked = $false }

        $Variable | Add-GitlabDisplayProperty -Name Value

        $Variable.DisplayValue | Should -Be 'us-west-2'
    }

    It "Should follow changes made after it was added" {
        $Variable = [PSCustomObject]@{ Key = 'REGION'; Value = 'us-west-2'; Masked = $false }
        $Variable | Add-GitlabDisplayProperty -Name Value

        $Variable.Masked = $true

        $Variable.DisplayValue | Should -Be '********'
    }
}
