---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Search/Search-GitlabProject
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Search-GitlabProject
---

# Search-GitlabProject

## SYNOPSIS

Searches for blobs within a specific GitLab project.

## SYNTAX

### __AllParameterSets

```
Search-GitlabProject [[-ProjectId] <string>] [[-Search] <string>] [[-Filename] <string>]
 [[-SiteUrl] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Searches within a specific GitLab project for code blobs matching a search term or filename pattern. Results include project information for context.

## EXAMPLES

### Example 1: Search for code in the current project

```powershell
Search-GitlabProject -Search 'ConnectionString'
```

Searches the current project (determined by local git context) for code containing 'ConnectionString'.

### Example 2: Search for a specific filename in a project

```powershell
Search-GitlabProject -ProjectId 'my-group/my-project' -Filename 'appsettings.json'
```

Finds all files named 'appsettings.json' in the specified project.

### Example 3: Search a project by ID

```powershell
Search-GitlabProject -ProjectId 12345 -Search 'TODO'
```

Searches project 12345 for code containing 'TODO'.

## PARAMETERS

### -Filename

Filter results to files matching this filename pattern.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project to search. Defaults to '.' (current project from local git context).

```yaml
Type: System.String
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

### -Search

The search query string to find in the project's code.

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

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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

See [Gitlab.SearchResult.Blob](#gitlabsearchresultblob)

### Gitlab.SearchResult.Blob

Returns GitLab search result blob objects.

## NOTES

## RELATED LINKS

- [GitLab Project Search API](https://docs.gitlab.com/ee/api/search.html#project-search-api)
- [Search-Gitlab](Search-Gitlab.md)
