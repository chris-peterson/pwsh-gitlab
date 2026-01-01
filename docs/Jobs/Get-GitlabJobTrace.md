---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Get-GitlabJobTrace
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabJobTrace
---

# Get-GitlabJobTrace

## SYNOPSIS

Retrieves the log (trace) output of a GitLab CI/CD job.

## SYNTAX

### Default

```
Get-GitlabJobTrace
    [-JobId] <string> [-ProjectId <string>]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

- `trace`


## DESCRIPTION

Retrieves the trace (log output) of a GitLab CI/CD job. The trace contains all console output from the job execution, including script output, errors, and status messages.

## EXAMPLES

### Example 1

```powershell
Get-GitlabJobTrace -JobId 12345
```

Retrieves the log output for job 12345.

### Example 2

```powershell
Get-GitlabJob -JobId 12345 | Get-GitlabJobTrace
```

Pipes a job object to retrieve its trace.

## PARAMETERS

### -JobId

The ID of the job to retrieve the trace for.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Accepts JobId and ProjectId from the pipeline by property name.

## OUTPUTS

### System.String

Returns the job trace as a string containing all log output from the job execution.

### System.Object

See [System.String](#systemstring)

## NOTES

Alias: trace

## RELATED LINKS

- [GitLab Jobs API - Get Job Log](https://docs.gitlab.com/ee/api/jobs.html#get-a-log-file)
- [Get-GitlabJob](Get-GitlabJob.md)
