---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Issues/Get-GitlabIssue
Locale: en-US
Module Name: GitlabCli
ms.date: 01/26/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabIssue
---

# Get-GitlabIssue

## SYNOPSIS

Retrieves GitLab issues from a project, group, or the authenticated user.

## SYNTAX

### ByProjectId (Default)

```
Get-GitlabIssue [[-IssueId] <string>] [-ProjectId <string>] [-State <string>]
 [-CreatedAfter <string>] [-CreatedBefore <string>] [-AssigneeUsername <string>]
 [-AuthorUsername <string>] [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### ByGroupId

```
Get-GitlabIssue [[-IssueId] <string>] [-GroupId] <string> [-State <string>] [-CreatedAfter <string>]
 [-CreatedBefore <string>] [-AssigneeUsername <string>] [-AuthorUsername <string>]
 [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### Mine

```
Get-GitlabIssue [[-IssueId] <string>] -Mine [-State <string>] [-CreatedAfter <string>]
 [-CreatedBefore <string>] [-AssigneeUsername <string>] [-AuthorUsername <string>]
 [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

- `issue`
- `issues`


## DESCRIPTION

Retrieves issues from GitLab using the Issues API. Issues can be retrieved at the project level, group level, or for the authenticated user. Supports filtering by state, creation date, and author.

## EXAMPLES

### Example 1

```powershell
Get-GitlabIssue
```

Gets all open issues from the current project (determined by local git context).

### Example 2

```powershell
Get-GitlabIssue -ProjectId 'mygroup/myproject' -State closed
```

Gets all closed issues from the specified project.

### Example 3

```powershell
Get-GitlabIssue -Mine
```

Gets all issues authored by the authenticated user.

### Example 4

```powershell
Get-GitlabIssue -GroupId 'mygroup' -CreatedAfter '2024-01-01'
```

Gets all issues created after January 1, 2024 in the specified group.

## PARAMETERS

### -All

When specified, retrieves all issues without pagination limits. Equivalent to setting MaxPages to a very large number.

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

### -AssigneeUsername

Filter issues by the username of the assignee.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- AssignedToUsername
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

### -AuthorUsername

Filter issues by the username of the author.

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

### -CreatedAfter

Return issues created on or after the given date. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value.

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

### -CreatedBefore

Return issues created on or before the given date. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value.

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

The ID or URL-encoded path of the group to retrieve issues from. When specified, retrieves issues from all projects within the group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByGroupId
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IssueId

The internal ID (IID) of a specific issue to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages of results to return. Each page typically contains 20 items.

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

### -Mine

When specified, retrieves only issues authored by the currently authenticated user.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Mine
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

```yaml
Type: System.String
DefaultValue: ''
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

### -State

Filter issues by state. Valid values are 'opened' or 'closed'. Defaults to 'opened'.

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

### Gitlab.Issue

Returns GitLab issue objects containing properties such as Id, Iid, Title, Description, State, Author, Assignees, Labels, and WebUrl.

### System.Object

HIDE_ME

## NOTES

This cmdlet uses the GitLab Issues API. For more information, see https://docs.gitlab.com/ee/api/issues.html

## RELATED LINKS

- [GitLab Issues API](https://docs.gitlab.com/ee/api/issues.html)
- [New-GitlabIssue](New-GitlabIssue.md)
- [Update-GitlabIssue](Update-GitlabIssue.md)
- [Close-GitlabIssue](Close-GitlabIssue.md)
- [Open-GitlabIssue](Open-GitlabIssue.md)
