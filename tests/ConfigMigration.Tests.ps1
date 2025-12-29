BeforeAll {
    Import-Module $PSScriptRoot/../src/GitlabCli -Force
}

Describe 'Invoke-GitlabConfigMigration' {

    BeforeAll {
        # Save the real config path and HOME
        $script:RealConfigPath = $global:GitlabConfigurationPath
        $script:RealHome = $env:HOME
        
        # Create isolated temp directory that will act as fake HOME
        $script:TestTempDir = Join-Path ([System.IO.Path]::GetTempPath()) "GitlabCliTests_$([System.Guid]::NewGuid().ToString('N'))"
        New-Item -Type Directory $script:TestTempDir -Force | Out-Null
    }

    AfterAll {
        # Restore real config path and HOME
        $global:GitlabConfigurationPath = $script:RealConfigPath
        $env:HOME = $script:RealHome
        
        # Clean up temp directory
        if (Test-Path $script:TestTempDir) {
            Remove-Item $script:TestTempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    BeforeEach {
        # Override HOME to our temp directory
        $env:HOME = $script:TestTempDir
        
        # These paths match what the migration function expects
        $script:OldConfigPath = Join-Path $env:HOME ".config/powershell/gitlab.config"
        $script:NewConfigPath = Join-Path $env:HOME ".config/powershell/gitlabcli/config.yml"

        # Point the global to our test path
        $global:GitlabConfigurationPath = $script:NewConfigPath

        # Create old config directory structure
        $OldDir = Split-Path -Parent $script:OldConfigPath
        if (-not (Test-Path $OldDir)) {
            New-Item -Type Directory $OldDir -Force | Out-Null
        }

        # Clean any leftover test files
        Remove-Item $script:OldConfigPath -Force -ErrorAction SilentlyContinue
        Remove-Item $script:NewConfigPath -Force -ErrorAction SilentlyContinue
    }

    AfterEach {
        # Clean up test files
        Remove-Item $script:OldConfigPath -Force -ErrorAction SilentlyContinue
        Remove-Item $script:NewConfigPath -Force -ErrorAction SilentlyContinue
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
