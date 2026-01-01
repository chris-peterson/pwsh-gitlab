---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Get-GitlabGroupVariable
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabGroupVariable
---

# Get-GitlabGroupVariable

## SYNOPSIS

Retrieves CI/CD variables defined at the group level.

## SYNTAX

### Default

```
Get-GitlabGroupVariable
    [-GroupId] <string> [[-Key] <string>]
    [-SiteUrl <string>]
    [-MaxPages <uint>]
    [-All]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets one or more CI/CD variables defined at the group level. Can retrieve a specific variable by key or list all variables for a group.

## EXAMPLES

### Example 1: Get all variables for a group

```powershell
Get-GitlabGroupVariable -GroupId "my-group"
```

Retrieves all CI/CD variables defined in "my-group".

### Example 2: Get a specific variable

```powershell
Get-GitlabGroupVariable -GroupId "my-group" -Key "MY_SECRET"
```

Retrieves the variable named "MY_SECRET" from "my-group".

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

### -GroupId

The ID or URL-encoded path of the group.

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

### -Key

The key (name) of a specific variable to retrieve. If not specified, all variables are returned.

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

The GroupId can be provided via the pipeline by property name.

## OUTPUTS

### Gitlab.Variable

Returns one or more GitLab variable objects.

### System.Object

See [Gitlab.Variable](#gitlabvariable).

## NOTES

Group-level CI/CD variables are available to all projects within the group.

## RELATED LINKS

- [GitLab Group-level Variables API - List group variables](https://docs.gitlab.com/ee/api/group_level_variables.html#list-group-variables)
- [GitLab Group-level Variables API - Show variable details](https://docs.gitlab.com/ee/api/group_level_variables.html#show-variable-details)
