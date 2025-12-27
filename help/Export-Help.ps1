$Module       = 'GitlabCli'
$Language     = 'en-US'
$ScriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$DocsFolder   = Resolve-Path (Join-Path $ScriptDir '../docs')
$ModuleFolder = Resolve-Path (Join-Path $ScriptDir "../src/$Module")
$OutputFolder = Join-Path $ModuleFolder $Language

Import-Module Microsoft.PowerShell.PlatyPS

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

Measure-PlatyPSMarkdown -Path (Join-Path $DocsFolder '*/*.md') |
    Where-Object Filetype -match 'CommandHelp' |
    Import-MarkdownCommandHelp -Path { $_.FilePath } |
    Export-MamlCommandHelp -OutputFolder $OutputFolder -Force | Out-Null

Move-Item -Path (Join-Path $OutputFolder "$Module/$Module-Help.xml") -Destination $OutputFolder -Force
Remove-Item -Path (Join-Path $OutputFolder $Module) -Recurse -Force

$OutputFile = Join-Path $OutputFolder "$Module-Help.xml"
Write-Host "Help exported to: $OutputFile" -ForegroundColor Green
