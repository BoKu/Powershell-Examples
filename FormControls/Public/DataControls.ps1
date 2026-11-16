function ConvertTo-DataTable {
    <#
    .SYNOPSIS
    Converts objects to a DataTable (one column per property of the first object) for grid binding.
    .EXAMPLE
    Get-Process | Select-Object Name, Id, CPU | ConvertTo-DataTable
    #>
    [CmdletBinding()]
    [OutputType([System.Data.DataTable])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)] [AllowNull()] [psobject] $InputObject
    )
    begin {
        $table = [System.Data.DataTable]::new()
        $columns = $null
    }
    process {
        if ($null -eq $InputObject) { return }
        if ($null -eq $columns) {
            $columns = @($InputObject.PSObject.Properties | ForEach-Object Name)
            foreach ($name in $columns) { $null = $table.Columns.Add($name, [string]) }
        }
        $row = $table.NewRow()
        foreach ($name in $columns) {
            $value = $InputObject.PSObject.Properties[$name].Value
            $row[$name] = if ($null -eq $value) { '' } else { [string]$value }
        }
        $table.Rows.Add($row)
    }
    end {
        # The leading comma stops PowerShell from unrolling the DataTable into rows.
        , $table
    }
}

function New-DataGrid {
    <#
    .SYNOPSIS
    Creates a DataGridView bound to -Data (any objects). Values are shown as text; sort by clicking a header.
    .EXAMPLE
    $grid = New-DataGrid -Data (Get-Process | Select-Object Name, Id) -Dock Fill
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DataGridView])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '400,200',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [object[]] $Data,
        [switch] $AllowEdit,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.DataGridView]::new()
    $control.Size = $Size
    $control.ReadOnly = -not $AllowEdit
    $control.AllowUserToAddRows = $false
    $control.AllowUserToDeleteRows = $false
    $control.RowHeadersVisible = $false
    $control.SelectionMode = 'FullRowSelect'
    $control.AutoSizeColumnsMode = 'Fill'
    if ($Data) { $control.DataSource = $Data | ConvertTo-DataTable }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-ListView {
    <#
    .SYNOPSIS
    Creates a details-view ListView. Each -Data object fills the columns named in -Column from its properties.
    .EXAMPLE
    New-ListView -Column Name, Length -Data (Get-ChildItem -File)
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ListView])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '400,200',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [Parameter(Mandatory)] [string[]] $Column,
        [object[]] $Data,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.ListView]::new()
    $control.View = 'Details'
    $control.FullRowSelect = $true
    $control.GridLines = $true
    $control.Size = $Size
    foreach ($name in $Column) { $null = $control.Columns.Add($name, 150) }
    foreach ($row in $Data) {
        $values = foreach ($name in $Column) {
            $value = $row.PSObject.Properties[$name].Value
            if ($null -eq $value) { '' } else { [string]$value }
        }
        $null = $control.Items.Add([System.Windows.Forms.ListViewItem]::new([string[]]@($values)))
    }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-TreeView {
    <#
    .SYNOPSIS
    Creates a TreeView from nested hashtables (keys are nodes), arrays and scalars (leaf nodes).
    .EXAMPLE
    New-TreeView -Data ([ordered]@{ Fruit = 'Apple', 'Pear'; Veg = @{ Root = 'Carrot' } })
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.TreeView])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '250,200',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [System.Collections.IDictionary] $Data,
        [switch] $ExpandAll,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.TreeView]::new()
    $control.Size = $Size
    if ($Data) { Add-TreeNodeData -Parent $control.Nodes -Data $Data }
    if ($ExpandAll) { $control.ExpandAll() }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}
