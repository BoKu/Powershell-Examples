<#
# Author: BoKu
# License: MIT License
# Copyright (c) 2024 BoKu
#>
#Requires -Version 5.1
<#
'libEnums.ps1' | ForEach-Object {
    $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($_)
    if (Get-Module -Name $moduleName) { Remove-Module -Name $moduleName -Force }
    # Reimport Modules
    $importModule = $PSScriptRoot + "\\" + $_
    Import-Module -Name $importModule -Force
}
#>
function GeneralValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [eGeneralValue] $GeneralValue = [eGeneralValue]::guid,
        [Parameter(Mandatory = $false)]
        [decimal] $Floor = 0,
        [Parameter(Mandatory = $false)]
        [decimal] $Ceiling = 1
    )
    $return = $null
    
    switch ($GeneralValue) {
        "datetimelong" {
            $return = (Get-Date -Format "yyyy-MM-dd HH:mm:ss").ToString()
        }
        "datetimeshort" {
            $return = (Get-Date -Format "yyyy-MM-dd HH:mm").ToString()
        }
        "date" {
            $return = (Get-Date -Format "yyyy-MM-dd").ToString()
        }
        "timelong" {
            $return = (Get-Date -Format "HH:mm:ss").ToString()
        }
        "timeshort" {
            $return = (Get-Date -Format "HH:mm").ToString()
        }
        "guid" {
            $return = New-Guid
        }
        "rand" {
            $return = Get-Random -Minimum $Floor -Maximum $Ceiling
        }
        Default {
            $return = $false
        }
    }
    return $return

    <#
        .SYNOPSIS
        Returns a random (or current) value based on the input type required.
        Defaults to New-Guid if no value supplied.
        .PARAMETER GeneralValue
        The General Value type you want to return
        .INPUTS
        None. You can't pipe objects to GeneralValue
        .OUTPUTS
        System.String.
        .EXAMPLE
        PS> $value = GeneralValue
        PS> Write-Host $value
        PS> cfea3ca4-5a5a-4a5c-b14f-d28dcd8778da
        .EXAMPLE
        PS> $value = GeneralValue("epoch")
        PS> Write-Host $value
        PS> cfea3ca4-5a5a-4a5c-b14f-d28dcd8778da
    #>
}

function HideConsoleWindows() {
    # Add-Type to access the ShowWindow function
    if (-not ([System.Management.Automation.PSTypeName]'WinAPI').Type) {
        Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAPI {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@
    }
    # Define the process names
    $processNames = 'Cmd', 'OpenConsole', 'WindowsTerminal'
    
    $thisProcess = Get-Process -Id $pid
    $thisProcessTitle = $thisProcess.MainWindowTitle
    $thisProcessHandle = $thisProcess.MainWindowHandle

    # Loop through each process name
    foreach ($name in $processNames) {
        try {
            # Get the process
            $otherProcess = Get-Process | Where-Object { $_.name -ilike $name }

            # Check if the process is running
            if ($otherProcess.Id -ne $pid) {
                
                # Get the MainWindowHandle
                $hWnd = $otherProcess.MainWindowHandle
                if (($hWnd -ne $thisProcessHandle) -and ($otherProcess.MainWindowTitle -ne $thisProcessTitle)) {
                    # Hide the window
                    $null = [WinAPI]::ShowWindow($hWnd, 0) 
                }
            }
        }
        catch {
            # TODO
        }
    }
    
    <#
        .SYNOPSIS
        Hides the currently open PowerShell, Console, Terminal or Command Windows.
        .INPUTS
        None. You can't pipe objects to HideConsoleWindows.
        .OUTPUTS
        None.
        .EXAMPLE
        PS> HideConsoleWindows
    #>
}