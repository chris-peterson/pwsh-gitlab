---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ServiceAccounts/New-GitlabServiceAccountPersonalAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 10/13/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabServiceAccountPersonalAccessToken
---

# New-GitlabServiceAccountPersonalAccessToken

## SYNOPSIS

Creates a personal access token for a group service account.

## SYNTAX

### __AllParameterSets

```
New-GitlabServiceAccountPersonalAccessToken [-GroupId] <string> [-ServiceAccountId] <int>
 [-Name] <string> [-Scope] <string[]> [[-Description] <string>] [[-ExpiresAt] <string>]
 [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a personal access token for a service account that belongs to a top-level group. Calls made with the token act as the service account, so anything they create (a pipeline trigger token, a merge request) is owned by it rather than by a person. The token value is returned once; GitLab doesn't show it again.

## EXAMPLES

### Example 1: Create a read-only token for a service account

```powershell
Get-GitlabServiceAccount -GroupId 'my-group' -ServiceAccountId 123 |
    New-GitlabServiceAccountPersonalAccessToken -Name 'ci-reader' -Scope read_api -ExpiresAt (Get-Date).AddDays(30)
```

Creates a token that can read the API as the service account and expires in 30 days. Store the returned `Token` value somewhere safe, such as a masked CI/CD variable.

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

### -Description

A description of what the token is for.

```yaml
Type: System.String
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

The date the token expires.

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

### -GroupId

The ID or URL-encoded path of the top-level group that owns the service account.

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

### -Name

The name of the token.

```yaml
Type: System.String
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

### -Scope

The scopes the token grants.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServiceAccountId

The service account's user ID.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
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

### System.Int32

The service account ID, by property name.

### System.String

The group ID, by property name, as set on service accounts from `Get-GitlabServiceAccount -GroupId`.

## OUTPUTS

### Gitlab.NewPersonalAccessToken

The new token, including its `Token` value.

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/api/service_accounts/)
- [Remove-GitlabServiceAccountPersonalAccessToken](Remove-GitlabServiceAccountPersonalAccessToken.md)
- [Get-GitlabServiceAccount](Get-GitlabServiceAccount.md)
