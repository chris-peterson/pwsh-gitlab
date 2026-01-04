---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PersonalAccessTokens/Invoke-GitlabPersonalAccessTokenRotation
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Invoke-GitlabPersonalAccessTokenRotation
---

# Invoke-GitlabPersonalAccessTokenRotation

## SYNOPSIS

Rotates a personal access token, generating a new token value.

## SYNTAX

### __AllParameterSets

```
Invoke-GitlabPersonalAccessTokenRotation [-TokenId] <string> [-ExpiresAt <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Rotate-GitlabPersonalAccessToken`


## DESCRIPTION

Rotates an existing personal access token by revoking the current token and generating a new one with the same scopes. The new token value is automatically copied to the clipboard. Optionally specify a new expiration date for the rotated token.

## EXAMPLES

### Example 1: Rotate a token by ID

```powershell
Invoke-GitlabPersonalAccessTokenRotation -TokenId 12345
```

Rotates the personal access token with ID 12345. The new token value is copied to the clipboard.

### Example 2: Rotate a token with a new expiration date

```powershell
Invoke-GitlabPersonalAccessTokenRotation -TokenId 12345 -ExpiresAt '2026-06-30'
```

Rotates the token and sets the new expiration date to June 30, 2026.

### Example 3: Rotate using the alias

```powershell
Rotate-GitlabPersonalAccessToken 12345
```

Uses the Rotate-GitlabPersonalAccessToken alias to rotate the specified token.

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

The new expiration date for the rotated token. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value. If not specified, uses the default expiration policy.

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

The numeric ID of the personal access token to rotate. Use Get-GitlabPersonalAccessToken to find token IDs.

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

You can pipe a token ID to rotate that token.

## OUTPUTS

### Gitlab.NewPersonalAccessToken

Returns the rotated token object including the new Token property. The new token value is also automatically copied to the clipboard.

### System.Object

HIDE_ME

## NOTES

The new token value is automatically copied to the clipboard after rotation. The old token is immediately invalidated.

## RELATED LINKS

- [GitLab PAT Rotation API](https://docs.gitlab.com/api/personal_access_tokens/#rotate-a-personal-access-token)
- [Get-GitlabPersonalAccessToken](Get-GitlabPersonalAccessToken.md)
- [New-GitlabPersonalAccessToken](New-GitlabPersonalAccessToken.md)
- [Revoke-GitlabPersonalAccessToken](Revoke-GitlabPersonalAccessToken.md)
