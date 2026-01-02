---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Runners/Get-GitlabRunner
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabRunner
---

# Get-GitlabRunner

## SYNOPSIS

Gets GitLab runners.

## SYNTAX

### ListAll (Default)

```
Get-GitlabRunner [-Type <string>] [-Status <string>] [-Tags <string[]>] [-FetchDetails]
 [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### RunnerId

```
Get-GitlabRunner [-RunnerId] <string> [-FetchDetails] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves GitLab runners. Can list all runners with optional filtering by type, status, or tags, or get detailed information about a specific runner by ID.

## EXAMPLES

### Example 1: List all runners

```powershell
Get-GitlabRunner
```

Retrieves all runners visible to the current user.

### Example 2: Get a specific runner by ID

```powershell
Get-GitlabRunner -RunnerId 123
```

Retrieves detailed information about runner with ID 123.

### Example 3: List online runners with specific tags

```powershell
Get-GitlabRunner -Status 'online' -Tags 'docker', 'linux' -FetchDetails
```

Retrieves all online runners with docker and linux tags, including detailed information.

## PARAMETERS

### -All

If specified, retrieves all runners by fetching all pages of results.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -FetchDetails

If specified, fetches detailed information for each runner. This may be slower for large numbers of runners.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -MaxPages

The maximum number of pages of results to retrieve.

```yaml
Type: System.UInt32
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

### -RunnerId

The ID of the runner to retrieve details for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: RunnerId
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured GitLab site.

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

### -Status

Filter runners by status. Valid values: 'active', 'paused', 'online', 'offline'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ListAll
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tags

Filter runners by tags. Only runners with all specified tags are returned.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ListAll
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

Filter runners by type. Valid values: 'instance_type', 'group_type', 'project_type'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ListAll
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

### Gitlab.Runner

Returns GitLab runner objects containing runner information including ID, description, status, tags, and configuration.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Runners API](https://docs.gitlab.com/ee/api/runners.html)
- [Update-GitlabRunner](Update-GitlabRunner.md)
- [Remove-GitlabRunner](Remove-GitlabRunner.md)
