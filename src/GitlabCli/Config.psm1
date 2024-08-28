
if($PSVersionTable.Platform -like 'Win*') {
    $env:HOME = Join-Path $env:HOMEDRIVE $env:HOMEPATH
} 

function Test-IsConfigurationEnvironmentVariables {
    param (
    )

    $env:GITLAB_ACCESS_TOKEN
}

function Write-GitlabConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Configuration
    )

    $ToSave = $Configuration |
        Select-Object -ExcludeProperty '*Display'

    try {
        # fun with cardinality
        if (-not ($ToSave.Sites -is [array])) {
            $ToSave.Sites = @($ToSave.Sites)
        }
    } catch [System.Management.Automation.PropertyNotFoundException] {
        # if there is no Sites yet (and $ToSave is $null, probably), make an empty config
        $ToSave = @{Sites = @()}
    }

    $ConfigContainer = Split-Path -Parent $global:GitlabConfigurationPath

    if (-not (Test-Path -Type Container $ConfigContainer)) {
        New-Item -Type Directory $ConfigContainer | Out-Null
    }

    $ToSave |
        ConvertTo-Json |
        Set-Content -Path $global:GitlabConfigurationPath -Force |
        Out-Null
}

function Get-GitlabConfiguration {
    [CmdletBinding()]
    param (
    )

    if (Test-IsConfigurationEnvironmentVariables) {
        return [PSCustomObject]@{
            Sites = @(@{
                Url = $env:GITLAB_URL ?? 'gitlab.com'
                AccessToken = $env:GITLAB_ACCESS_TOKEN
                IsDefault = $true
            })
        } | New-WrapperObject 'Gitlab.Configuration'
    }

    if (-not (Test-Path $global:GitlabConfigurationPath)) {
        Write-Warning "GitlabCli: Creating blank configuration file '$global:GitlabConfigurationPath'"
        @{
            Sites = @()
        } | Write-GitlabConfiguration
    }

    Get-Content $global:GitlabConfigurationPath | ConvertFrom-Json | New-WrapperObject 'Gitlab.Configuration'
}

function Get-DefaultGitlabSite {
    param (
    )

    $Configuration = Get-GitlabConfiguration
    $LocalContext = Get-LocalGitContext

    if ($LocalContext.Site) {
        $MatchingSite = $Configuration.Sites | Where-Object Url -eq $LocalContext.Site
        if ($MatchingSite) {
            return $MatchingSite | Select-Object -First 1
        }
    }

    $Configuration | Select-Object -ExpandProperty Sites | Where-Object IsDefault | Select-Object -First 1
}

function Set-DefaultGitlabSite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Url
    )

    if (Test-IsConfigurationEnvironmentVariables) {
        Write-Warning "GitlabCli: Current configuration is from environment variables which only supports a single site"
        Write-Warning "Unset `$env:GITLAB_ACCESS_TOKEN to use file-based configuration option"
        return
    }

    $Config = Get-GitlabConfiguration
    $Site = $Config.Sites | Where-Object Url -eq $Url

    if (-not $Site) {
        throw "'$Url' site not found"
    }

    $Config.Sites | ForEach-Object {
        $_.IsDefault = $false
    }
    $Site.IsDefault = $true

    $Config | Write-GitlabConfiguration
}

function Add-GitlabSite {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Url,

        [Parameter()]
        [string]
        $AccessToken,

        [Parameter()]
        [string]
        $ProxyUrl,

        [Parameter()]
        [switch]
        $IsDefault
    )

    if (Test-IsConfigurationEnvironmentVariables) {
        Write-Warning "GitlabCli: Current configuration is from environment variables"
        Write-Warning "Unset `$env:GITLAB_ACCESS_TOKEN to use file-based configuration"
        return
    }

    $Config = Get-GitlabConfiguration
    $ExistingSite = $Config.Sites | Where-Object Url -eq $Url
    if ($ExistingSite) {
        if ($(Read-Host -Prompt "Configuration for '$Url' already exists -- replace it? [y/n]") -ieq 'y') {
            Remove-GitlabSite $Url
            $Config = Get-GitlabConfiguration
        } else {
            return
        }
    }

    $Config.Sites += @{
        Url         = $Url
        AccessToken = $AccessToken
        ProxyUrl    = $ProxyUrl
        IsDefault   = 'false'
    }

    $Config | Write-GitlabConfiguration

    if ($IsDefault) {
        Set-DefaultGitlabSite -Url $Url
    }

    Get-GitlabConfiguration
}

function Remove-GitlabSite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Url
    )

    if (Test-IsConfigurationEnvironmentVariables) {
        Write-Warning "GitlabCli: Current configuration is from environment variables"
        Write-Warning "Unset `$env:GITLAB_ACCESS_TOKEN to use file-based configuration"
        return
    }

    $Config = Get-GitlabConfiguration
    $Config.Sites = $Config.Sites | Where-Object Url -ne $Url

    $Config | Write-GitlabConfiguration

    Get-GitlabConfiguration
}
