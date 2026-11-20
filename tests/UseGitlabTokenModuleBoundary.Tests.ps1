# Use-GitlabToken (Users.psm1) calls the service account token cmdlets (ServiceAccounts.psm1).
# In the shipped module those are separate nested modules, and preference variables such as
# $WhatIfPreference don't cross a module boundary. These tests load them as two modules so the
# boundary is there; UseGitlabToken.Tests.ps1 loads both into one, which hides it.
BeforeAll {
  $ServiceAccountsModule = 'UseGitlabTokenBoundaryServiceAccounts'
  $UsersModule           = 'UseGitlabTokenBoundaryUsers'
  Get-Module -Name $ServiceAccountsModule, $UsersModule -All | Remove-Module -Force -ErrorAction SilentlyContinue

  . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1
  . $PSScriptRoot/../src/GitlabCli/Private/Validations.ps1
  . $PSScriptRoot/TestHelpers.ps1

  $Shared = @(
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1" -Raw
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1" -Raw
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/SensitiveValueHelpers.ps1" -Raw
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
    Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/TokenHelpers.ps1" -Raw
  )
  Import-Module (New-Module -Name $ServiceAccountsModule -ScriptBlock ([scriptblock]::Create(
    @($Shared; Get-Content "$PSScriptRoot/../src/GitlabCli/ServiceAccounts.psm1" -Raw) -join "`n"))) -Force
  Import-Module (New-Module -Name $UsersModule -ScriptBlock ([scriptblock]::Create(
    @($Shared; Get-Content "$PSScriptRoot/../src/GitlabCli/Users.psm1" -Raw) -join "`n"))) -Force

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

  # GitLab expires a token at 00:00 UTC on its expires_at date, so a token that has to last an
  # hour gets the day after the UTC date an hour from now
  $ExpectedExpiry = [DateTime]::UtcNow.AddHours(1).Date.AddDays(1).ToString('yyyy-MM-dd')
}

Describe "Use-GitlabToken -ServiceAccount across the module boundary" {
  BeforeAll {
    $ServiceAccount = [PSCustomObject]@{ PSTypeName = 'Gitlab.ServiceAccount'; Id = 7; Username = 'marketplace-trigger'; GroupId = 'my-group' }
  }

  BeforeEach {
    $global:GitlabUserImpersonationSession = $null
    Mock -CommandName Invoke-GitlabApi -ModuleName $ServiceAccountsModule -ParameterFilter { $HttpMethod -eq 'POST' } -MockWith {
      [PSCustomObject]@{ Id = 5; Token = 'glpat-SECRET-PAT' }
    }
    Mock -CommandName Invoke-GitlabApi -ModuleName $ServiceAccountsModule -ParameterFilter { $HttpMethod -eq 'DELETE' } -MockWith {}
  }

  AfterEach {
    $global:GitlabUserImpersonationSession = $null
  }

  It "Should not mint or revoke a token under -WhatIf" {
    $Text = Get-DisplayedText {
      Use-GitlabToken -ServiceAccount $ServiceAccount { "session: [$($global:GitlabUserImpersonationSession.Username)]" } -WhatIf
    }
    Should -Invoke Invoke-GitlabApi -ModuleName $ServiceAccountsModule -Times 0 -ParameterFilter { $HttpMethod -eq 'POST' }
    Should -Invoke Invoke-GitlabApi -ModuleName $ServiceAccountsModule -Times 0 -ParameterFilter { $HttpMethod -eq 'DELETE' }
    $Text | Should -Match 'create personal access token'
    $Text | Should -Match 'revoke the personal access token'
    $Text | Should -Match ([regex]::Escape('session: []'))
  }

  It "Should default expires_at to a UTC date that keeps the token valid for an hour" {
    # a local clock still on the previous date, as on a US evening once UTC has rolled over
    Mock -CommandName Get-Date -ModuleName $UsersModule -MockWith { [DateTime]::UtcNow.AddDays(-1) }

    Use-GitlabToken -ServiceAccount $ServiceAccount { } | Out-Null

    Should -Invoke Invoke-GitlabApi -ModuleName $ServiceAccountsModule -Times 1 -Exactly -ParameterFilter {
      $HttpMethod -eq 'POST' -and $Body.expires_at -eq $ExpectedExpiry
    }
  }

  It "Should send an explicit -ExpiresAt as given" {
    Use-GitlabToken -ServiceAccount $ServiceAccount -ExpiresAt '2030-01-02' { } | Out-Null

    Should -Invoke Invoke-GitlabApi -ModuleName $ServiceAccountsModule -Times 1 -Exactly -ParameterFilter {
      $HttpMethod -eq 'POST' -and $Body.expires_at -eq '2030-01-02'
    }
  }
}

