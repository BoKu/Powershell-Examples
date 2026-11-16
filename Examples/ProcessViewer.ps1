#Requires -Version 5.1
<#
.SYNOPSIS
Filterable process list with a refresh button, menu and tray icon.
#>
[CmdletBinding()]
param()

Import-Module (Join-Path $PSScriptRoot '..\FormControls\FormControls.psd1') -Force

function Get-ProcessRow {
    Get-Process | Sort-Object WorkingSet64 -Descending |
        Select-Object Name, Id, @{ n = 'MemoryMB'; e = { [int]($_.WorkingSet64 / 1MB) } }, @{ n = 'Threads'; e = { $_.Threads.Count } }
}

$form = New-FormWindow -Title 'Process Viewer' -Size '760,520' -IconPath (Join-Path $PSScriptRoot '..\FormControls\Default.ico')
$grid = New-DataGrid -Dock Fill
$status = New-StatusStrip
$filter = New-TextBox -PlaceholderText 'Filter by name' -Dock Fill

$refresh = {
    $rows = Get-ProcessRow
    if ($filter.Text) { $rows = $rows | Where-Object { $_.Name -like "*$($filter.Text)*" } }
    $grid.DataSource = $rows | ConvertTo-DataTable
    $status.Items[0].Text = "$(@($rows).Count) processes at $(Get-GeneralValue -Type TimeLong)"
}
$filter.add_TextChanged($refresh)

$top = New-TablePanel -Columns 2 -Rows 1 -Dock Top -Size '100,36'
$top.ColumnStyles.Clear()
$null = $top.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new('Percent', 100))
$null = $top.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new('Absolute', 110))
Add-FormControl -Parent $top -Control $filter, (New-Button -Text 'Refresh' -Dock Fill -OnClick $refresh)

$menu = New-MenuStrip -Menu ([ordered]@{ File = [ordered]@{ Refresh = $refresh; '-1' = $null; Exit = { $form.Close() } } })
$tray = New-NotifyIcon -Text 'Process Viewer' -Menu @{ Quit = { $form.Close() } }

Add-FormControl -Parent $form -Control $grid, $top, $status, $menu
$form.add_Shown($refresh)
Show-FormWindow -Form $form -Cleanup $tray | Out-Null
