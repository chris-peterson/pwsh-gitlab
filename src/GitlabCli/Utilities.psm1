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
        [string] $Value
    )

    return [regex]::replace($Value, '(?<=.)(?=[A-Z])', '_').ToLower()
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

        [Parameter()]
        [int]
        $MaxPages = 1,

        [Parameter()]
        [switch]
        $WhatIf,

        [Parameter()]
        [hashtable]
        $WhatIfContext = @{}
    )

    $Headers = @{
        'Accept' = 'application/json'
    }
    if($env:GITLAB_PRIVATE_TOKEN -or $env:GITLAB_ACCESS_TOKEN) {
        $Headers['Authorization'] = "Bearer $($env:GITLAB_PRIVATE_TOKEN ?? $env:GITLAB_ACCESS_TOKEN)"
    }
    $GitlabUrl = $env:GITLAB_URL ?? 'https://gitlab.com'

    $SerializedQuery = ''
    $Delimiter = '?'
    if($Query.Count -gt 0) {
        foreach($Name in $Query.Keys) {
            $SerializedQuery += $Delimiter
            $SerializedQuery += "$Name="
            $SerializedQuery += [System.Net.WebUtility]::UrlDecode($Query[$Name])
            $Delimiter = '&'
        }
    }
    $Uri = "$GitlabUrl/api/v4/$Path$SerializedQuery"

    $RestMethodParams = @{}
    if($MaxPages -gt 1) {
        $RestMethodParams['FollowRelLink'] = $true
        $RestMethodParams['MaximumFollowRelLink'] = $MaxPages
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
        
        $SerializedContext = ""
        if($WhatIfContext.Count -gt 0) {
            $SerializedContext = $WhatIfContext.Keys |
                ForEach-Object {
                    "$_=`"$($WhatIfContext[$_])`""
                } |
                Join-String -Separator " "
            $SerializedContext = "($SerializedContext)"
        }
        
        Write-Host "$HttpMethod $Uri $SerializedParams$SerializedContext"
    }
    else {
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

function New-WrapperObject {
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        $Object,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $DisplayType
    )

    $Wrapper = New-Object PSObject
    $Object.PSObject.Properties | ForEach-Object {
        $Wrapper | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
    }
    if ($DisplayType) {
        $Wrapper.PSTypeNames.Insert(0, $DisplayType)
    }
    return $Wrapper
}