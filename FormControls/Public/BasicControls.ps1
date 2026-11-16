# Common parameters on every New-* function:
#   -Text, -Location '10,20', -Size '200,22', -Dock, -Anchor, -Name,
#   -Property @{ AnyWinFormsProperty = value }  (escape hatch for anything not exposed)

function New-Label {
    <#
    .SYNOPSIS
    Creates a Label.
    .EXAMPLE
    $label = New-Label -Text 'Hello' -Location '10,10'
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.Label])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size,
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [System.Drawing.ContentAlignment] $TextAlign = 'MiddleLeft',
        [switch] $FixedSize,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.Label]::new()
    $control.AutoSize = -not $FixedSize
    $control.TextAlign = $TextAlign
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-LinkLabel {
    <#
    .SYNOPSIS
    Creates a LinkLabel that opens an http(s) URL in the default browser. Other schemes are ignored.
    .EXAMPLE
    New-LinkLabel -Text 'GitHub' -Url 'https://github.com/BoKu'
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.LinkLabel])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size,
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [Parameter(Mandatory)] [uri] $Url,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.LinkLabel]::new()
    $control.AutoSize = $true
    if (-not $PSBoundParameters.ContainsKey('Text')) { $PSBoundParameters['Text'] = $Url.AbsoluteUri }
    $null = Set-ControlCommon -Control $control -Bound $PSBoundParameters
    $null = $control.Links.Add(0, $control.Text.Length, $Url.AbsoluteUri)
    $control.add_LinkClicked({
            param($sender, $e)
            $target = [uri]$e.Link.LinkData
            if ($target.Scheme -in 'http', 'https') {
                $e.Link.Visited = $true
                Start-Process -FilePath $target.AbsoluteUri
            }
        })
    $control
}

