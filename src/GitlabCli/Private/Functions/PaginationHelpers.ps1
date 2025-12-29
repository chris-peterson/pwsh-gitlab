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
