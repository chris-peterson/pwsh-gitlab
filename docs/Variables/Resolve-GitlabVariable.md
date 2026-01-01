---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Variables/Resolve-GitlabVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Resolve-GitlabVariable
---

# Resolve-GitlabVariable

## SYNOPSIS

Resolves a CI/CD variable value by searching up the group hierarchy.

## SYNTAX

### FromPipeline (Default)

```
Resolve-GitlabVariable [-Key] <string> -Context <Object> [-SiteUrl <string>] [<CommonParameters>]
```

### ByProject

```
Resolve-GitlabVariable [-Key] <string> -ProjectId <Object> [-SiteUrl <string>] [<CommonParameters>]
```

### ByGroup

```
Resolve-GitlabVariable [-Key] <string> -GroupId <Object> [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

- `var`


## DESCRIPTION

The `Resolve-GitlabVariable` cmdlet looks up a CI/CD variable by key, searching through the hierarchy of project and group variables. It first checks the project level, then walks up the group hierarchy until it finds a matching variable. This mimics how GitLab resolves CI/CD variables during pipeline execution.

## EXAMPLES

### Example 1: Resolve a variable for a project

```powershell
Get-GitlabProject 'mygroup/myproject' | Resolve-GitlabVariable 'DEPLOY_TOKEN'
```

Finds the `DEPLOY_TOKEN` variable, checking the project first, then its parent groups.

### Example 2: Resolve a variable using the alias

```powershell
Get-GitlabProject 'mygroup/myproject' | var 'API_KEY'
```

Uses the `var` alias to quickly resolve a variable.

### Example 3: Resolve a variable by project ID

```powershell
Resolve-GitlabVariable -ProjectId 'mygroup/subgroup/myproject' -Key 'ENVIRONMENT'
```

Resolves the variable using the project path directly without piping.

## PARAMETERS

### -Context

A GitLab project or group object (from `Get-GitlabProject` or `Get-GitlabGroup`) to use as the starting point for variable resolution.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FromPipeline
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupId

The ID or full path of a GitLab group to use as the starting point for variable resolution.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByGroup
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Key

The name of the CI/CD variable to look up.

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

### -ProjectId

The ID or full path of a GitLab project to use as the starting point for variable resolution.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProject
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

The URL of the GitLab instance to query. If not specified, uses the default configured GitLab site.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### GitLab.Project or GitLab.Group

A GitLab project or group object to use as the resolution context.

### System.Object

Accepts any object from the pipeline.

## OUTPUTS

### System.String

The value of the resolved variable, or `$null` if the variable was not found at any level in the hierarchy.

### System.Object

See [System.String](#systemstring)

## NOTES

The resolution order follows GitLab's variable precedence: project variables are checked first, then parent group variables are checked from the most specific (closest) to least specific (root). This is useful for understanding which variable value will be used in a CI/CD pipeline.

## RELATED LINKS

- [GitLab CI/CD Variable Precedence](https://docs.gitlab.com/ee/ci/variables/#cicd-variable-precedence)
- [Get-GitlabProjectVariable](../Projects/Get-GitlabProjectVariable.md)
- [Get-GitlabGroupVariable](../Groups/Get-GitlabGroupVariable.md)
- [ConvertTo-GitlabVariables](ConvertTo-GitlabVariables.md)
