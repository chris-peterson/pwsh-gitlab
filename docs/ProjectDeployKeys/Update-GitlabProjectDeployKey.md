---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectDeployKeys/Update-GitlabProjectDeployKey
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Update-GitlabProjectDeployKey
---

# Update-GitlabProjectDeployKey

## SYNOPSIS

Updates an existing deploy key for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Update-GitlabProjectDeployKey [-ProjectId] <string> -DeployKeyId <string> [-Title <string>]
 [-CanPush <bool>] [-SiteUrl <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates the properties of an existing deploy key for a GitLab project. You can modify the deploy key's push permissions using this cmdlet.

## EXAMPLES

### Example 1: Enable push access for a deploy key

```powershell
Update-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42 -CanPush $true
```

Updates the deploy key with ID 42 to allow push access to the repository.

### Example 2: Disable push access for a deploy key

```powershell
Update-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42 -CanPush $false
```

Updates the deploy key with ID 42 to be read-only (disables push access).

### Example 3: Force update without confirmation

```powershell
Update-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42 -CanPush $true -Force
```

Updates the deploy key without prompting for confirmation.

## PARAMETERS

### -CanPush

Specifies whether the deploy key should have push access. Set to $true for read-write access or $false for read-only access.

```yaml
Type: System.Boolean
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

### -DeployKeyId

The ID of the deploy key to update.

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

### -Title

A new descriptive name for the deploy key.

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

Returns the updated deploy key object containing properties such as Id, Title, Key, CreatedAt, and CanPush.

### System.Object

See [Gitlab.DeployKey](#gitlabdeploykey)

## NOTES

## RELATED LINKS

- [Get-GitlabProjectDeployKey](Get-GitlabProjectDeployKey.md)
- [Add-GitlabProjectDeployKey](Add-GitlabProjectDeployKey.md)
- [Remove-GitlabProjectDeployKey](Remove-GitlabProjectDeployKey.md)
- [Enable-GitlabProjectDeployKey](Enable-GitlabProjectDeployKey.md)
- [GitLab API: Deploy Keys](https://docs.gitlab.com/ee/api/deploy_keys.html)
