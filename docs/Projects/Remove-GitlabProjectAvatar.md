---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Remove-GitlabProjectAvatar
Locale: en-US
Module Name: GitlabCli
ms.date: 11/19/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabProjectAvatar
---

# Remove-GitlabProjectAvatar

## SYNOPSIS

Removes the avatar image from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabProjectAvatar [[-ProjectId] <string>] [[-SiteUrl] <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Clears the project's avatar so GitLab shows its default placeholder. Prompts for confirmation by default; the removed image cannot be recovered through the API.

## EXAMPLES

### Example 1: Remove the avatar of a specific project

```powershell
Remove-GitlabProjectAvatar -ProjectId 'mygroup/myproject'
```

Removes the avatar of `mygroup/myproject` after prompting for confirmation.

### Example 2: Remove without prompting

```powershell
Remove-GitlabProjectAvatar -ProjectId 'mygroup/myproject' -Confirm:$false
```

Removes the avatar without a confirmation prompt.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

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

### Gitlab.Project

Returns the updated GitLab project object.

### System.Object

HIDE_ME

## NOTES

Sends a blank `avatar` value, which GitLab treats as a removal.

## RELATED LINKS

- [GitLab Projects API - Remove a project avatar](https://docs.gitlab.com/api/projects/#remove-a-project-avatar)
- [Set-GitlabProjectAvatar](Set-GitlabProjectAvatar.md)
