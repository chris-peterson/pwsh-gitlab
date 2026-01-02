---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Variables/ConvertTo-GitlabVariables
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: ConvertTo-GitlabVariables
---

# ConvertTo-GitlabVariables

## SYNOPSIS

Converts a hashtable or PSCustomObject to GitLab CI/CD variable format.

## SYNTAX

### __AllParameterSets

```
ConvertTo-GitlabVariables [[-Object] <Object>] [[-VariableType] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `ConvertTo-GitlabVariables` cmdlet converts a hashtable or `PSCustomObject` to the array format expected by GitLab's API for CI/CD variables. Each key-value pair becomes an object with `key` and `value` properties, and optionally a `variable_type` property.

## EXAMPLES

### Example 1: Convert a hashtable to GitLab variables

```powershell
@{ DEPLOY_ENV = 'production'; VERSION = '1.0.0' } | ConvertTo-GitlabVariables
```

Converts the hashtable to an array of GitLab variable objects.

### Example 2: Convert with a variable type

```powershell
@{ SECRET_KEY = 'abc123' } | ConvertTo-GitlabVariables -VariableType 'env_var'
```

Converts the hashtable and includes the `variable_type` property set to `env_var`.

### Example 3: Use with pipeline triggering

```powershell
$vars = @{ BRANCH = 'main'; DEBUG = 'true' } | ConvertTo-GitlabVariables
Invoke-GitlabApi POST 'projects/123/trigger/pipeline' -Body @{ ref = 'main'; variables = $vars }
```

Creates variables for use when triggering a pipeline.

## PARAMETERS

### -Object

The hashtable or `PSCustomObject` to convert. Each property or key-value pair becomes a GitLab variable with `key` and `value` properties.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -VariableType

Optional type to assign to all variables. Common values are `env_var` (environment variable) and `file` (file variable). If not specified, no `variable_type` property is included.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Type
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

### System.Collections.Hashtable or System.Management.Automation.PSCustomObject

A hashtable or PSCustomObject containing key-value pairs to convert to GitLab variable format.

### System.Object

HIDE_ME

Accepts any object from the pipeline.

## OUTPUTS

### System.Object

HIDE_ME

### System.Collections.Hashtable

Returns a hashtable.

## NOTES

This function is useful when working with GitLab APIs that expect variables in a specific array format, such as when triggering pipelines or creating/updating CI/CD variables.

## RELATED LINKS

- [GitLab CI/CD Variables API](https://docs.gitlab.com/ee/api/project_level_variables.html)
- [Resolve-GitlabVariable](Resolve-GitlabVariable.md)
- [Get-GitlabProjectVariable](../Projects/Get-GitlabProjectVariable.md)
