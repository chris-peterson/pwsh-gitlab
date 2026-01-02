---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Get-GitlabMergeRequest
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabMergeRequest
---

# Get-GitlabMergeRequest

## SYNOPSIS

Retrieves merge requests from GitLab.

## SYNTAX

### ByProjectId (Default)

```
Get-GitlabMergeRequest [[-MergeRequestId] <string>] [-ProjectId <string>] [-State <string>]
 [-CreatedAfter <string>] [-CreatedBefore <string>] [-IsDraft <bool>] [-SourceBranch <string>]
 [-IncludeChangeSummary] [-IncludeDiffs] [-IncludeApprovals] [-Scope <string>] [-MaxPages <uint>]
 [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### ByGroupId

```
Get-GitlabMergeRequest [-GroupId] <string> [-State <string>] [-CreatedAfter <string>]
 [-CreatedBefore <string>] [-IsDraft <bool>] [-SourceBranch <string>] [-IncludeChangeSummary]
 [-IncludeDiffs] [-IncludeApprovals] [-Scope <string>] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

### ByUrl

```
Get-GitlabMergeRequest [-Url] <string> [-State <string>] [-CreatedAfter <string>]
 [-CreatedBefore <string>] [-IsDraft <bool>] [-SourceBranch <string>] [-IncludeChangeSummary]
 [-IncludeDiffs] [-IncludeApprovals] [-Scope <string>] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

### ByUser

```
Get-GitlabMergeRequest [-State <string>] [-CreatedAfter <string>] [-CreatedBefore <string>]
 [-IsDraft <bool>] [-SourceBranch <string>] [-IncludeChangeSummary] [-IncludeDiffs]
 [-IncludeApprovals] [-Username <string>] [-Role <string>] [-Scope <string>] [-MaxPages <uint>]
 [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### Mine

```
Get-GitlabMergeRequest [-State <string>] [-CreatedAfter <string>] [-CreatedBefore <string>]
 [-IsDraft <bool>] [-SourceBranch <string>] [-IncludeChangeSummary] [-IncludeDiffs]
 [-IncludeApprovals] [-Mine] [-Scope <string>] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

- `mrs`


## DESCRIPTION

Retrieves merge requests from GitLab at the project, group, or instance level. Supports filtering by state, date range, draft status, source branch, and user. Can optionally include change summary, diffs, and approval information. Results are sorted by project path.

## EXAMPLES

### Example 1: Get merge requests for current project

```powershell
Get-GitlabMergeRequest
```

Gets all merge requests from the project in the current directory.

### Example 2: Get open merge requests for a project

```powershell
Get-GitlabMergeRequest -ProjectId 'mygroup/myproject' -State opened
```

Gets all open merge requests from the specified project.

### Example 3: Get merge requests authored by current user

```powershell
Get-GitlabMergeRequest -Mine
```

Gets all merge requests authored by the current user across all accessible projects.

### Example 4: Get merge requests with approvals

```powershell
Get-GitlabMergeRequest -ProjectId 'mygroup/myproject' -MergeRequestId 123 -IncludeApprovals
```

Gets a specific merge request including its approval information.

### Example 5: Get group merge requests by date range

```powershell
Get-GitlabMergeRequest -GroupId 'mygroup' -CreatedAfter '2024-01-01' -State merged
```

Gets all merged merge requests in a group created after January 1, 2024.

## PARAMETERS

### -All

Retrieve all results by automatically paginating through all available pages.

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

### -CreatedAfter

Filter merge requests created after this date. Use ISO 8601 format (YYYY-MM-DD).

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

### -CreatedBefore

Filter merge requests created before this date. Use ISO 8601 format (YYYY-MM-DD).

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

### -GroupId

The ID or URL-encoded path of the group to list merge requests for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByGroupId
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludeApprovals

Include approval information with each merge request. Alias: Approvals.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Approvals
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

### -IncludeChangeSummary

Include a summary of changes (files changed, additions, deletions) with each merge request. Alias: ChangeSummary.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- ChangeSummary
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

### -IncludeDiffs

Include the full diff information for each merge request. Alias: Diffs.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Diffs
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

### -IsDraft

Filter by draft status. Use $true to show only draft merge requests, $false to exclude drafts.

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

### -MaxPages

The maximum number of pages to retrieve. GitLab returns 20 results per page by default.

```yaml
Type: System.UInt32
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

The internal ID of a specific merge request to retrieve. Alias: Id.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: ByProjectId
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Mine

Filter to show only merge requests authored by the current user.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Mine
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
- Name: ByProjectId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Role

The role of the user specified by -Username. Valid values are 'author' (default) or 'reviewer'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByUser
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Scope

The scope of merge requests to return. Valid values: 'created_by_me', 'assigned_to_me', 'reviews_for_me', 'all' (default).

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

### -SourceBranch

Filter by source branch name. Use '.' to use the current local git branch. Alias: Branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

### -State

Filter by merge request state. Valid values: 'all' (default), 'opened', 'closed', 'locked', 'merged'.

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

### -Url

The full URL of a merge request to retrieve. Extracts project and merge request ID from the URL.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByUrl
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Username

Filter merge requests by a specific user. Use with -Role to specify whether to filter by author or reviewer.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByUser
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

### Gitlab.MergeRequest

Returns merge request objects containing details such as title, state, source/target branches, author, and web URL.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Merge Requests API](https://docs.gitlab.com/ee/api/merge_requests.html)
