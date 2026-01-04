# Variables

Work with CI/CD variables and expand variable references.

## Overview

CI/CD variables store configuration values and secrets used in pipelines. These utility cmdlets help convert variable formats and resolve variable references in strings.

## Examples

```powershell
# Convert a hashtable to GitLab variable format
@{DEPLOY_ENV='staging'; DEBUG='true'} | ConvertTo-GitlabVariables

# Resolve variables in a string
Resolve-GitlabVariable -String 'Deploy to $DEPLOY_ENV' -Variables @{DEPLOY_ENV='production'}
```

> **Note:** For managing project and group CI/CD variables, see the [Projects](Projects/) and [Groups](Groups/) sections.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [ConvertTo-GitlabVariables](Variables/ConvertTo-GitlabVariables.md) | Converts hashtables to variable format |
| [Resolve-GitlabVariable](Variables/Resolve-GitlabVariable.md) | Expands variable references in strings |
