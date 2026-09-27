---
document type: cmdlet
external help file: Notes-Help.xml
HelpUri: ''
Locale: en-US
Module Name: Notes
ms.date: 09/24/2026
PlatyPS schema version: 2024-05-01
title: Update-GitlabMergeRequestNote
---

# Update-GitlabMergeRequestNote

## SYNOPSIS

Updates the body text of an existing note (comment) on a GitLab merge request.

## SYNTAX

### __AllParameterSets

```
Update-GitlabMergeRequestNote [-Note] <string> -NoteId <string> [-ProjectId <string>]
 [-MergeRequestId <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
```

## ALIASES

## DESCRIPTION

The `Update-GitlabMergeRequestNote` cmdlet replaces the body text of an existing note on a specific merge request in a GitLab project. This cmdlet supports the ShouldProcess pattern, allowing you to use -WhatIf and -Confirm parameters.

## EXAMPLES

### Example 1: Update a comment on a merge request

```powershell
Update-GitlabMergeRequestNote -MergeRequestId 42 -NoteId 100 -Note 'Addressed in the latest commit.'
```

Replaces the body of note 100 on merge request !42 in the current project context.

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

### -MergeRequestId

The internal ID of the merge request the note belongs to. This is the merge request number shown in the GitLab UI (e.g., !42).

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

You can pipe a project ID and merge request ID to this cmdlet.

## OUTPUTS

### Gitlab.Note

Returns the updated note object containing the note body, author, creation date, and other metadata.

## NOTES

## RELATED LINKS

- [GitLab Notes API - Update a merge request note](https://docs.gitlab.com/ee/api/notes.html#update-a-merge-request-note)
- [Get-GitlabMergeRequestNote](../Notes/Get-GitlabMergeRequestNote.md)
- [Remove-GitlabMergeRequestNote](../Notes/Remove-GitlabMergeRequestNote.md)
