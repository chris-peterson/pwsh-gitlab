---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Releases/Get-GitlabRelease
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabRelease
---

# Get-GitlabRelease

## SYNOPSIS

Gets releases from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabRelease [[-ProjectId] <string>] [[-Tag] <string>] [[-Sort] <string>] [[-MaxPages] <uint>]
 [[-SiteUrl] <string>] [-IncludeHtml] [-All] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves release information from a GitLab project. Can list all releases or get a specific release by tag. Releases contain information about versioned snapshots of a project including assets and release notes.

## EXAMPLES

### Example 1: Get all releases from the current project

```powershell
Get-GitlabRelease
```

Retrieves all releases from the current project (determined by local git context).

### Example 2: Get a specific release by tag

```powershell
Get-GitlabRelease -ProjectId 'mygroup/myproject' -Tag 'v1.0.0'
```

Gets the release with tag 'v1.0.0' from the specified project.

### Example 3: Get all releases with HTML description included

```powershell
Get-GitlabRelease -ProjectId 123 -IncludeHtml -All
```

Retrieves all releases from project ID 123, including the HTML-rendered description.

## PARAMETERS

### -All

If specified, retrieves all releases by fetching all pages of results. By default, only a limited number of results are returned.

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

### -IncludeHtml

If specified, includes the HTML-rendered description of the release in the response.

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
  Position: 3
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
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Sort

The sort order for releases. Valid values are 'desc' (default) or 'asc'.

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

### -Tag

The tag name of a specific release to retrieve. If not specified, all releases are returned.

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

### System.String

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Release

Returns GitLab release objects containing information about releases, including tag name, description, assets, and release dates.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Releases API](https://docs.gitlab.com/ee/api/releases/)
