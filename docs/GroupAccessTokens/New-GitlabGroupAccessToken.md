---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/GroupAccessTokens/New-GitlabGroupAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabGroupAccessToken
---

# New-GitlabGroupAccessToken

## SYNOPSIS

Creates a new access token for a GitLab group.

## SYNTAX

### Default

```
New-GitlabGroupAccessToken
    [-GroupId] <string> -Name <string> -Scope <string[]> -AccessLevel <string> [-ExpiresAt <datetime>]
    [-CopyToClipboard]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new group access token for a specified GitLab group with the given name, scopes, and access level. Group access tokens allow programmatic access to GitLab resources at the group level. The token expires in 1 year by default.

## EXAMPLES

### Example 1: Create a group access token with api scope

```powershell
New-GitlabGroupAccessToken -GroupId 'my-group' -Name 'CI Token' -Scope 'api' -AccessLevel 'Developer'
```

Creates a new access token with api scope and Developer access level.

### Example 2: Create a token and copy to clipboard

```powershell
New-GitlabGroupAccessToken -GroupId 'my-group' -Name 'Deploy Token' -Scope 'read_repository','write_repository' -AccessLevel 'Maintainer' -CopyToClipboard
```

Creates a new access token with repository scopes and copies the token value to the clipboard.

### Example 3: Create a token with custom expiration

```powershell
New-GitlabGroupAccessToken -GroupId 'my-group' -Name 'Short-lived Token' -Scope 'read_api' -AccessLevel 'Reporter' -ExpiresAt (Get-Date).AddMonths(3)
```

Creates a new access token that expires in 3 months.

## PARAMETERS

### -AccessLevel

The access level (role) for the token. Valid values are: Guest, Reporter, Developer, Maintainer, Owner.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

If specified, copies the generated token value to the clipboard instead of returning the response object. The token value is only available at creation time.

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

### -ExpiresAt

The expiration date for the token. Cannot be more than 1 year from now. Defaults to 1 year from the current date.

```yaml
Type: System.DateTime
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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the access token.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Scope

The scopes available to the token. Valid values are: api, read_api, read_registry, write_registry, read_repository, write_repository.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
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

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject).

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

You must have the Owner role for the group to create access tokens. The token value is only displayed once upon creation.

## RELATED LINKS

- [GitLab Group Access Tokens API](https://docs.gitlab.com/ee/api/group_access_tokens.html)
- [Get-GitlabGroupAccessToken](Get-GitlabGroupAccessToken.md)
- [Remove-GitlabGroupAccessToken](Remove-GitlabGroupAccessToken.md)
