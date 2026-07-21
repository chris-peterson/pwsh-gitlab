BeforeAll {
    $Script = "$PSScriptRoot/../build/Update-ReleaseArtifacts.ps1"

    function New-Fixtures {
        $Dir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
        New-Item -ItemType Directory -Path $Dir | Out-Null

        $Manifest = @"
@{
    ModuleVersion = '1.172.2'

    PrivateData = @{
        PSData = @{
            ReleaseNotes =
@'
### Bug Fixes
- https://github.com/chris-peterson/pwsh-gitlab/pull/158 - Thanks @rnebular
'@
        }
    }

    GUID = '220fdbee-bea7-4951-9375-f6e76bd981b4'
}
"@
        $ManifestPath = Join-Path $Dir 'GitlabCli.psd1'
        [System.IO.File]::WriteAllText($ManifestPath, $Manifest)

        $ChangelogPath = Join-Path $Dir 'CHANGELOG.md'
        [System.IO.File]::WriteAllText($ChangelogPath, @"
# Changelog

All notable changes to GitlabCli are recorded here, newest first.

## [1.172.2] - 2026-06-29

### Bug Fixes
- https://github.com/chris-peterson/pwsh-gitlab/pull/158 - Thanks @rnebular
"@)

        [pscustomobject]@{
            Dir           = $Dir
            ManifestPath  = $ManifestPath
            ChangelogPath = $ChangelogPath
        }
    }

    function Remove-Fixtures($Fixtures) {
        [System.IO.Directory]::Delete($Fixtures.Dir, $true)
    }
}

Describe 'Update-ReleaseArtifacts' {

    Context 'Manifest updates' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Sets ModuleVersion, stripping a leading v' {
            & $Script -Version 'v1.173.0' -ReleaseNotes "### Features`n- Added X" `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).ModuleVersion | Should -Be '1.173.0'
        }

        It 'Replaces the ReleaseNotes body verbatim, including literal dollar signs' {
            & $Script -Version '1.173.0' -ReleaseNotes "### Features`n- Added `$special" `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            $Notes = (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).PrivateData.PSData.ReleaseNotes
            $Notes | Should -BeLike '*Added $special*'
            $Notes | Should -Not -BeLike '*rnebular*'
        }

        It 'Leaves a manifest PowerShell can still parse' {
            & $Script -Version '1.173.0' -ReleaseNotes 'notes' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).GUID | Should -Be '220fdbee-bea7-4951-9375-f6e76bd981b4'
        }
    }

    Context 'CHANGELOG updates' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Prepends the new entry above existing entries' {
            & $Script -Version '1.173.0' -ReleaseNotes "### Features`n- Added X" `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            $Content = Get-Content $Fixtures.ChangelogPath -Raw
            $New = $Content.IndexOf('## [1.173.0]')
            $Old = $Content.IndexOf('## [1.172.2]')
            $New | Should -BeGreaterThan 0
            $New | Should -BeLessThan $Old
        }

        It 'Keeps the changelog header intact' {
            & $Script -Version '1.173.0' -ReleaseNotes 'notes' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            Get-Content $Fixtures.ChangelogPath -Raw | Should -BeLike '# Changelog*'
        }
    }

    Context 'Validation' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Throws for a non-three-part version' {
            { & $Script -Version '1.2' -ReleaseNotes 'notes' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } |
                Should -Throw '*three-part version*'
        }

        It 'Throws for empty release notes' {
            { & $Script -Version '1.173.0' -ReleaseNotes '   ' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } |
                Should -Throw '*must carry notes*'
        }
    }

    Context '-WhatIf' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Leaves the manifest and changelog untouched' {
            $ManifestBefore = Get-Content $Fixtures.ManifestPath -Raw
            $ChangelogBefore = Get-Content $Fixtures.ChangelogPath -Raw

            & $Script -Version 'v1.173.0' -ReleaseNotes "### Features`n- Added X" `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21' -WhatIf

            Get-Content $Fixtures.ManifestPath -Raw | Should -Be $ManifestBefore
            Get-Content $Fixtures.ChangelogPath -Raw | Should -Be $ChangelogBefore
        }
    }
}
