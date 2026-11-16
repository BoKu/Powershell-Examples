@{
    RootModule            = 'FormControls.psm1'
    ModuleVersion         = '2.0.0'
    GUID                  = '6f1d3c52-7a0e-4c0b-9b5e-2d8f4a1c9e37'
    Author                = 'BoKu'
    Copyright             = '(c) 2024 BoKu. MIT License.'
    Description           = 'Small helper module for building Windows Forms GUIs in PowerShell: controls, layout panels, menus, data grids and light/dark themes.'
    PowerShellVersion     = '5.1'
    CompatiblePSEditions  = @('Desktop', 'Core')
    FunctionsToExport     = @(
        'New-FormWindow', 'Show-FormWindow', 'Add-FormControl', 'Set-FormTheme',
        'New-Label', 'New-LinkLabel', 'New-Button', 'New-TextBox', 'New-ComboBox', 'New-CheckBox', 'New-RadioButton',
        'New-GroupBox', 'New-PictureBox', 'New-ProgressBar', 'New-NumericUpDown', 'New-DateTimePicker', 'New-ToolTip',
        'ConvertTo-DataTable', 'New-DataGrid', 'New-ListView', 'New-TreeView',
        'New-FlowPanel', 'New-TablePanel', 'New-TabControl',
        'New-MenuStrip', 'New-StatusStrip', 'New-NotifyIcon',
        'Get-GeneralValue', 'Hide-ConsoleWindow'
    )
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @()
    PrivateData           = @{
        PSData = @{
            Tags       = @('WinForms', 'GUI', 'Windows', 'Forms')
            LicenseUri = 'https://github.com/BoKu/Powershell-Examples/blob/master/LICENSE'
            ProjectUri = 'https://github.com/BoKu/Powershell-Examples'
        }
    }
}
