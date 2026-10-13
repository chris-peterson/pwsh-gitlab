---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Set-GitlabProjectMember
Locale: en-US
Module Name: GitlabCli
ms.date: 10/13/2026
PlatyPS schema version: 2024-05-01
title: Set-GitlabProjectMember
---

# Set-GitlabProjectMember

## SYNOPSIS

Sets or updates a user's membership in a GitLab project.

## SYNTAX

### __AllParameterSets

```
Set-GitlabProjectMember [-UserId] <string> [-AccessLevel] <string> [-ProjectId <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sets a user's access level for a GitLab project. A member who already has that access level is returned without a request. A member with a different level is updated, and a user who isn't a member is added. Any lookup failure other than not-found is raised rather than treated as "not a member".

A `Gitlab.User` or `Gitlab.ServiceAccount` can be piped in as the user.

## EXAMPLES

### Example 1: Set a user as a Developer

```powershell
Set-GitlabProjectMember -ProjectId 'mygroup/myproject' -UserId 'jsmith' -AccessLevel Developer
```

Sets user 'jsmith' as a Developer in 'mygroup/myproject'. If they are already a member with a different access level, it will be updated.

### Example 2: Promote a user to Maintainer

```powershell
Set-GitlabProjectMember -UserId 'jsmith' -AccessLevel Maintainer
```

Sets user 'jsmith' as a Maintainer in the project inferred from the current git context.

### Example 3: Make a service account a Maintainer

```powershell
Get-GitlabServiceAccount -GroupId 'mygroup' -Username 'deploy-bot' |
    Set-GitlabProjectMember -ProjectId 'mygroup/myproject' -AccessLevel Maintainer
```

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

### -ProjectId

The ID or URL-encoded path of the project. If not specified, uses the project inferred from the current git context.

```yaml
Type: System.String
DefaultValue: .
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

The user, by property name (`UserId` or `Username`), so a `Gitlab.User` or `Gitlab.ServiceAccount` can be piped in.

## OUTPUTS

### System.Object

HIDE_ME

### Gitlab.Member

Returns GitLab member objects.

## NOTES

This cmdlet supports ShouldProcess. Use -WhatIf to see what changes would be made without actually making them.

## RELATED LINKS

- [GitLab Members API](https://docs.gitlab.com/ee/api/members.html)
- [Get-GitlabProjectMember](Get-GitlabProjectMember.md)
- [Add-GitlabProjectMember](Add-GitlabProjectMember.md)
- [Remove-GitlabProjectMember](Remove-GitlabProjectMember.md)
