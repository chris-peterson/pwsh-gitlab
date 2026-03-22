BeforeAll {
    $TestModuleName = "Releases"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Releases.psm1" -Raw
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

Describe "New-GitlabRelease" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should POST to releases endpoint" {
        New-GitlabRelease -ProjectId '123' -TagName 'v1.0.0' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'POST' -and $Path -eq 'projects/123/releases'
        }
    }

    It "Should include description in body" {
        New-GitlabRelease -ProjectId '123' -TagName 'v1.0.0' -Description 'Release notes' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Body.description -eq 'Release notes'
        }
    }
}

Describe "Update-GitlabRelease" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should PUT to release endpoint with tag name" {
        Update-GitlabRelease -ProjectId '123' -TagName 'v1.0.0' -Name 'Updated Release' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'PUT' -and $Path -eq 'projects/123/releases/v1.0.0'
        }
    }
}

Describe "Remove-GitlabRelease" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should DELETE the release" {
        Remove-GitlabRelease -ProjectId '123' -TagName 'v1.0.0' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'DELETE' -and $Path -eq 'projects/123/releases/v1.0.0'
        }
    }
}
