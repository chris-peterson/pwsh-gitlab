---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/Stop-GitlabPipeline
Locale: en-US
Module Name: GitlabCli
ms.date: 03/14/2026
PlatyPS schema version: 2024-05-01
title: Stop-GitlabPipeline
---

# Stop-GitlabPipeline

## SYNOPSIS

Cancels a pipeline's jobs in a GitLab project.

## SYNTAX

### __AllParameterSets

```
Stop-GitlabPipeline [-PipelineId] <string> [-ProjectId <string>] [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Cancels all cancellable jobs in a pipeline by issuing a POST request to the GitLab cancel pipeline API endpoint. Returns the updated pipeline object.

## EXAMPLES

### Example 1: Cancel a pipeline in the current project

```powershell
Stop-GitlabPipeline -PipelineId 12345
```

Cancels pipeline 12345 in the current project (determined by local git context).

### Example 2: Cancel a pipeline in a specific project

```powershell
Stop-GitlabPipeline -ProjectId 'mygroup/myproject' -PipelineId 12345
```

Cancels pipeline 12345 in the specified project.

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

The ID of the pipeline to cancel.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

The ID or URL-encoded path of the project. Defaults to the current project based on local git context.

```yaml
Type: System.String
DefaultValue: .
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

The URL of the GitLab instance. If not specified, uses the default configured GitLab site.

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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Pipeline

Returns the updated GitLab pipeline object after cancellation.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Pipelines API](https://docs.gitlab.com/ee/api/pipelines.html#cancel-a-pipelines-jobs)
