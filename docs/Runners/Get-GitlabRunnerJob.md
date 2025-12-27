---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Runners/Get-GitlabRunnerJob.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabRunnerJob
---

# Get-GitlabRunnerJob

## SYNOPSIS

Gets jobs executed by a specific GitLab runner.

## SYNTAX

### __AllParameterSets

```
Get-GitlabRunnerJob [-RunnerId] <string> [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves a list of jobs that have been executed by a specific GitLab runner. This is useful for auditing runner usage and understanding workload distribution.

## EXAMPLES

### Example 1: Get jobs for a specific runner

```powershell
Get-GitlabRunnerJob -RunnerId 123
```

Retrieves jobs executed by runner with ID 123.

### Example 2: Get all jobs for a runner

```powershell
Get-GitlabRunnerJob -RunnerId 123 -All
```

Retrieves all jobs executed by the runner by fetching all pages.

### Example 3: Get jobs via pipeline

```powershell
Get-GitlabRunner -RunnerId 123 | Get-GitlabRunnerJob
```

Pipes a runner object to retrieve its jobs.

## PARAMETERS

### -All

If specified, retrieves all jobs by fetching all pages of results.

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

The maximum number of pages of results to retrieve.

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

### -RunnerId

The ID of the runner to retrieve jobs for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a runner ID to this cmdlet.

## OUTPUTS

### Gitlab.RunnerJob

Returns runner job objects containing job information including project, status, and timestamps.

### System.Object

See [Gitlab.RunnerJob](#gitlabrunnerjob)

## NOTES

## RELATED LINKS

- [GitLab Runners API](https://docs.gitlab.com/ee/api/runners.html)
- [Get-GitlabRunner](Get-GitlabRunner.md)
