---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Users/Start-GitlabUserImpersonation
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Start-GitlabUserImpersonation
---

# Start-GitlabUserImpersonation

## SYNOPSIS

Starts an impersonation session for a GitLab user.

## SYNTAX

### __AllParameterSets

```
Start-GitlabUserImpersonation [-UserId] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates an impersonation token for a GitLab user and starts an impersonation session. This allows administrators to perform actions as another user for troubleshooting or support purposes. The impersonation token is valid for 24 hours. Only one impersonation session can be active at a time.

## EXAMPLES

### Example 1: Start impersonating a user

```powershell
Start-GitlabUserImpersonation -UserId "john.doe"
```

Starts an impersonation session for user "john.doe".

### Example 2: Impersonate a user from pipeline

```powershell
Get-GitlabUser -UserId "john.doe" | Start-GitlabUserImpersonation
```

Starts impersonation using pipeline input.

### Example 3: Preview impersonation

```powershell
Start-GitlabUserImpersonation -UserId "john.doe" -WhatIf
```

Shows what would happen without actually starting the impersonation session.

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

Specifies the user to impersonate. Accepts a numeric ID, username, or email address.

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

Stores impersonation session data in the global variable $GitlabUserImpersonationSession.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [Stop-GitlabUserImpersonation](Stop-GitlabUserImpersonation.md)
- [Get-GitlabUser](Get-GitlabUser.md)
