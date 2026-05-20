BeforeAll {
    $TestModuleName = "MergeRequests"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ObjectHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/MergeRequests.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [hashtable]$Query,
            [uint]$MaxPages
        )
        @{}
    }
    function global:Resolve-GitlabProjectId {
        param([Parameter(Position=0)][string]$ProjectId)
        return $ProjectId
    }
}

Describe "Get-GitlabMergeRequestApprovalRule" {

    Context "Project parameter set (default)" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                @(
                    [PSCustomObject]@{ id = 5; name = 'Ruby'; rule_type = 'regular'; approvals_required = 2 }
                )
            }
        }

        It "Should GET projects/<id>/approval_rules" {
            Get-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject'

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Method -eq 'GET' -and $Path -eq 'projects/mygroup/myproject/approval_rules'
            }
        }

        It "Should hit the single-rule path when -ApprovalRuleId is provided" {
            Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -ApprovalRuleId 5

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Path -eq 'projects/p/q/approval_rules/5'
            }
        }

        It "Should tag rows with Gitlab.MergeRequestApprovalRule" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q'

            $result.PSTypeNames | Should -Contain 'Gitlab.MergeRequestApprovalRule'
        }

        It "Should decorate rows with ProjectId" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q'

            $result.ProjectId | Should -Be 'p/q'
        }
    }

    Context "MergeRequest parameter set" {
        BeforeEach {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                [PSCustomObject]@{
                    approval_rules_overwritten = $true
                    rules = @(
                        [PSCustomObject]@{
                            id                 = 1
                            name               = 'src/api/**'
                            rule_type          = 'code_owner'
                            section            = 'codeowners'
                            approvals_required = 1
                            approved           = $false
                            users              = @()
                            groups             = @()
                            approved_by        = @()
                            eligible_approvers = @()
                            code_owner         = $true
                        },
                        [PSCustomObject]@{
                            id                 = 2
                            name               = 'Regular reviewers'
                            rule_type          = 'regular'
                            approvals_required = 2
                            approved           = $true
                            users              = @()
                            groups             = @()
                            approved_by        = @()
                            eligible_approvers = @()
                            code_owner         = $false
                        }
                    )
                }
            }
        }

        It "Should GET projects/<id>/merge_requests/<iid>/approval_state when -MergeRequestId is set" {
            Get-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject' -MergeRequestId 42

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Method -eq 'GET' -and $Path -eq 'projects/mygroup/myproject/merge_requests/42/approval_state'
            }
        }

        It "Should resolve ProjectId via Resolve-GitlabProjectId" {
            Mock -CommandName Resolve-GitlabProjectId -ModuleName $TestModuleName -MockWith { 'resolved/path' }

            Get-GitlabMergeRequestApprovalRule -ProjectId '.' -MergeRequestId 7

            Should -Invoke -CommandName Resolve-GitlabProjectId -ModuleName $TestModuleName
            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Path -eq 'projects/resolved/path/merge_requests/7/approval_state'
            }
        }

        It "Should accept the -Iid alias for MergeRequestId" {
            Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -Iid 9

            Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Path -eq 'projects/p/q/merge_requests/9/approval_state'
            }
        }

        It "Should emit one object per synthesized rule" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -MergeRequestId 1

            $result.Count | Should -Be 2
        }

        It "Should convert rule properties to PascalCase" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -MergeRequestId 1

            $result[0].Name              | Should -Be 'src/api/**'
            $result[0].RuleType          | Should -Be 'code_owner'
            $result[0].Section           | Should -Be 'codeowners'
            $result[0].ApprovalsRequired | Should -Be 1
            $result[0].CodeOwner         | Should -BeTrue
        }

        It "Should decorate each row with ProjectId, MergeRequestId, ApprovalRulesOverwritten" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -MergeRequestId 42

            $result | ForEach-Object {
                $_.ProjectId                | Should -Be 'p/q'
                $_.MergeRequestId           | Should -Be '42'
                $_.ApprovalRulesOverwritten | Should -BeTrue
            }
        }

        It "Should tag rows with Gitlab.MergeRequestApprovalRuleState (not the project type)" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -MergeRequestId 1

            $result[0].PSTypeNames | Should -Contain 'Gitlab.MergeRequestApprovalRuleState'
            $result[0].PSTypeNames | Should -Not -Contain 'Gitlab.MergeRequestApprovalRule'
        }

        It "Should filter to code_owner rules via the pipeline" {
            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -MergeRequestId 1 |
                Where-Object RuleType -eq 'code_owner'

            $result.Count   | Should -Be 1
            $result[0].Name | Should -Be 'src/api/**'
        }

        It "Should emit nothing when the MR has no synthesized rules" {
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                [PSCustomObject]@{ approval_rules_overwritten = $false; rules = @() }
            }

            $result = Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -MergeRequestId 1

            @($result).Count | Should -Be 0
        }
    }

    Context "Parameter set selection" {
        It "Should reject -ApprovalRuleId and -MergeRequestId together" {
            { Get-GitlabMergeRequestApprovalRule -ProjectId 'p/q' -ApprovalRuleId 5 -MergeRequestId 42 } |
                Should -Throw
        }
    }
}
