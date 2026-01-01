---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Test-GitlabPipelineDefinition
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Test-GitlabPipelineDefinition
---

# Test-GitlabPipelineDefinition

## SYNOPSIS

Validates a GitLab CI/CD pipeline definition.

## SYNTAX

### __AllParameterSets

```
Test-GitlabPipelineDefinition [[-ProjectId] <string>] [[-Content] <string>] [[-Select] <string>]
 [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Validates a GitLab CI/CD pipeline definition (.gitlab-ci.yml) using the GitLab CI Lint API. Can validate YAML content directly or validate a project's existing CI configuration. Returns validation results including any errors found.

## EXAMPLES

### Example 1

```powershell
Test-GitlabPipelineDefinition
```

Validates the current project's .gitlab-ci.yml file.

### Example 2

```powershell
Test-GitlabPipelineDefinition -Content (Get-Content '.gitlab-ci.yml' -Raw)
```

Validates YAML content from a local file.

### Example 3

```powershell
Test-GitlabPipelineDefinition -Content '.gitlab-ci.yml' -Select 'valid,errors'
```

Validates a file and returns only the valid status and any errors.

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

### -Content

The YAML content to validate, or a path to a YAML file. If a valid file path is provided, the content is read from the file.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's Git remote.

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

### -Select

A comma-separated list of properties to include in the output. Use to filter the returned object properties.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab site. If not specified, uses the default configured site.

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

## OUTPUTS

### Gitlab.PipelineDefinition

Returns a validation result object with properties including Valid (boolean), Errors (array), Warnings (array), and MergedYaml (the fully resolved pipeline configuration).

### System.Object

See [Gitlab.PipelineDefinition](#gitlabpipelinedefinition)

## NOTES

When Content is provided, uses POST to validate the content. When Content is omitted, uses GET to validate the project's existing CI configuration.

## RELATED LINKS

- [GitLab CI Lint API](https://docs.gitlab.com/ee/api/lint.html)
- [Get-GitlabPipelineDefinition](Get-GitlabPipelineDefinition.md)
