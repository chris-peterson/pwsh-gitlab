---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Add-GitlabUserMembership
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Add-GitlabUserMembership
---

# Add-GitlabUserMembership

## SYNOPSIS

Adds a user as a member of a GitLab group.

## SYNTAX

### __AllParameterSets

```
Add-GitlabUserMembership [-Username] <string> [-GroupId] <string> [-AccessLevel] <string>
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Adds a user to a GitLab group with the specified access level. This is a user-centric way to manage group membership, taking the username as the primary identifier.

## EXAMPLES

### Example 1: Add a user to a group as Developer

```powershell
Add-GitlabUserMembership -Username 'jsmith' -GroupId 'mygroup' -AccessLevel developer
```

Adds user 'jsmith' to 'mygroup' with Developer access.

### Example 2: Add a user as Maintainer

```powershell
Add-GitlabUserMembership -Username 'jdoe' -GroupId 'mygroup/subgroup' -AccessLevel maintainer
```

Adds user 'jdoe' to 'mygroup/subgroup' with Maintainer access.

## PARAMETERS

### -AccessLevel

The access level to grant to the user. Valid values are: developer, maintainer, owner.

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

The ID or URL-encoded path of the group to add the user to.

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

The username of the user to add to the group.

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

This cmdlet supports ShouldProcess. Use -WhatIf to see what changes would be made without actually making them.

## RELATED LINKS

- [GitLab Members API - Add a member](https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project)
- [Get-GitlabUserMembership](Get-GitlabUserMembership.md)
- [Remove-GitlabUserMembership](Remove-GitlabUserMembership.md)
- [Update-GitlabUserMembership](Update-GitlabUserMembership.md)
