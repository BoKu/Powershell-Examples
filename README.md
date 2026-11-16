# Powershell-Examples

## FormControls

A small PowerShell module for building Windows Forms GUIs without writing WinForms boilerplate.
Works on Windows PowerShell 5.1 and PowerShell 7+ (Windows only).

```powershell
Import-Module .\FormControls\FormControls.psd1

$form   = New-FormWindow -Title 'Hello' -Size '420,200'
$name   = New-TextBox -PlaceholderText 'Your name' -Dock Top
$button = New-Button -Text 'Greet' -Dock Bottom -OnClick { [System.Windows.Forms.MessageBox]::Show("Hi $($name.Text)") | Out-Null }
Add-FormControl -Parent $form -Control $name, $button
Show-FormWindow -Form $form -Theme Auto
```

### What is included

| Area | Functions |
| --- | --- |
| Window | `New-FormWindow`, `Show-FormWindow`, `Add-FormControl`, `Set-FormTheme` (Light, Dark or follow Windows) |
| Basic controls | `New-Label`, `New-LinkLabel`, `New-Button`, `New-TextBox`, `New-ComboBox`, `New-CheckBox`, `New-RadioButton`, `New-GroupBox`, `New-PictureBox`, `New-ProgressBar`, `New-NumericUpDown`, `New-DateTimePicker`, `New-ToolTip` |
| Data | `New-DataGrid`, `New-ListView`, `New-TreeView`, `ConvertTo-DataTable` |
| Layout | `New-FlowPanel`, `New-TablePanel`, `New-TabControl` |
| Menus and tray | `New-MenuStrip`, `New-StatusStrip`, `New-NotifyIcon` |
| Utility | `Get-GeneralValue`, `Hide-ConsoleWindow` |

Every `New-*` control takes `-Text`, `-Location`, `-Size`, `-Dock`, `-Anchor`, `-Name` and a `-Property` hashtable
for any other WinForms property. Use `Get-Help New-Button -Examples` for details.

### Examples

Run these on Windows:

* `Examples\Demo.ps1` shows every control, in tabs.
* `Examples\SettingsForm.ps1` is a settings dialog that saves to JSON.
* `Examples\ProcessViewer.ps1` is a filterable process list with a menu and tray icon.

### Upgrading from 1.x

Version 2 is a rewrite and is not compatible with the old class files.

| 1.x | 2.0 |
| --- | --- |
| `[ButtonControl]::New(...)` with 9 positional arguments | `New-Button -Text ... -Location ...` |
| `GeneralValue("guid")` | `Get-GeneralValue -Type Guid` |
| `HideConsoleWindows` (hid other windows) | `Hide-ConsoleWindow` (hides only its own console) |
| `DoEvents()` loop | `Show-FormWindow` |
| Fixed pixel layout only | Flow, table and dock layouts as well |

### Development

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse -Settings PSScriptAnalyzerSettings.psd1
Invoke-Pester -Path Tests
```

CI runs both on every pull request.

![DEMO FORM](https://github.com/BoKu/Powershell-Examples/assets/6552986/f48afda3-3a8a-4b77-953e-06387b0404c3)
