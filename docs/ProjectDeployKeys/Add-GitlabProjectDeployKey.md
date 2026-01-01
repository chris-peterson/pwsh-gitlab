---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectDeployKeys/Add-GitlabProjectDeployKey
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Add-GitlabProjectDeployKey
---

# Add-GitlabProjectDeployKey

## SYNOPSIS

Adds a new deploy key to a GitLab project.

## SYNTAX

### __AllParameterSets

```
Add-GitlabProjectDeployKey [-ProjectId] <string> -Title <string> -Key <string> [-CanPush]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Adds a new deploy key to a GitLab project. Deploy keys are SSH keys that grant read-only or read-write access to a project's repository. This is useful for automated systems that need to clone or push to a repository.

## EXAMPLES

### Example 1: Add a read-only deploy key

```powershell
Add-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -Title 'CI Server Key' -Key 'ssh-rsa AAAA...'
```

Adds a new deploy key with read-only access to the specified project.

### Example 2: Add a deploy key with push access

```powershell
Add-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -Title 'Deploy Server Key' -Key 'ssh-rsa AAAA...' -CanPush
```

Adds a new deploy key with read-write access (can push) to the specified project.

### Example 3: Add a deploy key using pipeline input

```powershell
Get-GitlabProject 'mygroup/myproject' | Add-GitlabProjectDeployKey -Title 'Backup Key' -Key 'ssh-rsa AAAA...'
```

Adds a deploy key to a project using pipeline input from Get-GitlabProject.

## PARAMETERS

### -CanPush

When specified, the deploy key will have read-write access and can push to the repository. By default, deploy keys have read-only access.

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

### -Key

The public SSH key to add as a deploy key (e.g., 'ssh-rsa AAAA...' or 'ssh-ed25519 AAAA...').

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

### -Title

A descriptive name for the deploy key to help identify its purpose.

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

You can pipe a project ID string to this cmdlet.

## OUTPUTS

### Gitlab.DeployKey

Returns the newly created deploy key object containing properties such as Id, Title, Key, CreatedAt, and CanPush.

### System.Object

See [Gitlab.DeployKey](#gitlabdeploykey)

## NOTES

## RELATED LINKS

- [Get-GitlabProjectDeployKey](Get-GitlabProjectDeployKey.md)
- [Update-GitlabProjectDeployKey](Update-GitlabProjectDeployKey.md)
- [Remove-GitlabProjectDeployKey](Remove-GitlabProjectDeployKey.md)
- [Enable-GitlabProjectDeployKey](Enable-GitlabProjectDeployKey.md)
- [GitLab API: Deploy Keys](https://docs.gitlab.com/ee/api/deploy_keys.html)
