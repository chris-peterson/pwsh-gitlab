---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Topics/New-GitlabTopic
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabTopic
---

# New-GitlabTopic

## SYNOPSIS

Creates a new GitLab topic.

## SYNTAX

### __AllParameterSets

```
New-GitlabTopic [-Name] <string> [-Title <string>] [-Description <string>] [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new project topic in GitLab. Topics are used to categorize projects and make them easier to discover. You can specify a name, title, and description for the topic.

## EXAMPLES

### Example 1: Create a simple topic

```powershell
New-GitlabTopic -Name "devops"
```

Creates a new topic named "devops" with the same value for the title.

### Example 2: Create a topic with title and description

```powershell
New-GitlabTopic -Name "cloud-native" -Title "Cloud Native" -Description "Projects related to cloud-native development"
```

Creates a topic with a custom title and description.

### Example 3: Preview topic creation

```powershell
New-GitlabTopic -Name "testing" -WhatIf
```

Shows what would happen if the topic were created without actually creating it.

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

### -Description

Specifies a description for the topic that explains its purpose or scope.

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

### -Name

Specifies the name of the topic to create. This is a required parameter.

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

### -Title

Specifies the display title of the topic. If not provided, defaults to the Name value.

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

## OUTPUTS

### Gitlab.Topic

Returns the newly created GitLab topic object.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Topics API](https://docs.gitlab.com/ee/api/topics.html)
- [Get-GitlabTopic](Get-GitlabTopic.md)
- [Update-GitlabTopic](Update-GitlabTopic.md)
- [Remove-GitlabTopic](Remove-GitlabTopic.md)
