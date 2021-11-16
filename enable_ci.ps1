$GroupsToUpdate = @('security-infrastructure')

$GroupsToUpdate | ForEach-Object {
    $Projects = Get-GitlabProject -Group $_
    Write-Host "Updating $($Projects.Length) projects for $_..."

    $Projects | ForEach-Object {
        Write-Host "`tUpdating $($_.PathWithNamespace) ($($_.Id))..."
        try {
            Update-GitlabProject $_.Id -BuildsAccessLevel 'enabled' | Out-Null
        }
        catch {
            Update-GitlabProject $_.Id -Visibility 'internal' -BuildsAccessLevel 'private' | Out-Null
        }
    }
}
