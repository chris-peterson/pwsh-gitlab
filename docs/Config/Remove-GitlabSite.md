---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Config/Remove-GitlabSite
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabSite
---

# Remove-GitlabSite

## SYNOPSIS

Removes a GitLab site from the configuration.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabSite [-Url] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Removes a GitLab site from the local configuration file. This cmdlet has high confirm impact and will prompt for confirmation before removing the site. This cmdlet does not work when configuration is set via environment variables (`$env:GITLAB_ACCESS_TOKEN`).

## EXAMPLES

### Example 1

```powershell
Remove-GitlabSite -Url 'https://gitlab.example.com'
```

Removes the specified GitLab site from the configuration after prompting for confirmation.

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

The URL of the GitLab site to remove from the configuration.

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

### Gitlab.Configuration

Returns the updated GitLab configuration object after the site is removed.

### System.Object

See [Gitlab.Configuration](#gitlabconfiguration).

## NOTES

This cmdlet has ConfirmImpact='High' and will prompt for confirmation by default. Use -Confirm:$false to skip the confirmation prompt.

## RELATED LINKS

- [Add-GitlabSite](Add-GitlabSite.md)
- [Get-GitlabConfiguration](Get-GitlabConfiguration.md)
