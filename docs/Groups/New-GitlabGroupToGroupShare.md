---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/New-GitlabGroupToGroupShare
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabGroupToGroupShare
---

# New-GitlabGroupToGroupShare

## SYNOPSIS

Shares a GitLab group with another group.

## SYNTAX

### __AllParameterSets

```
New-GitlabGroupToGroupShare [-GroupId] <string> [-GroupShareId] <string> [-AccessLevel] <string>
 [-ExpiresAt <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Share-GitlabGroupWithGroup`


## DESCRIPTION

Creates a share link that grants members of one group access to another group at the specified access level. This allows cross-group collaboration without adding individual users.

## EXAMPLES

### Example 1: Share a group with developer access

```powershell
New-GitlabGroupToGroupShare -GroupId "my-group" -GroupShareId "other-team" -AccessLevel developer
```

Grants members of "other-team" developer access to "my-group".

### Example 2: Share with expiration

```powershell
New-GitlabGroupToGroupShare -GroupId "my-group" -GroupShareId "contractors" -AccessLevel reporter -ExpiresAt "2024-12-31"
```

Grants temporary reporter access that expires at the end of the year.

## PARAMETERS

### -AccessLevel

The access level to grant. Valid values are: noaccess, minimalaccess, guest, reporter, developer, maintainer, owner.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
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

### -ExpiresAt

The expiration date for the share. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value. After this date, the share is automatically removed.

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

### -GroupId

The ID or URL-encoded path of the group to share.

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

### -GroupShareId

The ID or URL-encoded path of the group to share with (the group whose members will gain access).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- ShareWith
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
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

Returns the shared GitLab group object.

### System.Object

HIDE_ME

## NOTES

Alias: Share-GitlabGroupWithGroup

This cmdlet supports the ShouldProcess functionality for -WhatIf and -Confirm parameters.

## RELATED LINKS

- [GitLab Groups API - Share groups with groups](https://docs.gitlab.com/ee/api/groups.html#share-groups-with-groups)
