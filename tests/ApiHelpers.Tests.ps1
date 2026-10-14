BeforeAll {
  $TestModuleName = "Utilities"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Utilities.psm1" -Raw
    ) -join "`n"))) -Force

  . $PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1
  . $PSScriptRoot/TestHelpers.ps1

  function global:Resolve-GitlabSite {
    param([string]$SiteUrl)
    [PSCustomObject]@{ Url = 'gitlab.example.com'; AccessToken = 'glpat-SECRET-ACCESS' }
  }
}

Describe "ConvertTo-GitlabLogText" {
  AfterEach {
    $global:GitlabLogSecretValues.value = $false
  }

  It "Should hide secret fields, including nested ones" {
    $Text = ConvertTo-GitlabLogText @{
      key       = 'MARKETPLACE_TRIGGER_TOKEN'
      value     = 'SECRET-VALUE'
      variables = @(@{ key = 'A'; value = 'SECRET-NESTED' })
      owner     = [PSCustomObject]@{ username = 'bot'; token = 'SECRET-TOKEN' }
    }
    $Text | Should -Not -Match 'SECRET'
    $Text | Should -Match 'MARKETPLACE_TRIGGER_TOKEN'
    $Text | Should -Match 'bot'
  }

  It "Should show only the fields turned on in GitlabLogSecretValues" {
    $global:GitlabLogSecretValues.value = $true
    $Text = @{ value = 'SECRET-VALUE'; token = 'SECRET-TOKEN' } | ConvertTo-GitlabLogText
    $Text | Should -Match 'SECRET-VALUE'
    $Text | Should -Not -Match 'SECRET-TOKEN'
  }

  It "Should render piped objects as one array" {
    $Text = @([PSCustomObject]@{ id = 1; token = 'SECRET-A' }, [PSCustomObject]@{ id = 2; token = 'SECRET-B' }) | ConvertTo-GitlabLogText
    ($Text | ConvertFrom-Json).Count | Should -Be 2
    $Text | Should -Not -Match 'SECRET'
  }
}

Describe "Test-GitlabNotFound" {
  It "Should recognize a 404 response" {
    try { throw (New-HttpError 404) } catch { Test-GitlabNotFound $_ | Should -BeTrue }
  }

  It "Should not treat other failures as not found" {
    try { throw (New-HttpError 500) } catch { Test-GitlabNotFound $_ | Should -BeFalse }
    try { throw 'boom' } catch { Test-GitlabNotFound $_ | Should -BeFalse }
  }
}

Describe "Invoke-GitlabApi" {
  BeforeEach {
    Mock -CommandName Invoke-RestMethod -ModuleName $TestModuleName -MockWith {
      [PSCustomObject]@{ id = 1; token = 'glptt-SECRET-RESPONSE' }
    }
  }

  It "Should keep the access token and body secrets out of -WhatIf output" {
    $Text = Get-DisplayedText {
      Invoke-GitlabApi POST 'projects/42/variables' -Body @{ key = 'K'; value = 'SECRET-VALUE' } -WhatIf
    }
    $Text | Should -Match 'projects/42/variables'
    $Text | Should -Not -Match 'SECRET'
    Should -Invoke Invoke-RestMethod -ModuleName $TestModuleName -Times 0
  }

  It "Should keep the access token, body secrets, and response secrets out of -Verbose output" {
    $Text = Get-DisplayedText {
      Invoke-GitlabApi POST 'projects/42/triggers' -Body @{ description = 'ci'; value = 'SECRET-VALUE' } -Verbose -Confirm:$false | Out-Null
    }
    $Text | Should -Match 'Response'
    $Text | Should -Not -Match 'SECRET'
  }

  It "Should still send the access token" {
    Invoke-GitlabApi GET 'projects/42' | Out-Null
    Should -Invoke Invoke-RestMethod -ModuleName $TestModuleName -ParameterFilter {
      $Headers.Authorization -eq 'Bearer glpat-SECRET-ACCESS'
    }
  }
}
