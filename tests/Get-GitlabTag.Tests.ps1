BeforeAll {
    $TestModuleName = "Tags"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Tags.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [hashtable]$Query,
            [hashtable]$Body,
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
    function global:Resolve-GitlabProjectId {
        param([Parameter(Position=0)][string]$ProjectId)
        return $ProjectId
    }
}

Describe "Get-GitlabTag" {
    Context "List tags" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
        }

        It "Should use repository tags endpoint" {
            Get-GitlabTag -ProjectId '123'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Path -eq 'projects/123/repository/tags'
            }
        }

        It "Should pass search parameter" {
            Get-GitlabTag -ProjectId '123' -Search 'v1'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.search -eq 'v1'
            }
        }
    }

    Context "Get single tag" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
        }

        It "Should append tag name to path" {
            Get-GitlabTag -ProjectId '123' -Name 'v1.0.0'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Path -eq 'projects/123/repository/tags/v1.0.0'
            }
        }
    }
}

Describe "New-GitlabTag" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should POST to repository tags endpoint" {
        New-GitlabTag -ProjectId '123' -Name 'v1.0.0' -Ref 'main' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'POST' -and $Path -eq 'projects/123/repository/tags'
        }
    }
}

Describe "Remove-GitlabTag" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should DELETE the tag" {
        Remove-GitlabTag -ProjectId '123' -Name 'v1.0.0' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'DELETE' -and $Path -eq 'projects/123/repository/tags/v1.0.0'
        }
    }
}
