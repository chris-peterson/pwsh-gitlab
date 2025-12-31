BeforeAll {
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/CasingHelpers.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Globals.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/ObjectHelpers.ps1
}

Describe "New-GitlabObject" {

    Context "Property conversion" {
        It "Should convert snake_case properties to PascalCase" {
            $Input = [PSCustomObject]@{ first_name = 'John'; last_name = 'Doe' }
            $Result = $Input | New-GitlabObject
            $Result.FirstName | Should -Be 'John'
            $Result.LastName | Should -Be 'Doe'
        }

        It "Should preserve casing when -PreserveCasing is specified" {
            $Input = [PSCustomObject]@{ first_name = 'John'; last_name = 'Doe' }
            $Result = $Input | New-GitlabObject -PreserveCasing
            $Result.first_name | Should -Be 'John'
            $Result.last_name | Should -Be 'Doe'
        }

        It "Should preserve property values" {
            $Input = [PSCustomObject]@{ count = 123; active = $true; items = @(1,2,3) }
            $Result = $Input | New-GitlabObject
            $Result.Count | Should -Be 123
            $Result.Active | Should -Be $true
            $Result.Items | Should -HaveCount 3
        }
    }

    Context "URL aliasing" {
        It "Should create Url alias from WebUrl" {
            $Input = [PSCustomObject]@{ web_url = 'https://gitlab.com/project' }
            $Result = $Input | New-GitlabObject
            $Result.Url | Should -Be 'https://gitlab.com/project'
            $Result.WebUrl | Should -Be 'https://gitlab.com/project'
        }

        It "Should create Url alias from TargetUrl" {
            $Input = [PSCustomObject]@{ target_url = 'https://gitlab.com/target' }
            $Result = $Input | New-GitlabObject
            $Result.Url | Should -Be 'https://gitlab.com/target'
            $Result.TargetUrl | Should -Be 'https://gitlab.com/target'
        }
    }

    Context "DisplayType" {
        It "Should set PSTypeName when DisplayType is provided" {
            $Input = [PSCustomObject]@{ id = 1; name = 'test' }
            $Result = $Input | New-GitlabObject 'Gitlab.Project'
            $Result.PSTypeNames | Should -Contain 'Gitlab.Project'
        }

        It "Should not set PSTypeName when DisplayType is not provided" {
            $Input = [PSCustomObject]@{ id = 1; name = 'test' }
            $Result = $Input | New-GitlabObject
            $Result.PSTypeNames | Should -Not -Contain 'Gitlab.Project'
        }
    }

    Context "Identity field aliasing" {
        It "Should create identity alias using Iid by default" {
            $Input = [PSCustomObject]@{ iid = 42; title = 'Test Issue' }
            $Result = $Input | New-GitlabObject 'Gitlab.Issue'
            $Result.IssueId | Should -Be 42
            $Result.Iid | Should -Be 42
        }

        It "Should create identity alias using Id for exempted types" {
            $Input = [PSCustomObject]@{ id = 123; status = 'running' }
            $Result = $Input | New-GitlabObject 'Gitlab.Pipeline'
            $Result.PipelineId | Should -Be 123
            $Result.Id | Should -Be 123
        }

        It "Should not create identity alias for types with empty exemption" {
            $Input = [PSCustomObject]@{ key = 'MY_VAR'; value = 'secret' }
            $Result = $Input | New-GitlabObject 'Gitlab.Variable'
            $Result.PSObject.Properties.Name | Should -Not -Contain 'VariableId'
        }
    }

    Context "Pipeline support" {
        It "Should process multiple objects from pipeline" {
            $Items = @(
                [PSCustomObject]@{ id = 1; name = 'first' }
                [PSCustomObject]@{ id = 2; name = 'second' }
                [PSCustomObject]@{ id = 3; name = 'third' }
            )
            $Results = $Items | New-GitlabObject
            $Results | Should -HaveCount 3
            $Results[0].Id | Should -Be 1
            $Results[1].Id | Should -Be 2
            $Results[2].Id | Should -Be 3
        }

        It "Should apply DisplayType to all objects in pipeline" {
            $Items = @(
                [PSCustomObject]@{ iid = 1 }
                [PSCustomObject]@{ iid = 2 }
            )
            $Results = $Items | New-GitlabObject 'Gitlab.Issue'
            $Results | ForEach-Object {
                $_.PSTypeNames | Should -Contain 'Gitlab.Issue'
            }
        }
    }

    Context "Positional parameter" {
        It "Should accept DisplayType as positional parameter" {
            $Input = [PSCustomObject]@{ id = 1 }
            $Result = $Input | New-GitlabObject 'Gitlab.Runner'
            $Result.PSTypeNames | Should -Contain 'Gitlab.Runner'
        }
    }
}

