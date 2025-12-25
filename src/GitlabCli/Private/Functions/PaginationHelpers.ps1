# Pagination helper functions

<#
.SYNOPSIS
Resolves the MaxPages value based on parameters and defaults.

.DESCRIPTION
Internal helper function that determines the appropriate MaxPages value to use
for paginated API calls. If -All is specified, returns uint max value.
Otherwise, returns the provided MaxPages or falls back to the global default.

.PARAMETER MaxPages
The maximum number of pages to retrieve.

.PARAMETER All
If specified, retrieves all pages (sets MaxPages to uint max value).

.EXAMPLE
# In a function that supports pagination:
$MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
#>
function Resolve-GitlabMaxPages {
    param (
        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All
    )
    if ($MaxPages -eq 0) {
        $MaxPages = $global:GitlabDefaultMaxPages
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
