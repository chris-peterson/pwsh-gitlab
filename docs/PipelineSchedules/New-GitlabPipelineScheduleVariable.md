---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/New-GitlabPipelineScheduleVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabPipelineScheduleVariable
---

# New-GitlabPipelineScheduleVariable

## SYNOPSIS

Creates a new variable for a pipeline schedule.

## SYNTAX

### __AllParameterSets

```
New-GitlabPipelineScheduleVariable [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [-Key] <string> [-Value] <string> [[-VariableType] <string>] [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new variable on a pipeline schedule. The variable will be passed to the pipeline when it runs on schedule. Variables can be of type 'env_var' (environment variable) or 'file' (file variable).

## EXAMPLES

### Example 1: Create an environment variable

```powershell
New-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'DEPLOY_ENV' -Value 'production'
```

Creates an environment variable named DEPLOY_ENV with value 'production'.

### Example 2: Create a file variable

```powershell
New-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'CONFIG_FILE' -Value '{"setting": true}' -VariableType file
```

Creates a file variable that will be written to a file during pipeline execution.

### Example 3: Add multiple variables using pipeline

```powershell
Get-GitlabPipelineSchedule -PipelineScheduleId 42 | ForEach-Object {
    New-GitlabPipelineScheduleVariable -PipelineScheduleId $_.Id -Key 'BUILD_TYPE' -Value 'release'
}
```

Adds a variable to a schedule using pipeline input for the schedule ID.

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

The key (name) of the variable. Must contain only alphanumeric characters and underscores.

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

The ID of the pipeline schedule to add the variable to.

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

The value of the variable.

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

### System.Int32

PipelineScheduleId can be passed from the pipeline by property name.

## OUTPUTS

### Gitlab.PipelineScheduleVariable

A custom object representing the created pipeline schedule variable.

### System.Object

See [Gitlab.PipelineScheduleVariable](#gitlabpipelineschedulevariable)

## NOTES

Supports `-WhatIf` and `-Confirm` parameters for safe execution.

## RELATED LINKS

- [GitLab Pipeline Schedule Variables API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#create-a-new-pipeline-schedule-variable)
- [Get-GitlabPipelineScheduleVariable](Get-GitlabPipelineScheduleVariable.md)
- [Update-GitlabPipelineScheduleVariable](Update-GitlabPipelineScheduleVariable.md)
- [Remove-GitlabPipelineScheduleVariable](Remove-GitlabPipelineScheduleVariable.md)
