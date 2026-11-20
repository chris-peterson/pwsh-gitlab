# Helpers for the temporary tokens Use-GitlabToken and Start-GitlabUserImpersonation create

<#
.SYNOPSIS
Computes the expires_at date for a temporary token that must stay valid for at least -Lifetime.

.DESCRIPTION
GitLab takes expires_at as a date, not a time, and expires the token at 00:00 UTC on that date.
So the token can't be given an exact lifetime: this returns the day after the UTC date that
-Lifetime from now falls on, which keeps the token valid for at least -Lifetime and at most a day
longer. The caller revokes the token when it's done, so the expiry only matters if that fails.

-Lifetime defaults to $global:GitlabTemporaryTokenLifetime (Globals.ps1).

.EXAMPLE
Get-GitlabTemporaryTokenExpiryDate
# 2026-11-21 when run at 2026-11-20T01:06Z, and also at 2026-11-19T23:30Z
#>
function Get-GitlabTemporaryTokenExpiryDate {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter()]
        [TimeSpan]
        $Lifetime = $global:GitlabTemporaryTokenLifetime,

        # for tests; the current time
        [Parameter()]
        [DateTime]
        $Now = [DateTime]::UtcNow
    )

    $Now.ToUniversalTime().Add($Lifetime).Date.AddDays(1).ToString('yyyy-MM-dd')
}
