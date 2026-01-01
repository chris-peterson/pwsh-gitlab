---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/RepositoryFiles/New-GitlabRepositoryFile
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabRepositoryFile
---

# New-GitlabRepositoryFile

## SYNOPSIS

Creates a new file in a GitLab repository.

## SYNTAX

### Default

```
New-GitlabRepositoryFile
    [-FilePath] <string> -Content <string> -CommitMessage <string> [-ProjectId <string>]
    [-Branch <string>]
    [-SkipCi <bool>]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new file in a GitLab repository with the specified content and commit message. The file is created directly via the GitLab API without requiring a local clone.

## EXAMPLES

### Example 1: Create a new file

```powershell
New-GitlabRepositoryFile -FilePath 'docs/README.md' -Content '# Documentation' -CommitMessage 'Add documentation'
```

Creates a new README.md file in the docs folder with a commit message.

### Example 2: Create a file on a specific branch

```powershell
New-GitlabRepositoryFile -ProjectId 'mygroup/myproject' -FilePath 'config.json' -Content '{"key": "value"}' -CommitMessage 'Add config' -Branch 'develop'
```

Creates a new config.json file on the develop branch.

### Example 3: Create a file with CI pipeline triggered

```powershell
New-GitlabRepositoryFile -FilePath 'script.sh' -Content '#!/bin/bash' -CommitMessage 'Add script' -SkipCi $false
```

Creates a file without adding [skip ci] to the commit message, allowing CI pipelines to run.

## PARAMETERS

### -Branch

The name of the branch to create the file on. Defaults to the project's default branch.

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

### -CommitMessage

The commit message to use when creating the file.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

The content to write to the new file.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FilePath

The path where the file will be created in the repository (e.g., 'src/app.js' or 'docs/README.md').

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

### -SkipCi

If true (default), appends [skip ci] to the commit message to prevent CI pipelines from running.

```yaml
Type: System.Boolean
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

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Repository Files API](https://docs.gitlab.com/ee/api/repository_files.html)
- [Update-GitlabRepositoryFile](Update-GitlabRepositoryFile.md)
