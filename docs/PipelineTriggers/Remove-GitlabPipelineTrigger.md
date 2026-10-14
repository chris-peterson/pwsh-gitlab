---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineTriggers/Remove-GitlabPipelineTrigger
Locale: en-US
Module Name: GitlabCli
ms.date: 10/13/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabPipelineTrigger
---

# Remove-GitlabPipelineTrigger

## SYNOPSIS

Deletes a pipeline trigger token from a project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabPipelineTrigger [-TriggerId] <int> [-ProjectId <string>] [-SiteUrl <string>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a pipeline trigger token. Requests that use the token fail from then on. Prompts for confirmation unless `-Force` is given.

## EXAMPLES

### Example 1: Delete a trigger token

```powershell
Remove-GitlabPipelineTrigger -ProjectId 'my-group/my-project' -TriggerId 12
```

Deletes the trigger token with ID 12, after confirmation.

### Example 2: Delete trigger tokens by description

```powershell
Get-GitlabPipelineTrigger -ProjectId 'my-group/my-project' |
    Where-Object Description -like 'deploy*' |
    Remove-GitlabPipelineTrigger -Force
```

Deletes every trigger token whose description starts with `deploy`, without prompting.

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

### -Force

Delete without prompting for confirmation.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the project of the current directory's git remote.

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

The URL of the GitLab instance. If not specified, uses the default configured site.

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

### -TriggerId

The ID of the trigger token to delete.

```yaml
Type: System.Int32
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

The project ID, by property name.

### System.Int32

The trigger token ID, by property name.

## OUTPUTS

### System.Void

This cmdlet returns no output.

## NOTES

## RELATED LINKS

- [GitLab Pipeline Trigger Tokens API](https://docs.gitlab.com/api/pipeline_triggers/)
- [Get-GitlabPipelineTrigger](Get-GitlabPipelineTrigger.md)
- [New-GitlabPipelineTrigger](New-GitlabPipelineTrigger.md)
