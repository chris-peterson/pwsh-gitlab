---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectAccessTokens/Get-GitlabProjectAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectAccessToken
---

# Get-GitlabProjectAccessToken

## SYNOPSIS

Retrieves project access tokens from a GitLab project.

## SYNTAX

### ByTokenId

```
Get-GitlabProjectAccessToken
    [-ProjectId] <string> -TokenId <string> [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

### All

```
Get-GitlabProjectAccessToken
    [-ProjectId] <string> [-CreatedAfter <datetime>]
    [-CreatedBefore <datetime>]
    [-ExpiresAfter <datetime>]
    [-ExpiresBefore <datetime>]
    [-LastUsedAfter <datetime>]
    [-LastUsedBefore <datetime>]
    [-Revoked <bool>]
    [-Search <string>]
    [-Sort <string>]
    [-State <string>]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves project access tokens for a specified GitLab project. You can retrieve all tokens or a specific token by ID. Supports filtering by creation date, expiration date, last used date, revocation status, state, and search string. Results can be sorted by various criteria.

## EXAMPLES

### Example 1: Get all access tokens for a project

```powershell
Get-GitlabProjectAccessToken -ProjectId 'mygroup/myproject'
```

Retrieves all project access tokens for the specified project.

### Example 2: Get a specific access token by ID

```powershell
Get-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -TokenId '12345'
```

Retrieves a specific project access token by its ID.

### Example 3: Get active tokens expiring soon

```powershell
Get-GitlabProjectAccessToken -ProjectId 123 -State 'active' -ExpiresBefore (Get-Date).AddDays(30) -Sort 'expires_asc'
```

Retrieves all active tokens that will expire within the next 30 days, sorted by expiration date.

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

### -CreatedAfter

Filter tokens created after this date.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Filter tokens created before this date.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExpiresAfter

Filter tokens that expire after this date.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExpiresBefore

Filter tokens that expire before this date.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Filter tokens last used after this date.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Filter tokens last used before this date.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByTokenId
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: All
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Revoked

Filter tokens by revocation status. Set to $true to show only revoked tokens, or $false for non-revoked tokens.

```yaml
Type: System.Boolean
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Search

Search for tokens by name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

The URL of the GitLab site. If not specified, uses the default configured site.

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

### -Sort

Sort tokens by a specific field and direction. Valid values: created_asc, created_desc, expires_asc, expires_desc, last_used_asc, last_used_desc, name_asc, name_desc.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Filter tokens by state. Valid values: active, inactive.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

The ID of the project access token to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByTokenId
  Position: Named
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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.AccessToken

Returns one or more GitLab access token objects containing token details such as ID, name, scopes, expiration date, and state.

### System.Object

See [Gitlab.AccessToken](#gitlabaccesstoken)

## NOTES

## RELATED LINKS

- [New-GitlabProjectAccessToken](New-GitlabProjectAccessToken.md)
- [Remove-GitlabProjectAccessToken](Remove-GitlabProjectAccessToken.md)
- [Invoke-GitlabProjectAccessTokenRotation](Invoke-GitlabProjectAccessTokenRotation.md)
- [GitLab Project Access Tokens API](https://docs.gitlab.com/ee/api/project_access_tokens.html)
