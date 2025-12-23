BeforeAll {
  $TestModuleName = "Resolve-GitlabSite"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
    @(
      Get-Content "$PSScriptRoot/../GitlabCli/Private/Globals.ps1" -Raw
      Get-Content "$PSScriptRoot/../GitlabCli/Utilities.psm1" -Raw
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
