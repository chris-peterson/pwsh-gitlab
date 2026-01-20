BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1
}

Describe "ConvertTo-PascalCase" {

    Context "Basic conversions" {
        It "Should convert snake_case to PascalCase" {
            'hello_world' | ConvertTo-PascalCase | Should -Be 'HelloWorld'
        }

        It "Should convert single word" {
            'hello' | ConvertTo-PascalCase | Should -Be 'Hello'
        }

        It "Should handle multiple underscores" {
            'one_two_three_four' | ConvertTo-PascalCase | Should -Be 'OneTwoThreeFour'
        }

        It "Should preserve leading underscore" {
            '_private_field' | ConvertTo-PascalCase | Should -Be '_privateField'
        }

        It "Should handle uppercase input" {
            'HELLO_WORLD' | ConvertTo-PascalCase | Should -Be 'HelloWorld'
        }

        It "Should handle mixed case input" {
            'Hello_World' | ConvertTo-PascalCase | Should -Be 'HelloWorld'
        }
    }

    Context "Pipeline support" {
        It "Should process multiple values from pipeline" {
            $Results = @('first_name', 'last_name', 'email_address') | ConvertTo-PascalCase
            $Results | Should -HaveCount 3
            $Results[0] | Should -Be 'FirstName'
            $Results[1] | Should -Be 'LastName'
            $Results[2] | Should -Be 'EmailAddress'
        }
    }

    Context "Hashtable conversions" {
        It "Should convert hashtable keys to PascalCase" {
            $Input = @{ first_name = 'John'; last_name = 'Doe' }
            $Result = $Input | ConvertTo-PascalCase
            $Result.Keys | Should -Contain 'FirstName'
            $Result.Keys | Should -Contain 'LastName'
            $Result.FirstName | Should -Be 'John'
            $Result.LastName | Should -Be 'Doe'
        }

        It "Should preserve values when converting hashtable" {
            $Input = @{ my_key = 123 }
            $Result = $Input | ConvertTo-PascalCase
            $Result.MyKey | Should -Be 123
        }
    }

    Context "Positional parameter" {
        It "Should accept value as positional parameter" {
            ConvertTo-PascalCase 'test_value' | Should -Be 'TestValue'
        }
    }
}

Describe "ConvertTo-SnakeCase" {

    Context "String conversions" {
        It "Should convert PascalCase to snake_case" {
            'HelloWorld' | ConvertTo-SnakeCase | Should -Be 'hello_world'
        }

        It "Should convert camelCase to snake_case" {
            'helloWorld' | ConvertTo-SnakeCase | Should -Be 'hello_world'
        }

        It "Should handle single word" {
            'Hello' | ConvertTo-SnakeCase | Should -Be 'hello'
        }

        It "Should handle multiple capitals" {
            'OneTwoThreeFour' | ConvertTo-SnakeCase | Should -Be 'one_two_three_four'
        }

        It "Should handle already lowercase" {
            'already' | ConvertTo-SnakeCase | Should -Be 'already'
        }
    }

    Context "Hashtable conversions" {
        It "Should convert hashtable keys to snake_case" {
            $Input = @{ FirstName = 'John'; LastName = 'Doe' }
            $Result = $Input | ConvertTo-SnakeCase
            $Result.Keys | Should -Contain 'first_name'
            $Result.Keys | Should -Contain 'last_name'
            $Result.first_name | Should -Be 'John'
            $Result.last_name | Should -Be 'Doe'
        }

        It "Should preserve values when converting hashtable" {
            $Input = @{ MyKey = 123 }
            $Result = $Input | ConvertTo-SnakeCase
            $Result.my_key | Should -Be 123
        }
    }

    Context "Pipeline support" {
        It "Should process multiple strings from pipeline" {
            $Results = @('FirstName', 'LastName') | ConvertTo-SnakeCase
            $Results | Should -HaveCount 2
            $Results[0] | Should -Be 'first_name'
            $Results[1] | Should -Be 'last_name'
        }
    }

    Context "Positional parameter" {
        It "Should accept value as positional parameter" {
            ConvertTo-SnakeCase 'TestValue' | Should -Be 'test_value'
        }
    }
}

Describe "ConvertTo-UrlEncoded" {

    Context "Basic encoding" {
        It "Should encode spaces" {
            'hello world' | ConvertTo-UrlEncoded | Should -Be 'hello%20world'
        }

        It "Should encode special characters" {
            'foo/bar' | ConvertTo-UrlEncoded | Should -Be 'foo%2Fbar'
        }

        It "Should encode ampersand" {
            'a&b' | ConvertTo-UrlEncoded | Should -Be 'a%26b'
        }

        It "Should encode equals sign" {
            'key=value' | ConvertTo-UrlEncoded | Should -Be 'key%3Dvalue'
        }

        It "Should not encode alphanumeric" {
            'abc123' | ConvertTo-UrlEncoded | Should -Be 'abc123'
        }

        It "Should handle empty string" {
            '' | ConvertTo-UrlEncoded | Should -Be ''
        }
    }

    Context "Pipeline support" {
        It "Should process multiple values from pipeline" {
            $Results = @('hello world', 'foo/bar') | ConvertTo-UrlEncoded
            $Results | Should -HaveCount 2
            $Results[0] | Should -Be 'hello%20world'
            $Results[1] | Should -Be 'foo%2Fbar'
        }
    }

    Context "Positional parameter" {
        It "Should accept value as positional parameter" {
            ConvertTo-UrlEncoded 'test value' | Should -Be 'test%20value'
        }
    }
}
