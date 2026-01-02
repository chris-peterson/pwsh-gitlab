---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/AuditEvents/Get-GitlabAuditEvent
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabAuditEvent
---

# Get-GitlabAuditEvent

## SYNOPSIS

Retrieves audit events from GitLab at the instance, group, or project level.

## SYNTAX

### __AllParameterSets

```
Get-GitlabAuditEvent [[-ProjectId] <string>] [[-GroupId] <string>] [[-AuditEventId] <string>]
 [[-EntityType] <string>] [[-EntityId] <string>] [[-MaxPages] <uint>] [[-Before] <string>]
 [[-After] <string>] [[-SiteUrl] <string>] [-FetchAuthors] [-All] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves audit events from GitLab. Audit events track important actions within GitLab, such as user authentication, permission changes, and project/group modifications. This cmdlet can query audit events at the instance level (requires admin), group level, or project level. Results can be filtered by entity type, date range, and specific audit event ID.

## EXAMPLES

### Example 1: Get audit events for a group

```powershell
Get-GitlabAuditEvent -GroupId 'mygroup'
```

Retrieves audit events for the specified group.

### Example 2: Get audit events filtered by date range

```powershell
Get-GitlabAuditEvent -GroupId 'mygroup' -After '2024-01-01' -Before '2024-12-31'
```

Retrieves audit events for the group within the specified date range.

### Example 3: Get audit events with author information

```powershell
Get-GitlabAuditEvent -ProjectId 'mygroup/myproject' -FetchAuthors
```

Retrieves audit events for the project and resolves the author information for each event.

### Example 4: Get audit events for a specific entity

```powershell
Get-GitlabAuditEvent -EntityType 'User' -EntityId '123'
```

Retrieves instance-level audit events for the specified user.

## PARAMETERS

### -After

Filter audit events created after this date. Use ISO 8601 format (YYYY-MM-DD). Alias: Since.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Since
ParameterSets:
- Name: (All)
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -All

Retrieve all results by automatically paginating through all available pages.

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

### -AuditEventId

The ID of a specific audit event to retrieve.

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

### -Before

Filter audit events created before this date. Use ISO 8601 format (YYYY-MM-DD). Alias: Until.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Until
ParameterSets:
- Name: (All)
  Position: 6
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EntityId

The ID of the entity to filter audit events by. Requires -EntityType to also be specified.

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

### -EntityType

The type of entity to filter audit events by. Valid values are 'User', 'Group', or 'Project'.

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

### -FetchAuthors

Resolve and include the full user object for each audit event's author.

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

### -GroupId

The ID or URL-encoded path of the group to retrieve audit events for.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages to retrieve. GitLab returns 20 results per page by default.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project to retrieve audit events for.

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

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 8
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

You can pipe a project or group object to this cmdlet via the ProjectId or GroupId properties.

## OUTPUTS

### Gitlab.AuditEvent

Returns GitLab audit event objects containing details about the tracked actions.

### System.Object

HIDE_ME

## NOTES

Instance-level audit events require GitLab Premium or Ultimate and administrator access.

## RELATED LINKS

- [GitLab Audit Events API](https://docs.gitlab.com/ee/api/audit_events.html)
- [GitLab Group Audit Events API](https://docs.gitlab.com/ee/api/group_audit_events.html)
- [GitLab Project Audit Events API](https://docs.gitlab.com/ee/api/project_audit_events.html)
