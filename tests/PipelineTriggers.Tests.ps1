BeforeAll {
  $TestModuleName = "PipelineTriggers"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
      Get-Content "$PSScriptRoot/../src/GitlabCli/PipelineTriggers.psm1" -Raw
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
  function global:New-GitlabObject {
    param(
      [Parameter(ValueFromPipeline)]$InputObject,
      [Parameter(Position=0)][string]$DisplayType
    )
    process { $InputObject }
  }
}

Describe "Get-GitlabPipelineTrigger" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
      @([PSCustomObject]@{ id = 7; description = 'notify marketplace: group/project' })
    }
  }

  It "Should list the project's triggers" {
    $Result = Get-GitlabPipelineTrigger -ProjectId 'group/project'
    $Result.id | Should -Be 7
    $Result.ProjectId | Should -Be 42
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'GET' -and $Path -eq 'projects/42/triggers'
    }
  }

  It "Should filter to a description, newest first, reading every page" {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
      @(
        [PSCustomObject]@{ Id = 1; Description = 'notify marketplace'; CreatedAt = '2026-01-01T00:00:00Z' }
        [PSCustomObject]@{ Id = 2; Description = 'other'; CreatedAt = '2026-03-01T00:00:00Z' }
        [PSCustomObject]@{ Id = 3; Description = 'notify marketplace'; CreatedAt = '2026-02-01T00:00:00Z' }
      )
    }
    $Result = Get-GitlabPipelineTrigger -ProjectId 'group/project' -Description 'notify marketplace'
    $Result.Id | Should -Be @(3, 1)
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $MaxPages -eq [uint]::MaxValue }
  }

  It "Should get a single trigger by id" {
    Get-GitlabPipelineTrigger -ProjectId 'group/project' -TriggerId 7 | Out-Null
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'GET' -and $Path -eq 'projects/42/triggers/7'
    }
  }
}

Describe "New-GitlabPipelineTrigger" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
      [PSCustomObject]@{ id = 8; description = 'ci'; token = 'glptt-example' }
    }
  }

  It "Should create a trigger with the description" {
    $Result = New-GitlabPipelineTrigger -ProjectId 'group/project' -Description 'ci'
    $Result.token | Should -Be 'glptt-example'
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'POST' -and $Path -eq 'projects/42/triggers' -and $Body.description -eq 'ci'
    }
  }
}

Describe "Remove-GitlabPipelineTrigger" {
  BeforeEach {
    Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {}
  }

  It "Should delete every trigger from the pipeline" {
    @(
      [PSCustomObject]@{ PSTypeName = 'Gitlab.PipelineTrigger'; ProjectId = 42; Id = 1 }
      [PSCustomObject]@{ PSTypeName = 'Gitlab.PipelineTrigger'; ProjectId = 42; Id = 3 }
    ) | Remove-GitlabPipelineTrigger -Force
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $Path -eq 'projects/42/triggers/1' }
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $Path -eq 'projects/42/triggers/3' }
  }

  It "Should delete the trigger" {
    Remove-GitlabPipelineTrigger -ProjectId 'group/project' -TriggerId 8 -Force
    Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
      $HttpMethod -eq 'DELETE' -and $Path -eq 'projects/42/triggers/8'
    }
  }
}
