---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Users/Stop-GitlabUserImpersonation.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Stop-GitlabUserImpersonation
---

# Stop-GitlabUserImpersonation

## SYNOPSIS

Stops the current GitLab user impersonation session.

## SYNTAX

### __AllParameterSets

```
Stop-GitlabUserImpersonation [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Stops the current impersonation session by revoking the impersonation token and clearing the session data. This should be called after completing administrative tasks performed while impersonating another user.

## EXAMPLES

### Example 1: Stop the current impersonation session

```powershell
Stop-GitlabUserImpersonation
```

Stops the active impersonation session and revokes the impersonation token.

### Example 2: Stop impersonation without confirmation

```powershell
Stop-GitlabUserImpersonation -Confirm:$false
```

Stops impersonation without prompting for confirmation.

### Example 3: Preview stopping impersonation

```powershell
Stop-GitlabUserImpersonation -WhatIf
```

Shows what would happen without actually stopping the impersonation session.

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
  Position: 0
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

## OUTPUTS

### None

Clears the global variable $GitlabUserImpersonationSession and displays a confirmation message.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [Start-GitlabUserImpersonation](Start-GitlabUserImpersonation.md)
- [Get-GitlabUser](Get-GitlabUser.md)
