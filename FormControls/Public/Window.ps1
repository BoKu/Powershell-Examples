function New-FormWindow {
    <#
    .SYNOPSIS
    Creates a DPI-aware Windows Form.
    .EXAMPLE
    $form = New-FormWindow -Title 'Demo' -Size '800,500' -IconPath .\Default.ico
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.Form])]
    param(
        [string] $Title = 'Form',
        [System.Drawing.Size] $Size = '800,500',
        [System.Drawing.Size] $MinimumSize = '640,320',
        [System.Drawing.Size] $MaximumSize = '0,0',
        [System.Windows.Forms.FormStartPosition] $StartPosition = 'CenterScreen',
        [System.Windows.Forms.FormBorderStyle] $BorderStyle = 'Sizable',
        [string] $IconPath,
        [switch] $TopMost,
        [switch] $HideFromTaskbar,
        [hashtable] $Property
    )
    $form = [System.Windows.Forms.Form]::new()
    $form.AutoScaleDimensions = [System.Drawing.SizeF]::new(96, 96)
    $form.AutoScaleMode = 'Dpi'
    $form.Font = [System.Drawing.SystemFonts]::MessageBoxFont
    $form.Text = $Title
    $form.Size = $Size
    $form.MinimumSize = $MinimumSize
    $form.MaximumSize = $MaximumSize
    $form.StartPosition = $StartPosition
    $form.FormBorderStyle = $BorderStyle
    $form.TopMost = $TopMost
    $form.ShowInTaskbar = -not $HideFromTaskbar
    if ($IconPath) {
        if (Test-Path -LiteralPath $IconPath -PathType Leaf) {
            $form.Icon = [System.Drawing.Icon]::new((Resolve-Path -LiteralPath $IconPath).ProviderPath)
        }
        else { Write-Warning "Icon not found: $IconPath" }
    }
    if ($Property) { foreach ($key in $Property.Keys) { $form.$key = $Property[$key] } }
    $form
}

function Show-FormWindow {
    <#
    .SYNOPSIS
    Applies a theme, shows the form modally and disposes it (and any -Cleanup objects) when it closes.
    .EXAMPLE
    Show-FormWindow -Form $form -Theme Dark -Cleanup $notifyIcon
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [System.Windows.Forms.Form] $Form,
        [ValidateSet('Auto', 'Light', 'Dark', 'None')] [string] $Theme = 'Auto',
        [switch] $HideConsole,
        [System.IDisposable[]] $Cleanup
    )
    try {
        if ($Theme -ne 'None') { Set-FormTheme -Control $Form -Theme $Theme }
        if ($HideConsole) { Hide-ConsoleWindow }
        $Form.ShowDialog()
    }
    finally {
        if ($HideConsole) { Hide-ConsoleWindow -Restore }
        foreach ($item in $Cleanup) { if ($item) { $item.Dispose() } }
        $Form.Dispose()
    }
}

function Add-FormControl {
    <#
    .SYNOPSIS
    Adds controls to a form, panel, group box, tab page, status strip or menu strip.
    .EXAMPLE
    Add-FormControl -Parent $form -Control $label, $button
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [System.Object] $Parent,
        [Parameter(Mandatory)] [System.Object[]] $Control
    )
    foreach ($item in $Control) {
        if ($Parent -is [System.Windows.Forms.ToolStrip]) { $null = $Parent.Items.Add($item) }
        elseif ($Parent -is [System.Windows.Forms.Control]) {
            $Parent.Controls.Add($item)
            if ($Parent -is [System.Windows.Forms.Form] -and $item -is [System.Windows.Forms.MenuStrip]) {
                $Parent.MainMenuStrip = $item
            }
        }
        else { throw "Cannot add controls to a $($Parent.GetType().Name)." }
    }
}

function Set-FormTheme {
    <#
    .SYNOPSIS
    Recolours a control tree with a light or dark palette. 'Auto' follows the Windows app theme.
    .EXAMPLE
    Set-FormTheme -Control $form -Theme Dark
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)] [System.Windows.Forms.Control] $Control,
        [ValidateSet('Auto', 'Light', 'Dark')] [string] $Theme = 'Auto'
    )
    process {
        $resolved = if ($Theme -eq 'Auto') { Get-SystemTheme } else { $Theme }
        $palette = Get-ThemePalette -Theme $resolved
        Set-ThemeRecursive -Control $Control -Palette $palette
        if ($Control -is [System.Windows.Forms.Form]) { Set-TitleBarTheme -Form $Control -Dark $palette.Dark }
    }
}
