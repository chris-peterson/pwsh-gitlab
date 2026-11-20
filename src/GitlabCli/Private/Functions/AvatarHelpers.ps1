# Avatar upload helpers shared by the project, group, and topic avatar cmdlets

<#
.SYNOPSIS
Tests whether an avatar cmdlet's -Path is usable: an existing file or a data: URI.
#>
function Test-GitlabAvatarSource {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $Path
    )

    $Path -like 'data:*' -or (Test-Path -LiteralPath $Path -PathType Leaf)
}

<#
.SYNOPSIS
Describes an avatar source for -WhatIf and -Confirm: a file's full path, or a data: URI without its payload.
#>
function Get-GitlabAvatarSourceText {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $Path
    )

    if ($Path -like 'data:*') {
        "$($Path -replace ',.*$', ''),..."
    } else {
        (Resolve-Path -LiteralPath $Path).ProviderPath
    }
}

<#
.SYNOPSIS
Decodes a data: URI (base64 or percent-encoded) into an image file in the given directory.
#>
function ConvertFrom-GitlabDataUri {
    [CmdletBinding()]
    [OutputType([IO.FileInfo])]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $Uri,

        [Parameter(Mandatory)]
        [string]
        $Directory
    )

    $Extensions = @{
        'image/png'                = '.png'
        'image/jpeg'               = '.jpg'
        'image/gif'                = '.gif'
        'image/bmp'                = '.bmp'
        'image/tiff'               = '.tiff'
        'image/webp'               = '.webp'
        'image/x-icon'             = '.ico'
        'image/vnd.microsoft.icon' = '.ico'
        'image/svg+xml'            = '.svg'
    }

    if ($Uri -notmatch '(?s)^data:(?<Type>[^;,]*)(?<Parameters>[^,]*?)(?<Base64>;base64)?,(?<Data>.*)$') {
        throw "'$(Get-GitlabAvatarSourceText $Uri)' is not a valid data: URI"
    }
    $MediaType = $Matches.Type.Trim().ToLowerInvariant()
    $Extension = $Extensions[$MediaType]
    if (-not $Extension) {
        throw "Unsupported data: URI media type '$MediaType'. Use one of: $(($Extensions.Keys | Sort-Object) -join ', ')"
    }

    $Bytes = if ($Matches.Base64) {
        [Convert]::FromBase64String(($Matches.Data -replace '\s', ''))
    } else {
        [Text.Encoding]::UTF8.GetBytes([Uri]::UnescapeDataString($Matches.Data))
    }

    $File = Join-Path $Directory "avatar$Extension"
    [IO.File]::WriteAllBytes($File, $Bytes)
    Get-Item -LiteralPath $File
}

<#
.SYNOPSIS
Tests whether a file is an SVG image, by extension or by its leading content.
#>
function Test-GitlabSvg {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Position=0, Mandatory)]
        [IO.FileInfo]
        $File
    )

    if ($File.Extension -eq '.svg') {
        return $true
    }
    $Reader = [IO.StreamReader]::new($File.FullName)
    try {
        $Buffer = [char[]]::new(4096)
        $Count  = $Reader.Read($Buffer, 0, $Buffer.Length)
        [string]::new($Buffer, 0, $Count) -match '<svg[\s>]'
    } finally {
        $Reader.Dispose()
    }
}

<#
.SYNOPSIS
Rasterizes an SVG to a PNG that fits in a Size x Size square, using rsvg-convert, ImageMagick, or (on macOS) sips.

.DESCRIPTION
GitLab rejects SVG avatars, so they are converted client-side before upload.
#>
function ConvertFrom-GitlabSvg {
    [CmdletBinding()]
    [OutputType([IO.FileInfo])]
    param (
        [Parameter(Position=0, Mandatory)]
        [IO.FileInfo]
        $File,

        [Parameter(Mandatory)]
        [string]
        $Directory,

        [Parameter()]
        [uint]
        $Size = 192
    )

    $Png = Join-Path $Directory "$($File.BaseName).png"

    if (Get-Command 'rsvg-convert' -CommandType Application -ErrorAction SilentlyContinue) {
        $Tool = 'rsvg-convert'
        rsvg-convert --width $Size --height $Size --keep-aspect-ratio --background-color none --output $Png $File.FullName
    } elseif (Get-Command 'magick' -CommandType Application -ErrorAction SilentlyContinue) {
        $Tool = 'magick'
        magick -background none -density 384 $File.FullName -resize "$($Size)x$($Size)" -depth 8 $Png
    } elseif ($IsMacOS -and (Get-Command 'sips' -CommandType Application -ErrorAction SilentlyContinue)) {
        $Tool = 'sips'
        sips -Z $Size -s format png $File.FullName --out $Png | Out-Null
    } else {
        throw "GitLab doesn't accept SVG avatars, and no converter was found to turn '$($File.Name)' into a PNG. Install librsvg (rsvg-convert) or ImageMagick (magick), or pass a PNG."
    }

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $Png)) {
        throw "$Tool failed to convert '$($File.Name)' to PNG (exit code $LASTEXITCODE)"
    }
    Write-Verbose "Converted '$($File.Name)' to a $($Size)px PNG with $Tool (GitLab doesn't accept SVG avatars)"
    Get-Item -LiteralPath $Png
}

<#
.SYNOPSIS
Uploads an image as the avatar of a project, group, or topic.

.DESCRIPTION
Accepts a file path or a data: URI. SVG input is converted to PNG first, since GitLab rejects SVG avatars.
Intermediate files go to a temporary directory that is removed afterward.

.EXAMPLE
Invoke-GitlabAvatarUpload -Path ./logo.svg -ApiPath "projects/$($Project.Id)"
#>
function Invoke-GitlabAvatarUpload {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [string]
        $ApiPath
    )

    $WorkDir = Join-Path ([IO.Path]::GetTempPath()) "gitlab-avatar-$([guid]::NewGuid())"
    New-Item -ItemType Directory -Path $WorkDir | Out-Null
    try {
        $Image = $Path -like 'data:*' ?
            (ConvertFrom-GitlabDataUri $Path -Directory $WorkDir) :
            (Get-Item -LiteralPath $Path)
        if (Test-GitlabSvg $Image) {
            $Image = ConvertFrom-GitlabSvg $Image -Directory $WorkDir
        }
        Invoke-GitlabApi PUT $ApiPath -Form @{ avatar = $Image }
    } finally {
        Remove-Item -LiteralPath $WorkDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
