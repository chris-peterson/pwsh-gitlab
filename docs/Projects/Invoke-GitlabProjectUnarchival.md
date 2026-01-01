---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Invoke-GitlabProjectUnarchival
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-GitlabProjectUnarchival
---

# Invoke-GitlabProjectUnarchival

## SYNOPSIS

Unarchives a GitLab project.

## SYNTAX

### Default

```
Invoke-GitlabProjectUnarchival
    [[-ProjectId] <string>]
    [-SiteUrl] <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

- `Unarchive-GitlabProject`


## DESCRIPTION

Restores an archived GitLab project to active status. After unarchiving, the project will be writable and visible in the default project list again.

## EXAMPLES

### Example 1: Unarchive the current project

```powershell
Invoke-GitlabProjectUnarchival
```

Unarchives the current directory's project.

### Example 2: Unarchive a specific project

```powershell
Invoke-GitlabProjectUnarchival -ProjectId "mygroup/myproject"
```

Unarchives the specified project.

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
  Position: 1
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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Project

Returns the unarchived GitLab project object.

### System.Object

See [Gitlab.Project](#gitlabproject)

## NOTES

This cmdlet has an alias: Unarchive-GitlabProject.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Unarchive a Project](https://docs.gitlab.com/ee/api/projects.html#unarchive-a-project)
