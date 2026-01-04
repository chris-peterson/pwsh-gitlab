---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PersonalAccessTokens/New-GitlabPersonalAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabPersonalAccessToken
---

# New-GitlabPersonalAccessToken

## SYNOPSIS

Creates a new personal access token for a GitLab user.

## SYNTAX

### __AllParameterSets

```
New-GitlabPersonalAccessToken [[-UserId] <string>] [-Name] <string> [-Scope] <string[]>
 [[-ExpiresAt] <string>] [[-ExpireInMonths] <uint>] [[-SiteUrl] <string>] [-CopyToClipboard]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new personal access token for the specified user or the current user. The token can be configured with specific scopes to control access permissions, and an optional expiration date. Requires administrator privileges to create tokens for other users.

## EXAMPLES

### Example 1: Create a token for yourself with api scope

```powershell
New-GitlabPersonalAccessToken -Name 'CI Token' -Scope 'api' -ExpireInMonths 6
```

Creates a new personal access token named 'CI Token' with api scope that expires in 6 months.

### Example 2: Create a token with multiple scopes and copy to clipboard

```powershell
New-GitlabPersonalAccessToken -Name 'Read Only' -Scope 'read_api', 'read_repository' -ExpiresAt '2025-12-31' -CopyToClipboard
```

Creates a token with read-only scopes, expiring on December 31, 2025, and copies the token value to clipboard.

### Example 3: Create a token for another user

```powershell
New-GitlabPersonalAccessToken -UserId 'jsmith' -Name 'Service Token' -Scope 'api'
```

Creates a personal access token for user 'jsmith' with api scope. Requires administrator privileges.

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

### -CopyToClipboard

When specified, copies the new token value directly to the clipboard instead of returning the token object. Useful for immediately using the token.

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

### -ExpireInMonths

Number of months from now until the token expires. Alternative to specifying an exact ExpiresAt date.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExpiresAt

The expiration date for the token. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value. If not specified, the token may have no expiration depending on instance settings.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name/description for the personal access token. Should be descriptive of the token's purpose.

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

### -Scope

The scopes to assign to the token. Valid values: api, read_user, read_api, read_repository, write_repository, read_registry, write_registry, sudo, admin_mode, create_runner, manage_runner, ai_features, k8s_proxy, read_service_ping.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
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
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

The user ID or username to create the token for. If not specified, creates a token for the current user. Requires administrator privileges to create tokens for other users.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Username
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

You can pipe a user ID or username to create a token for that user.

## OUTPUTS

### Gitlab.NewPersonalAccessToken

Returns the newly created token object including the Token property containing the actual token value. This is the only time the token value is available.

### System.Object

HIDE_ME

## NOTES

The token value is only returned once when the token is created. Store it securely as it cannot be retrieved again.

## RELATED LINKS

- [GitLab Users API - Create PAT](https://docs.gitlab.com/ee/api/users.html#create-a-personal-access-token)
- [Get-GitlabPersonalAccessToken](Get-GitlabPersonalAccessToken.md)
- [Invoke-GitlabPersonalAccessTokenRotation](Invoke-GitlabPersonalAccessTokenRotation.md)
- [Revoke-GitlabPersonalAccessToken](Revoke-GitlabPersonalAccessToken.md)
