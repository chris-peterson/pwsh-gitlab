BeforeAll {
  . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1
  . $PSScriptRoot/TestHelpers.ps1

  foreach ($Name in 'Projects', 'Groups') {
    Get-Module -Name $Name -All | Remove-Module -Force -ErrorAction SilentlyContinue
    Import-Module (New-Module -Name $Name -ScriptBlock ([scriptblock]::Create(
      @(
        Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
        Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ApiHelpers.ps1" -Raw
        Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
        Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1" -Raw
        Get-Content "$PSScriptRoot/../src/GitlabCli/$Name.psm1" -Raw
      ) -join "`n"))) -Force
  }

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
  function global:New-GitlabObject {
    param(
      [Parameter(ValueFromPipeline)]$InputObject,
      [Parameter(Position=0)][string]$DisplayType
    )
    process { $InputObject }
  }
}

Describe "Get-GitlabProjectVariable" {
  It "Should write a non-terminating not-found error for a missing key" {
    Mock -CommandName Invoke-GitlabApi -ModuleName Projects -MockWith { throw (New-HttpError 404) }
    $Result = Get-GitlabProjectVariable -ProjectId 'g/p' -Key 'MISSING' -ErrorAction SilentlyContinue -ErrorVariable Errors
    $Result | Should -BeNullOrEmpty
    $Errors.CategoryInfo.Category | Should -Contain 'ObjectNotFound'
  }

  It "Should still throw for other failures" {
    Mock -CommandName Invoke-GitlabApi -ModuleName Projects -MockWith { throw (New-HttpError 500) }
    { Get-GitlabProjectVariable -ProjectId 'g/p' -Key 'K' -ErrorAction SilentlyContinue } | Should -Throw
  }
}

Describe "Set-GitlabProjectVariable" {
  BeforeEach {
    Mock -CommandName Get-GitlabProject -ModuleName Projects -MockWith {
      [PSCustomObject]@{ Id = $ProjectId; PathWithNamespace = "group/$ProjectId" }
    }
    Mock -CommandName Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'GET' } -MockWith { throw (New-HttpError 404) }
    Mock -CommandName Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -ne 'GET' } -MockWith { [PSCustomObject]@{ key = 'K' } }
  }

  It "Should create a variable that doesn't exist" {
    Set-GitlabProjectVariable -ProjectId 1 'K' 'SECRET-VALUE' | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'POST' -and $Path -eq 'projects/1/variables' }
  }

  It "Should update a variable that exists" {
    Mock -CommandName Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'GET' } -MockWith { [PSCustomObject]@{ key = 'K' } }
    Set-GitlabProjectVariable -ProjectId 1 'K' 'SECRET-VALUE' | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'PUT' -and $Path -eq 'projects/1/variables/K' }
  }

  It "Should not treat a failed lookup as a missing variable" {
    Mock -CommandName Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'GET' } -MockWith { throw (New-HttpError 500) }
    { Set-GitlabProjectVariable -ProjectId 1 'K' 'SECRET-VALUE' } | Should -Throw
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -ne 'GET' } -Times 0
  }

  It "Should set the variable on every project from the pipeline" {
    @(
      [PSCustomObject]@{ PSTypeName = 'Gitlab.Project'; ProjectId = 1 }
      [PSCustomObject]@{ PSTypeName = 'Gitlab.Project'; ProjectId = 2 }
    ) | Set-GitlabProjectVariable 'K' 'SECRET-VALUE' -Protect $true -Mask $true -NoExpand | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'POST' -and $Path -eq 'projects/1/variables' -and $Body.masked -and $Body.raw }
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -eq 'POST' -and $Path -eq 'projects/2/variables' }
  }

  It "Should report the change under -WhatIf without printing the value" {
    $Text = Get-DisplayedText { Set-GitlabProjectVariable -ProjectId 1 'K' 'SECRET-VALUE' -WhatIf }
    $Text | Should -Match 'What if'
    $Text | Should -Not -Match 'SECRET-VALUE'
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -ne 'GET' } -Times 0
  }

  It "Should accept an empty value only under -WhatIf" {
    { Set-GitlabProjectVariable -ProjectId 1 'K' $null -WhatIf } | Should -Not -Throw
    { Set-GitlabProjectVariable -ProjectId 1 'K' '' } | Should -Throw '*empty*'
    Should -Invoke Invoke-GitlabApi -ModuleName Projects -ParameterFilter { $HttpMethod -ne 'GET' } -Times 0
  }
}

Describe "Get-GitlabGroupVariable" {
  It "Should write a non-terminating not-found error for a missing key" {
    Mock -CommandName Invoke-GitlabApi -ModuleName Groups -MockWith { throw (New-HttpError 404) }
    $Result = Get-GitlabGroupVariable -GroupId 'g' -Key 'MISSING' -ErrorAction SilentlyContinue -ErrorVariable Errors
    $Result | Should -BeNullOrEmpty
    $Errors.CategoryInfo.Category | Should -Contain 'ObjectNotFound'
  }
}

Describe "Set-GitlabGroupVariable" {
  It "Should report the change under -WhatIf without printing the value" {
    Mock -CommandName Invoke-GitlabApi -ModuleName Groups -ParameterFilter { $HttpMethod -eq 'GET' } -MockWith { throw (New-HttpError 404) }
    Mock -CommandName Invoke-GitlabApi -ModuleName Groups -ParameterFilter { $HttpMethod -ne 'GET' } -MockWith {}
    $Text = Get-DisplayedText { Set-GitlabGroupVariable -GroupId 'g' 'K' 'SECRET-VALUE' -WhatIf }
    $Text | Should -Match 'What if'
    $Text | Should -Not -Match 'SECRET-VALUE'
    Should -Invoke Invoke-GitlabApi -ModuleName Groups -ParameterFilter { $HttpMethod -ne 'GET' } -Times 0
  }
}
