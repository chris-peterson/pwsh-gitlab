function Get-GitLabProject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectId
    )

    $Project = gitlab -o json project get --id $ProjectId | ConvertFrom-Json
    if ($Project) {
        $RetVal = New-Object -TypeName 'PSCustomObject'
        $RetVal.PSTypeNames.Insert(0,'Gitlab.Project')
        $Project.PSObject.Properties | ForEach-Object {
            $RetVal | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
        }
        return $RetVal
    }
}
