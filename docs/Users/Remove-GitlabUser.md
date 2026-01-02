---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Users/Remove-GitlabUser
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabUser
---

# Remove-GitlabUser

## SYNOPSIS

Deletes a GitLab user.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabUser [-UserId] <int> [-SiteUrl <string>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Permanently deletes a GitLab user account. This is a high-impact operation that will prompt for confirmation by default. Use the -Force parameter to skip confirmation. Once deleted, the user and all their data will be permanently removed from GitLab.

## EXAMPLES

### Example 1: Delete a user with confirmation

```powershell
Remove-GitlabUser -UserId 42
```

Prompts for confirmation before deleting the user with ID 42.

### Example 2: Delete a user without confirmation

```powershell
Remove-GitlabUser -UserId 42 -Force
```

Deletes the user with ID 42 without prompting for confirmation.

### Example 3: Delete a user from pipeline

```powershell
Get-GitlabUser -UserId "john.doe" | Remove-GitlabUser
```

Deletes a user using pipeline input.

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

Skips the confirmation prompt and deletes the user immediately.

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

### -SiteUrl

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

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

### -UserId

Specifies the numeric ID of the user to delete.

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

### System.Int32

Accepts UserId from pipeline by property name.

## OUTPUTS

### None

This cmdlet does not return any output. A confirmation message is displayed upon successful deletion.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [Get-GitlabUser](Get-GitlabUser.md)
- [Block-GitlabUser](Block-GitlabUser.md)
- [Unblock-GitlabUser](Unblock-GitlabUser.md)