Describe "Add-CoalescedProperty" {

    Context "Basic aliasing" {
        It "Should add alias property when source exists" {
            $Obj = [PSCustomObject]@{ WebUrl = 'https://example.com' }
            $Obj | Add-CoalescedProperty -From 'WebUrl' -To 'Url'
            $Obj.Url | Should -Be 'https://example.com'
        }

        It "Should not add alias when source property is null" {
            $Obj = [PSCustomObject]@{ WebUrl = $null }
            $Obj | Add-CoalescedProperty -From 'WebUrl' -To 'Url'
            $Obj.PSObject.Properties.Name | Should -Not -Contain 'Url'
        }

        It "Should not overwrite existing property" {
            $Obj = [PSCustomObject]@{ WebUrl = 'https://example.com'; Url = 'existing' }
            $Obj | Add-CoalescedProperty -From 'WebUrl' -To 'Url'
            $Obj.Url | Should -Be 'existing'
        }
    }

    Context "Multiple source properties" {
        It "Should use first non-null property from array" {
            $Obj = [PSCustomObject]@{ WebUrl = 'https://web.com'; TargetUrl = 'https://target.com' }
            $Obj | Add-CoalescedProperty -From @('WebUrl', 'TargetUrl') -To 'Url'
            $Obj.Url | Should -Be 'https://web.com'
        }

        It "Should fall back to second property when first is null" {
            $Obj = [PSCustomObject]@{ WebUrl = $null; TargetUrl = 'https://target.com' }
            $Obj | Add-CoalescedProperty -From @('WebUrl', 'TargetUrl') -To 'Url'
            $Obj.Url | Should -Be 'https://target.com'
        }

        It "Should not add alias when all source properties are null" {
            $Obj = [PSCustomObject]@{ WebUrl = $null; TargetUrl = $null }
            $Obj | Add-CoalescedProperty -From @('WebUrl', 'TargetUrl') -To 'Url'
            $Obj.PSObject.Properties.Name | Should -Not -Contain 'Url'
        }
    }

    Context "Falsy but valid values" {
        It "Should add alias when source property is 0" {
            $Obj = [PSCustomObject]@{ Count = 0 }
            $Obj | Add-CoalescedProperty -From 'Count' -To 'Total'
            $Obj.Total | Should -Be 0
        }

        It "Should add alias when source property is empty string" {
            $Obj = [PSCustomObject]@{ Name = '' }
            $Obj | Add-CoalescedProperty -From 'Name' -To 'Title'
            $Obj.Title | Should -Be ''
        }

        It "Should add alias when source property is false" {
            $Obj = [PSCustomObject]@{ Active = $false }
            $Obj | Add-CoalescedProperty -From 'Active' -To 'IsActive'
            $Obj.IsActive | Should -Be $false
        }
    }

    Context "Pipeline support" {
        It "Should process objects from pipeline" {
            $Obj = [PSCustomObject]@{ WebUrl = 'https://example.com' }
            $Obj | Add-CoalescedProperty -From 'WebUrl' -To 'Url'
            $Obj.Url | Should -Be 'https://example.com'
        }
    }
}
