---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/New-GitlabPipelineSchedule
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabPipelineSchedule
---

# New-GitlabPipelineSchedule

## SYNOPSIS

Creates a new pipeline schedule for a GitLab project.

## SYNTAX

### __AllParameterSets

```
New-GitlabPipelineSchedule [[-ProjectId] <string>] [[-Ref] <string>] [-Description] <string>
 [-Cron] <string> [[-CronTimezone] <string>] [[-Active] <bool>] [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new pipeline schedule for a GitLab project. Pipeline schedules allow you to trigger pipelines at specified intervals using cron syntax. You can specify the branch/ref, cron expression, timezone, and whether the schedule should be active.

## EXAMPLES

### Example 1: Create a daily pipeline schedule

```powershell
New-GitlabPipelineSchedule -Description 'Daily build' -Cron '0 6 * * *' -Ref 'main'
```

Creates a pipeline schedule that runs daily at 6:00 AM UTC on the main branch.

### Example 2: Create a schedule with a specific timezone

```powershell
New-GitlabPipelineSchedule -Description 'Nightly tests' -Cron '0 2 * * *' -CronTimezone 'America/New_York' -Ref 'develop'
```

Creates a pipeline schedule that runs at 2:00 AM Eastern time on the develop branch.

### Example 3: Create an inactive schedule for later activation

```powershell
New-GitlabPipelineSchedule -ProjectId 'mygroup/myproject' -Description 'Weekly deploy' -Cron '0 10 * * 1' -Active $false
```

Creates a weekly schedule (Mondays at 10:00 AM) but keeps it inactive.

## PARAMETERS

### -Active

Whether the schedule is active. Active schedules will trigger pipelines according to the cron expression.

```yaml
Type: System.Boolean
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

The cron expression for the schedule (e.g., '0 6 * * *' for daily at 6 AM). Uses standard cron syntax: minute hour day-of-month month day-of-week.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CronTimezone

The timezone for the cron expression (e.g., 'America/New_York', 'Europe/London'). Defaults to 'UTC'.

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

### -Description

A description for the pipeline schedule to identify its purpose.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Ref

The branch or tag name to run the scheduled pipeline on. Defaults to the current branch (local context) or project default branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

### -SiteUrl

The URL of the GitLab instance. Uses the default site if not specified.

```yaml
Type: System.String
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

ProjectId and Ref can be passed from the pipeline by property name.

## OUTPUTS

### Gitlab.PipelineSchedule

A custom object representing the created pipeline schedule.

### System.Object

See [Gitlab.PipelineSchedule](#gitlabpipelineschedule)

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#create-a-new-pipeline-schedule)
- [Get-GitlabPipelineSchedule](Get-GitlabPipelineSchedule.md)
- [Update-GitlabPipelineSchedule](Update-GitlabPipelineSchedule.md)
- [New-GitlabPipelineScheduleVariable](New-GitlabPipelineScheduleVariable.md)
