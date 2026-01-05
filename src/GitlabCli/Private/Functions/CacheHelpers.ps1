# Shared cache for project and group ID lookups
# Structure: @{ $siteUrl = @{ projects = @{ $path = $id }; groups = @{ $path = $id } } }
$global:GitlabCache = @{}

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

    if ($global:GitlabCache.ContainsKey($ResolvedSiteUrl)) {
        Write-Debug "GitlabCache: Using in-memory cache for '$ResolvedSiteUrl'"
        return $global:GitlabCache[$ResolvedSiteUrl]
    }

    $CachePath = Get-GitlabCachePath -ResolvedSiteUrl $ResolvedSiteUrl
    if (Test-Path $CachePath) {
        try {
            $DiskCache = Get-Content $CachePath -Raw | ConvertFrom-Yaml
            if ($DiskCache) {
                $global:GitlabCache[$ResolvedSiteUrl] = $DiskCache
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
    $global:GitlabCache[$ResolvedSiteUrl] = @{ projects = @{}; groups = @{} }
    return $global:GitlabCache[$ResolvedSiteUrl]
}

function Save-GitlabSiteCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $ResolvedSiteUrl
    )

    if (-not $global:GitlabCache.ContainsKey($ResolvedSiteUrl)) {
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
        $Cache = $global:GitlabCache[$ResolvedSiteUrl]
        $SortedCache = [ordered]@{}
        if ($Cache.projects) {
            $SortedCache.projects = [ordered]@{}
            $Cache.projects.GetEnumerator() | Sort-Object Key | ForEach-Object { $SortedCache.projects[$_.Key] = $_.Value }
        }
        if ($Cache.groups) {
            $SortedCache.groups = [ordered]@{}
            $Cache.groups.GetEnumerator() | Sort-Object Key | ForEach-Object { $SortedCache.groups[$_.Key] = $_.Value }
        }
        $SortedCache | ConvertTo-Yaml | Set-Content -Path $CachePath -Force
        Write-Debug "GitlabCache: Persisted cache to '$CachePath'"
    } catch {
        Write-Debug "GitlabCache: Error saving cache to disk: $_"
    }
}

