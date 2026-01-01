---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Git/Get-LocalGitContext
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-LocalGitContext
---

# Get-LocalGitContext

## SYNOPSIS

Retrieves the local Git repository context including the GitLab site, project path, and current branch.

## SYNTAX

### Default

```
Get-LocalGitContext
    [[-Path] <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-LocalGitContext` cmdlet reads the local Git repository configuration to determine the GitLab site (host), project path, and current branch. It parses the remote origin URL to extract the GitLab host and project path, supporting both HTTPS and SSH Git URL formats. This is useful for automatically determining the GitLab context when working within a cloned repository.

## EXAMPLES

### Example 1: Get context from current directory

```powershell
Get-LocalGitContext
```

Returns the GitLab site, project path, and current branch for the Git repository in the current directory.

### Example 2: Get context from a specific path

```powershell
Get-LocalGitContext -Path ~/projects/my-repo
```

Returns the GitLab site, project path, and current branch for the Git repository at the specified path.

## PARAMETERS

### -Path

Specifies the path to the Git repository. If not specified, defaults to the current directory ('.').

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject).

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This cmdlet requires Git to be installed and available in the system PATH. If the current location is not a FileSystem provider (e.g., a registry path), an empty context object is returned.

## RELATED LINKS

- [Get-GitlabProject](../Projects/Get-GitlabProject.md)
- [Get-GitlabBranch](../Branches/Get-GitlabBranch.md)
