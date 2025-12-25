# Runner helper functions

function Get-Percentile {
    param (
        [decimal[]] $Values,
        [decimal] $Percentile
    )

    $Sorted = $Values | Sort-Object
    $Index = [int] [Math]::Ceiling($Percentile * $Sorted.Count)
    if ($Index -eq 0) {
        $Sorted[$Index]
    } else {
        $Sorted[$Index-1]
    }
}
