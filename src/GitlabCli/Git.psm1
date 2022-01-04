function Get-LocalGitContext {
    param (
        [string]
        [Parameter(Mandatory=$false)]
        $Path = '.'
    )
    
    $Context = [PSCustomObject]@{
        Site = ''
        Project = ''
        Branch = ''
    }
    if($(Get-Location).Provider.Name -ne 'FileSystem') {
        return $Context
    }

    Push-Location

    try {
        Set-Location $Path
        if (Get-ChildItem -Filter '.git' -Hidden -Directory) {
            $OriginUrl = git config --get remote.origin.url
            # https
            try {
                $Uri = [Uri]::new($OriginUrl)
                $Context.Site = $Uri.Host
                $Uri.AbsolutePath -match '/?(?<Project>.*)' | Out-Null
                $Context.Project = $Matches.Project -replace '.git$', ''
              
            }
            catch {
                # git
                $OriginUrl -match '@(?<Site>.*?)(/|:)(?<Project>[a-zA-Z0-9/-]+)' | Out-Null
                $Context.Site = $Matches.Site
                $Context.Project = $Matches.Project
            }

            $Ref = git status | Select-String "^HEAD detached at (?<sha>.{7,40})`|^On branch (?<branch>.*)"

            if ($Ref.Matches[0].Groups["sha"].Success) {
                $Context.Branch = (git branch -a --contains $Ref.Matches[0].Groups["sha"].Value `
                    | Select-Object -Skip 1 -First 1 `
                    | Select-String "  (?<branch>.*)").Matches[0].Groups["branch"].Value
            } elseif ($Ref.Matches[0].Groups["branch"]) {
                $Context.Branch = $Ref.Matches[0].Groups["branch"].Value
            } else {
                $Context.Branch = "Detached HEAD"
            }
        }
    }
    finally {
        Pop-Location
    }

    $Context
}
