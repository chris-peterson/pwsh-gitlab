function Get-GitLabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId
    )

    $Group = gitlab -o json group get --id $GroupId | ConvertFrom-Json

    return $Group | New-WrapperObject -DisplayType 'GitLab.Group'
}

function Copy-GitLabGroupToLocalFileSystem {
    [Alias("Clone-GitLabGroup")]
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

    $Group = Get-GitLabGroup $GroupId
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

    Get-GitLabProject -GroupId $GroupId |
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
