<#
.SYNOPSIS
    Plumbs a release version and notes into the module manifest and CHANGELOG.

.DESCRIPTION
    Given a version and release notes (typically from a published GitHub
    Release), sets ModuleVersion and ReleaseNotes in GitlabCli.psd1 and prepends
    a dated section to CHANGELOG.md. Run by the release workflow before
    publishing, and locally to preview the changes a release will make.

.EXAMPLE
    ./build/Update-ReleaseArtifacts.ps1 -Version v1.173.0 -ReleaseNotes "### Features`n- Added X"
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    # The release version, with or without a leading 'v' (e.g. v1.173.0 or 1.173.0).
    [Parameter(Mandatory)]
    [string]
    $Version,

    [Parameter(Mandatory)]
    [string]
    $ReleaseNotes,

    [string]
    $Date = (Get-Date -Format 'yyyy-MM-dd'),

    [string]
    $ManifestPath = (Join-Path $PSScriptRoot '../src/GitlabCli/GitlabCli.psd1'),

    [string]
    $ChangelogPath = (Join-Path $PSScriptRoot '../CHANGELOG.md')
)

$ErrorActionPreference = 'Stop'

$NormalizedVersion = $Version -replace '^v', ''
if ($NormalizedVersion -notmatch '^\d+\.\d+\.\d+$') {
    throw "Version '$Version' is not a three-part version (e.g. v1.173.0)."
}

$Notes = $ReleaseNotes.Trim()
if (-not $Notes) {
    throw 'ReleaseNotes is empty; a release must carry notes.'
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

# --- CHANGELOG: prepend a dated section ---
$Header = @"
# Changelog

All notable changes to GitlabCli are recorded here, newest first.
"@

$Entry = "## [$NormalizedVersion] - $Date`n`n$Notes"

if (Test-Path $ChangelogPath) {
    $Existing = (Get-Content $ChangelogPath -Raw).TrimEnd()
    $FirstEntry = $Existing.IndexOf('## [')
    if ($FirstEntry -ge 0) {
        $Intro = $Existing.Substring(0, $FirstEntry).TrimEnd()
        $Rest = $Existing.Substring($FirstEntry).TrimEnd()
        $Changelog = "$Intro`n`n$Entry`n`n$Rest"
    } else {
        $Changelog = "$Existing`n`n$Entry"
    }
} else {
    $Changelog = "$Header`n`n$Entry"
}

if ($PSCmdlet.ShouldProcess($ChangelogPath, "prepend a $NormalizedVersion entry dated $Date")) {
    [System.IO.File]::WriteAllText($ChangelogPath, "$Changelog`n")
}

if (-not $WhatIfPreference) {
    Write-Host "Set ModuleVersion to $NormalizedVersion and recorded CHANGELOG entry for $Date." -ForegroundColor Green
}
