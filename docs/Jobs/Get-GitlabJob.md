---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Jobs/Get-GitlabJob.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabJob
---

# Get-GitlabJob

## SYNOPSIS

Retrieves GitLab CI/CD jobs for a project.

## SYNTAX

### Query (Default)

```
Get-GitlabJob [-ProjectId <string>] [-Scope <string>] [-Stage <string>] [-Name <string>]
 [-IncludeTrace] [-IncludeVariables] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

### ByPipeline

```
Get-GitlabJob -PipelineId <string> [-ProjectId <string>] [-Stage <string>] [-Name <string>]
 [-IncludeRetried] [-IncludeTrace] [-IncludeVariables] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

### ById

```
Get-GitlabJob -JobId <string> [-ProjectId <string>] [-Stage <string>] [-Name <string>]
 [-IncludeTrace] [-IncludeVariables] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

- `job`
- `jobs`


## DESCRIPTION

Retrieves GitLab CI/CD jobs from a project. Jobs can be retrieved by project, pipeline, or individual job ID. Supports filtering by scope, stage, and name. Can optionally include job trace logs and manual variables.

## EXAMPLES

### Example 1

```powershell
Get-GitlabJob -ProjectId 'mygroup/myproject'
```

Retrieves all jobs for the specified project.

### Example 2

```powershell
Get-GitlabJob -PipelineId 12345
```

Retrieves all jobs from a specific pipeline.

### Example 3

```powershell
Get-GitlabJob -JobId 67890 -IncludeTrace
```

Retrieves a specific job by ID with its trace log included.

### Example 4

```powershell
Get-GitlabJob -Scope 'failed' -Stage 'test'
```

Retrieves all failed jobs from the test stage.

## PARAMETERS

### -All

Returns all jobs without pagination limits. When specified, retrieves all pages of results.

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

### -IncludeRetried

Includes retried jobs in the results. When specified, jobs that were retried will also be returned.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByPipeline
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludeTrace

Includes the job trace (log output) as a property on each returned job object.

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

### -IncludeVariables

Includes manual job variables as a property on each returned job object. Uses GraphQL to retrieve variables.

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

### -JobId

The ID of a specific job to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages of results to retrieve. Used to limit the amount of data returned.

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

### -Name

Filter jobs by name using regex matching. Returns the first matching job.

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

### -PipelineId

The ID of the pipeline to retrieve jobs from.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByPipeline
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's Git remote.

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

### -Scope

Filter jobs by status. Valid values are: created, pending, running, failed, success, canceled, skipped, manual.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
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

The URL of the GitLab site. If not specified, uses the default configured site.

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

### -Stage

Filter jobs by stage name using regex matching.

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

Accepts ProjectId and PipelineId from the pipeline by property name.

## OUTPUTS

### Gitlab.Job

Returns one or more GitLab job objects with properties such as Id, Name, Stage, Status, and optionally Trace and Variables.

### System.Object

See [Gitlab.Job](#gitlabjob)

## NOTES

Aliases: job, jobs

## RELATED LINKS

- [GitLab Jobs API](https://docs.gitlab.com/ee/api/jobs.html)
- [Get-GitlabJobTrace](Get-GitlabJobTrace.md)
- [Get-GitlabJobArtifact](Get-GitlabJobArtifact.md)
- [Start-GitlabJob](Start-GitlabJob.md)
