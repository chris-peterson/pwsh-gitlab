---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Config/Set-DefaultGitlabSite
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Set-DefaultGitlabSite
---

# Set-DefaultGitlabSite

## SYNOPSIS

Sets the default GitLab site for API operations.

## SYNTAX

### __AllParameterSets

```
Set-DefaultGitlabSite [-Url] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sets the specified GitLab site as the default for API operations. The site must already exist in the configuration. This cmdlet does not work when configuration is set via environment variables (`$env:GITLAB_ACCESS_TOKEN`), as environment variable configuration only supports a single site.

## EXAMPLES

### Example 1

```powershell
Set-DefaultGitlabSite -Url 'https://gitlab.example.com'
```

Sets the specified GitLab site as the default for all API operations.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -Url

The URL of an existing GitLab site to set as the default.

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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None

This cmdlet does not produce output.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

The site must already be configured using `Add-GitlabSite` before it can be set as the default. An error is thrown if the specified site is not found.

## RELATED LINKS

- [Add-GitlabSite](Add-GitlabSite.md)
- [Get-GitlabConfiguration](Get-GitlabConfiguration.md)
- [Get-DefaultGitlabSite](Get-DefaultGitlabSite.md)
