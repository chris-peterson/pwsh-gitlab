# Job helper functions

function Get-EpochTimestamp {
    [decimal] ((Get-Date) - (Get-Date "1/1/1970")).TotalMilliseconds * 1000
}
