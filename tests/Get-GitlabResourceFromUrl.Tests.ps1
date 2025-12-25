BeforeAll {
  $TestModuleName = "Get-GitlabResourceFromUrl"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue
  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create((Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/Configuration.ps1" -Raw)))) -Force
  function global:Get-GitlabConfiguration {}
}

Describe "Get-GitlabResourceFromUrl" {
  BeforeEach {
    Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
      return [PSCustomObject]@{
        Sites = @(
          [PSCustomObject]@{
            Url = "https://gitlab.example.com"
            IsDefault = $true
          }
        )
      }
    }
  }

  Context "When URL contains a merge request" {
    It "Should extract project, resource type, and resource id" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/project/-/merge_requests/123"
      $Result.ProjectId | Should -Be "group/project"
      $Result.ResourceType | Should -Be "merge_requests"
      $Result.ResourceId | Should -Be "123"
    }
  }

  Context "When URL contains an issue" {
    It "Should extract project, resource type, and resource id" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/project/-/issues/456"
      $Result.ProjectId | Should -Be "group/project"
      $Result.ResourceType | Should -Be "issues"
      $Result.ResourceId | Should -Be "456"
    }
  }

  Context "When URL is a plain project URL" {
    It "Should extract project id without trailing slash" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/project"
      $Result.ProjectId | Should -Be "group/project"
      $Result.ResourceType | Should -BeNullOrEmpty
      $Result.ResourceId | Should -BeNullOrEmpty
    }

    It "Should extract project id with trailing slash" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/project/"
      $Result.ProjectId | Should -Be "group/project"
      $Result.ResourceType | Should -BeNullOrEmpty
      $Result.ResourceId | Should -BeNullOrEmpty
    }

    It "Should extract project id with trailing /-/" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/project/-/"
      $Result.ProjectId | Should -Be "group/project"
      $Result.ResourceType | Should -BeNullOrEmpty
      $Result.ResourceId | Should -BeNullOrEmpty
    }
  }

  Context "When URL contains nested groups" {
    It "Should extract the full project path" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/subgroup/project/-/merge_requests/789"
      $Result.ProjectId | Should -Be "group/subgroup/project"
      $Result.ResourceType | Should -Be "merge_requests"
      $Result.ResourceId | Should -Be "789"
    }

    It "Should extract the full project path for plain project URL" {
      $Result = Get-GitlabResourceFromUrl -Url "https://gitlab.example.com/group/subgroup/project"
      $Result.ProjectId | Should -Be "group/subgroup/project"
      $Result.ResourceType | Should -BeNullOrEmpty
      $Result.ResourceId | Should -BeNullOrEmpty
    }
  }

  Context "When URL does not match any configured site" {
    It "Should throw an error" {
      { Get-GitlabResourceFromUrl -Url "https://unknown.gitlab.com/group/project" } | Should -Throw "*Could not extract a GitLab resource*"
    }
  }
}
