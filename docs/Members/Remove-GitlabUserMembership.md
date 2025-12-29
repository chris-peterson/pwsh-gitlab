---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Members/Remove-GitlabUserMembership.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabUserMembership
---

# Remove-GitlabUserMembership

## SYNOPSIS

Removes a user's membership from specified groups and/or projects.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabUserMembership [-Username] <string> [-Group <Object>] [-Project <Object>]
 [-RemoveAllAccess] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Removes a user's membership from one or more groups and/or projects. Can specify individual groups and projects to remove access from, or use -RemoveAllAccess to revoke all of the user's memberships across GitLab.

## EXAMPLES

### Example 1: Remove user from specific groups

```powershell
Remove-GitlabUserMembership -Username 'jsmith' -Group 'group1', 'group2'
```

Removes user 'jsmith' from 'group1' and 'group2'.

### Example 2: Remove user from specific projects

```powershell
Remove-GitlabUserMembership -Username 'jsmith' -Project 'mygroup/project1', 'mygroup/project2'
```

Removes user 'jsmith' from the specified projects.

### Example 3: Remove all access for a user

```powershell
Remove-GitlabUserMembership -Username 'jsmith' -RemoveAllAccess
```

Removes user 'jsmith' from all groups and projects they are a member of.

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

### -Group

One or more group IDs or paths to remove the user from.

```yaml
Type: System.Object
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

### -Project

One or more project IDs or paths to remove the user from.

```yaml
Type: System.Object
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

### -RemoveAllAccess

When specified, removes the user from all groups and projects they are currently a member of.

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

### -Username

The username of the user whose memberships should be removed.

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

You can pipe a Username string to this cmdlet.

## OUTPUTS

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

This cmdlet supports ShouldProcess with High confirmation impact. Use -WhatIf to see what changes would be made without actually making them.

## RELATED LINKS

- [GitLab Members API - Remove a member](https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project)
- [Get-GitlabUserMembership](Get-GitlabUserMembership.md)
- [Add-GitlabUserMembership](Add-GitlabUserMembership.md)
- [Update-GitlabUserMembership](Update-GitlabUserMembership.md)
