BeforeAll {
    $TestModuleName = "Search"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Search.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][Alias('HttpMethod')][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [hashtable]$Query,
            [uint]$MaxPages
        )
        @()
    }
    function global:New-GitlabObject {
        param(
            [Parameter(ValueFromPipeline)]$InputObject,
            [Parameter(Position=0)][string]$DisplayType
        )
        process { $InputObject }
    }
    function global:Get-FilteredObject {
        param(
            [Parameter(ValueFromPipeline)]$InputObject,
            [Parameter(Position=0)][string]$Select
        )
        process { $InputObject }
    }
}

Describe "Search-Gitlab" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    Context "Page size" {
        It "Should request a single page of 100 by default" {
            Search-Gitlab 'needle'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.per_page -eq 100 -and $MaxPages -eq 1
            }
        }

        It "Should request pages of 100 with -All" {
            Search-Gitlab 'needle' -All

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.per_page -eq 100 -and $MaxPages -gt 1
            }
        }

        It "Should request a single page of <MaxResults> when -MaxResults is <MaxResults>" -TestCases @(
            @{ MaxResults = 1 }
            @{ MaxResults = 20 }
            @{ MaxResults = 50 }
            @{ MaxResults = 99 }
        ) {
            Search-Gitlab 'needle' -MaxResults $MaxResults

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.per_page -eq $MaxResults -and $MaxPages -eq 1
            }
        }

        It "Should request pages of 100 when -MaxResults is over 100" {
            Search-Gitlab 'needle' -MaxResults 300

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.per_page -eq 100 -and $MaxPages -eq 3
            }
        }

        It "Should reject -MaxResults 0" {
            { Search-Gitlab 'needle' -MaxResults 0 } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
    }
}
