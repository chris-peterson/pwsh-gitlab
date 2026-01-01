---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/GroupAccessTokens/Get-GitlabGroupAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabGroupAccessToken
---

# Get-GitlabGroupAccessToken

## SYNOPSIS

Gets access tokens for a GitLab group.

## SYNTAX

### __AllParameterSets

```
Get-GitlabGroupAccessToken [-GroupId] <string> [[-TokenId] <string>] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves group access tokens for a specified GitLab group. Can return all tokens for the group or a specific token by ID. Group access tokens allow programmatic access to GitLab resources at the group level.

## EXAMPLES

### Example 1: Get all access tokens for a group

```powershell
Get-GitlabGroupAccessToken -GroupId 'my-group'
```

Retrieves all access tokens for the specified group.

### Example 2: Get a specific access token

```powershell
Get-GitlabGroupAccessToken -GroupId 'my-group' -TokenId 42
```

Retrieves the access token with ID 42 from the specified group.

## PARAMETERS

### -GroupId

The ID or URL-encoded path of the group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

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

The ID of a specific access token to retrieve. If not specified, all tokens for the group are returned.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

You can pipe the GroupId to this cmdlet.

## OUTPUTS

### Gitlab.AccessToken

Returns access token objects containing properties such as id, name, scopes, expires_at, active, revoked, created_at, and access_level.

### System.Object

See [Gitlab.AccessToken](#gitlabaccesstoken).

## NOTES

Requires appropriate permissions to view group access tokens.

## RELATED LINKS

- [GitLab Group Access Tokens API](https://docs.gitlab.com/ee/api/group_access_tokens.html)
- [New-GitlabGroupAccessToken](New-GitlabGroupAccessToken.md)
- [Remove-GitlabGroupAccessToken](Remove-GitlabGroupAccessToken.md)
