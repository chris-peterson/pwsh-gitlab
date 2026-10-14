---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ServiceAccounts/Set-GitlabServiceAccount
Locale: en-US
Module Name: GitlabCli
ms.date: 10/14/2026
PlatyPS schema version: 2024-05-01
title: Set-GitlabServiceAccount
---

# Set-GitlabServiceAccount

## SYNOPSIS

Creates a group service account, or returns the one with that username.

## SYNTAX

### __AllParameterSets

```
Set-GitlabServiceAccount [-GroupId] <string> [-Username] <string> [[-Name] <string>]
 [[-Email] <string>] [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Looks up the group's service account by username and returns it. If no account has that username, creates one. If one exists but `-Name` or `-Email` differs, updates those fields. An account that already matches is returned without a request, so the cmdlet is safe to run repeatedly.

The returned account carries `GroupId`, so it can be piped to `Use-GitlabToken`, `New-GitlabServiceAccountPersonalAccessToken`, or `Set-GitlabProjectMember`.

## EXAMPLES

### Example 1: Ensure a service account exists and is a project maintainer

```powershell
Set-GitlabServiceAccount -GroupId 'my-group' -Username 'deploy-bot' -Name 'deploy bot' |
    Set-GitlabProjectMember -ProjectId 'my-group/my-project' -AccessLevel maintainer
```

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

### -Email

The account's email. When omitted, GitLab generates one for a new account and an existing account's email is left as is.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupId

The ID or path of the top-level group that owns the service account.

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

### -Name

The account's display name. When omitted, an existing account's name is left as is.

```yaml
Type: System.String
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

The URL of the GitLab instance. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Username

The service account's username, used to find an existing account. GitLab reserves usernames starting with `duo-`, `duo_`, `ai-`, or `ai_` for its AI entities, so the cmdlet rejects them before sending a request, including under `-WhatIf`.

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

### Gitlab.ServiceAccount

The existing, created, or updated account, with `GroupId` set.

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/api/service_accounts/)
- [Get-GitlabServiceAccount](Get-GitlabServiceAccount.md)
- [Use-GitlabToken](../Users/Use-GitlabToken.md)
