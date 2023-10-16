function Get-GitlabMembershipReport {
    param(
        [string]
        [Parameter(Mandatory, Position=0)]
        $GroupName,

        [string]
        [Parameter(Mandatory)]
        $StartDate,

        [string]
        [Parameter()]
        $EndDate
    )

    $Group = Get-GitlabGroup $GroupName

    $CurrentMembership = $Group | Get-GitlabGroupMember
    $AuditRequest = @{
        GroupId      = $Group.Id
        All          = $true
        FetchAuthors = $true
        After        = $StartDate
    }
    if ($EndDate) {
        Before = $EndDate
    }

    Write-Host "Current membership of '$GroupName' on $(Get-Date):"
    $CurrentMembership | Foreach-Object {
        [PSCustomObject]@{
            'User'       = $_.Name
            'Access'     = $_.AccessLevelFriendly
            'Granted On' = $_.CreatedAt
        }
    } | Format-Markdown
    Write-Host "`nChanges to membership since $StartDate`:"
    Get-GitlabAuditEvent @AuditRequest |
        Where-Object { $_.Details.add -eq 'user_access' -or $_.Details.remove -eq 'user_access' -or $_.Details.change -eq 'access_level' } |
        ForEach-Object {
            [PSCustomObject]@{
                Timestamp = $_.CreatedAt
                User      = $_.Author.Name
                Action    = $_.Summary
            }
        } | Format-Markdown
}
