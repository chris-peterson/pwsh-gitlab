---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Labels/Get-GitlabLabel
Locale: en-US
Module Name: GitlabCli
ms.date: 03/22/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabLabel
---

# Get-GitlabLabel

## SYNOPSIS

Gets labels from a GitLab project or group.

## SYNTAX

### ByProjectId

```
Get-GitlabLabel [-ProjectId <string>] [-LabelId <string>] [-Name <string>] [-Search <string>]
 [-IncludeAncestorGroups] [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### ByGroupId

```
Get-GitlabLabel [-GroupId <string>] [-LabelId <string>] [-Name <string>] [-Search <string>]
 [-IncludeAncestorGroups] [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

labels


## DESCRIPTION

Retrieves labels from a GitLab project or group. Labels are used to categorize and filter issues, merge requests, and epics. You can list all labels, search by name, or filter by specific criteria.

## EXAMPLES

### Example 1: Get all labels from the current project

```powershell
Get-GitlabLabel
```

Retrieves all labels from the current project (determined by local git context).

### Example 2: Get labels from a specific group

```powershell
Get-GitlabLabel -GroupId 'mygroup'
```

Retrieves all labels defined on the specified group.

### Example 3: Search for labels matching a pattern

```powershell
Get-GitlabLabel -Search 'bug'
```

Retrieves labels from the current project whose names match the search term 'bug'.

### Example 4: Get a specific label by name

```powershell
Get-GitlabLabel -Name 'critical'
```

Gets the label named 'critical' from the current project.

## PARAMETERS

### -All

If specified, retrieves all labels by fetching all pages of results.

```yaml
Type: System.Management.Automation.SwitchParameter
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

The ID or URL-encoded path of the group to retrieve labels from.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByGroupId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludeAncestorGroups

If specified, includes labels from ancestor groups.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -LabelId

Specifies the ID of a specific label to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

### -MaxPages

The maximum number of pages of results to retrieve. Each page typically contains 20 items.

```yaml
Type: System.UInt32
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

The exact name of a label to retrieve. If not specified, all labels are returned.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current project based on local git context.

```yaml
Type: System.String
DefaultValue: .
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProjectId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Search

A search term to filter labels by name.

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

### Gitlab.Label

Returns GitLab label objects containing information about labels, including name, color, description, and priority.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Labels API](https://docs.gitlab.com/ee/api/labels.html)
