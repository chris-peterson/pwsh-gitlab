function Get-GitLabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId
    )

    $Group = gitlab -o json group get --id $GroupId | ConvertFrom-Json

    return $Group | New-WrapperObject -DisplayType 'Gitlab.Group'
}