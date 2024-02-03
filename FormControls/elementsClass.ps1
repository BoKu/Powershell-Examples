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
        $this.Add_FormClosing()
        $this.Add_FormClosing()
    }

    # Method to Add_Shown
    [void] Add_Shown() {
        Write-Host "Loading..." -ForegroundColor Yellow
        $this.Activate()
    }

    # Method to Add_FormClosing
    [void] Add_FormClosing() {
        $this.Add_FormClosing({
                $this.Dispose()
                Write-Host "Unloading" -ForegroundColor Yellow
            })
    }

    # Method to Add Controls    
    [void] AddControls([System.Windows.Forms.Control[]] $controls) {
        foreach ($control in $controls) {
            $this.Controls.Add($control)
        }
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
    [bool] $TabStop_Bool = $false
    [int] $TabIndex_Int = 0
    
    # Default constructor
    LabelControl(
        [string] $Text_String, [int] $X_int, [int] $Y_Int, [bool] $AutoSize_Bool, [string] $FontName_String, `
            [int] $FontSize_Int, [System.Drawing.FontStyle] $FontStyle_, [bool] $Visible_Bool, [bool] $TabStop_Bool, [int] $TabIndex_Int
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_int, $Y_Int)
        $this.Font = [System.Drawing.Font]::New($FontName_String, $FontSize_Int, [System.Drawing.FontStyle] $FontStyle_)
        $this.AutoSize = $AutoSize_Bool
        $this.Visible = $Visible_Bool
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
    }
}
class LinkLabelControl : System.Windows.Forms.LinkLabel {
    # Class Properties
    [string] $Text_String = "GitHub Page"
    [string] $Link_String = "https://github.com/BoKu/"
    [int] $X_int = 10
    [int] $Y_Int = 10
    [bool] $AutoSize_Bool = $true
    [string] $FontName_String = "Segoe UI"
    [int] $FontSize_Int = 9
    [System.Drawing.FontStyle] $FontStyle_ = [System.Drawing.FontStyle]::Regular
    [bool] $Visible_Bool = $true
    [bool] $TabStop_Bool = $true
    [int] $TabIndex_Int = 0
    
    # Default constructor
    LinkLabelControl(
        [string] $Text_String, [string] $Link_String, [int] $X_int, [int] $Y_Int, [bool] $AutoSize_Bool, [string] $FontName_String, `
            [int] $FontSize_Int, [System.Drawing.FontStyle] $FontStyle_, [bool] $Visible_Bool, [bool] $TabStop_Bool, [int] $TabIndex_Int
    ) {
        $this.Text = $Text_String
        $this.Links.Add(0, $Link_String.Length, $Link_String)
        $this.Location = New-Object System.Drawing.Point($X_int, $Y_Int)
        $this.AutoSize = $AutoSize_Bool
        $this.Font = [System.Drawing.Font]::New($FontName_String, $FontSize_Int, [System.Drawing.FontStyle] $FontStyle_)
        $this.Visible = $Visible_Bool
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
        $this.Add_LinkClicked({$this.LinkClickHandler($e)})
    }

    [void] LinkClickHandler([System.Windows.Forms.LinkLabelLinkClickedEventArgs]$e){
        if ($null -ne $this.Links[0].LinkData) {
            $this.Links[0].Visited = $true
            $linkPath = $this.Links[0].LinkData.ToString()
            Start-Process $linkPath
        }
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
    [int] $TabIndex_Int = 0
    [System.Windows.Forms.Cursor] $Cursor_ = [System.Windows.Forms.Cursors]::Hand
    [bool] $Visible_Bool = $true

    # Default constructor
    ButtonControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, [int] $TabIndex_Int, `
            [System.Windows.Forms.Cursor] $Cursor_, [bool] $Visible_Bool
    ) {
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Cursor = $Cursor_
        $this.Text = $Text_String
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
        $this.Visible = $Visible_Bool
    }
}

class ComboBoxControl : System.Windows.Forms.ComboBox {
    # Class Properties
    [string] $Text_String = "ComboBox1"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 70
    [int] $Height_Int = 22
    [bool] $TabStop_Bool = $true
    [int] $TabIndex_Int = 0
    [int] $MaxDropDownItems_Int = 5
    [System.Windows.Forms.Cursor] $Cursor_ = [System.Windows.Forms.Cursors]::Hand
    [bool] $Visible_Bool = $true
    [bool] $Sorted_Bool = $false
    [System.Windows.Forms.ComboBoxStyle] $ComboBoxStyle_ = [System.Windows.Forms.ComboBoxStyle]::DropDown
    [int] $DropDownHeight_Int = 20

    # Default constructor
    ComboBoxControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, [int] $TabIndex_Int, `
            [int] $MaxDropDownItems_Int, [System.Windows.Forms.Cursor] $Cursor_, [bool] $Visible_Bool, [bool] $Sorted_Bool, `
            [System.Windows.Forms.ComboBoxStyle] $ComboBoxStyle_, [int] $DropDownHeight_Int
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Cursor = $Cursor_
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
        $this.Visible = $Visible_Bool
        $this.MaxDropDownItems = $MaxDropDownItems_Int
        $this.Sorted = $Sorted_Bool
        $this.DropDownStyle = $ComboBoxStyle_
        $this.DropDownHeight = $DropDownHeight_Int
    }
}

class TextBoxControl : System.Windows.Forms.TextBox {
    # Class Properties
    [string] $Text_String = "TextBox1"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 70
    [int] $Height_Int = 22
    [bool] $TabStop_Bool = $true
    [int] $TabIndex_Int = 0
    [System.Windows.Forms.Cursor] $Cursor_ = [System.Windows.Forms.Cursors]::Pointer
    [bool] $Visible_Bool = $true
    [bool] $ReadOnly_Bool = $false
    [bool] $Enabled_Bool = $true

    # Default constructor
    TextBoxControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, [int] $TabIndex_Int, `
            [System.Windows.Forms.Cursor] $Cursor_, [bool] $Visible_Bool, [bool] $ReadOnly_Bool, [bool] $Enabled_Bool
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Cursor = $Cursor_
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
        $this.Visible = $Visible_Bool
        $this.ReadOnly = $ReadOnly_Bool
        $this.Enabled = $Enabled_Bool
    }
}

