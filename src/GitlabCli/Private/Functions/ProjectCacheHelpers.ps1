$script:GitlabCache = @{}

function Get-GitlabCachePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $CacheDir = Split-Path -Parent $global:GitlabConfigurationPath

    $SafeSiteName = $ResolvedSiteUrl -replace 'https?://', '' -replace '[^a-zA-Z0-9.-]', '_'

    $CachePath = Join-Path $CacheDir "cache-$SafeSiteName.yml"
    Write-Debug "GitlabCache: CachePath='$CachePath'"
    $CachePath
}

function Get-GitlabSiteCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    if ($script:GitlabCache.ContainsKey($ResolvedSiteUrl)) {
        Write-Debug "GitlabCache: Using in-memory cache for '$ResolvedSiteUrl'"
        return $script:GitlabCache[$ResolvedSiteUrl]
    }

    $CachePath = Get-GitlabCachePath -ResolvedSiteUrl $ResolvedSiteUrl
    if (Test-Path $CachePath) {
        try {
            $DiskCache = Get-Content $CachePath -Raw | ConvertFrom-Yaml
            if ($DiskCache) {
                $script:GitlabCache[$ResolvedSiteUrl] = $DiskCache
                $EntryCount = $DiskCache.projects ? $DiskCache.projects.Count : 0
                Write-Debug "GitlabCache: Loaded $EntryCount project(s) from disk for '$ResolvedSiteUrl'"
                return $DiskCache
            }
        } catch {
            Write-Debug "GitlabCache: Error loading cache from disk: $_"
        }
    }

    Write-Debug "GitlabCache: Initializing empty cache for '$ResolvedSiteUrl'"
    $script:GitlabCache[$ResolvedSiteUrl] = @{ projects = @{} }
    return $script:GitlabCache[$ResolvedSiteUrl]
}

function Save-GitlabSiteCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    if (-not $script:GitlabCache.ContainsKey($ResolvedSiteUrl)) {
        Write-Debug "GitlabCache: Nothing to save for '$ResolvedSiteUrl'"
        return
    }

    $CachePath = Get-GitlabCachePath -ResolvedSiteUrl $ResolvedSiteUrl
    $CacheDir = Split-Path -Parent $CachePath

    if (-not (Test-Path $CacheDir)) {
        Write-Debug "GitlabCache: Creating cache directory '$CacheDir'"
        New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
    }

    try {
        $script:GitlabCache[$ResolvedSiteUrl] | ConvertTo-Yaml | Set-Content -Path $CachePath -Force
        Write-Debug "GitlabCache: Persisted cache to '$CachePath'"
    } catch {
        Write-Debug "GitlabCache: Error saving cache to disk: $_"
    }
}

function Resolve-GitlabProjectId {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $ProjectId
    )

    $OriginalInput = $ProjectId
    $ProjectId = $ProjectId.TrimEnd('/')
    $Site = Resolve-GitlabSite
    Write-Debug "GitlabCache: Resolve-GitlabProjectId '$OriginalInput' for site '$($Site.Url)'"

    if ($ProjectId -match '^\d+$') {
        $NumericId = [int]$ProjectId
        if (Test-ProjectIdInCache -ProjectId $NumericId -ResolvedSiteUrl $Site.Url) {
            Write-Debug "GitlabCache: Numeric ID $NumericId is cached (known valid)"
            return $NumericId
        }
        Write-Debug "GitlabCache: Numeric ID $NumericId not cached, returning as-is"
        return $NumericId
    }

    if ($ProjectId -eq '.') {
        $ProjectId = $(Get-LocalGitContext).Project
        if (-not $ProjectId) {
            throw "Could not infer project based on current directory ($(Get-Location))"
        }
        Write-Debug "GitlabCache: Resolved '.' to '$ProjectId'"
        if ($ProjectId -match '^\d+$') {
            return [int]$ProjectId
        }
    }

    $CachedId = Get-ProjectIdFromCache -ProjectPath $ProjectId -ResolvedSiteUrl $Site.Url
    if ($CachedId) {
        Write-Debug "GitlabCache: Cache hit '$ProjectId' -> $CachedId"
        return $CachedId
    }

    Write-Debug "GitlabCache: Cache miss for '$ProjectId', calling API"
    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $Site.Url
    Set-ProjectIdInCache -ProjectPath $ProjectId -ProjectId $Project.Id -ResolvedSiteUrl $Site.Url
    Write-Debug "GitlabCache: Resolved '$ProjectId' -> $($Project.Id) (cached)"
    return $Project.Id
}

function Get-ProjectIdFromCache {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [string]
        $ProjectPath,

        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $Cache = Get-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl

    if ($Cache.projects -and $Cache.projects.ContainsKey($ProjectPath)) {
        Write-Debug "GitlabCache: Get '$ProjectPath' -> $($Cache.projects[$ProjectPath])"
        return $Cache.projects[$ProjectPath]
    }

    Write-Debug "GitlabCache: Get '$ProjectPath' -> (not found)"
    return $null
}

function Test-ProjectIdInCache {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [int]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $Cache = Get-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl

    if ($Cache.projects) {
        $Found = $Cache.projects.Values -contains $ProjectId
        Write-Debug "GitlabCache: Test ID $ProjectId -> $Found"
        return $Found
    }

    Write-Debug "GitlabCache: Test ID $ProjectId -> False (no projects in cache)"
    return $false
}

function Set-ProjectIdInCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $ProjectPath,

        [Parameter(Mandatory)]
        [int]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $Cache = Get-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl

    if (-not $Cache.projects) {
        $Cache.projects = @{}
    }

    $Cache.projects[$ProjectPath] = $ProjectId
    Write-Debug "GitlabCache: Set '$ProjectPath' -> $ProjectId"

    Save-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl
}
