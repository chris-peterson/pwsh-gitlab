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
        [Alias('Ref')]
        [Parameter(ValueFromPipeline)]
        [string]
        $Branch
    )

    if ([string]::IsNullOrWhiteSpace($Branch)) {
        return $null
    }

    if ($Branch -eq '.') {
        $Branch = $(Get-LocalGitContext).Branch
        if (-not $Branch) {
            return $null
        }
    }

    return $Branch
}
