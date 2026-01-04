# Todos

Manage your GitLab to-do list.

## Overview

Todos are action items created when you're mentioned, assigned to issues/MRs, or have other actionable items. These cmdlets help you view and manage your pending todos.

## Examples

```powershell
# Get pending to-dos
Get-GitlabTodo

# Get all to-dos across all pages
Get-GitlabTodo -All

# Mark all to-dos as done
Clear-GitlabTodo
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Clear-GitlabTodo](Todos/Clear-GitlabTodo.md) | Marks todos as done |
| [Get-GitlabTodo](Todos/Get-GitlabTodo.md) | Retrieves pending todos |
