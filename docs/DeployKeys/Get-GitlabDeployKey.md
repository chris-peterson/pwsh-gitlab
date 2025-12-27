---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/DeployKeys/Get-GitlabDeployKey.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabDeployKey
---

# Get-GitlabDeployKey

## SYNOPSIS

Gets deploy keys from the GitLab instance.

## SYNTAX

### __AllParameterSets

```
Get-GitlabDeployKey [[-DeployKeyId] <string>] [[-SiteUrl] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves deploy keys from the GitLab instance. Deploy keys allow read-only or read-write access to repositories without being tied to a specific user. When called without parameters, returns all deploy keys visible to the current user. When a specific DeployKeyId is provided, returns details for that particular deploy key.

## EXAMPLES

### Example 1: Get all deploy keys

```powershell
Get-GitlabDeployKey
```

Retrieves all deploy keys visible to the current user across all projects.

### Example 2: Get a specific deploy key

```powershell
Get-GitlabDeployKey -DeployKeyId 42
```

Retrieves details for the deploy key with ID 42.

## PARAMETERS

### -DeployKeyId

The ID of a specific deploy key to retrieve. If not specified, all deploy keys visible to the current user are returned.

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

### -SiteUrl

The URL of the GitLab site to query. If not specified, uses the default configured GitLab site.

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

## OUTPUTS

### Gitlab.DeployKey

Returns one or more deploy key objects containing properties such as Id, Title, Key, and CreatedAt.

### System.Object

See [Gitlab.DeployKey](#gitlabdeploykey).

## NOTES

This cmdlet queries the GitLab Deploy Keys API at the instance level. For project-specific deploy keys, see `Get-GitlabProjectDeployKey`.

## RELATED LINKS

- [GitLab Deploy Keys API](https://docs.gitlab.com/ee/api/deploy_keys.html)
- [Get-GitlabProjectDeployKey](../ProjectDeployKeys/Get-GitlabProjectDeployKey.md)
