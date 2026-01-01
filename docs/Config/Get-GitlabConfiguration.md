---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Config/Get-GitlabConfiguration
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabConfiguration
---

# Get-GitlabConfiguration

## SYNOPSIS

Gets the current GitLab CLI configuration.

## SYNTAX

### __AllParameterSets

```
Get-GitlabConfiguration [<CommonParameters>]
```

### DefaultSite

```
Get-GitlabConfiguration [-DefaultSite] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the current GitLab CLI configuration, including all configured sites. Configuration can come from either environment variables (`$env:GITLAB_URL` and `$env:GITLAB_ACCESS_TOKEN`) or from the configuration file. If no configuration file exists, a blank one is created.

## EXAMPLES

### Example 1

```powershell
Get-GitlabConfiguration
```

Returns the current GitLab CLI configuration with all configured sites.

## PARAMETERS

### -DefaultSite

When specified, returns only the default site configuration.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DefaultSite
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

Specifies the URL of the GitLab site to retrieve configuration for.

```yaml
Type: System.String
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Gitlab.Configuration

Returns a configuration object containing a Sites property with all configured GitLab sites.

### System.Object

See [Gitlab.Configuration](#gitlabconfiguration).

### Gitlab.Site

In some cases, just a site is returned (e.g. [default site](#defaultsite))

## NOTES

When `$env:GITLAB_ACCESS_TOKEN` is set, configuration is read from environment variables instead of the configuration file. The URL defaults to 'gitlab.com' if `$env:GITLAB_URL` is not set.

## RELATED LINKS

- [Add-GitlabSite](Add-GitlabSite.md)
- [Remove-GitlabSite](Remove-GitlabSite.md)
- [Set-DefaultGitlabSite](Set-DefaultGitlabSite.md)
