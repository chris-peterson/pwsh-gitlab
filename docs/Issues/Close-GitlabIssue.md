---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Issues/Close-GitlabIssue
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Close-GitlabIssue
---

# Close-GitlabIssue

## SYNOPSIS

Closes an open GitLab issue.

## SYNTAX

### __AllParameterSets

```
Close-GitlabIssue [-IssueId] <string> [-ProjectId <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Closes an open issue in GitLab. This is a convenience wrapper around Update-GitlabIssue that sets the state event to 'close'.

## EXAMPLES

### Example 1

```powershell
Close-GitlabIssue -IssueId 42
```

Closes issue #42 in the current project.

### Example 2

```powershell
Close-GitlabIssue -ProjectId 'mygroup/myproject' -IssueId 10
```

Closes issue #10 in the specified project.

### Example 3

```powershell
Get-GitlabIssue -State opened | Where-Object { $_.Labels -contains 'wontfix' } | Close-GitlabIssue
```

Closes all open issues with the 'wontfix' label using pipeline input.

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

The internal ID (IID) of the issue to close. This is a required parameter.

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

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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

### Gitlab.Issue

Returns the closed GitLab issue object.

### System.Object

HIDE_ME

## NOTES

This cmdlet is an alias for `Update-GitlabIssue -StateEvent 'close'`.

## RELATED LINKS

- [GitLab Issues API](https://docs.gitlab.com/ee/api/issues.html#edit-issue)
- [Get-GitlabIssue](Get-GitlabIssue.md)
- [Open-GitlabIssue](Open-GitlabIssue.md)
- [Update-GitlabIssue](Update-GitlabIssue.md)
