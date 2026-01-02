---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Remove-GitlabMergeRequestApprovalRule
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabMergeRequestApprovalRule
---

# Remove-GitlabMergeRequestApprovalRule

## SYNOPSIS

Removes a merge request approval rule from a project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabMergeRequestApprovalRule [[-ProjectId] <string>] [-MergeRequestApprovalRuleId] <string>
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Remove-GitlabMergeRequestApprovalRule` cmdlet deletes a project-level approval rule. This operation has high impact and will prompt for confirmation by default.

## EXAMPLES

### Example 1: Remove an approval rule by ID

```powershell
Remove-GitlabMergeRequestApprovalRule -MergeRequestApprovalRuleId 5
```

Removes the approval rule with ID 5 from the current project. Prompts for confirmation.

### Example 2: Remove an approval rule using pipeline input

```powershell
Get-GitlabMergeRequestApprovalRule -ProjectId 'mygroup/myproject' | Where-Object Name -eq 'Old Rule' | Remove-GitlabMergeRequestApprovalRule
```

Finds the approval rule named 'Old Rule' and removes it from the project.

### Example 3: Remove an approval rule without confirmation

```powershell
Remove-GitlabMergeRequestApprovalRule -ProjectId 123 -MergeRequestApprovalRuleId 5 -Confirm:$false
```

Removes the approval rule without prompting for confirmation.

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

### -MergeRequestApprovalRuleId

The ID of the approval rule to remove.

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

You can pipe a project ID and approval rule ID to this cmdlet.

## OUTPUTS

### System.Object

HIDE_ME

### System.Void

N/A

## NOTES

## RELATED LINKS

- [Get-GitlabMergeRequestApprovalRule](Get-GitlabMergeRequestApprovalRule.md)
- [New-GitlabMergeRequestApprovalRule](New-GitlabMergeRequestApprovalRule.md)
