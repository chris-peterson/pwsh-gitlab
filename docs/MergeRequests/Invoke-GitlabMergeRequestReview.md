---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Invoke-GitlabMergeRequestReview
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-GitlabMergeRequestReview
---

# Invoke-GitlabMergeRequestReview

## SYNOPSIS

Checks out a merge request branch locally for review.

## SYNTAX

### Default

```
Invoke-GitlabMergeRequestReview
    [-MergeRequestId] <string> [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

- `Review-GitlabMergeRequest`


## DESCRIPTION

The `Invoke-GitlabMergeRequestReview` cmdlet facilitates local code review by stashing any local changes, pulling the latest code, checking out the merge request's source branch, and displaying the diff against the target branch. This allows you to review and test the merge request code locally.

## EXAMPLES

### Example 1: Review a merge request locally

```powershell
Invoke-GitlabMergeRequestReview -MergeRequestId 42
```

Stashes local changes, pulls the latest code, checks out the source branch for MR #42, and shows the diff against the target branch.

### Example 2: Use the alias to review a merge request

```powershell
Review-GitlabMergeRequest -MergeRequestId 42
```

Same as Example 1, using the `Review-GitlabMergeRequest` alias.

## PARAMETERS

### -MergeRequestId

The internal ID of the merge request to review.

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

## OUTPUTS

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [Get-GitlabMergeRequest](Get-GitlabMergeRequest.md)
- [Approve-GitlabMergeRequest](Approve-GitlabMergeRequest.md)
