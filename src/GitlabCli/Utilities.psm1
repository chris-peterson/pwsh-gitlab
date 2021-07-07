# Inspired by https://gist.github.com/awakecoding/acc626741704e8885da8892b0ac6ce64
function ConvertTo-PascalCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Value
    )

    # https://devblogs.microsoft.com/oldnewthing/20190909-00/?p=102844
    return [regex]::replace($Value.ToLower(), '(^|_)(.)', { $args[0].Groups[2].Value.ToUpper()})
}

function ConvertTo-SnakeCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Value
    )

    return [regex]::replace($Value, '(?<=.)(?=[A-Z])', '_').ToLower()
}

function New-WrapperObject {
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        $Object,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $DisplayType
    )

    $Wrapper = New-Object PSObject
    $Object.PSObject.Properties | ForEach-Object {
        $Wrapper | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
    }
    if ($DisplayType) {
        $Wrapper.PSTypeNames.Insert(0, $DisplayType)
    }
    return $Wrapper
}