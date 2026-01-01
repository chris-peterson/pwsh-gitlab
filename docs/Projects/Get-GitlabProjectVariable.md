---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Get-GitlabProjectVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectVariable
---

# Get-GitlabProjectVariable

## SYNOPSIS

Retrieves CI/CD variables for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabProjectVariable [[-Key] <string>] [-ProjectId <string>] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets one or all CI/CD variables defined at the project level. When a key is specified, returns the specific variable; otherwise, returns all project variables.

## EXAMPLES

### Example 1: Get all project variables

```powershell
Get-GitlabProjectVariable
```

Retrieves all CI/CD variables for the current project.

### Example 2: Get a specific variable

```powershell
Get-GitlabProjectVariable -Key "MY_SECRET"
```

Retrieves the variable named "MY_SECRET".

### Example 3: Get all variables from a specific project

```powershell
Get-GitlabProjectVariable -ProjectId "mygroup/myproject" -All
```

Retrieves all CI/CD variables from the specified project.

## PARAMETERS

### -All

Retrieve all results by automatically paginating through all available pages.

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

### -Key

The key (name) of a specific variable to retrieve.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages to retrieve. GitLab returns 20 results per page by default.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Variable

Returns GitLab variable objects.

### System.Object

See [Gitlab.Variable](#gitlabvariable)

## NOTES

This cmdlet uses the GitLab Project Variables API.

## RELATED LINKS

- [GitLab Project Variables API](https://docs.gitlab.com/ee/api/project_level_variables.html)
- [List Variables](https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables)
- [Get Variable](https://docs.gitlab.com/ee/api/project_level_variables.html#get-a-single-variable)
