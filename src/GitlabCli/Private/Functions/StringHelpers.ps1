# Casing conversion helper functions

function ConvertTo-PascalCase {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        $InputObject
    )
    Begin {}
    Process {
        if ($InputObject -is [string]) {
            [regex]::replace($InputObject.ToLower(), '(^|_)(.)', { $args[0].Groups[2].Value.ToUpper()})
        }
        elseif ($InputObject -is [hashtable]) {
            $InputObject.Keys.Clone() | ForEach-Object {
                $OriginalValue = $InputObject[$_]
                $InputObject.Remove($_)
                $InputObject[$($_ | ConvertTo-PascalCase)] = $OriginalValue
            }
            $InputObject
        }
    }
    End {}
}

function ConvertTo-SnakeCase {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        $InputObject
    )
    Begin {}
    Process {
        if ($InputObject -is [string]) {
            [regex]::replace($InputObject, '(?<=.)(?=[A-Z])', '_').ToLower()
        }
        elseif ($InputObject -is [hashtable]) {
            $InputObject.Keys.Clone() | ForEach-Object {
                $OriginalValue = $InputObject[$_]
                $InputObject.Remove($_)
                $InputObject[$($_ | ConvertTo-SnakeCase)] = $OriginalValue
            }
            $InputObject
        }
    }
    End {}
}

function ConvertTo-UrlEncoded {
    param (
        [Parameter(Position=0, ValueFromPipeline)]
        [string]
        $Value
    )
    Begin {}
    Process {
        [Uri]::EscapeDataString($Value)
    }
    End {}
}
