---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Jobs/Start-GitlabJob.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Start-GitlabJob
---

# Start-GitlabJob

## SYNOPSIS

Starts or retries a GitLab CI/CD job.

## SYNTAX

### __AllParameterSets

```
Start-GitlabJob [-JobId] <string> [-ProjectId <string>] [-Variables <Object>] [-SiteUrl <string>]
 [-Wait] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Play-GitlabJob`
- `Retry-GitlabJob`
- `play`


## DESCRIPTION

Starts a manual GitLab CI/CD job or retries a failed/canceled job. Supports passing custom variables to the job and optionally waiting for the job to complete. If the job is not playable (already completed), it will automatically attempt to retry the job instead.

## EXAMPLES

### Example 1

```powershell
Start-GitlabJob -JobId 12345
```

Starts or retries job 12345.

### Example 2

```powershell
Start-GitlabJob -JobId 12345 -Wait
```

Starts job 12345 and waits for it to complete, showing progress.

### Example 3

```powershell
Start-GitlabJob -JobId 12345 -Variables @{DEPLOY_ENV='staging'}
```

Starts a manual job with custom variables.

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

### -JobId

The ID of the job to start or retry.

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

### -Variables

A hashtable or object containing custom variables to pass to the job. These variables will be available to the job during execution.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases:
- vars
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

### -Wait

Wait for the job to complete before returning. Shows progress with the last line of the job trace.

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

Accepts JobId and ProjectId from the pipeline by property name.

## OUTPUTS

### Gitlab.Job

Returns the started job object with properties such as Id, Name, Stage, Status, and optionally Trace when using -Wait.

### System.Object

See [Gitlab.Job](#gitlabjob)

## NOTES

Aliases: Play-GitlabJob, Retry-GitlabJob, play

## RELATED LINKS

- [GitLab Jobs API - Run a Job](https://docs.gitlab.com/ee/api/jobs.html#run-a-job)
- [GitLab Jobs API - Retry a Job](https://docs.gitlab.com/ee/api/jobs.html#retry-a-job)
- [Get-GitlabJob](Get-GitlabJob.md)
