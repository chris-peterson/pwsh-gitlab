---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Rename-GitlabProjectDefaultBranch
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Rename-GitlabProjectDefaultBranch
---

# Rename-GitlabProjectDefaultBranch

## SYNOPSIS

Renames the default branch of a GitLab project.

## SYNTAX

### __AllParameterSets

```
Rename-GitlabProjectDefaultBranch [-NewDefaultBranch] <string> [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Renames the default branch of the current GitLab project. This command performs a complete branch rename including: checking out the old branch, creating a new branch with the new name, pushing it, updating the project's default branch setting, updating branch protection, and deleting the old remote branch.

## EXAMPLES

### Example 1: Rename default branch from master to main

```powershell
Rename-GitlabProjectDefaultBranch -NewDefaultBranch "main"
```

Renames the project's default branch to "main".

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

### -NewDefaultBranch

The new name for the default branch.

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

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

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

### Gitlab.Project

Returns the updated GitLab project object with the new default branch.

### System.Object

HIDE_ME

## NOTES

This cmdlet must be run from within a GitLab project directory. It performs multiple git operations and API calls to safely rename the default branch.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Protected Branches API](https://docs.gitlab.com/ee/api/protected_branches.html)
