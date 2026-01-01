---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Update-GitlabPipelineScheduleVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Update-GitlabPipelineScheduleVariable
---

# Update-GitlabPipelineScheduleVariable

## SYNOPSIS

Updates an existing variable on a pipeline schedule.

## SYNTAX

### __AllParameterSets

```
Update-GitlabPipelineScheduleVariable [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [-Key] <string> [-Value] <string> [[-VariableType] <string>] [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates the value or type of an existing variable on a pipeline schedule. The variable is identified by its key.

## EXAMPLES

### Example 1: Update a variable value

```powershell
Update-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'DEPLOY_ENV' -Value 'staging'
```

Updates the DEPLOY_ENV variable to have the value 'staging'.

### Example 2: Change variable type

```powershell
Update-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'CONFIG' -Value '{"debug": true}' -VariableType file
```

Updates the CONFIG variable to be a file variable.

### Example 3: Update a variable in a specific project

```powershell
Update-GitlabPipelineScheduleVariable -ProjectId 'mygroup/myproject' -PipelineScheduleId 42 -Key 'VERSION' -Value '2.0.0'
```

Updates a variable in a schedule for the specified project.

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

### -Key

The key (name) of the variable to update. Must be 1-255 characters and contain only alphanumeric characters and underscores.

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

### -PipelineScheduleId

The ID of the pipeline schedule containing the variable.

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
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Value

The new value for the variable.

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

### -VariableType

The type of variable: 'env_var' (default) for environment variables or 'file' for file variables.

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

### Gitlab.PipelineScheduleVariable

A custom object representing the updated pipeline schedule variable.

### System.Object

See [Gitlab.PipelineScheduleVariable](#gitlabpipelineschedulevariable)

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedule Variables API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#edit-a-pipeline-schedule-variable)
- [Get-GitlabPipelineScheduleVariable](Get-GitlabPipelineScheduleVariable.md)
- [New-GitlabPipelineScheduleVariable](New-GitlabPipelineScheduleVariable.md)
- [Remove-GitlabPipelineScheduleVariable](Remove-GitlabPipelineScheduleVariable.md)
