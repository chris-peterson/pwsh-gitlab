---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Utilities/Invoke-GitlabApi
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Invoke-GitlabApi
---

# Invoke-GitlabApi

## SYNOPSIS

Makes direct REST API calls to a GitLab instance.

## SYNTAX

### Default

```
Invoke-GitlabApi
    [-HttpMethod] <string> [-Path] <string> [[-Query] <hashtable>]
    [-Body <hashtable>]
    [-MaxPages <uint>]
    [-Api <string>]
    [-SiteUrl <string>]
    [-AccessToken <string>]
    [-ProxyUrl <string>]
    [-OutFile <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Invoke-GitlabApi` cmdlet provides direct access to the GitLab REST API. It handles authentication, pagination, query string serialization, and JSON conversion automatically. This is the core function used by all other GitlabCli cmdlets to communicate with GitLab, and can be used directly for API endpoints not covered by specific cmdlets.

## EXAMPLES

### Example 1: Get current user information

```powershell
Invoke-GitlabApi GET 'user'
```

Retrieves information about the currently authenticated user.

### Example 2: List projects with pagination

```powershell
Invoke-GitlabApi GET 'projects' -Query @{ membership = 'true' } -MaxPages 5
```

Retrieves up to 5 pages of projects where the current user is a member.

### Example 3: Create a new issue

```powershell
Invoke-GitlabApi POST 'projects/123/issues' -Body @{ title = 'New Issue'; description = 'Issue description' }
```

Creates a new issue in project 123.

## PARAMETERS

### -AccessToken

A GitLab personal access token or OAuth token. If not specified, uses the token from the configured GitLab site or from an active impersonation session.

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

### -Api

The API version to use. Defaults to `v4`. Set to an empty string for endpoints that don't include a version prefix.

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

### -Body

A hashtable of data to send in the request body. Automatically converted to JSON for POST, PUT, and PATCH requests.

```yaml
Type: System.Collections.Hashtable
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

### -HttpMethod

The HTTP method to use for the request. Common values are `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Method
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

### -MaxPages

The maximum number of pages to retrieve for paginated results. Defaults to 1. Set to a higher value to automatically follow pagination links.

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

### -OutFile

Path to save the response to a file. When specified, the response is saved as binary data (useful for downloading artifacts or files).

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

### -Path

The API endpoint path, relative to the API base URL. For example, `projects`, `users/1`, or `groups/mygroup/projects`.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProxyUrl

URL of an HTTP proxy server to use for the request. If not specified, uses the proxy configured for the site (if any).

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

### -Query

A hashtable of query string parameters to append to the URL. Values are automatically URL-encoded.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab instance to call. If not specified, uses the default configured GitLab site.

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

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject)

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This cmdlet supports `-WhatIf` for non-GET requests. When using `-WhatIf`, the request parameters are displayed without making the actual API call.

For user impersonation, set `$global:GitlabUserImpersonationSession` with `Username` and `Token` properties.

## RELATED LINKS

- [GitLab REST API Documentation](https://docs.gitlab.com/ee/api/rest/)
- [Get-GitlabVersion](Get-GitlabVersion.md)
- [Invoke-GitlabGraphQL](../GraphQL/Invoke-GitlabGraphQL.md)
