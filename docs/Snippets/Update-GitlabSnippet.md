---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Snippets/Update-GitlabSnippet
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Update-GitlabSnippet
---

# Update-GitlabSnippet

## SYNOPSIS

Updates an existing GitLab snippet.

## SYNTAX

### __AllParameterSets

```
Update-GitlabSnippet [-SnippetId] <int> [-Title <string>] [-Description <string>]
 [-Visibility <string>] [-Files <hashtable[]>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates the properties of an existing GitLab snippet, including title, description, visibility, and file contents. Files can be created, updated, deleted, moved, or renamed within the snippet.

## EXAMPLES

### Example 1: Update snippet title

```powershell
Update-GitlabSnippet -SnippetId 123 -Title 'Updated Title'
```

Updates the title of snippet 123.

### Example 2: Change snippet visibility

```powershell
Update-GitlabSnippet -SnippetId 456 -Visibility 'public'
```

Makes snippet 456 publicly visible.

### Example 3: Update snippet files

```powershell
$files = @(
    @{ action = 'update'; file_path = 'main.ps1'; content = 'Write-Host "Updated"' },
    @{ action = 'create'; file_path = 'new-file.ps1'; content = 'Write-Host "New"' }
)
Update-GitlabSnippet -SnippetId 789 -Files $files
```

Updates an existing file and adds a new file to the snippet.

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

The new description for the snippet.

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

### -Files

An array of hashtables defining file operations. Each hashtable should contain 'action' (create, update, delete, move), 'file_path', and optionally 'content' or 'previous_path'.

```yaml
Type: System.Collections.Hashtable[]
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

The ID of the snippet to update.

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

### -Title

The new title for the snippet.

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

### -Visibility

The new visibility level: 'public', 'private', or 'internal'.

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

### System.Int32

The SnippetId parameter accepts pipeline input by property name (aliased as 'Id').

## OUTPUTS

### System.Object

HIDE_ME

### Gitlab.Snippet

Returns GitLab snippet objects.

## NOTES

## RELATED LINKS

- [GitLab Snippets API](https://docs.gitlab.com/ee/api/snippets.html#update-snippet)
- [Get-GitlabSnippet](Get-GitlabSnippet.md)
- [New-GitlabSnippet](New-GitlabSnippet.md)
- [Remove-GitlabSnippet](Remove-GitlabSnippet.md)
