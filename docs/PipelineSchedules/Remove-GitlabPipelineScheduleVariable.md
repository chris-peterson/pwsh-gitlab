---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Remove-GitlabPipelineScheduleVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabPipelineScheduleVariable
---

# Remove-GitlabPipelineScheduleVariable

## SYNOPSIS

Deletes a variable from a pipeline schedule.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabPipelineScheduleVariable [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [-Key] <string> [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Permanently removes a variable from a pipeline schedule. The variable is identified by its key.

## EXAMPLES

### Example 1: Delete a variable by key

```powershell
Remove-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'DEPLOY_ENV'
```

Deletes the DEPLOY_ENV variable from the pipeline schedule. Prompts for confirmation.

### Example 2: Delete a variable without confirmation

```powershell
Remove-GitlabPipelineScheduleVariable -PipelineScheduleId 42 -Key 'OLD_VAR' -Confirm:$false
```

Deletes the variable without prompting for confirmation.

### Example 3: Delete a variable from a specific project

```powershell
Remove-GitlabPipelineScheduleVariable -ProjectId 'mygroup/myproject' -PipelineScheduleId 42 -Key 'TEMP_VAR'
```

Deletes a variable from a schedule in the specified project.

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

The key (name) of the variable to delete.

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

## OUTPUTS

### Gitlab.PipelineScheduleVariable

Returns the deleted variable object.

### System.Object

See [Gitlab.PipelineScheduleVariable](#gitlabpipelineschedulevariable)

## NOTES

This cmdlet has a high ConfirmImpact and will prompt for confirmation by default.

## RELATED LINKS

- [GitLab Pipeline Schedule Variables API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#delete-a-pipeline-schedule-variable)
- [Get-GitlabPipelineScheduleVariable](Get-GitlabPipelineScheduleVariable.md)
- [New-GitlabPipelineScheduleVariable](New-GitlabPipelineScheduleVariable.md)
- [Update-GitlabPipelineScheduleVariable](Update-GitlabPipelineScheduleVariable.md)
