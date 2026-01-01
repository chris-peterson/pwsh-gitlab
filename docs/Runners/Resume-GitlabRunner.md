---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Runners/Resume-GitlabRunner
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Resume-GitlabRunner
---

# Resume-GitlabRunner

## SYNOPSIS

Reactivates a paused GitLab runner.

## SYNTAX

### __AllParameterSets

```
Resume-GitlabRunner [-RunnerId] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Reactivates a paused GitLab runner by setting its active status to true. This is the opposite of Suspend-GitlabRunner.

## EXAMPLES

### Example 1: Resume a paused runner

```powershell
Resume-GitlabRunner -RunnerId 123
```

Reactivates the runner with ID 123.

### Example 2: Resume a runner via pipeline

```powershell
Get-GitlabRunner -Status 'paused' | Resume-GitlabRunner
```

Reactivates all paused runners.

### Example 3: Preview resuming a runner

```powershell
Resume-GitlabRunner -RunnerId 123 -WhatIf
```

Shows what would happen without actually resuming the runner.

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

### -RunnerId

The ID of the runner to reactivate.

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
- [Suspend-GitlabRunner](Suspend-GitlabRunner.md)
- [Update-GitlabRunner](Update-GitlabRunner.md)
