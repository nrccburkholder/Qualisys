<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ManageTypesControl
    Inherits AdministrationControlTemplate

    'UserControl overrides dispose to clean up the component list.
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
        Me.WeightTypesPanel = New NRC.Framework.WinForms.SectionPanel
        Me.ManageWeightsToolStrip = New System.Windows.Forms.ToolStrip
        Me.NewTypeButton = New System.Windows.Forms.ToolStripButton
        Me.RenameTypeButton = New System.Windows.Forms.ToolStripSplitButton
        Me.RenameTypeNameMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RenameExportColumnNameMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteTypeButton = New System.Windows.Forms.ToolStripButton
        Me.SaveTypesButton = New System.Windows.Forms.ToolStripButton
        Me.UndoButton = New System.Windows.Forms.ToolStripButton
        Me.TypesDataGrid = New System.Windows.Forms.DataGridView
        Me.TypeNameDataGridViewColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ExportcolumnNameDataGridViewColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ManageTypesDataGridContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.NewTypeToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RenameTypeToolContextMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RenameTypeNameContextMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RenameExportColumnNameContextMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteTypeToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.WeightTypesPanel.SuspendLayout()
        Me.ManageWeightsToolStrip.SuspendLayout()
        CType(Me.TypesDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ManageTypesDataGridContextMenuStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'WeightTypesPanel
        '
        Me.WeightTypesPanel.AutoScroll = True
        Me.WeightTypesPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.WeightTypesPanel.Caption = "Manage Weight Types"
        Me.WeightTypesPanel.Controls.Add(Me.ManageWeightsToolStrip)
        Me.WeightTypesPanel.Controls.Add(Me.TypesDataGrid)
        Me.WeightTypesPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WeightTypesPanel.Location = New System.Drawing.Point(0, 0)
        Me.WeightTypesPanel.Name = "WeightTypesPanel"
        Me.WeightTypesPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.WeightTypesPanel.ShowCaption = False
        Me.WeightTypesPanel.Size = New System.Drawing.Size(576, 393)
        Me.WeightTypesPanel.TabIndex = 1
        '
        'ManageWeightsToolStrip
        '
        Me.ManageWeightsToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewTypeButton, Me.RenameTypeButton, Me.DeleteTypeButton, Me.SaveTypesButton, Me.UndoButton})
        Me.ManageWeightsToolStrip.Location = New System.Drawing.Point(1, 1)
        Me.ManageWeightsToolStrip.Name = "ManageWeightsToolStrip"
        Me.ManageWeightsToolStrip.Size = New System.Drawing.Size(574, 25)
        Me.ManageWeightsToolStrip.TabIndex = 1
        Me.ManageWeightsToolStrip.Text = "ToolStrip1"
        '
        'NewTypeButton
        '
        Me.NewTypeButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Star
        Me.NewTypeButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NewTypeButton.Name = "NewTypeButton"
        Me.NewTypeButton.Size = New System.Drawing.Size(48, 22)
        Me.NewTypeButton.Text = "New"
        '
        'RenameTypeButton
        '
        Me.RenameTypeButton.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RenameTypeNameMenuItem, Me.RenameExportColumnNameMenuItem})
        Me.RenameTypeButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.RecyclingXP
        Me.RenameTypeButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RenameTypeButton.Name = "RenameTypeButton"
        Me.RenameTypeButton.Size = New System.Drawing.Size(90, 22)
        Me.RenameTypeButton.Text = "Rename..."
        '
        'RenameTypeNameMenuItem
        '
        Me.RenameTypeNameMenuItem.Name = "RenameTypeNameMenuItem"
        Me.RenameTypeNameMenuItem.Size = New System.Drawing.Size(227, 22)
        Me.RenameTypeNameMenuItem.Text = "Rename Type Name"
        '
        'RenameExportColumnNameMenuItem
        '
        Me.RenameExportColumnNameMenuItem.Name = "RenameExportColumnNameMenuItem"
        Me.RenameExportColumnNameMenuItem.Size = New System.Drawing.Size(227, 22)
        Me.RenameExportColumnNameMenuItem.Text = "Rename Export Column Name"
        '
        'DeleteTypeButton
        '
        Me.DeleteTypeButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Delete
        Me.DeleteTypeButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteTypeButton.Name = "DeleteTypeButton"
        Me.DeleteTypeButton.Size = New System.Drawing.Size(58, 22)
        Me.DeleteTypeButton.Text = "Delete"
        '
        'SaveTypesButton
        '
        Me.SaveTypesButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Save
        Me.SaveTypesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SaveTypesButton.Name = "SaveTypesButton"
        Me.SaveTypesButton.Size = New System.Drawing.Size(51, 22)
        Me.SaveTypesButton.Text = "Save"
        '
        'UndoButton
        '
        Me.UndoButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Undo
        Me.UndoButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UndoButton.Name = "UndoButton"
        Me.UndoButton.Size = New System.Drawing.Size(142, 22)
        Me.UndoButton.Text = "Undo Unsaved Changes"
        '
        'TypesDataGrid
        '
        Me.TypesDataGrid.AllowUserToAddRows = False
        Me.TypesDataGrid.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.TypesDataGrid.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells
        Me.TypesDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.TypesDataGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.TypeNameDataGridViewColumn, Me.ExportcolumnNameDataGridViewColumn})
        Me.TypesDataGrid.ContextMenuStrip = Me.ManageTypesDataGridContextMenuStrip
        Me.TypesDataGrid.Location = New System.Drawing.Point(3, 29)
        Me.TypesDataGrid.Name = "TypesDataGrid"
        Me.TypesDataGrid.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.AutoSizeToDisplayedHeaders
        Me.TypesDataGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.TypesDataGrid.Size = New System.Drawing.Size(390, 360)
        Me.TypesDataGrid.TabIndex = 4
        '
        'TypeNameDataGridViewColumn
        '
        Me.TypeNameDataGridViewColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.TypeNameDataGridViewColumn.HeaderText = "Type Name"
        Me.TypeNameDataGridViewColumn.Name = "TypeNameDataGridViewColumn"
        Me.TypeNameDataGridViewColumn.Width = 200
        '
        'ExportcolumnNameDataGridViewColumn
        '
        Me.ExportcolumnNameDataGridViewColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.ExportcolumnNameDataGridViewColumn.HeaderText = "Export Column Name"
        Me.ExportcolumnNameDataGridViewColumn.Name = "ExportcolumnNameDataGridViewColumn"
        '
        'ManageTypesDataGridContextMenuStrip
        '
        Me.ManageTypesDataGridContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewTypeToolStripMenuItem, Me.RenameTypeToolContextMenuItem, Me.DeleteTypeToolStripMenuItem})
        Me.ManageTypesDataGridContextMenuStrip.Name = "ManageCategoriesDataGridContextMenuStrip"
        Me.ManageTypesDataGridContextMenuStrip.Size = New System.Drawing.Size(137, 70)
        '
        'NewTypeToolStripMenuItem
        '
        Me.NewTypeToolStripMenuItem.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Star
        Me.NewTypeToolStripMenuItem.Name = "NewTypeToolStripMenuItem"
        Me.NewTypeToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.NewTypeToolStripMenuItem.Text = "New"
        '
        'RenameTypeToolContextMenuItem
        '
        Me.RenameTypeToolContextMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RenameTypeNameContextMenuItem, Me.RenameExportColumnNameContextMenuItem})
        Me.RenameTypeToolContextMenuItem.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.RecyclingXP
        Me.RenameTypeToolContextMenuItem.Name = "RenameTypeToolContextMenuItem"
        Me.RenameTypeToolContextMenuItem.Size = New System.Drawing.Size(136, 22)
        Me.RenameTypeToolContextMenuItem.Text = "Rename..."
        '
        'RenameTypeNameContextMenuItem
        '
        Me.RenameTypeNameContextMenuItem.Name = "RenameTypeNameContextMenuItem"
        Me.RenameTypeNameContextMenuItem.Size = New System.Drawing.Size(227, 22)
        Me.RenameTypeNameContextMenuItem.Text = "Rename Type Name"
        '
        'RenameExportColumnNameContextMenuItem
        '
        Me.RenameExportColumnNameContextMenuItem.Name = "RenameExportColumnNameContextMenuItem"
        Me.RenameExportColumnNameContextMenuItem.Size = New System.Drawing.Size(227, 22)
        Me.RenameExportColumnNameContextMenuItem.Text = "Rename Export Column Name"
        '
        'DeleteTypeToolStripMenuItem
        '
        Me.DeleteTypeToolStripMenuItem.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Delete
        Me.DeleteTypeToolStripMenuItem.Name = "DeleteTypeToolStripMenuItem"
        Me.DeleteTypeToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.DeleteTypeToolStripMenuItem.Text = "Delete"
        '
        'ManageTypesControl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.WeightTypesPanel)
        Me.Name = "ManageTypesControl"
        Me.Size = New System.Drawing.Size(576, 393)
        Me.WeightTypesPanel.ResumeLayout(False)
        Me.WeightTypesPanel.PerformLayout()
        Me.ManageWeightsToolStrip.ResumeLayout(False)
        Me.ManageWeightsToolStrip.PerformLayout()
        CType(Me.TypesDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ManageTypesDataGridContextMenuStrip.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents WeightTypesPanel As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents ManageWeightsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents NewTypeButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DeleteTypeButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SaveTypesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TypesDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents ManageTypesDataGridContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents NewTypeToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RenameTypeToolContextMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteTypeToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UndoButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TypeNameDataGridViewColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ExportcolumnNameDataGridViewColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents RenameTypeButton As System.Windows.Forms.ToolStripSplitButton
    Friend WithEvents RenameTypeNameMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RenameExportColumnNameMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RenameTypeNameContextMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RenameExportColumnNameContextMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
