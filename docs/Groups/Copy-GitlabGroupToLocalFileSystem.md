---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Copy-GitlabGroupToLocalFileSystem
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Copy-GitlabGroupToLocalFileSystem
---

# Copy-GitlabGroupToLocalFileSystem

## SYNOPSIS

Clones all projects from a GitLab group to the local file system.

## SYNTAX

### __AllParameterSets

```
Copy-GitlabGroupToLocalFileSystem [-GroupId] <string> [-ProjectLike <string>]
 [-ProjectNotLike <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Clone-GitlabGroup`


## DESCRIPTION

Clones all projects from a GitLab group (including nested subgroups) to the local file system using git clone. The directory structure mirrors the group hierarchy. Projects can be filtered using regex patterns to include or exclude specific projects.

## EXAMPLES

### Example 1: Clone all projects from a group

```powershell
Copy-GitlabGroupToLocalFileSystem -GroupId "my-org"
```

Clones all projects from "my-org" and its subgroups to the current directory.

### Example 2: Clone only projects matching a pattern

```powershell
Copy-GitlabGroupToLocalFileSystem -GroupId "my-org" -ProjectLike "api"
```

Clones only projects whose path contains "api".

### Example 3: Clone projects excluding a pattern

```powershell
Copy-GitlabGroupToLocalFileSystem -GroupId "my-org" -ProjectNotLike "deprecated"
```

Clones all projects except those whose path contains "deprecated".

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

The ID or URL-encoded path of the group to clone projects from.

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

### -ProjectLike

A regex pattern to filter projects. Only projects whose path matches this pattern will be cloned.

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

### -ProjectNotLike

A regex pattern to exclude projects. Projects whose path matches this pattern will not be cloned.

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

### System.String

The GroupId can be provided via the pipeline by property name.

## OUTPUTS

### None

This cmdlet does not return any output. Projects are cloned to the local file system.

### System.Object

See [System.Void](#systemvoid).

### System.Void

N/A

## NOTES

Alias: Clone-GitlabGroup

This cmdlet uses git clone with SSH URLs. Ensure SSH access is configured for the GitLab instance.

## RELATED LINKS

- [GitLab Groups API](https://docs.gitlab.com/ee/api/groups.html)
- [Get-GitlabProject](../Projects/Get-GitlabProject.md)
