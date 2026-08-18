BeforeAll {
    $TestModuleName = "Utilities"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Utilities.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Resolve-GitlabSite {
        param([string]$SiteUrl)
        [PSCustomObject]@{ Url = 'https://gitlab.example.com'; AccessToken = 'token' }
    }

    # Three pages of 20/20/3, the shape that exposed the paging defect: -FollowRelLink
    # returned 39 of the 43 because pages 2 and 3 were fetched without the Authorization
    # header.
    $global:TestPages = @{
        1 = @{ Records = 1..20;  Next = '2' }
        2 = @{ Records = 21..40; Next = '3' }
        3 = @{ Records = 41..43; Next = ''  }
    }
}

AfterAll {
    Remove-Item function:global:Resolve-GitlabSite -ErrorAction SilentlyContinue
    Remove-Variable -Name TestPages -Scope Global -ErrorAction SilentlyContinue
}

Describe 'Invoke-GitlabApi' {

    BeforeEach {
        Mock -ModuleName Utilities Invoke-WebRequest {
            $RequestedPage = 1
            if ($Uri -match 'page=(\d+)') { $RequestedPage = [int]$Matches[1] }
            $Slice = $global:TestPages[$RequestedPage]
            if (-not $Slice) { $Slice = @{ Records = @(); Next = '' } }
            [PSCustomObject]@{
                Content = ($Slice.Records | ForEach-Object { @{ id = $_ } } | ConvertTo-Json)
                Headers = @{
                    'X-Total'     = @('43')
                    'X-Next-Page' = @($Slice.Next)
                }
            }
        }
        Mock -ModuleName Utilities Invoke-RestMethod { @() }
        Mock -ModuleName Utilities Test-PowerShellRelLinkDefect { $true }
    }

    Context 'When the result spans several pages' {
        It 'Returns every record' {
            $Result = Invoke-GitlabApi GET 'groups/1/projects' -MaxPages 100
            $Result.Count | Should -Be 43
        }

        It 'Returns the records that sit at a page boundary' {
            $Ids = Invoke-GitlabApi GET 'groups/1/projects' -MaxPages 100 |
                Select-Object -ExpandProperty id
            21, 22, 23, 24 | ForEach-Object { $Ids | Should -Contain $_ }
        }

        It 'Requests each page once' {
            $null = Invoke-GitlabApi GET 'groups/1/projects' -MaxPages 100
            Should -Invoke -ModuleName Utilities Invoke-WebRequest -Times 3 -Exactly
        }
    }

    Context 'When MaxPages is lower than the number of pages' {
        It 'Stops at MaxPages' {
            $Result = Invoke-GitlabApi GET 'groups/1/projects' -MaxPages 2
            $Result.Count | Should -Be 40
        }
    }

    Context 'When only one page is asked for' {
        It 'Does not walk pages' {
            $null = Invoke-GitlabApi GET 'groups/1/projects'
            Should -Invoke -ModuleName Utilities Invoke-WebRequest -Times 0 -Exactly
            Should -Invoke -ModuleName Utilities Invoke-RestMethod -Times 1 -Exactly `
                -ParameterFilter { $Uri -notmatch 'page=' }
        }
    }

    Context 'When the running PowerShell follows rel links correctly' {
        BeforeEach {
            Mock -ModuleName Utilities Test-PowerShellRelLinkDefect { $false }
        }

        It 'Lets Invoke-RestMethod follow the rel links' {
            $null = Invoke-GitlabApi GET 'groups/1/projects' -MaxPages 100
            Should -Invoke -ModuleName Utilities Invoke-WebRequest -Times 0 -Exactly
            Should -Invoke -ModuleName Utilities Invoke-RestMethod -Times 1 -Exactly `
                -ParameterFilter { $FollowRelLink -and $MaximumFollowRelLink -eq 100 }
        }

        It 'Unwraps the pages Invoke-RestMethod returns' {
            Mock -ModuleName Utilities Invoke-RestMethod {
                1..3 | ForEach-Object { , @(@{ id = $_ }) }
            }
            $Result = Invoke-GitlabApi GET 'groups/1/projects' -MaxPages 100
            $Result.Count | Should -Be 3
        }
    }
}

Describe 'Test-PowerShellRelLinkDefect' {
    It 'Flags <_>, a servicing patch the defect shipped in' -ForEach @(
        '7.4.19', '7.5.10', '7.6.5'
    ) {
        InModuleScope Utilities -Parameters @{ Version = $_ } {
            $PSVersionTable = @{ PSVersion = [Management.Automation.SemanticVersion]$Version }
            Test-PowerShellRelLinkDefect | Should -BeTrue
        }
    }

    It 'Flags <_>, a later patch on an affected line' -ForEach @(
        '7.4.20', '7.5.11', '7.6.6'
    ) {
        InModuleScope Utilities -Parameters @{ Version = $_ } {
            $PSVersionTable = @{ PSVersion = [Management.Automation.SemanticVersion]$Version }
            Test-PowerShellRelLinkDefect | Should -BeTrue
        }
    }

    It 'Clears <_>, which predates the defect on its line' -ForEach @(
        '7.4.18', '7.5.9', '7.6.4', '7.5.0'
    ) {
        InModuleScope Utilities -Parameters @{ Version = $_ } {
            $PSVersionTable = @{ PSVersion = [Management.Automation.SemanticVersion]$Version }
            Test-PowerShellRelLinkDefect | Should -BeFalse
        }
    }

    It 'Clears <_>, a line the defect never landed on' -ForEach @(
        '7.3.12', '7.7.0-preview.2', '7.9.0-preview.1'
    ) {
        InModuleScope Utilities -Parameters @{ Version = $_ } {
            $PSVersionTable = @{ PSVersion = [Management.Automation.SemanticVersion]$Version }
            Test-PowerShellRelLinkDefect | Should -BeFalse
        }
    }
}
