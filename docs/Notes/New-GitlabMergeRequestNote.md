---
document type: cmdlet
external help file: Notes-Help.xml
HelpUri: ''
Locale: en-US
Module Name: Notes
ms.date: 09/23/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabMergeRequestNote
---

# New-GitlabMergeRequestNote

## SYNOPSIS

Creates a new note (comment) on a GitLab merge request.

## SYNTAX

### __AllParameterSets

```
New-GitlabMergeRequestNote [-Note] <string> [-ProjectId <string>] [-MergeRequestId <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Add-GitlabMergeRequestNote`


## DESCRIPTION

The `New-GitlabMergeRequestNote` cmdlet creates a new note (comment) on a specific merge request in a GitLab project. This cmdlet supports the ShouldProcess pattern, allowing you to use -WhatIf and -Confirm parameters. An alias `Add-GitlabMergeRequestNote` is also available.

## EXAMPLES

### Example 1: Add a comment to a merge request

```powershell
New-GitlabMergeRequestNote -MergeRequestId 42 -Note 'LGTM, thanks!'
```

Adds a comment to merge request !42 in the current project context.

### Example 2: Add a comment to a merge request in a specific project

```powershell
New-GitlabMergeRequestNote -ProjectId 'mygroup/myproject' -MergeRequestId 15 -Note 'Please rebase against main.'
```

Adds a comment to merge request !15 in the specified project.

### Example 3: Use the alias and preview changes

```powershell
Add-GitlabMergeRequestNote -MergeRequestId 42 -Note 'Merging now' -WhatIf
```

Previews what would happen without actually creating the note.

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

The internal ID of the merge request to add the note to. This is the merge request number shown in the GitLab UI (e.g., !42).

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

The body text of the note to create. Supports GitLab Flavored Markdown.

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

Returns the newly created note object containing the note body, author, creation date, and other metadata.

## NOTES

## RELATED LINKS

- [GitLab Notes API - Create a merge request note](https://docs.gitlab.com/ee/api/notes.html#create-a-merge-request-note)
- [Get-GitlabMergeRequestNote](Get-GitlabMergeRequestNote.md)
