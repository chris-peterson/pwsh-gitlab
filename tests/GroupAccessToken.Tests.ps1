BeforeAll {
  $TestModuleName = "GroupAccessTokens"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../GitlabCli/Private/Globals.ps1" -Raw
      Get-Content "$PSScriptRoot/../GitlabCli/GroupAccessTokens.psm1" -Raw
    ) -join "`n"))) -Force

  function global:Invoke-GitlabApi {}
  function global:New-WrapperObject {
    param(
      [Parameter(ValueFromPipeline)]$InputObject,
      [Parameter(Position=0)][string]$DisplayType
    )
    process { $InputObject }
  }
  function global:Test-GitlabSettableAccessLevel {}
  function global:Get-GitlabMemberAccessLevel {}
}

Describe "Get-GitlabGroupAccessToken" {

  Context "When no group access tokens" {
    BeforeEach {
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName `
        -MockWith { @() }
    }

    It "Should return an empty result" {
      $Result = Get-GitlabGroupAccessToken -GroupId 1
      $Result | Should -BeNullOrEmpty
    }
  }

  Context "When there are group access tokens" {
    BeforeEach {
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName `
        -MockWith {
          @(
            [PSCustomObject]@{ id = 1; name = "token1"; token = "token1"; expires_at = (Get-Date).AddMonths(6).ToString('yyyy-MM-dd'); scope = "api" },
            [PSCustomObject]@{ id = 2; name = "token2"; token = "token2"; expires_at = (Get-Date).AddMonths(6).ToString('yyyy-MM-dd'); scope = "api" }
          )
        }
    }

    It "Should return the group access tokens" {
      $Result = Get-GitlabGroupAccessToken -GroupId 1
      $Result | Should -HaveCount 2
      $Result[0].Name | Should -Be "token1"
      $Result[1].Name | Should -Be "token2"
    }
  }
}

Describe "New-GitlabGroupAccessToken" {

  Context "When creating a new group access token" {
    BeforeEach {
      Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName `
        -MockWith {
          [PSCustomObject]@{ id = 1; name = "token1"; token = "token1"; expires_at = (Get-Date).AddMonths(6).ToString('yyyy-MM-dd'); scopes = @("api") }
        }
      Mock -CommandName Get-GitlabMemberAccessLevel -ModuleName $TestModuleName `
        -MockWith { return 30 }
      Mock -CommandName Test-GitlabSettableAccessLevel -ModuleName $TestModuleName `
        -MockWith { return $true }
    }

    It "Should return the new group access token" {
      $Result = New-GitlabGroupAccessToken -GroupId 1 -Name "token1" -Scope "api" -AccessLevel "developer"
      $Result.Name | Should -Be "token1"
      $Result.Token | Should -Be "token1"
    }

    It "Should fail when Expires At is more than a year from now" {
      { New-GitlabGroupAccessToken -GroupId 1 -Name "token1" -Scope "api" -AccessLevel "developer" -ExpiresAt (Get-Date).AddYears(2) } |
        Should -Throw "*ExpiresAt can't be more than 1 year from now*"
    }
  }
}