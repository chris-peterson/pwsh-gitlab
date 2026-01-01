---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Users/Get-GitlabUserEvent
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabUserEvent
---

# Get-GitlabUserEvent

## SYNOPSIS

Retrieves contribution events for a GitLab user.

## SYNTAX

### ByUserId (Default)

```
Get-GitlabUserEvent [-UserId <string>] [-Action <string>] [-TargetType <string>] [-Before <string>]
 [-After <string>] [-Sort <string>] [-MaxPages <uint>] [-FetchProjects] [-SiteUrl <string>]
 [<CommonParameters>]
```

### ByEmail

```
Get-GitlabUserEvent [-EmailAddress <string>] [-Action <string>] [-TargetType <string>]
 [-Before <string>] [-After <string>] [-Sort <string>] [-MaxPages <uint>] [-FetchProjects]
 [-SiteUrl <string>] [<CommonParameters>]
```

### ByMe

```
Get-GitlabUserEvent [-Me] [-Action <string>] [-TargetType <string>] [-Before <string>]
 [-After <string>] [-Sort <string>] [-MaxPages <uint>] [-FetchProjects] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets user contribution events from GitLab. Events include activities like creating issues, merge requests, comments, pushes, and other user actions. You can filter events by action type, target type, date range, and optionally fetch associated project information.

## EXAMPLES

### Example 1: Get events for the current user

```powershell
Get-GitlabUserEvent -Me
```

Retrieves contribution events for the currently authenticated user.

### Example 2: Get push events for a specific user

```powershell
Get-GitlabUserEvent -UserId "john.doe" -Action pushed
```

Retrieves push events for the specified user.

### Example 3: Get events with project details

```powershell
Get-GitlabUserEvent -Me -FetchProjects -MaxPages 5
```

Retrieves events for the current user with associated project information.

## PARAMETERS

### -Action

Filters events by action type. Valid values include: approved, closed, commented, created, destroyed, expired, joined, left, merged, pushed, reopened, updated.

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

### -After

Filters events to only include those that occurred after this date (YYYY-MM-DD format).

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

Filters events to only include those that occurred before this date (YYYY-MM-DD format).

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

### -EmailAddress

Specifies the user by email address.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByEmail
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FetchProjects

When specified, fetches and attaches project information to each event.

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

Specifies the maximum number of pages of results to retrieve. Default is 1.

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

### -Me

Retrieves events for the currently authenticated user.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByMe
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

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

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

Specifies the sort order of the results. Valid values are: asc, desc.

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

### -TargetType

Filters events by target type. Valid values include: issue, milestone, merge_request, note, project, snippet, user.

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

### -UserId

Specifies the user by ID or username.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Username
ParameterSets:
- Name: ByUserId
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

Returns one or more GitLab event objects containing properties such as ActionName, TargetType, TargetTitle, and CreatedAt.

### System.Object

See [Gitlab.Event](#gitlabevent)

## NOTES

## RELATED LINKS

- [GitLab Events API](https://docs.gitlab.com/ee/api/events.html)
- [Get-GitlabUser](Get-GitlabUser.md)
- [Get-GitlabCurrentUser](Get-GitlabCurrentUser.md)
