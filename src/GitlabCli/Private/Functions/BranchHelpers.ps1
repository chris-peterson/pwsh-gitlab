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
        $Branch
    )

    if ($Branch -eq '.') {
        $Branch = $(Get-LocalGitContext).Branch
        if (-not $Branch) {
            throw "Could not infer branch based on current directory ($(Get-Location))"
        }
        Write-Debug "Resolve-GitlabBranch: Resolved '.' to '$Branch'"
    }

    return $Branch
}
