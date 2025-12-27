---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Snippets/New-GitlabSnippet.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabSnippet
---

# New-GitlabSnippet

## SYNOPSIS

Creates a new GitLab snippet.

## SYNTAX

### SingleFile

```
New-GitlabSnippet [-Title] <string> -FileName <string> -Content <string> [-Description <string>]
 [-Visibility <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### MultipleFiles

```
New-GitlabSnippet [-Title] <string> -Files <hashtable[]> [-Description <string>]
 [-Visibility <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new personal snippet in GitLab. Snippets can contain a single file or multiple files, and can be set to public, private, or internal visibility.

## EXAMPLES

### Example 1: Create a simple snippet with a single file

```powershell
New-GitlabSnippet -Title 'My Script' -FileName 'script.ps1' -Content 'Write-Host "Hello World"'
```

Creates a private snippet with a single PowerShell file.

### Example 2: Create a public snippet with description

```powershell
New-GitlabSnippet -Title 'Config Example' -FileName 'config.json' -Content '{"key": "value"}' -Description 'Sample JSON configuration' -Visibility 'public'
```

Creates a public snippet with a description.

### Example 3: Create a snippet with multiple files

```powershell
$files = @(
    @{ file_path = 'main.ps1'; content = 'Write-Host "Main"' },
    @{ file_path = 'helper.ps1'; content = 'function Get-Help { }' }
)
New-GitlabSnippet -Title 'Multi-file Project' -Files $files
```

Creates a snippet containing multiple files.

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

### -Content

The content of the snippet file. Used with the SingleFile parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SingleFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

A description of the snippet.

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

### -FileName

The name of the snippet file. Used with the SingleFile parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SingleFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Files

An array of hashtables defining multiple files. Each hashtable should contain 'file_path' and 'content' keys.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: MultipleFiles
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured site.

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

### -Title

The title of the snippet.

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

### -Visibility

The visibility level of the snippet: 'public', 'private' (default), or 'internal'.

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

## OUTPUTS

### System.Object

See [Gitlab.Snippet](#gitlabsnippet)

### Gitlab.Snippet

Returns GitLab snippet objects.

## NOTES

## RELATED LINKS

- [GitLab Snippets API](https://docs.gitlab.com/ee/api/snippets.html#create-new-snippet)
- [Get-GitlabSnippet](Get-GitlabSnippet.md)
- [Update-GitlabSnippet](Update-GitlabSnippet.md)
- [Remove-GitlabSnippet](Remove-GitlabSnippet.md)
