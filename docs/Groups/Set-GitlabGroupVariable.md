---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Set-GitlabGroupVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Set-GitlabGroupVariable
---

# Set-GitlabGroupVariable

## SYNOPSIS

Creates or updates a CI/CD variable at the group level.

## SYNTAX

### __AllParameterSets

```
Set-GitlabGroupVariable [-Key] <string> [-Value] <string> -GroupId <string> [-Protect <bool>]
 [-Mask <bool>] [-ExpandVariables <bool>] [-NoExpand] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new CI/CD variable or updates an existing one at the group level. Supports options for masking the variable value, protecting it for protected branches only, and controlling variable expansion.

## EXAMPLES

### Example 1: Create a simple variable

```powershell
Set-GitlabGroupVariable -GroupId "my-group" -Key "MY_VAR" -Value "my-value"
```

Creates or updates the variable "MY_VAR" with the value "my-value".

### Example 2: Create a protected and masked variable

```powershell
Set-GitlabGroupVariable -GroupId "my-group" -Key "MY_SECRET" -Value "secret123" -Protect $true -Mask $true
```

Creates a variable that is only available on protected branches and masked in job logs.

### Example 3: Create a variable without expansion

```powershell
Set-GitlabGroupVariable -GroupId "my-group" -Key "MY_RAW" -Value '$VAR' -NoExpand
```

Creates a variable where the value is treated as raw text and not expanded.

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

### -ExpandVariables

Whether to expand variable references in the value. Defaults to true.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupId

The ID or URL-encoded path of the group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Key

The key (name) of the variable to create or update.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Mask

Whether to mask the variable value in job logs. Masked values must meet certain requirements (length, no special characters, etc.).

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoExpand

When specified, the variable value is treated as raw text and variable references are not expanded.

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

### -Protect

Whether to only expose this variable to protected branches and tags.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

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

### -Value

The value of the variable.

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

The GroupId can be provided via the pipeline by property name.

### System.Boolean

The Protect, Mask, and ExpandVariables parameters can be provided via the pipeline by property name.

## OUTPUTS

### Gitlab.Variable

Returns the created or updated GitLab variable object.

### System.Object

HIDE_ME

## NOTES

This cmdlet automatically determines whether to create or update the variable based on whether it already exists.

## RELATED LINKS

- [GitLab Group-level Variables API - Create variable](https://docs.gitlab.com/ee/api/group_level_variables.html#create-variable)
- [GitLab Group-level Variables API - Update variable](https://docs.gitlab.com/ee/api/group_level_variables.html#update-variable)
