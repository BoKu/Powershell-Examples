#Requires -Version 5.1
<#
.SYNOPSIS
A small settings dialog that saves to and loads from a JSON file next to the script.
#>
[CmdletBinding()]
param([string] $SettingsPath = (Join-Path $PSScriptRoot 'settings.json'))

Import-Module (Join-Path $PSScriptRoot '..\FormControls\FormControls.psd1') -Force

$defaults = [ordered]@{ UserName = $env:USERNAME; Notify = $true; Retries = 3; Mode = 'Balanced' }
$settings = $defaults
if (Test-Path -LiteralPath $SettingsPath) {
    try {
        $saved = Get-Content -LiteralPath $SettingsPath -Raw | ConvertFrom-Json
        foreach ($key in @($defaults.Keys)) { if ($null -ne $saved.$key) { $settings[$key] = $saved.$key } }
    }
    catch { Write-Warning "Ignoring unreadable settings file: $($_.Exception.Message)" }
}

$form = New-FormWindow -Title 'Settings' -Size '420,300' -MinimumSize '420,300' -BorderStyle FixedDialog `
    -Property @{ MaximizeBox = $false; MinimizeBox = $false }

$table = New-TablePanel -Columns 2 -Rows 4 -Dock Fill -Property @{ Padding = [System.Windows.Forms.Padding]::new(12) }
$userName = New-TextBox -Text $settings.UserName -Dock Top
$notify = New-CheckBox -Text 'Show notifications' -Checked:([bool]$settings.Notify)
$retries = New-NumericUpDown -Minimum 0 -Maximum 10 -Value ([int]$settings.Retries)
$mode = New-ComboBox -Item 'Fast', 'Balanced', 'Thorough' -Dock Top
$mode.SelectedItem = $settings.Mode
if ($mode.SelectedIndex -lt 0) { $mode.SelectedIndex = 1 }

Add-FormControl -Parent $table -Control (New-Label -Text 'User name' -Dock Fill), $userName,
(New-Label -Text 'Notifications' -Dock Fill), $notify,
(New-Label -Text 'Retries' -Dock Fill), $retries,
(New-Label -Text 'Mode' -Dock Fill), $mode

$status = New-StatusStrip -Text 'Not saved'
$save = New-Button -Text 'Save' -OnClick {
    [ordered]@{
        UserName = $userName.Text; Notify = $notify.Checked; Retries = [int]$retries.Value; Mode = [string]$mode.SelectedItem
    } | ConvertTo-Json | Set-Content -LiteralPath $SettingsPath -Encoding UTF8
    $status.Items[0].Text = "Saved to $SettingsPath"
}
$close = New-Button -Text 'Close' -OnClick { $form.Close() }
$buttons = New-FlowPanel -Dock Bottom -Size '100,44' -FlowDirection RightToLeft
Add-FormControl -Parent $buttons -Control $close, $save

Add-FormControl -Parent $form -Control $table, $buttons, $status
Show-FormWindow -Form $form | Out-Null
