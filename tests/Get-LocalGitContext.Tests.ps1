BeforeAll {
  $TestModuleName = "Get-LocalGitContext"
  Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue
  Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create((Get-Content "$PSScriptRoot/../GitlabCli/Git.psm1" -Raw)))) -Force
}

Describe "Get-LocalGitContext" {
  Context "When the current directory is not a git repository" {
    BeforeAll {
      $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "git-test-$(New-Guid)"
      New-Item -ItemType Directory -Path $TempDir | Out-Null
      Push-Location $TempDir
    }

    AfterAll {
      Pop-Location
      Remove-Item -Recurse -Force $TempDir
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
      $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "git-test-$(New-Guid)"
      New-Item -ItemType Directory -Path $TempDir | Out-Null
      Push-Location $TempDir
      git init --initial-branch=main | Out-Null
      git config user.email "test@test.com" | Out-Null
      git config user.name "Test" | Out-Null
      # Need at least one commit for branch to exist
      git commit --allow-empty -m "init" | Out-Null
    }

    AfterAll {
      Pop-Location
      Remove-Item -Recurse -Force $TempDir
    }

    Context "When the remote origin url is an https url" {
      BeforeAll {
        git remote add origin 'https://gitlab.com/group/blah-project-name' 2>$null
      }

      AfterAll {
        git remote remove origin
      }

      It "Should return the site" {
        $Result = Get-LocalGitContext
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result = Get-LocalGitContext
        $Result.Project | Should -Be "group/blah-project-name"
      }

      It "Should return the branch" {
        $Result = Get-LocalGitContext
        $Result.Branch | Should -Be "main"
      }
    }

    Context "When the remote origin url is a git url with .git extension" {
      BeforeAll {
        git remote add origin 'git@gitlab.com:group/blah-project-name.git' 2>$null
      }

      AfterAll {
        git remote remove origin
      }

      It "Should return the site" {
        $Result = Get-LocalGitContext
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result = Get-LocalGitContext
        $Result.Project | Should -Be "group/blah-project-name"
      }

      It "Should return the branch name" {
        $Result = Get-LocalGitContext
        $Result.Branch | Should -Be "main"
      }
    }

    Context "When the remote origin url is a git url with periods in the path and .git extension" {
      BeforeAll {
        git remote add origin 'git@gitlab.com:group/blah.project.name.git' 2>$null
      }

      AfterAll {
        git remote remove origin
      }

      It "Should return the site" {
        $Result = Get-LocalGitContext
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result = Get-LocalGitContext
        $Result.Project | Should -Be "group/blah.project.name"
      }

      It "Should return the branch name" {
        $Result = Get-LocalGitContext
        $Result.Branch | Should -Be "main"
      }
    }

    Context "When in a subdirectory of a git repository" {
      BeforeAll {
        git remote add origin 'git@gitlab.com:group/project.git' 2>$null
        git checkout -b feature/test 2>$null
        $SubDir = Join-Path $TempDir "src/nested/deep"
        New-Item -ItemType Directory -Path $SubDir -Force | Out-Null
        Push-Location $SubDir
      }

      AfterAll {
        Pop-Location
        git checkout main 2>$null
        git branch -D feature/test 2>$null
        git remote remove origin
      }

      It "Should return the site" {
        $Result = Get-LocalGitContext
        $Result.Site | Should -Be "gitlab.com"
      }

      It "Should return the project" {
        $Result = Get-LocalGitContext
        $Result.Project | Should -Be "group/project"
      }

      It "Should return the branch name" {
        $Result = Get-LocalGitContext
        $Result.Branch | Should -Be "feature/test"
      }
    }
  }
}