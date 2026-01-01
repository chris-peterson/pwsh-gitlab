---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Branches/Remove-GitlabBranch
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabBranch
---

# Remove-GitlabBranch

## SYNOPSIS

Deletes a branch or merged branches from a GitLab project repository.

## SYNTAX

### ByBranch (Default)

```
Remove-GitlabBranch [[-Branch] <string>] [-ProjectId <string>] [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### MergedBranches

```
Remove-GitlabBranch [-ProjectId <string>] [-MergedBranches] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a specific branch or all merged branches from a GitLab project repository. This operation requires confirmation due to its destructive nature.

## EXAMPLES

### Example 1

```powershell
Remove-GitlabBranch -Name 'feature/old-feature'
```

Deletes the 'feature/old-feature' branch from the current project.

### Example 2

```powershell
Remove-GitlabBranch -MergedBranches
```

Deletes all merged branches from the current project.

### Example 3

```powershell
Remove-GitlabBranch -ProjectId 'mygroup/myproject' -Name 'cleanup-branch' -Confirm:$false
```

Deletes the specified branch without confirmation prompt.

## PARAMETERS

### -Branch

Branch name to remove.  Defaults to `.` which is interpreted as the current branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: ByBranch
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### -MergedBranches

When specified, deletes all branches that have been merged into the default branch.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: MergedBranches
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the branch to delete. Use '.' to delete the current local branch.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project.
Defaults to the current directory's git repository.

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

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.
The URL of the GitLab site to connect to.
If not specified, uses the default configured site.

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

### System.String

You can pipe a project ID and branch name to this cmdlet.

## OUTPUTS

### System.Object

See [System.Void](#systemvoid).

### System.Void

N/A

## NOTES

This cmdlet has a High confirm impact. Use -Confirm:$false to bypass confirmation, or -WhatIf to preview the operation.

## RELATED LINKS

- [GitLab Branches API](https://docs.gitlab.com/ee/api/branches.html)
