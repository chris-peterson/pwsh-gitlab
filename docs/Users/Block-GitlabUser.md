---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Users/Block-GitlabUser
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Block-GitlabUser
---

# Block-GitlabUser

## SYNOPSIS

Blocks a GitLab user.

## SYNTAX

### __AllParameterSets

```
Block-GitlabUser [-UserId] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Blocks a GitLab user, preventing them from signing in and accessing GitLab. Blocked users cannot create new issues, merge requests, or perform any actions in GitLab until they are unblocked.

## EXAMPLES

### Example 1: Block a user by username

```powershell
Block-GitlabUser -UserId "john.doe"
```

Blocks the user with username "john.doe".

### Example 2: Block a user from pipeline

```powershell
Get-GitlabUser -UserId "john.doe" | Block-GitlabUser
```

Blocks a user using pipeline input.

### Example 3: Block a user without confirmation

```powershell
Block-GitlabUser -UserId "john.doe" -Confirm:$false
```

Blocks a user without prompting for confirmation.

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

Specifies the user to block. Accepts a numeric ID, username, or email address.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EmailAddress
- Username
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

Accepts UserId from pipeline by property name.

## OUTPUTS

### None

This cmdlet does not return any output. A confirmation message is displayed upon successful blocking.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [Unblock-GitlabUser](Unblock-GitlabUser.md)
- [Get-GitlabUser](Get-GitlabUser.md)
- [Remove-GitlabUser](Remove-GitlabUser.md)
