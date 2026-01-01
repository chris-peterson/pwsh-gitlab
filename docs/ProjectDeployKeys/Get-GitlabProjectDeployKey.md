---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectDeployKeys/Get-GitlabProjectDeployKey
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectDeployKey
---

# Get-GitlabProjectDeployKey

## SYNOPSIS

Retrieves deploy keys for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabProjectDeployKey [-ProjectId] <string> [-DeployKeyId <string>] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves deploy keys associated with a GitLab project. Deploy keys are SSH keys that grant read-only or read-write access to a project's repository. You can retrieve all deploy keys for a project or a specific deploy key by ID.

## EXAMPLES

### Example 1: Get all deploy keys for a project

```powershell
Get-GitlabProjectDeployKey -ProjectId 'mygroup/myproject'
```

Retrieves all deploy keys configured for the specified project.

### Example 2: Get a specific deploy key by ID

```powershell
Get-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42
```

Retrieves the deploy key with ID 42 from the specified project.

### Example 3: Get deploy keys using pipeline input

```powershell
Get-GitlabProject 'mygroup/myproject' | Get-GitlabProjectDeployKey
```

Retrieves all deploy keys for a project using pipeline input from Get-GitlabProject.

## PARAMETERS

### -DeployKeyId

The ID of a specific deploy key to retrieve. If not specified, all deploy keys for the project are returned.

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

### -ProjectId

The ID or URL-encoded path of the project (e.g., 'mygroup/myproject' or '123').

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a project ID string to this cmdlet.

## OUTPUTS

### Gitlab.DeployKey

Returns one or more deploy key objects containing properties such as Id, Title, Key, CreatedAt, and CanPush.

### System.Object

See [Gitlab.DeployKey](#gitlabdeploykey)

## NOTES

## RELATED LINKS

- [Add-GitlabProjectDeployKey](Add-GitlabProjectDeployKey.md)
- [Update-GitlabProjectDeployKey](Update-GitlabProjectDeployKey.md)
- [Remove-GitlabProjectDeployKey](Remove-GitlabProjectDeployKey.md)
- [Enable-GitlabProjectDeployKey](Enable-GitlabProjectDeployKey.md)
- [GitLab API: Deploy Keys](https://docs.gitlab.com/ee/api/deploy_keys.html)
