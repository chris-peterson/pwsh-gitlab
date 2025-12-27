---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Groups/Remove-GitlabGroupToGroupShare.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabGroupToGroupShare
---

# Remove-GitlabGroupToGroupShare

## SYNOPSIS

Removes a group-to-group share link.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabGroupToGroupShare [-GroupId] <string> [-GroupShareId] <string> [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes the share link between two groups, revoking the access that was previously granted to the shared group's members.

## EXAMPLES

### Example 1: Remove a group share

```powershell
Remove-GitlabGroupToGroupShare -GroupId "my-group" -GroupShareId "other-team"
```

Removes the share link between "my-group" and "other-team" after confirmation.

### Example 2: Remove without confirmation

```powershell
Remove-GitlabGroupToGroupShare -GroupId "my-group" -GroupShareId "other-team" -Confirm:$false
```

Removes the share link without prompting for confirmation.

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

### -GroupId

The ID or URL-encoded path of the group that was shared.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupShareId

The ID or URL-encoded path of the group that access is being revoked from.

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

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

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

### System.String

The GroupId can be provided via the pipeline by property name.

## OUTPUTS

### None

This cmdlet does not return any output. A confirmation message is displayed upon successful removal.

### System.Object

See [System.Void](#systemvoid).

### System.Void

N/A

## NOTES

This cmdlet has a high confirmation impact. Use -Confirm:$false to skip the confirmation prompt, or -WhatIf to preview the action.

## RELATED LINKS

- [GitLab Groups API - Delete the link that shares a group with another group](https://docs.gitlab.com/ee/api/groups.html#delete-the-link-that-shares-a-group-with-another-group)
