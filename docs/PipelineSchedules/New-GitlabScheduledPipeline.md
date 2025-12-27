---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/PipelineSchedules/New-GitlabScheduledPipeline.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabScheduledPipeline
---

# New-GitlabScheduledPipeline

## SYNOPSIS

Triggers a scheduled pipeline to run immediately.

## SYNTAX

### __AllParameterSets

```
New-GitlabScheduledPipeline [-PipelineScheduleId] <int> [-ProjectId <string>] [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Runs a scheduled pipeline immediately without waiting for its next scheduled execution time. This is useful for testing schedule configurations or triggering ad-hoc runs with the schedule's variables.

## EXAMPLES

### Example 1: Trigger a scheduled pipeline immediately

```powershell
New-GitlabScheduledPipeline -PipelineScheduleId 42
```

Runs the pipeline schedule with ID 42 immediately.

### Example 2: Trigger using pipeline input

```powershell
Get-GitlabPipelineSchedule -PipelineScheduleId 42 | New-GitlabScheduledPipeline
```

Pipes a schedule object to trigger it immediately.

### Example 3: Trigger a schedule in a specific project

```powershell
New-GitlabScheduledPipeline -ProjectId 'mygroup/myproject' -PipelineScheduleId 42
```

Triggers the specified schedule in the given project.

## PARAMETERS

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

### -PipelineScheduleId

The ID of the pipeline schedule to trigger.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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
  Position: Named
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

### System.String

Returns a message from the API confirming the pipeline was triggered.

### System.Object

See [System.String](#systemstring)

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#run-a-scheduled-pipeline-immediately)
- [Get-GitlabPipelineSchedule](Get-GitlabPipelineSchedule.md)
- [New-GitlabPipelineSchedule](New-GitlabPipelineSchedule.md)
