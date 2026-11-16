function Set-ControlCommon {
    <#
    .SYNOPSIS
    Applies the shared parameters (Text, Location, Size, Dock, Anchor, Name, Property) to a control.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [System.Windows.Forms.Control] $Control,
        [Parameter(Mandatory)] [System.Collections.IDictionary] $Bound
    )
    foreach ($name in 'Text', 'Location', 'Size', 'Dock', 'Anchor', 'Name') {
        if ($Bound.Contains($name)) { $Control.$name = $Bound[$name] }
    }
    if ($Bound.Contains('Property') -and $Bound['Property']) {
        foreach ($key in $Bound['Property'].Keys) { $Control.$key = $Bound['Property'][$key] }
    }
    $Control
}

function Add-TreeNodeData {
    # Recursively turns nested hashtables / arrays / scalars into TreeNodes.
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Parent,
        [Parameter(Mandatory)] $Data
    )
    if ($Data -is [System.Collections.IDictionary]) {
        foreach ($key in $Data.Keys) {
            $node = $Parent.Add([string]$key)
            Add-TreeNodeData -Parent $node.Nodes -Data $Data[$key]
        }
    }
    elseif ($Data -is [System.Collections.IEnumerable] -and $Data -isnot [string]) {
        foreach ($item in $Data) { Add-TreeNodeData -Parent $Parent -Data $item }
    }
    elseif ($null -ne $Data) {
        $null = $Parent.Add([string]$Data)
    }
}

function Add-MenuItemData {
    # Recursively builds ToolStripMenuItems. Scriptblock = click action, hashtable = submenu, key starting with '-' = separator.
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Items,
        [Parameter(Mandatory)] [System.Collections.IDictionary] $Menu
    )
    foreach ($key in $Menu.Keys) {
        if ($key -like '-*') {
            $null = $Items.Add([System.Windows.Forms.ToolStripSeparator]::new())
            continue
        }
        $item = [System.Windows.Forms.ToolStripMenuItem]::new([string]$key)
        $value = $Menu[$key]
        if ($value -is [scriptblock]) { $item.add_Click($value) }
        elseif ($value -is [System.Collections.IDictionary]) { Add-MenuItemData -Items $item.DropDownItems -Menu $value }
        $null = $Items.Add($item)
    }
}
