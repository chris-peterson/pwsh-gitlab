---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Todos/Clear-GitlabTodo
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Clear-GitlabTodo
---

# Clear-GitlabTodo

## SYNOPSIS

Marks GitLab to-do items as done.

## SYNTAX

### ById (Default)

```
Clear-GitlabTodo [-TodoId] <Object> [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### All

```
Clear-GitlabTodo [-All] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Mark-GitlabTodoDone`


## DESCRIPTION

Marks one or all to-do items as done in GitLab. Can mark a specific to-do by ID or mark all pending to-dos as done at once.

## EXAMPLES

### Example 1: Mark a specific to-do as done

```powershell
Clear-GitlabTodo -TodoId 123
```

Marks to-do item 123 as done.

### Example 2: Mark all to-dos as done

```powershell
Clear-GitlabTodo -All
```

Marks all pending to-do items as done.

### Example 3: Clear to-dos with WhatIf

```powershell
Clear-GitlabTodo -TodoId 456 -WhatIf
```

Shows what would happen without actually marking the to-do as done.

## PARAMETERS

### -All

Mark all pending to-do items as done.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
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

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured site.

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

### -TodoId

The ID of the specific to-do item to mark as done.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
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

### System.Object

HIDE_ME

## OUTPUTS

### System.Object

HIDE_ME

### Gitlab.Todo

Returns GitLab todo objects.

## NOTES

## RELATED LINKS

- [GitLab Todos API](https://docs.gitlab.com/ee/api/todos.html#mark-a-to-do-item-as-done)
- [Get-GitlabTodo](Get-GitlabTodo.md)
