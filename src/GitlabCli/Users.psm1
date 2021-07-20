function Get-GitLabUser {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress
    )

    if ($Username) {
        $UserId = gitlab -o json user list --username $Username | jq '.[0].id'
        gitlab -o json user get --id $UserId | ConvertFrom-Json | New-WrapperObject -DisplayType 'GitLab.User'
    }
    elseif ($EmailAddress) {
        $(gitlab -o json user list --search $EmailAddress | ConvertFrom-Json)[0] | New-WrapperObject -DisplayType 'GitLab.User'
    }
}

function Get-GitLabGroupMembership {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress
    )
    $User = Get-GitLabUser -Username $Username -EmailAddress $EmailAddress

    gitlab -o json user-membership list --user-id $User.Id --all | ConvertFrom-Json |
        ForEach-Object { New-WrapperObject $_ }
}

function Add-GitLabUserToGroup {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupName,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        [ValidateSet("developer", "maintainer")]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress
    )
    $Group = Get-GitLabGroup -GroupId $GroupName
    $User = Get-GitLabUser -Username $Username -EmailAddress $EmailAddress
    gitlab group-member create --group-id $Group.Id --user-id $User.Id --access-level $Global:GitLabAccessLevels[$AccessLevel] | Out-Null

    Get-GitLabGroupMembership -Username $Username -EmailAddress $EmailAddress
}

$Global:GitLabAccessLevels = @{developer = 30; maintainer = 40}
