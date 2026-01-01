---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Snippets/Get-GitlabSnippetContent
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabSnippetContent
---

# Get-GitlabSnippetContent

## SYNOPSIS

Retrieves the raw content of a GitLab snippet.

## SYNTAX

### __AllParameterSets

```
Get-GitlabSnippetContent [-SnippetId] <int> [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the raw content of a GitLab snippet by its ID. Returns the actual text content of the snippet file.

## EXAMPLES

### Example 1: Get snippet content by ID

```powershell
Get-GitlabSnippetContent -SnippetId 123
```

Retrieves and displays the raw content of snippet 123.

### Example 2: Get content via pipeline

```powershell
Get-GitlabSnippet -SnippetId 456 | Get-GitlabSnippetContent
```

Retrieves a snippet and then gets its content via pipeline.

### Example 3: Save snippet content to a file

```powershell
Get-GitlabSnippetContent -SnippetId 789 | Out-File -FilePath './snippet.txt'
```

Retrieves snippet content and saves it to a local file.

## PARAMETERS

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

The ID of the snippet to retrieve content from.

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

See [System.String](#systemstring)

### System.String

Returns a string.

## NOTES

## RELATED LINKS

- [GitLab Snippets API](https://docs.gitlab.com/ee/api/snippets.html#single-snippet-contents)
- [Get-GitlabSnippet](Get-GitlabSnippet.md)
- [New-GitlabSnippet](New-GitlabSnippet.md)
