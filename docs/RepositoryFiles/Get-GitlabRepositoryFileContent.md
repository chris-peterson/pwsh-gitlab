---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/RepositoryFiles/Get-GitlabRepositoryFileContent
Locale: en-US
Module Name: GitlabCli
ms.date: 01/20/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabRepositoryFileContent
---

# Get-GitlabRepositoryFileContent

## SYNOPSIS

Gets the decoded content of a file from a GitLab repository.

## SYNTAX

### __AllParameterSets

```
Get-GitlabRepositoryFileContent [-FilePath] <string> [-ProjectId <string>] [-Ref <string>]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves and decodes the content of a file from a GitLab repository. The file content is returned as a UTF-8 decoded string. This is a convenience wrapper around Get-GitlabRepositoryFile that automatically decodes base64-encoded content.

## EXAMPLES

### Example 1: Get file content from the current project

```powershell
Get-GitlabRepositoryFileContent -FilePath 'README.md'
```

Retrieves the content of README.md from the current project's default branch.

### Example 2: Get file content from a specific branch

```powershell
Get-GitlabRepositoryFileContent -ProjectId 'mygroup/myproject' -FilePath 'config/settings.yml' -Ref 'develop'
```

Retrieves the content of settings.yml from the develop branch.

### Example 3: Parse YAML file content

```powershell
Get-GitlabRepositoryFileContent -FilePath '.gitlab-ci.yml' | ConvertFrom-Yaml
```

Retrieves the CI configuration and converts it from YAML to a PowerShell object.

## PARAMETERS

### -FilePath

The path to the file in the repository (e.g., 'src/app.js' or 'README.md').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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
  ValueFromPipelineByPropertyName: true
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

### System.String

You can pipe a project ID to this cmdlet.

## OUTPUTS

### System.String

Returns the UTF-8 decoded content of the file as a string.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Repository Files API](https://docs.gitlab.com/ee/api/repository_files.html)
- [Get-GitlabRepositoryFile](Get-GitlabRepositoryFile.md)
