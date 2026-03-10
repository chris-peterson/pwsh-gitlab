BeforeAll {
    $TestModuleName = "Milestones"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Milestones.psm1" -Raw
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
    function global:Invoke-GitlabGraphQL {
        param([string]$Query)
        @{}
    }
}

Describe "New-GitlabMilestone" {
    Context "Project scope" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
        }

        It "Should POST to project milestones endpoint" {
            New-GitlabMilestone -ProjectId '123' -Title 'v1.0' -Confirm:$false

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Method -eq 'POST' -and $Path -eq 'projects/123/milestones'
            }
        }
    }

    Context "Group scope" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
        }

        It "Should POST to group milestones endpoint" {
            New-GitlabMilestone -GroupId '456' -Title 'v1.0' -Confirm:$false

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Method -eq 'POST' -and $Path -eq 'groups/456/milestones'
            }
        }
    }
}

Describe "Update-GitlabMilestone" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should PUT to milestones endpoint" {
        Update-GitlabMilestone -ProjectId '123' -MilestoneId 1 -Title 'v1.1' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'PUT' -and $Path -eq 'projects/123/milestones/1'
        }
    }

    It "Should support state events" {
        Update-GitlabMilestone -ProjectId '123' -MilestoneId 1 -StateEvent 'close' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Body.state_event -eq 'close'
        }
    }
}

Describe "Remove-GitlabMilestone" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should DELETE the milestone" {
        Remove-GitlabMilestone -ProjectId '123' -MilestoneId 1 -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'DELETE' -and $Path -eq 'projects/123/milestones/1'
        }
    }
}
