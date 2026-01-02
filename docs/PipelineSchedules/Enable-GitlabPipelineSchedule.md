---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Enable-GitlabPipelineSchedule
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Enable-GitlabPipelineSchedule
---

# Enable-GitlabPipelineSchedule

## SYNOPSIS

Enables a pipeline schedule for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Enable-GitlabPipelineSchedule [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Activates an existing pipeline schedule so that it will trigger pipelines according to its cron expression. This is a convenience wrapper around `Update-GitlabPipelineSchedule -Active true`.

## EXAMPLES

### Example 1: Enable a schedule by ID

```powershell
Enable-GitlabPipelineSchedule -PipelineScheduleId 42
```

Enables the pipeline schedule with ID 42 in the current project.

### Example 2: Enable a schedule using pipeline input

```powershell
Get-GitlabPipelineSchedule -Scope inactive | Enable-GitlabPipelineSchedule
```

Enables all inactive schedules in the current project.

### Example 3: Enable a schedule in a specific project

```powershell
Enable-GitlabPipelineSchedule -ProjectId 'mygroup/myproject' -PipelineScheduleId 42
```

Enables the specified schedule in the given project.

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

The ID of the pipeline schedule to enable.

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

A custom object representing the enabled pipeline schedule.

### System.Object

HIDE_ME

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html)
- [Disable-GitlabPipelineSchedule](Disable-GitlabPipelineSchedule.md)
- [Update-GitlabPipelineSchedule](Update-GitlabPipelineSchedule.md)
- [Get-GitlabPipelineSchedule](Get-GitlabPipelineSchedule.md)
