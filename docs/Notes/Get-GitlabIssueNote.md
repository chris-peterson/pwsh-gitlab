---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Notes/Get-GitlabIssueNote
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabIssueNote
---

# Get-GitlabIssueNote

## SYNOPSIS

Retrieves notes (comments) from a GitLab issue.

## SYNTAX

### Default

```
Get-GitlabIssueNote
    [-IssueId] <string> [-ProjectId <string>]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-GitlabIssueNote` cmdlet retrieves all notes (comments) associated with a specific issue in a GitLab project. Notes include user comments, system messages, and activity logs on the issue.

## EXAMPLES

### Example 1: Get notes for an issue in the current project

```powershell
Get-GitlabIssueNote -IssueId 42
```

Retrieves all notes from issue #42 in the current project context.

### Example 2: Get notes for an issue in a specific project

```powershell
Get-GitlabIssueNote -ProjectId 'mygroup/myproject' -IssueId 15
```

Retrieves all notes from issue #15 in the specified project.

### Example 3: Pipeline from Get-GitlabIssue

```powershell
Get-GitlabIssue -IssueId 42 | Get-GitlabIssueNote
```

Pipes an issue object to retrieve its associated notes.

## PARAMETERS

### -IssueId

The internal ID of the issue to retrieve notes from. This is the issue number shown in the GitLab UI (e.g., #42).

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository if not specified.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a project ID and issue ID to this cmdlet.

## OUTPUTS

### Gitlab.Note

Returns one or more note objects containing the note body, author, creation date, and other metadata.

### System.Object

See [Gitlab.Note](#gitlabnote)

## NOTES

## RELATED LINKS

- [GitLab Notes API - List project issue notes](https://docs.gitlab.com/ee/api/notes.html#list-project-issue-notes)
- [New-GitlabIssueNote](New-GitlabIssueNote.md)
