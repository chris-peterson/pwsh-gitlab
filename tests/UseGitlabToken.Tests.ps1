BeforeAll {
  $TestModuleName = "UseGitlabToken"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1
  . $PSScriptRoot/../src/GitlabCli/Private/Validations.ps1
  . $PSScriptRoot/TestHelpers.ps1

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/ServiceAccounts.psm1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Users.psm1" -Raw
    ) -join "`n"))) -Force

  function global:Invoke-GitlabApi {
    param(
      [Parameter(Position=0)][Alias('Method')][string]$HttpMethod,
      [Parameter(Position=1)][string]$Path,
      [hashtable]$Query,
      [hashtable]$Body,
      [uint]$MaxPages
    )
  }
  function global:Resolve-GitlabGroupId { param([string]$GroupId) 18 }
  function global:New-GitlabObject {
    param(
      [Parameter(ValueFromPipeline)]$InputObject,
      [Parameter(Position=0)][string]$DisplayType
    )
    process { $InputObject }
  }
}

Describe "Use-GitlabToken" {
  BeforeEach {
    $global:GitlabUserImpersonationSession = $null
  }

  AfterEach {
    $global:GitlabUserImpersonationSession = $null
  }

  It "Should refuse to start while an impersonation session is active" {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    $global:GitlabUserImpersonationSession = @{ Username = 'someone'; Token = 'x' }
    { Use-GitlabToken -User 'john.doe' { } } | Should -Throw '*already active*'
    { Use-GitlabToken -Token 'glpat-other' { } } | Should -Throw '*already active*'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }

  Context "-User" {
    BeforeEach {
      Mock -CommandName Get-GitlabUser -ModuleName $TestModuleName -ParameterFilter { $Me } -MockWith {
        [PSCustomObject]@{ Id = 1; Username = 'me' }
      }
      Mock -CommandName Get-GitlabUser -ModuleName $TestModuleName -ParameterFilter { -not $Me } -MockWith {
        [PSCustomObject]@{ Id = 42; Username = 'john.doe' }
      }
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'POST' } -MockWith {
        [PSCustomObject]@{ id = 5; user_id = 42; token = 'glpat-SECRET-IMPERSONATION' }
      }
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'DELETE' } -MockWith {}
    }

    It "Should run the block as the user and return its output" {
      $Result = Use-GitlabToken -User 'john.doe' { "as $($global:GitlabUserImpersonationSession.Username)" }
      $Result | Should -Be 'as john.doe'
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
        $HttpMethod -eq 'POST' -and $Path -eq 'users/42/impersonation_tokens'
      }
    }

    It "Should take the user from the pipeline" {
      $Result = [PSCustomObject]@{ PSTypeName = 'Gitlab.User'; Id = 42; Username = 'john.doe' } |
        Use-GitlabToken { $global:GitlabUserImpersonationSession.Token }
      $Result | Should -Be 'glpat-SECRET-IMPERSONATION'
    }

    It "Should revoke the token as the caller after the block" {
      Use-GitlabToken -User 'john.doe' { } | Out-Null
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -ParameterFilter {
        $HttpMethod -eq 'DELETE' -and $Path -eq 'users/42/impersonation_tokens/5'
      }
    }

    It "Should revoke the token when the block throws" {
      { Use-GitlabToken -User 'john.doe' { throw 'block failed' } } | Should -Throw 'block failed'
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -ParameterFilter { $HttpMethod -eq 'DELETE' }
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
    }

    It "Should run the block as the caller when asked to impersonate the caller" {
      Mock -CommandName Get-GitlabUser -ModuleName $TestModuleName -ParameterFilter { -not $Me } -MockWith {
        [PSCustomObject]@{ Id = 1; Username = 'me' }
      }
      $Result = Use-GitlabToken -User 'me' { "session: [$($global:GitlabUserImpersonationSession.Username)]" }
      $Result | Should -Be 'session: []'
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
    }

    It "Should report the start and stop under -WhatIf and run the block as the caller" {
      $Text = Get-DisplayedText {
        Use-GitlabToken -User 'john.doe' { "session: [$($global:GitlabUserImpersonationSession.Username)]" } -WhatIf
      }
      $Text | Should -Match 'start impersonation'
      $Text | Should -Match 'stop impersonation'
      $Text | Should -Match ([regex]::Escape('session: []'))
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
    }
  }

  Context "-ServiceAccount" {
    BeforeAll {
      $ServiceAccount = [PSCustomObject]@{ PSTypeName = 'Gitlab.ServiceAccount'; Id = 7; Username = 'marketplace-trigger'; GroupId = 'my-group' }
    }

    BeforeEach {
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'POST' } -MockWith {
        [PSCustomObject]@{ Id = 5; Token = 'glpat-SECRET-PAT' }
      }
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'DELETE' } -MockWith {}
    }

    It "Should run the block as the service account and return its output" {
      $Result = Use-GitlabToken -ServiceAccount $ServiceAccount { "as $($global:GitlabUserImpersonationSession.Username)" }
      $Result | Should -Be 'as marketplace-trigger'
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
        $HttpMethod -eq 'POST' -and $Path -eq 'groups/18/service_accounts/7/personal_access_tokens' -and $Body.scopes -contains 'api'
      }
    }

    It "Should take the service account from the pipeline" {
      $Result = $ServiceAccount | Use-GitlabToken { $global:GitlabUserImpersonationSession.Username }
      $Result | Should -Be 'marketplace-trigger'
    }

    It "Should use the token for calls in the block, then clear it" {
      Use-GitlabToken -ServiceAccount $ServiceAccount { $global:GitlabUserImpersonationSession.Token | Should -Be 'glpat-SECRET-PAT' }
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
    }

    It "Should revoke the token as the caller after the block" {
      Use-GitlabToken -ServiceAccount $ServiceAccount { } | Out-Null
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -ParameterFilter {
        $HttpMethod -eq 'DELETE' -and $Path -eq 'groups/18/service_accounts/7/personal_access_tokens/5'
      }
    }

    It "Should revoke the token when the block throws" {
      { Use-GitlabToken -ServiceAccount $ServiceAccount { throw 'block failed' } } | Should -Throw 'block failed'
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -ParameterFilter { $HttpMethod -eq 'DELETE' }
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
    }

    It "Should not print the token" {
      $Text = Get-DisplayedText { Use-GitlabToken -ServiceAccount $ServiceAccount { 'done' } -Verbose }
      $Text | Should -Match 'done'
      $Text | Should -Not -Match 'SECRET'
    }

    It "Should report the mint and revoke under -WhatIf and run the block as the caller" {
      $Text = Get-DisplayedText {
        Use-GitlabToken -ServiceAccount $ServiceAccount { "session: [$($global:GitlabUserImpersonationSession.Username)]" } -WhatIf
      }
      $Text | Should -Match 'create personal access token'
      $Text | Should -Match 'revoke the personal access token'
      $Text | Should -Match ([regex]::Escape('session: []'))
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
    }
  }

  Context "-Token" {
    BeforeEach {
      Mock -CommandName Get-GitlabUser -ModuleName $TestModuleName -ParameterFilter { $Me } -MockWith {
        [PSCustomObject]@{ Id = 9; Username = 'project_123_bot' }
      }
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    }

    It "Should run the block with the token as its owner, then clear it" {
      $Result = Use-GitlabToken -Token 'glpat-SECRET-GIVEN' {
        "$($global:GitlabUserImpersonationSession.Username) $($global:GitlabUserImpersonationSession.Token)"
      }
      $Result | Should -Be 'project_123_bot glpat-SECRET-GIVEN'
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
    }

    It "Should look up the token's owner with the token" {
      Mock -CommandName Get-GitlabUser -ModuleName $TestModuleName -ParameterFilter { $Me } -MockWith {
        [PSCustomObject]@{ Id = 9; Username = "owner of $($global:GitlabUserImpersonationSession.Token)" }
      }
      Use-GitlabToken -Token 'glpat-given' { $global:GitlabUserImpersonationSession.Username } |
        Should -Be 'owner of glpat-given'
    }

    It "Should not revoke a token it was given" {
      Use-GitlabToken -Token 'glpat-given' { } | Out-Null
      Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
    }

    It "Should clear the token and skip the block when the owner lookup fails" {
      Mock -CommandName Get-GitlabUser -ModuleName $TestModuleName -ParameterFilter { $Me } -MockWith { throw '401 Unauthorized' }
      $script:Ran = $false
      { Use-GitlabToken -Token 'glpat-bad' { $script:Ran = $true } } | Should -Throw '*401*'
      $script:Ran | Should -BeFalse
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
    }

    It "Should clear the token when the block throws" {
      { Use-GitlabToken -Token 'glpat-given' { throw 'block failed' } } | Should -Throw 'block failed'
      $global:GitlabUserImpersonationSession | Should -BeNullOrEmpty
    }
  }
}
