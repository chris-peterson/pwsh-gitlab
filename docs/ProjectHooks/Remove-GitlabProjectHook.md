---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/ProjectHooks/Remove-GitlabProjectHook.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabProjectHook
---

# Remove-GitlabProjectHook

## SYNOPSIS

Removes a webhook from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabProjectHook [[-ProjectId] <string>] [-HookId] <int> [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a webhook (project hook) from a GitLab project. This permanently removes the webhook configuration and stops notifications from being sent to the webhook URL.

## EXAMPLES

### Example 1: Remove a webhook by ID

```powershell
Remove-GitlabProjectHook -ProjectId 'mygroup/myproject' -HookId 123
```

Removes the webhook with ID 123 from the specified project.

### Example 2: Remove a webhook from the current project

```powershell
Remove-GitlabProjectHook -HookId 456
```

Removes the webhook with ID 456 from the project in the current directory.

### Example 3: Remove a webhook using pipeline input

```powershell
Get-GitlabProjectHook -ProjectId 'mygroup/myproject' | Where-Object Url -match 'old-service' | Remove-GitlabProjectHook
```

Removes webhooks that match a URL pattern by piping from Get-GitlabProjectHook.

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

### -HookId

The ID of the webhook to remove. This parameter is required.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. If not specified, defaults to the project in the current directory.

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
  Position: 2
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

### System.Int32

You can pipe a hook ID to this cmdlet.

## OUTPUTS

### None

This cmdlet does not return any output. A confirmation message is written to the host upon successful deletion.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [Get-GitlabProjectHook](Get-GitlabProjectHook.md)
- [New-GitlabProjectHook](New-GitlabProjectHook.md)
- [Update-GitlabProjectHook](Update-GitlabProjectHook.md)
- [GitLab Project Hooks API](https://docs.gitlab.com/ee/api/projects.html#hooks)
