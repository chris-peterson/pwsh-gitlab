---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectDeployKeys/Enable-GitlabProjectDeployKey
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Enable-GitlabProjectDeployKey
---

# Enable-GitlabProjectDeployKey

## SYNOPSIS

Enables an existing deploy key for a GitLab project.

## SYNTAX

### Default

```
Enable-GitlabProjectDeployKey
    [-ProjectId] <string> -DeployKeyId <string> [-SiteUrl <string>]
    [-Force]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Enables an existing deploy key for a GitLab project. This allows you to share a deploy key that was created in another project with this project, rather than creating a new key. The deploy key must already exist in the GitLab instance.

## EXAMPLES

### Example 1: Enable a deploy key for a project

```powershell
Enable-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42
```

Enables the deploy key with ID 42 for the specified project.

### Example 2: Enable a deploy key without confirmation

```powershell
Enable-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42 -Force
```

Enables the deploy key without prompting for confirmation.

### Example 3: Enable a deploy key using pipeline input

```powershell
Get-GitlabProject 'mygroup/myproject' | Enable-GitlabProjectDeployKey -DeployKeyId 42
```

Enables a deploy key for a project using pipeline input from Get-GitlabProject.

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

### -DeployKeyId

The ID of the deploy key to enable for the project.

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

### -Force

Bypasses the confirmation prompt and executes the command without asking for user confirmation.

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

Returns the enabled deploy key object containing properties such as Id, Title, Key, CreatedAt, and CanPush.

### System.Object

See [Gitlab.DeployKey](#gitlabdeploykey)

## NOTES

## RELATED LINKS

- [Get-GitlabProjectDeployKey](Get-GitlabProjectDeployKey.md)
- [Add-GitlabProjectDeployKey](Add-GitlabProjectDeployKey.md)
- [Update-GitlabProjectDeployKey](Update-GitlabProjectDeployKey.md)
- [Remove-GitlabProjectDeployKey](Remove-GitlabProjectDeployKey.md)
- [GitLab API: Deploy Keys](https://docs.gitlab.com/ee/api/deploy_keys.html)
