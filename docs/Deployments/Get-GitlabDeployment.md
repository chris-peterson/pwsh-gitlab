---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Deployments/Get-GitlabDeployment
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabDeployment
---

# Get-GitlabDeployment

## SYNOPSIS

Gets deployments for a GitLab project.

## SYNTAX

### Query (Default)

```
Get-GitlabDeployment [-ProjectId <string>] [-EnvironmentName <string>] [-Status <string>] [-Latest]
 [-UpdatedBefore <string>] [-UpdatedAfter <string>] [-MaxPages <int>] [-Select <string>]
 [-SiteUrl <string>] [<CommonParameters>]
```

### ById

```
Get-GitlabDeployment -DeploymentId <string> [-ProjectId <string>] [-Select <string>]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

- `deploys`


## DESCRIPTION

Retrieves deployment information for a GitLab project. Deployments can be queried by environment name, status, or retrieved by a specific deployment ID. By default, returns successful deployments sorted in descending order.

## EXAMPLES

### Example 1: Get successful deployments for the current project

```powershell
Get-GitlabDeployment
```

Gets all successful deployments for the project in the current directory.

### Example 2: Get deployments for a specific environment

```powershell
Get-GitlabDeployment -ProjectId 'mygroup/myproject' -EnvironmentName 'production'
```

Gets successful deployments for the production environment.

### Example 3: Get the latest deployment

```powershell
Get-GitlabDeployment -EnvironmentName 'staging' -Latest
```

Gets only the most recent deployment to the staging environment.

### Example 4: Get a specific deployment by ID

```powershell
Get-GitlabDeployment -DeploymentId 123
```

Gets the deployment with ID 123.

### Example 5: Get failed deployments

```powershell
Get-GitlabDeployment -Status 'failed' -MaxPages 5
```

Gets failed deployments across up to 5 pages of results.

## PARAMETERS

### -DeploymentId

The ID of a specific deployment to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EnvironmentName

The name of the environment to filter deployments by (e.g., 'production', 'staging').

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Latest

When specified, returns only the most recent deployment matching the query criteria.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
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

The maximum number of pages of results to return. Defaults to 1.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
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

The ID or URL-encoded path of the project. Defaults to the project in the current directory.

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

### -Select

Specifies which properties to include in the output. Use this to filter the returned object properties.

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

### -SiteUrl

The URL of the GitLab instance. Defaults to the configured default site.

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

The status of deployments to return. Valid values are 'created', 'running', 'success', 'failed', 'canceled', or 'all'. Defaults to 'success'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UpdatedAfter

Return deployments updated after the specified date/time. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UpdatedBefore

Return deployments updated before the specified date/time. Accepts any valid [`datetime`](https://learn.microsoft.com/en-us/dotnet/api/system.datetime) value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
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

You can pipe a project ID or environment name to this cmdlet.

## OUTPUTS

### Gitlab.Deployment

Returns GitLab deployment objects containing deployment details such as ID, environment, status, ref, SHA, and timestamps.

### System.Object

HIDE_ME

## NOTES

This cmdlet wraps the GitLab Deployments API.

## RELATED LINKS

- [GitLab Deployments API](https://docs.gitlab.com/ee/api/deployments.html)
- [Get-GitlabEnvironment](../Environments/Get-GitlabEnvironment.md)
- [Get-GitlabProject](../Projects/Get-GitlabProject.md)
