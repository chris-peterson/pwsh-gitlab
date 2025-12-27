---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/RepositoryFiles/Get-GitlabRepositoryTree.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabRepositoryTree
---

# Get-GitlabRepositoryTree

## SYNOPSIS

Gets the repository tree (file and directory listing) from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabRepositoryTree [[-Path] <string>] [-ProjectId <string>] [-Ref <string>] [-Recurse]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the repository tree (list of files and directories) from a GitLab project. Can list contents of a specific path and optionally recurse into subdirectories.

## EXAMPLES

### Example 1: List root directory contents

```powershell
Get-GitlabRepositoryTree
```

Lists all files and directories in the root of the current project.

### Example 2: List contents of a specific directory

```powershell
Get-GitlabRepositoryTree -Path 'src/components'
```

Lists files and directories in the src/components folder.

### Example 3: Recursively list all files

```powershell
Get-GitlabRepositoryTree -ProjectId 'mygroup/myproject' -Recurse -Ref 'develop'
```

Recursively lists all files and directories from the develop branch.

## PARAMETERS

### -Path

The path inside the repository to list. If not specified, lists the root directory.

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

### -Recurse

If specified, recursively lists all files and directories in the repository tree.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- r
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

The name of the branch, tag, or commit to retrieve the tree from. Defaults to the project's default branch.

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

### Gitlab.RepositoryTree

Returns repository tree objects containing file/directory name, path, type (tree or blob), and mode.

### System.Object

See [Gitlab.RepositoryTree](#gitlabrepositorytree)

## NOTES

## RELATED LINKS

- [GitLab Repository Files API](https://docs.gitlab.com/ee/api/repository_files.html)
