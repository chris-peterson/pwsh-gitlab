BeforeAll {
    $Script = "$PSScriptRoot/../build/Update-ReleaseArtifacts.ps1"

    # A literal '$' in the body guards the verbatim-notes path through both writes.
    $DefaultUnreleased = "### Features`n- Added `$special"

    function New-Fixtures($Unreleased = $DefaultUnreleased) {
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

## [Unreleased]

$Unreleased

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
            & $Script -Version 'v1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).ModuleVersion | Should -Be '1.173.0'
        }

        It 'Takes its ReleaseNotes from Unreleased, verbatim, including literal dollar signs' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            $Notes = (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).PrivateData.PSData.ReleaseNotes
            $Notes | Should -Be $DefaultUnreleased
        }

        It 'Stores the same text the promoted changelog section gets' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            $Notes = (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).PrivateData.PSData.ReleaseNotes
            $Section = [regex]::Match(
                (Get-Content $Fixtures.ChangelogPath -Raw),
                '(?s)## \[1\.173\.0\] - 2026-07-21\n\n(?<body>.*?)\n\n## \[1\.172\.2\]')
            $Section.Groups['body'].Value | Should -Be $Notes
        }

        It 'Leaves a manifest PowerShell can still parse' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            (Import-PowerShellDataFile -Path $Fixtures.ManifestPath).GUID | Should -Be '220fdbee-bea7-4951-9375-f6e76bd981b4'
        }
    }

    Context 'CHANGELOG promotion' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Moves the Unreleased body under a dated version heading' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            Get-Content $Fixtures.ChangelogPath -Raw |
                Should -Match ([regex]::Escape("## [1.173.0] - 2026-07-21`n`n$DefaultUnreleased"))
        }

        It 'Leaves a fresh, empty Unreleased behind' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            Get-Content $Fixtures.ChangelogPath -Raw |
                Should -Match ([regex]::Escape("## [Unreleased]`n`n## [1.173.0]"))
        }

        It 'Prepends the new entry above existing entries' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            $Content = Get-Content $Fixtures.ChangelogPath -Raw
            $New = $Content.IndexOf('## [1.173.0]')
            $Old = $Content.IndexOf('## [1.172.2]')
            $New | Should -BeGreaterThan 0
            $New | Should -BeLessThan $Old
        }

        It 'Keeps the changelog header intact' {
            & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            Get-Content $Fixtures.ChangelogPath -Raw | Should -BeLike '# Changelog*'
        }
    }

    Context '-NotesOutputPath' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Writes the promoted notes on their own' {
            $NotesPath = Join-Path $Fixtures.Dir 'release-notes.md'
            & $Script -Version '1.173.0' -NotesOutputPath $NotesPath `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            Get-Content $NotesPath -Raw | Should -Be "$DefaultUnreleased`n"
        }

        It 'Writes nothing under -WhatIf' {
            $NotesPath = Join-Path $Fixtures.Dir 'release-notes.md'
            & $Script -Version '1.173.0' -NotesOutputPath $NotesPath -WhatIf `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21'
            Test-Path $NotesPath | Should -BeFalse
        }
    }

    Context 'Validation' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Throws for a non-three-part version' {
            { & $Script -Version '1.2' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } |
                Should -Throw '*three-part version*'
        }

        It 'Throws when there is no Unreleased section, naming the file' {
            [System.IO.File]::WriteAllText($Fixtures.ChangelogPath, "# Changelog`n`n## [1.172.2] - 2026-06-29`n`nnotes`n")
            { & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } |
                Should -Throw "*No *Unreleased* section in $($Fixtures.ChangelogPath)*"
        }

        It 'Throws when the changelog is missing' {
            [System.IO.File]::Delete($Fixtures.ChangelogPath)
            { & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } |
                Should -Throw '*No changelog at*'
        }
    }

    Context 'Validation with an empty Unreleased' {
        BeforeEach { $Fixtures = New-Fixtures '' }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Throws, naming the section and the file' {
            { & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } |
                Should -Throw "*Unreleased* section in $($Fixtures.ChangelogPath) is empty*"
        }

        It 'Leaves the manifest untouched' {
            $ManifestBefore = Get-Content $Fixtures.ManifestPath -Raw
            { & $Script -Version '1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath } | Should -Throw
            Get-Content $Fixtures.ManifestPath -Raw | Should -Be $ManifestBefore
        }
    }

    Context '-WhatIf' {
        BeforeEach { $Fixtures = New-Fixtures }
        AfterEach { Remove-Fixtures $Fixtures }

        It 'Leaves the manifest and changelog untouched' {
            $ManifestBefore = Get-Content $Fixtures.ManifestPath -Raw
            $ChangelogBefore = Get-Content $Fixtures.ChangelogPath -Raw

            & $Script -Version 'v1.173.0' `
                -ManifestPath $Fixtures.ManifestPath -ChangelogPath $Fixtures.ChangelogPath -Date '2026-07-21' -WhatIf

            Get-Content $Fixtures.ManifestPath -Raw | Should -Be $ManifestBefore
            Get-Content $Fixtures.ChangelogPath -Raw | Should -Be $ChangelogBefore
        }
    }
}
