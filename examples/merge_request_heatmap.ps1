function Get-MergeRequestHeatmap {
    param (
        [string]
        [Parameter(Mandatory)]
        $Group,

        [ushort]
        [Parameter(Mandatory)]
        $Year,

        [string]
        [Parameter()]
        $Path = "$($Group)_merge_requests_$($Year).csv"
    )

    if (-not (Test-Path $Path)) {
        $MergeRequest = Get-GitlabMergeRequest -All -GroupId $Group -State merged -CreatedAfter "$($Year-1)-12-31" -CreatedBefore "$($Year+1)-01-01"
        $MergeRequestByQuarter = $MergeRequest | Group-Object @{e={[math]::Ceiling($_.MergedAt.Month / 3.0)}}
        $Rows = $MergeRequest.ProjectPath | Sort-Object -Unique
        $Data = $Rows | ForEach-Object { [pscustomobject]@{Project=$_; Q1=0; Q2=0; Q3=0; Q4=0} }
        for ($i=1; $i-le4; $i++)
        {
            foreach ($Mr in ($MergeRequestByQuarter | Where-Object Name -eq $i).Group) {
                $Data | Where-Object Project -eq $Mr.ProjectPath | ForEach-Object {
                    $_."Q$($i)"++
                }
            }
        }
        $Data | Export-Csv $Path
    }
    Import-Csv $Path
}

$Years = @()
for ($Year=2023; $Year -le 2025; $Year++)
{
    $Years += [pscustomobject]@{
        Year          = $Year
        MergeRequests = Get-MergeRequestHeatmap -Group $env:GROUP -Year $Year
    }
}

$Rows = $Years.MergeRequests.Project | Sort-Object -Unique
$Data = $Rows | ForEach-Object { 
    $Row = [pscustomobject][ordered]@{Project=$_;}
    foreach ($Year in $Years.Year) {
        $YearRow = $Years | Where-Object Year -eq $Year | Select-Object -ExpandProperty MergeRequests | Where-Object Project -eq $_
        $Row | Add-Member -NotePropertyName "$($Year):Q1" -NotePropertyValue ([int]$YearRow.Q1)
        $Row | Add-Member -NotePropertyName "$($Year):Q2" -NotePropertyValue ([int]$YearRow.Q2)
        $Row | Add-Member -NotePropertyName "$($Year):Q3" -NotePropertyValue ([int]$YearRow.Q3)
        $Row | Add-Member -NotePropertyName "$($Year):Q4" -NotePropertyValue ([int]$YearRow.Q4)
    }
    $Row
}

$Data | ForEach-Object {
    $Total = 0
    foreach ($Year in $Years.Year) {
        $Total += $_."$($Year):Q1" + $_."$($Year):Q2" + $_."$($Year):Q3" + $_."$($Year):Q4"
    }
    $_ | Add-Member -NotePropertyName Total -NotePropertyValue $Total
}

$Data | Export-Csv 'data.csv'
