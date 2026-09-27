BeforeAll {
    $TestModuleName = "Notes"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Notes.psm1" -Raw
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

Describe "Get-GitlabIssueNote" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should GET the issue notes endpoint" {
        Get-GitlabIssueNote -ProjectId '123' -IssueId '7'

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq 'projects/123/issues/7/notes'
        }
    }

    It "Should GET a single note when -NoteId is specified" {
        Get-GitlabIssueNote -ProjectId '123' -IssueId '7' -NoteId '42'

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq 'projects/123/issues/7/notes/42'
        }
    }
}

Describe "Update-GitlabIssueNote" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should PUT to the issue note endpoint" {
        Update-GitlabIssueNote -ProjectId '123' -IssueId '7' -NoteId '42' -Note 'Updated' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'PUT' -and $Path -eq 'projects/123/issues/7/notes/42' -and $Body.body -eq 'Updated'
        }
    }

    It "Should not call the API when -WhatIf is specified" {
        Update-GitlabIssueNote -ProjectId '123' -IssueId '7' -NoteId '42' -Note 'Updated' -WhatIf

        Should -Not -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    }
}

Describe "Remove-GitlabIssueNote" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should DELETE the issue note endpoint" {
        Remove-GitlabIssueNote -ProjectId '123' -IssueId '7' -NoteId '42' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'DELETE' -and $Path -eq 'projects/123/issues/7/notes/42'
        }
    }

    It "Should not call the API when -WhatIf is specified" {
        Remove-GitlabIssueNote -ProjectId '123' -IssueId '7' -NoteId '42' -WhatIf

        Should -Not -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    }
}

Describe "New-GitlabMergeRequestNote" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should POST to the merge request notes endpoint" {
        New-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -Note 'Looks good' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'POST' -and $Path -eq 'projects/123/merge_requests/7/notes'
        }
    }

    It "Should send the note text as the body" {
        New-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -Note 'Looks good' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Body.body -eq 'Looks good'
        }
    }

    It "Should not call the API when -WhatIf is specified" {
        New-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -Note 'Looks good' -WhatIf

        Should -Not -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    }

    It "Should support the Add-GitlabMergeRequestNote alias" {
        Add-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -Note 'Looks good' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'POST' -and $Path -eq 'projects/123/merge_requests/7/notes'
        }
    }
}

Describe "Update-GitlabMergeRequestNote" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should PUT to the merge request note endpoint" {
        Update-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -NoteId '42' -Note 'Updated' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'PUT' -and $Path -eq 'projects/123/merge_requests/7/notes/42' -and $Body.body -eq 'Updated'
        }
    }

    It "Should not call the API when -WhatIf is specified" {
        Update-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -NoteId '42' -Note 'Updated' -WhatIf

        Should -Not -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    }
}

Describe "Remove-GitlabMergeRequestNote" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should DELETE the merge request note endpoint" {
        Remove-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -NoteId '42' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'DELETE' -and $Path -eq 'projects/123/merge_requests/7/notes/42'
        }
    }

    It "Should not call the API when -WhatIf is specified" {
        Remove-GitlabMergeRequestNote -ProjectId '123' -MergeRequestId '7' -NoteId '42' -WhatIf

        Should -Not -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    }
}
