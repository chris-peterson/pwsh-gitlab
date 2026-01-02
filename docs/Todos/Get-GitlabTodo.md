---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Todos/Get-GitlabTodo
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabTodo
---

# Get-GitlabTodo

## SYNOPSIS

Retrieves the to-do items for the current user.

## SYNTAX

### __AllParameterSets

```
Get-GitlabTodo [[-MaxPages] <uint>] [[-SiteUrl] <string>] [-All] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves a list of pending to-do items from GitLab for the current authenticated user. To-dos are created when users are mentioned, assigned to issues or merge requests, or have other actionable items.

## EXAMPLES

### Example 1: Get all pending to-dos

```powershell
Get-GitlabTodo
```

Retrieves the first page of pending to-do items.

### Example 2: Get all to-dos across all pages

```powershell
Get-GitlabTodo -All
```

Retrieves all pending to-do items by paginating through all results.

### Example 3: Get to-dos with limited pages

```powershell
Get-GitlabTodo -MaxPages 3
```

Retrieves to-do items from up to 3 pages of results.

## PARAMETERS

### -All

Return all results by automatically paginating through all pages.

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

### -MaxPages

The maximum number of result pages to retrieve.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured site.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

HIDE_ME

### Gitlab.Todo

Returns GitLab todo objects.

## NOTES

## RELATED LINKS

- [GitLab Todos API](https://docs.gitlab.com/ee/api/todos.html)
- [Clear-GitlabTodo](Clear-GitlabTodo.md)
