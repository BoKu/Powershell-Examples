#Requires -Version 5.1
<#
.SYNOPSIS
Showcase of every FormControls control. Run on Windows: .\Demo.ps1 [-Theme Auto|Light|Dark]
#>
[CmdletBinding()]
param([ValidateSet('Auto', 'Light', 'Dark')] [string] $Theme = 'Auto')

Import-Module (Join-Path $PSScriptRoot '..\FormControls\FormControls.psd1') -Force

$icon = Join-Path $PSScriptRoot '..\FormControls\Default.ico'
$form = New-FormWindow -Title 'FormControls Demo' -Size '860,560' -IconPath $icon

# Menu and status bar
$status = New-StatusStrip -Text 'Ready'
$menu = New-MenuStrip -Menu ([ordered]@{
        File = [ordered]@{
            'New GUID' = { $status.Items[0].Text = 'GUID: ' + (Get-GeneralValue -Type Guid) }
            '-1'       = $null
            Exit       = { $form.Close() }
        }
        Help = @{ About = { [System.Windows.Forms.MessageBox]::Show('FormControls demo', 'About') | Out-Null } }
    })

# Tabs
$tabs = New-TabControl -Page 'Basics', 'Data', 'Layout' -Dock Fill

# --- Basics tab -----------------------------------------------------------
$basics = $tabs.TabPages['Basics']
$clock = New-Label -Text ('Time: ' + (Get-GeneralValue -Type TimeLong)) -Location '10,10'
$timer = [System.Windows.Forms.Timer]::new()
$timer.Interval = 1000
$timer.add_Tick({ $clock.Text = 'Time: ' + (Get-GeneralValue -Type TimeLong) })
$timer.Start()

$link = New-LinkLabel -Text 'Go to GitHub page' -Url 'https://github.com/BoKu' -Location '10,36'
$button = New-Button -Text 'MessageBox' -Location '10,66' -Size '120,28' -OnClick {
    [System.Windows.Forms.MessageBox]::Show('Simple MessageBox', 'Demo', 'OK', 'Information') | Out-Null
}
$text = New-TextBox -Text 'Editable' -Location '140,68' -PlaceholderText 'Type here'
$readOnly = New-TextBox -Text 'Read only' -Location '350,68' -ReadOnly
$combo = New-ComboBox -Item 'One', 'Two', 'Three' -SelectedIndex 0 -Location '10,106'
$number = New-NumericUpDown -Minimum 0 -Maximum 10 -Value 3 -Location '220,106'
$date = New-DateTimePicker -Location '310,106'
$progress = New-ProgressBar -Location '10,146' -Size '440,18' -Value 40
$slider = New-Button -Text 'Advance progress' -Location '10,174' -Size '140,28' -OnClick {
    $progress.Value = ($progress.Value + 10) % 101
    $status.Items[0].Text = "Progress: $($progress.Value)%"
}

$group = New-GroupBox -Text 'Options' -Location '10,214' -Size '440,100'
$r1 = New-RadioButton -Text 'Radio 1' -Location '12,24' -Checked
$r2 = New-RadioButton -Text 'Radio 2' -Location '12,50'
$c1 = New-CheckBox -Text 'Check 1' -Location '200,24' -Checked
$c2 = New-CheckBox -Text 'Three state' -Location '200,50' -ThreeState -CheckState Indeterminate
Add-FormControl -Parent $group -Control $r1, $r2, $c1, $c2

$picture = New-PictureBox -Path 'https://avatars.githubusercontent.com/u/6552986' -Location '480,10' -Size '140,140'
Add-FormControl -Parent $basics -Control $clock, $link, $button, $text, $readOnly, $combo, $number, $date, $progress, $slider, $group, $picture

$tip = New-ToolTip -Tip @{ $button = 'Shows a MessageBox'; $number = 'Pick a number' }

# --- Data tab -------------------------------------------------------------
$data = $tabs.TabPages['Data']
$grid = New-DataGrid -Dock Fill -Data (Get-Process | Sort-Object WorkingSet64 -Descending |
        Select-Object -First 25 Name, Id, @{ n = 'MemoryMB'; e = { [int]($_.WorkingSet64 / 1MB) } })
$tree = New-TreeView -Dock Left -Size '200,100' -ExpandAll -Data ([ordered]@{
        Fruit = 'Apple', 'Pear'
        Veg   = [ordered]@{ Root = 'Carrot', 'Beet'; Leaf = 'Kale' }
    })
Add-FormControl -Parent $data -Control $grid, $tree

# --- Layout tab -----------------------------------------------------------
$layout = $tabs.TabPages['Layout']
$buttons = New-FlowPanel -Dock Bottom -Size '100,44' -FlowDirection RightToLeft
Add-FormControl -Parent $buttons -Control (New-Button -Text 'Close' -OnClick { $form.Close() }), (New-Button -Text 'Apply')
$table = New-TablePanel -Columns 2 -Rows 2 -Dock Fill
Add-FormControl -Parent $table -Control (New-Label -Text 'Name:' -Dock Fill), (New-TextBox -Dock Top),
(New-Label -Text 'Role:' -Dock Fill), (New-ComboBox -Item 'Admin', 'User' -Dock Top)
Add-FormControl -Parent $layout -Control $table, $buttons

# Order matters for Dock: last added is laid out first.
Add-FormControl -Parent $form -Control $tabs, $status, $menu
Show-FormWindow -Form $form -Theme $Theme -Cleanup $timer, $tip | Out-Null