function Resolve-LocalGroupPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $GroupId = '.'
    )

    # Handle '../..' notation for parent group navigation
    if ($GroupId -match '^\.\.(/\.\.)*$') {
        $LevelsUp = ($GroupId -split '/').Count  # '..' = 1 level, '../..' = 2 levels
        $GitGroup = $(Get-LocalGitContext).Group
        if (-not $GitGroup) {
            throw "Cannot use '$GroupId' - not in a git repository with a valid group context"
        }
        $GroupParts = $GitGroup -split '/'
        if ($LevelsUp -ge $GroupParts.Count) {
            throw "Cannot navigate $LevelsUp level(s) up from '$GitGroup' - already at root"
        }
        $ParentPath = ($GroupParts | Select-Object -First ($GroupParts.Count - $LevelsUp)) -join '/'
        Write-Debug "GitlabCache: Resolved '$GroupId' to parent group '$ParentPath'"
        return $ParentPath
    }

    # Handle '.' notation for current group
    if ($GroupId -eq '.') {
        $GitGroup = $(Get-LocalGitContext).Group
        if ($GitGroup) {
            Write-Debug "GitlabCache: Resolved '.' to '$GitGroup' from git context"
            return $GitGroup
        }

        # Fallback: probe directory path from deepest to shallowest
        $LocalPath = Get-Location | Select-Object -ExpandProperty Path
        $Parts = $LocalPath.Split([IO.Path]::DirectorySeparatorChar) | Where-Object { $_ }
        $Site = Resolve-GitlabSite
        $MaxDepth = [Math]::Min(5, $Parts.Count)

        $MatchedGroups = @()

        # Probe from deepest to shallowest (i.e. prefer more specific matches)
        for ($depth = $MaxDepth; $depth -ge 1; $depth--) {
            $PossibleGroupName = ($Parts | Select-Object -Last $depth) -join '/'
            $CachedId = Get-GroupIdFromCache -GroupPath $PossibleGroupName -ResolvedSiteUrl $Site.Url
            if ($CachedId) {
                Write-Debug "GitlabCache: Found cached group '$PossibleGroupName'"
                $MatchedGroups += $PossibleGroupName
                continue
            }
            try {
                $Group = Invoke-GitlabApi GET "groups/$($PossibleGroupName | ConvertTo-UrlEncoded)" @{
                    'with_projects' = 'false'
                } -SiteUrl $Site.Url
                if ($Group) {
                    # Use snake_case properties from raw API response
                    Set-GroupIdInCache -GroupPath $Group.full_path -GroupId $Group.id -ResolvedSiteUrl $Site.Url
                    Write-Debug "GitlabCache: Found group '$($Group.full_path)' via API"
                    $MatchedGroups += $Group.full_path
                }
            }
            catch {
                Write-Debug "Group lookup failed for '$PossibleGroupName': $_"
            }
        }

        if ($MatchedGroups.Count -eq 0) {
            throw "Could not infer group based on current directory ($(Get-Location))"
        }

        if ($MatchedGroups.Count -gt 1) {
            Write-Warning "Ambiguous group resolution from directory path. Found multiple matches:"
            $MatchedGroups | ForEach-Object { Write-Warning "  - $_" }
            Write-Warning "Using most specific match: $($MatchedGroups[0])"
        }

        # Return the deepest (most specific) match
        Write-Debug "GitlabCache: Resolved '.' to group '$($MatchedGroups[0])'"
        return $MatchedGroups[0]
    }

    # Pass through non-special values as-is
    return $GroupId
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
        Write-Debug "GitlabCache: Numeric ID $NumericId not cached, validating via API"
        $Project = Get-GitlabProject -ProjectId $NumericId -SiteUrl $Site.Url
        Set-ProjectIdInCache -ProjectPath $Project.PathWithNamespace -ProjectId $Project.Id -ResolvedSiteUrl $Site.Url
        return $Project.Id
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

    if ($Cache.projects[$ProjectPath] -eq $ProjectId) {
        Write-Debug "GitlabCache: '$ProjectPath' -> $ProjectId (unchanged, skip save)"
        return
    }

    $Cache.projects[$ProjectPath] = $ProjectId
    Write-Debug "GitlabCache: Set '$ProjectPath' -> $ProjectId"

    Save-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl
}

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
        Write-Debug "GitlabCache: Numeric group ID $NumericId not cached, validating via API"
        $Group = Get-GitlabGroup -GroupId $NumericId -SiteUrl $Site.Url
        Set-GroupIdInCache -GroupPath $Group.FullPath -GroupId $Group.Id -ResolvedSiteUrl $Site.Url
        return $Group.Id
    }

    if ($GroupId -eq '.') {
        $GroupId = Resolve-LocalGroupPath
        if ($GroupId -match '^\d+$') {
            return [int]$GroupId
        }
    }
    elseif ($GroupId -match '^\.\.(/\.\.)*$') {
        $GroupId = Resolve-LocalGroupPath -GroupId $GroupId
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

    if ($Cache.groups[$GroupPath] -eq $GroupId) {
        Write-Debug "GitlabCache: group '$GroupPath' -> $GroupId (unchanged, skip save)"
        return
    }

    $Cache.groups[$GroupPath] = $GroupId
    Write-Debug "GitlabCache: Set group '$GroupPath' -> $GroupId"

    Save-GitlabSiteCache -ResolvedSiteUrl $ResolvedSiteUrl
}

function Save-ProjectToCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal cache helper, not user-facing state change')]
    [CmdletBinding()]
    [OutputType('Gitlab.Project')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSObject]
        $Project
    )

    begin {
        $Site = Resolve-GitlabSite
    }

    process {
        Set-ProjectIdInCache -ProjectPath $Project.PathWithNamespace -ProjectId $Project.Id -ResolvedSiteUrl $Site.Url
        $Project
    }
}

function Save-GroupToCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal cache helper, not user-facing state change')]
    [CmdletBinding()]
    [OutputType('Gitlab.Group')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSObject]
        $Group
    )

    begin {
        $Site = Resolve-GitlabSite
    }

    process {
        Set-GroupIdInCache -GroupPath $Group.FullPath -GroupId $Group.Id -ResolvedSiteUrl $Site.Url
        $Group
    }
}
