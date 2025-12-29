# Configuration helper functions

function Test-IsConfigurationEnvironmentVariables {
    param (
    )

    $env:GITLAB_ACCESS_TOKEN
}

function Invoke-GitlabConfigMigration {
    [CmdletBinding()]
    param ()

    if (Test-Path $global:GitlabConfigurationPath) {
        return
    }

    $OldConfigPath = Join-Path $env:HOME '/.config/powershell/gitlab.config'

    if (-not (Test-Path $OldConfigPath)) {
        return
    }

    Write-Host "GitlabCli: Migrating configuration from '$OldConfigPath' to '$global:GitlabConfigurationPath'"

    try {
        $OldConfig = Get-Content $OldConfigPath -Raw | ConvertFrom-Json

        $OldConfig | Write-GitlabConfiguration

        Remove-Item $OldConfigPath -Force
        Write-Host "GitlabCli: Migration complete. Old config file removed."
    }
    catch {
        Write-Warning "GitlabCli: Failed to migrate configuration: $_"
        Write-Warning "GitlabCli: Old config preserved at '$OldConfigPath'"
    }
}

function Write-GitlabConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
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

    $SaveParameters = @{
        Path   = $global:GitlabConfigurationPath
        Force  = $true
        WhatIf = $false
    }
    $ToSave |
        ConvertTo-Yaml |
        Set-Content @SaveParameters |
        Out-Null
}

function Resolve-GitlabSite {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]
        $SiteUrl
    )

    $Sites = Get-GitlabConfiguration | Select-Object -ExpandProperty Sites

    if (-not [string]::IsNullOrWhiteSpace($SiteUrl)) {
        Write-Verbose "SiteUrl: $SiteUrl (source: -SiteUrl parameter)"

        $Site = $Sites | Where-Object Url -match $SiteUrl
        if ($Site) {
            Write-Verbose "SiteUrl: Using $($Site.Url)"
            return $Site
        }
    }

    $CallStack = Get-PSCallStack
    $SiteUrls = @()
    for ($i = 1; $i -lt $CallStack.Count; $i++) {
        $CallerInfo = $CallStack[$i].InvocationInfo
        $CallerSiteUrl = $null
        if ($CallerInfo.BoundParameters -and $CallerInfo.BoundParameters.TryGetValue('SiteUrl', [ref]$CallerSiteUrl) -and -not [string]::IsNullOrWhiteSpace($CallerSiteUrl)) {
            Write-Verbose "found $CallerSiteUrl (passed to [$($CallerInfo.MyCommand.Name)])"
            $SiteUrls += $CallerSiteUrl
        }
    }
    $ResolvedSiteUrls = @($SiteUrls | Select-Object -Unique)
    if ($ResolvedSiteUrls.Count -eq 1) {
        Write-Verbose "SiteUrl: $($ResolvedSiteUrls[0]) (source: call stack)"
        $Site = $Sites | Where-Object Url -match $ResolvedSiteUrls[0]
        if ($Site) {
            return $Site
        }
    }
    elseif ($ResolvedSiteUrls.Count -gt 1) {
        Write-Verbose "Inconsistent SiteUrls found in call stack ($($SiteUrls -join ', ')), ignoring..."
    }

    $LocalGitContext = Get-LocalGitContext
    if ($LocalGitContext -and $LocalGitContext.Site) {
        $Site = $Sites | Where-Object Url -eq $LocalGitContext.Site
        if ($Site) {
            Write-Verbose "SiteUrl: Using $($Site.Url) (source: local git context)"
            return $Site
        }
    }
    $Default = $Sites | Where-Object IsDefault | Select-Object -First 1
    if ($Default) {
        Write-Verbose "SiteUrl: Using $($Default.Url) (source: default site)"
        return $Default
    }

    throw "SiteUrl: Could not resolve GitLab site.  See https://github.com/chris-peterson/pwsh-gitlab#configuration"
}

function Get-GitlabResourceFromUrl {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Url
    )

    $Match = $null
    Get-GitlabConfiguration | Select-Object -Expand sites | Select-Object -Expand Url | ForEach-Object {
        if ($Url -match "$_/(?<ProjectId>.+?)(?:/-/(?:(?<ResourceType>[a-zA-Z_]+)/(?<ResourceId>\d+))?)?/?$") {
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
