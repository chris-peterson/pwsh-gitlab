# Job helper functions

function global:Get-EpochTimestamp {
    [decimal] ((Get-Date) - (Get-Date "1/1/1970")).TotalMilliseconds * 1000
}