function New-Button {
    <#
    .SYNOPSIS
    Creates a Button. -OnClick takes a scriptblock.
    .EXAMPLE
    New-Button -Text 'Save' -Size '90,28' -OnClick { Write-Host 'Saved' }
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.Button])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '90,28',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [scriptblock] $OnClick,
        [System.Windows.Forms.DialogResult] $DialogResult = 'None',
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.Button]::new()
    $control.Cursor = [System.Windows.Forms.Cursors]::Hand
    $control.Size = $Size
    $control.DialogResult = $DialogResult
    if ($OnClick) { $control.add_Click($OnClick) }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-TextBox {
    <#
    .SYNOPSIS
    Creates a TextBox (single line, multiline, read-only or password).
    .EXAMPLE
    New-TextBox -Text 'Notes' -Multiline -Size '300,120'
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.TextBox])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '200,23',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [string] $PlaceholderText,
        [switch] $ReadOnly, [switch] $Multiline, [switch] $Password,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.TextBox]::new()
    $control.Size = $Size
    $control.ReadOnly = $ReadOnly
    $control.Multiline = $Multiline
    $control.UseSystemPasswordChar = $Password
    if ($Multiline) { $control.ScrollBars = 'Vertical' }
    # PlaceholderText exists on .NET Core / .NET 5+ (PowerShell 7) only.
    if ($PlaceholderText -and $null -ne $control.PSObject.Properties['PlaceholderText']) {
        $control.PlaceholderText = $PlaceholderText
    }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-ComboBox {
    <#
    .SYNOPSIS
    Creates a ComboBox filled with -Item.
    .EXAMPLE
    New-ComboBox -Item 'One', 'Two' -SelectedIndex 0 -Style DropDownList
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ComboBox])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '200,23',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [object[]] $Item,
        [int] $SelectedIndex = -1,
        [System.Windows.Forms.ComboBoxStyle] $Style = 'DropDownList',
        [switch] $Sorted,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.ComboBox]::new()
    $control.DropDownStyle = $Style
    $control.Sorted = $Sorted
    $control.Size = $Size
    if ($Item) { $control.Items.AddRange($Item) }
    $control.SelectedIndex = $SelectedIndex
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-CheckBox {
    <#
    .SYNOPSIS
    Creates a CheckBox. -ThreeState enables the indeterminate state.
    .EXAMPLE
    New-CheckBox -Text 'Enable logging' -Checked
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.CheckBox])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size,
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [switch] $Checked, [switch] $ThreeState,
        [System.Windows.Forms.CheckState] $CheckState,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.CheckBox]::new()
    $control.AutoSize = $true
    $control.ThreeState = $ThreeState
    $control.Checked = $Checked
    if ($PSBoundParameters.ContainsKey('CheckState')) { $control.CheckState = $CheckState }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-RadioButton {
    <#
    .SYNOPSIS
    Creates a RadioButton. Radio buttons in the same parent form one group.
    .EXAMPLE
    New-RadioButton -Text 'Option A' -Checked
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.RadioButton])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size,
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [switch] $Checked,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.RadioButton]::new()
    $control.AutoSize = $true
    $control.Checked = $Checked
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-GroupBox {
    <#
    .SYNOPSIS
    Creates a GroupBox. Add children with Add-FormControl.
    .EXAMPLE
    $group = New-GroupBox -Text 'Options' -Size '300,120'
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.GroupBox])]
    param(
        [string] $Text, [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '300,120',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.GroupBox]::new()
    $control.Size = $Size
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-PictureBox {
    <#
    .SYNOPSIS
    Creates a PictureBox from a file path or an http(s) URL. URLs load in the background so the UI does not freeze.
    .EXAMPLE
    New-PictureBox -Path 'https://avatars.githubusercontent.com/u/6552986' -Size '120,120' -SizeMode Zoom
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.PictureBox])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '120,120',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [string] $Path,
        [System.Windows.Forms.PictureBoxSizeMode] $SizeMode = 'Zoom',
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.PictureBox]::new()
    $control.Size = $Size
    $control.SizeMode = $SizeMode
    if ($Path) {
        if ($Path -match '^https?://') { $control.LoadAsync($Path) }
        elseif (Test-Path -LiteralPath $Path -PathType Leaf) { $control.Load((Resolve-Path -LiteralPath $Path).ProviderPath) }
        else { Write-Warning "Image not found: $Path" }
    }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-ProgressBar {
    <#
    .SYNOPSIS
    Creates a ProgressBar. Use -Style Marquee for an indeterminate bar.
    .EXAMPLE
    $bar = New-ProgressBar -Maximum 100 -Value 25
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ProgressBar])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '200,18',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [int] $Minimum = 0, [int] $Maximum = 100, [int] $Value = 0,
        [System.Windows.Forms.ProgressBarStyle] $Style = 'Continuous',
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.ProgressBar]::new()
    $control.Minimum = $Minimum
    $control.Maximum = $Maximum
    $control.Value = [Math]::Min([Math]::Max($Value, $Minimum), $Maximum)
    $control.Style = $Style
    $control.Size = $Size
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-NumericUpDown {
    <#
    .SYNOPSIS
    Creates a NumericUpDown spinner.
    .EXAMPLE
    New-NumericUpDown -Minimum 1 -Maximum 10 -Value 3
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.NumericUpDown])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '80,23',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [decimal] $Minimum = 0, [decimal] $Maximum = 100, [decimal] $Value = 0,
        [decimal] $Increment = 1, [int] $DecimalPlaces = 0,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.NumericUpDown]::new()
    $control.Minimum = $Minimum
    $control.Maximum = $Maximum
    $control.Increment = $Increment
    $control.DecimalPlaces = $DecimalPlaces
    $control.Value = [Math]::Min([Math]::Max($Value, $Minimum), $Maximum)
    $control.Size = $Size
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-DateTimePicker {
    <#
    .SYNOPSIS
    Creates a DateTimePicker.
    .EXAMPLE
    New-DateTimePicker -Format Short -Value (Get-Date)
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DateTimePicker])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '140,23',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [System.Windows.Forms.DateTimePickerFormat] $Format = 'Short',
        [datetime] $Value = (Get-Date),
        [switch] $ShowUpDown,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.DateTimePicker]::new()
    $control.Format = $Format
    $control.ShowUpDown = $ShowUpDown
    $control.Value = $Value
    $control.Size = $Size
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-ToolTip {
    <#
    .SYNOPSIS
    Creates a ToolTip and assigns text to controls. Keep the returned object alive (and pass it to Show-FormWindow -Cleanup).
    .EXAMPLE
    $tip = New-ToolTip -Tip @{ $button = 'Saves the file' }
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ToolTip])]
    param(
        [Parameter(Mandatory)] [hashtable] $Tip,
        [int] $InitialDelay = 400
    )
    $tooltip = [System.Windows.Forms.ToolTip]::new()
    $tooltip.InitialDelay = $InitialDelay
    foreach ($control in $Tip.Keys) { $tooltip.SetToolTip($control, [string]$Tip[$control]) }
    $tooltip
}
