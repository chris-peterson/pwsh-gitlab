BeforeAll {
  $TestModuleName = "Utilities"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/SensitiveValueHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Utilities.psm1" -Raw
    ) -join "`n"))) -Force

  . $PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1
  . $PSScriptRoot/../src/GitlabCli/Private/Functions/SensitiveValueHelpers.ps1
  . $PSScriptRoot/TestHelpers.ps1

  function global:Resolve-GitlabSite {
    param([string]$SiteUrl)
    [PSCustomObject]@{ Url = 'gitlab.example.com'; AccessToken = 'glpat-SECRET-ACCESS' }
  }
}

Describe "ConvertTo-GitlabLogText" {
  It "Should hide secret fields, including nested ones" {
    $Text = ConvertTo-GitlabLogText @{
      key       = 'MARKETPLACE_TRIGGER_TOKEN'
      value     = 'SECRET-VALUE'
      variables = @(@{ key = 'A'; value = 'SECRET-NESTED'; masked = $true })
      owner     = [PSCustomObject]@{ username = 'bot'; token = 'SECRET-TOKEN' }
    }
    $Text | Should -Not -Match 'SECRET-'
    $Text | Should -Match '\*{8}'
    $Text | Should -Match 'MARKETPLACE_TRIGGER_TOKEN'
    $Text | Should -Match 'bot'
  }

  It "Should show the value of a variable that isn't secret" {
    $Text = @{ key = 'ENVIRONMENT'; value = 'production' } | ConvertTo-GitlabLogText
    $Text | Should -Match 'production'
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
      Invoke-GitlabApi POST 'projects/42/variables' -Body @{ key = 'DEPLOY_TOKEN'; value = 'SECRET-VALUE' } -WhatIf
    }
    $Text | Should -Match 'projects/42/variables'
    $Text | Should -Not -Match 'SECRET'
    Should -Invoke Invoke-RestMethod -ModuleName $TestModuleName -Times 0
  }

  It "Should keep the access token, body secrets, and response secrets out of -Verbose output" {
    $Text = Get-DisplayedText {
      Invoke-GitlabApi POST 'projects/42/triggers' -Body @{ description = 'ci'; token = 'SECRET-VALUE' } -Verbose -Confirm:$false | Out-Null
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

  Context "-Form" {
    BeforeAll {
      $Image = New-Item -ItemType File -Path (Join-Path $TestDrive 'logo.png') -Force
    }

    It "Should send the fields as multipart form data instead of JSON" {
      Invoke-GitlabApi PUT 'projects/42' -Form @{ avatar = $Image } -Confirm:$false | Out-Null
      Should -Invoke Invoke-RestMethod -ModuleName $TestModuleName -ParameterFilter {
        $Form.avatar.FullName -eq $Image.FullName -and -not $Body -and -not $ContentType
      }
    }

    It "Should show the uploaded file's path in -WhatIf output" {
      $Text = Get-DisplayedText { Invoke-GitlabApi PUT 'projects/42' -Form @{ avatar = $Image } -WhatIf }
      $Text | Should -Match '"avatar": ".*logo\.png"'
      Should -Invoke Invoke-RestMethod -ModuleName $TestModuleName -Times 0
    }

    It "Should refuse a request that has both -Body and -Form" {
      { Invoke-GitlabApi PUT 'projects/42' -Body @{ name = 'x' } -Form @{ avatar = $Image } -Confirm:$false } |
        Should -Throw '*combined*'
    }
  }
}
