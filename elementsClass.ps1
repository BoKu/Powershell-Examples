<#
# Author: BoKu
# License: MIT License
# Copyright (c) 2024 BoKu
#>
#Requires -Version 5.1

Add-Type -AssemblyName System.Windows.Forms -PassThru | Out-Null
Add-Type -AssemblyName System.Drawing -PassThru | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()

class FormControl : System.Windows.Forms.Form {
    # Class Properties
    [string] $Text_String = "Form1"
    [int] $Width_Int = 800
    [int] $WidthMin_Int = 640
    [int] $WidthMax_Int = 1024
    [int] $Height_Int = 500
    [int] $HeightMin_Int = 320
    [int] $HeightMax_Int = 768
    [bool] $ShowIcon_Bool = $true
    [bool] $ShowInTaskbar_Bool = $true
    [System.Windows.Forms.FormStartPosition] $StartPosition_ = [System.Windows.Forms.FormStartPosition]::WindowsDefaultLocation
    [System.Windows.Forms.FormBorderStyle] $BorderStyle_ = [System.Windows.Forms.FormBorderStyle]::Sizable
    [bool] $TopMost_Bool = $false
    [string] $IconPath_String = "$PSScriptRoot\\Default.ico"
    hidden [System.Windows.Forms.Application] $EnableVisualStyles_ = [System.Windows.Forms.Application]::EnableVisualStyles()
    
    # Default constructor
    FormControl(
        [string] $Text_String, `
            [int] $Width_Int, [int] $Height_Int, [int] $WidthMin_Int, [int] $HeightMin_Int, [int] $WidthMax_Int, [int] $HeightMax_Int, `
            [bool] $ShowIcon_Bool, [bool] $ShowInTaskbar_Bool, [System.Windows.Forms.FormStartPosition] $StartPosition_, `
            [System.Windows.Forms.FormBorderStyle] $BorderStyle_, [bool] $TopMost_Bool, [string] $IconPath_String) {

        $this.Text = $Text_String
        $this.MinimumSize = New-Object System.Drawing.Size ($WidthMin_Int, $HeightMin_Int)
        $this.MaximumSize = New-Object System.Drawing.Size ($WidthMax_Int, $HeightMax_Int)
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.ShowIcon = $ShowIcon_Bool
        $this.ShowInTaskbar = $ShowInTaskbar_Bool
        $this.StartPosition = $StartPosition_
        $this.FormBorderStyle = $BorderStyle_
        $this.TopMost = $TopMost_Bool
        $this.Icon = New-Object System.Drawing.Icon($IconPath_String)  # Set the icon
        $this.Add_Shown()
    }

    # Method to Add_Shown
    [void] Add_Shown() {
        $this.Activate()
    }

    # Method to Add Controls
    [void] AddRange( $NewControls ) {
        $this.Controls.AddRange(@($NewControls))
    }
}

class LabelControl : System.Windows.Forms.Label {
    # Class Properties
    [string] $Text_String = "Label1"
    [int] $X_int = 10
    [int] $Y_Int = 10
    [bool] $AutoSize_Bool = $true
    [string] $FontName_String = "Segoe UI"
    [int] $FontSize_Int = 9
    [System.Drawing.FontStyle] $FontStyle_ = [System.Drawing.FontStyle]::Regular
    [bool] $Visible_Bool = $true
    
    # Default constructor
    LabelControl(
        [string] $Text_String, [int] $X_int, [int] $Y_Int, [bool] $AutoSize_Bool, [string] $FontName_String, `
            [int] $FontSize_Int, [System.Drawing.FontStyle] $FontStyle_, [bool] $Visible_Bool
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_int, $Y_Int)
        $this.Font = [System.Drawing.Font]::New($FontName_String, $FontSize_Int, [System.Drawing.FontStyle] $FontStyle_)
        $this.AutoSize = $AutoSize_Bool
        $this.Visible = $Visible_Bool
    }
}
class ButtonControl : System.Windows.Forms.Button {
    # Class Properties
    [string] $Text_String = "Button1"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 70
    [int] $Height_Int = 22
    [bool] $TabStop_Bool = $true
    [System.Windows.Forms.Cursor] $Cursor_ = [System.Windows.Forms.Cursors]::Hand
    [bool] $Visible_Bool = $true

    # Default constructor
    ButtonControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, `
            [System.Windows.Forms.Cursor] $Cursor_, [bool] $Visible_Bool
    ) {
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Cursor = $Cursor_
        $this.Text = $Text_String
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.TabStop = $TabStop_Bool
        $this.Visible = $Visible_Bool
    }
}

class ComboBoxControl : System.Windows.Forms.ComboBox {
    # Class Properties

    # Default constructor
    ComboBoxControl(

    ) {}
}
