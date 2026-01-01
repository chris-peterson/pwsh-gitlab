---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Environments/Remove-GitlabEnvironment
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabEnvironment
---

# Remove-GitlabEnvironment

## SYNOPSIS

Deletes a GitLab environment.

## SYNTAX

### Default

```
Remove-GitlabEnvironment
    [[-ProjectId] <string>]
    [-Name] <string> [[-SiteUrl] <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Permanently deletes an environment from a GitLab project. This is a destructive operation that requires confirmation by default due to the high impact. The environment must exist in the project for deletion to succeed.

## EXAMPLES

### Example 1

```powershell
Remove-GitlabEnvironment -ProjectId "mygroup/myproject" -Name "review/feature-branch"
```

Deletes the environment named "review/feature-branch" from the specified project after confirmation.

### Example 2

```powershell
Remove-GitlabEnvironment -Name "old-staging" -Confirm:$false
```

Deletes the environment named "old-staging" from the current project without prompting for confirmation.

### Example 3

```powershell
Get-GitlabEnvironment -Search "review" -State "stopped" | Remove-GitlabEnvironment
```

Pipes stopped review environments to be deleted.

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

The name of the environment to delete. This parameter is mandatory.

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

This cmdlet does not return any output. A confirmation message is written to the host upon successful deletion.

### System.Object

See [System.Void](#systemvoid).

### System.Void

N/A

## NOTES

This cmdlet supports ShouldProcess, so you can use -WhatIf to see what would happen without actually deleting the environment, or -Confirm:$false to skip the confirmation prompt.

## RELATED LINKS

- [GitLab Environments API - Delete an environment](https://docs.gitlab.com/ee/api/environments.html#delete-an-environment)
- [Get-GitlabEnvironment](Get-GitlabEnvironment.md)
- [Stop-GitlabEnvironment](Stop-GitlabEnvironment.md)
