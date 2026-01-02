---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Integrations/Update-GitlabProjectIntegration
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Update-GitlabProjectIntegration
---

# Update-GitlabProjectIntegration

## SYNOPSIS

Updates or enables an integration for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Update-GitlabProjectIntegration [-Integration] <string> [-Settings] <hashtable>
 [-ProjectId <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sets or updates the configuration settings for a project integration. This cmdlet accepts raw API settings as a hashtable, allowing full control over integration configuration. For Slack-specific configuration with a more user-friendly interface, consider using Enable-GitlabProjectSlackNotification instead.

## EXAMPLES

### Example 1

```powershell
Update-GitlabProjectIntegration -Integration 'slack' -Settings @{
    webhook = 'https://hooks.slack.com/services/xxx/yyy/zzz'
    channel = '#deployments'
    push_events = $true
}
```

Configures the Slack integration for the project in the current directory with the specified webhook and channel.

### Example 2

```powershell
Update-GitlabProjectIntegration -ProjectId 'mygroup/myproject' -Integration 'gitlab-slack-application' -Settings @{
    channel = '#alerts'
    branches_to_be_notified = 'default_and_protected'
}
```

Updates the GitLab for Slack app integration settings for the specified project.

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

### -Integration

The name of the integration to update. Currently supports 'slack' and 'gitlab-slack-application'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Slug
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. If not specified, uses the project in the current directory.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Settings

A hashtable containing the integration settings to configure. The available settings depend on the specific integration type. Refer to the GitLab API documentation for the complete list of settings for each integration.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

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

### System.String

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.ProjectIntegration

Returns the updated project integration object.

### System.Object

HIDE_ME

## NOTES

Corresponds to the GitLab API endpoint: PUT /projects/:id/integrations/:slug

## RELATED LINKS

- [Get-GitlabProjectIntegration](Get-GitlabProjectIntegration.md)
- [Remove-GitlabProjectIntegration](Remove-GitlabProjectIntegration.md)
- [Enable-GitlabProjectSlackNotification](Enable-GitlabProjectSlackNotification.md)
- [GitLab Integrations API](https://docs.gitlab.com/ee/api/integrations.html)
