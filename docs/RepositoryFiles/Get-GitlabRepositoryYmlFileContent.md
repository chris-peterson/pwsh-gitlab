---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/RepositoryFiles/Get-GitlabRepositoryYmlFileContent
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabRepositoryYmlFileContent
---

# Get-GitlabRepositoryYmlFileContent

## SYNOPSIS

Gets and parses YAML file content from a GitLab repository.

## SYNTAX

### Default

```
Get-GitlabRepositoryYmlFileContent
    [-FilePath] <string> [-ProjectId <string>]
    [-Ref <string>]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves a YAML file from a GitLab repository and parses it into a PowerShell object. This cmdlet is deprecated - use `Get-GitlabRepositoryFileContent | ConvertFrom-Yaml` instead.

## EXAMPLES

### Example 1: Get parsed YAML configuration

```powershell
Get-GitlabRepositoryYmlFileContent -FilePath '.gitlab-ci.yml'
```

Retrieves and parses the GitLab CI configuration file.

### Example 2: Use the recommended alternative

```powershell
Get-GitlabRepositoryFileContent -FilePath 'config.yml' | ConvertFrom-Yaml
```

The recommended way to get parsed YAML content.

## PARAMETERS

### -FilePath

The path to the YAML file in the repository (e.g., '.gitlab-ci.yml' or 'config/settings.yml').

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

The ID or URL-encoded path of the project. Defaults to the current project based on local git context.

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

### -Ref

The name of the branch, tag, or commit to retrieve the file from. Defaults to the project's default branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

The URL of the GitLab instance. If not specified, uses the default configured GitLab site.

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

## OUTPUTS

### System.Object

See [System.Collections.Hashtable](#systemcollectionshashtable)

### System.Collections.Hashtable

Returns a hashtable.

## NOTES

This cmdlet is deprecated. Use `Get-GitlabRepositoryFileContent | ConvertFrom-Yaml` instead.

## RELATED LINKS

- [GitLab Repository Files API](https://docs.gitlab.com/ee/api/repository_files.html)
- [Get-GitlabRepositoryFileContent](Get-GitlabRepositoryFileContent.md)
