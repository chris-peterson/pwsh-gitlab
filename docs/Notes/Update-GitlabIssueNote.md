---
document type: cmdlet
external help file: Notes-Help.xml
HelpUri: ''
Locale: en-US
Module Name: Notes
ms.date: 09/24/2026
PlatyPS schema version: 2024-05-01
title: Update-GitlabIssueNote
---

# Update-GitlabIssueNote

## SYNOPSIS

Updates the body text of an existing note (comment) on a GitLab issue.

## SYNTAX

### __AllParameterSets

```
Update-GitlabIssueNote [-Note] <string> -NoteId <string> [-ProjectId <string>] [-IssueId <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm]
```

## ALIASES

## DESCRIPTION

The `Update-GitlabIssueNote` cmdlet replaces the body text of an existing note on a specific issue in a GitLab project. This cmdlet supports the ShouldProcess pattern, allowing you to use -WhatIf and -Confirm parameters.

## EXAMPLES

### Example 1: Update a comment on an issue

```powershell
Update-GitlabIssueNote -IssueId 42 -NoteId 100 -Note 'Fixed in the latest release.'
```

Replaces the body of note 100 on issue #42 in the current project context.

### Example 2: Update a comment on an issue in a specific project

```powershell
Update-GitlabIssueNote -ProjectId 'mygroup/myproject' -IssueId 15 -NoteId 200 -Note 'No longer reproducible.'
```

Replaces the body of note 200 on issue #15 in the specified project.

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

### -IssueId

The internal ID of the issue the note belongs to. This is the issue number shown in the GitLab UI (e.g., #42).

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

### -Note

The new body text for the note. Supports GitLab Flavored Markdown.

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

### -NoteId

The ID of the note to update.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
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

You can pipe a project ID and issue ID to this cmdlet.

## OUTPUTS

### Gitlab.Note

Returns the updated note object containing the note body, author, creation date, and other metadata.

## NOTES

## RELATED LINKS

- [GitLab Notes API - Update an issue note](https://docs.gitlab.com/ee/api/notes.html#update-an-issue-note)
- [Get-GitlabIssueNote](Get-GitlabIssueNote.md)
- [Remove-GitlabIssueNote](Remove-GitlabIssueNote.md)
