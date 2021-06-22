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
        $Group = $(gitlab -o json group get --id $GroupId | ConvertFrom-Json)
        $Projects = gitlab -o json group-project list --group-id $($Group.id) --include-subgroups true --all | ConvertFrom-Json
        if ($Projects) {
            if (-not $IncludeArchived) {
                $Projects = $Projects | Where-Object -not Archived
            }
            
            $Projects |
                Where-Object { $($_.path_with_namespace).StartsWith($Group.full_path) } |
                ForEach-Object { Get-GitLabProject -ProjectId $_.id } |
                Sort-Object -Property 'Name'
        }
    }
}
