---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Snippets/Remove-GitlabSnippet
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabSnippet
---

# Remove-GitlabSnippet

## SYNOPSIS

Deletes a GitLab snippet.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabSnippet [-SnippetId] <int> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a personal snippet from GitLab. This action is permanent and cannot be undone.

## EXAMPLES

### Example 1: Delete a snippet by ID

```powershell
Remove-GitlabSnippet -SnippetId 123
```

Deletes snippet 123 after prompting for confirmation.

### Example 2: Delete a snippet via pipeline

```powershell
Get-GitlabSnippet -SnippetId 456 | Remove-GitlabSnippet
```

Retrieves and deletes snippet 456.

### Example 3: Delete multiple snippets

```powershell
Get-GitlabSnippet | Where-Object Title -like '*temp*' | Remove-GitlabSnippet
```

Deletes all snippets with 'temp' in the title.

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

### -SnippetId

The ID of the snippet to delete.

```yaml
Type: System.Int32
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

### System.Int32

The SnippetId parameter accepts pipeline input by property name (aliased as 'Id').

## OUTPUTS

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Snippets API](https://docs.gitlab.com/ee/api/snippets.html#delete-snippet)
- [Get-GitlabSnippet](Get-GitlabSnippet.md)
- [New-GitlabSnippet](New-GitlabSnippet.md)
