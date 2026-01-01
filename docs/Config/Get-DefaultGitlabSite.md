---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Config/Get-DefaultGitlabSite
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-DefaultGitlabSite
---

# Get-DefaultGitlabSite

## SYNOPSIS

Gets the default GitLab site configuration.

## SYNTAX

### Default

```
Get-DefaultGitlabSite
```

## ALIASES

## DESCRIPTION

**DEPRECATED**: This cmdlet is deprecated and will be removed in a future release.

Retrieves the default GitLab site from the configuration. If the current local git context matches a configured site, that site is returned. Otherwise, returns the site marked as default.

## EXAMPLES

### Example 1

```powershell
Get-DefaultGitlabSite
```

Returns the default GitLab site configuration.

## PARAMETERS

## INPUTS

## OUTPUTS

### Gitlab.Site

Returns the default GitLab site object containing Url, AccessToken, and IsDefault properties.

### System.Object

See [Gitlab.Site](#gitlabsite).

## NOTES

This cmdlet is deprecated. Use `Get-GitlabConfiguration` instead to access site information.

## RELATED LINKS

- [Get-GitlabConfiguration](Get-GitlabConfiguration.md)
- [Set-DefaultGitlabSite](Set-DefaultGitlabSite.md)
