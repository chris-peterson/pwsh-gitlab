---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Snippets/Get-GitlabSnippet
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabSnippet
---

# Get-GitlabSnippet

## SYNOPSIS

Retrieves GitLab snippets for the current user or by ID.

## SYNTAX

### Mine (Default)

```
Get-GitlabSnippet [-Mine] [-CreatedAfter <string>] [-CreatedBefore <string>] [-IncludeContent]
 [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### ById

```
Get-GitlabSnippet [-SnippetId] <int> [-CreatedAfter <string>] [-CreatedBefore <string>]
 [-IncludeContent] [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### ByAuthor

```
Get-GitlabSnippet [-AuthorUsername <string>] [-CreatedAfter <string>] [-CreatedBefore <string>]
 [-IncludeContent] [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves personal snippets from GitLab. Can retrieve all snippets for the current user, a specific snippet by ID, or snippets by a specific author. Optionally includes the raw content of each snippet.

## EXAMPLES

### Example 1: Get all snippets for the current user

```powershell
Get-GitlabSnippet
```

Retrieves all snippets owned by the current authenticated user.

### Example 2: Get a specific snippet with content

```powershell
Get-GitlabSnippet -SnippetId 123 -IncludeContent
```

Retrieves snippet 123 and includes its raw content.

### Example 3: Get snippets created within a date range

```powershell
Get-GitlabSnippet -CreatedAfter '2024-01-01' -CreatedBefore '2024-12-31'
```

Retrieves snippets created during the year 2024.

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

### -AuthorUsername

The username of the author whose snippets to retrieve. Uses user impersonation to fetch snippets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByAuthor
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

Return snippets created on or after the specified date (ISO 8601 format).

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

Return snippets created on or before the specified date (ISO 8601 format).

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

### -IncludeContent

Include the raw content of each snippet in the output.

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

Retrieve snippets owned by the current authenticated user. This is the default behavior.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Mine
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

The ID of a specific snippet to retrieve.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: 0
  IsRequired: true
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

See [Gitlab.Snippet](#gitlabsnippet)

### Gitlab.Snippet

Returns GitLab snippet objects.

## NOTES

## RELATED LINKS

- [GitLab Snippets API](https://docs.gitlab.com/ee/api/snippets.html)
- [Get-GitlabSnippetContent](Get-GitlabSnippetContent.md)
- [New-GitlabSnippet](New-GitlabSnippet.md)
- [Update-GitlabSnippet](Update-GitlabSnippet.md)
- [Remove-GitlabSnippet](Remove-GitlabSnippet.md)
