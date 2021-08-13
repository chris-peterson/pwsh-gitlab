function Get-LocalGitContext {
    param (
        [string]
        [Parameter(Mandatory=$false)]
        $Path = '.'
    )
    
    Push-Location
    $Context = [PSCustomObject]@{
        Repo = ''
        Branch = ''
    }

    try {
        Set-Location $Path
        if (Get-ChildItem -Filter '.git' -Hidden -Directory) {
            $Context.Repo = $($(git config --get remote.origin.url) -split ':' | Select-Object -Last 1).Replace('.git', '')
            
            $branchOrSha = git status | select-string "^HEAD detached at (?<sha>.{8})`|^On branch (?<branch>.*)"
 
            if($branchOrSha.Matches[0].Groups["sha"].Success) {
                $Context.Branch = (git branch -a --contains $branchOrSha.Matches[0].Groups["sha"].Value `
                    | Select-Object -Skip 1 -First 1 `
                    | select-string "  (?<branch>.*)").Matches[0].Groups["branch"].Value
            } elseif ($branchOrSha.Matches[0].Groups["branch"]) {
                $Context.Branch = $branchOrSha.Matches[0].Groups["branch"].Value
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
