BeforeAll {
    $TestModuleName = "Avatars"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Validations.ps1
    . $PSScriptRoot/TestHelpers.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/AvatarHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Projects.psm1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Groups.psm1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Topics.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [hashtable]$Body,
            [hashtable]$Form
        )
    }
    function global:New-GitlabObject {
        param(
            [Parameter(ValueFromPipeline)]$InputObject,
            [Parameter(Position=0)][string]$DisplayType
        )
        process { $InputObject }
    }

    $Svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" fill="#167125"/></svg>'
}

Describe "Avatars" {
    BeforeAll {
        $Image = New-Item -ItemType File -Path (Join-Path $TestDrive 'logo.png') -Force
    }

    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { [PSCustomObject]@{ id = 7 } }
        Mock -CommandName Get-GitlabProject -ModuleName $TestModuleName -MockWith {
            [PSCustomObject]@{ Id = 123; PathWithNamespace = 'mygroup/myproject' }
        }
    }

    Context "<Command>" -ForEach @(
        @{ Command = 'Set-GitlabProjectAvatar';  Arguments = @{ ProjectId = 'mygroup/myproject' }; ExpectedPath = 'projects/123' }
        @{ Command = 'Set-GitlabGroupAvatar';    Arguments = @{ GroupId = 'mygroup/sub' };         ExpectedPath = 'groups/mygroup%2Fsub' }
        @{ Command = 'Set-GitlabTopicAvatar';    Arguments = @{ TopicId = '7' };                   ExpectedPath = 'topics/7' }
    ) {
        It "Should upload the image as the avatar form field" {
            & $Command @Arguments -Path $Image.FullName | Out-Null

            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'PUT' -and $Path -eq $ExpectedPath -and $Form.avatar.FullName -eq $Image.FullName
            }
        }

        It "Should resolve a relative path against the current location" {
            Push-Location $TestDrive
            try {
                & $Command @Arguments -Path './logo.png' | Out-Null
            } finally {
                Pop-Location
            }

            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
                $Form.avatar.FullName -eq $Image.FullName
            }
        }

        It "Should reject a path that isn't a file or a data: URI" {
            { & $Command @Arguments -Path $TestDrive } | Should -Throw '*is not a file or a data: URI*'
            { & $Command @Arguments -Path (Join-Path $TestDrive 'missing.png') } | Should -Throw '*is not a file or a data: URI*'
            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
        }

        It "Should not upload under -WhatIf" {
            & $Command @Arguments -Path $Image.FullName -WhatIf
            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
        }
    }

    Context "<Command>" -ForEach @(
        @{ Command = 'Remove-GitlabProjectAvatar'; Arguments = @{ ProjectId = 'mygroup/myproject' }; ExpectedPath = 'projects/123' }
        @{ Command = 'Remove-GitlabGroupAvatar';   Arguments = @{ GroupId = 'mygroup/sub' };         ExpectedPath = 'groups/mygroup%2Fsub' }
        @{ Command = 'Remove-GitlabTopicAvatar';   Arguments = @{ TopicId = '7' };                   ExpectedPath = 'topics/7' }
    ) {
        It "Should send a blank avatar" {
            & $Command @Arguments -Confirm:$false | Out-Null

            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'PUT' -and $Path -eq $ExpectedPath -and $Body.ContainsKey('avatar') -and $Body.avatar -eq ''
            }
        }

        It "Should not remove under -WhatIf" {
            & $Command @Arguments -WhatIf
            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
        }
    }

    It "Should take the topic from the pipeline" {
        [PSCustomObject]@{ Id = '9' } | Set-GitlabTopicAvatar -Path $Image.FullName | Out-Null
        Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter { $Path -eq 'topics/9' }
    }

    Context "SVG and data: URIs" {
        BeforeEach {
            # stands in for rsvg-convert / magick / sips, which CI doesn't have
            $script:Converted = $null
            Mock -CommandName ConvertFrom-GitlabSvg -ModuleName $TestModuleName -MockWith {
                $script:Converted = Get-Content -LiteralPath $File.FullName -Raw
                $Png = Join-Path $Directory "$($File.BaseName).png"
                Set-Content -LiteralPath $Png -Value 'PNG'
                Get-Item -LiteralPath $Png
            }
            $script:Uploaded = $null
            Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith {
                $script:Uploaded = [PSCustomObject]@{
                    Name    = $Form.avatar.Name
                    Content = Get-Content -LiteralPath $Form.avatar.FullName -Raw
                    Folder  = $Form.avatar.DirectoryName
                }
                [PSCustomObject]@{ id = 7 }
            }
        }

        It "Should convert an SVG file to PNG before uploading it" {
            $SvgFile = Join-Path $TestDrive 'logo.svg'
            Set-Content -LiteralPath $SvgFile -Value $Svg

            Set-GitlabTopicAvatar 7 $SvgFile | Out-Null

            Should -Invoke ConvertFrom-GitlabSvg -ModuleName $TestModuleName -Times 1 -Exactly
            $Uploaded.Name | Should -Be 'logo.png'
        }

        It "Should decode a base64 data: URI" {
            $Png = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('PNG-BYTES'))

            Set-GitlabTopicAvatar 7 "data:image/png;base64,$Png" | Out-Null

            Should -Invoke ConvertFrom-GitlabSvg -ModuleName $TestModuleName -Times 0
            $Uploaded.Name    | Should -Be 'avatar.png'
            $Uploaded.Content | Should -Be 'PNG-BYTES'
        }

        It "Should decode and convert an SVG data: URI" {
            $Encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Svg))

            Set-GitlabProjectAvatar "data:image/svg+xml;base64,$Encoded" | Out-Null

            Should -Invoke ConvertFrom-GitlabSvg -ModuleName $TestModuleName -Times 1 -Exactly
            $Converted     | Should -Be $Svg
            $Uploaded.Name | Should -Be 'avatar.png'
        }

        It "Should decode a percent-encoded data: URI" {
            Set-GitlabGroupAvatar 'mygroup' "data:image/svg+xml,$([Uri]::EscapeDataString($Svg))" | Out-Null

            $Converted | Should -Be $Svg
        }

        It "Should remove its intermediate files" {
            $Encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Svg))
            Set-GitlabTopicAvatar 7 "data:image/svg+xml;base64,$Encoded" | Out-Null
            $Uploaded.Folder | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $Uploaded.Folder | Should -BeFalse
        }

        It "Should leave out the payload of a data: URI under -WhatIf" {
            $Encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Svg))
            $Text = Get-DisplayedText { Set-GitlabTopicAvatar 7 "data:image/svg+xml;base64,$Encoded" -WhatIf }
            $Text | Should -Match ([regex]::Escape('data:image/svg+xml;base64,...'))
            $Text | Should -Not -Match ([regex]::Escape($Encoded))
            Should -Invoke Invoke-GitlabApi -ModuleName $TestModuleName -Times 0
        }

        It "Should reject a data: URI that isn't an image" {
            { Set-GitlabTopicAvatar 7 'data:text/plain;base64,aGk=' } | Should -Throw "*Unsupported data: URI media type 'text/plain'*"
        }
    }
}

