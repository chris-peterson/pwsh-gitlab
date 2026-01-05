BeforeAll {
    Import-Module powershell-yaml

    . $PSScriptRoot/../src/GitlabCli/Private/Globals.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/CacheHelpers.ps1

    function Resolve-GitlabSite {
        param([string]$SiteUrl)
        [PSCustomObject]@{ Url = $SiteUrl }
    }

    function Get-LocalGitContext {
        # Default mock - can be overridden in tests
        [PSCustomObject]@{
            Site = ''
            Project = ''
            Branch = ''
            Group = ''
        }
    }
}

Describe 'Resolve-LocalGroupPath with parent navigation' {
    BeforeAll {
        function Get-LocalGitContext {
            [PSCustomObject]@{
                Site = 'gitlab.example.com'
                Project = 'myco/mygroup/infrastructure/myproject'
                Branch = 'main'
                Group = 'myco/mygroup/infrastructure'
            }
        }
    }

    It 'Should resolve . to current group' {
        $Result = Resolve-LocalGroupPath -GroupId '.'
        $Result | Should -Be 'myco/mygroup/infrastructure'
    }

    It 'Should resolve .. to parent group' {
        $Result = Resolve-LocalGroupPath -GroupId '..'
        $Result | Should -Be 'myco/mygroup'
    }

    It 'Should resolve ../.. to grandparent group' {
        $Result = Resolve-LocalGroupPath -GroupId '../..'
        $Result | Should -Be 'myco'
    }

    It 'Should throw when navigating too far up' {
        { Resolve-LocalGroupPath -GroupId '../../..' } | Should -Throw "*already at root*"
    }
}

Describe 'Resolve-LocalGroupPath without git context' {
    BeforeAll {
        function Get-LocalGitContext {
            [PSCustomObject]@{
                Site = ''
                Project = ''
                Branch = ''
                Group = ''
            }
        }
    }

    It 'Should throw when using .. without git context' {
        { Resolve-LocalGroupPath -GroupId '..' } | Should -Throw "*not in a git repository*"
    }
}

Describe 'Get-GitlabCachePath' {
    It 'Should return path in gitlabcli directory' {
        $Result = Get-GitlabCachePath -ResolvedSiteUrl 'https://gitlab.com'
        $Result | Should -Match 'gitlabcli[/\\]cache-'
    }

    It 'Should sanitize URL for filename' {
        $Result = Get-GitlabCachePath -ResolvedSiteUrl 'https://gitlab.example.com'
        $Result | Should -Match 'cache-gitlab.example.com\.yml$'
    }

    It 'Should handle URLs with ports' {
        $Result = Get-GitlabCachePath -ResolvedSiteUrl 'https://gitlab.example.com:8443'
        $Result | Should -Match 'cache-gitlab.example.com_8443\.yml$'
    }
}

Describe 'Get-ProjectIdFromCache' {
    BeforeAll {
        $TestSiteUrl = 'https://test-gitlab.example.com'
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl $TestSiteUrl
        $TestCacheDir = Split-Path -Parent $TestCachePath

        if (-not (Test-Path $TestCacheDir)) {
            New-Item -ItemType Directory -Path $TestCacheDir -Force | Out-Null
        }
    }

    BeforeEach {
        $global:GitlabCache = @{}
    }

    AfterAll {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl 'https://test-gitlab.example.com'
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }
    }

    It 'Should return null when cache file does not exist' {
        $Result = Get-ProjectIdFromCache -ProjectPath 'nonexistent/project' -ResolvedSiteUrl 'https://nonexistent.example.com'
        $Result | Should -BeNullOrEmpty
    }

    It 'Should return null when project is not in cache' {
        $TestSiteUrl = 'https://test-gitlab.example.com'

        Set-ProjectIdInCache -ProjectPath 'other/project' -ProjectId 123 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-ProjectIdFromCache -ProjectPath 'mygroup/myproject' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -BeNullOrEmpty
    }

    It 'Should return cached ID when project is in cache' {
        $TestSiteUrl = 'https://test-gitlab.example.com'

        Set-ProjectIdInCache -ProjectPath 'mygroup/myproject' -ProjectId 42 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-ProjectIdFromCache -ProjectPath 'mygroup/myproject' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -Be 42
    }
}

Describe 'Set-ProjectIdInCache' {
    BeforeAll {
        $TestSiteUrl = 'https://set-test-gitlab.example.com'
    }

    BeforeEach {
        $global:GitlabCache = @{}
    }

    AfterAll {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl 'https://set-test-gitlab.example.com'
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }
    }

    It 'Should create cache file if it does not exist' {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl $TestSiteUrl
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }

        Set-ProjectIdInCache -ProjectPath 'newgroup/newproject' -ProjectId 999 -ResolvedSiteUrl $TestSiteUrl

        Test-Path $TestCachePath | Should -BeTrue
    }

    It 'Should store project mapping in cache' {
        Set-ProjectIdInCache -ProjectPath 'testgroup/testproject' -ProjectId 123 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-ProjectIdFromCache -ProjectPath 'testgroup/testproject' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -Be 123
    }

    It 'Should preserve existing entries when adding new one' {
        Set-ProjectIdInCache -ProjectPath 'first/project' -ProjectId 100 -ResolvedSiteUrl $TestSiteUrl
        Set-ProjectIdInCache -ProjectPath 'second/project' -ProjectId 200 -ResolvedSiteUrl $TestSiteUrl

        $First = Get-ProjectIdFromCache -ProjectPath 'first/project' -ResolvedSiteUrl $TestSiteUrl
        $Second = Get-ProjectIdFromCache -ProjectPath 'second/project' -ResolvedSiteUrl $TestSiteUrl

        $First | Should -Be 100
        $Second | Should -Be 200
    }

    It 'Should update existing entry' {
        Set-ProjectIdInCache -ProjectPath 'update/project' -ProjectId 300 -ResolvedSiteUrl $TestSiteUrl
        Set-ProjectIdInCache -ProjectPath 'update/project' -ProjectId 400 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-ProjectIdFromCache -ProjectPath 'update/project' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -Be 400
    }
}

