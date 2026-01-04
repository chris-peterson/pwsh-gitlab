function Get-GitlabProtectedBranchAccessLevel {
    [PSCustomObject]@{
        NoAccess = 0
        Developer = 30
        Maintainer = 40
        Admin = 60
    }
}

function Resolve-GitlabBranch {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Branch,

        [Parameter()]
        [scriptblock]
        $OnBranchNotInferred = { throw "Could not infer branch based on current directory ($(Get-Location))" }
    )

    if ($Branch -eq '.') {
        $Branch = $(Get-LocalGitContext).Branch
        if (-not $Branch) {
            return & $OnBranchNotInferred
        }
        Write-Debug "Resolve-GitlabBranch: Resolved '.' to '$Branch'"
    }

    return $Branch
}
