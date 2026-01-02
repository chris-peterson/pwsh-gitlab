---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineSchedules/Remove-GitlabPipelineSchedule
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabPipelineSchedule
---

# Remove-GitlabPipelineSchedule

## SYNOPSIS

Deletes a pipeline schedule from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabPipelineSchedule [[-ProjectId] <string>] [-PipelineScheduleId] <int>
 [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Permanently deletes a pipeline schedule from a GitLab project. This action cannot be undone. Consider using `Disable-GitlabPipelineSchedule` if you want to temporarily stop a schedule without removing it.

## EXAMPLES

### Example 1: Delete a schedule by ID

```powershell
Remove-GitlabPipelineSchedule -PipelineScheduleId 42
```

Deletes the pipeline schedule with ID 42 from the current project. Prompts for confirmation.

### Example 2: Delete a schedule without confirmation

```powershell
Remove-GitlabPipelineSchedule -PipelineScheduleId 42 -Confirm:$false
```

Deletes the schedule without prompting for confirmation.

### Example 3: Delete inactive schedules

```powershell
Get-GitlabPipelineSchedule -Scope inactive | Remove-GitlabPipelineSchedule
```

Deletes all inactive schedules in the current project.

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

The ID of the pipeline schedule to delete.

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

### None

This cmdlet does not produce any output on success.

### System.Object

HIDE_ME

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This cmdlet has a high ConfirmImpact and will prompt for confirmation by default.

## RELATED LINKS

- [GitLab Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html#delete-a-pipeline-schedule)
- [Get-GitlabPipelineSchedule](Get-GitlabPipelineSchedule.md)
- [Disable-GitlabPipelineSchedule](Disable-GitlabPipelineSchedule.md)
- [New-GitlabPipelineSchedule](New-GitlabPipelineSchedule.md)
