---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Get-GitlabMergeRequestApprovalRule
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabMergeRequestApprovalRule
---

# Get-GitlabMergeRequestApprovalRule

## SYNOPSIS

Gets merge request approval rules for a project.

## SYNTAX

### Default

```
Get-GitlabMergeRequestApprovalRule
    [[-ProjectId] <string>]
    [-ApprovalRuleId] <string>]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-GitlabMergeRequestApprovalRule` cmdlet retrieves project-level approval rules that define the number of required approvals and who can approve merge requests. You can get all approval rules or a specific rule by ID.

## EXAMPLES

### Example 1: Get all approval rules for the current project

```powershell
Get-GitlabMergeRequestApprovalRule
```

Retrieves all merge request approval rules for the current project.

### Example 2: Get a specific approval rule by ID

```powershell
Get-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject' -ApprovalRuleId 5
```

Retrieves the approval rule with ID 5 from the specified project.

## PARAMETERS

### -ApprovalRuleId

The ID of a specific approval rule to retrieve. If not specified, all approval rules are returned.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
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

Returns one or more merge request approval rule objects.

### System.Object

See [Gitlab.MergeRequestApprovalRule](#gitlabmergerequestapprovalrule)

## NOTES

## RELATED LINKS

- [New-GitlabMergeRequestApprovalRule](New-GitlabMergeRequestApprovalRule.md)
- [Remove-GitlabMergeRequestApprovalRule](Remove-GitlabMergeRequestApprovalRule.md)
