---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Milestones/Remove-GitlabMilestone
Locale: en-US
Module Name: GitlabCli
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabMilestone
---

# Remove-GitlabMilestone

## SYNOPSIS

Deletes a milestone from a GitLab project or group.

## SYNTAX

### ByProject

```
Remove-GitlabMilestone [-ProjectId <string>] -MilestoneId <int> [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByGroup

```
Remove-GitlabMilestone [-GroupId <string>] -MilestoneId <int> [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a milestone from a GitLab project or group. This action is irreversible. Only milestones with no issues or merge requests can be deleted.

## EXAMPLES

### Example 1: Delete a project milestone

```powershell
Remove-GitlabMilestone -ProjectId 'mygroup/myproject' -MilestoneId 1
```

Deletes milestone 1 from the specified project. Prompts for confirmation before deleting.

### Example 2: Delete a group milestone without confirmation

```powershell
Remove-GitlabMilestone -GroupId 456 -MilestoneId 2 -Confirm:$false
```

Deletes milestone 2 from the specified group without prompting for confirmation.

## PARAMETERS

### -GroupId

The ID or URL-encoded path of the group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByGroup
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MilestoneId

The ID of the milestone to delete.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured GitLab site.

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

### System.String

You can pipe a project ID or group ID to this cmdlet.

## OUTPUTS

### System.Void

This cmdlet does not produce any output.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Milestones API](https://docs.gitlab.com/ee/api/milestones.html)
