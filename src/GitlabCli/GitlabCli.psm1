function Get-GitLabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
    param (
        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ById')]
        [string]
        $ProjectId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroup')]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='ByGroup')]
        $IncludeArchived = $false
    )

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $Project = gitlab -o json project get --id $ProjectId | ConvertFrom-Json
        if ($Project) {
            $RetVal = New-Object PSObject
            $Project.PSObject.Properties | ForEach-Object {
                $RetVal | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
            }
            $RetVal.PSTypeNames.Insert(0, 'Gitlab.Project')
            return $RetVal
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'ByGroup') {
        # workaround for https://github.com/python-gitlab/python-gitlab/issues/1498
        $GroupId = $GroupId.Replace('/', '%2F')
        $Projects = gitlab -o json group-project list --group-id $GroupId | ConvertFrom-Json
        if ($Projects) {
            if (-not $IncludeArchived) {
                $Projects = $Projects | Where-Object -not Archived
            }
            $Projects | ForEach-Object {
                Get-GitLabProject -ProjectId $_.id
            } | Sort-Object -Property 'Name'
        }
    }
}
