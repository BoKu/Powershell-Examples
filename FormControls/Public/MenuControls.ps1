function New-MenuStrip {
    <#
    .SYNOPSIS
    Creates a MenuStrip from nested hashtables. A scriptblock value is a click action, a hashtable value is a submenu,
    and a key starting with '-' is a separator. Use [ordered] to keep the order.
    .EXAMPLE
    $menu = New-MenuStrip -Menu ([ordered]@{
        File = [ordered]@{ Open = { 'open' }; '-1' = $null; Exit = { $form.Close() } }
        Help = @{ About = { 'about' } }
    })
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.MenuStrip])]
    param(
        [Parameter(Mandatory)] [System.Collections.IDictionary] $Menu
    )
    $strip = [System.Windows.Forms.MenuStrip]::new()
    Add-MenuItemData -Items $strip.Items -Menu $Menu
    $strip
}

function New-StatusStrip {
    <#
    .SYNOPSIS
    Creates a StatusStrip with one label (Items[0]). Change the text with $strip.Items[0].Text.
    .EXAMPLE
    $status = New-StatusStrip -Text 'Ready'
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.StatusStrip])]
    param(
        [string] $Text = 'Ready'
    )
    $strip = [System.Windows.Forms.StatusStrip]::new()
    $label = [System.Windows.Forms.ToolStripStatusLabel]::new($Text)
    $label.Spring = $true
    $label.TextAlign = 'MiddleLeft'
    $null = $strip.Items.Add($label)
    $strip
}

function New-NotifyIcon {
    <#
    .SYNOPSIS
    Creates a tray icon with an optional context menu (same format as New-MenuStrip).
    Dispose it when done, for example with Show-FormWindow -Cleanup $icon.
    .EXAMPLE
    $icon = New-NotifyIcon -Text 'Demo' -Menu @{ Quit = { $form.Close() } }
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.NotifyIcon])]
    param(
        [string] $Text = 'Notification',
        [string] $IconPath,
        [System.Collections.IDictionary] $Menu
    )
    $notify = [System.Windows.Forms.NotifyIcon]::new()
    $notify.Text = $Text.Substring(0, [Math]::Min($Text.Length, 63))
    $notify.Icon = [System.Drawing.SystemIcons]::Application
    if ($IconPath) {
        if (Test-Path -LiteralPath $IconPath -PathType Leaf) {
            $notify.Icon = [System.Drawing.Icon]::new((Resolve-Path -LiteralPath $IconPath).ProviderPath)
        }
        else { Write-Warning "Icon not found: $IconPath" }
    }
    if ($Menu) {
        $context = [System.Windows.Forms.ContextMenuStrip]::new()
        Add-MenuItemData -Items $context.Items -Menu $Menu
        $notify.ContextMenuStrip = $context
    }
    $notify.Visible = $true
    $notify
}
