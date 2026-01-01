---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Runners/Remove-GitlabRunner
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabRunner
---

# Remove-GitlabRunner

## SYNOPSIS

Deletes a GitLab runner.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabRunner [-RunnerId] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Permanently deletes a GitLab runner by ID. This action cannot be undone. Supports ShouldProcess for confirmation.

## EXAMPLES

### Example 1: Remove a runner

```powershell
Remove-GitlabRunner -RunnerId 123
```

Deletes the runner with ID 123 after confirmation.

### Example 2: Remove a runner without confirmation

```powershell
Remove-GitlabRunner -RunnerId 123 -Confirm:$false
```

Deletes the runner without prompting for confirmation.

### Example 3: Preview runner deletion

```powershell
Remove-GitlabRunner -RunnerId 123 -WhatIf
```

Shows what would happen without actually deleting the runner.

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

The ID of the runner to delete.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Runners API](https://docs.gitlab.com/ee/api/runners.html)
- [Get-GitlabRunner](Get-GitlabRunner.md)
