# Git

Local git context utilities for working with GitLab repositories.

## Overview

These utilities help bridge your local git environment with GitLab. Many GitlabCli cmdlets automatically infer the project from your current directory using these underlying functions.

## Examples

```powershell
# Get the GitLab context from your current directory
Get-LocalGitContext

# This returns information like:
# - Remote URL
# - Project path
# - Current branch
# - GitLab site URL
```

> **Tip:** When you run cmdlets like `Get-GitlabProject` without specifying a project, they use `Get-LocalGitContext` to determine which project you're working with.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-LocalGitContext](Git/Get-LocalGitContext.md) | Gets GitLab context from local git repo |
