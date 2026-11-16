function Get-SystemTheme {
    try {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
        $light = Get-ItemPropertyValue -Path $key -Name AppsUseLightTheme -ErrorAction Stop
        if ($light -eq 0) { return 'Dark' }
    }
    catch {
        Write-Verbose 'Could not read the Windows theme setting, using Light.'
    }
    'Light'
}

function Get-ThemePalette {
    param([ValidateSet('Light', 'Dark')] [string] $Theme)
    $c = { param($r, $g, $b) [System.Drawing.Color]::FromArgb($r, $g, $b) }
    if ($Theme -eq 'Dark') {
        @{ Back = & $c 32 32 32; Surface = & $c 45 45 45; Fore = & $c 240 240 240; Border = & $c 80 80 80; Link = & $c 90 200 140; Dark = $true }
    }
    else {
        @{ Back = & $c 243 243 243; Surface = & $c 255 255 255; Fore = & $c 20 20 20; Border = & $c 180 180 180; Link = & $c 0 102 204; Dark = $false }
    }
}

function Set-ToolStripItemTheme {
    param($Item, $Palette)
    $Item.BackColor = $Palette.Surface
    $Item.ForeColor = $Palette.Fore
    if ($Item -is [System.Windows.Forms.ToolStripDropDownItem]) {
        foreach ($child in $Item.DropDownItems) { Set-ToolStripItemTheme -Item $child -Palette $Palette }
    }
}

function Set-ThemeRecursive {
    param($Control, $Palette)
    $inputTypes = [System.Windows.Forms.TextBoxBase], [System.Windows.Forms.ComboBox], [System.Windows.Forms.ListBox],
    [System.Windows.Forms.ListView], [System.Windows.Forms.TreeView], [System.Windows.Forms.NumericUpDown]
    $isInput = $false
    foreach ($type in $inputTypes) { if ($Control -is $type) { $isInput = $true } }

    if ($Control -is [System.Windows.Forms.DataGridView]) {
        $Control.BackgroundColor = $Palette.Surface
        $Control.GridColor = $Palette.Border
        $Control.EnableHeadersVisualStyles = $false
        foreach ($style in $Control.DefaultCellStyle, $Control.ColumnHeadersDefaultCellStyle, $Control.RowHeadersDefaultCellStyle) {
            $style.BackColor = $Palette.Surface
            $style.ForeColor = $Palette.Fore
        }
    }
    elseif ($Control -is [System.Windows.Forms.Button]) {
        $Control.FlatStyle = 'Flat'
        $Control.FlatAppearance.BorderColor = $Palette.Border
        $Control.BackColor = $Palette.Surface
        $Control.ForeColor = $Palette.Fore
    }
    elseif ($Control -is [System.Windows.Forms.ToolStrip]) {
        $Control.BackColor = $Palette.Surface
        $Control.ForeColor = $Palette.Fore
        foreach ($item in $Control.Items) { Set-ToolStripItemTheme -Item $item -Palette $Palette }
    }
    elseif ($isInput) {
        $Control.BackColor = $Palette.Surface
        $Control.ForeColor = $Palette.Fore
    }
    else {
        $Control.BackColor = $Palette.Back
        $Control.ForeColor = $Palette.Fore
        if ($Control -is [System.Windows.Forms.LinkLabel]) {
            $Control.LinkColor = $Palette.Link
            $Control.VisitedLinkColor = $Palette.Link
        }
    }
    foreach ($child in $Control.Controls) { Set-ThemeRecursive -Control $child -Palette $Palette }
}

function Set-TitleBarTheme {
    # Dark title bar on Windows 10 1809+ / 11. Silently ignored where unsupported.
    param([System.Windows.Forms.Form] $Form, [bool] $Dark)
    Initialize-NativeMethod
    $value = [int]$Dark
    $apply = {
        param($eventSender, $e)
        $null = $e
        try { $null = [FormControls.NativeMethods]::DwmSetWindowAttribute($eventSender.Handle, 20, [ref]$value, 4) }
        catch { Write-Verbose 'Title bar theme not supported.' }
    }.GetNewClosure()
    if ($Form.IsHandleCreated) { & $apply $Form $null } else { $Form.add_HandleCreated($apply) }
}

function Initialize-NativeMethod {
    if (-not ('FormControls.NativeMethods' -as [type])) {
        Add-Type -Namespace FormControls -Name NativeMethods -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("dwmapi.dll")]
public static extern int DwmSetWindowAttribute(System.IntPtr hwnd, int attr, ref int value, int size);
[System.Runtime.InteropServices.DllImport("kernel32.dll")]
public static extern System.IntPtr GetConsoleWindow();
[System.Runtime.InteropServices.DllImport("user32.dll")]
public static extern bool ShowWindow(System.IntPtr hWnd, int nCmdShow);
'@
    }
}
