---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Topics/Remove-GitlabTopicAvatar
Locale: en-US
Module Name: GitlabCli
ms.date: 11/19/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabTopicAvatar
---

# Remove-GitlabTopicAvatar

## SYNOPSIS

Removes the avatar image from a GitLab topic.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabTopicAvatar [-TopicId] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Clears the topic's avatar. Prompts for confirmation by default; the removed image cannot be recovered through the API.

## EXAMPLES

### Example 1: Remove the avatar of a topic

```powershell
Remove-GitlabTopicAvatar 42
```

Removes the avatar of topic 42 after prompting for confirmation.

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

### -SiteUrl

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

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

### -TopicId

The ID of the topic. Accepts pipeline input by property name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

Accepts TopicId from pipeline by property name.

## OUTPUTS

### Gitlab.Topic

Returns the updated GitLab topic object.

### System.Object

HIDE_ME

## NOTES

Sends a blank `avatar` value, which GitLab treats as a removal. Requires administrator access.

## RELATED LINKS

- [GitLab Topics API - Remove a topic avatar](https://docs.gitlab.com/api/topics/#remove-a-topic-avatar)
- [Set-GitlabTopicAvatar](Set-GitlabTopicAvatar.md)
