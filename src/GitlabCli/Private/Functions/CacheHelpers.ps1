# Shared cache for project and group ID lookups
# Structure: @{ $siteUrl = @{ projects = @{ $path = $id }; groups = @{ $path = $id } } }
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
                $ProjectCount = $DiskCache.projects ? $DiskCache.projects.Count : 0
                $GroupCount = $DiskCache.groups ? $DiskCache.groups.Count : 0
                Write-Debug "GitlabCache: Loaded $ProjectCount project(s) and $GroupCount group(s) from disk for '$ResolvedSiteUrl'"
                return $DiskCache
            }
        } catch {
            Write-Debug "GitlabCache: Error loading cache from disk: $_"
        }
    }

    Write-Debug "GitlabCache: Initializing empty cache for '$ResolvedSiteUrl'"
    $script:GitlabCache[$ResolvedSiteUrl] = @{ projects = @{}; groups = @{} }
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal cache helper, not user-facing state change')]
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

# ============================================================================
# Group Cache Functions
# ============================================================================

function Resolve-GitlabGroupId {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $GroupId
    )

    $OriginalInput = $GroupId
    $GroupId = $GroupId.TrimEnd('/')
    $Site = Resolve-GitlabSite
    Write-Debug "GitlabCache: Resolve-GitlabGroupId '$OriginalInput' for site '$($Site.Url)'"

    if ($GroupId -match '^\d+$') {
        $NumericId = [int]$GroupId
        if (Test-GroupIdInCache -GroupId $NumericId -ResolvedSiteUrl $Site.Url) {
            Write-Debug "GitlabCache: Numeric group ID $NumericId is cached (known valid)"
            return $NumericId
        }
        Write-Debug "GitlabCache: Numeric group ID $NumericId not cached, returning as-is"
        return $NumericId
    }

    if ($GroupId -eq '.') {
        # First try git context (if in a git repo)
        $GitGroup = $(Get-LocalGitContext).Group
        if ($GitGroup) {
            $GroupId = $GitGroup
            Write-Debug "GitlabCache: Resolved '.' to '$GroupId' from git context"
        } else {
            # Fall back to directory-based inference (deepest to shallowest)
            $LocalPath = Get-Location | Select-Object -ExpandProperty Path
            $PossibleNames = Get-PossibleGroupName $LocalPath
            $MaxDepth = [Math]::Min(3, $PossibleNames.Count)
            for ($i = 1; $i -le $MaxDepth; $i++) {
                $PossibleGroupName = $PossibleNames[-$i]  # negative index: deepest to shallowest
                # Check cache first
                $CachedId = Get-GroupIdFromCache -GroupPath $PossibleGroupName -ResolvedSiteUrl $Site.Url
                if ($CachedId) {
                    Write-Debug "GitlabCache: Resolved '.' to cached group '$PossibleGroupName' -> $CachedId"
                    return $CachedId
                }
                # Try API lookup
                try {
                    $Group = Invoke-GitlabApi GET "groups/$($PossibleGroupName | ConvertTo-UrlEncoded)" @{
                        'with_projects' = 'false'
                    } -SiteUrl $Site.Url
                    if ($Group) {
                        Set-GroupIdInCache -GroupPath $PossibleGroupName -GroupId $Group.Id -ResolvedSiteUrl $Site.Url
                        Write-Debug "GitlabCache: Resolved '.' to group '$PossibleGroupName' -> $($Group.Id) (cached)"
                        return $Group.Id
                    }
                }
                catch {
                    Write-Debug "Group lookup failed for '$PossibleGroupName': $_"
                }
                Write-Verbose "Didn't find a group named '$PossibleGroupName'"
            }
            throw "Could not infer group based on current directory ($(Get-Location))"
        }
        if ($GroupId -match '^\d+$') {
            return [int]$GroupId
        }
    }

    $CachedId = Get-GroupIdFromCache -GroupPath $GroupId -ResolvedSiteUrl $Site.Url
    if ($CachedId) {
        Write-Debug "GitlabCache: Cache hit group '$GroupId' -> $CachedId"
        return $CachedId
    }

    Write-Debug "GitlabCache: Cache miss for group '$GroupId', calling API"
    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $Site.Url
    Set-GroupIdInCache -GroupPath $GroupId -GroupId $Group.Id -ResolvedSiteUrl $Site.Url
    Write-Debug "GitlabCache: Resolved group '$GroupId' -> $($Group.Id) (cached)"
    return $Group.Id
}

function Get-GroupIdFromCache {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [string]
        $GroupPath,

        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $Cache = Get-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl

    if ($Cache.groups -and $Cache.groups.ContainsKey($GroupPath)) {
        Write-Debug "GitlabCache: Get group '$GroupPath' -> $($Cache.groups[$GroupPath])"
        return $Cache.groups[$GroupPath]
    }

    Write-Debug "GitlabCache: Get group '$GroupPath' -> (not found)"
    return $null
}

function Test-GroupIdInCache {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [int]
        $GroupId,

        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $Cache = Get-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl

    if ($Cache.groups) {
        $Found = $Cache.groups.Values -contains $GroupId
        Write-Debug "GitlabCache: Test group ID $GroupId -> $Found"
        return $Found
    }

    Write-Debug "GitlabCache: Test group ID $GroupId -> False (no groups in cache)"
    return $false
}

function Set-GroupIdInCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal cache helper, not user-facing state change')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $GroupPath,

        [Parameter(Mandatory)]
        [int]
        $GroupId,

        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    $Cache = Get-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl

    if (-not $Cache.groups) {
        $Cache.groups = @{}
    }

    $Cache.groups[$GroupPath] = $GroupId
    Write-Debug "GitlabCache: Set group '$GroupPath' -> $GroupId"

    Save-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl
}