Describe "Start-GitlabUserImpersonation" {
  BeforeEach {
    $global:GitlabUserImpersonationSession = $null
    Mock -CommandName Get-GitlabUser -ModuleName $UsersModule -ParameterFilter { $Me } -MockWith {
      [PSCustomObject]@{ Id = 1; Username = 'me' }
    }
    Mock -CommandName Get-GitlabUser -ModuleName $UsersModule -ParameterFilter { -not $Me } -MockWith {
      [PSCustomObject]@{ Id = 42; Username = 'john.doe' }
    }
    Mock -CommandName Invoke-GitlabApi -ModuleName $UsersModule -MockWith {
      [PSCustomObject]@{ id = 5; user_id = 42; token = 'glpat-SECRET-IMPERSONATION' }
    }
  }

  AfterEach {
    $global:GitlabUserImpersonationSession = $null
  }

  It "Should default expires_at to a UTC date that keeps the token valid for an hour" {
    Mock -CommandName Get-Date -ModuleName $UsersModule -MockWith { [DateTime]::UtcNow.AddDays(-1) }

    Start-GitlabUserImpersonation 'john.doe'

    Should -Invoke Invoke-GitlabApi -ModuleName $UsersModule -Times 1 -Exactly -ParameterFilter {
      $Method -eq 'POST' -and $Body.expires_at -eq $ExpectedExpiry
    }
  }
}

Describe "Get-GitlabTemporaryTokenExpiryDate" {
  It "Should return the day after the UTC date <Lifetime> from <Now>" -ForEach @(
    # a US evening, once UTC has rolled over: the case that minted expired tokens
    @{ Now = '2026-11-20T01:06:00Z'; Lifetime = '01:00:00'; Expected = '2026-11-21' }
    # late in the UTC day: tomorrow's date would leave half an hour
    @{ Now = '2026-11-19T23:30:00Z'; Lifetime = '01:00:00'; Expected = '2026-11-21' }
    @{ Now = '2026-11-19T22:00:00Z'; Lifetime = '01:00:00'; Expected = '2026-11-20' }
    @{ Now = '2026-11-20T01:06:00Z'; Lifetime = '1.00:00:00'; Expected = '2026-11-22' }
  ) {
    InModuleScope $UsersModule -Parameters @{ Now = $Now; Lifetime = $Lifetime; Expected = $Expected } {
      $Utc = [DateTime]::Parse($Now, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AdjustToUniversal)
      Get-GitlabTemporaryTokenExpiryDate -Now $Utc -Lifetime ([TimeSpan]::Parse($Lifetime)) | Should -Be $Expected
    }
  }

  It "Should take its default lifetime from `$global:GitlabTemporaryTokenLifetime" {
    $Saved = $global:GitlabTemporaryTokenLifetime
    try {
      $global:GitlabTemporaryTokenLifetime = [TimeSpan]::FromDays(3)
      InModuleScope $UsersModule {
        $Now = [DateTime]::new(2026, 11, 20, 1, 6, 0, [DateTimeKind]::Utc)
        Get-GitlabTemporaryTokenExpiryDate -Now $Now | Should -Be '2026-11-24'
      }
    } finally {
      $global:GitlabTemporaryTokenLifetime = $Saved
    }
  }
}
