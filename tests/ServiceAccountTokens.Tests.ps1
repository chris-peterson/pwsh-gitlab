BeforeAll {
  $TestModuleName = "ServiceAccounts"
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

Describe "New-GitlabServiceAccountPersonalAccessToken" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
      [PSCustomObject]@{ id = 5; user_id = 99; token = 'glpat-example' }
    }
  }

  It "Should create the token through the group's service account API" {
    $Result = New-GitlabServiceAccountPersonalAccessToken -GroupId 'my-group' -ServiceAccountId 99 -Name 'ci' -Scope api -ExpiresAt '2026-12-31'
    $Result.token | Should -Be 'glpat-example'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'POST' -and
      $Path -eq 'groups/18/service_accounts/99/personal_access_tokens' -and
      $Body.name -eq 'ci' -and
      $Body.scopes -contains 'api' -and
      $Body.expires_at -eq '2026-12-31'
    }
  }

  It "Should take a group service account from Get-GitlabServiceAccount on the pipeline" {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'GET' } -MockWith {
      [PSCustomObject]@{ Id = 99; Username = 'deploy-bot' }
    }
    Get-GitlabServiceAccount -GroupId 'my-group' -ServiceAccountId 99 |
      New-GitlabServiceAccountPersonalAccessToken -Name 'ci' -Scope read_api | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'POST' -and $Path -eq 'groups/18/service_accounts/99/personal_access_tokens'
    }
  }

  It "Should leave out optional fields that weren't given" {
    New-GitlabServiceAccountPersonalAccessToken -GroupId 'my-group' -ServiceAccountId 99 -Name 'ci' -Scope api | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      -not $Body.ContainsKey('expires_at') -and -not $Body.ContainsKey('description')
    }
  }
}

Describe "Remove-GitlabServiceAccountPersonalAccessToken" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {}
  }

  It "Should revoke the token through the group's service account API" {
    Remove-GitlabServiceAccountPersonalAccessToken -GroupId 'my-group' -ServiceAccountId 99 -TokenId 5 -Force
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'DELETE' -and $Path -eq 'groups/18/service_accounts/99/personal_access_tokens/5'
    }
  }

  It "Should take the token New-GitlabServiceAccountPersonalAccessToken returns from the pipeline" {
    [PSCustomObject]@{ Id = 5; UserId = 99 } |
      Remove-GitlabServiceAccountPersonalAccessToken -GroupId 'my-group' -Force
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $Path -eq 'groups/18/service_accounts/99/personal_access_tokens/5'
    }
  }
}

Describe "Get-GitlabServiceAccount -Username" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
      @(
        [PSCustomObject]@{ Id = 7; Username = 'marketplace-trigger' }
        [PSCustomObject]@{ Id = 8; Username = 'other' }
      )
    }
  }

  It "Should return the account with that username, carrying GroupId" {
    $Result = Get-GitlabServiceAccount -GroupId 'my-group' -Username 'marketplace-trigger'
    $Result.Id | Should -Be 7
    $Result.GroupId | Should -Be 'my-group'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $Path -eq 'groups/my-group/service_accounts' -and $MaxPages -eq [uint]::MaxValue
    }
  }

  It "Should write a non-terminating not-found error for an unknown username" {
    $Result = Get-GitlabServiceAccount -GroupId 'my-group' -Username 'missing' -ErrorAction SilentlyContinue -ErrorVariable Errors
    $Result | Should -BeNullOrEmpty
    $Errors.CategoryInfo.Category | Should -Contain 'ObjectNotFound'
  }
}

Describe "Set-GitlabServiceAccount" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'GET' } -MockWith {
      [PSCustomObject]@{ PSTypeName = 'Gitlab.ServiceAccount'; Id = 7; Username = 'marketplace-trigger'; Name = 'marketplace trigger' }
    }
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -ne 'GET' } -MockWith {
      [PSCustomObject]@{ PSTypeName = 'Gitlab.ServiceAccount'; Id = 9; Username = $Body.username; Name = $Body.name }
    }
    function global:Get-GitlabGroup {
      param([string]$GroupId)
      [PSCustomObject]@{ Id = 18; FullPath = $GroupId; IsTopLevel = $true }
    }
  }

  It "Should return an account that already matches without a request" {
    $Result = Set-GitlabServiceAccount -GroupId 'my-group' -Username 'marketplace-trigger' -Name 'marketplace trigger'
    $Result.Id | Should -Be 7
    $Result.GroupId | Should -Be 'my-group'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -ne 'GET' } -Times 0
  }

  It "Should create an account that doesn't exist" {
    $Result = Set-GitlabServiceAccount -GroupId 'my-group' -Username 'new-bot' -Name 'new bot'
    $Result.Id | Should -Be 9
    $Result.GroupId | Should -Be 'my-group'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'POST' -and $Path -eq 'groups/18/service_accounts' -and $Body.username -eq 'new-bot'
    }
  }

  It "Should update only the fields that differ" {
    Set-GitlabServiceAccount -GroupId 'my-group' -Username 'marketplace-trigger' -Name 'renamed' | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'PATCH' -and $Path -eq 'groups/my-group/service_accounts/7' -and $Body.name -eq 'renamed' -and -not $Body.ContainsKey('email')
    }
  }

  It "Should reject a username with a prefix GitLab reserves, even under -WhatIf" -ForEach @(
    @{ Username = 'duo-bot' }, @{ Username = 'duo_bot' }, @{ Username = 'ai-bot' }, @{ Username = 'AI_bot' }
  ) {
    { Set-GitlabServiceAccount -GroupId 'my-group' -Username $Username -WhatIf } | Should -Throw '*reserves for its AI entities*'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }

  It "Should accept a username that only contains a reserved word" {
    Set-GitlabServiceAccount -GroupId 'my-group' -Username 'team-ai-bot' | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'POST' -and $Body.username -eq 'team-ai-bot' }
  }
}

Describe "New-GitlabServiceAccount" {
  It "Should reject a username with a prefix GitLab reserves, even under -WhatIf" {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName
    { New-GitlabServiceAccount -Username 'ai-bot' -WhatIf } | Should -Throw '*reserves for its AI entities*'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }
}
