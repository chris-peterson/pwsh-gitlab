BeforeAll {
    $TestModuleName = "Projects"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Validations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ObjectHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Projects.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [hashtable]$Body
        )
        [PSCustomObject]@{ id = 123 }
    }
}

Describe "Update-GitlabProject" {
    BeforeEach {
        Mock -CommandName Get-GitlabProject -ModuleName $TestModuleName -MockWith {
            [PSCustomObject]@{ Id = 123; PathWithNamespace = 'mygroup/myproject' }
        }
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
            [PSCustomObject]@{ id = 123 }
        }
    }

    It "Should send wiki_access_level when -WikiAccessLevel is specified" {
        Update-GitlabProject -ProjectId 'mygroup/myproject' -WikiAccessLevel 'disabled'

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'PUT' -and $Path -eq 'projects/123' -and $Body.wiki_access_level -eq 'disabled'
        }
    }

    It "Should omit wiki_access_level when -WikiAccessLevel is not specified" {
        Update-GitlabProject -ProjectId 'mygroup/myproject' -Name 'renamed'

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            -not $Body.ContainsKey('wiki_access_level')
        }
    }

    It "Should reject an invalid -WikiAccessLevel" {
        { Update-GitlabProject -ProjectId 'mygroup/myproject' -WikiAccessLevel 'off' } | Should -Throw
    }
}
