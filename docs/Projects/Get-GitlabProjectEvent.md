---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Get-GitlabProjectEvent
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectEvent
---

# Get-GitlabProjectEvent

## SYNOPSIS

Retrieves events (activity) for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabProjectEvent [[-ProjectId] <string>] [-Before <string>] [-After <string>] [-Sort <string>]
 [-MaxPages <int>] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets the visible events for a project. Events include activities such as pushes, comments, merges, and other project-related actions. Results can be filtered by date range and sorted.

## EXAMPLES

### Example 1: Get recent events for the current project

```powershell
Get-GitlabProjectEvent
```

Retrieves recent events for the current directory's project.

### Example 2: Get events in a date range

```powershell
Get-GitlabProjectEvent -After "2024-01-01" -Before "2024-01-31"
```

Retrieves events that occurred in January 2024.

### Example 3: Get events sorted ascending

```powershell
Get-GitlabProjectEvent -Sort "asc" -MaxPages 5
```

Retrieves events sorted by date ascending, up to 5 pages of results.

## PARAMETERS

### -After

Only return events after this date (format: YYYY-MM-DD).

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

### -Before

Only return events before this date (format: YYYY-MM-DD).

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

### -MaxPages

The maximum number of pages to retrieve. GitLab returns 20 results per page by default. Defaults to 1.

```yaml
Type: System.Int32
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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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

### -Sort

The sort order for results. Valid values are 'asc' (ascending) or 'desc' (descending).

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

## OUTPUTS

### Gitlab.Event

Returns GitLab event objects.

### System.Object

See [Gitlab.Event](#gitlabevent)

## NOTES

This cmdlet uses the GitLab Events API to retrieve project activity.

## RELATED LINKS

- [GitLab Events API](https://docs.gitlab.com/ee/api/events.html)
- [List Project Events](https://docs.gitlab.com/ee/api/events.html#list-a-projects-visible-events)
