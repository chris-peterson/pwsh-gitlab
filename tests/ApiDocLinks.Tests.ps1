BeforeDiscovery {
    $SourceFiles = Get-ChildItem -Path "$PSScriptRoot/../src" -Recurse -Include '*.psm1', '*.ps1'
    $Links = $SourceFiles | ForEach-Object {
        $File = $_
        Select-String -Path $File.FullName -Pattern 'https://docs\.gitlab\.com[^\s)]+' -AllMatches |
            ForEach-Object {
                $_.Matches | ForEach-Object {
                    @{
                        Url  = $_.Value
                        File = $File.Name
                        Line = $_.Groups[0].Value
                    }
                }
            }
    } | Sort-Object -Property Url -Unique
}

Describe "API Documentation Links" -Tag 'Online' {
    BeforeAll {
        $SourceFiles = Get-ChildItem -Path "$PSScriptRoot/../src" -Recurse -Include '*.psm1', '*.ps1'
        $Links = $SourceFiles | ForEach-Object {
            $File = $_
            Select-String -Path $File.FullName -Pattern 'https://docs\.gitlab\.com[^\s)]+' -AllMatches |
                ForEach-Object {
                    $_.Matches | ForEach-Object {
                        @{
                            Url  = $_.Value
                            File = $File.Name
                            Line = $_.Groups[0].Value
                        }
                    }
                }
        } | Sort-Object -Property Url -Unique
    }

    It "Found at least one link to verify" {
        $Links.Count | Should -BeGreaterThan 0
    }

    It "<Url> is valid (from <File>)" -ForEach $Links {
        $Response = Invoke-WebRequest -Uri $Url -Method Head -MaximumRedirection 5 -SkipHttpErrorCheck
        if ($Response.StatusCode -eq 403 -and $Response.Headers['Cf-Mitigated'] -contains 'challenge') {
            # GitLab's docs site puts some automated clients through a Cloudflare bot
            # challenge; a 403 carrying this header means the link exists but the
            # request was blocked, not that the page is gone.
            Set-ItResult -Skipped -Because 'blocked by a Cloudflare bot challenge, not a dead link'
        }
        else {
            $Response.StatusCode | Should -Be 200
        }
    }
}
