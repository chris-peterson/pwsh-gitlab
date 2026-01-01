---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Get-GitlabPipelineScheduleVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipelineScheduleVariable
---

# Get-GitlabPipelineScheduleVariable

## SYNOPSIS

Gets variables associated with a pipeline schedule.

## SYNTAX

### __AllParameterSets

```
Get-GitlabPipelineScheduleVariable [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [[-Key] <Object>] [[-SiteUrl] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves variables defined on a pipeline schedule. These variables are passed to the pipeline when it runs on schedule. You can optionally filter by a specific variable key.

## EXAMPLES

### Example 1: Get all variables for a schedule

```powershell
Get-GitlabPipelineScheduleVariable -PipelineScheduleId 42
```

Retrieves all variables defined on the pipeline schedule with ID 42.

### Example 2: Get a specific variable

```powershell
Get-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'DEPLOY_ENV'
```

Retrieves only the variable with key 'DEPLOY_ENV' from the schedule.

### Example 3: Get variables using pipeline input

```powershell
Get-GitlabPipelineSchedule -PipelineScheduleId 42 | Get-GitlabPipelineScheduleVariable
```

Pipes a schedule object to retrieve its variables.

## PARAMETERS

### -Key

The key (name) of a specific variable to retrieve. If not specified, all variables are returned.

```yaml
Type: System.Object
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

### -PipelineScheduleId

The ID of the pipeline schedule to get variables for.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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
  ValueFromPipelineByPropertyName: false
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
  Position: 3
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

### System.Int32

PipelineScheduleId can be passed from the pipeline by property name.

## OUTPUTS

### Gitlab.PipelineScheduleVariable

A custom object representing the pipeline schedule variable with properties: Key, Value, and VariableType.

### System.Object

See [Gitlab.PipelineScheduleVariable](#gitlabpipelineschedulevariable)

## NOTES

Variables are retrieved from the schedule's nested structure, not a separate API endpoint.

## RELATED LINKS

- [GitLab Pipeline Schedule Variables](https://docs.gitlab.com/ee/api/pipeline_schedules.html#pipeline-schedule-variables)
- [New-GitlabPipelineScheduleVariable](New-GitlabPipelineScheduleVariable.md)
- [Update-GitlabPipelineScheduleVariable](Update-GitlabPipelineScheduleVariable.md)
- [Remove-GitlabPipelineScheduleVariable](Remove-GitlabPipelineScheduleVariable.md)
