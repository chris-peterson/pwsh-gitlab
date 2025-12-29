---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Projects/New-GitlabGroupToProjectShare.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabGroupToProjectShare
---

# New-GitlabGroupToProjectShare

## SYNOPSIS

Shares a GitLab project with a group.

## SYNTAX

### __AllParameterSets

```
New-GitlabGroupToProjectShare [[-ProjectId] <string>] [[-GroupId] <string>]
 [[-GroupAccess] <string>] [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Share-GitlabProjectWithGroup`


## DESCRIPTION

Shares a project with a group, granting all members of the group access to the project at the specified access level.

## EXAMPLES

### Example 1: Share project with a group as developer

```powershell
New-GitlabGroupToProjectShare -ProjectId "mygroup/myproject" -GroupId "targetgroup" -GroupAccess "developer"
```

Shares the project with the target group, giving members developer access.

### Example 2: Share current project with a group

```powershell
New-GitlabGroupToProjectShare -GroupId "targetgroup" -GroupAccess "maintainer"
```

Shares the current directory's project with the target group as maintainers.

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

### -GroupAccess

The access level to grant to the group members. Valid values include 'guest', 'reporter', 'developer', 'maintainer'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Access
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupId

The ID or URL-encoded path of the group to share the project with.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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
  Position: 3
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

You can pipe project and group IDs to this cmdlet.

## OUTPUTS

### None

This cmdlet outputs a confirmation message.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

This cmdlet has an alias: Share-GitlabProjectWithGroup.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Share Project with Group](https://docs.gitlab.com/ee/api/projects.html#share-project-with-group)
