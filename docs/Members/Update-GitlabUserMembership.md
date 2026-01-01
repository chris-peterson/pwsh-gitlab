---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Update-GitlabUserMembership
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Update-GitlabUserMembership
---

# Update-GitlabUserMembership

## SYNOPSIS

Updates a user's access level in a GitLab group or project.

## SYNTAX

### Group (Default)

```
Update-GitlabUserMembership [-Username] <string> -GroupId <string> -AccessLevel <string>
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Project

```
Update-GitlabUserMembership [-Username] <string> -ProjectId <string> -AccessLevel <string>
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates an existing user's access level in a GitLab group or project. The user must already be a member of the specified group or project. Use this cmdlet to promote or demote a user's permissions.

## EXAMPLES

### Example 1: Update a user's group access level

```powershell
Update-GitlabUserMembership -Username 'jsmith' -GroupId 'mygroup' -AccessLevel maintainer
```

Updates user 'jsmith' to Maintainer access level in 'mygroup'.

### Example 2: Update a user's project access level

```powershell
Update-GitlabUserMembership -Username 'jsmith' -ProjectId 'mygroup/myproject' -AccessLevel developer
```

Updates user 'jsmith' to Developer access level in 'mygroup/myproject'.

## PARAMETERS

### -AccessLevel

The new access level to assign to the user. Valid values are: developer, maintainer, owner.

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

The ID or URL-encoded path of the group. Use this parameter to update group membership.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Group
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Use this parameter to update project membership.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Project
  Position: Named
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

The username of the user whose membership should be updated.

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

See [Gitlab.Member](#gitlabmember)

### Gitlab.Member

Returns GitLab member objects.

## NOTES

This cmdlet supports ShouldProcess. Use -WhatIf to see what changes would be made without actually making them. The user must already be a member of the group or project.

## RELATED LINKS

- [GitLab Members API - Edit a member](https://docs.gitlab.com/ee/api/members.html#edit-a-member-of-a-group-or-project)
- [Get-GitlabUserMembership](Get-GitlabUserMembership.md)
- [Add-GitlabUserMembership](Add-GitlabUserMembership.md)
- [Remove-GitlabUserMembership](Remove-GitlabUserMembership.md)
