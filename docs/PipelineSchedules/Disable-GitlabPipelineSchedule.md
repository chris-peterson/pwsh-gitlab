---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Disable-GitlabPipelineSchedule
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Disable-GitlabPipelineSchedule
---

# Disable-GitlabPipelineSchedule

## SYNOPSIS

Disables a pipeline schedule for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Disable-GitlabPipelineSchedule [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deactivates an existing pipeline schedule so that it will no longer trigger pipelines. The schedule is preserved and can be re-enabled later. This is a convenience wrapper around `Update-GitlabPipelineSchedule -Active false`.

## EXAMPLES

### Example 1: Disable a schedule by ID

```powershell
Disable-GitlabPipelineSchedule -PipelineScheduleId 42
```

Disables the pipeline schedule with ID 42 in the current project.

### Example 2: Disable all active schedules

```powershell
Get-GitlabPipelineSchedule -Scope active | Disable-GitlabPipelineSchedule
```

Disables all active schedules in the current project.

### Example 3: Disable a schedule in a specific project

```powershell
Disable-GitlabPipelineSchedule -ProjectId 'mygroup/myproject' -PipelineScheduleId 42
```

Disables the specified schedule in the given project.

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

The ID of the pipeline schedule to disable.

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

### -SiteUrl

The URL of the GitLab instance. Uses the default site if not specified.

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

A custom object representing the disabled pipeline schedule.

### System.Object

See [Gitlab.PipelineSchedule](#gitlabpipelineschedule)

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html)
- [Enable-GitlabPipelineSchedule](Enable-GitlabPipelineSchedule.md)
- [Update-GitlabPipelineSchedule](Update-GitlabPipelineSchedule.md)
- [Get-GitlabPipelineSchedule](Get-GitlabPipelineSchedule.md)