class GroupBoxControl : System.Windows.Forms.GroupBox {
    # Class Properties
    [string] $Text_String = "GroupBox1"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 70
    [int] $Height_Int = 22
    [bool] $TabStop_Bool = $true
    [int] $TabIndex_Int = 0
    [bool] $Visible_Bool = $true
    [bool] $Enabled_Bool = $true

    # Default constructor
    GroupBoxControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, [int] $TabIndex_Int, `
            [bool] $Visible_Bool, [bool] $Enabled_Bool
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.Enabled = $Enabled_Bool
    }

    [void] AddControls([System.Windows.Forms.Control[]] $controls) {
        foreach ($control in $controls) {
            $this.Controls.Add($control)
        }
    }
}

class RadioButtonControl : System.Windows.Forms.RadioButton {
    # Class Properties
    [string] $Text_String = "RadioButton1"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 70
    [int] $Height_Int = 22
    [bool] $TabStop_Bool = $true
    [int] $TabIndex_Int = 0
    [bool] $Visible_Bool = $true
    [bool] $Enabled_Bool = $true
    [bool] $Checked_Bool = $false
    [System.Drawing.ContentAlignment] $CheckAlign_ = [System.Drawing.ContentAlignment]::MiddleLeft
    [System.Drawing.ContentAlignment] $TextAlign_ = [System.Drawing.ContentAlignment]::MiddleLeft

    # Default constructor
    RadioButtonControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, [int] $TabIndex_Int, `
            [bool] $Visible_Bool, [bool] $Enabled_Bool, [bool] $Checked_Bool, [System.Drawing.ContentAlignment] $CheckAlign_, `
            [System.Drawing.ContentAlignment] $TextAlign_
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.Enabled = $Enabled_Bool
        $this.Checked = $Checked_Bool
        $this.CheckAlign = $CheckAlign_
        $this.TextAlign = $TextAlign_
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
        $this.Visible = $Visible_Bool
    }
}

class CheckBoxControl : System.Windows.Forms.CheckBox {
    # Class Properties
    [string] $Text_String = "CheckBox1"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 70
    [int] $Height_Int = 22
    [bool] $TabStop_Bool = $true
    [int] $TabIndex_Int = 0
    [bool] $Visible_Bool = $true
    [bool] $Enabled_Bool = $true
    [System.Windows.Forms.CheckState] $CheckState_ = [System.Windows.Forms.CheckState]::Unchecked
    [System.Drawing.ContentAlignment] $CheckAlign_ = [System.Drawing.ContentAlignment]::MiddleLeft
    [System.Drawing.ContentAlignment] $TextAlign_ = [System.Drawing.ContentAlignment]::MiddleLeft

    # Default constructor
    CheckBoxControl(
        [string] $Text_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [bool] $TabStop_Bool, [int] $TabIndex_Int, `
            [bool] $Visible_Bool, [bool] $Enabled_Bool, [System.Windows.Forms.CheckState] $CheckState_, [System.Drawing.ContentAlignment] $CheckAlign_, `
            [bool] $ThreeState_Bool, [System.Drawing.ContentAlignment] $TextAlign_
    ) {
        $this.Text = $Text_String
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Width = $Width_Int
        $this.Height = $Height_Int
        $this.Enabled = $Enabled_Bool
        $this.CheckState = $CheckState_
        $this.CheckAlign = $CheckAlign_
        $this.ThreeState = $ThreeState_Bool
        $this.TextAlign = $TextAlign_
        $this.TabStop = $TabStop_Bool
        $this.TabIndex = $TabIndex_Int
        $this.Visible = $Visible_Bool
    }
}

class PictureBoxControl : System.Windows.Forms.PictureBox {
    # Class Properties
    [string] $ImagePath_String = "https://avatars.githubusercontent.com/u/6552986"
    [int] $X_Int = 10
    [int] $Y_Int = 10
    [int] $Width_Int = 200
    [int] $Height_Int = 200
    [System.Windows.Forms.PictureBoxSizeMode] $SizeMode_ = [System.Windows.Forms.PictureBoxSizeMode]::Normal

    PictureBoxControl([string] $ImagePath_String, [int] $X_Int, [int] $Y_Int, [int] $Width_Int, [int] $Height_Int, [System.Windows.Forms.PictureBoxSizeMode] $SizeMode_
    ) {
        $this.Location = New-Object System.Drawing.Point($X_Int, $Y_Int)
        $this.Size = New-Object System.Drawing.Size($Width_Int, $Height_Int)
        $this.Load($ImagePath_String)
        $this.SizeMode = $SizeMode_
    }
}
