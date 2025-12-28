BeforeAll {
    Import-Module $PSScriptRoot/../src/GitlabCli -Force
}

Describe 'Invoke-GitlabConfigMigration' {

    BeforeEach {
        $script:OldConfigPath = Join-Path $env:HOME "/.config/powershell/gitlab.config"
        $script:NewConfigPath = $global:GitlabConfigurationPath

        $OldDir = Split-Path -Parent $script:OldConfigPath
        if (-not (Test-Path $OldDir)) {
            New-Item -Type Directory $OldDir -Force | Out-Null
        }

        $script:OldBackup = $null
        $script:NewBackup = $null

        if (Test-Path $script:OldConfigPath) {
            $script:OldBackup = Get-Content $script:OldConfigPath -Raw
            Remove-Item $script:OldConfigPath -Force
        }
        if (Test-Path $script:NewConfigPath) {
            $script:NewBackup = Get-Content $script:NewConfigPath -Raw
            Remove-Item $script:NewConfigPath -Force
        }
    }

    AfterEach {
        Remove-Item $script:OldConfigPath -Force -ErrorAction SilentlyContinue
        Remove-Item $script:NewConfigPath -Force -ErrorAction SilentlyContinue

        if ($script:OldBackup) {
            $script:OldBackup | Set-Content $script:OldConfigPath -Force
        }
        if ($script:NewBackup) {
            $dir = Split-Path -Parent $script:NewConfigPath
            if (-not (Test-Path $dir)) {
                New-Item -Type Directory $dir | Out-Null
            }
            $script:NewBackup | Set-Content $script:NewConfigPath -Force
        }
    }

    It 'migrates old JSON config to new YAML location' {
        $OldConfig = @{
            Sites = @(
                @{ Url = "gitlab.example.com"; AccessToken = "token123"; IsDefault = $true }
            )
        }
        $OldConfig | ConvertTo-Json | Set-Content $script:OldConfigPath

        Invoke-GitlabConfigMigration

        $script:OldConfigPath | Should -Not -Exist
        $script:NewConfigPath | Should -Exist

        $NewConfig = Get-Content $script:NewConfigPath -Raw | ConvertFrom-Yaml
        $NewConfig.Sites | Should -HaveCount 1
        $NewConfig.Sites[0].Url | Should -Be "gitlab.example.com"
        $NewConfig.Sites[0].AccessToken | Should -Be "token123"
    }

    It 'skips migration when old config does not exist' {
        Invoke-GitlabConfigMigration

        $script:NewConfigPath | Should -Not -Exist
    }

    It 'skips migration when new config already exists' {
        @{ Sites = @(@{ Url = "old.example.com" }) } | ConvertTo-Json | Set-Content $script:OldConfigPath
        
        $dir = Split-Path -Parent $script:NewConfigPath
        if (-not (Test-Path $dir)) {
            New-Item -Type Directory $dir | Out-Null
        }
        @{ Sites = @(@{ Url = "new.example.com" }) } | ConvertTo-Yaml | Set-Content $script:NewConfigPath

        Invoke-GitlabConfigMigration

        $script:OldConfigPath | Should -Exist
        $NewConfig = Get-Content $script:NewConfigPath -Raw | ConvertFrom-Yaml
        $NewConfig.Sites[0].Url | Should -Be "new.example.com"
    }

    It 'preserves multiple sites during migration' {
        $OldConfig = @{
            Sites = @(
                @{ Url = "gitlab1.example.com"; AccessToken = "token1"; IsDefault = $true }
                @{ Url = "gitlab2.example.com"; AccessToken = "token2"; IsDefault = $false }
            )
        }
        $OldConfig | ConvertTo-Json -Depth 3 | Set-Content $script:OldConfigPath

        Invoke-GitlabConfigMigration

        $NewConfig = Get-Content $script:NewConfigPath -Raw | ConvertFrom-Yaml
        $NewConfig.Sites | Should -HaveCount 2
        $NewConfig.Sites[0].Url | Should -Be "gitlab1.example.com"
        $NewConfig.Sites[1].Url | Should -Be "gitlab2.example.com"
    }
}
