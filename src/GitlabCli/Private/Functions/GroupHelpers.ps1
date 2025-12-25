# Group helper functions

function Get-PossibleGroupName {
    param (
        [string]
        $Path
    )

    $Parts = $Path.Split('/')
    for ($i = 0; $i -lt $Parts.Length; $i++) {
        if ($i -eq 0) {
            $Parts[$i]
        }
        else {
            $Parts[0..($i)] -join '/'
        }
    }
}
