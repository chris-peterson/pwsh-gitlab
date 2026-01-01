---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/Get-GitlabPipeline
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipeline
---

# Get-GitlabPipeline

## SYNOPSIS

Gets pipelines from a GitLab project.

## SYNTAX

### Default

```
Get-GitlabPipeline
    [[-PipelineId] <string>]
    [-ProjectId <string>]
    [-Ref <string>]
    [-Url <string>]
    [-Scope <string>]
    [-Status <string>]
    [-Source <string>]
    [-Username <string>]
    [-Mine]
    [-Latest]
    [-IncludeTestReport]
    [-FetchDownstream]
    [-MaxPages <uint>]
    [-All]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

- `pipeline`
- `pipelines`


## DESCRIPTION

Retrieves pipeline information from a GitLab project. Can retrieve a single pipeline by ID or list multiple pipelines with various filtering options. Supports filtering by branch/ref, status, scope, source, and username. Can also include test reports and fetch downstream/upstream pipeline relationships.

## EXAMPLES

### Example 1: Get all pipelines for current project

```powershell
Get-GitlabPipeline
```

Retrieves pipelines from the project in the current directory.

### Example 2: Get a specific pipeline by ID

```powershell
Get-GitlabPipeline -ProjectId 'mygroup/myproject' -PipelineId 12345
```

Retrieves the pipeline with ID 12345 from the specified project.

### Example 3: Get pipelines for a specific branch with status filter

```powershell
Get-GitlabPipeline -Ref 'main' -Status 'failed' -Mine
```

Retrieves failed pipelines on the main branch that were triggered by the current user.

## PARAMETERS

### -All

Returns all pipelines without pagination limits.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -FetchDownstream

Includes downstream (child) and upstream (parent) pipeline information using GraphQL. Adds Downstream and Upstream properties to the returned pipeline objects.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- FetchUpstream
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

### -IncludeTestReport

Includes test report data for each pipeline. Adds a TestReport property containing test statistics and results.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Latest

Returns only the most recent pipeline from the results.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -MaxPages

Maximum number of pages of results to retrieve from the API.

```yaml
Type: System.UInt32
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

### -Mine

Filters pipelines to only those triggered by the current authenticated user.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -PipelineId

The ID of a specific pipeline to retrieve.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the project in the current directory.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Ref

The git reference (branch or tag) to filter pipelines by. Use '.' to use the current local branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

### -Scope

The scope of pipelines to return. Valid values: running, pending, finished, branches, tags.

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

### -SiteUrl

The URL of the GitLab site to connect to. Defaults to the configured default site.

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

### -Source

Filters pipelines by how they were triggered. Valid values: push, web, trigger, schedule, api, external, pipeline, chat, webide, merge_request_event, external_pull_request_event, parent_pipeline, ondemand_dast_scan, ondemand_dast_validation.

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

### -Status

Filters pipelines by status. Valid values: created, waiting_for_resource, preparing, pending, running, success, failed, canceled, skipped, manual, scheduled.

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

### -Url

The full URL of a GitLab pipeline. Extracts the project and pipeline ID from the URL.

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

### -Username

Filters pipelines to those triggered by the specified username.

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

You can pipe a project ID or pipeline ID to this cmdlet.

## OUTPUTS

### Gitlab.Pipeline

Returns pipeline objects with properties such as Id, Status, Ref, Sha, WebUrl, CreatedAt, and more.

### System.Object

See [Gitlab.Pipeline](#gitlabpipeline)

## NOTES

## RELATED LINKS

- [GitLab Pipelines API](https://docs.gitlab.com/ee/api/pipelines.html)
- [New-GitlabPipeline](New-GitlabPipeline.md)
- [Remove-GitlabPipeline](Remove-GitlabPipeline.md)
- [Get-GitlabPipelineVariable](Get-GitlabPipelineVariable.md)
