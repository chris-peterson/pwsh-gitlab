---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Update-GitlabPipelineSchedule
Locale: en-US
Module Name: GitlabCli
ms.date: 12/31/2025
PlatyPS schema version: 2024-05-01
title: Update-GitlabPipelineSchedule
---

# Update-GitlabPipelineSchedule

## SYNOPSIS

Updates an existing pipeline schedule for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Update-GitlabPipelineSchedule [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [[-Description] <string>] [[-Ref] <string>] [[-Cron] <string>] [[-CronTimezone] <string>]
 [[-Active] <bool>] [[-NewOwner] <string>] [[-SiteUrl] <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates properties of an existing pipeline schedule. You can modify the description, branch/ref, cron expression, timezone, active status, or transfer ownership to another user.

## EXAMPLES

### Example 1: Update the cron expression

```powershell
Update-GitlabPipelineSchedule -PipelineScheduleId 42 -Cron '0 8 * * *'
```

Changes the schedule to run at 8:00 AM instead of its previous time.

### Example 2: Disable a schedule

```powershell
Update-GitlabPipelineSchedule -PipelineScheduleId 42 -Active false
```

Disables the pipeline schedule without deleting it.

### Example 3: Transfer ownership of a schedule

```powershell
Update-GitlabPipelineSchedule -ProjectId 'mygroup/myproject' -PipelineScheduleId 42 -NewOwner 'jsmith'
```

Transfers ownership of the schedule to user 'jsmith'.

## PARAMETERS

### -Active

Whether the schedule should be active.
Set to 'true' to enable or 'false' to disable.

```yaml
Type: System.Boolean
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Cron

The cron expression for the schedule (e.g., '0 6 * * *' for daily at 6 AM).

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

### -CronTimezone

The timezone for the cron expression (e.g., 'America/New_York', 'Europe/London').

```yaml
Type: System.String
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

### -Description

A new description for the pipeline schedule.

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

### -NewOwner

The username of the new owner to transfer the schedule to.
Uses impersonation to take ownership on behalf of the user.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -PipelineScheduleId

The ID of the pipeline schedule to update.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project.
Defaults to the current directory's git repository.

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

### -Ref

The branch or tag name to run the scheduled pipeline on.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

### -SiteUrl

The URL of the GitLab instance.
Uses the default site if not specified.

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

### System.String

ProjectId can be passed from the pipeline by property name.

### System.Int32

PipelineScheduleId can be passed from the pipeline by property name.

## OUTPUTS

### Gitlab.PipelineSchedule

A custom object representing the updated pipeline schedule.

### System.Object

See [Gitlab.PipelineSchedule](#gitlabpipelineschedule)

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#edit-a-pipeline-schedule)
- [Get-GitlabPipelineSchedule](Get-GitlabPipelineSchedule.md)
- [Enable-GitlabPipelineSchedule](Enable-GitlabPipelineSchedule.md)
- [Disable-GitlabPipelineSchedule](Disable-GitlabPipelineSchedule.md)
