BeforeAll {
  $TestModuleName = "Resolve-GitlabSite"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/ConfigurationHelpers.ps1" -Raw
    ) -join "`n"))) -Force

  function global:Get-GitlabConfiguration {}
  function global:Get-LocalGitContext {}
}

Describe "Resolve-GitlabSite" {
  Context "When -SiteUrl parameter is provided" {
    BeforeEach {
      Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
        return [PSCustomObject]@{
          Sites = @(
            [PSCustomObject]@{
              Url = "gitlab.com"
              IsDefault = $true
            },
            [PSCustomObject]@{
              Url = "gitlab.example.com"
              IsDefault = $false
            }
          )
        }
      }
    }

    It "Should return the matching site" {
      $Result = Resolve-GitlabSite -SiteUrl "gitlab.example.com"
      $Result.Url | Should -Be "gitlab.example.com"
    }

    It "Should return the matching site with partial match" {
      $Result = Resolve-GitlabSite -SiteUrl "example"
      $Result.Url | Should -Be "gitlab.example.com"
    }
  }

  Context "When -SiteUrl parameter is not provided" {
    Context "When local git context has a matching site" {
      BeforeEach {
        Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Sites = @(
              [PSCustomObject]@{
                Url = "gitlab.com"
                IsDefault = $true
              },
              [PSCustomObject]@{
                Url = "gitlab.example.com"
                IsDefault = $false
              }
            )
          }
        }
        Mock -CommandName Get-LocalGitContext -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Site = "gitlab.example.com"
            Project = "group/project"
            Branch = "main"
          }
        }
      }

      It "Should return the site from local git context" {
        $Result = Resolve-GitlabSite
        $Result.Url | Should -Be "gitlab.example.com"
      }
    }

    Context "When local git context does not have a matching site" {
      BeforeEach {
        Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Sites = @(
              [PSCustomObject]@{
                Url = "gitlab.com"
                IsDefault = $true
              },
              [PSCustomObject]@{
                Url = "gitlab.example.com"
                IsDefault = $false
              }
            )
          }
        }
        Mock -CommandName Get-LocalGitContext -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Site = "unknown.gitlab.com"
            Project = "group/project"
            Branch = "main"
          }
        }
      }

      It "Should return the default site" {
        $Result = Resolve-GitlabSite
        $Result.Url | Should -Be "gitlab.com"
      }
    }

    Context "When no local git context and no default site" {
      BeforeEach {
        Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Sites = @(
              [PSCustomObject]@{
                Url = "gitlab.example.com"
                IsDefault = $false
              }
            )
          }
        }
        Mock -CommandName Get-LocalGitContext -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Site = $null
            Project = $null
            Branch = $null
          }
        }
      }

      It "Should throw an error" {
        { Resolve-GitlabSite } | Should -Throw "*Could not resolve GitLab site*"
      }
    }

    Context "When env-var config is incomplete (GITLAB_URL set without access token)" {
      BeforeEach {
        $script:SavedUrl = $env:GITLAB_URL
        $script:SavedToken = $env:GITLAB_ACCESS_TOKEN
        $env:GITLAB_URL = "gitlab.getty.cloud"
        Remove-Item Env:\GITLAB_ACCESS_TOKEN -ErrorAction SilentlyContinue

        Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Sites = @()
          }
        }
        Mock -CommandName Get-LocalGitContext -ModuleName $TestModuleName -MockWith {
          return $null
        }
      }

      AfterEach {
        if ($null -ne $script:SavedUrl) { $env:GITLAB_URL = $script:SavedUrl } else { Remove-Item Env:\GITLAB_URL -ErrorAction SilentlyContinue }
        if ($null -ne $script:SavedToken) { $env:GITLAB_ACCESS_TOKEN = $script:SavedToken } else { Remove-Item Env:\GITLAB_ACCESS_TOKEN -ErrorAction SilentlyContinue }
      }

      It "Should name the missing GITLAB_ACCESS_TOKEN in the error" {
        { Resolve-GitlabSite } | Should -Throw "*GITLAB_ACCESS_TOKEN*"
      }

      It "Should point at the current docs, not the dead github anchor" {
        { Resolve-GitlabSite } | Should -Throw "*chris-peterson.github.io*"
      }
    }

    Context "When local git context is empty" {
      BeforeEach {
        Mock -CommandName Get-GitlabConfiguration -ModuleName $TestModuleName -MockWith {
          return [PSCustomObject]@{
            Sites = @(
              [PSCustomObject]@{
                Url = "gitlab.com"
                IsDefault = $true
              },
              [PSCustomObject]@{
                Url = "gitlab.example.com"
                IsDefault = $false
              }
            )
          }
        }
        Mock -CommandName Get-LocalGitContext -ModuleName $TestModuleName -MockWith {
          return $null
        }
      }

      It "Should fall back to the default site" {
        $Result = Resolve-GitlabSite
        $Result.Url | Should -Be "gitlab.com"
      }
    }
  }
}
