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
            $Context.Branch = git rev-parse --abbrev-ref HEAD
        }
    }
    finally {
        Pop-Location
    }

    $Context
}