Describe "Get-GitlabAvatarSourceText" {
    It "Should drop the payload of a data: URI" {
        InModuleScope $TestModuleName {
            Get-GitlabAvatarSourceText 'data:image/svg+xml;base64,PHN2Zz4=' | Should -Be 'data:image/svg+xml;base64,...'
        }
    }
}

Describe "Test-GitlabSvg" {
    It "Should recognize an SVG by its content when the extension doesn't say so" {
        $File = Join-Path $TestDrive 'download'
        Set-Content -LiteralPath $File -Value "<?xml version=`"1.0`"?>`n$Svg"
        InModuleScope $TestModuleName -Parameters @{ File = $File } {
            Test-GitlabSvg (Get-Item -LiteralPath $File) | Should -BeTrue
        }
    }

    It "Should not treat other files as SVG" {
        $File = Join-Path $TestDrive 'photo.png'
        [IO.File]::WriteAllBytes($File, [byte[]](0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A))
        InModuleScope $TestModuleName -Parameters @{ File = $File } {
            Test-GitlabSvg (Get-Item -LiteralPath $File) | Should -BeFalse
        }
    }
}

Describe "ConvertFrom-GitlabSvg" {
    It "Should render a PNG that fits in the requested size" -Skip:(-not (
        (Get-Command 'rsvg-convert', 'magick' -CommandType Application -ErrorAction SilentlyContinue) -or
        ($IsMacOS -and (Get-Command 'sips' -CommandType Application -ErrorAction SilentlyContinue)))) {
        $SvgFile = Join-Path $TestDrive 'mark.svg'
        Set-Content -LiteralPath $SvgFile -Value $Svg
        $Png = InModuleScope $TestModuleName -Parameters @{ SvgFile = $SvgFile; Directory = "$TestDrive" } {
            ConvertFrom-GitlabSvg (Get-Item -LiteralPath $SvgFile) -Directory $Directory -Size 96
        }
        $Bytes = [IO.File]::ReadAllBytes($Png.FullName)
        $Bytes[0..3] | Should -Be @(0x89, 0x50, 0x4E, 0x47)
        # PNG IHDR: width and height are big-endian at offsets 16 and 20
        [BitConverter]::ToUInt32([byte[]]$Bytes[19..16], 0) | Should -Be 96
        [BitConverter]::ToUInt32([byte[]]$Bytes[23..20], 0) | Should -Be 96
    }
}
