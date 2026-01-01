---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Get-GitlabPipelineSchedule
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipelineSchedule
---

# Get-GitlabPipelineSchedule

## SYNOPSIS

Gets pipeline schedules for a GitLab project.

## SYNTAX

### ByProjectId (Default)

```
Get-GitlabPipelineSchedule [-ProjectId <string>] [-Scope <string>] [-IncludeVariables]
 [-SiteUrl <string>] [<CommonParameters>]
```

### ByPipelineScheduleId

```
Get-GitlabPipelineSchedule -PipelineScheduleId <int> [-ProjectId <string>] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

- `schedule`
- `schedules`


## DESCRIPTION

Retrieves pipeline schedules from a GitLab project. Can return all schedules for a project, filter by scope (active/inactive), or retrieve a specific schedule by ID. When retrieving a specific schedule, variable details are included. Use the `-IncludeVariables` switch to fetch variables for all schedules.

## EXAMPLES

### Example 1: Get all pipeline schedules for the current project

```powershell
Get-GitlabPipelineSchedule
```

Retrieves all pipeline schedules for the current project (determined by local git context).

### Example 2: Get active schedules for a specific project

```powershell
Get-GitlabPipelineSchedule -ProjectId 'mygroup/myproject' -Scope active
```

Retrieves only active pipeline schedules for the specified project.

### Example 3: Get a specific schedule with its variables

```powershell
Get-GitlabPipelineSchedule -PipelineScheduleId 42
```

Retrieves a specific pipeline schedule by ID, including its variables.

## PARAMETERS

### -IncludeVariables

When specified, fetches variable details for each schedule. This requires an additional API call per schedule since variables are only returned by the single schedule endpoint.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProjectId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PipelineScheduleId

The ID of a specific pipeline schedule to retrieve. When specified, returns detailed information including variables.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: ByPipelineScheduleId
  Position: Named
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
- Name: ByPipelineScheduleId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByProjectId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Scope

Filter schedules by their status. Valid values are 'active' or 'inactive'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProjectId
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

ProjectId can be passed from the pipeline.

### System.Management.Automation.SwitchParameter

IncludeVariables switch parameter.

## OUTPUTS

### Gitlab.PipelineSchedule

A custom object representing the pipeline schedule with properties such as Id, Description, Ref, Cron, CronTimezone, NextRunAt, Active, and Variables.

### System.Object

See [Gitlab.PipelineSchedule](#gitlabpipelineschedule)

## NOTES

This cmdlet has aliases: `schedule`, `schedules`.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html)
- [New-GitlabPipelineSchedule](New-GitlabPipelineSchedule.md)
- [Update-GitlabPipelineSchedule](Update-GitlabPipelineSchedule.md)
- [Remove-GitlabPipelineSchedule](Remove-GitlabPipelineSchedule.md)
