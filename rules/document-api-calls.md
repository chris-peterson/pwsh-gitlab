Any call to `Invoke-GitlabApi` should have a blank line and a comment just above it that links to the relevant REST API documentation, e.g.

```powershell
    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    # https://docs.gitlab.com/ee/api/releases/#list-releases
    Invoke-GitlabApi GET 'releases' # ...
```
