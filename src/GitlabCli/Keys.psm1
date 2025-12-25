<#
.SYNOPSIS
    Retrieves SSH key by ID or Fingerprint from GitLab.

.LINK
    https://docs.gitlab.com/api/keys/
#>
function Get-GitlabKey {
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory,ParameterSetName = 'ById')]
        [string]$Id,

        [Parameter(Mandatory,ParameterSetName = 'ByFingerprint')]
        [string]$Fingerprint,

        [Parameter()]
        [string]$SiteUrl
    )

    $apiParams = @{
        Method  = 'Get'
        Path    = if ($Id) { "/keys/$Id" } else { "/keys" }
        Query   = if ($Fingerprint) { @{ fingerprint = $Fingerprint } } else { $null }
    }

    Invoke-GitlabApi @apiParams | New-GitlabObject 'Gitlab.SSHKey'
}