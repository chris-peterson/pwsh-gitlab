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

    Write-Warning "Get-DefaultGitlabSite is deprecated; it will be removed in a future release"
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
    [CmdletBinding(SupportsShouldProcess)]
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

    if ($PSCmdlet.ShouldProcess("$Url", "add site")) {
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
}

function Remove-GitlabSite {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
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

    if ($PSCmdlet.ShouldProcess("$Url", "remove site")) {
        $Config = Get-GitlabConfiguration
        $Config.Sites = $Config.Sites | Where-Object Url -ne $Url

        $Config | Write-GitlabConfiguration

        Get-GitlabConfiguration
    }
}
