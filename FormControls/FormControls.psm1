#Requires -Version 5.1
Set-StrictMode -Version Latest

if ($PSVersionTable.PSEdition -eq 'Core' -and -not $IsWindows) {
    throw 'FormControls needs Windows (Windows Forms).'
}
Add-Type -AssemblyName System.Windows.Forms, System.Drawing, System.Data
[System.Windows.Forms.Application]::EnableVisualStyles()
try { [System.Windows.Forms.Application]::SetHighDpiMode('PerMonitorV2') | Out-Null }
catch { Write-Verbose 'SetHighDpiMode is not available (Windows PowerShell 5.1); using the default DPI mode.' }

foreach ($folder in 'Private', 'Public') {
    Get-ChildItem -Path (Join-Path $PSScriptRoot $folder) -Filter '*.ps1' -File | ForEach-Object { . $_.FullName }
}

Export-ModuleMember -Function @(
    'New-FormWindow', 'Show-FormWindow', 'Add-FormControl', 'Set-FormTheme',
    'New-Label', 'New-LinkLabel', 'New-Button', 'New-TextBox', 'New-ComboBox', 'New-CheckBox', 'New-RadioButton',
    'New-GroupBox', 'New-PictureBox', 'New-ProgressBar', 'New-NumericUpDown', 'New-DateTimePicker', 'New-ToolTip',
    'ConvertTo-DataTable', 'New-DataGrid', 'New-ListView', 'New-TreeView',
    'New-FlowPanel', 'New-TablePanel', 'New-TabControl',
    'New-MenuStrip', 'New-StatusStrip', 'New-NotifyIcon',
    'Get-GeneralValue', 'Hide-ConsoleWindow'
)
