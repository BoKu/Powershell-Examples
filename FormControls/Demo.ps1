<#
# Author: BoKu
# License: MIT License
# Copyright (c) 2024 BoKu
#>
#Requires -Version 5.1
Add-Type -AssemblyName System.Windows.Forms -PassThru | Out-Null
Add-Type -AssemblyName System.Drawing -PassThru | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()

# Clear Console
Clear-Host
Write-Host "Loading..." -ForegroundColor Yellow

# Import Required Modules
'libEnums.ps1', "libFunctions.ps1", "elementsClass.ps1" | ForEach-Object {
    $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($_)
    if (Get-Module -Name $moduleName) { Remove-Module -Name $moduleName -Force }
    # Reimport Modules
    $importModule = $PSScriptRoot + "\\" + $_
    Import-Module -Name $importModule -Force
}

# Create Form and Controls
$form1 = [FormControl]::New("DEMO FORM", 800, 500, 640, 320, 1024, 768, $true, $true, "CenterScreen", "Sizable", $false, "Default.ico")

$label1 = [LabelControl]::New("Label 1", 10, 10, $true, "Segoe UI", 9, "Regular", $true)

$date = PseduoValue("datenow")
$labelDate = [LabelControl]::New("Date:    $date", 150, 10, $true, "Segoe UI", 9, "Regular", $true)

$button1 = [ButtonControl]::New("Button 1 Shows a Message", 10, 40, 200, 22, $true, "Hand", $true)
$button1.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("This is the simplest way to get a MessageBox working", "Demo MessageBox", "OKCancel", "Information", "Button1")
    })

# Add Controls to Form and Show Form
$form1.AddRange(@($label1, $labelDate, $button1))
$form1.Show()

# Keep the Script running until the Form is Closed
while ($form1.Created) {
    HideConsoleWindows
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.Application]::DoEvents()
}