Describe 'Get-GroupIdFromCache' {
    BeforeAll {
        $TestSiteUrl = 'https://group-test-gitlab.example.com'
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl $TestSiteUrl
        $TestCacheDir = Split-Path -Parent $TestCachePath

        if (-not (Test-Path $TestCacheDir)) {
            New-Item -ItemType Directory -Path $TestCacheDir -Force | Out-Null
        }
    }

    BeforeEach {
        $global:GitlabCache = @{}
    }

    AfterAll {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl 'https://group-test-gitlab.example.com'
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }
    }

    It 'Should return null when cache file does not exist' {
        $Result = Get-GroupIdFromCache -GroupPath 'nonexistent/group' -ResolvedSiteUrl 'https://nonexistent-group.example.com'
        $Result | Should -BeNullOrEmpty
    }

    It 'Should return null when group is not in cache' {
        $TestSiteUrl = 'https://group-test-gitlab.example.com'

        Set-GroupIdInCache -GroupPath 'other/group' -GroupId 123 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-GroupIdFromCache -GroupPath 'mygroup' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -BeNullOrEmpty
    }

    It 'Should return cached ID when group is in cache' {
        $TestSiteUrl = 'https://group-test-gitlab.example.com'

        Set-GroupIdInCache -GroupPath 'mygroup' -GroupId 42 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-GroupIdFromCache -GroupPath 'mygroup' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -Be 42
    }
}

Describe 'Set-GroupIdInCache' {
    BeforeAll {
        $TestSiteUrl = 'https://set-group-test-gitlab.example.com'
    }

    BeforeEach {
        $global:GitlabCache = @{}
    }

    AfterAll {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl 'https://set-group-test-gitlab.example.com'
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }
    }

    It 'Should create cache file if it does not exist' {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl $TestSiteUrl
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }

        Set-GroupIdInCache -GroupPath 'newgroup' -GroupId 999 -ResolvedSiteUrl $TestSiteUrl

        Test-Path $TestCachePath | Should -BeTrue
    }

    It 'Should store group mapping in cache' {
        Set-GroupIdInCache -GroupPath 'testgroup' -GroupId 123 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-GroupIdFromCache -GroupPath 'testgroup' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -Be 123
    }

    It 'Should preserve existing entries when adding new one' {
        Set-GroupIdInCache -GroupPath 'first-group' -GroupId 100 -ResolvedSiteUrl $TestSiteUrl
        Set-GroupIdInCache -GroupPath 'second-group' -GroupId 200 -ResolvedSiteUrl $TestSiteUrl

        $First = Get-GroupIdFromCache -GroupPath 'first-group' -ResolvedSiteUrl $TestSiteUrl
        $Second = Get-GroupIdFromCache -GroupPath 'second-group' -ResolvedSiteUrl $TestSiteUrl

        $First | Should -Be 100
        $Second | Should -Be 200
    }

    It 'Should update existing entry' {
        Set-GroupIdInCache -GroupPath 'update-group' -GroupId 300 -ResolvedSiteUrl $TestSiteUrl
        Set-GroupIdInCache -GroupPath 'update-group' -GroupId 400 -ResolvedSiteUrl $TestSiteUrl

        $Result = Get-GroupIdFromCache -GroupPath 'update-group' -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -Be 400
    }
}

Describe 'Test-GroupIdInCache' {
    BeforeAll {
        $TestSiteUrl = 'https://test-group-id-gitlab.example.com'
    }

    BeforeEach {
        $global:GitlabCache = @{}
    }

    AfterAll {
        $TestCachePath = Get-GitlabCachePath -ResolvedSiteUrl 'https://test-group-id-gitlab.example.com'
        if (Test-Path $TestCachePath) {
            Remove-Item $TestCachePath -Force
        }
    }

    It 'Should return false when cache is empty' {
        $Result = Test-GroupIdInCache -GroupId 123 -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -BeFalse
    }

    It 'Should return false when group ID is not in cache' {
        Set-GroupIdInCache -GroupPath 'somegroup' -GroupId 100 -ResolvedSiteUrl $TestSiteUrl

        $Result = Test-GroupIdInCache -GroupId 999 -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -BeFalse
    }

    It 'Should return true when group ID is in cache' {
        Set-GroupIdInCache -GroupPath 'cachedgroup' -GroupId 42 -ResolvedSiteUrl $TestSiteUrl

        $Result = Test-GroupIdInCache -GroupId 42 -ResolvedSiteUrl $TestSiteUrl
        $Result | Should -BeTrue
    }
}
