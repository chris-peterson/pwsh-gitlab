---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/UserDeployKeys/Get-GitlabUserDeployKey.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabUserDeployKey
---

# Get-GitlabUserDeployKey

## SYNOPSIS

Retrieves deploy keys associated with a user's projects.

## SYNTAX

### __AllParameterSets

```
Get-GitlabUserDeployKey [-UserId] <string> [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets all project deploy keys associated with a specific GitLab user. Deploy keys allow read-only or read-write access to repositories and are used for automated deployments and CI/CD pipelines.

## EXAMPLES

### Example 1: Get deploy keys for a user by username

```powershell
Get-GitlabUserDeployKey -UserId "john.doe"
```

Retrieves all deploy keys for projects owned by user "john.doe".

### Example 2: Get deploy keys for a user by ID

```powershell
Get-GitlabUserDeployKey -UserId 42
```

Retrieves all deploy keys for projects owned by user with ID 42.

### Example 3: Get deploy keys from pipeline

```powershell
Get-GitlabUser -UserId "john.doe" | Get-GitlabUserDeployKey
```

Uses pipeline input to get deploy keys for a user.

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
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

Specifies the user ID, username, or other identifier. The user will be resolved before retrieving deploy keys.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Accepts UserId from pipeline by property name.

## OUTPUTS

### Gitlab.DeployKey

Returns one or more GitLab deploy key objects containing properties such as Id, Title, Key, and CreatedAt.

### System.Object

See [Gitlab.DeployKey](#gitlabdeploykey)

## NOTES

## RELATED LINKS

- [GitLab Deploy Keys API](https://docs.gitlab.com/ee/api/deploy_keys.html)
- [Get-GitlabUser](../Users/Get-GitlabUser.md)
- [Get-GitlabDeployKey](../DeployKeys/Get-GitlabDeployKey.md)
