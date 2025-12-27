---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Pipelines/Get-GitlabPipelineVariable.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipelineVariable
---

# Get-GitlabPipelineVariable

## SYNOPSIS

Gets variables from a GitLab pipeline.

## SYNTAX

### __AllParameterSets

```
Get-GitlabPipelineVariable [-PipelineId] <string> [[-Variable] <string>] [-ProjectId <string>]
 [-As <string>] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves variables that were used in a GitLab pipeline. Can return all variables as key-value pairs, as a single object with properties, or retrieve a specific variable by name.

## EXAMPLES

### Example 1: Get all variables from a pipeline

```powershell
Get-GitlabPipelineVariable -PipelineId 12345
```

Retrieves all variables from the specified pipeline as key-value pairs.

### Example 2: Get a specific variable value

```powershell
Get-GitlabPipelineVariable -PipelineId 12345 -Variable 'DEPLOY_ENV'
```

Retrieves only the value of the DEPLOY_ENV variable.

### Example 3: Get variables as a single object

```powershell
Get-GitlabPipelineVariable -PipelineId 12345 -As 'Object'
```

Returns a single object with variable names as properties and their values.

## PARAMETERS

### -As

Specifies the output format. 'KeyValuePairs' returns separate objects for each variable. 'Object' returns a single object with variables as properties.

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

### -PipelineId

The ID of the pipeline to retrieve variables from.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the project in the current directory.

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

The URL of the GitLab site to connect to. Defaults to the configured default site.

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

### -Variable

The name of a specific variable to retrieve. Returns only the value of the specified variable.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a pipeline ID to this cmdlet.

## OUTPUTS

### Gitlab.PipelineVariable

Returns pipeline variable objects with Key and Value properties (when using KeyValuePairs format), a single PSObject with variable names as properties (when using Object format), or a string value (when specifying a Variable name).

### System.Object

See [Gitlab.PipelineVariable](#gitlabpipelinevariable)

## NOTES

## RELATED LINKS

- [GitLab Pipelines API - Get variables of a pipeline](https://docs.gitlab.com/ee/api/pipelines.html#get-variables-of-a-pipeline)
- [Get-GitlabPipeline](Get-GitlabPipeline.md)
- [New-GitlabPipeline](New-GitlabPipeline.md)
