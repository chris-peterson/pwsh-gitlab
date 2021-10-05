function Get-LocalGitContext {
    param (
        [string]
        [Parameter(Mandatory=$false)]
        $Path = '.'
    )
    
    Push-Location
    $Context = [PSCustomObject]@{
        Site = ''
        Project = ''
        Branch = ''
    }

    try {
        Set-Location $Path
        if (Get-ChildItem -Filter '.git' -Hidden -Directory) {
            $(git config --get remote.origin.url) -match '(https://|git@)(?<Site>.*?)(/|:)(?<Project>[a-zA-Z/-]+)'
            $Context.Site = $Matches.Site
            $Context.Project = $Matches.Project
            
            $Ref = git status | Select-String "^HEAD detached at (?<sha>.{8})`|^On branch (?<branch>.*)"
 
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
