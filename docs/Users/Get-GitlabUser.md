---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Users/Get-GitlabUser.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabUser
---

# Get-GitlabUser

## SYNOPSIS

Retrieves GitLab users.

## SYNTAX

### Filter (Default)

```
Get-GitlabUser [-Active] [-External] [-Blocked] [-ExcludeActive] [-ExcludeExternal]
 [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### Id

```
Get-GitlabUser [-UserId] <string> [-MaxPages <uint>] [-All] [-SiteUrl <string>] [<CommonParameters>]
```

### Me

```
Get-GitlabUser [-MaxPages <uint>] [-All] [-Me] [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets GitLab users from the configured GitLab instance. You can retrieve a specific user by ID, username, or email address, get the currently authenticated user, or list users with various filters such as active, blocked, or external status.

## EXAMPLES

### Example 1: Get a user by username

```powershell
Get-GitlabUser -UserId "john.doe"
```

Retrieves the user with username "john.doe".

### Example 2: Get the current user

```powershell
Get-GitlabUser -Me
```

Retrieves the currently authenticated user.

### Example 3: Get all active users

```powershell
Get-GitlabUser -Active -All
```

Retrieves all active users in the GitLab instance.

## PARAMETERS

### -Active

Filters to only return active users.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -All

Retrieves all users by fetching all pages of results.

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

### -Blocked

Filters to only return blocked users.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExcludeActive

Excludes active users from the results.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExcludeExternal

Excludes external users from the results.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -External

Filters to only return external users.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
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

Specifies the maximum number of pages of results to retrieve. Default is 1.

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

### -Me

Retrieves the currently authenticated user.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Me
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

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

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

### -UserId

Specifies the user to retrieve. Accepts a numeric ID, username, or email address.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EmailAddress
- Username
- Id
ParameterSets:
- Name: Id
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

Accepts UserId from pipeline by property name.

## OUTPUTS

### Gitlab.User

Returns one or more GitLab user objects containing properties such as Id, Username, Name, Email, State, and more.

### System.Object

See [Gitlab.User](#gitlabuser)

## NOTES

## RELATED LINKS

- [GitLab Users API](https://docs.gitlab.com/ee/api/users.html)
- [Block-GitlabUser](Block-GitlabUser.md)
- [Unblock-GitlabUser](Unblock-GitlabUser.md)
- [Get-GitlabCurrentUser](Get-GitlabCurrentUser.md)
