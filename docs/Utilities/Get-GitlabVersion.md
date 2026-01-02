---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Utilities/Get-GitlabVersion
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabVersion
---

# Get-GitlabVersion

## SYNOPSIS

Gets the version information of a GitLab instance.

## SYNTAX

### __AllParameterSets

```
Get-GitlabVersion [[-Select] <string>] [[-SiteUrl] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-GitlabVersion` cmdlet retrieves version information from a GitLab instance. By default, it returns just the version number, but you can use the `-Select` parameter to retrieve additional information like the revision.

## EXAMPLES

### Example 1: Get the GitLab version

```powershell
Get-GitlabVersion
```

Returns the version number of the default GitLab instance (e.g., `16.7.0`).

### Example 2: Get all version information

```powershell
Get-GitlabVersion -Select '*'
```

Returns the complete version object including version number and revision.

### Example 3: Get version from a specific GitLab site

```powershell
Get-GitlabVersion -SiteUrl 'https://gitlab.example.com'
```

Returns the version of the specified GitLab instance.

## PARAMETERS

### -Select

Specifies which properties to return. Defaults to `Version` to return just the version string. Use `*` to return all properties including the revision.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab instance to query. If not specified, uses the default configured GitLab site.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

When using the default `-Select 'Version'`, returns the version string (e.g., `16.7.0`).

### GitLab.Version

When using `-Select '*'`, returns an object with `Version` and `Revision` properties.

### System.Object

HIDE_ME

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This cmdlet calls the GitLab Version API endpoint which does not require authentication in some configurations.

## RELATED LINKS

- [GitLab Version API](https://docs.gitlab.com/ee/api/version.html)
- [Invoke-GitlabApi](Invoke-GitlabApi.md)
