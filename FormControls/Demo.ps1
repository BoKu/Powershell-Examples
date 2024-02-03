<#
# Author: BoKu
# License: MIT License
# Copyright (c) 2024 BoKu
#>
#Requires -Version 5.1
Add-Type -AssemblyName System.Windows.Forms -PassThru | Out-Null
Add-Type -AssemblyName System.Drawing -PassThru | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()

<##################################################>

# Clear Console
Clear-Host

<##################################################>

# Import Required Modules
'libEnums.ps1', "libFunctions.ps1", "elementsClass.ps1" | ForEach-Object {
    $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($_)
    if (Get-Module -Name $moduleName) { Remove-Module -Name $moduleName -Force }
    # Reimport Modules
    $importModule = $PSScriptRoot + "\\" + $_
    Import-Module -Name $importModule -Force
}

<##################################################>

# Create Form and Controls
$form1 = [FormControl]::New("DEMO FORM", 800, 500, 640, 320, 1024, 768, $true, $true, "CenterScreen", "Sizable", $false, "Default.ico")

<##################################################>

$label1 = [LabelControl]::New("Label Control", 10, 10, $true, "Segoe UI", 9, "Regular", $true, $false, 0)

$guid = GeneralValue("guid")
$label2 = [LabelControl]::New("GUID:    $guid", 220, 10, $true, "Segoe UI", 9, "Regular", $true, $false, 0)

$clock = GeneralValue("datetimeshort")
$label3 = [LabelControl]::New("DateTimeShort:    $clock", 640, 10, $true, "Segoe UI", 9, "Regular", $true, $false, 0)

$linklabel1 = [LinkLabelControl]::New("Go to GitHub page", "https://github.com/BoKu/", 650, 230, $true, "Segoe UI", 12, "Regular", $true, $true, 0)

# Create a new timer
$timer1 = [System.Windows.Forms.Timer]::New() 
$timer1.Enabled = $false
# Define the event handler for the timer tick event
$timer1.Add_Tick({
        $clock = GeneralValue("datetimeshort")
        $label3.Text = "DateTimeShort:    $clock"
    })

# Add Label Controls to Form
$form1.AddControls(@($label1, $label2, $label3, $linklabel1))

<##################################################>

$button1 = [ButtonControl]::New("Button Shows a MessageBox", 10, 40, 200, 22, $true, 0, "Hand", $true)
$button1.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("This is the simplest way to get a MessageBox working", "Demo MessageBox", "OKCancel", "Information", "Button1")
    })

# Add Button Controls to Form
$form1.AddControls(@($button1))

<##################################################>

$textbox1 = [TextBoxControl]::New("Normal TextBox with string of text", 220, 40, 200, 22, $true, 0, "Hand", $true, $false, $true)
$textbox2 = [TextBoxControl]::New("ReadOnly TextBox with string of text", 430, 40, 200, 22, $true, 0, "Hand", $true, $true, $true)
$textbox3 = [TextBoxControl]::New("Disabled TextBox with string of text", 640, 40, 200, 22, $true, 0, "Hand", $true, $true, $false)

# Add Controls to Form
$form1.AddControls(@($textbox1, $textbox2, $textbox3))

<##################################################>

$comboBoxDataSource = [System.Collections.ArrayList]@("Dropdown", "DropDownList", "Simple", `
        "Item 0", "Item 1", "Item 2", "Item 3", "Item 4", `
        "Item 5", "Item 6", "Item 7", "Item 8", "Item 9")

$combobox1 = [ComboBoxControl]::New("ComboBox - Dropdown", 10, 70, 200, 22, $true, 1, 5, "Hand", $true, $false, "DropDown", 100)
$combobox1.DataSource = @() + $comboBoxDataSource

$combobox2 = [ComboBoxControl]::New("ComboBox - DropDownList", 220, 70, 200, 22, $true, 1, 5, "Hand", $true, $false, "DropDownList", 100)
$combobox2.DataSource = @() + $comboBoxDataSource

$combobox3 = [ComboBoxControl]::New("ComboBox - Simple", 430, 70, 200, 120, $true, 1, 5, "Hand", $true, $false, "Simple", 100)
$combobox3.DataSource = @() + $comboBoxDataSource

# Add Controls to Form
$form1.AddControls(@($combobox1, $combobox2, $combobox3))

<##################################################>

$groupbox1 = [GroupBoxControl]::New("GroupBox", 10, 100, 410, 92, $true, 0, $true, $true)

$radioButton1 = [RadioButtonControl]::New("Radio Button 1", 10, 15, 150, 20, $true, 0, $true, $true, [eChecked]::checked, "MiddleLeft", "MiddleLeft")
$radioButton2 = [RadioButtonControl]::New("Radio Button 2", 10, 40, 150, 20, $true, 0, $true, $true, [eChecked]::unchecked, "MiddleCenter", "MiddleCenter")
$radioButton3 = [RadioButtonControl]::New("Radio Button 3", 10, 65, 150, 20, $true, 0, $true, $true, [eChecked]::unchecked, "MiddleRight", "MiddleRight")

$checkbox1 = [CheckBoxControl]::New("CheckBox 1", 200, 15, 150, 20, $true, 0, $true, $true, [eCheckState]::unchecked, "MiddleRight", $false, "MiddleRight")
$checkbox2 = [CheckBoxControl]::New("CheckBox 2", 200, 40, 150, 20, $true, 0, $true, $true, [eCheckState]::indeterminate, "MiddleCenter", $false, "MiddleCenter")
$checkbox3 = [CheckBoxControl]::New("CheckBox 3", 200, 65, 150, 20, $true, 0, $true, $true, [eCheckState]::checked, "MiddleLeft", $true, "MiddleLeft")

# Add Controls to GroupBox
$groupbox1.AddControls(@($radioButton1, $radioButton2, $radioButton3, $checkbox1, $checkbox2, $checkbox3))

# Add Controls to Form
$form1.AddControls(@($groupbox1))

<##################################################>

<#
$picturebox1 = [PictureBoxControl]::New("Z:\OneDrive\Documents\WindowsPowerShell\Default.png", 640, 70, 200, 200, $true, $false, 0, $true, [eBorder]::fixedSingle, `
        [eSizeMode]::stretchImage)
#>

$pictureBox = [PictureBoxControl]::New("https://avatars.githubusercontent.com/u/6552986", 640, 70, 200, 120, [eSizeMode]::zoom)

# Add Controls to Form
$form1.AddControls(@($pictureBox))

<##################################################>

#Show the main Form
$form1.Show()

#Adjust controls for demo purposes
$form1.Width = 870
$combobox1.SelectedIndex = 0
$combobox2.SelectedIndex = 1
$combobox3.SelectedIndex = 2

<##################################################>

# Keep the Script running until the Form is Closed
while ($form1.Created) {
    HideConsoleWindows
    Start-Sleep -Milliseconds 10
    [System.Windows.Forms.Application]::DoEvents()
}

$form1.Close()