<#
.SYNOPSIS
    Promotes CHANGELOG's Unreleased section into a released version.

.DESCRIPTION
    Reads the accumulated "## [Unreleased]" section of CHANGELOG.md, moves it
    under a dated "## [<version>]" heading with a fresh Unreleased left behind,
    and writes the same text into ModuleVersion and ReleaseNotes in
    GitlabCli.psd1. Run by the release workflow before publishing, and locally
    to preview the changes a release will make.

    -NotesOutputPath additionally writes the promoted text on its own, which the
    release workflow hands to `gh release edit` so the releases page carries the
    same notes.

.EXAMPLE
    ./build/Update-ReleaseArtifacts.ps1 -Version v1.173.0
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    # The release version, with or without a leading 'v' (e.g. v1.173.0 or 1.173.0).
    [Parameter(Mandatory)]
    [string]
    $Version,

    [string]
    $Date = (Get-Date -Format 'yyyy-MM-dd'),

    [string]
    $ManifestPath = (Join-Path $PSScriptRoot '../src/GitlabCli/GitlabCli.psd1'),

    [string]
    $ChangelogPath = (Join-Path $PSScriptRoot '../CHANGELOG.md'),

    # Where to write the promoted notes on their own, for the release body.
    [string]
    $NotesOutputPath
)

$ErrorActionPreference = 'Stop'

$NormalizedVersion = $Version -replace '^v', ''
if ($NormalizedVersion -notmatch '^\d+\.\d+\.\d+$') {
    throw "Version '$Version' is not a three-part version (e.g. v1.173.0)."
}

# --- CHANGELOG: read the Unreleased section ---
if (-not (Test-Path $ChangelogPath)) {
    throw "No changelog at $ChangelogPath; a release promotes its notes from that file's '## [Unreleased]' section."
}

$Changelog = (Get-Content $ChangelogPath -Raw).TrimEnd()

$Unreleased = [regex]::Match($Changelog, '(?m)^##\s+\[Unreleased\].*$')
if (-not $Unreleased.Success) {
    throw "No '## [Unreleased]' section in $ChangelogPath; a release promotes its notes from that section."
}

$BodyStart = $Unreleased.Index + $Unreleased.Length
$NextSection = [regex]::Match($Changelog.Substring($BodyStart), '(?m)^##\s+\[')
$BodyLength = if ($NextSection.Success) { $NextSection.Index } else { $Changelog.Length - $BodyStart }

$Notes = $Changelog.Substring($BodyStart, $BodyLength).Trim()
if (-not $Notes) {
    throw "The '## [Unreleased]' section in $ChangelogPath is empty; record what changed there before releasing."
}

# --- Manifest: ModuleVersion + ReleaseNotes ---
$Manifest = Get-Content $ManifestPath -Raw

$Manifest = [regex]::Replace(
    $Manifest,
    "(?m)^(?<pre>\s*ModuleVersion\s*=\s*')[^']*(?<post>')",
    { param($m) "$($m.Groups['pre'].Value)$NormalizedVersion$($m.Groups['post'].Value)" })

# ReleaseNotes is a single-quoted here-string; swap only its body so the notes
# are stored verbatim (a MatchEvaluator avoids $-substitution inside the notes).
$ReleaseNotesPattern = "(?s)(?<open>ReleaseNotes\s*=\s*@'\r?\n).*?(?<close>\r?\n'@)"
if ($Manifest -notmatch $ReleaseNotesPattern) {
    throw "Could not find a ReleaseNotes here-string in $ManifestPath."
}
$Manifest = [regex]::Replace(
    $Manifest,
    $ReleaseNotesPattern,
    { param($m) "$($m.Groups['open'].Value)$Notes$($m.Groups['close'].Value)" })

if ($PSCmdlet.ShouldProcess($ManifestPath, "set ModuleVersion to $NormalizedVersion and replace ReleaseNotes")) {
    [System.IO.File]::WriteAllText($ManifestPath, $Manifest)

    # Fail loudly if the edit produced a manifest PowerShell can't parse.
    $Parsed = Import-PowerShellDataFile -Path $ManifestPath
    if ($Parsed.ModuleVersion -ne $NormalizedVersion) {
        throw "Manifest ModuleVersion is '$($Parsed.ModuleVersion)', expected '$NormalizedVersion'."
    }
}

# --- CHANGELOG: promote Unreleased to a dated section ---
$Intro = $Changelog.Substring(0, $Unreleased.Index).TrimEnd()
$Released = $Changelog.Substring($BodyStart + $BodyLength).TrimEnd()

$Promoted = "## [Unreleased]`n`n## [$NormalizedVersion] - $Date`n`n$Notes"
$Updated = "$Intro`n`n$Promoted"
if ($Released) {
    $Updated = "$Updated`n`n$Released"
}

if ($PSCmdlet.ShouldProcess($ChangelogPath, "promote Unreleased to a $NormalizedVersion section dated $Date")) {
    [System.IO.File]::WriteAllText($ChangelogPath, "$Updated`n")
}

if ($NotesOutputPath -and $PSCmdlet.ShouldProcess($NotesOutputPath, 'write the promoted notes')) {
    [System.IO.File]::WriteAllText($NotesOutputPath, "$Notes`n")
}

if (-not $WhatIfPreference) {
    Write-Host "Set ModuleVersion to $NormalizedVersion and promoted Unreleased to a CHANGELOG entry dated $Date." -ForegroundColor Green
}
