---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Add-GitlabGroupMember
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Add-GitlabGroupMember
---

# Add-GitlabGroupMember

## SYNOPSIS

Adds a user as a member of a GitLab group.

## SYNTAX

### Default

```
Add-GitlabGroupMember
    [-GroupId] <string> [-UserId] <string> [-AccessLevel] <string> [[-SiteUrl] <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Adds a new member to a GitLab group with the specified access level. The user must not already be a direct member of the group. To update an existing member's access level, use Set-GitlabGroupMember instead.

## EXAMPLES

### Example 1: Add a user as a Developer

```powershell
Add-GitlabGroupMember -GroupId 'mygroup' -UserId 'jsmith' -AccessLevel Developer
```

Adds user 'jsmith' to 'mygroup' with Developer access.

### Example 2: Add a user as a Maintainer

```powershell
Add-GitlabGroupMember -GroupId 'mygroup/subgroup' -UserId 'jdoe' -AccessLevel Maintainer
```

Adds user 'jdoe' to 'mygroup/subgroup' with Maintainer access.

## PARAMETERS

### -AccessLevel

The access level to grant to the user. Valid values are: Guest, Reporter, Developer, Maintainer, Owner.

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

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

The ID or username of the user to add to the group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

You can pipe a GroupId string to this cmdlet.

## OUTPUTS

### System.Object

See [Gitlab.Member](#gitlabmember)

### Gitlab.Member

Returns GitLab member objects.

## NOTES

This cmdlet supports ShouldProcess. Use -WhatIf to see what changes would be made without actually making them.

## RELATED LINKS

- [GitLab Members API - Add a member](https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project)
- [Get-GitlabGroupMember](Get-GitlabGroupMember.md)
- [Set-GitlabGroupMember](Set-GitlabGroupMember.md)
- [Remove-GitlabGroupMember](Remove-GitlabGroupMember.md)
