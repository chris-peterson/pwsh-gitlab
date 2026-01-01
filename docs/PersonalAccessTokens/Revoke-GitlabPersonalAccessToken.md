---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PersonalAccessTokens/Revoke-GitlabPersonalAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Revoke-GitlabPersonalAccessToken
---

# Revoke-GitlabPersonalAccessToken

## SYNOPSIS

Revokes a personal access token, permanently invalidating it.

## SYNTAX

### Default

```
Revoke-GitlabPersonalAccessToken
    [-TokenId] <string> [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

- `Remove-GitlabPersonalAccessToken`


## DESCRIPTION

Revokes a personal access token by ID, permanently invalidating it. Once revoked, the token can no longer be used for authentication. This action cannot be undone.

## EXAMPLES

### Example 1: Revoke a token by ID

```powershell
Revoke-GitlabPersonalAccessToken -TokenId 12345
```

Revokes the personal access token with ID 12345.

### Example 2: Revoke using the alias

```powershell
Remove-GitlabPersonalAccessToken 12345
```

Uses the Remove-GitlabPersonalAccessToken alias to revoke the specified token.

### Example 3: Revoke tokens from pipeline

```powershell
Get-GitlabPersonalAccessToken -Mine | Where-Object { $_.ExpiresAt -lt (Get-Date) } | Revoke-GitlabPersonalAccessToken
```

Revokes all expired personal access tokens for the current user.

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

The URL of the GitLab instance to connect to. If not specified, uses the default configured site.

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

### -TokenId

The numeric ID of the personal access token to revoke. Use Get-GitlabPersonalAccessToken to find token IDs.

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

You can pipe a token ID to revoke that token.

## OUTPUTS

### None

This cmdlet does not return output. A confirmation message is displayed upon successful revocation.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

Revocation is permanent and cannot be undone. Ensure you no longer need the token before revoking it.

## RELATED LINKS

- [GitLab PAT Revoke API](https://docs.gitlab.com/ee/api/personal_access_tokens.html#revoke-a-personal-access-token)
- [Get-GitlabPersonalAccessToken](Get-GitlabPersonalAccessToken.md)
- [New-GitlabPersonalAccessToken](New-GitlabPersonalAccessToken.md)
- [Invoke-GitlabPersonalAccessTokenRotation](Invoke-GitlabPersonalAccessTokenRotation.md)
