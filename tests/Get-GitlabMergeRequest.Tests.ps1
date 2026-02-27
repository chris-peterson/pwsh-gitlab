BeforeAll {
    $TestModuleName = "MergeRequests"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/MergeRequests.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
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
    function global:Resolve-GitlabProjectId {
        param([Parameter(Position=0)][string]$ProjectId)
        return $ProjectId
    }
    function global:Resolve-GitlabGroupId {
        param([Parameter(Position=0)][string]$GroupId)
        return $GroupId
    }
    function global:Resolve-GitlabBranch {
        param([Parameter(Position=0)][string]$Branch)
        return $Branch
    }
    function global:Get-GitlabCurrentUser {
        [PSCustomObject]@{ Username = 'testuser' }
    }
    function global:Get-GitlabResourceFromUrl {
        param([Parameter(ValueFromPipeline)][string]$Url)
        [PSCustomObject]@{ ProjectId = '123'; ResourceId = '1' }
    }
}

Describe "Get-GitlabMergeRequest" {

    Context "Default parameter values" {
        It "State should default to 'opened'" {
            $Command = Get-Command Get-GitlabMergeRequest
            $Command.Parameters['State'].Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] }) | Should -Not -BeNullOrEmpty
            $Default = (Get-Command Get-GitlabMergeRequest).Parameters['State'].DefaultValue
            # Note: PowerShell metadata doesn't always expose default values this way,
            # so we verify through invocation below
        }

        It "Should send state=opened to the API by default" {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }

            Get-GitlabMergeRequest -Mine

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.state -eq 'opened'
            }
        }

        It "Should send scope=all to the API by default" {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }

            Get-GitlabMergeRequest -Mine

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.scope -eq 'all'
            }
        }
    }

    Context "-Mine parameter set" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should use the global merge_requests endpoint" {
            Get-GitlabMergeRequest -Mine

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Path -eq 'merge_requests'
            }
        }

        It "Should set author_username to the current user" {
            Get-GitlabMergeRequest -Mine

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.author_username -eq 'testuser'
            }
        }
    }

    Context "-State parameter" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should allow overriding state to 'all'" {
            Get-GitlabMergeRequest -Mine -State all

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.state -eq 'all'
            }
        }

        It "Should allow overriding state to 'merged'" {
            Get-GitlabMergeRequest -Mine -State merged

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.state -eq 'merged'
            }
        }
    }

    Context "-Scope parameter" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should allow overriding scope to 'assigned_to_me'" {
            Get-GitlabMergeRequest -Mine -Scope assigned_to_me

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query.scope -eq 'assigned_to_me'
            }
        }
    }
}
