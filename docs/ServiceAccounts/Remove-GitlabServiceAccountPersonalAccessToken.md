---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ServiceAccounts/Remove-GitlabServiceAccountPersonalAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 10/13/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabServiceAccountPersonalAccessToken
---

# Remove-GitlabServiceAccountPersonalAccessToken

## SYNOPSIS

Revokes a personal access token of a group service account.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabServiceAccountPersonalAccessToken [-GroupId] <string> [-ServiceAccountId] <int>
 [-TokenId] <int> [[-SiteUrl] <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Revoke-GitlabServiceAccountPersonalAccessToken`


## DESCRIPTION

Revokes a personal access token that belongs to a group service account. Requests made with the token fail from then on. Prompts for confirmation unless `-Force` is given.

## EXAMPLES

### Example 1: Revoke a token by ID

```powershell
Remove-GitlabServiceAccountPersonalAccessToken -GroupId 'my-group' -ServiceAccountId 123 -TokenId 45
```

Revokes token 45 of service account 123, after confirmation.

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

### -Force

Revoke without prompting for confirmation.

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
- UserId
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
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TokenId

The ID of the token to revoke.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 2
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

### System.Int32

The service account ID and token ID, by property name.

## OUTPUTS

### System.Void

This cmdlet returns no output.

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/api/service_accounts/)
- [New-GitlabServiceAccountPersonalAccessToken](New-GitlabServiceAccountPersonalAccessToken.md)
