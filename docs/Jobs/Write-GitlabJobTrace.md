---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Write-GitlabJobTrace
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Write-GitlabJobTrace
---

# Write-GitlabJobTrace

## SYNOPSIS

Writes colored text to the GitLab CI/CD job log.

## SYNTAX

### __AllParameterSets

```
Write-GitlabJobTrace [[-Text] <string>] [[-Color] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Writes text to the GitLab CI/CD job log with optional ANSI color formatting. This cmdlet is designed to be used within GitLab CI/CD job scripts to produce colored output that displays correctly in the GitLab job log viewer.

## EXAMPLES

### Example 1

```powershell
Write-GitlabJobTrace -Text 'Build successful!' -Color Green
```

Writes a green success message to the job log.

### Example 2

```powershell
Write-GitlabJobTrace -Text 'Warning: deprecated feature used' -Color Yellow
```

Writes a yellow warning message to the job log.

## PARAMETERS

### -Color

The color to use for the text. Valid values are: Black, Red, Green, Orange, Blue, Purple, Cyan, LightGray, DarkGray, LightRed, LightGreen, Yellow, LightBlue, LightPurple, LightCyan, White.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Text

The text to write to the job log.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None

This cmdlet writes to the host and does not return output to the pipeline.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

Uses ANSI escape codes for coloring. Colors are rendered correctly in GitLab job logs and compatible terminals.

## RELATED LINKS

- [Start-GitlabJobLogSection](Start-GitlabJobLogSection.md)
- [Stop-GitlabJobLogSection](Stop-GitlabJobLogSection.md)
