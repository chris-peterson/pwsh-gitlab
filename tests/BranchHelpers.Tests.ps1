BeforeAll {
    Import-Module $PSScriptRoot/../src/GitlabCli/Git.psm1 -Force
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/BranchHelpers.ps1
}

Describe 'Resolve-GitlabBranch' {
    Context 'When branch name is provided directly' {
        It 'Should return the branch name unchanged' {
            $Result = Resolve-GitlabBranch -Branch 'main'
            $Result | Should -Be 'main'
        }

        It 'Should return feature branch name unchanged' {
            $Result = Resolve-GitlabBranch -Branch 'feature/my-feature'
            $Result | Should -Be 'feature/my-feature'
        }

        It 'Should handle branch names with special characters' {
            $Result = Resolve-GitlabBranch -Branch 'release/v1.0.0'
            $Result | Should -Be 'release/v1.0.0'
        }
    }

    Context 'When branch is "." in a git repository' {
        BeforeAll {
            $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "branch-test-$(New-Guid)"
            New-Item -ItemType Directory -Path $TempDir | Out-Null
            Push-Location $TempDir
            git init --initial-branch=test-branch | Out-Null
            git config user.email "test@test.com" | Out-Null
            git config user.name "Test" | Out-Null
            git commit --allow-empty -m "init" | Out-Null
        }

        AfterAll {
            Pop-Location
            Remove-Item -Recurse -Force $TempDir
        }

        It 'Should resolve "." to the current branch name' {
            $Result = Resolve-GitlabBranch -Branch '.'
            $Result | Should -Be 'test-branch'
        }
    }

    Context 'When branch is "." but not in a git repository' {
        BeforeAll {
            $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "non-git-test-$(New-Guid)"
            New-Item -ItemType Directory -Path $TempDir | Out-Null
            Push-Location $TempDir
        }

        AfterAll {
            Pop-Location
            Remove-Item -Recurse -Force $TempDir
        }

        It 'Should throw an error' {
            { Resolve-GitlabBranch -Branch '.' } | Should -Throw "*Could not infer branch*"
        }
    }

    Context 'Pipeline support' {
        It 'Should accept branch name from pipeline' {
            $Result = 'develop' | Resolve-GitlabBranch
            $Result | Should -Be 'develop'
        }
    }
}

Describe 'Get-GitlabProtectedBranchAccessLevel' {
    It 'Should return NoAccess as 0' {
        $Levels = Get-GitlabProtectedBranchAccessLevel
        $Levels.NoAccess | Should -Be 0
    }

    It 'Should return Developer as 30' {
        $Levels = Get-GitlabProtectedBranchAccessLevel
        $Levels.Developer | Should -Be 30
    }

    It 'Should return Maintainer as 40' {
        $Levels = Get-GitlabProtectedBranchAccessLevel
        $Levels.Maintainer | Should -Be 40
    }

    It 'Should return Admin as 60' {
        $Levels = Get-GitlabProtectedBranchAccessLevel
        $Levels.Admin | Should -Be 60
    }
}
