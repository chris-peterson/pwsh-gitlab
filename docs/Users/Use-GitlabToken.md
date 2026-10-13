---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Users/Use-GitlabToken
Locale: en-US
Module Name: GitlabCli
ms.date: 10/14/2026
PlatyPS schema version: 2024-05-01
title: Use-GitlabToken
---

# Use-GitlabToken

## SYNOPSIS

Runs a script block as another identity: a user, a group service account, or the owner of a token.

## SYNTAX

### ServiceAccount (Default)

```
Use-GitlabToken [-ScriptBlock] <scriptblock> -ServiceAccount <ServiceAccount> [-Scope <string[]>]
 [-ExpiresAt <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### User

```
Use-GitlabToken [-ScriptBlock] <scriptblock> -User <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Token

```
Use-GitlabToken [-ScriptBlock] <scriptblock> -Token <string> [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Makes every GitlabCli call in the script block use another identity's token, and stops using it when the block finishes, including when the block throws. The block's output is returned. Use it for short tasks; for a longer interactive session as another user, use `Start-GitlabUserImpersonation` and `Stop-GitlabUserImpersonation`.

Where the token comes from depends on the parameter:

| Parameter | Token | Afterwards | Needs |
| --- | --- | --- | --- |
| `-User` | An impersonation token, created by `Start-GitlabUserImpersonation` | Revoked | Administrator |
| `-ServiceAccount` | A personal access token for the group service account | Revoked | Permission to manage the group's service accounts |
| `-Token` | The token you pass | Left as is | Nothing beyond the token |

With `-User`, asking to impersonate yourself runs the block as you, without a token. With `-Token`, the token's owner is looked up before the block runs, so a token GitLab rejects fails before the block starts.

Token values are not written to output or verbose messages. Only one impersonation session can be active at a time; this cmdlet fails if `Start-GitlabUserImpersonation` or another `Use-GitlabToken` block is in progress.

With `-WhatIf` and `-User` or `-ServiceAccount`, creating and revoking the token are reported rather than run, and the block runs under your own identity with `-WhatIf` in effect, so the changes it would make are reported too. With `-Token`, the block runs with the token and `-WhatIf` in effect.

## EXAMPLES

### Example 1: Create a pipeline trigger owned by a service account

```powershell
Set-GitlabServiceAccount -GroupId 'my-group' -Username 'deploy-bot' | Use-GitlabToken {
    New-GitlabPipelineTrigger -ProjectId 'my-group/my-project' 'deploy'
}
```

The trigger is owned by `deploy-bot`, so it keeps working when the person who ran the script leaves the project. Only a trigger's owner can read its full token.

### Example 2: Take ownership of a pipeline schedule as its new owner

```powershell
Use-GitlabToken -User 'jane.doe' {
    Invoke-GitlabApi POST 'projects/my-group%2Fmy-project/pipeline_schedules/12/take_ownership'
}
```

GitLab only lets a user take ownership of a schedule for themselves, so the call runs as `jane.doe`.

### Example 3: Run as a project access token

```powershell
Use-GitlabToken -Token $env:PROJECT_TOKEN { Get-GitlabProject 'my-group/my-project' }
```

### Example 4: Preview the changes

```powershell
Get-GitlabServiceAccount -GroupId 'my-group' -Username 'deploy-bot' |
    Use-GitlabToken { New-GitlabPipelineTrigger -ProjectId 'my-group/my-project' 'deploy' } -WhatIf
```

Reports the token creation, the trigger creation, and the token revocation without making any of them.

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

### -ExpiresAt

When the service account's temporary token expires. Defaults to one day from now. The token is revoked when the block finishes, so this only matters if revocation fails.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServiceAccount
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Scope

Scopes for the service account's temporary token. Defaults to `api`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServiceAccount
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ScriptBlock

The commands to run as the other identity.

```yaml
Type: System.Management.Automation.ScriptBlock
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

### -ServiceAccount

The group service account, from `Get-GitlabServiceAccount -GroupId` or `Set-GitlabServiceAccount`. It must carry `Id` and `GroupId`.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServiceAccount
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
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

### -Token

A personal, project, or group access token to run the block with. It is not revoked afterwards.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Token
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -User

The user to impersonate. Accepts a numeric ID, username, or email address.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EmailAddress
- Username
- UserId
ParameterSets:
- Name: User
  Position: Named
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

### System.Object

The `Gitlab.ServiceAccount` to run the block as.

### System.String

A user to impersonate, such as one from `Get-GitlabUser`, identified by its `Username`, `UserId`, or `EmailAddress` property.

## OUTPUTS

### System.Object

Whatever the script block outputs.

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [GitLab Service Accounts API](https://docs.gitlab.com/api/service_accounts/)
- [Start-GitlabUserImpersonation](Start-GitlabUserImpersonation.md)
- [Set-GitlabServiceAccount](../ServiceAccounts/Set-GitlabServiceAccount.md)
