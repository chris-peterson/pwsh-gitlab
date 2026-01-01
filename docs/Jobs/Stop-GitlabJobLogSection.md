---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Stop-GitlabJobLogSection
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Stop-GitlabJobLogSection
---

# Stop-GitlabJobLogSection

## SYNOPSIS

Closes a collapsible section in GitLab CI/CD job logs.

## SYNTAX

### __AllParameterSets

```
Stop-GitlabJobLogSection [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Closes a collapsible section previously started with Start-GitlabJobLogSection. Sections are tracked on a stack, so nested sections are supported.

## EXAMPLES

### Example 1

```powershell
Start-GitlabJobLogSection -HeaderText 'Build Process'
# ... build commands ...
Stop-GitlabJobLogSection
```

Closes the 'Build Process' section.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None

This cmdlet writes ANSI escape sequences to the host and does not return output.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

If called when no sections are open, this cmdlet does nothing. Sections are managed using a stack to support nesting.

## RELATED LINKS

- [Start-GitlabJobLogSection](Start-GitlabJobLogSection.md)
- [Write-GitlabJobTrace](Write-GitlabJobTrace.md)
- [GitLab Custom Collapsible Sections](https://docs.gitlab.com/ee/ci/jobs/index.html#custom-collapsible-sections)
