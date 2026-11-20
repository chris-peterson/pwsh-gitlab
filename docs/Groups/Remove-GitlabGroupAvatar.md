---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Remove-GitlabGroupAvatar
Locale: en-US
Module Name: GitlabCli
ms.date: 11/19/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabGroupAvatar
---

# Remove-GitlabGroupAvatar

## SYNOPSIS

Removes the avatar image from a GitLab group.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabGroupAvatar [-GroupId] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Clears the group's avatar so GitLab shows its default placeholder. Prompts for confirmation by default; the removed image cannot be recovered through the API.

## EXAMPLES

### Example 1: Remove the avatar of a group

```powershell
Remove-GitlabGroupAvatar 'mygroup'
```

Removes the avatar of `mygroup` after prompting for confirmation.

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

### -GroupId

The ID or URL-encoded path of the group.

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

The GroupId can be provided via the pipeline by property name.

## OUTPUTS

### Gitlab.Group

Returns the updated GitLab group object.

### System.Object

HIDE_ME

## NOTES

Sends a blank `avatar` value, which GitLab treats as a removal.

## RELATED LINKS

- [GitLab Groups API - Remove a group avatar](https://docs.gitlab.com/api/groups/#remove-a-group-avatar)
- [Set-GitlabGroupAvatar](Set-GitlabGroupAvatar.md)
