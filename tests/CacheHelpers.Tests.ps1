BeforeAll {
    Import-Module powershell-yaml

    . $PSScriptRoot/../src/GitlabCli/Private/Globals.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/CacheHelpers.ps1

    function Resolve-GitlabSite {
        param([string]$SiteUrl)
        [PSCustomObject]@{ Url = $SiteUrl }
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
        $script:GitlabCache = @{}
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
        $script:GitlabCache = @{}
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
