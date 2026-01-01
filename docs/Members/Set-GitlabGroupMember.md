---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Set-GitlabGroupMember
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Set-GitlabGroupMember
---

# Set-GitlabGroupMember

## SYNOPSIS

Sets or updates a user's membership in a GitLab group.

## SYNTAX

### __AllParameterSets

```
Set-GitlabGroupMember [-UserId] <string> [-AccessLevel] <string> -SiteUrl <string>
 [-GroupId <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sets a user's access level for a GitLab group. If the user is already a member, their access level is updated. If they are not a member, they are added with the specified access level. This cmdlet provides an idempotent way to manage group membership.

## EXAMPLES

### Example 1: Set a user as a Developer

```powershell
Set-GitlabGroupMember -GroupId 'mygroup' -UserId 'jsmith' -AccessLevel Developer
```

Sets user 'jsmith' as a Developer in 'mygroup'. If they are already a member with a different access level, it will be updated.

### Example 2: Promote a user to Maintainer

```powershell
Set-GitlabGroupMember -UserId 'jsmith' -AccessLevel Maintainer
```

Sets user 'jsmith' as a Maintainer in the group inferred from the current git context.

## PARAMETERS

### -AccessLevel

The access level to assign to the user. Valid values are: Guest, Reporter, Developer, Maintainer, Owner.

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

The ID or URL-encoded path of the group. If not specified, uses the group inferred from the current git context.

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
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

The ID or username of the user to add or update. Alias: Username.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Username
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

### System.Object

See [Gitlab.Member](#gitlabmember)

### Gitlab.Member

Returns GitLab member objects.

## NOTES

This cmdlet supports ShouldProcess. Use -WhatIf to see what changes would be made without actually making them.

## RELATED LINKS

- [GitLab Members API](https://docs.gitlab.com/ee/api/members.html)
- [Get-GitlabGroupMember](Get-GitlabGroupMember.md)
- [Add-GitlabGroupMember](Add-GitlabGroupMember.md)
- [Remove-GitlabGroupMember](Remove-GitlabGroupMember.md)
