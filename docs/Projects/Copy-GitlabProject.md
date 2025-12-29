---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Projects/Copy-GitlabProject.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Copy-GitlabProject
---

# Copy-GitlabProject

## SYNOPSIS

Forks (copies) a GitLab project to a different namespace.

## SYNTAX

### __AllParameterSets

```
Copy-GitlabProject [-DestinationGroup] <string> [-ProjectId <string>]
 [-DestinationProjectName <string>] [-PreserveForkRelationship <bool>] [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Fork-GitlabProject`


## DESCRIPTION

Creates a fork of an existing project in a new namespace (group). By default, the fork relationship is preserved, but you can optionally remove it to create an independent copy.

## EXAMPLES

### Example 1: Fork a project to a different group

```powershell
Copy-GitlabProject -ProjectId "sourcegroup/myproject" -DestinationGroup "targetgroup"
```

Forks the project to the target group, preserving the fork relationship.

### Example 2: Copy a project without fork relationship

```powershell
Copy-GitlabProject -DestinationGroup "targetgroup" -PreserveForkRelationship $false
```

Creates an independent copy of the current project without a fork relationship.

### Example 3: Fork with a new name

```powershell
Copy-GitlabProject -DestinationGroup "targetgroup" -DestinationProjectName "my-new-project-name"
```

Forks the project with a new name.

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

### -DestinationGroup

The ID or URL-encoded path of the group where the forked project will be created.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DestinationProjectName

The name for the forked project. If not specified, uses the original project's name.

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

### -PreserveForkRelationship

When true (default), maintains the fork relationship with the source project. When false, removes the fork relationship to create an independent copy.

```yaml
Type: System.Boolean
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

### -ProjectId

The ID or URL-encoded path of the project to fork. Defaults to the current directory's git repository.

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

## OUTPUTS

### Gitlab.Project

Returns the newly forked GitLab project object.

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject)

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This cmdlet has an alias: Fork-GitlabProject.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Fork Project](https://docs.gitlab.com/ee/api/projects.html#fork-project)
