# Pagination helper functions

<#
.SYNOPSIS
Resolves the MaxPages value based on parameters and defaults.

.DESCRIPTION
Internal helper function that determines the appropriate MaxPages value to use
for paginated API calls. If -All or -Recurse is specified, returns uint max value.
Otherwise, returns the provided MaxPages or falls back to the global default.

.PARAMETER MaxPages
The maximum number of pages to retrieve.

.PARAMETER All
If specified, retrieves all pages (sets MaxPages to uint max value).

.PARAMETER Recurse
If specified, implies -All behavior (sets MaxPages to uint max value).
Using -Recurse without retrieving all pages doesn't make sense in most scenarios.

.EXAMPLE
# In a function that supports pagination:
$MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

.EXAMPLE
# In a function that supports recursion:
$MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All -Recurse:$Recurse
#>
function Resolve-GitlabMaxPages {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Resolves the MaxPages parameter value (plural is intentional)')]
    param (
        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [switch]
        [Parameter()]
        $Recurse
    )
    if ($MaxPages -eq 0) {
        $MaxPages = $global:GitlabDefaultMaxPages
    }
    # -Recurse implies -All behavior
    if ($Recurse) {
        $All = $true
    }
    if ($All) {
        if ($MaxPages -ne $global:GitlabDefaultMaxPages) {
            Write-Warning -Message "Ignoring -MaxPages in favor of -All"
        }
        $MaxPages = [uint]::MaxValue
    }
    Write-Debug "MaxPages: $MaxPages"
    $MaxPages
}

<#
.SYNOPSIS
Tests whether the running PowerShell drops the Authorization header when following rel links.

.DESCRIPTION
Per https://github.com/PowerShell/PowerShell/issues/27861, Invoke-RestMethod's -FollowRelLink
applies redirect authorization-stripping to rel-link follows, so every page after the first
is requested anonymously. GitLab answers those anonymously rather than rejecting them, and
the caller gets a partial result with no error.

The 2026-08-14 servicing patches landed it on three lines at once, and no fix has shipped on
any of them, so each range is open-ended: a later patch on an affected line still carries it.
Give a line an upper bound as its fix ships, and drop this function (and Invoke-GitlabApi's
manual page walk) once every affected version is out of circulation.

Preview and 7.7+ builds are clean today only because the change went straight onto the
servicing branches. If it is forward-ported, they join the table.
#>
function Test-PowerShellRelLinkDefect {
    [OutputType([bool])]
    param()

    $FirstAffected = @{
        '7.4' = [version]'7.4.19'
        '7.5' = [version]'7.5.10'
        '7.6' = [version]'7.6.5'
    }

    $PSVersion = $PSVersionTable.PSVersion
    $Floor     = $FirstAffected["$($PSVersion.Major).$($PSVersion.Minor)"]
    if (-not $Floor) {
        return $false
    }
    [version]::new($PSVersion.Major, $PSVersion.Minor, $PSVersion.Patch) -ge $Floor
}
