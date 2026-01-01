---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Get-GitlabMemberAccessLevel
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabMemberAccessLevel
---

# Get-GitlabMemberAccessLevel

## SYNOPSIS

Gets the valid GitLab member access levels or converts an access level name to its numeric value.

## SYNTAX

### Default

```
Get-GitlabMemberAccessLevel
    [[-AccessLevel] <Object>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Returns all valid GitLab member access levels (NoAccess, MinimalAccess, Guest, Reporter, Developer, Maintainer, Owner, Admin) with their numeric values. When called with a specific access level name, returns its corresponding numeric value. This cmdlet is used internally by other member management cmdlets to convert access level names to the numeric values required by the GitLab API.

## EXAMPLES

### Example 1: Get all access levels

```powershell
Get-GitlabMemberAccessLevel
```

Returns an object with all valid access levels and their numeric values.

### Example 2: Get numeric value for a specific access level

```powershell
Get-GitlabMemberAccessLevel -AccessLevel Developer
```

Returns `30`, the numeric value for Developer access level.

## PARAMETERS

### -AccessLevel

The name or numeric value of the access level to retrieve. Valid names are: NoAccess (0), MinimalAccess (5), Guest (10), Reporter (20), Developer (30), Maintainer (40), Owner (50), Admin (60). If not specified, returns all access levels.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject)

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This cmdlet is primarily used internally by other member management cmdlets.

## RELATED LINKS

- [GitLab Members API - Valid Access Levels](https://docs.gitlab.com/ee/api/members.html#valid-access-levels)
- [Add-GitlabGroupMember](Add-GitlabGroupMember.md)
- [Add-GitlabProjectMember](Add-GitlabProjectMember.md)
