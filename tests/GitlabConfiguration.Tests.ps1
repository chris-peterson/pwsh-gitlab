BeforeAll {
    Import-Module $PSScriptRoot/../src/GitlabCli -Force
}

Describe 'Get-GitlabConfiguration environment-variable handling' {

    BeforeAll {
        $script:RealConfigPath = $global:GitlabConfigurationPath
        $script:RealHome = $env:HOME
        $script:RealUrl = $env:GITLAB_URL
        $script:RealToken = $env:GITLAB_ACCESS_TOKEN

        $script:TestTempDir = Join-Path ([System.IO.Path]::GetTempPath()) "GitlabCliCfg_$([System.Guid]::NewGuid().ToString('N'))"
        New-Item -Type Directory $script:TestTempDir -Force | Out-Null
    }

    AfterAll {
        $global:GitlabConfigurationPath = $script:RealConfigPath
        $env:HOME = $script:RealHome
        if ($null -ne $script:RealUrl) { $env:GITLAB_URL = $script:RealUrl } else { Remove-Item Env:\GITLAB_URL -ErrorAction SilentlyContinue }
        if ($null -ne $script:RealToken) { $env:GITLAB_ACCESS_TOKEN = $script:RealToken } else { Remove-Item Env:\GITLAB_ACCESS_TOKEN -ErrorAction SilentlyContinue }
        if (Test-Path $script:TestTempDir) {
            [System.IO.Directory]::Delete($script:TestTempDir, $true)
        }
    }

    BeforeEach {
        $env:HOME = $script:TestTempDir
        $global:GitlabConfigurationPath = Join-Path $script:TestTempDir ".config/powershell/gitlabcli/config.yml"
        Remove-Item $global:GitlabConfigurationPath -Force -ErrorAction SilentlyContinue
        Remove-Item Env:\GITLAB_URL -ErrorAction SilentlyContinue
        Remove-Item Env:\GITLAB_ACCESS_TOKEN -ErrorAction SilentlyContinue
    }

    Context 'When GITLAB_URL is set but GITLAB_ACCESS_TOKEN is not' {
        BeforeEach {
            $env:GITLAB_URL = 'gitlab.getty.cloud'
        }

        It 'warns that the environment-variable configuration is incomplete' {
            Get-GitlabConfiguration -WarningVariable warnings -WarningAction SilentlyContinue | Out-Null
            ($warnings -join "`n") | Should -Match 'GITLAB_ACCESS_TOKEN'
        }
    }

    Context 'When neither env var is set' {
        It 'does not warn about incomplete environment-variable configuration' {
            Get-GitlabConfiguration -WarningVariable warnings -WarningAction SilentlyContinue | Out-Null
            ($warnings -join "`n") | Should -Not -Match 'GITLAB_ACCESS_TOKEN'
        }
    }
}
