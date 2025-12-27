---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Projects/New-GitlabProject.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabProject
---

# New-GitlabProject

## SYNOPSIS

Creates a new GitLab project.

## SYNTAX

### Group

```
New-GitlabProject [-ProjectName] <string> [-DestinationGroup <string>] [-Visibility <string>]
 [-BuildTimeout <uint>] [-CloneNow] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Personal

```
New-GitlabProject [-ProjectName] <string> [-Personal] [-Visibility <string>] [-BuildTimeout <uint>]
 [-CloneNow] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new project in GitLab. The project can be created in a specific group or as a personal project. You can optionally clone the project immediately after creation.

## EXAMPLES

### Example 1: Create a project in a group

```powershell
New-GitlabProject -ProjectName "my-new-project" -DestinationGroup "mygroup"
```

Creates a new project named "my-new-project" in the "mygroup" group.

### Example 2: Create a personal project

```powershell
New-GitlabProject -ProjectName "my-personal-project" -Personal
```

Creates a new personal project.

### Example 3: Create and clone a project

```powershell
New-GitlabProject -ProjectName "my-project" -DestinationGroup "mygroup" -CloneNow
```

Creates a new project and immediately clones it to the current directory.

## PARAMETERS

### -BuildTimeout

The CI/CD job timeout in seconds. Set to 0 to use the default timeout.

```yaml
Type: System.UInt32
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

### -CloneNow

When specified, clones the newly created project to the current directory and changes to the project folder.

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

The ID or URL-encoded path of the group where the project will be created.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Group
ParameterSets:
- Name: Group
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Personal

When specified, creates the project in the current user's personal namespace.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Personal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectName

The name of the new project.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
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

### -Visibility

The visibility level of the new project. Valid values are 'private', 'internal', or 'public'. Defaults to 'internal'.

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

### System.String

You can pipe a group ID to this cmdlet via the DestinationGroup parameter.

## OUTPUTS

### Gitlab.Project

Returns the newly created GitLab project object, unless -CloneNow is specified.

### System.Object

See [Gitlab.Project](#gitlabproject)

## NOTES

This cmdlet uses the GitLab Projects API to create new projects.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Create Project](https://docs.gitlab.com/ee/api/projects.html#create-project)
