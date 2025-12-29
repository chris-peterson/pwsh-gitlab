---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Utilities/Open-InBrowser.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Open-InBrowser
---

# Open-InBrowser

## SYNOPSIS

Opens a URL or GitLab object in the default web browser.

## SYNTAX

### __AllParameterSets

```
Open-InBrowser [-InputObject] <Object> [<CommonParameters>]
```

## ALIASES

- `go`


## DESCRIPTION

The `Open-InBrowser` cmdlet opens URLs in your default web browser. It accepts a string URL directly, or any GitLab object that has a `Url` or `WebUrl` property. This provides a convenient way to quickly navigate to GitLab resources from the command line.

## EXAMPLES

### Example 1: Open a project in the browser

```powershell
Get-GitlabProject 'mygroup/myproject' | Open-InBrowser
```

Opens the project's web page in the default browser.

### Example 2: Open a merge request using the alias

```powershell
Get-GitlabMergeRequest -ProjectId 'mygroup/myproject' -MergeRequestId 42 | go
```

Opens the merge request page using the `go` alias.

### Example 3: Open a URL string directly

```powershell
'https://gitlab.com/explore' | Open-InBrowser
```

Opens the specified URL in the default browser.

## PARAMETERS

### -InputObject

The URL or object to open. Can be a string URL, or any object with a `Url` or `WebUrl` property (such as GitLab projects, merge requests, issues, etc.).

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
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

### System.Object

Accepts any object from the pipeline.

## OUTPUTS

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

The `go` alias provides a quick shorthand for this cmdlet. Most GitLab objects returned by this module include a `WebUrl` property that works with this cmdlet.

## RELATED LINKS

- [Get-GitlabProject](../Projects/Get-GitlabProject.md)
- [Get-GitlabMergeRequest](../MergeRequests/Get-GitlabMergeRequest.md)
