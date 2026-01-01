---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Merge-GitlabMergeRequest
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Merge-GitlabMergeRequest
---

# Merge-GitlabMergeRequest

## SYNOPSIS

Merges a GitLab merge request.

## SYNTAX

### Default

```
Merge-GitlabMergeRequest
    [[-ProjectId] <string>]
    [-MergeRequestId] <string> [-MergeCommitMessage <string>]
    [-SquashCommitMessage <string>]
    [-ConfirmSha <string>]
    [-Squash]
    [-KeepSourceBranch]
    [-MergeWhenPipelineSucceeds]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Merges an accepted merge request into its target branch. Supports options for squashing commits, keeping the source branch, setting custom commit messages, and merge when pipeline succeeds. By default, the source branch is deleted after merge.

## EXAMPLES

### Example 1: Merge a merge request

```powershell
Merge-GitlabMergeRequest -MergeRequestId 123
```

Merges merge request #123 in the current project and deletes the source branch.

### Example 2: Squash and merge

```powershell
Merge-GitlabMergeRequest -MergeRequestId 123 -Squash -SquashCommitMessage 'feat: Add new feature'
```

Squashes all commits and merges with a custom commit message.

### Example 3: Merge when pipeline succeeds

```powershell
Merge-GitlabMergeRequest -ProjectId 'mygroup/myproject' -MergeRequestId 123 -MergeWhenPipelineSucceeds
```

Sets the merge request to automatically merge when the pipeline succeeds.

### Example 4: Keep source branch

```powershell
Merge-GitlabMergeRequest -MergeRequestId 123 -KeepSourceBranch
```

Merges the request but keeps the source branch instead of deleting it.

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

### -ConfirmSha

If present, the merge will only happen if the head SHA of the source branch matches this value. Prevents race conditions.

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

### -KeepSourceBranch

If specified, the source branch will not be deleted after the merge. By default, the source branch is removed.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -MergeCommitMessage

Custom merge commit message to use instead of the default.

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

### -MergeRequestId

The internal ID of the merge request to merge. Alias: Id.

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

### -MergeWhenPipelineSucceeds

If specified, sets the merge request to automatically merge when the pipeline succeeds.

```yaml
Type: System.Management.Automation.SwitchParameter
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

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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

### -Squash

If specified, squashes all commits into a single commit before merging.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -SquashCommitMessage

Custom squash commit message to use when squashing commits.

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

You can pipe a merge request object to this cmdlet.

## OUTPUTS

### Gitlab.MergeRequest

Returns the merged merge request object.

### System.Object

See [Gitlab.MergeRequest](#gitlabmergerequest)

## NOTES

## RELATED LINKS

- [GitLab Merge Requests API - Merge](https://docs.gitlab.com/ee/api/merge_requests.html#merge-a-merge-request)
