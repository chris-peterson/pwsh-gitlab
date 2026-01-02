---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/GroupAccessTokens/Remove-GitlabGroupAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabGroupAccessToken
---

# Remove-GitlabGroupAccessToken

## SYNOPSIS

Revokes a group access token.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabGroupAccessToken [-GroupId] <string> [-TokenId] <string> [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Revoke-GitlabGroupAccessToken`


## DESCRIPTION

Revokes a specified group access token, permanently disabling it. This action cannot be undone. The cmdlet has an alias `Revoke-GitlabGroupAccessToken`.

## EXAMPLES

### Example 1: Revoke a group access token

```powershell
Remove-GitlabGroupAccessToken -GroupId 'my-group' -TokenId 42
```

Revokes the access token with ID 42 from the specified group. Prompts for confirmation.

### Example 2: Revoke a token without confirmation

```powershell
Remove-GitlabGroupAccessToken -GroupId 'my-group' -TokenId 42 -Confirm:$false
```

Revokes the access token without prompting for confirmation.

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

The ID of the access token to revoke.

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

HIDE_ME

### System.Void

N/A

## NOTES

This cmdlet has high impact and will prompt for confirmation by default. Use -Confirm:$false to skip confirmation. Alias: Revoke-GitlabGroupAccessToken.

## RELATED LINKS

- [GitLab Group Access Tokens API](https://docs.gitlab.com/ee/api/group_access_tokens.html)
- [Get-GitlabGroupAccessToken](Get-GitlabGroupAccessToken.md)
- [New-GitlabGroupAccessToken](New-GitlabGroupAccessToken.md)
