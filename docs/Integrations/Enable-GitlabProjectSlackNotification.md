---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Integrations/Enable-GitlabProjectSlackNotification
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Enable-GitlabProjectSlackNotification
---

# Enable-GitlabProjectSlackNotification

## SYNOPSIS

Enables and configures Slack notifications for a GitLab project.

## SYNTAX

### SpecificEvents (Default)

```
Enable-GitlabProjectSlackNotification -Channel <string> [-ProjectId <string>] [-Webhook <string>]
 [-Username <string>] [-BranchesToBeNotified <string>] [-NotifyOnlyBrokenPipelines <bool>]
 [-JobEvents <bool>] [-Enable <string[]>] [-Disable <string[]>] [-Integration <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AllEvents

```
Enable-GitlabProjectSlackNotification -Channel <string> [-ProjectId <string>] [-Webhook <string>]
 [-Username <string>] [-BranchesToBeNotified <string>] [-NotifyOnlyBrokenPipelines <bool>]
 [-JobEvents <bool>] [-AllEvents] [-Integration <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NoEvents

```
Enable-GitlabProjectSlackNotification [-ProjectId <string>] [-Webhook <string>] [-Username <string>]
 [-BranchesToBeNotified <string>] [-NotifyOnlyBrokenPipelines <bool>] [-JobEvents <bool>]
 [-NoEvents] [-Integration <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Configures Slack notifications for a GitLab project with a user-friendly interface. This cmdlet wraps Update-GitlabProjectIntegration with Slack-specific parameters for easier configuration. By default, it uses the newer 'gitlab-slack-application' integration, but can also configure the legacy 'slack' webhook integration. If a legacy Slack integration exists, it will be automatically disabled before enabling the new integration.

## EXAMPLES

### Example 1

```powershell
Enable-GitlabProjectSlackNotification -Channel '#deployments' -Enable merge_request, pipeline
```

Enables Slack notifications for merge requests and pipelines to the #deployments channel for the project in the current directory.

### Example 2

```powershell
Enable-GitlabProjectSlackNotification -Channel '#alerts' -AllEvents
```

Enables Slack notifications for all supported events to the #alerts channel.

### Example 3

```powershell
Enable-GitlabProjectSlackNotification -Channel '#ci' -Enable pipeline -NotifyOnlyBrokenPipelines $true
```

Enables pipeline notifications only for broken pipelines to the #ci channel.

### Example 4

```powershell
Enable-GitlabProjectSlackNotification -NoEvents
```

Disables all event notifications while keeping the integration active.

## PARAMETERS

### -AllEvents

Enables notifications for all supported event types. This is a convenience switch that enables: commit, confidential_issue, confidential_note, deployment, issue, merge_request, note, pipeline, push, tag_push, vulnerability, and wiki_page events.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AllEvents
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BranchesToBeNotified

Specifies which branches trigger notifications. Valid values are: 'all', 'default', 'protected', or 'default_and_protected'. Default is 'default_and_protected'.

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

### -Channel

The Slack channel where notifications will be posted (e.g., '#general', '#deployments'). Required when enabling specific events or all events.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AllEvents
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SpecificEvents
  Position: Named
  IsRequired: true
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

### -Disable

An array of event types to disable notifications for. Valid values include: alert, commit, confidential_issue, confidential_note, deployment, issue, merge_request, note, pipeline, push, tag_push, vulnerability, wiki_page.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SpecificEvents
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Enable

An array of event types to enable notifications for. Valid values include: alert, commit, confidential_issue, confidential_note, deployment, issue, merge_request, note, pipeline, push, tag_push, vulnerability, wiki_page.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SpecificEvents
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

The type of Slack integration to use. Valid values are 'slack' (legacy webhook) and 'gitlab-slack-application' (newer app integration). Default is 'gitlab-slack-application'.

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

### -JobEvents

Whether to enable notifications for job events. Set to $true to enable or $false to disable.

```yaml
Type: System.Boolean
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

### -NoEvents

Disables notifications for all event types. Use this to silence all notifications without removing the integration.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NoEvents
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NotifyOnlyBrokenPipelines

When set to $true, pipeline notifications are only sent for broken (failed) pipelines. This reduces notification noise by filtering out successful pipeline runs.

```yaml
Type: System.Boolean
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

### -Username

The username to display in Slack for notification messages. If not specified, the default GitLab bot name is used.

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

### -Webhook

The Slack incoming webhook URL for the legacy 'slack' integration type. Not required when using 'gitlab-slack-application'.

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

Returns the configured Slack integration object.

### System.Object

HIDE_ME

## NOTES

This cmdlet wraps Update-GitlabProjectIntegration with a Slack-specific interface.

The 'gitlab-slack-application' integration is recommended over the legacy 'slack' webhook integration as it provides better functionality and is the preferred method for GitLab-Slack integration.

If a legacy Slack integration is detected, it will be automatically removed before enabling the new integration to avoid conflicts.

## RELATED LINKS

- [Get-GitlabProjectIntegration](Get-GitlabProjectIntegration.md)
- [Update-GitlabProjectIntegration](Update-GitlabProjectIntegration.md)
- [Remove-GitlabProjectIntegration](Remove-GitlabProjectIntegration.md)
- [GitLab for Slack App API](https://docs.gitlab.com/ee/api/integrations.html#gitlab-for-slack-app)
- [Slack Notifications API](https://docs.gitlab.com/ee/api/integrations.html#slack-notifications)
