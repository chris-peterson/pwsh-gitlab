---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Users/Get-GitlabCurrentUser
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabCurrentUser
---

# Get-GitlabCurrentUser

## SYNOPSIS

Retrieves the currently authenticated GitLab user.

## SYNTAX

### __AllParameterSets

```
Get-GitlabCurrentUser [[-SiteUrl] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets information about the currently authenticated GitLab user. This is a convenience wrapper for `Get-GitlabUser -Me` and returns the user associated with the access token being used.

## EXAMPLES

### Example 1: Get the current user

```powershell
Get-GitlabCurrentUser
```

Returns the currently authenticated user.

### Example 2: Display current user's username

```powershell
(Get-GitlabCurrentUser).Username
```

Displays just the username of the current user.

### Example 3: Check current user against different GitLab instance

```powershell
Get-GitlabCurrentUser -SiteUrl "https://gitlab.example.com"
```

Retrieves the current user for a specific GitLab instance.

## PARAMETERS

### -SiteUrl

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### Gitlab.User

Returns the GitLab user object for the currently authenticated user.

### System.Object

See [Gitlab.User](#gitlabuser)

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [Get-GitlabUser](Get-GitlabUser.md)
- [Start-GitlabUserImpersonation](Start-GitlabUserImpersonation.md)
