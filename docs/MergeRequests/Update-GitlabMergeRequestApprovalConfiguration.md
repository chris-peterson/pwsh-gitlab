---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Update-GitlabMergeRequestApprovalConfiguration
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Update-GitlabMergeRequestApprovalConfiguration
---

# Update-GitlabMergeRequestApprovalConfiguration

## SYNOPSIS

Updates the merge request approval configuration for a project.

## SYNTAX

### __AllParameterSets

```
Update-GitlabMergeRequestApprovalConfiguration [[-ProjectId] <string>]
 [-DisableOverridingApproversPerMergeRequest <bool>] [-MergeRequestsAuthorApproval <bool>]
 [-MergeRequestsDisableCommittersApproval <bool>] [-RequirePasswordToApprove <bool>]
 [-ResetApprovalsOnPush <bool>] [-SelectiveCodeOwnerRemovals <bool>] [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Update-GitlabMergeRequestApprovalConfiguration` cmdlet modifies project-level merge request approval settings including whether authors can approve, whether committers can approve, password requirements, approval reset behavior, and code owner approval settings.

## EXAMPLES

### Example 1: Disable author approval for merge requests

```powershell
Update-GitlabMergeRequestApprovalConfiguration -MergeRequestsAuthorApproval $false
```

Configures the current project to prevent merge request authors from approving their own merge requests.

### Example 2: Require password to approve and reset approvals on push

```powershell
Update-GitlabMergeRequestApprovalConfiguration -ProjectId 'mygroup/myproject' -RequirePasswordToApprove $true -ResetApprovalsOnPush $true
```

Configures the specified project to require password re-entry for approvals and reset approvals when new commits are pushed.

### Example 3: Disable overriding approvers per merge request

```powershell
Update-GitlabMergeRequestApprovalConfiguration -DisableOverridingApproversPerMergeRequest $true
```

Prevents users from modifying the approvers list on individual merge requests.

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

### -DisableOverridingApproversPerMergeRequest

When true, prevents users from overriding the approvers list on individual merge requests.

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

### -MergeRequestsAuthorApproval

When true, allows merge request authors to approve their own merge requests.

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

### -MergeRequestsDisableCommittersApproval

When true, prevents users who have committed to the merge request from approving it.

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

### -RequirePasswordToApprove

When true, requires users to enter their password when approving merge requests.

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

### -ResetApprovalsOnPush

When true, removes all approvals from a merge request when new commits are pushed.

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

### -SelectiveCodeOwnerRemovals

When true, only removes code owner approvals when files owned by the code owner are changed.

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

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject)

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

## RELATED LINKS

- [Get-GitlabMergeRequestApprovalConfiguration](Get-GitlabMergeRequestApprovalConfiguration.md)
- [Get-GitlabMergeRequestApprovalRule](Get-GitlabMergeRequestApprovalRule.md)
