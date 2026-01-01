---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectAccessTokens/Remove-GitlabProjectAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabProjectAccessToken
---

# Remove-GitlabProjectAccessToken

## SYNOPSIS

Revokes (removes) a project access token.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabProjectAccessToken [-ProjectId] <string> -TokenId <string> [-SiteUrl <string>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Revoke-GitlabProjectAccessToken`


## DESCRIPTION

Revokes a project access token, permanently invalidating it. Once revoked, the token can no longer be used for authentication. This action cannot be undone. By default, the cmdlet prompts for confirmation before revoking the token.

## EXAMPLES

### Example 1: Revoke a project access token

```powershell
Remove-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -TokenId '12345'
```

Revokes the specified token after prompting for confirmation.

### Example 2: Force revoke without confirmation

```powershell
Remove-GitlabProjectAccessToken -ProjectId 123 -TokenId '12345' -Force
```

Revokes the token immediately without prompting for confirmation.

### Example 3: Revoke a token using the alias

```powershell
Revoke-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -TokenId '12345' -Force
```

Revokes the token using the Revoke-GitlabProjectAccessToken alias.

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

Bypasses confirmation prompts and revokes the token immediately.

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

The ID of the project access token to revoke.

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

### None

This cmdlet does not generate any output.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

Alias: Revoke-GitlabProjectAccessToken

## RELATED LINKS

- [Get-GitlabProjectAccessToken](Get-GitlabProjectAccessToken.md)
- [New-GitlabProjectAccessToken](New-GitlabProjectAccessToken.md)
- [Invoke-GitlabProjectAccessTokenRotation](Invoke-GitlabProjectAccessTokenRotation.md)
- [GitLab Project Access Tokens API](https://docs.gitlab.com/ee/api/project_access_tokens.html)
