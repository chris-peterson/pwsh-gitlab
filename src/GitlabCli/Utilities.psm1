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
    if ($SiteUrl) {
        Write-Debug "Attempting to resolve site using $SiteUrl"
        $Site = Get-GitlabConfiguration | Select-Object -ExpandProperty Sites | Where-Object Url -eq $SiteUrl
    }
    if (-not $Site) {
        Write-Debug "Attempting to resolve site using local git context"
        $Site = Get-GitlabConfiguration | Select-Object -ExpandProperty Sites | Where-Object Url -eq $(Get-LocalGitContext).Site
    }
    if (-not $Site -or $Site -is [array]) {
        $Site = Get-DefaultGitlabSite
        Write-Debug "Using default site ($($Site.Url))"
    }
    $GitlabUrl = $Site.Url
    $Headers = @{
        Accept = 'application/json'
    }

    if ($global:GitlabUserImpersonationSession) {
        Write-Verbose "Impersonating API call as '$($global:GitlabUserImpersonationSession.Username)'..."
        $AccessToken = $global:GitlabUserImpersonationSession.Token
    } elseif (-not $AccessToken) {
        $AccessToken = $Site.AccessToken 
    }
    if ($AccessToken) {
        $Headers.Authorization = "Bearer $AccessToken"
    } else {
        throw "GitlabCli: environment not configured`nSee https://github.com/chris-peterson/pwsh-gitlab#getting-started for details"
    }

    if (-not $GitlabUrl.StartsWith('http')) {
        $GitlabUrl = "https://$GitlabUrl"
    }
    $GitlabUrl = $GitlabUrl.TrimEnd('/')

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

    if($PSCmdlet.ShouldProcess($RestMethodParams.Uri, $HttpMethod)) {
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

function Add-AliasedProperty {
    param (
        [PSCustomObject]
        [Parameter(Mandatory=$true, Position = 0)]
        $On,

        [string]
        [Parameter(Mandatory=$true)]
        $From,

        [string]
        [Parameter(Mandatory=$true)]
        $To
    )
    
    if ($null -ne $On.$To -and -NOT (Get-Member -Name $On.$To -InputObject $On)) {
        $On | Add-Member -MemberType NoteProperty -Name $From -Value $On.$To
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
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )
    Invoke-GitlabApi GET 'version' -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject | Get-FilteredObject $Select
}

function Get-GitlabResourceFromUrl {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Url
    )

    $Match = $null
    Get-GitlabConfiguration | Select-Object -Expand sites | Select-Object -Expand Url | ForEach-Object {
        if ($Url -match "$_/(?<ProjectId>.*)/-/(?<ResourceType>[a-zA-Z_]+)/(?<ResourceId>\d+)") {
            $Match = [PSCustomObject]@{
                ProjectId    = $Matches.ProjectId
                ResourceType = $Matches.ResourceType
                ResourceId   = $Matches.ResourceId
            }
        }
    }

    if (-not $Match) {
        throw "Could not extract a GitLab resource from '$Url'"
    }
    $Match
}

$global:GitlabDefaultMaxPages = 10

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
    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
#>

function Get-GitlabMaxPages {
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
