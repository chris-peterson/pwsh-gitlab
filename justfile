# https://just.systems/man/en/

# :all-the-things!:
default: test lint help

test *ARGS:
    pwsh -Command "Import-Module Pester; Invoke-Pester ./tests {{ARGS}}"

lint:
    pwsh -Command "Invoke-ScriptAnalyzer -Path ./src -Recurse -Settings ./PSScriptAnalyzerSettings.ps1 "

help: help-update help-export

help-update:
    pwsh -File ./docs/.support/scripts/Update-Help.ps1

help-export:
    pwsh -File ./docs/.support/scripts/Export-Help.ps1
