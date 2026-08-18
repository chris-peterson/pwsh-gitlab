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
    $Paginate  = $MaxPages -gt 1 -and -not $OutFile
    $WalkPages = $Paginate -and (Test-PowerShellRelLinkDefect)
    if ($Paginate -and -not $WalkPages) {
        $RestMethodParams.FollowRelLink        = $true
        $RestMethodParams.MaximumFollowRelLink = $MaxPages
    }
    if ($Body.Count -gt 0) {
        $RestMethodParams.ContentType = 'application/json'
        $RestMethodParams.Body        = $Body | ConvertTo-Json
    }

    $HostOutput = "$($RestMethodParams | ConvertTo-Json)"

    if ($HttpMethod -eq 'GET' -or $PSCmdlet.ShouldProcess($RestMethodParams.Uri, $HostOutput)) {
        Write-Verbose "Request: $HostOutput"
        if ($WalkPages) {
            # Workaround for https://github.com/PowerShell/PowerShell/issues/27861 (see
            # Test-PowerShellRelLinkDefect): on affected versions -FollowRelLink fetches every
            # page after the first without our Authorization header, and a group of 43 projects
            # comes back as 39 with no error. Walking X-Next-Page ourselves keeps the header on
            # each request, and X-Total gives us something to check the walk against.
            $PageUri  = $RestMethodParams.Uri
            $Appender = $PageUri.Contains('?') ? '&' : '?'
            $Page     = 1
            $Yielded  = 0
            $Total    = $null
            while ($Page -le $MaxPages) {
                $RestMethodParams.Uri = "$PageUri$($Appender)page=$Page"
                $Response = Invoke-WebRequest @RestMethodParams
                $Response.Content | ConvertFrom-Json | ForEach-Object {
                    $Yielded++
                    Write-Output $_
                }
                if ($null -eq $Total) {
                    $Total = $Response.Headers.'X-Total' | Select-Object -First 1
                }
                $NextPage = $Response.Headers.'X-Next-Page' | Select-Object -First 1
                if ([string]::IsNullOrWhiteSpace($NextPage)) {
                    break
                }
                $Page = [int]$NextPage
            }
            # A short walk is worth saying out loud: it reads downstream as "the group has
            # fewer projects", not "the fetch came up short".
            if ($null -ne $Total -and $Page -le $MaxPages -and $Yielded -lt [int]$Total) {
                Write-Warning "$Path returned $Yielded of $Total record(s)"
            }
        } else {
            $Result = Invoke-RestMethod @RestMethodParams
            Write-Verbose "Response: $($Result | ConvertTo-Json -Depth 10)"
            if ($Paginate) {
                # Unwrap pagination container
                $Result | ForEach-Object {
                    Write-Output $_
                }
            } else {
                Write-Output $Result
            }
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
