---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Start-GitlabJobLogSection
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Start-GitlabJobLogSection
---

# Start-GitlabJobLogSection

## SYNOPSIS

Starts a collapsible section in GitLab CI/CD job logs.

## SYNTAX

### __AllParameterSets

```
Start-GitlabJobLogSection [-HeaderText] <string> [-Collapsed] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a collapsible section in GitLab CI/CD job logs using GitLab's section markers. This helps organize long job output into logical, collapsible groups. Must be paired with Stop-GitlabJobLogSection to close the section.

## EXAMPLES

### Example 1

```powershell
Start-GitlabJobLogSection -HeaderText 'Installing Dependencies'
# ... installation commands ...
Stop-GitlabJobLogSection
```

Creates an expanded collapsible section for installation output.

### Example 2

```powershell
Start-GitlabJobLogSection -HeaderText 'Debug Information' -Collapsed
# ... debug output ...
Stop-GitlabJobLogSection
```

Creates a collapsed section that users can expand if needed.

## PARAMETERS

### -Collapsed

When specified, the section will be collapsed by default in the job log. Users can click to expand it.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HeaderText

The text to display as the section header in the job log.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

This cmdlet writes ANSI escape sequences to the host and does not return output.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

This cmdlet is designed to be used within GitLab CI/CD job scripts. The section markers use GitLab's ANSI escape sequence format.

## RELATED LINKS

- [Stop-GitlabJobLogSection](Stop-GitlabJobLogSection.md)
- [Write-GitlabJobTrace](Write-GitlabJobTrace.md)
- [GitLab Custom Collapsible Sections](https://docs.gitlab.com/ee/ci/jobs/index.html#custom-collapsible-sections)
