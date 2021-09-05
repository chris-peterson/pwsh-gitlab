function Get-GitlabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId
    )

    $Group = Invoke-GitlabApi GET "groups/$([System.Net.WebUtility]::UrlEncode($GroupId))" @{
        'with_projects' = 'false'
    }

    return $Group | New-WrapperObject 'Gitlab.Group'
}

function New-GitlabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupName,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $ParentGroupName,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $ParentGroup = Get-GitlabGroup -GroupId $ParentGroupName
    $GroupId = Invoke-GitlabApi POST "groups" @{
        name = $GroupName
        path = $GroupName
        parent_id = $ParentGroup.Id
        visibility = $ParentGroup.Visibility
    } -WhatIf:$WhatIf | Select-Object -ExcludeProperty id
    if(-not $WhatIf) {
        return Get-GitlabGroup -GroupId $GroupId
    }
}


function Remove-GitlabGroup {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $Group = Get-GitlabGroup -GroupId $GroupId

    Invoke-GitlabApi DELETE "groups/$($Group.Id)" -WhatIf:$WhatIf | Out-Null
}

function Copy-GitlabGroupToLocalFileSystem {
    [Alias("Clone-GitlabGroup")]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    Push-Location

    $Group = Get-GitlabGroup $GroupId
    $GroupSplit = $Group.FullPath -split '/'

    $LocalPath = $(Get-Location).Path
    for ($i = 0; $i -lt $GroupSplit.Count; $i++)
    {
        $ToMatch = $($GroupSplit | Select-Object -First $($GroupSplit.Count - $i)) -join '/'
        if ($LocalPath -imatch "$ToMatch$") {
            $LocalPath = $LocalPath.Replace($ToMatch, "").TrimEnd('/')
            break;
        }
    }

    if ($WhatIf) {
        Write-Host "WhatIf: setting local directory to '$LocalPath'"
    }

    Get-GitlabProject -GroupId $GroupId |
        ForEach-Object {
            $Path="$LocalPath/$($_.Group)"

            if ($WhatIf) {
                Write-Host "WhatIf: cloning $($_.SshUrlToRepo) to $Path"
            } else {
                if (-not $(Test-Path $Path)) {
                    New-Item $Path -Type Directory | Out-Null
                }
                Push-Location
                Set-Location $Path
                git clone $_.SshUrlToRepo
                Pop-Location
            }
        }

    Pop-Location

    if ($WhatIf) {
        Write-Host "WhatIf: setting directory to $LocalPath"
    } else {
        Set-Location $LocalPath
    }
}

function Update-LocalGitlabGroup {
    [Alias("Pull-GitlabGroup")]
    [CmdletBinding()]
    param (
        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    Get-ChildItem -Recurse -Hidden -Directory |
        Where-Object Name -match '.git$' |
        ForEach-Object {
            Push-Location

            if ($WhatIf) {
                Write-Host "WhatIf: git pull -p '$_'"
            } else {
                Set-Location -Path "$_/.."
                git pull -p
            }
            Pop-Location
    }
}
