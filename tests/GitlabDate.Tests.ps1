BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    function Test-GitlabDateRequired {
        param (
            [Parameter(Mandatory)]
            [GitlabDate()][string] $Value
        )
        $Value
    }

    function Test-GitlabDateOptional {
        param (
            [Parameter()]
            [GitlabDate()][string] $Value
        )
        if ($PSBoundParameters.ContainsKey('Value')) {
            $Value
        } else {
            $null
        }
    }
}

Describe "GitlabDate Attribute" {

    Context "DateTime input" {
        It "Should convert DateTime to YYYY-MM-DD string" {
            $date = [datetime]::new(2024, 12, 25)
            Test-GitlabDateRequired -Value $date | Should -Be '2024-12-25'
        }

        It "Should be of type String" {
            $date = [datetime]::new(2024, 12, 25)
            (Test-GitlabDateRequired -Value $date).GetType().Name | Should -Be 'String'
        }

        It "Should handle single digit month and day with zero padding" {
            $date = [datetime]::new(2024, 1, 5)
            Test-GitlabDateRequired -Value $date | Should -Be '2024-01-05'
        }
    }

    Context "YYYY-MM-DD string passthrough" {
        It "Should pass through valid YYYY-MM-DD format" {
            Test-GitlabDateRequired -Value '2024-12-25' | Should -Be '2024-12-25'
        }

        It "Should pass through first day of year" {
            Test-GitlabDateRequired -Value '2024-01-01' | Should -Be '2024-01-01'
        }

        It "Should pass through last day of year" {
            Test-GitlabDateRequired -Value '2024-12-31' | Should -Be '2024-12-31'
        }
    }

    Context "Parseable date strings" {
        It "Should convert MM/DD/YYYY format" {
            Test-GitlabDateRequired -Value '12/25/2024' | Should -Be '2024-12-25'
        }

        It "Should convert ISO 8601 datetime format" {
            Test-GitlabDateRequired -Value '2024-12-25T10:30:00' | Should -Be '2024-12-25'
        }

        It "Should convert long date format" {
            Test-GitlabDateRequired -Value 'December 25, 2024' | Should -Be '2024-12-25'
        }
    }

    Context "Invalid inputs" {
        It "Should throw for unparseable string" {
            { Test-GitlabDateRequired -Value 'not-a-date' } | Should -Throw "*Cannot convert 'not-a-date' to GitLab date format*"
        }

        It "Should throw for random text" {
            { Test-GitlabDateRequired -Value 'chicken' } | Should -Throw "*Cannot convert 'chicken' to GitLab date format*"
        }

        It "Should throw for numeric value" {
            { Test-GitlabDateRequired -Value 12345 } | Should -Throw "*Cannot convert '12345' to GitLab date format*"
        }
    }

    Context "Optional parameter behavior" {
        It "Should return null when not provided" {
            Test-GitlabDateOptional | Should -BeNullOrEmpty
        }

        It "Should transform when provided" {
            $date = [datetime]::new(2024, 6, 15)
            Test-GitlabDateOptional -Value $date | Should -Be '2024-06-15'
        }
    }
}
