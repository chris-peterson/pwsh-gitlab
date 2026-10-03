BeforeAll {
    Update-TypeData -PrependPath $PSScriptRoot/../src/GitlabCli/Types.ps1xml

    . $PSScriptRoot/../src/GitlabCli/Private/Functions/StringHelpers.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Globals.ps1
    . $PSScriptRoot/../src/GitlabCli/Private/Functions/ObjectHelpers.ps1

    function New-TestIssue {
        param($Iid, $ProjectPath, $DueDate)
        $Issue = @{ iid = $Iid; web_url = "https://gitlab.com/$ProjectPath/-/issues/$Iid" }
        if ($DueDate) {
            $Issue.due_date = $DueDate
        }
        [PSCustomObject]$Issue
    }
}

Describe "Gitlab.Issue" {

    Context "SortKey" {
        It "Should be a string whether or not the issue has a due date" {
            $Dated = New-TestIssue -Iid 1 -ProjectPath 'group/project' -DueDate '2026-10-01'
            $Undated = New-TestIssue -Iid 2 -ProjectPath 'group/project'

            ($Dated | New-GitlabObject 'Gitlab.Issue').SortKey | Should -BeOfType [string]
            ($Undated | New-GitlabObject 'Gitlab.Issue').SortKey | Should -BeOfType [string]
        }

        It "Should order due-dated issues by date, soonest first" {
            $Issues = @(
                New-TestIssue -Iid 1 -ProjectPath 'group/project' -DueDate '2026-12-25'
                New-TestIssue -Iid 2 -ProjectPath 'group/project' -DueDate '2026-10-01'
            )
            ($Issues | New-GitlabObject 'Gitlab.Issue').IssueId | Should -Be @(2, 1)
        }

        It "Should put due-dated issues ahead of undated ones under <ProjectPath>" -ForEach @(
            @{ ProjectPath = '0-numeric-group/project' }
            @{ ProjectPath = 'alpha-group/project' }
        ) {
            $Issues = @(
                New-TestIssue -Iid 1 -ProjectPath $ProjectPath
                New-TestIssue -Iid 2 -ProjectPath $ProjectPath -DueDate '2026-10-01'
            )
            ($Issues | New-GitlabObject 'Gitlab.Issue').IssueId | Should -Be @(2, 1)
        }

        It "Should group undated issues by project" {
            $Issues = @(
                New-TestIssue -Iid 1 -ProjectPath 'zulu/project'
                New-TestIssue -Iid 2 -ProjectPath 'alpha/project'
            )
            ($Issues | New-GitlabObject 'Gitlab.Issue').ProjectPath | Should -Be @('alpha/project', 'zulu/project')
        }
    }
}

Describe "Gitlab.MergeRequest" {

    Context "SortKey" {
        It "Should be the merge request's GitLab reference" {
            $MergeRequest = [PSCustomObject]@{
                id = 300
                iid = 7
                web_url = 'https://gitlab.com/group/project/-/merge_requests/7'
            } | New-GitlabObject 'Gitlab.MergeRequest'

            $MergeRequest.SortKey | Should -Be 'group/project!7'
        }

        It "Should group merge requests by project" {
            $MergeRequests = @(
                [PSCustomObject]@{ id = 1; iid = 20; web_url = 'https://gitlab.com/group/zulu/-/merge_requests/20' }
                [PSCustomObject]@{ id = 2; iid = 3;  web_url = 'https://gitlab.com/group/alpha/-/merge_requests/3' }
                [PSCustomObject]@{ id = 3; iid = 1;  web_url = 'https://gitlab.com/group/zulu/-/merge_requests/1' }
            )
            ($MergeRequests | New-GitlabObject 'Gitlab.MergeRequest').SortKey |
                Should -Be @('group/alpha!3', 'group/zulu!1', 'group/zulu!20')
        }
    }

    Context "Contract properties" {
        BeforeAll {
            $MergeRequest = [PSCustomObject]@{
                id      = 300
                iid     = 7
                state   = 'opened'
                web_url = 'https://gitlab.example.com/group/project/-/merge_requests/7'
                author  = [PSCustomObject]@{ username = 'jdoe'; name = 'Jane Doe' }
            } | New-GitlabObject 'Gitlab.MergeRequest'
        }

        It "Should name its forge" {
            $MergeRequest.Forge | Should -Be 'gitlab'
        }

        It "Should report the host of the instance it came from" {
            $MergeRequest.Host | Should -Be 'gitlab.example.com'
        }

        It "Should expose the author's username as AuthorUsername" {
            $MergeRequest.AuthorUsername | Should -Be 'jdoe'
        }

        It "Should report an open merge request as open" {
            $MergeRequest.State | Should -Be 'open'
        }

        It "Should use the iid shown in the UI as Id" {
            $MergeRequest.Id | Should -Be 7
        }

        It "Should keep the instance-wide id as DatabaseId" {
            $MergeRequest.DatabaseId | Should -Be 300
        }

        It "Should keep MergeRequestId as the iid, for pipeline binding" {
            $MergeRequest.MergeRequestId | Should -Be 7
        }

        It "Should leave the <_> state as GitLab reports it" -ForEach @('merged', 'closed', 'locked') {
            $Result = [PSCustomObject]@{ id = 1; iid = 1; state = $_; web_url = 'https://gitlab.com/g/p/-/merge_requests/1' } |
                New-GitlabObject 'Gitlab.MergeRequest'
            $Result.State | Should -Be $_
        }
    }
}

Describe "Gitlab.Branch" {

    Context "UpdatedAt" {
        It "Should be the later of the tip commit's authored and committed dates" {
            $Branch = [PSCustomObject]@{
                name = 'main'
                commit = @{ authored_date = '2026-09-01T00:00:00Z'; committed_date = '2026-09-10T00:00:00Z' }
            } | New-GitlabObject 'Gitlab.Branch'

            $Branch.UpdatedAt | Should -Be '2026-09-10T00:00:00Z'
        }

        It "Should order branches most recently updated first" {
            $Branches = @(
                [PSCustomObject]@{ name = 'stale';  commit = @{ authored_date = '2026-01-01T00:00:00Z'; committed_date = '2026-01-01T00:00:00Z' } }
                [PSCustomObject]@{ name = 'fresh';  commit = @{ authored_date = '2026-09-10T00:00:00Z'; committed_date = '2026-09-10T00:00:00Z' } }
                [PSCustomObject]@{ name = 'middle'; commit = @{ authored_date = '2026-05-05T00:00:00Z'; committed_date = '2026-05-05T00:00:00Z' } }
            )
            ($Branches | New-GitlabObject 'Gitlab.Branch').Name | Should -Be @('fresh', 'middle', 'stale')
        }
    }
}

AfterAll {
    Remove-TypeData -Path $PSScriptRoot/../src/GitlabCli/Types.ps1xml
}
