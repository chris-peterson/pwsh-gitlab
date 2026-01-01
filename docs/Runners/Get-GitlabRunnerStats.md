---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Runners/Get-GitlabRunnerStats
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabRunnerStats
---

# Get-GitlabRunnerStats

## SYNOPSIS

Gets statistics for GitLab runners.

## SYNTAX

### ByTags (Default)

```
Get-GitlabRunnerStats [-RunnerTag] <string[]> [-Before <datetime>] [-After <datetime>]
 [-JobLimit <int>] [-SiteUrl <string>] [<CommonParameters>]
```

### ById

```
Get-GitlabRunnerStats
    [-RunnerId] <string> [-Before <datetime>]
    [-After <datetime>]
    [-JobLimit <int>]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves statistics for GitLab runners using GraphQL, including job counts by status and queue duration percentiles. Can query by runner ID or by runner tags.

## EXAMPLES

### Example 1: Get stats for runners by tag

```powershell
Get-GitlabRunnerStats -RunnerTag 'docker'
```

Retrieves statistics for all runners with the 'docker' tag.

### Example 2: Get stats for a specific runner

```powershell
Get-GitlabRunnerStats -RunnerId 123
```

Retrieves statistics for the runner with ID 123.

### Example 3: Get stats with custom job limit

```powershell
Get-GitlabRunnerStats -RunnerTag 'linux', 'shared' -JobLimit 200
```

Retrieves statistics considering up to 200 jobs per runner.

## PARAMETERS

### -After

Filter jobs started after this date/time.

```yaml
Type: System.DateTime
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

### -Before

Filter jobs started before this date/time.

```yaml
Type: System.DateTime
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

### -JobLimit

The maximum number of jobs to retrieve per runner for statistics calculation. Defaults to 100.

```yaml
Type: System.Int32
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

The ID of a specific runner to get statistics for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RunnerTag

One or more tags to filter runners by. Statistics are aggregated across all matching runners.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Tag
ParameterSets:
- Name: ByTags
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
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

### Gitlab.RunnerStats

Returns runner statistics including runner count, job count, job count by status, and queue duration percentiles (50th, 80th, 95th, 99th).

### System.Object

See [Gitlab.RunnerStats](#gitlabrunnerstats)

## NOTES

## RELATED LINKS

- [GitLab Runners API](https://docs.gitlab.com/ee/api/runners.html)
- [Get-GitlabRunner](Get-GitlabRunner.md)
