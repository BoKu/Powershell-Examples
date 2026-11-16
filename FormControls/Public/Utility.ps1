function Get-GeneralValue {
    <#
    .SYNOPSIS
    Returns a GUID, a timestamp or a random number. Defaults to a GUID.
    .EXAMPLE
    Get-GeneralValue -Type DateTimeShort
    .EXAMPLE
    Get-GeneralValue -Type Random -Minimum 1 -Maximum 7
    #>
    [CmdletBinding()]
    [OutputType([string], [int])]
    param(
        [ValidateSet('Guid', 'Unix', 'Date', 'DateTimeShort', 'DateTimeLong', 'TimeShort', 'TimeLong', 'Random')]
        [string] $Type = 'Guid',
        [int] $Minimum = 0,
        [int] $Maximum = 100
    )
    switch ($Type) {
        'Guid' { [guid]::NewGuid().ToString() }
        'Unix' { [string][DateTimeOffset]::UtcNow.ToUnixTimeSeconds() }
        'Date' { Get-Date -Format 'yyyy-MM-dd' }
        'DateTimeShort' { Get-Date -Format 'yyyy-MM-dd HH:mm' }
        'DateTimeLong' { Get-Date -Format 'yyyy-MM-dd HH:mm:ss' }
        'TimeShort' { Get-Date -Format 'HH:mm' }
        'TimeLong' { Get-Date -Format 'HH:mm:ss' }
        'Random' { Get-Random -Minimum $Minimum -Maximum $Maximum }
    }
}

function Hide-ConsoleWindow {
    <#
    .SYNOPSIS
    Hides this process's own console window (not other windows). Use -Restore to show it again.
    Does nothing inside Windows Terminal or without a console.
    .EXAMPLE
    Hide-ConsoleWindow
    #>
    [CmdletBinding()]
    param([switch] $Restore)
    if ($env:WT_SESSION) { return }
    Initialize-NativeMethod
    $handle = [FormControls.NativeMethods]::GetConsoleWindow()
    if ($handle -ne [IntPtr]::Zero) {
        $command = if ($Restore) { 5 } else { 0 }
        $null = [FormControls.NativeMethods]::ShowWindow($handle, $command)
    }
}
