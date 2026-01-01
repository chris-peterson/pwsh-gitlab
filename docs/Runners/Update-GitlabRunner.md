---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Runners/Update-GitlabRunner
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Update-GitlabRunner
---

# Update-GitlabRunner

## SYNOPSIS

Updates the configuration of a GitLab runner.

## SYNTAX

### Default

```
Update-GitlabRunner
    [-RunnerId] <string> [-Id <string>]
    [-Description <string>]
    [-Active <bool>]
    [-Tags <string>]
    [-RunUntaggedJobs <bool>]
    [-Locked <bool>]
    [-AccessLevel <string>]
    [-MaximumTimeoutSeconds <uint>]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates the configuration of an existing GitLab runner including description, tags, active status, and other settings.

## EXAMPLES

### Example 1: Update runner description

```powershell
Update-GitlabRunner -RunnerId 123 -Description 'Production runner'
```

Updates the description of runner 123.

### Example 2: Update runner tags and lock it

```powershell
Update-GitlabRunner -RunnerId 123 -Tags 'docker,linux' -Locked $true
```

Updates the tags and locks the runner to the current project.

### Example 3: Set maximum timeout

```powershell
Update-GitlabRunner -RunnerId 123 -MaximumTimeoutSeconds 3600
```

Sets the maximum job timeout to 1 hour (3600 seconds).

## PARAMETERS

### -AccessLevel

The access level of the runner. Valid values: 'not_protected' (can run jobs from any branch) or 'ref_protected' (can only run jobs from protected branches).

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

### -Active

Whether the runner is active (can receive jobs). Set to $false to pause the runner.

```yaml
Type: System.Boolean
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

### -Description

A description for the runner.

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

### -Id

Alternate identifier for the runner.

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

### -Locked

Whether the runner is locked to the current project. A locked runner cannot be assigned to other projects.

```yaml
Type: System.Boolean
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

### -MaximumTimeoutSeconds

The maximum timeout (in seconds) for jobs run by this runner. Must be at least 600 seconds.

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

The ID of the runner to update.

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

### -RunUntaggedJobs

Whether the runner can run jobs without tags.

```yaml
Type: System.Boolean
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

### -Tags

Comma-separated list of tags for the runner.

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

You can pipe a runner ID to this cmdlet.

## OUTPUTS

### Gitlab.Runner

Returns the updated runner object.

### System.Object

See [Gitlab.Runner](#gitlabrunner)

## NOTES

## RELATED LINKS

- [GitLab Runners API](https://docs.gitlab.com/ee/api/runners.html)
- [Get-GitlabRunner](Get-GitlabRunner.md)
- [Suspend-GitlabRunner](Suspend-GitlabRunner.md)
- [Resume-GitlabRunner](Resume-GitlabRunner.md)
