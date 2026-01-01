---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Config/Add-GitlabSite
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Add-GitlabSite
---

# Add-GitlabSite

## SYNOPSIS

Adds a new GitLab site configuration.

## SYNTAX

### __AllParameterSets

```
Add-GitlabSite [[-Url] <string>] [[-AccessToken] <string>] [[-ProxyUrl] <string>] [-IsDefault]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Adds a new GitLab site to the local configuration file. This allows you to configure multiple GitLab instances (e.g., gitlab.com and self-hosted instances) and switch between them. If a site with the same URL already exists, you will be prompted to replace it. This cmdlet does not work when configuration is set via environment variables (`$env:GITLAB_ACCESS_TOKEN`).

## EXAMPLES

### Example 1

```powershell
Add-GitlabSite -Url 'https://gitlab.example.com' -AccessToken 'glpat-xxxx' -IsDefault
```

Adds a new GitLab site and sets it as the default site for API operations.

## PARAMETERS

### -AccessToken

The personal access token used to authenticate with the GitLab API.

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

### -IsDefault

If specified, sets this site as the default GitLab site for API operations.

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

### -ProxyUrl

The URL of a proxy server to use when connecting to the GitLab API.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Url

The URL of the GitLab site to add (e.g., 'https://gitlab.com' or 'https://gitlab.example.com').

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

Returns the updated GitLab configuration object.

### System.Object

See [Gitlab.Configuration](#gitlabconfiguration).

## NOTES

Configuration is stored in a JSON file. When using environment variables for configuration, this cmdlet will display a warning and exit without making changes.

## RELATED LINKS

- [Get-GitlabConfiguration](Get-GitlabConfiguration.md)
- [Remove-GitlabSite](Remove-GitlabSite.md)
- [Set-DefaultGitlabSite](Set-DefaultGitlabSite.md)
