# https://docs.gitlab.com/ee/api/#id-vs-iid
# TL;DR; it's a mess and we have to special-case specific entity types
$global:GitlabIdentityPropertyNameExemptions=@{
    'Gitlab.AuditEvent'                = 'Id'
    'Gitlab.AccessToken'               = 'Id'
    'Gitlab.BlobSearchResult'          = ''
    'Gitlab.Branch'                    = ''
    'Gitlab.Commit'                    = 'Id'
    'Gitlab.Configuration'             = ''
    'Gitlab.Environment'               = 'Id'
    'Gitlab.Event'                     = 'Id'
    'Gitlab.Group'                     = 'Id'
    'Gitlab.ProjectIntegration'        = 'Id'
    'Gitlab.Job'                       = 'Id'
    'Gitlab.Member'                    = 'Id'
    'Gitlab.MergeRequestApprovalRule'  = 'Id'
    'Gitlab.Note'                      = 'Id'
    'Gitlab.Pipeline'                  = 'Id'
    'Gitlab.PipelineBridge'            = 'Id'
    'Gitlab.PipelineDefinition'        = ''
    'Gitlab.PipelineSchedule'          = 'Id'
    'Gitlab.PipelineScheduleVariable'  = ''
    'Gitlab.Project'                   = 'Id'
    'Gitlab.ProjectHook'               = 'Id'
    'Gitlab.ProtectedBranch'           = 'Id'
    'Gitlab.RepositoryFile'            = ''
    'Gitlab.RepositoryTree'            = ''
    'Gitlab.Runner'                    = 'Id'
    'Gitlab.RunnerJob'                 = 'Id'
    'Gitlab.SearchResult.Blob'         = ''
    'Gitlab.SearchResult.MergeRequest' = ''
    'Gitlab.SearchResult.Project'      = ''
    'Gitlab.Topic'                     = 'Id'
    'Gitlab.User'                      = 'Id'
    'Gitlab.UserMembership'            = ''
    'Gitlab.Variable'                  = ''
}

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
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $HttpMethod,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $Path,

        [Parameter(Position=2, Mandatory=$false)]
        [hashtable]
        $Query = @{},

        [Parameter(Mandatory=$false)]
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
        [switch]
        $WhatIf
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
    $AccessToken = $Site.AccessToken

    $Headers = @{
        'Accept' = 'application/json'
    }
    if ($AccessToken) {
        $Headers['Authorization'] = "Bearer $AccessToken"
    } else {
        throw "GitlabCli: environment not configured`nSee https://github.com/chris-peterson/pwsh-gitlab#getting-started for details"
    }

    if (-not $GitlabUrl.StartsWith('http')) {
        $GitlabUrl = "https://$GitlabUrl"
    }

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
    $Uri = "$GitlabUrl/api/$Api/$Path$SerializedQuery"

    $RestMethodParams = @{}
    if($MaxPages -gt 1) {
        $RestMethodParams.FollowRelLink = $true
        $RestMethodParams.MaximumFollowRelLink = $MaxPages
    }
    if ($Body.Count -gt 0) {
        $RestMethodParams.ContentType = 'application/json'
        $RestMethodParams.Body        = $Body | ConvertTo-Json
    }

    if($WhatIf) {
        $SerializedParams = ""
        if($RestMethodParams.Count -gt 0) {
            $SerializedParams = $RestMethodParams.Keys | 
                ForEach-Object {
                    "-$_ `"$($RestMethodParams[$_])`""
                } |
                Join-String -Separator " "
            $SerializedParams += " "
        }
        Write-Host "WhatIf: $HttpMethod $Uri $SerializedParams"
    }
    else {
        Write-Debug "$HttpMethod $Uri"
        $Result = Invoke-RestMethod -Method $HttpMethod -Uri $Uri -Header $Headers @RestMethodParams
        if($MaxPages -gt 1) {
            # Unwrap pagination container
            $Result | ForEach-Object { 
                Write-Output $_
            }
        }
        else {
            Write-Output $Result
        }
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

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $DisplayType
    )
    Begin{}
    Process {
        foreach ($item in $InputObject) {
            $Wrapper = New-Object PSObject
            $item.PSObject.Properties |
                Sort-Object Name |
                ForEach-Object {
                    $Wrapper | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
                }
            
            # aliases for common property names
            Add-AliasedProperty -On $Wrapper -From 'Url' -To 'WebUrl'
            
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

function ValidateGitlabDateFormat {
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        $DateString
    )
    if($DateString -match "\d\d\d\d-\d\d-\d\d") {
        $true
    } else {
        throw "$DateString is invalid. The date format expected is YYYY-MM-DD"
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
