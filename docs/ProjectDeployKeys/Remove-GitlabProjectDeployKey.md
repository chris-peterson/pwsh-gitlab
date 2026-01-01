---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectDeployKeys/Remove-GitlabProjectDeployKey
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabProjectDeployKey
---

# Remove-GitlabProjectDeployKey

## SYNOPSIS

Removes a deploy key from a GitLab project.

## SYNTAX

### Default

```
Remove-GitlabProjectDeployKey
    [-ProjectId] <string> -DeployKeyId <string> [-SiteUrl <string>]
    [-Force]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Removes a deploy key from a GitLab project. This operation deletes the association between the deploy key and the project, revoking the key's access to the repository. This cmdlet has high confirm impact and will prompt for confirmation by default.

## EXAMPLES

### Example 1: Remove a deploy key

```powershell
Remove-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42
```

Removes the deploy key with ID 42 from the specified project. Prompts for confirmation.

### Example 2: Remove a deploy key without confirmation

```powershell
Remove-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42 -Force
```

Removes the deploy key without prompting for confirmation.

### Example 3: Preview removal with WhatIf

```powershell
Remove-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -DeployKeyId 42 -WhatIf
```

Shows what would happen if the command runs without actually removing the deploy key.

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

The ID of the deploy key to remove from the project.

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

### None

This cmdlet does not produce any output.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [Get-GitlabProjectDeployKey](Get-GitlabProjectDeployKey.md)
- [Add-GitlabProjectDeployKey](Add-GitlabProjectDeployKey.md)
- [Update-GitlabProjectDeployKey](Update-GitlabProjectDeployKey.md)
- [Enable-GitlabProjectDeployKey](Enable-GitlabProjectDeployKey.md)
- [GitLab API: Deploy Keys](https://docs.gitlab.com/ee/api/deploy_keys.html)
