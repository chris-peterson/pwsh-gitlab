---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/New-GitlabMergeRequestApprovalRule
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabMergeRequestApprovalRule
---

# New-GitlabMergeRequestApprovalRule

## SYNOPSIS

Creates a new merge request approval rule for a project.

## SYNTAX

### __AllParameterSets

```
New-GitlabMergeRequestApprovalRule [[-ProjectId] <string>] [-Name] <string>
 [-ApprovalsRequired] <uint> [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `New-GitlabMergeRequestApprovalRule` cmdlet creates a new project-level approval rule that applies to all protected branches. The rule specifies a name and the number of required approvals for merge requests.

## EXAMPLES

### Example 1: Create an approval rule requiring 2 approvals

```powershell
New-GitlabMergeRequestApprovalRule -Name 'Code Review' -ApprovalsRequired 2
```

Creates a new approval rule named 'Code Review' that requires 2 approvals for the current project.

### Example 2: Create an approval rule for a specific project

```powershell
New-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject' -Name 'Security Review' -ApprovalsRequired 1
```

Creates a new approval rule named 'Security Review' that requires 1 approval for the specified project.

## PARAMETERS

### -ApprovalsRequired

The number of approvals required for merge requests to satisfy this rule.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

### -Name

The name of the approval rule.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's project.

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

### -SiteUrl

Specifies the URL of the GitLab instance. If not specified, uses the default configured site.

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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.MergeRequestApprovalRule

Returns the newly created merge request approval rule object.

### System.Object

See [Gitlab.MergeRequestApprovalRule](#gitlabmergerequestapprovalrule)

## NOTES

## RELATED LINKS

- [Get-GitlabMergeRequestApprovalRule](Get-GitlabMergeRequestApprovalRule.md)
- [Remove-GitlabMergeRequestApprovalRule](Remove-GitlabMergeRequestApprovalRule.md)
