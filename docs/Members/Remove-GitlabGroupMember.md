---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Remove-GitlabGroupMember
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabGroupMember
---

# Remove-GitlabGroupMember

## SYNOPSIS

Removes a user from a GitLab group.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabGroupMember [-GroupId] <string> [-UserId] <string> [[-SiteUrl] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Removes a user's membership from a GitLab group. This removes the user's direct access to the group. Note that the user may still have access through inherited membership from parent groups.

## EXAMPLES

### Example 1: Remove a user from a group

```powershell
Remove-GitlabGroupMember -GroupId 'mygroup' -UserId 'jsmith'
```

Removes user 'jsmith' from 'mygroup' after confirmation.

### Example 2: Remove a user without confirmation

```powershell
Remove-GitlabGroupMember -GroupId 'mygroup' -UserId 'jsmith' -Confirm:$false
```

Removes user 'jsmith' from 'mygroup' without prompting for confirmation.

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

### -UserId

The ID or username of the user to remove from the group. Alias: Username.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Username
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

You can pipe GroupId and UserId strings to this cmdlet.

## OUTPUTS

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

This cmdlet supports ShouldProcess with High confirmation impact. Use -WhatIf to see what changes would be made without actually making them.

## RELATED LINKS

- [GitLab Members API - Remove a member](https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project)
- [Get-GitlabGroupMember](Get-GitlabGroupMember.md)
- [Add-GitlabGroupMember](Add-GitlabGroupMember.md)
- [Set-GitlabGroupMember](Set-GitlabGroupMember.md)
