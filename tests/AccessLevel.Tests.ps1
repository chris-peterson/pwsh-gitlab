BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    function Test-AccessLevel {
        param (
            [Parameter()]
            [AccessLevel()]
            [string]
            $Level
        )
        $Level
    }
}

Describe "AccessLevel Attribute" {

    It "Should leave an unbound parameter empty" {
        Test-AccessLevel | Should -BeNullOrEmpty
    }

    It "Should accept a level name" {
        Test-AccessLevel -Level 'developer' | Should -Be 'developer'
    }

    It "Should translate a numeric level to its name" {
        Test-AccessLevel -Level 40 | Should -Be 'maintainer'
    }

    It "Should reject an unknown level" {
        { Test-AccessLevel -Level 'admin' } | Should -Throw '*Cannot convert*'
    }
}
