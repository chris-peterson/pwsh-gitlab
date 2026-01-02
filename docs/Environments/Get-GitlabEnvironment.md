---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Environments/Get-GitlabEnvironment
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabEnvironment
---

# Get-GitlabEnvironment

## SYNOPSIS

Gets environments for a GitLab project.

## SYNTAX

### List (Default)

```
Get-GitlabEnvironment [-ProjectId <string>] [-State <string>] [-Enrich] [-MaxPages <int>]
 [-SiteUrl <string>] [<CommonParameters>]
```

### Name

```
Get-GitlabEnvironment [-ProjectId <string>] [-Name <string>] [-State <string>] [-Enrich]
 [-MaxPages <int>] [-SiteUrl <string>] [<CommonParameters>]
```

### Search

```
Get-GitlabEnvironment -Search <string> [-ProjectId <string>] [-State <string>] [-Enrich]
 [-MaxPages <int>] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

- `envs`


## DESCRIPTION

Retrieves environments from a GitLab project. You can list all environments, get a specific environment by name or ID, or search for environments. By default, only available environments are returned, but you can filter by state (available, stopping, or stopped).

## EXAMPLES

### Example 1

```powershell
Get-GitlabEnvironment -ProjectId "mygroup/myproject"
```

Gets all available environments for the specified project.

### Example 2

```powershell
Get-GitlabEnvironment -Name "production"
```

Gets the environment named "production" from the current project (determined by local git context).

### Example 3

```powershell
Get-GitlabEnvironment -Search "review" -State "stopped"
```

Searches for stopped environments containing "review" in their name.

### Example 4

```powershell
Get-GitlabEnvironment -Enrich
```

Gets all environments with enriched details including most recent deployment information.

## PARAMETERS

### -Enrich

When specified, retrieves additional details for each environment by making individual API calls. This includes information like the most recent deployment that is not available in the batch listing.

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

The maximum number of result pages to retrieve. Defaults to 1. Increase this value to retrieve more environments when the project has many environments.

```yaml
Type: System.Int32
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

### -Name

The name or numeric ID of the environment to retrieve. When a numeric value is provided, it is treated as the environment ID and retrieves that specific environment directly.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EnvironmentId
- Id
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository (detected via local git context).

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

### -Search

A search term to filter environments by name. Returns environments whose names contain the search string.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Search
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

The URL of the GitLab site to connect to. If not specified, uses the default configured GitLab site.

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

### -State

Filters environments by their state. Valid values are 'available', 'stopping', or 'stopped'. Defaults to 'available'.

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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Environment

Returns one or more GitLab environment objects containing properties such as Id, Name, Slug, ExternalUrl, and State.

### System.Object

HIDE_ME

## NOTES

This cmdlet has an alias: `envs`

## RELATED LINKS

- [GitLab Environments API - List environments](https://docs.gitlab.com/ee/api/environments.html#list-environments)
- [GitLab Environments API - Get a specific environment](https://docs.gitlab.com/ee/api/environments.html#get-a-specific-environment)
- [Stop-GitlabEnvironment](Stop-GitlabEnvironment.md)
- [Remove-GitlabEnvironment](Remove-GitlabEnvironment.md)
