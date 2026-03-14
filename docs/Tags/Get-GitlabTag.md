---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Tags/Get-GitlabTag
Locale: en-US
Module Name: GitlabCli
ms.date: 03/14/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabTag
---

# Get-GitlabTag

## SYNOPSIS

Gets tags from a GitLab project repository.

## SYNTAX

### __AllParameterSets

```
Get-GitlabTag [[-Name] <string>] [-ProjectId <string>] [-Search <string>] [-Sort <string>]
 [-OrderBy <string>] [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

tags


## DESCRIPTION

Retrieves repository tags from a GitLab project. Can list all tags, search for tags by name, or get a specific tag. Tags represent points in a repository's history and are commonly used to mark release versions.

## EXAMPLES

### Example 1: Get all tags from the current project

```powershell
Get-GitlabTag
```

Retrieves all tags from the current project (determined by local git context).

### Example 2: Get a specific tag by name

```powershell
Get-GitlabTag -ProjectId 'mygroup/myproject' -Name 'v1.0.0'
```

Gets the tag named 'v1.0.0' from the specified project.

### Example 3: Search for tags matching a pattern

```powershell
Get-GitlabTag -ProjectId 123 -Search 'v2'
```

Retrieves all tags from project ID 123 that match the search term 'v2'.

## PARAMETERS

### -All

If specified, retrieves all tags by fetching all pages of results. By default, only a limited number of results are returned.

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

The name of a specific tag to retrieve. If not specified, all tags are returned.

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

### -OrderBy

The field to order tags by. Valid values are 'name', 'updated', or 'version'.

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
AcceptedValues:
- name
- updated
- version
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
- Name: (All)
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

A search term to filter tags by name.

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

### -Sort

The sort order for tags. Valid values are 'desc' or 'asc'.

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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Tag

Returns GitLab tag objects containing information about repository tags, including the tag name, message, commit, and release information.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Tags API](https://docs.gitlab.com/ee/api/tags.html)
