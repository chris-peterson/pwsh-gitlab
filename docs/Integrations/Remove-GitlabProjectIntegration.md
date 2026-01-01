---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Integrations/Remove-GitlabProjectIntegration
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabProjectIntegration
---

# Remove-GitlabProjectIntegration

## SYNOPSIS

Removes an integration from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabProjectIntegration [-Integration] <string> [-ProjectId <string>] [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Disables and removes the specified integration from a project. This action deletes all integration settings and cannot be undone.

## EXAMPLES

### Example 1

```powershell
Remove-GitlabProjectIntegration -Integration 'slack'
```

Removes the Slack integration from the project in the current directory.

### Example 2

```powershell
Remove-GitlabProjectIntegration -ProjectId 'mygroup/myproject' -Integration 'gitlab-slack-application' -Confirm:$false
```

Removes the GitLab for Slack app integration from the specified project without prompting for confirmation.

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

The name of the integration to remove. Currently supports 'slack' and 'gitlab-slack-application'.

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

You can pipe a project ID or integration name to this cmdlet.

## OUTPUTS

### None

This cmdlet does not return any output.

### System.Object

See [System.Void](#systemvoid).

### System.Void

N/A

## NOTES

Corresponds to the GitLab API endpoint: DELETE /projects/:id/integrations/:slug

This cmdlet has a high confirmation impact and will prompt for confirmation by default.

## RELATED LINKS

- [Get-GitlabProjectIntegration](Get-GitlabProjectIntegration.md)
- [Update-GitlabProjectIntegration](Update-GitlabProjectIntegration.md)
- [Enable-GitlabProjectSlackNotification](Enable-GitlabProjectSlackNotification.md)
- [GitLab Integrations API](https://docs.gitlab.com/ee/api/integrations.html)
