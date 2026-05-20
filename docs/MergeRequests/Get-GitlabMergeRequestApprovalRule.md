---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Get-GitlabMergeRequestApprovalRule
Locale: en-US
Module Name: GitlabCli
ms.date: 05/20/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabMergeRequestApprovalRule
---

# Get-GitlabMergeRequestApprovalRule

## SYNOPSIS

Gets merge request approval rules — project-level templates by default, or per-MR synthesized rules (including CODEOWNERS) with `-MergeRequestId`.

## SYNTAX

### Project (Default)

```
Get-GitlabMergeRequestApprovalRule [[-ProjectId] <string>] [[-ApprovalRuleId] <string>]
 [-SiteUrl <string>] [<CommonParameters>]
```

### MergeRequest

```
Get-GitlabMergeRequestApprovalRule [[-ProjectId] <string>] -MergeRequestId <string>
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Returns approval rules at one of two scopes:

- **Project** (default): the project-level rule templates that define how many approvals are required and who can approve. Hits `/projects/:id/approval_rules`. Emits `Gitlab.MergeRequestApprovalRule` objects.
- **MergeRequest** (`-MergeRequestId`): the rules GitLab synthesized for a specific MR, including the `code_owner` rows built from CODEOWNERS. Hits `/projects/:id/merge_requests/:iid/approval_state`. Emits `Gitlab.MergeRequestApprovalRuleState` objects, each carrying `Approved`, `ApprovedBy`, `Section`, `CodeOwner`, `Overridden`, `SourceRule` (state fields only available per-MR), plus `MergeRequestId` and `ApprovalRulesOverwritten`.

For a flat rollup of required/left/approved-by counts, see [Get-GitlabMergeRequestApproval](Get-GitlabMergeRequestApproval.md).

## EXAMPLES

### Example 1: Get all project-level approval rules

```powershell
Get-GitlabMergeRequestApprovalRule
```

### Example 2: Get a specific project-level rule by ID

```powershell
Get-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject' -ApprovalRuleId 5
```

### Example 3: Get the synthesized rules for a specific MR

```powershell
Get-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject' -MergeRequestId 456
```

### Example 4: Show just the CODEOWNERS rules for an MR

```powershell
Get-GitlabMergeRequestApprovalRule -MergeRequestId 456 |
    Where-Object RuleType -eq 'code_owner' |
    Select-Object Section, Name, ApprovalsRequired, Approved
```

## PARAMETERS

### -ApprovalRuleId

The ID of a specific project-level approval rule to retrieve. Only valid in the `Project` parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Project
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MergeRequestId

The IID of a merge request. When supplied, switches to the per-MR synthesized rules endpoint (`/approval_state`).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Iid
ParameterSets:
- Name: MergeRequest
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's project.

```yaml
Type: System.String
DefaultValue: .
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: MergeRequest
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Project
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

ProjectId, ApprovalRuleId, and MergeRequestId can be provided via pipeline by property name.

## OUTPUTS

### Gitlab.MergeRequestApprovalRule

Project-level rule. Returned when called without `-MergeRequestId`.

### Gitlab.MergeRequestApprovalRuleState

Per-MR synthesized rule. Returned when called with `-MergeRequestId`. Adds `Approved`, `ApprovedBy`, `Section`, `CodeOwner`, `Overridden`, `SourceRule`, `MergeRequestId`, and `ApprovalRulesOverwritten` to the project-rule fields.

## NOTES

## RELATED LINKS

- [Get-GitlabMergeRequestApproval](Get-GitlabMergeRequestApproval.md)
- [New-GitlabMergeRequestApprovalRule](New-GitlabMergeRequestApprovalRule.md)
- [Remove-GitlabMergeRequestApprovalRule](Remove-GitlabMergeRequestApprovalRule.md)
