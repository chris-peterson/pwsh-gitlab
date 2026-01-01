---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/Get-GitlabPipelineBridge
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipelineBridge
---

# Get-GitlabPipelineBridge

## SYNOPSIS

Gets bridge jobs (downstream pipeline triggers) from a GitLab pipeline.

## SYNTAX

### Default

```
Get-GitlabPipelineBridge
    [[-ProjectId] <string>]
    [-PipelineId] <string> [[-Scope] <string>]
    [-SiteUrl] <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves bridge jobs from a GitLab pipeline. Bridge jobs are used to trigger downstream (child) pipelines. This cmdlet is useful for understanding multi-project or parent-child pipeline relationships.

## EXAMPLES

### Example 1: Get all bridges from a pipeline

```powershell
Get-GitlabPipelineBridge -ProjectId 'mygroup/myproject' -PipelineId 12345
```

Retrieves all bridge jobs from the specified pipeline.

### Example 2: Get failed bridges from the current project

```powershell
Get-GitlabPipelineBridge -PipelineId 12345 -Scope 'failed'
```

Retrieves only failed bridge jobs from the pipeline.

### Example 3: Get bridges via pipeline

```powershell
Get-GitlabPipeline -PipelineId 12345 | Get-GitlabPipelineBridge
```

Uses the pipeline output to retrieve its bridge jobs.

## PARAMETERS

### -PipelineId

The ID of the pipeline to retrieve bridge jobs from.

```yaml
Type: System.String
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

### -Scope

Filters bridge jobs by status. Valid values: created, pending, running, failed, success, canceled, skipped, manual.

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

### -SiteUrl

The URL of the GitLab site to connect to. Defaults to the configured default site.

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

### System.String

You can pipe a project ID or pipeline ID to this cmdlet.

## OUTPUTS

### Gitlab.PipelineBridge

Returns bridge job objects with properties including the downstream pipeline information.

### System.Object

See [Gitlab.PipelineBridge](#gitlabpipelinebridge)

## NOTES

## RELATED LINKS

- [GitLab Jobs API - List pipeline bridges](https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-bridges)
- [Get-GitlabPipeline](Get-GitlabPipeline.md)
