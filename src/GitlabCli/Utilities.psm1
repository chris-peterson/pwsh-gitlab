# Inspired by https://gist.github.com/awakecoding/acc626741704e8885da8892b0ac6ce64
function ConvertTo-PascalCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Value
    )

    # https://devblogs.microsoft.com/oldnewthing/20190909-00/?p=102844
    return [regex]::replace($Value.ToLower(), '(^|_)(.)', { $args[0].Groups[2].Value.ToUpper()})
}

function ConvertTo-SnakeCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        $InputObject
    )

    Process {
        foreach ($Value in $InputObject) {
            if ($Value -is [string]) {
                return [regex]::replace($Value, '(?<=.)(?=[A-Z])', '_').ToLower()
            }
        
            if ($Value -is [hashtable]) {
                $Value.Keys.Clone() | ForEach-Object {
                    $OriginalValue = $Value[$_]
                    $Value.Remove($_)
                    $Value[$($_ | ConvertTo-SnakeCase)] = $OriginalValue
                }
                $Value
            }
        }
    }
}


function ConvertTo-UrlEncoded {
    param (
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string]
        $Value
    )
    [System.Net.WebUtility]::UrlEncode($Value)
}

function Invoke-GitlabApi {
    [CmdletBinding(SupportsShouldProcess)]
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
                $SerializedQuery += [System.Net.WebUtility]::UrlEncode($Value)
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
    }
    if ($Body.Count -gt 0) {
        $RestMethodParams.ContentType = 'application/json'
        $RestMethodParams.Body        = $Body | ConvertTo-Json
    }

    $HostOutput = "$($RestMethodParams | ConvertTo-Json)"

    if ($HttpMethod -eq 'GET' -or $PSCmdlet.ShouldProcess($RestMethodParams.Uri, $HostOutput)) {
        Write-Verbose "Request: $HostOutput"
        $Result = Invoke-RestMethod @RestMethodParams
        Write-Verbose "Response: $($Result | ConvertTo-Json -Depth 10)"
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

function New-WrapperObject {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0)]
        [string]
        $DisplayType,

        [Parameter()]
        [switch]
        $PreserveCasing
    )
    Begin{}
    Process {
        foreach ($item in $InputObject) {
            $Wrapper = New-Object PSObject
            $item.PSObject.Properties |
                Sort-Object Name |
                ForEach-Object {
                    $Name = if ($PreserveCasing) { $_.Name } else { $_.Name | ConvertTo-PascalCase }
                    $Wrapper | Add-Member -MemberType NoteProperty -Name $Name -Value $_.Value
                }
            
            # aliases for common property names
            Add-AliasedProperty -On $Wrapper -From 'Url' -To 'WebUrl'
            Add-AliasedProperty -On $Wrapper -From 'Url' -To 'TargetUrl'
            
            if ($DisplayType) {
                $Wrapper.PSTypeNames.Insert(0, $DisplayType)

                $IdentityPropertyName = $global:GitlabIdentityPropertyNameExemptions[$DisplayType]
                if ($IdentityPropertyName -eq $null) {
                    $IdentityPropertyName = 'Iid' # default for anything that isn't explicitly mapped
                }
                if ($IdentityPropertyName -ne '') {
                    if ($Wrapper.$IdentityPropertyName) {
                        $TypeShortName = $DisplayType.Split('.') | Select-Object -Last 1
                        Add-AliasedProperty -On $Wrapper -From "$($TypeShortName)Id" -To $IdentityPropertyName
                    } else {
                        Write-Warning "$DisplayType does not have an identity field"
                    }
                }
            }
            Write-Output $Wrapper
        }
    }
    End{}
}

function Open-InBrowser {
    [CmdletBinding()]
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
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $Select = 'Version',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )
    Invoke-GitlabApi GET 'version' | New-WrapperObject | Get-FilteredObject $Select
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
