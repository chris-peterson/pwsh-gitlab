function Get-GitlabProtectedBranchAccessLevel {
    [PSCustomObject]@{
        NoAccess = 0
        Developer = 30
        Maintainer = 40
        Admin = 60
    }
}
