---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Commits/Get-GitlabCommit
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabCommit
---

# Get-GitlabCommit

## SYNOPSIS

Retrieves commits from a GitLab project repository.

## SYNTAX

### __AllParameterSets

```
Get-GitlabCommit [[-ProjectId] <string>] [[-Before] <string>] [[-After] <string>] [[-Ref] <string>]
 [[-Sha] <string>] [[-MaxPages] <uint>] [[-SiteUrl] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets commits from a GitLab project repository. You can filter commits by date range, branch/ref, or retrieve a specific commit by SHA. By default, returns commits from the first page of results.

## EXAMPLES

### Example 1: Get commits from current project

```powershell
Get-GitlabCommit
```

Retrieves the most recent commits from the current directory's git repository.

### Example 2: Get commits from a specific project

```powershell
Get-GitlabCommit -ProjectId 'mygroup/myproject'
```

Retrieves commits from the specified project.

### Example 3: Get a specific commit by SHA

```powershell
Get-GitlabCommit -Sha 'abc123def456'
```

Retrieves details for a specific commit.

### Example 4: Get commits from a specific branch

```powershell
Get-GitlabCommit -Ref 'develop' -MaxPages 5
```

Retrieves commits from the 'develop' branch, returning up to 5 pages of results.

### Example 5: Get commits within a date range

```powershell
Get-GitlabCommit -After '2024-01-01' -Before '2024-12-31'
```

Retrieves commits made during 2024.

## PARAMETERS

### -After

Filter commits made after this date. Also aliased as 'Since'. The date should be in a format that can be parsed as a date (e.g., '2024-01-01' or '2024-01-01T00:00:00Z').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Since
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Before

Filter commits made before this date. Also aliased as 'Until'. The date should be in a format that can be parsed as a date (e.g., '2024-01-01' or '2024-01-01T00:00:00Z').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Until
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages to retrieve. GitLab returns 20 results per page by default. Defaults to 1 page.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
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

### -Ref

The name of a repository branch, tag, or revision range to filter commits. Also aliased as 'Branch'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Sha

The commit SHA hash to retrieve a specific commit. When specified, returns details for that single commit instead of a list.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
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
  Position: 6
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

### Gitlab.Commit

Returns one or more GitLab commit objects containing commit details such as SHA, author, message, and timestamps.

### System.Object

See [Gitlab.Commit](#gitlabcommit).

## NOTES

This cmdlet uses the GitLab Commits API to retrieve repository commits.

## RELATED LINKS

- [GitLab Commits API - List repository commits](https://docs.gitlab.com/ee/api/commits.html#list-repository-commits)
- [GitLab Commits API - Get a single commit](https://docs.gitlab.com/ee/api/commits.html#get-a-single-commit)
