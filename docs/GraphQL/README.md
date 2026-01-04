# GraphQL

Execute GraphQL queries against the GitLab API.

## Overview

GraphQL provides a flexible and efficient way to query GitLab data, allowing you to request exactly the fields you need in a single request. This is particularly useful for complex queries that would otherwise require multiple REST API calls.

## Examples

```powershell
# Query current user information
Invoke-GitlabGraphQL -Query '{ currentUser { username name email } }'

# Query project details
Invoke-GitlabGraphQL -Query '{ project(fullPath: "mygroup/myproject") { name description webUrl } }'

# Query merge request approvals
Invoke-GitlabGraphQL -Query '
  {
    project(fullPath: "mygroup/myproject") {
      mergeRequest(iid: "123") {
        approvedBy { nodes { username } }
      }
    }
  }
'
```

> **Tip:** Use GitLab's GraphQL Explorer at `https://gitlab.com/-/graphql-explorer` to build and test queries interactively.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Invoke-GitlabGraphQL](GraphQL/Invoke-GitlabGraphQL.md) | Executes a GraphQL query |
