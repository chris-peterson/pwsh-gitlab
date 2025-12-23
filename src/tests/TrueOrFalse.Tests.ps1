BeforeAll {
    . $PSScriptRoot/../GitlabCli/Private/Transformations.ps1

    function Test-TrueOrFalseRequired {
        param (
            [Parameter(Mandatory)]
            [TrueOrFalse()][bool] $Value
        )
        $Value
    }

    function Test-TrueOrFalseOptional {
        param (
            [Parameter()]
            [TrueOrFalse()][bool] $Value
        )
        if ($PSBoundParameters.ContainsKey('Value')) {
            $Value
        } else {
            $null
        }
    }
}

Describe "TrueOrFalse Attribute" {

    Context "String 'true'" {
        It "Should convert to boolean True" {
            Test-TrueOrFalseRequired -Value 'true' | Should -BeTrue
        }

        It "Should be of type Boolean" {
            (Test-TrueOrFalseRequired -Value 'true').GetType().Name | Should -Be 'Boolean'
        }
    }

    Context "String 'false'" {
        It "Should convert to boolean False" {
            Test-TrueOrFalseRequired -Value 'false' | Should -BeFalse
        }

        It "Should be of type Boolean" {
            (Test-TrueOrFalseRequired -Value 'false').GetType().Name | Should -Be 'Boolean'
        }
    }

    Context "Boolean passthrough" {
        It "Should pass through `$true" {
            Test-TrueOrFalseRequired -Value $true | Should -BeTrue
        }

        It "Should pass through `$false" {
            Test-TrueOrFalseRequired -Value $false | Should -BeFalse
        }
    }

    Context "Case insensitivity" {
        It "Should accept 'True'" {
            Test-TrueOrFalseRequired -Value 'True' | Should -BeTrue
        }

        It "Should accept 'TRUE'" {
            Test-TrueOrFalseRequired -Value 'TRUE' | Should -BeTrue
        }

        It "Should accept 'False'" {
            Test-TrueOrFalseRequired -Value 'False' | Should -BeFalse
        }

        It "Should accept 'FALSE'" {
            Test-TrueOrFalseRequired -Value 'FALSE' | Should -BeFalse
        }

        It "Should accept mixed case 'tRuE'" {
            Test-TrueOrFalseRequired -Value 'tRuE' | Should -BeTrue
        }

        It "Should accept mixed case 'fAlSe'" {
            Test-TrueOrFalseRequired -Value 'fAlSe' | Should -BeFalse
        }
    }

    Context "Invalid inputs" {
        It "Should throw for 'chicken'" {
            { Test-TrueOrFalseRequired -Value 'chicken' } | Should -Throw "*Cannot convert 'chicken' to boolean*"
        }

        It "Should throw for 'yes'" {
            { Test-TrueOrFalseRequired -Value 'yes' } | Should -Throw "*Cannot convert 'yes' to boolean*"
        }

        It "Should throw for 'no'" {
            { Test-TrueOrFalseRequired -Value 'no' } | Should -Throw "*Cannot convert 'no' to boolean*"
        }

        It "Should throw for integer 1" {
            { Test-TrueOrFalseRequired -Value 1 } | Should -Throw "*Cannot convert '1' to boolean*"
        }

        It "Should throw for integer 0" {
            { Test-TrueOrFalseRequired -Value 0 } | Should -Throw "*Cannot convert '0' to boolean*"
        }

        It "Should throw for empty string" {
            { Test-TrueOrFalseRequired -Value '' } | Should -Throw "*Cannot convert '' to boolean*"
        }
    }

    Context "Optional parameter" {
        It "Should work when provided 'true'" {
            Test-TrueOrFalseOptional -Value 'true' | Should -BeTrue
        }

        It "Should work when provided 'false'" {
            Test-TrueOrFalseOptional -Value 'false' | Should -BeFalse
        }

        It "Should return null when omitted" {
            Test-TrueOrFalseOptional | Should -BeNullOrEmpty
        }
    }
}
