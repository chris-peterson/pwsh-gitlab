---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/GraphQL/Invoke-GitlabGraphQL
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Invoke-GitlabGraphQL
---

# Invoke-GitlabGraphQL

## SYNOPSIS

Executes a GraphQL query against the GitLab API.

## SYNTAX

### __AllParameterSets

```
Invoke-GitlabGraphQL [-Query] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Invoke-GitlabGraphQL` cmdlet sends a GraphQL query to the GitLab GraphQL API endpoint and returns the results. GraphQL provides a flexible and efficient way to query GitLab data, allowing you to request exactly the fields you need in a single request. This is particularly useful for complex queries that would otherwise require multiple REST API calls.

## EXAMPLES

### Example 1: Query current user information

```powershell
Invoke-GitlabGraphQL -Query '{ currentUser { username name email } }'
```

Retrieves the username, name, and email of the currently authenticated user.

### Example 2: Query project details

```powershell
Invoke-GitlabGraphQL -Query '{ project(fullPath: "mygroup/myproject") { name description webUrl } }'
```

Retrieves the name, description, and web URL for a specific project.

### Example 3: Query with a different GitLab site

```powershell
Invoke-GitlabGraphQL -Query '{ currentUser { username } }' -SiteUrl 'https://gitlab.example.com'
```

Executes the GraphQL query against a specific GitLab instance.

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

### -Query

The GraphQL query string to execute against the GitLab API. This should be a valid GraphQL query following the GitLab GraphQL schema. You can explore available queries and types using the GitLab GraphQL Explorer.

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

### -SiteUrl

Specifies the URL of the GitLab instance to query. If not specified, the default configured GitLab site is used.

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

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject).

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

The GitLab GraphQL API provides a more flexible alternative to the REST API. Use the GitLab GraphQL Explorer at your GitLab instance (e.g., https://gitlab.com/-/graphql-explorer) to discover available queries and test them interactively.

## RELATED LINKS

- [GitLab GraphQL API](https://docs.gitlab.com/ee/api/graphql/)
- [GitLab GraphQL Reference](https://docs.gitlab.com/ee/api/graphql/reference/)
- [Getting started with GitLab GraphQL API](https://docs.gitlab.com/ee/api/graphql/getting_started.html)
