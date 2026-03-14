---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Milestones/New-GitlabMilestone
Locale: en-US
Module Name: GitlabCli
ms.date: 03/14/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabMilestone
---

# New-GitlabMilestone

## SYNOPSIS

Creates a new milestone in a GitLab project or group.

## SYNTAX

### ByProject

```
New-GitlabMilestone [-Title] <string> [-ProjectId <string>] [-Description <string>]
 [-DueDate <string>] [-StartDate <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByGroup

```
New-GitlabMilestone [-Title] <string> [-GroupId <string>] [-Description <string>]
 [-DueDate <string>] [-StartDate <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new milestone in a GitLab project or group. Milestones can be used to track issues and merge requests towards a specific goal or release.

## EXAMPLES

### Example 1: Create a project milestone

```powershell
New-GitlabMilestone -ProjectId 'mygroup/myproject' -Title 'v1.0'
```

Creates a new milestone named 'v1.0' in the specified project.

### Example 2: Create a group milestone with dates

```powershell
New-GitlabMilestone -GroupId 123 -Title 'Q1 2026' -StartDate '2026-01-01' -DueDate '2026-03-31'
```

Creates a new group milestone with start and due dates.

### Example 3: Create a milestone with a description

```powershell
New-GitlabMilestone -ProjectId 'mygroup/myproject' -Title 'v2.0' -Description 'Major release with breaking changes'
```

Creates a new milestone with a description.

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

The description of the milestone.

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

### -DueDate

The due date of the milestone in YYYY-MM-DD format.

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

### -StartDate

The start date of the milestone in YYYY-MM-DD format.

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

The title of the milestone.

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

You can pipe a project ID or group ID to this cmdlet.

## OUTPUTS

### Gitlab.Milestone

Returns the newly created GitLab milestone object.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Milestones API](https://docs.gitlab.com/ee/api/milestones.html)
