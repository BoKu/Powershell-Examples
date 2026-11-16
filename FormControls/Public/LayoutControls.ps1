function New-FlowPanel {
    <#
    .SYNOPSIS
    Creates a FlowLayoutPanel that arranges children in a row or column. No pixel positions needed.
    .EXAMPLE
    $bar = New-FlowPanel -Dock Bottom -Size '0,40' -FlowDirection RightToLeft
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.FlowLayoutPanel])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '300,100',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [System.Windows.Forms.FlowDirection] $FlowDirection = 'LeftToRight',
        [switch] $NoWrap, [switch] $AutoScroll,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.FlowLayoutPanel]::new()
    $control.Size = $Size
    $control.FlowDirection = $FlowDirection
    $control.WrapContents = -not $NoWrap
    $control.AutoScroll = $AutoScroll
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-TablePanel {
    <#
    .SYNOPSIS
    Creates a TableLayoutPanel with equal-width columns and equal-height rows.
    .EXAMPLE
    $table = New-TablePanel -Columns 2 -Rows 3 -Dock Fill
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.TableLayoutPanel])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '300,200',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [ValidateRange(1, 50)] [int] $Columns = 2,
        [ValidateRange(1, 50)] [int] $Rows = 2,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.TableLayoutPanel]::new()
    $control.Size = $Size
    $control.ColumnCount = $Columns
    $control.RowCount = $Rows
    for ($i = 0; $i -lt $Columns; $i++) {
        $null = $control.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new('Percent', 100 / $Columns))
    }
    for ($i = 0; $i -lt $Rows; $i++) {
        $null = $control.RowStyles.Add([System.Windows.Forms.RowStyle]::new('Percent', 100 / $Rows))
    }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}

function New-TabControl {
    <#
    .SYNOPSIS
    Creates a TabControl with one page per -Page name. Reach a page with $tab.TabPages['Name'].
    .EXAMPLE
    $tab = New-TabControl -Page 'General', 'Advanced' -Dock Fill
    #>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.TabControl])]
    param(
        [System.Drawing.Point] $Location, [System.Drawing.Size] $Size = '400,250',
        [System.Windows.Forms.DockStyle] $Dock, [System.Windows.Forms.AnchorStyles] $Anchor, [string] $Name,
        [Parameter(Mandatory)] [string[]] $Page,
        [hashtable] $Property
    )
    $control = [System.Windows.Forms.TabControl]::new()
    $control.Size = $Size
    foreach ($title in $Page) {
        $tabPage = [System.Windows.Forms.TabPage]::new($title)
        $tabPage.Name = $title
        $tabPage.Padding = [System.Windows.Forms.Padding]::new(8)
        $control.TabPages.Add($tabPage)
    }
    Set-ControlCommon -Control $control -Bound $PSBoundParameters
}
