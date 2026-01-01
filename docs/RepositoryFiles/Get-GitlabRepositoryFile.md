---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/RepositoryFiles/Get-GitlabRepositoryFile
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabRepositoryFile
---

# Get-GitlabRepositoryFile

## SYNOPSIS

Gets file metadata from a GitLab repository.

## SYNTAX

### __AllParameterSets

```
Get-GitlabRepositoryFile [-FilePath] <string> [-ProjectId <string>] [-Ref <string>]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves file metadata from a GitLab repository including file name, size, encoding, and base64-encoded content. Use Get-GitlabRepositoryFileContent to retrieve the decoded file content directly.

## EXAMPLES

### Example 1: Get file metadata from the current project

```powershell
Get-GitlabRepositoryFile -FilePath 'README.md'
```

Retrieves metadata for README.md from the current project's default branch.

### Example 2: Get file metadata from a specific branch

```powershell
Get-GitlabRepositoryFile -ProjectId 'mygroup/myproject' -FilePath 'src/config.json' -Ref 'develop'
```

Retrieves metadata for config.json from the develop branch of the specified project.

### Example 3: Get file metadata using Branch alias

```powershell
Get-GitlabRepositoryFile -FilePath '.gitlab-ci.yml' -Branch 'feature-branch'
```

Retrieves CI configuration file metadata from a feature branch.

## PARAMETERS

### -FilePath

The path to the file in the repository (e.g., 'src/app.js' or 'README.md').

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

### Gitlab.RepositoryFile

Returns a repository file object containing file metadata including file name, path, size, encoding, and base64-encoded content.

### System.Object

See [Gitlab.RepositoryFile](#gitlabrepositoryfile)

## NOTES

## RELATED LINKS

- [GitLab Repository Files API](https://docs.gitlab.com/ee/api/repository_files.html)
- [Get-GitlabRepositoryFileContent](Get-GitlabRepositoryFileContent.md)
