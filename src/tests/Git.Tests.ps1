BeforeAll {
  Import-Module $PSScriptRoot/../GitlabCli/Git.psm1 -Force
}

Describe "Get-LocalGitContext" {
  Context "When the current directory is not a git repository" {
    BeforeAll {
      Mock -CommandName Test-Path `
      -MockWith {
        return $false
      } `
      -ModuleName Git
    }
    It "Should return an empty result" {
      $Result = Get-LocalGitContext
      $Result.Site | Should -BeNullOrEmpty
      $Result.Project | Should -BeNullOrEmpty
      $Result.Branch | Should -BeNullOrEmpty
    }
  }

  Context "When the current directory is a git repository" {
    BeforeAll {
      Mock -CommandName Test-Path `
        -MockWith {
        return $true
      }`
      -ModuleName Git

      Mock -CommandName git `
        -ParameterFilter { 
          $args -match "status" 
        } `
        -MockWith {
          return "On branch main"
        } `
        -ModuleName Git
    }

    Context "When the remote origin url is an https url" {
      BeforeAll {
        Mock `
          -ModuleName Git `
          -CommandName git `
          -ParameterFilter { 
            $args[0] -eq 'config' -and `
              $args[1] -eq '--get' -and `
              $args[2] -eq 'remote.origin.url' 
          } `
          -MockWith {
            return 'https://gitlab.com/group/blah-project-name'  
          }

          $Result = Get-LocalGitContext
      }

      It "Should return the site" {
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result.Project | Should -Be "group/blah-project-name"
      }

      It "Should Return the branch" {
        $Result.Branch | Should -Be "main"
      } 
    }

    Context "When the remote origin url is a git url with .git extension" {
      BeforeAll {
        Mock `
          -ModuleName Git `
          -CommandName git `
          -ParameterFilter { 
            $args[0] -eq 'config' -and `
              $args[1] -eq '--get' -and `
              $args[2] -eq 'remote.origin.url' 
          } `
          -MockWith {
            return 'git@gitlab.com:group/blah-project-name.git' 
          }

          $Result = Get-LocalGitContext
      }

      It "Should return the site" {
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result.Project | Should -Be "group/blah-project-name"
      }

      It "Should return the branch name" {
        $Result.Branch | Should -Be "main"
      }
    }
    
    Context "When the remote origin url is a git url with periods in the path and .git extension" {
      BeforeAll {
        Mock `
        -ModuleName Git `
        -CommandName git `
        -ParameterFilter { 
          $args[0] -eq 'config' -and `
            $args[1] -eq '--get' -and `
            $args[2] -eq 'remote.origin.url' 
        } `
        -MockWith {
          return 'git@gitlab.com:group/blah.project.name.git' 
        }

        $Result = Get-LocalGitContext
      }

      It "Should return the site" {
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result.Project | Should -Be "group/blah.project.name"
      }

      It "Should return the branch name" {
        $Result.Branch | Should -Be "main"
      }
    }
  }
}