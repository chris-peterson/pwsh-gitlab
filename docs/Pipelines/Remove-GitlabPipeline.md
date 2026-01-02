---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/Remove-GitlabPipeline
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabPipeline
---

# Remove-GitlabPipeline

## SYNOPSIS

Deletes a pipeline from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabPipeline [[-ProjectId] <string>] [-PipelineId] <string> [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Permanently deletes a pipeline and all of its associated resources (jobs, artifacts, logs). This action cannot be undone. The cmdlet will prompt for confirmation before deletion due to its high impact.

## EXAMPLES

### Example 1: Delete a specific pipeline

```powershell
Remove-GitlabPipeline -PipelineId 12345
```

Deletes the pipeline with ID 12345 from the project in the current directory.

### Example 2: Delete a pipeline without confirmation

```powershell
Remove-GitlabPipeline -ProjectId 'mygroup/myproject' -PipelineId 12345 -Confirm:$false
```

Deletes the pipeline without prompting for confirmation.

### Example 3: Delete pipelines via pipeline

```powershell
Get-GitlabPipeline -Status 'failed' | Remove-GitlabPipeline
```

Deletes all failed pipelines from the current project (prompts for each).

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

### -PipelineId

The ID of the pipeline to delete.

```yaml
Type: System.String
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

The ID or URL-encoded path of the project. Defaults to the project in the current directory.

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

The URL of the GitLab site to connect to. Defaults to the configured default site.

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

You can pipe a project ID or pipeline ID to this cmdlet.

## OUTPUTS

### None

This cmdlet does not return any output. A confirmation message is displayed upon successful deletion.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Pipelines API - Delete a pipeline](https://docs.gitlab.com/ee/api/pipelines.html#delete-a-pipeline)
- [Get-GitlabPipeline](Get-GitlabPipeline.md)
- [New-GitlabPipeline](New-GitlabPipeline.md)
