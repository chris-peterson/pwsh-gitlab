---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Projects/ConvertTo-GitlabTriggerYaml.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: ConvertTo-GitlabTriggerYaml
---

# ConvertTo-GitlabTriggerYaml

## SYNOPSIS

Converts GitLab projects to a trigger YAML configuration.

## SYNTAX

### __AllParameterSets

```
ConvertTo-GitlabTriggerYaml [-InputObject] <Object> [[-Strategy] <string>] [[-StageName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Generates GitLab CI/CD trigger job YAML configuration from project objects. This is useful for creating multi-project pipelines where one project triggers pipelines in other projects.

## EXAMPLES

### Example 1: Generate trigger YAML for projects in a group

```powershell
Get-GitlabProject -GroupId "mygroup" | ConvertTo-GitlabTriggerYaml
```

Generates trigger YAML for all projects in the group.

### Example 2: Generate trigger YAML with depend strategy

```powershell
Get-GitlabProject -GroupId "mygroup" | ConvertTo-GitlabTriggerYaml -Strategy "depend"
```

Generates trigger YAML with the depend strategy, so the trigger job waits for downstream pipelines.

### Example 3: Use a custom stage name

```powershell
Get-GitlabProject -GroupId "mygroup" | ConvertTo-GitlabTriggerYaml -StageName "downstream"
```

Generates trigger YAML using "downstream" as the stage name instead of the default "trigger".

## PARAMETERS

### -InputObject

The GitLab project object(s) to convert to trigger YAML. Typically piped from Get-GitlabProject.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StageName

The name of the stage for the trigger jobs. Defaults to 'trigger'.

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

### -Strategy

The trigger strategy. When set to 'depend', the trigger job will wait for the downstream pipeline to complete. Valid values are null or 'depend'.

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

### Gitlab.Project

Accepts GitLab project objects from the pipeline.

### System.Object

Accepts any object from the pipeline.

## OUTPUTS

### System.String

Returns YAML content for GitLab CI/CD trigger jobs.

### System.Object

See [System.String](#systemstring)

## NOTES

The generated YAML can be used in a .gitlab-ci.yml file to trigger downstream pipelines.

## RELATED LINKS

- [GitLab Multi-Project Pipelines](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html)
- [GitLab Trigger Jobs](https://docs.gitlab.com/ee/ci/yaml/#trigger)
