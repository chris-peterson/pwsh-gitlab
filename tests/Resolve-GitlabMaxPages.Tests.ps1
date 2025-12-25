BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Globals.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1
}

Describe "Resolve-GitlabMaxPages" {

    Context "When neither MaxPages nor All is specified" {
        It "Should return the global default" {
            $Result = Resolve-GitlabMaxPages
            $Result | Should -Be $global:GitlabDefaultMaxPages
        }
    }

    Context "When MaxPages is 0" {
        It "Should return the global default" {
            $Result = Resolve-GitlabMaxPages -MaxPages 0
            $Result | Should -Be $global:GitlabDefaultMaxPages
        }
    }

    Context "When MaxPages is specified" {
        It "Should return the specified value" {
            $Result = Resolve-GitlabMaxPages -MaxPages 5
            $Result | Should -Be 5
        }

        It "Should return large values" {
            $Result = Resolve-GitlabMaxPages -MaxPages 100
            $Result | Should -Be 100
        }
    }

    Context "When -All is specified" {
        It "Should return uint max value" {
            $Result = Resolve-GitlabMaxPages -All
            $Result | Should -Be ([uint]::MaxValue)
        }

        It "Should ignore MaxPages when -All is specified" {
            $Result = Resolve-GitlabMaxPages -MaxPages 5 -All
            $Result | Should -Be ([uint]::MaxValue)
        }

        It "Should warn when MaxPages differs from default and -All is specified" {
            $Result = Resolve-GitlabMaxPages -MaxPages 5 -All -WarningVariable warnings -WarningAction SilentlyContinue
            $warnings | Should -Match "Ignoring -MaxPages in favor of -All"
        }

        It "Should not warn when MaxPages equals default and -All is specified" {
            $Result = Resolve-GitlabMaxPages -MaxPages $global:GitlabDefaultMaxPages -All -WarningVariable warnings -WarningAction SilentlyContinue
            $warnings | Should -BeNullOrEmpty
        }
    }

    Context "When -Recurse is specified" {
        It "Should return uint max value (implies -All)" {
            $Result = Resolve-GitlabMaxPages -Recurse
            $Result | Should -Be ([uint]::MaxValue)
        }

        It "Should ignore MaxPages when -Recurse is specified" {
            $Result = Resolve-GitlabMaxPages -MaxPages 5 -Recurse
            $Result | Should -Be ([uint]::MaxValue)
        }

        It "Should warn when MaxPages differs from default and -Recurse is specified" {
            $Result = Resolve-GitlabMaxPages -MaxPages 5 -Recurse -WarningVariable warnings -WarningAction SilentlyContinue
            $warnings | Should -Match "Ignoring -MaxPages in favor of -All"
        }

        It "Should work the same with both -Recurse and -All" {
            $Result = Resolve-GitlabMaxPages -Recurse -All
            $Result | Should -Be ([uint]::MaxValue)
        }
    }

    Context "Return type" {
        It "Should return uint type" {
            $Result = Resolve-GitlabMaxPages -MaxPages 10
            $Result | Should -BeOfType [uint]
        }
    }
}
