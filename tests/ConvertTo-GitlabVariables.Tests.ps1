BeforeAll {
    $TestModuleName = "Variables"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        (Get-Content "$PSScriptRoot/../src/GitlabCli/Variables.psm1" -Raw)))) -Force
}

Describe "ConvertTo-GitlabVariables" {
    It "Converts a hashtable to an array of key/value entries" {
        $Result = @{ FOO = 'bar' } | ConvertTo-GitlabVariables

        @($Result).Count | Should -Be 1
        $Result[0].key   | Should -Be 'FOO'
        $Result[0].value | Should -Be 'bar'
    }

    It "Returns an array even for a single-entry hashtable (no unrolling)" {
        $Result = @{ ONLY = 'one' } | ConvertTo-GitlabVariables

        # If the function unrolls, $Result is a single hashtable, not an array.
        $Result -is [System.Collections.IList] | Should -BeTrue
    }

    It "Adds variable_type when -Type is supplied" {
        $Result = @{ DEPLOY_ENV = 'staging' } | ConvertTo-GitlabVariables -Type 'env_var'

        $Result[0].variable_type | Should -Be 'env_var'
    }

    It "Converts multi-key hashtables to multiple entries" {
        $Result = @{ A = '1'; B = '2' } | ConvertTo-GitlabVariables

        @($Result).Count | Should -Be 2
        ($Result | ForEach-Object { $_.key } | Sort-Object) -join ',' | Should -Be 'A,B'
    }

    It "Converts a PSCustomObject to an array of entries" {
        $Result = [pscustomobject]@{ KEY1 = 'v1'; KEY2 = 'v2' } | ConvertTo-GitlabVariables

        @($Result).Count | Should -Be 2
    }

    It "Returns an empty array when given no input" {
        $Result = $null | ConvertTo-GitlabVariables

        @($Result).Count | Should -Be 0
    }

    It "Throws on unsupported input types" {
        { 'just-a-string' | ConvertTo-GitlabVariables } | Should -Throw "*Unsupported type*"
    }
}
