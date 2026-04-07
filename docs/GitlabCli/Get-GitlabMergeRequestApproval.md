---
document type: cmdlet
external help file: MergeRequests-Help.xml
HelpUri: ''
Locale: en-US
Module Name: MergeRequests
ms.date: 04/07/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabMergeRequestApproval
---

# Get-GitlabMergeRequestApproval

## SYNOPSIS

Gets approval information for a merge request.

## SYNTAX

### __AllParameterSets

```
Get-GitlabMergeRequestApproval [[-ProjectId] <string>] [-MergeRequestId] <string>
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Returns the approval status of a merge request, including the number of required and remaining approvals, and the list of users who have approved.

## EXAMPLES

### Example 1

```powershell
Get-GitlabMergeRequestApproval -ProjectId 123 -MergeRequestId 456
```

## PARAMETERS

### -MergeRequestId

The IID of the merge request.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

The project ID or path. Defaults to the current directory.

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

The GitLab site URL to use. Defaults to the configured default site.

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

ProjectId and MergeRequestId can be provided via pipeline by property name.

## OUTPUTS

### System.Management.Automation.PSObject

Returns an object with ApprovalsRequired, ApprovalsLeft, and ApprovedBy properties.

## NOTES

Uses the GitLab merge request approvals API endpoint.

## RELATED LINKS

- [Approve-GitlabMergeRequest](Approve-GitlabMergeRequest.md)
