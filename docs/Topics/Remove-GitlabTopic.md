---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Topics/Remove-GitlabTopic
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabTopic
---

# Remove-GitlabTopic

## SYNOPSIS

Deletes a GitLab topic.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabTopic [-TopicId] <string> [[-SiteUrl] <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a project topic from GitLab. This operation has high impact and will prompt for confirmation by default. Use -Confirm:$false or -Force to skip the confirmation prompt.

## EXAMPLES

### Example 1: Delete a topic with confirmation

```powershell
Remove-GitlabTopic -TopicId 42
```

Prompts for confirmation before deleting topic 42.

### Example 2: Delete a topic from pipeline

```powershell
Get-GitlabTopic -TopicId 42 | Remove-GitlabTopic
```

Deletes a topic using pipeline input.

### Example 3: Delete a topic without confirmation

```powershell
Remove-GitlabTopic -TopicId 42 -Confirm:$false
```

Deletes topic 42 without prompting for confirmation.

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
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TopicId

Specifies the ID of the topic to delete. Accepts pipeline input by property name.

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

### None

This cmdlet does not return any output. A confirmation message is displayed upon successful deletion.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Topics API](https://docs.gitlab.com/ee/api/topics.html)
- [Get-GitlabTopic](Get-GitlabTopic.md)
- [New-GitlabTopic](New-GitlabTopic.md)
- [Update-GitlabTopic](Update-GitlabTopic.md)
