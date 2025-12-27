# Usage:
#   ./Update-Help.ps1                 # Update markdown files
#   ./Update-Help.ps1 -ThrowOnChanges # Update and fail if changes were made (for CI)

param(
    [switch]
    $ThrowOnChanges
)

$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$DocsFolder = Join-Path $ScriptDir '../docs'
$ModulePath = Join-Path $ScriptDir '../src/GitlabCli'
$RepoRoot   = Resolve-Path (Join-Path $ScriptDir '..')

Import-Module Microsoft.PowerShell.PlatyPS
Import-Module $ModulePath -Force

$Module = Get-Module GitlabCli

Write-Host "Updating existing markdown help files..." -ForegroundColor Cyan
$MdFiles = Measure-PlatyPSMarkdown -Path (Join-Path $DocsFolder '*/*.md') -ErrorAction SilentlyContinue
if ($MdFiles) {
    $MdFiles | Where-Object Filetype -match 'CommandHelp' |
        Update-MarkdownCommandHelp -Path { $_.FilePath } -NoBackup
}

Write-Host "Checking for new commands without documentation..." -ForegroundColor Cyan
$NewFiles = New-MarkdownCommandHelp -Module $Module -OutputFolder $DocsFolder -WarningAction SilentlyContinue

foreach ($File in $NewFiles) {
    $RelativePath = $File.FullName -replace [regex]::Escape((Resolve-Path $DocsFolder).Path + '/'), ''
    $Help = Import-MarkdownCommandHelp -Path $File.FullName
    $Help.OnlineVersionUrl = "https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/$RelativePath"
    $Help.ModuleName = 'GitlabCli'
    $Help | Export-MarkdownCommandHelp -OutputFolder $DocsFolder -Force
}

# Check for PlatyPS placeholder text that needs to be filled in
Write-Host "Checking for placeholder text..." -ForegroundColor Cyan
$PlaceholderPattern = '\{\{\s*Fill in'
$PlaceholderMatches = Get-ChildItem -Path $DocsFolder -Filter '*.md' -Recurse |
    Select-String -Pattern $PlaceholderPattern

if ($PlaceholderMatches) {
    Write-Host "`nFound placeholder text that needs to be filled in:" -ForegroundColor Red
    $PlaceholderMatches | ForEach-Object {
        $RelativePath = $_.Path -replace [regex]::Escape((Resolve-Path $DocsFolder).Path + '/'), ''
        Write-Host "  - $RelativePath`:$($_.LineNumber): $($_.Line.Trim())" -ForegroundColor Yellow
    }
    throw "Documentation contains placeholder text. Please fill in the descriptions above."
}

if ($ThrowOnChanges) {
    Push-Location $RepoRoot
    $ModifiedFiles = git diff --name-only -- docs/
    $UntrackedFiles = git ls-files --others --exclude-standard -- docs/
    Pop-Location

    $PendingChanges = @($ModifiedFiles) + @($UntrackedFiles) | Where-Object { $_ }

    if ($PendingChanges) {
        Write-Host "`nThe following markdown help files are out of sync:" -ForegroundColor Red
        $PendingChanges | ForEach-Object {
            Write-Host "  - $_" -ForegroundColor Yellow
        }
        throw "Markdown help is out of sync. Run 'help/Update-Help.ps1' locally and commit the changes."
    }
    else {
        Write-Host "Markdown help is up to date." -ForegroundColor Green
    }
}
else {
    Push-Location $RepoRoot
    $ModifiedFiles = git diff --name-only -- docs/
    $UntrackedFiles = git ls-files --others --exclude-standard -- docs/
    Pop-Location

    $PendingChanges = @($ModifiedFiles) + @($UntrackedFiles) | Where-Object { $_ }

    if ($PendingChanges) {
        Write-Host "Help files updated. Review changes and commit." -ForegroundColor Yellow
    }
    else {
        Write-Host "Help files are up to date." -ForegroundColor Green
    }
}
