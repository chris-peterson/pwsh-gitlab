---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Get-GitlabPipelineDefinition
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipelineDefinition
---

# Get-GitlabPipelineDefinition

## SYNOPSIS

Retrieves the GitLab CI/CD pipeline definition (.gitlab-ci.yml) for a project.

## SYNTAX

### Default

```
Get-GitlabPipelineDefinition
    [[-ProjectId] <string>]
    [-Ref] <string>]
    [-SiteUrl] <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves and parses the .gitlab-ci.yml file from a project repository. The YAML content is converted to a PowerShell object for easy inspection and manipulation of the pipeline configuration.

## EXAMPLES

### Example 1

```powershell
Get-GitlabPipelineDefinition
```

Retrieves the pipeline definition from the current project's default branch.

### Example 2

```powershell
Get-GitlabPipelineDefinition -ProjectId 'mygroup/myproject' -Ref 'develop'
```

Retrieves the pipeline definition from the develop branch of a specific project.

## PARAMETERS

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

### -Ref

The branch or tag name to retrieve the pipeline definition from. If not specified, uses the project's default branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

### -SiteUrl

The URL of the GitLab site. If not specified, uses the default configured site.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable

Returns the parsed .gitlab-ci.yml content as a hashtable/object containing the pipeline configuration including stages, jobs, variables, and other CI/CD settings.

### System.Object

See [System.Collections.Hashtable](#systemcollectionshashtable)

## NOTES

Requires the powershell-yaml module for YAML parsing.

## RELATED LINKS

- [Test-GitlabPipelineDefinition](Test-GitlabPipelineDefinition.md)
- [GitLab CI/CD YAML Reference](https://docs.gitlab.com/ee/ci/yaml/)
