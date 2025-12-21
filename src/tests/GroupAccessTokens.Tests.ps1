BeforeAll {
  . $PSScriptRoot/../GitlabCli/_Init.ps1
  Import-Module $PSScriptRoot/../GitlabCli/Utilities.psm1 -Force
  Import-Module $PSScriptRoot/../GitlabCli/Validation.psm1 -Force
  Import-Module $PSScriptRoot/../GitlabCli/Members.psm1 -Force
  Import-Module $PSScriptRoot/../GitlabCli/GroupAccessTokens.psm1 -Force
}

Describe "Get-GitlabGroupAccessToken" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName GroupAccessTokens -MockWith { write-host "fallthrough"; throw "Mock fall through, check your parameter filters"}
  }

  Context "When no group access tokens" {
    BeforeEach {
      Mock -CommandName Invoke-GitlabApi `
        -ParameterFilter { 
          $HttpMethod -eq 'GET' `
          -and $Path -eq 'groups/1/access_tokens' 
        } `
        -MockWith {
          return @()
        } `
        -ModuleName GroupAccessTokens
    }
    It "Should return an empty result" {
      $Result = Get-GitlabGroupAccessToken -GroupId 1
      $Result | Should -BeNullOrEmpty
    }
  }

  Context "When there are group access tokens" {
    BeforeEach {
      Mock -CommandName Invoke-GitlabApi -ModuleName GroupAccessTokens `
        -ParameterFilter { 
          $HttpMethod -eq 'GET' `
          -and $Path -eq 'groups/1/access_tokens' 
        } `
        -MockWith {
          return @(
            [PSCustomObject]@{
              id = 1
              name = "token1"
              token = "token1"
              expires_at = (Get-Date).AddMonths(6).ToString('yyyy-MM-dd')
              scope = "api"
            },
            [PSCustomObject]@{
              id = 2
              name = "token2"
              token = "token2"
              expires_at = (Get-Date).AddMonths(6).ToString('yyyy-MM-dd')
              scope = "api"
            }
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
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName GroupAccessTokens -MockWith { write-host "fallthrough"; throw "Mock fall through, check your parameter filters"}
  }

  Context "When creating a new group access token" {
    BeforeEach {
      Mock -CommandName Invoke-GitlabApi -ModuleName GroupAccessTokens `
        -ParameterFilter { 
          $HttpMethod -eq 'POST' `
          -and $Path -eq 'groups/1/access_tokens'
        } `
        -MockWith {
          return [PSCustomObject]@{
            id = 1
            name = "token1"
            token = "token1"
            expires_at = (Get-Date).AddMonths(6).ToString('yyyy-MM-dd')
            scopes = @("api")
          }
        }
    }

    It "Should return the new group access token" {
      $Result = New-GitlabGroupAccessToken -GroupId 1 -Name "token1" -Scope "api" -AccessLevel "developer"
      $Result.Name | Should -Be "token1"
      $Result.Token  | Should -Be "token1"
    }

    It "Should fail when Expires At is more than a year from now" {
      { New-GitlabGroupAccessToken -GroupId 1 -Name "token1" -Scope "api" -AccessLevel "developer" -ExpiresAt (Get-Date).AddYears(2) } | Should -Throw
    }
  }
}