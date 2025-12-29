---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/MergeRequests/Set-GitlabMergeRequest.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Set-GitlabMergeRequest
---

# Set-GitlabMergeRequest

## SYNOPSIS

Gets an existing merge request for the current branch or creates a new one.

## SYNTAX

### __AllParameterSets

```
Set-GitlabMergeRequest [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `mr`


## DESCRIPTION

The `Set-GitlabMergeRequest` cmdlet provides a convenient way to ensure a merge request exists for the current branch. It first checks if an open merge request already exists for the current branch in the current project. If one exists, it returns the existing merge request. If not, it creates a new merge request. This is a convenience cmdlet designed for use in a local git context and does not accept a SiteUrl parameter.

## EXAMPLES

### Example 1: Get or create a merge request for the current branch

```powershell
Set-GitlabMergeRequest
```

Returns the existing open merge request for the current branch, or creates a new one if none exists.

### Example 2: Use the alias to quickly create or get a merge request

```powershell
mr
```

Uses the `mr` alias to get or create a merge request for the current branch.

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

### Gitlab.MergeRequest

Returns a GitLab merge request object representing either the existing merge request or the newly created one.

### System.Object

See [Gitlab.MergeRequest](#gitlabmergerequest)

## NOTES

## RELATED LINKS

- [Get-GitlabMergeRequest](Get-GitlabMergeRequest.md)
- [New-GitlabMergeRequest](New-GitlabMergeRequest.md)
