---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Update-LocalGitlabGroup
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Update-LocalGitlabGroup
---

# Update-LocalGitlabGroup

## SYNOPSIS

Pulls the latest changes for all local git repositories.

## SYNTAX

### __AllParameterSets

```
Update-LocalGitlabGroup [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Pull-GitlabGroup`


## DESCRIPTION

Recursively searches for git repositories in the current directory and runs 'git pull -p' on each one to fetch and prune remote tracking branches. This is useful for keeping a local clone of a GitLab group up to date.

## EXAMPLES

### Example 1: Update all repositories in current directory

```powershell
Update-LocalGitlabGroup
```

Pulls the latest changes for all git repositories found recursively in the current directory.

### Example 2: Preview which repositories would be updated

```powershell
Update-LocalGitlabGroup -WhatIf
```

Shows which repositories would be updated without actually pulling changes.

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

### None

This cmdlet does not return any output. Git pull output is displayed for each repository.

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

Alias: Pull-GitlabGroup

This cmdlet operates on local git repositories only and does not make API calls to GitLab.

## RELATED LINKS

- [Copy-GitlabGroupToLocalFileSystem](Copy-GitlabGroupToLocalFileSystem.md)
