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
    if ($env:GITLAB_ACCESS_TOKEN) {
        $Headers['Authorization'] = "Bearer $env:GITLAB_ACCESS_TOKEN"
    } else {
        Write-Error "`$env:GITLAB_ACCESS_TOKEN` has not been configured`nSee https://github.com/chris-peterson/pwsh-gitlab#getting-started for details"
        return
    }
    $GitlabUrl = $env:GITLAB_URL ?? 'gitlab.com'

    if (-not $GitlabUrl.StartsWith('http')) {
        $GitlabUrl = "https://$GitlabUrl"
    }

    $SerializedQuery = ''
    $Delimiter = '?'
    if($Query.Count -gt 0) {
        foreach($Name in $Query.Keys) {
            $SerializedQuery += $Delimiter
            $SerializedQuery += "$Name="
            $SerializedQuery += [System.Net.WebUtility]::UrlEncode($Query[$Name])
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
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0,Mandatory=$false)]
        [string]
        $DisplayType
    )
    Begin{}
    Process {
        foreach ($item in $InputObject) {
            $Wrapper = New-Object PSObject
            $item.PSObject.Properties | ForEach-Object {
                $Wrapper | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
            }
            if ($DisplayType) {
                $Wrapper.PSTypeNames.Insert(0, $DisplayType)
            }
            Write-Output $Wrapper
        }
    }
    End{}
}