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
        $Response.StatusCode | Should -Be 200
    }
}
