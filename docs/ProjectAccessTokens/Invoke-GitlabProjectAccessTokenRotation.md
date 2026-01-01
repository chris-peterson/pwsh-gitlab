---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectAccessTokens/Invoke-GitlabProjectAccessTokenRotation
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-GitlabProjectAccessTokenRotation
---

# Invoke-GitlabProjectAccessTokenRotation

## SYNOPSIS

Rotates a project access token, generating a new token with a new value.

## SYNTAX

### Default

```
Invoke-GitlabProjectAccessTokenRotation
    [-ProjectId] <string> -TokenId <string> [-ExpiresAt <datetime>]
    [-SiteUrl <string>]
    [-Force]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

- `Rotate-GitlabProjectAccessToken`


## DESCRIPTION

Rotates a project access token. This revokes the current token and creates a new one with the same scopes and access level but a new token value. The new token will have a new expiration date if specified, otherwise it uses the GitLab default. Use this cmdlet to periodically rotate tokens for security purposes without having to recreate them manually.

## EXAMPLES

### Example 1: Rotate a project access token

```powershell
Invoke-GitlabProjectAccessTokenRotation -ProjectId 'mygroup/myproject' -TokenId '12345'
```

Rotates the specified token, generating a new token value.

### Example 2: Rotate a token with a custom expiration date

```powershell
Invoke-GitlabProjectAccessTokenRotation -ProjectId 123 -TokenId '12345' -ExpiresAt (Get-Date).AddDays(90)
```

Rotates the token and sets the new expiration date to 90 days from now.

### Example 3: Force rotate without confirmation

```powershell
Invoke-GitlabProjectAccessTokenRotation -ProjectId 'mygroup/myproject' -TokenId '12345' -Force
```

Rotates the token without prompting for confirmation.

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

The expiration date for the new rotated token. If not specified, the GitLab default expiration is used.

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

### -Force

Bypasses confirmation prompts and executes the rotation immediately.

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

### -ProjectId

The ID or URL-encoded path of the project.

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

### -TokenId

The ID of the project access token to rotate.

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

Returns the newly rotated GitLab access token object containing the new token value. Important: Save the token value immediately as it cannot be retrieved again.

### System.Object

See [Gitlab.AccessToken](#gitlabaccesstoken)

## NOTES

Alias: Rotate-GitlabProjectAccessToken

## RELATED LINKS

- [Get-GitlabProjectAccessToken](Get-GitlabProjectAccessToken.md)
- [New-GitlabProjectAccessToken](New-GitlabProjectAccessToken.md)
- [Remove-GitlabProjectAccessToken](Remove-GitlabProjectAccessToken.md)
- [GitLab Project Access Tokens API](https://docs.gitlab.com/ee/api/project_access_tokens.html)
