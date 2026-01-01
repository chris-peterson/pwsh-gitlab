---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/New-GitlabGroup
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabGroup
---

# New-GitlabGroup

## SYNOPSIS

Creates a new GitLab group.

## SYNTAX

### Default

```
New-GitlabGroup
    [-GroupName] <string> [-ParentGroupName <string>]
    [-Visibility <string>]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new GitLab group with the specified name and visibility. The group can be created as a top-level group or as a subgroup of an existing parent group.

## EXAMPLES

### Example 1: Create a new top-level group

```powershell
New-GitlabGroup -GroupName "my-new-group"
```

Creates a new internal visibility group named "my-new-group".

### Example 2: Create a private subgroup

```powershell
New-GitlabGroup -GroupName "my-subgroup" -ParentGroupName "parent-group" -Visibility private
```

Creates a new private subgroup named "my-subgroup" under "parent-group".

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

### -GroupName

The name of the group to create. This will also be used as the group path.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ParentGroupName

The name or path of the parent group. If specified, the new group will be created as a subgroup.

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

### -Visibility

The visibility level of the group. Valid values are 'private', 'internal', or 'public'. Defaults to 'internal'.

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

## OUTPUTS

### Gitlab.Group

Returns the newly created GitLab group object.

### System.Object

See [Gitlab.Group](#gitlabgroup).

## NOTES

This cmdlet supports the ShouldProcess functionality for -WhatIf and -Confirm parameters.

## RELATED LINKS

- [GitLab Groups API - New group](https://docs.gitlab.com/ee/api/groups.html#new-group)
