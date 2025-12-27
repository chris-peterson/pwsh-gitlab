---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Keys/Get-GitlabKey.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabKey
---

# Get-GitlabKey

## SYNOPSIS

Gets an SSH key by ID or fingerprint.

## SYNTAX

### ById (Default)

```
Get-GitlabKey -Id <string> [-SiteUrl <string>] [<CommonParameters>]
```

### ByFingerprint

```
Get-GitlabKey -Fingerprint <string> [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves SSH key information from GitLab by specifying either the key ID or the key fingerprint. This cmdlet is useful for looking up SSH keys and identifying which user owns a particular key. Requires administrator access.

## EXAMPLES

### Example 1

```powershell
Get-GitlabKey -Id 1
```

Gets the SSH key with ID 1.

### Example 2

```powershell
Get-GitlabKey -Fingerprint 'SHA256:ABC123xyz...'
```

Gets the SSH key matching the specified SHA256 fingerprint.

### Example 3

```powershell
Get-GitlabKey -Fingerprint 'MD5:ab:cd:ef:12:34:56:78:90:ab:cd:ef:12:34:56:78:90'
```

Gets the SSH key matching the specified MD5 fingerprint.

## PARAMETERS

### -Fingerprint

The fingerprint of the SSH key to retrieve. Supports both MD5 and SHA256 fingerprint formats.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByFingerprint
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The unique identifier of the SSH key to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Gitlab.SSHKey

Returns an SSH key object containing the key details including the key ID, title, key value, and the user who owns the key.

### System.Object

See [Gitlab.SSHKey](#gitlabsshkey)

## NOTES

## RELATED LINKS

- [GitLab Keys API](https://docs.gitlab.com/ee/api/keys.html)
