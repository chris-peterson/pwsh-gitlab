---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectAccessTokens/New-GitlabProjectAccessToken
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabProjectAccessToken
---

# New-GitlabProjectAccessToken

## SYNOPSIS

Creates a new project access token.

## SYNTAX

### __AllParameterSets

```
New-GitlabProjectAccessToken [-ProjectId] <string> -Name <string> -Scopes <string[]>
 [-Description <string>] [-AccessLevel <string>] [-ExpiresAt <datetime>] [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new project access token for a specified GitLab project. Project access tokens are similar to personal access tokens but are scoped to a specific project. They can be used for API authentication and Git operations within the project. You must specify the token name and scopes, and can optionally set the access level, description, and expiration date.

## EXAMPLES

### Example 1: Create a token with read-only repository access

```powershell
New-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -Name 'CI Read Token' -Scopes 'read_repository'
```

Creates a new token with read-only access to the repository.

### Example 2: Create a token with multiple scopes and maintainer access

```powershell
New-GitlabProjectAccessToken -ProjectId 123 -Name 'CI/CD Token' -Scopes 'api', 'read_registry', 'write_registry' -AccessLevel 'maintainer' -ExpiresAt (Get-Date).AddDays(365)
```

Creates a token with API and container registry access at maintainer level, expiring in one year.

### Example 3: Create a token with description for CI runner

```powershell
New-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -Name 'Runner Token' -Description 'Token for self-hosted CI runner' -Scopes 'create_runner', 'manage_runner' -AccessLevel 'developer'
```

Creates a token for managing CI runners with a descriptive label.

## PARAMETERS

### -AccessLevel

The access level for the token. Valid values: guest, planner, reporter, developer, maintainer, owner. Determines what operations the token can perform.

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

A description for the token to help identify its purpose.

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

### -ExpiresAt

The expiration date for the token. If not specified, the token will use the GitLab default expiration.

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

### -Name

The name of the token. This is used to identify the token in the GitLab UI.

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

### -Scopes

The scopes to grant to the token. Valid values: api, read_api, read_repository, write_repository, read_registry, write_registry, create_runner, manage_runner, ai_features, k8s_proxy, self_rotate.

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

Returns the newly created GitLab access token object containing the token value. Important: Save the token value immediately as it cannot be retrieved again.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [Get-GitlabProjectAccessToken](Get-GitlabProjectAccessToken.md)
- [Remove-GitlabProjectAccessToken](Remove-GitlabProjectAccessToken.md)
- [Invoke-GitlabProjectAccessTokenRotation](Invoke-GitlabProjectAccessTokenRotation.md)
- [GitLab Project Access Tokens API](https://docs.gitlab.com/ee/api/project_access_tokens.html)
