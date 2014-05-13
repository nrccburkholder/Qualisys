<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ApplicationManagerForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim DataGridViewCellStyle9 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle11 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle12 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle10 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ApplicationManagerForm))
        Me.ApplicationDataGrid = New System.Windows.Forms.DataGridView
        Me.ImageColumn = New System.Windows.Forms.DataGridViewImageColumn
        Me.ImageMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.ChangeImageMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RemoveImageToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.NameColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CategoryName = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DescriptionColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DeploymentTypeColumn = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.PathColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.PathMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.BrowseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ApplicationBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.OpenDialog = New System.Windows.Forms.OpenFileDialog
        Me.SaveButton = New System.Windows.Forms.Button
        Me.AbortButton = New System.Windows.Forms.Button
        Me.BrowseForPathDialog = New System.Windows.Forms.OpenFileDialog
        Me.TitleBar = New Nrc.LaunchPad.LaunchTitleBar
        Me.ExportImageToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.SaveImageDialog = New System.Windows.Forms.SaveFileDialog
        CType(Me.ApplicationDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ImageMenu.SuspendLayout()
        Me.PathMenu.SuspendLayout()
        CType(Me.ApplicationBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'ApplicationDataGrid
        '
        Me.ApplicationDataGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplicationDataGrid.AutoGenerateColumns = False
        Me.ApplicationDataGrid.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells
        Me.ApplicationDataGrid.BackgroundColor = System.Drawing.Color.LightSlateGray
        Me.ApplicationDataGrid.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.ApplicationDataGrid.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.[Single]
        DataGridViewCellStyle9.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle9.BackColor = System.Drawing.Color.SteelBlue
        DataGridViewCellStyle9.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle9.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle9.SelectionBackColor = System.Drawing.Color.LemonChiffon
        DataGridViewCellStyle9.SelectionForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle9.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.ApplicationDataGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle9
        Me.ApplicationDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ApplicationDataGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.ImageColumn, Me.NameColumn, Me.CategoryName, Me.DescriptionColumn, Me.DeploymentTypeColumn, Me.PathColumn})
        Me.ApplicationDataGrid.DataSource = Me.ApplicationBindingSource
        DataGridViewCellStyle11.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle11.BackColor = System.Drawing.Color.AliceBlue
        DataGridViewCellStyle11.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle11.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle11.SelectionBackColor = System.Drawing.Color.LemonChiffon
        DataGridViewCellStyle11.SelectionForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle11.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.ApplicationDataGrid.DefaultCellStyle = DataGridViewCellStyle11
        Me.ApplicationDataGrid.EnableHeadersVisualStyles = False
        Me.ApplicationDataGrid.Location = New System.Drawing.Point(13, 32)
        Me.ApplicationDataGrid.MultiSelect = False
        Me.ApplicationDataGrid.Name = "ApplicationDataGrid"
        Me.ApplicationDataGrid.RowHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.[Single]
        DataGridViewCellStyle12.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle12.BackColor = System.Drawing.Color.SteelBlue
        DataGridViewCellStyle12.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle12.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle12.SelectionBackColor = System.Drawing.Color.LemonChiffon
        DataGridViewCellStyle12.SelectionForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle12.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ApplicationDataGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle12
        Me.ApplicationDataGrid.Size = New System.Drawing.Size(781, 283)
        Me.ApplicationDataGrid.TabIndex = 0
        '
        'ImageColumn
        '
        Me.ImageColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells
        Me.ImageColumn.ContextMenuStrip = Me.ImageMenu
        Me.ImageColumn.DataPropertyName = "Image"
        Me.ImageColumn.HeaderText = "Image"
        Me.ImageColumn.Name = "ImageColumn"
        Me.ImageColumn.Width = 42
        '
        'ImageMenu
        '
        Me.ImageMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ChangeImageMenuItem, Me.RemoveImageToolStripMenuItem, Me.ExportImageToolStripMenuItem})
        Me.ImageMenu.Name = "ImageMenu"
        Me.ImageMenu.Size = New System.Drawing.Size(157, 70)
        '
        'ChangeImageMenuItem
        '
        Me.ChangeImageMenuItem.Name = "ChangeImageMenuItem"
        Me.ChangeImageMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.ChangeImageMenuItem.Text = "Change Image..."
        '
        'RemoveImageToolStripMenuItem
        '
        Me.RemoveImageToolStripMenuItem.Name = "RemoveImageToolStripMenuItem"
        Me.RemoveImageToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.RemoveImageToolStripMenuItem.Text = "Remove Image"
        '
        'NameColumn
        '
        Me.NameColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells
        Me.NameColumn.DataPropertyName = "Name"
        Me.NameColumn.HeaderText = "Name"
        Me.NameColumn.Name = "NameColumn"
        Me.NameColumn.Width = 58
        '
        'CategoryName
        '
        Me.CategoryName.DataPropertyName = "CategoryName"
        Me.CategoryName.HeaderText = "Category"
        Me.CategoryName.Name = "CategoryName"
        '
        'DescriptionColumn
        '
        Me.DescriptionColumn.DataPropertyName = "Description"
        DataGridViewCellStyle10.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.DescriptionColumn.DefaultCellStyle = DataGridViewCellStyle10
        Me.DescriptionColumn.HeaderText = "Description"
        Me.DescriptionColumn.Name = "DescriptionColumn"
        Me.DescriptionColumn.Width = 200
        '
        'DeploymentTypeColumn
        '
        Me.DeploymentTypeColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells
        Me.DeploymentTypeColumn.DataPropertyName = "DeploymentType"
        Me.DeploymentTypeColumn.HeaderText = "Deployment Type"
        Me.DeploymentTypeColumn.Name = "DeploymentTypeColumn"
        Me.DeploymentTypeColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.DeploymentTypeColumn.Width = 96
        '
        'PathColumn
        '
        Me.PathColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells
        Me.PathColumn.ContextMenuStrip = Me.PathMenu
        Me.PathColumn.DataPropertyName = "Path"
        Me.PathColumn.HeaderText = "Path"
        Me.PathColumn.MinimumWidth = 200
        Me.PathColumn.Name = "PathColumn"
        Me.PathColumn.Width = 200
        '
        'PathMenu
        '
        Me.PathMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BrowseToolStripMenuItem})
        Me.PathMenu.Name = "PathMenu"
        Me.PathMenu.Size = New System.Drawing.Size(122, 26)
        '
        'BrowseToolStripMenuItem
        '
        Me.BrowseToolStripMenuItem.Name = "BrowseToolStripMenuItem"
        Me.BrowseToolStripMenuItem.Size = New System.Drawing.Size(121, 22)
        Me.BrowseToolStripMenuItem.Text = "Browse..."
        '
        'ApplicationBindingSource
        '
        Me.ApplicationBindingSource.DataSource = GetType(Nrc.LaunchPad.Library.Application)
        '
        'OpenDialog
        '
        Me.OpenDialog.Filter = "Icon Files|*.ico|Image Files|*.gif;*.png;*.jpg;*.bmp|Applications|*.exe"
        '
        'SaveButton
        '
        Me.SaveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SaveButton.Location = New System.Drawing.Point(638, 321)
        Me.SaveButton.Name = "SaveButton"
        Me.SaveButton.Size = New System.Drawing.Size(75, 23)
        Me.SaveButton.TabIndex = 2
        Me.SaveButton.Text = "Save"
        Me.SaveButton.UseVisualStyleBackColor = True
        '
        'AbortButton
        '
        Me.AbortButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AbortButton.Location = New System.Drawing.Point(719, 321)
        Me.AbortButton.Name = "AbortButton"
        Me.AbortButton.Size = New System.Drawing.Size(75, 23)
        Me.AbortButton.TabIndex = 3
        Me.AbortButton.Text = "Cancel"
        Me.AbortButton.UseVisualStyleBackColor = True
        '
        'BrowseForPathDialog
        '
        Me.BrowseForPathDialog.Filter = "Applications|*.exe|All Files|*.*"
        '
        'TitleBar
        '
        Me.TitleBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.TitleBar.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TitleBar.ForeColor = System.Drawing.Color.White
        Me.TitleBar.Icon = CType(resources.GetObject("TitleBar.Icon"), System.Drawing.Icon)
        Me.TitleBar.Location = New System.Drawing.Point(1, 1)
        Me.TitleBar.Name = "TitleBar"
        Me.TitleBar.Padding = New System.Windows.Forms.Padding(2)
        Me.TitleBar.Size = New System.Drawing.Size(805, 25)
        Me.TitleBar.TabIndex = 4
        Me.TitleBar.Text = "Application Managment"
        '
        'ExportImageToolStripMenuItem
        '
        Me.ExportImageToolStripMenuItem.Name = "ExportImageToolStripMenuItem"
        Me.ExportImageToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.ExportImageToolStripMenuItem.Text = "Export Image..."
        '
        'SaveImageDialog
        '
        Me.SaveImageDialog.Filter = "Bitmap|*.bmp|EMF Image|*.emf|GIF Image|*.gif|Icon|*.ico|JPEG Image|*.jpg|PNG Imag" & _
            "e|*.png|TIFF Image|*.tif|WMF Image|*.wmf"
        Me.SaveImageDialog.FilterIndex = 6
        '
        'ApplicationManagerForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.LightSteelBlue
        Me.ClientSize = New System.Drawing.Size(807, 357)
        Me.Controls.Add(Me.TitleBar)
        Me.Controls.Add(Me.ApplicationDataGrid)
        Me.Controls.Add(Me.AbortButton)
        Me.Controls.Add(Me.SaveButton)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "ApplicationManagerForm"
        Me.Padding = New System.Windows.Forms.Padding(1)
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "AdminForm"
        CType(Me.ApplicationDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ImageMenu.ResumeLayout(False)
        Me.PathMenu.ResumeLayout(False)
        CType(Me.ApplicationBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ApplicationDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents ApplicationBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents OpenDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents ImageMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents ChangeImageMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveButton As System.Windows.Forms.Button
    Friend WithEvents AbortButton As System.Windows.Forms.Button
    Friend WithEvents TitleBar As LaunchTitleBar
    Friend WithEvents RemoveImageToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PathMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents BrowseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents BrowseForPathDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents ImageColumn As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents NameColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CategoryName As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DescriptionColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DeploymentTypeColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents PathColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ExportImageToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveImageDialog As System.Windows.Forms.SaveFileDialog
End Class
