---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/PersonalAccessTokens/Get-GitlabPersonalAccessToken.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabPersonalAccessToken
---

# Get-GitlabPersonalAccessToken

## SYNOPSIS

Retrieves personal access tokens from GitLab.

## SYNTAX

### Default (Default)

```
Get-GitlabPersonalAccessToken [[-TokenId] <string>] [-UserId <string>] [-CreatedAfter <string>]
 [-CreatedBefore <string>] [-LastUsedAfter <string>] [-LastUsedBefore <string>] [-State <string>]
 [-Revoked <bool>] [-FetchUsers] [-ForExport] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

### Mine

```
Get-GitlabPersonalAccessToken [-Mine] [-FetchUsers] [-ForExport] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

### Token

```
Get-GitlabPersonalAccessToken [-Token <string>] [-FetchUsers] [-ForExport] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

### Self

```
Get-GitlabPersonalAccessToken [-Self] [-FetchUsers] [-ForExport] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves personal access tokens from GitLab with various filtering options. Supports getting a specific token by ID, tokens for a specific user, the current user's tokens, or introspecting a token value. Administrators can list all tokens across users, while non-administrators can only access their own tokens. Results include token metadata such as name, scopes, creation date, last used date, and expiration.

## EXAMPLES

### Example 1: Get your own personal access tokens

```powershell
Get-GitlabPersonalAccessToken -Mine
```

Retrieves all active personal access tokens for the currently authenticated user.

### Example 2: Get a specific token by ID

```powershell
Get-GitlabPersonalAccessToken -TokenId 12345
```

Retrieves the personal access token with ID 12345.

### Example 3: Get tokens for a specific user with user details

```powershell
Get-GitlabPersonalAccessToken -UserId 'jsmith' -FetchUsers
```

Retrieves all active tokens for user 'jsmith' and includes full user object details.

## PARAMETERS

### -All

Retrieve all results without pagination limits. When specified, overrides MaxPages.

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

### -CreatedAfter

Filter tokens created after the specified date. Use ISO 8601 format (e.g., '2024-01-01').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CreatedBefore

Filter tokens created before the specified date. Use ISO 8601 format (e.g., '2024-12-31').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FetchUsers

When specified, fetches and attaches full user objects to each token result. Useful for getting detailed user information associated with tokens.

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

### -ForExport

Returns results in a simplified format suitable for export, with dates formatted as strings and selected properties for reporting purposes.

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

### -LastUsedAfter

Filter tokens last used after the specified date. Use ISO 8601 format (e.g., '2024-01-01').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LastUsedBefore

Filter tokens last used before the specified date. Use ISO 8601 format (e.g., '2024-12-31').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

Maximum number of pages of results to retrieve. Use to limit results for large token lists.

```yaml
Type: System.UInt32
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

### -Mine

Retrieve only personal access tokens belonging to the currently authenticated user. Equivalent to using -UserId with your own user ID.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Mine
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Revoked

Filter by revocation status. Set to $true to show only revoked tokens, or $false (default) to show only non-revoked tokens.

```yaml
Type: System.Boolean
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Self

Introspect the currently configured access token. Returns information about the token being used for authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Self
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

### -State

Filter tokens by state. Valid values are 'active' (default) or 'inactive'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
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

A personal access token value to introspect. Returns information about the specified token.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Token
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

The numeric ID of a specific personal access token to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: Default
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

The user ID, username, or email address to filter tokens by. Requires administrator privileges to view other users' tokens.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EmailAddress
- Username
ParameterSets:
- Name: Default
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

You can pipe a user ID, username, or email address to filter tokens.

## OUTPUTS

### Gitlab.PersonalAccessToken

Returns personal access token objects containing Id, Name, Scopes, Active, Revoked, CreatedAt, LastUsedAt, ExpiresAt, and UserId properties.

### System.Object

See [Gitlab.PersonalAccessToken](#gitlabpersonalaccesstoken)

## NOTES

Administrators can view tokens for all users. Non-administrators can only view their own tokens using -Mine or -Self.

## RELATED LINKS

- [GitLab Personal Access Tokens API](https://docs.gitlab.com/ee/api/personal_access_tokens.html)
- [New-GitlabPersonalAccessToken](New-GitlabPersonalAccessToken.md)
- [Invoke-GitlabPersonalAccessTokenRotation](Invoke-GitlabPersonalAccessTokenRotation.md)
- [Revoke-GitlabPersonalAccessToken](Revoke-GitlabPersonalAccessToken.md)
