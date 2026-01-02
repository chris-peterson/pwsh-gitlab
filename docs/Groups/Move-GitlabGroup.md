---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Move-GitlabGroup
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Move-GitlabGroup
---

# Move-GitlabGroup

## SYNOPSIS

Transfers a GitLab group to a new parent group or to the top level.

## SYNTAX

### __AllParameterSets

```
Move-GitlabGroup [[-GroupId] <string>] [[-DestinationGroupId] <string>] [[-SiteUrl] <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Transfer-GitlabGroup`


## DESCRIPTION

Moves a GitLab group to become a subgroup of another group, or to the top level if no destination is specified. This changes the group's URL path and hierarchy.

## EXAMPLES

### Example 1: Move a group under another group

```powershell
Move-GitlabGroup -GroupId "my-group" -DestinationGroupId "new-parent"
```

Moves "my-group" to become a subgroup of "new-parent".

### Example 2: Move a group to the top level

```powershell
Move-GitlabGroup -GroupId "parent/my-subgroup"
```

Moves "my-subgroup" from under "parent" to the top level.

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

### -DestinationGroupId

The ID or URL-encoded path of the destination parent group. If not specified, the group is moved to the top level.

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

### -GroupId

The ID or URL-encoded path of the group to move. Defaults to '.' which infers the group from the current local git directory.

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

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

Returns the moved GitLab group object.

### System.Object

HIDE_ME

## NOTES

Alias: Transfer-GitlabGroup

This operation may take some time for large groups as GitLab updates all project paths.

## RELATED LINKS

- [GitLab Groups API - Transfer a group](https://docs.gitlab.com/ee/api/groups.html#transfer-a-group)
