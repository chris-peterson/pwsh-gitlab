# contains functions for use with ValidateScript attributes

function Test-GitlabDate {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]
        $DateString
    )
    if ($DateString -match "\d\d\d\d-\d\d-\d\d") {
        $true
    } else {
        throw "$DateString is invalid - expected YYYY-MM-DD"
    }
}

function Test-GitlabSettableAccessLevel {
    param(
        [Parameter(Mandatory)]
        $Permission
    )

    $SettablePermissions = @('guest', 'reporter', 'developer', 'maintainer', 'owner')
    if ($SettablePermissions -contains $Permission) {
        return $true
    }
    $SettablePermissions | ForEach-Object {
        if ((Get-GitlabMemberAccessLevel -AccessLevel $_) -eq $Permission) {
            Write-Verbose "Allowing numeric $_ as $Permission"
            return $true
        }
    }
    return $false
}
