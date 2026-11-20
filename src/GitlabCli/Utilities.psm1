function Invoke-GitlabApi {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position=0, Mandatory)]
        [Alias('Method')]
        [string]
        $HttpMethod,

        [Parameter(Position=1, Mandatory)]
        [string]
        $Path,

        [Parameter(Position=2)]
        [hashtable]
        $Query = @{},

        [Parameter()]
        [hashtable]
        $Body = @{},

        # multipart/form-data fields; a [IO.FileInfo] value is uploaded as a file
        [Parameter()]
        [hashtable]
        $Form = @{},

        [Parameter()]
        [uint]
        $MaxPages = 1,

        [Parameter()]
        [string]
        $Api = 'v4',

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [string]
        $AccessToken,

        [Parameter()]
        [string]
        $ProxyUrl,

        [Parameter()]
        [string]
        $OutFile
    )

    if ($MaxPages -gt [int]::MaxValue) {
         $MaxPages = [int]::MaxValue
    }
    $Site = Resolve-GitlabSite -SiteUrl $SiteUrl

    $GitlabUrl = $Site.Url
    if (-not $GitlabUrl.StartsWith('http')) {
        $GitlabUrl = "https://$GitlabUrl"
    }
    $GitlabUrl = $GitlabUrl.TrimEnd('/')

    $Headers = @{
        Accept = 'application/json'
    }

    if ($global:GitlabUserImpersonationSession) {
        Write-Verbose "Impersonating API call as '$($global:GitlabUserImpersonationSession.Username)'..."
        $AccessToken = $global:GitlabUserImpersonationSession.Token
    } elseif (-not $AccessToken) {
        $AccessToken = $Site.AccessToken
    }
    $Headers.Authorization = "Bearer $AccessToken"

    $SerializedQuery = ''
    $Delimiter = '?'
    if($Query.Count -gt 0) {
        foreach($Name in $Query.Keys) {
            $Value = $Query[$Name]
            if ($Value) {
                $SerializedQuery += $Delimiter
                $SerializedQuery += "$Name="
                $SerializedQuery += $Value | ConvertTo-UrlEncoded
                $Delimiter = '&'
            }
        }
    }
    $RestMethodParams = @{
        Method = $HttpMethod
        Uri    = "$GitlabUrl/api/$([string]::IsNullOrWhiteSpace($Api) ? '' : "$Api/")$Path$SerializedQuery"
        Header = $Headers
    }
    if ($OutFile) {
        $RestMethodParams.OutFile = $OutFile
        $RestMethodParams.Header.Accept = 'application/octet-stream'
    }

    $Proxy  = $ProxyUrl ?? $Site.ProxyUrl
    if (-not [string]::IsNullOrWhiteSpace($Proxy)) {
        Write-Verbose "Using proxy $Proxy..."
    }
    if($MaxPages -gt 1) {
        $RestMethodParams.FollowRelLink        = $true
        $RestMethodParams.MaximumFollowRelLink = $MaxPages
        # PowerShell 7.6 drops the Authorization header when following rel=next, so
        # any paged request 401s past page 1. Drop this once the scoped upstream fix
        # ships: https://github.com/PowerShell/PowerShell/issues/27861
        $RestMethodParams.PreserveAuthorizationOnRedirect = $true
    }
    if ($Body.Count -gt 0 -and $Form.Count -gt 0) {
        throw "-Body and -Form can't be combined"
    }
    if ($Body.Count -gt 0) {
        $RestMethodParams.ContentType = 'application/json'
        $RestMethodParams.Body        = $Body | ConvertTo-Json
    }
    if ($Form.Count -gt 0) {
        $RestMethodParams.Form = $Form
    }

    $Display = [ordered]@{
        Method = $HttpMethod
        Uri    = $RestMethodParams.Uri
    }
    if ($Body.Count -gt 0) {
        $Display.Body = $Body
    }
    if ($Form.Count -gt 0) {
        $Display.Form = @{}
        foreach ($Name in $Form.Keys) {
            $Value = $Form[$Name]
            $Display.Form[$Name] = $Value -is [IO.FileSystemInfo] ? $Value.FullName : $Value
        }
    }
    if ($OutFile) {
        $Display.OutFile = $OutFile
    }
    $HostOutput = $Display | ConvertTo-GitlabLogText

    if ($HttpMethod -eq 'GET' -or $PSCmdlet.ShouldProcess($RestMethodParams.Uri, $HostOutput)) {
        Write-Verbose "Request: $HostOutput"
        $Result = Invoke-RestMethod @RestMethodParams
        if ($VerbosePreference -ne 'SilentlyContinue') {
            # responses can carry secrets (new access tokens, masked variable values)
            Write-Verbose "Response: $($Result | ConvertTo-GitlabLogText)"
        }
        if($MaxPages -gt 1) {
            # Unwrap pagination container
            $Result | ForEach-Object {
                Write-Output $_
            }
        } else {
            Write-Output $Result
        }
    } else {
        Write-Host "Parameters: $HostOutput"
    }
}

function Open-InBrowser {
    [CmdletBinding()]
    [OutputType([void])]
    [Alias('go')]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject
    )

    Process {
        if (-not $InputObject) {
            # do nothing
        } elseif ($InputObject -is [string]) {
            Start-Process $InputObject
        } elseif ($InputObject.Url -and $InputObject.Url -is [string]) {
            Start-Process $InputObject.Url
        } elseif ($InputObject.WebUrl -and $InputObject.WebUrl -is [string]) {
            Start-Process $InputObject.WebUrl
        }
    }
}

function Get-FilteredObject {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $InputObject,

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $Select = '*'
    )
    Begin {}
    Process {
        foreach ($Object in $InputObject) {
            if (($Select -eq '*') -or (-not $Select)) {
                $Object
            } elseif ($Select.Contains(',')) {
                $Object | Select-Object $($Select -split ',')
            } else {
                $Object | Select-Object -ExpandProperty $Select
            }
        }
    }
    End {}
}

function Get-GitlabVersion {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $Select = 'Version',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )
    Invoke-GitlabApi GET 'version' | New-GitlabObject | Get-FilteredObject $Select
}

# Helper function for consistency of paging parameters
# Add these parameters to your cmdlet
<#
    [Parameter()]
    [uint]
    $MaxPages,

    [switch]
    [Parameter()]
    $All,
#>
# then call
<#
    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
#>
# Note: Resolve-GitlabMaxPages is defined in Private/Functions/PaginationHelpers.ps1
