---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Environments/Stop-GitlabEnvironment
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Stop-GitlabEnvironment
---

# Stop-GitlabEnvironment

## SYNOPSIS

Stops a GitLab environment.

## SYNTAX

### __AllParameterSets

```
Stop-GitlabEnvironment [[-ProjectId] <string>] [-Name] <string> [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Stops an active environment in a GitLab project. This triggers any on_stop actions defined in the project's CI/CD configuration. Stopping an environment does not delete it; the environment can be restarted by a new deployment.

## EXAMPLES

### Example 1

```powershell
Stop-GitlabEnvironment -ProjectId "mygroup/myproject" -Name "review/feature-branch"
```

Stops the environment named "review/feature-branch" in the specified project.

### Example 2

```powershell
Stop-GitlabEnvironment -Name "staging"
```

Stops the environment named "staging" in the current project (determined by local git context).

### Example 3

```powershell
Get-GitlabEnvironment -Search "review" | Stop-GitlabEnvironment
```

Stops all review environments by piping them from Get-GitlabEnvironment.

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

### -Name

The name of the environment to stop. This parameter is mandatory.

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

The ID or URL-encoded path of the project. Defaults to the current directory's git repository (detected via local git context).

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

The URL of the GitLab site to connect to. If not specified, uses the default configured GitLab site.

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

You can pipe ProjectId and Name values to this cmdlet.

## OUTPUTS

### None

This cmdlet does not return any output. A confirmation message is written to the host upon successful stop.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

This cmdlet supports ShouldProcess, so you can use -WhatIf to see what would happen without actually stopping the environment.

## RELATED LINKS

- [GitLab Environments API - Stop an environment](https://docs.gitlab.com/ee/api/environments.html#stop-an-environment)
- [Get-GitlabEnvironment](Get-GitlabEnvironment.md)
- [Remove-GitlabEnvironment](Remove-GitlabEnvironment.md)
