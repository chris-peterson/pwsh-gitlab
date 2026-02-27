BeforeAll {
    $TestModuleName = "Projects"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    # Dot-source class definitions first — PowerShell classes used as parameter
    # attributes (e.g. [GitlabDate()]) must be registered in the type system
    # before [scriptblock]::Create() parses function signatures that reference them.
    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ObjectHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/CacheHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Projects.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [Parameter(Position=2)][hashtable]$Query,
            [uint]$MaxPages
        )
        @()
    }
    function global:Get-FilteredObject {
        param(
            [Parameter(ValueFromPipeline)]$InputObject,
            [Parameter(Position=0)][string]$Select = '*'
        )
        process { $InputObject }
    }
    function global:Get-GitlabGroup {
        param([Parameter(Position=0)][string]$GroupId)
        [PSCustomObject]@{
            Id = 456
            FullPath = 'mygroup'
            Name = 'MyGroup'
        }
    }
    function global:Get-LocalGitContext {
        [PSCustomObject]@{ Project = 'default-project' }
    }
    function global:Get-GitlabResourceFromUrl {
        param([Parameter(ValueFromPipeline)][string]$Url)
        [PSCustomObject]@{ ProjectId = '123'; ResourceId = '1' }
    }
    function global:Resolve-GitlabSite {
        param([string]$SiteUrl)
        [PSCustomObject]@{ Url = 'https://gitlab.com' }
    }
    function global:Set-ProjectIdInCache {
        param($ProjectPath, $ProjectId, $ResolvedSiteUrl)
        # No-op for tests
    }
    
    # Override Save-ProjectToCache from CacheHelpers to just pass through
    function global:Save-ProjectToCache {
        param([Parameter(ValueFromPipeline)]$Project)
        process { $Project }
    }
}

Describe "Get-GitlabProject" {

    Context "ByGroup parameter set - basic functionality" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @(
                    [PSCustomObject]@{
                        id = 1
                        name = 'project-a'
                        path_with_namespace = 'mygroup/project-a'
                    },
                    [PSCustomObject]@{
                        id = 2
                        name = 'project-b'
                        path_with_namespace = 'mygroup/project-b'
                    }
                )
            }
        }

        It "Should use the correct API endpoint with group ID" {
            Get-GitlabProject -GroupId 'mygroup'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Method -eq 'GET' -and $Path -eq 'groups/456/projects'
            }
        }

        It "Should set include_subgroups to false by default" {
            Get-GitlabProject -GroupId 'mygroup'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['include_subgroups'] -eq 'false'
            }
        }

        It "Should set archived to false by default" {
            Get-GitlabProject -GroupId 'mygroup'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['archived'] -eq 'false'
            }
        }

        It "Should return filtered and sorted projects" {
            $Result = Get-GitlabProject -GroupId 'mygroup'

            $Result | Should -HaveCount 2
            $Result[0].name | Should -Be 'project-a'
            $Result[1].name | Should -Be 'project-b'
        }
    }

    Context "ByGroup parameter set - with -Recurse" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should set include_subgroups to true when -Recurse is specified" {
            Get-GitlabProject -GroupId 'mygroup' -Recurse

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['include_subgroups'] -eq 'true'
            }
        }
    }

    Context "ByGroup parameter set - with -Search" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should add search parameter to query" {
            Get-GitlabProject -GroupId 'mygroup' -Search 'test'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['search'] -eq 'test'
            }
        }

        It "Should handle search with special characters" {
            Get-GitlabProject -GroupId 'mygroup' -Search '-db'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['search'] -eq '-db'
            }
        }
    }

    Context "ByGroup parameter set - with -IncludeArchived" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should not set archived parameter when -IncludeArchived is specified" {
            Get-GitlabProject -GroupId 'mygroup' -IncludeArchived

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $null -eq $Query['archived']
            }
        }
    }

    Context "ByGroup parameter set - filtering by path_with_namespace" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @(
                    [PSCustomObject]@{
                        id = 1
                        name = 'project-a'
                        path_with_namespace = 'mygroup/project-a'
                    },
                    [PSCustomObject]@{
                        id = 2
                        name = 'project-b'
                        path_with_namespace = 'othergroup/project-b'
                    },
                    [PSCustomObject]@{
                        id = 3
                        name = 'project-c'
                        path_with_namespace = 'mygroup/subgroup/project-c'
                    }
                )
            }
        }

        It "Should filter projects to only those matching the group's FullPath" {
            $Result = Get-GitlabProject -GroupId 'mygroup'

            $Result | Should -HaveCount 2
            $Result[0].PathWithNamespace | Should -Be 'mygroup/project-a'
            $Result[1].PathWithNamespace | Should -Be 'mygroup/subgroup/project-c'
        }

        It "Should exclude projects from other groups" {
            $Result = Get-GitlabProject -GroupId 'mygroup'

            $Result.PathWithNamespace | Should -Not -Contain 'othergroup/project-b'
        }
    }

    Context "ByGroup parameter set - sorting" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @(
                    [PSCustomObject]@{
                        id = 3
                        name = 'zebra-project'
                        path_with_namespace = 'mygroup/zebra-project'
                    },
                    [PSCustomObject]@{
                        id = 1
                        name = 'alpha-project'
                        path_with_namespace = 'mygroup/alpha-project'
                    },
                    [PSCustomObject]@{
                        id = 2
                        name = 'beta-project'
                        path_with_namespace = 'mygroup/beta-project'
                    }
                )
            }
        }

        It "Should sort projects by Name" {
            $Result = Get-GitlabProject -GroupId 'mygroup'

            $Result | Should -HaveCount 3
            $Result[0].Name | Should -Be 'alpha-project'
            $Result[1].Name | Should -Be 'beta-project'
            $Result[2].Name | Should -Be 'zebra-project'
        }
    }

    Context "ByGroup parameter set - combined parameters" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should handle -Recurse and -Search together" {
            Get-GitlabProject -GroupId 'mygroup' -Recurse -Search 'api'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['include_subgroups'] -eq 'true' -and $Query['search'] -eq 'api'
            }
        }

        It "Should handle -Recurse, -Search, and -IncludeArchived together" {
            Get-GitlabProject -GroupId 'mygroup' -Recurse -Search 'api' -IncludeArchived

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Query['include_subgroups'] -eq 'true' -and 
                $Query['search'] -eq 'api' -and 
                $null -eq $Query['archived']
            }
        }
    }

    Context "ByGroup parameter set - MaxPages parameter" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @()
            }
        }

        It "Should pass MaxPages to Invoke-GitlabApi" {
            Get-GitlabProject -GroupId 'mygroup' -MaxPages 5

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $MaxPages -eq 5
            }
        }
    }
}
