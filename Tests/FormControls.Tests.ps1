BeforeDiscovery {
    $script:OnWindows = $env:OS -eq 'Windows_NT'
}

Describe 'FormControls' -Skip:(-not $script:OnWindows) {
    BeforeAll {
        $script:ModuleRoot = Join-Path $PSScriptRoot '..\FormControls'
        Import-Module (Join-Path $script:ModuleRoot 'FormControls.psd1') -Force
    }

    It 'has a valid manifest' {
        { Test-ModuleManifest -Path (Join-Path $script:ModuleRoot 'FormControls.psd1') -ErrorAction Stop } | Should -Not -Throw
    }

    It 'exports exactly the functions listed in the manifest' {
        $manifest = Import-PowerShellDataFile (Join-Path $script:ModuleRoot 'FormControls.psd1')
        (Get-Command -Module FormControls).Name | Sort-Object | Should -Be ($manifest.FunctionsToExport | Sort-Object)
    }

    It 'has help for every exported function' {
        foreach ($command in Get-Command -Module FormControls) {
            (Get-Help $command.Name).Synopsis | Should -Not -BeNullOrEmpty -Because $command.Name
        }
    }

    Context 'Get-GeneralValue' {
        It 'returns a GUID by default' { [guid]::Parse((Get-GeneralValue)) | Should -BeOfType [guid] }
        It 'formats dates' { Get-GeneralValue -Type Date | Should -Match '^\d{4}-\d{2}-\d{2}$' }
        It 'formats short date and time' { Get-GeneralValue -Type DateTimeShort | Should -Match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$' }
        It 'returns a unix timestamp' { Get-GeneralValue -Type Unix | Should -Match '^\d{10}$' }
        It 'keeps random values in range' { Get-GeneralValue -Type Random -Minimum 5 -Maximum 8 | Should -BeIn 5, 6, 7 }
    }

    Context 'ConvertTo-DataTable' {
        It 'builds one row per object and one column per property' {
            $table = [pscustomobject]@{ A = 1; B = 'x' }, [pscustomobject]@{ A = 2; B = $null } | ConvertTo-DataTable
            $table | Should -BeOfType [System.Data.DataTable]
            $table.Rows.Count | Should -Be 2
            $table.Columns.Count | Should -Be 2
            $table.Rows[1]['B'] | Should -Be ''
        }
        It 'returns an empty table for no input' {
            @() | ConvertTo-DataTable | Should -BeOfType [System.Data.DataTable]
        }
    }

    Context 'Controls' {
        It 'creates a form' {
            $form = New-FormWindow -Title 'T' -Size '500,300'
            $form.Text | Should -Be 'T'
            $form.Size.Width | Should -Be 500
            $form.Dispose()
        }
        It 'applies common parameters' {
            $label = New-Label -Text 'Hi' -Location '5,6' -Name 'lbl'
            $label.Text | Should -Be 'Hi'
            $label.Location.X | Should -Be 5
            $label.Name | Should -Be 'lbl'
        }
        It 'applies the -Property escape hatch' {
            (New-Button -Text 'B' -Property @{ Enabled = $false }).Enabled | Should -BeFalse
        }
        It 'runs a button click scriptblock' {
            $script:clicked = $false
            $button = New-Button -Text 'B' -OnClick { $script:clicked = $true }
            $button.PerformClick()
            $script:clicked | Should -BeTrue
        }
        It 'clamps progress and numeric values' {
            (New-ProgressBar -Maximum 10 -Value 99).Value | Should -Be 10
            (New-NumericUpDown -Minimum 1 -Maximum 5 -Value 9).Value | Should -Be 5
        }
        It 'fills a combo box' {
            $combo = New-ComboBox -Item 'a', 'b' -SelectedIndex 1
            $combo.Items.Count | Should -Be 2
            $combo.SelectedItem | Should -Be 'b'
        }
        It 'binds a data grid' {
            $grid = New-DataGrid -Data ([pscustomobject]@{ A = 1 }, [pscustomobject]@{ A = 2 })
            $grid.Rows.Count | Should -Be 2
        }
        It 'builds a tree from nested data' {
            $tree = New-TreeView -Data ([ordered]@{ Top = [ordered]@{ Child = 'Leaf' } })
            $tree.Nodes[0].Text | Should -Be 'Top'
            $tree.Nodes[0].Nodes[0].Nodes[0].Text | Should -Be 'Leaf'
        }
        It 'builds a menu with actions and separators' {
            $menu = New-MenuStrip -Menu ([ordered]@{ File = [ordered]@{ Open = { }; '-1' = $null; Exit = { } } })
            $menu.Items[0].DropDownItems.Count | Should -Be 3
            $menu.Items[0].DropDownItems[1] | Should -BeOfType [System.Windows.Forms.ToolStripSeparator]
        }
        It 'adds controls to a form and sets the main menu' {
            $form = New-FormWindow
            $menu = New-MenuStrip -Menu @{ File = @{ Exit = { } } }
            Add-FormControl -Parent $form -Control (New-Label -Text 'x'), $menu
            $form.Controls.Count | Should -Be 2
            $form.MainMenuStrip | Should -Be $menu
            $form.Dispose()
        }
        It 'creates tab pages by name' {
            (New-TabControl -Page 'One', 'Two').TabPages['Two'] | Should -Not -BeNullOrEmpty
        }
        It 'stores the link target' {
            $link = New-LinkLabel -Text 'x' -Url 'https://example.com'
            $link.Links[0].LinkData | Should -Be 'https://example.com/'
        }
    }

    Context 'Themes' {
        It 'applies dark colours recursively' {
            $form = New-FormWindow
            Add-FormControl -Parent $form -Control (New-TextBox), (New-Button -Text 'B')
            Set-FormTheme -Control $form -Theme Dark
            $form.BackColor.R | Should -BeLessThan 64
            $form.Controls[0].BackColor.R | Should -BeLessThan 64
            $form.Dispose()
        }
    }
}
