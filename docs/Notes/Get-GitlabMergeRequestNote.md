---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Notes/Get-GitlabMergeRequestNote
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabMergeRequestNote
---

# Get-GitlabMergeRequestNote

## SYNOPSIS

Retrieves notes (comments) from a GitLab merge request.

## SYNTAX

### __AllParameterSets

```
Get-GitlabMergeRequestNote [-MergeRequestId] <string> [[-NoteId] <string>] [-ProjectId <string>]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-GitlabMergeRequestNote` cmdlet retrieves notes (comments) from a specific merge request in a GitLab project. You can retrieve all notes or a single note by specifying the NoteId parameter.

## EXAMPLES

### Example 1: Get all notes from a merge request

```powershell
Get-GitlabMergeRequestNote -MergeRequestId 123
```

Retrieves all notes from merge request !123 in the current project context.

### Example 2: Get a specific note from a merge request

```powershell
Get-GitlabMergeRequestNote -MergeRequestId 123 -NoteId 456
```

Retrieves the specific note with ID 456 from merge request !123.

### Example 3: Get notes from a merge request in a specific project

```powershell
Get-GitlabMergeRequestNote -ProjectId 'mygroup/myproject' -MergeRequestId 50
```

Retrieves all notes from merge request !50 in the specified project.

## PARAMETERS

### -MergeRequestId

The internal ID of the merge request to retrieve notes from. This is the merge request IID shown in the GitLab UI (e.g., !123).

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

### -NoteId

The ID of a specific note to retrieve. If not specified, all notes for the merge request are returned.

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
  ValueFromPipelineByPropertyName: false
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

You can pipe a project ID and merge request ID to this cmdlet.

## OUTPUTS

### Gitlab.Note

Returns one or more note objects containing the note body, author, creation date, and other metadata.

### System.Object

See [Gitlab.Note](#gitlabnote)

## NOTES

## RELATED LINKS

- [GitLab Notes API - List all merge request notes](https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes)
- [GitLab Notes API - Get single merge request note](https://docs.gitlab.com/api/notes/#get-single-issue-note)
