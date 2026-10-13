BeforeAll {
  $TestModuleName = "Members"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1
  . $PSScriptRoot/TestHelpers.ps1

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/Members.psm1" -Raw
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
  function global:Resolve-GitlabProjectId { param([string]$ProjectId) 42 }
  function global:Resolve-GitlabGroupId { param([string]$GroupId) 18 }
  function global:Get-GitlabUser {
    param([Parameter(Position=0)][string]$UserId)
    [PSCustomObject]@{ Id = ($UserId -as [int]) ?? 7; Username = $UserId }
  }
  function global:New-GitlabObject {
    param(
      [Parameter(ValueFromPipeline)]$InputObject,
      [Parameter(Position=0)][string]$DisplayType
    )
    process { $InputObject }
  }
}

Describe "Set-GitlabProjectMember" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { [PSCustomObject]@{ id = 99 } }
  }

  It "Should update an existing member without -SiteUrl" {
    Mock -CommandName Get-GitlabProjectMember -ModuleName $TestModuleName -MockWith {
      [PSCustomObject]@{ Id = 99; Name = 'someone'; ProjectId = 42; AccessLevel = 30 }
    }
    Set-GitlabProjectMember -ProjectId 'group/project' -UserId 'someone' -AccessLevel maintainer | Out-Null
    Should -Invoke Get-GitlabProjectMember -ModuleName $TestModuleName -ParameterFilter {
      $ProjectId -eq 'group/project'
    }
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'PUT' -and $Path -eq 'projects/42/members/99' -and $Body.access_level -eq 40
    }
  }

  It "Should return a member that already has the access level without a request" {
    Mock -CommandName Get-GitlabProjectMember -ModuleName $TestModuleName -MockWith {
      [PSCustomObject]@{ Id = 99; Username = 'someone'; ProjectId = 42; AccessLevel = 40 }
    }
    $Text = Get-DisplayedText { $script:Result = Set-GitlabProjectMember -ProjectId 'group/project' -UserId 'someone' -AccessLevel maintainer -WhatIf }
    $script:Result.Id | Should -Be 99
    $Text | Should -Not -Match 'What if'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }

  It "Should add a user the lookup reports as not found" {
    Mock -CommandName Get-GitlabProjectMember -ModuleName $TestModuleName -MockWith { throw (New-HttpError 404) }
    Set-GitlabProjectMember -ProjectId 'group/project' -UserId 'someone' -AccessLevel maintainer | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -ParameterFilter {
      $HttpMethod -eq 'POST' -and $Path -eq 'projects/42/members' -and $Body.access_level -eq 40
    }
  }

  It "Should not add a user when the lookup fails for another reason" {
    Mock -CommandName Get-GitlabProjectMember -ModuleName $TestModuleName -MockWith { throw (New-HttpError 500) }
    { Set-GitlabProjectMember -ProjectId 'group/project' -UserId 'someone' -AccessLevel maintainer } | Should -Throw
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }

  It "Should take a service account or a user from the pipeline" {
    Mock -CommandName Get-GitlabProjectMember -ModuleName $TestModuleName -MockWith { throw (New-HttpError 404) }
    [PSCustomObject]@{ PSTypeName = 'Gitlab.ServiceAccount'; Id = 7; Username = 'marketplace-trigger'; GroupId = 'my-group' } |
      Set-GitlabProjectMember -ProjectId 'group/project' -AccessLevel maintainer | Out-Null
    [PSCustomObject]@{ PSTypeName = 'Gitlab.User'; Id = 8; UserId = 8; Username = 'someone' } |
      Set-GitlabProjectMember -ProjectId 'group/project' -AccessLevel maintainer | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'POST' -and $Body.user_id -eq 7 }
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $HttpMethod -eq 'POST' -and $Body.user_id -eq 8 }
  }
}

Describe "Set-GitlabGroupMember" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {}
  }

  It "Should return a member that already has the access level without a request" {
    Mock -CommandName Get-GitlabGroupMember -ModuleName $TestModuleName -MockWith {
      [PSCustomObject]@{ Id = 99; Username = 'someone'; GroupId = 18; AccessLevel = 30 }
    }
    $Result = Set-GitlabGroupMember -GroupId 'group' -UserId 'someone' -AccessLevel developer
    $Result.Id | Should -Be 99
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }

  It "Should not add a user when the lookup fails for another reason" {
    Mock -CommandName Get-GitlabGroupMember -ModuleName $TestModuleName -MockWith { throw (New-HttpError 500) }
    { Set-GitlabGroupMember -GroupId 'group' -UserId 'someone' -AccessLevel developer } | Should -Throw
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
  }
}
