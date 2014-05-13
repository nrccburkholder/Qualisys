<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RollbacksSection
    Inherits Qualisys.QLoader.Section

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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RollbacksSection))
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.DatasetGridView = New System.Windows.Forms.DataGridView
        Me.DatasetIdColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DatasetCreationColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DatasetRecordsColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.DeleteDatasetButton = New System.Windows.Forms.ToolStripButton
        Me.RefreshButton = New System.Windows.Forms.ToolStripButton
        Me.SectionPanel1.SuspendLayout()
        CType(Me.DatasetGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Unsampled Datasets"
        Me.SectionPanel1.Controls.Add(Me.DatasetGridView)
        Me.SectionPanel1.Controls.Add(Me.ToolStrip1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(472, 358)
        Me.SectionPanel1.TabIndex = 0
        '
        'DatasetGridView
        '
        Me.DatasetGridView.AllowUserToAddRows = False
        Me.DatasetGridView.AllowUserToDeleteRows = False
        Me.DatasetGridView.AllowUserToOrderColumns = True
        DataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetGridView.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle1
        Me.DatasetGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DatasetGridView.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.DatasetIdColumn, Me.DatasetCreationColumn, Me.DatasetRecordsColumn})
        Me.DatasetGridView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.DatasetGridView.Location = New System.Drawing.Point(1, 52)
        Me.DatasetGridView.MultiSelect = False
        Me.DatasetGridView.Name = "DatasetGridView"
        Me.DatasetGridView.ReadOnly = True
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetGridView.RowHeadersDefaultCellStyle = DataGridViewCellStyle2
        Me.DatasetGridView.RowHeadersVisible = False
        Me.DatasetGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.DatasetGridView.Size = New System.Drawing.Size(470, 305)
        Me.DatasetGridView.TabIndex = 1
        '
        'DatasetIdColumn
        '
        Me.DatasetIdColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DatasetIdColumn.HeaderText = "Dataset ID"
        Me.DatasetIdColumn.Name = "DatasetIdColumn"
        Me.DatasetIdColumn.ReadOnly = True
        Me.DatasetIdColumn.Width = 83
        '
        'DatasetCreationColumn
        '
        Me.DatasetCreationColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DatasetCreationColumn.HeaderText = "Creation Date"
        Me.DatasetCreationColumn.Name = "DatasetCreationColumn"
        Me.DatasetCreationColumn.ReadOnly = True
        Me.DatasetCreationColumn.Width = 97
        '
        'DatasetRecordsColumn
        '
        Me.DatasetRecordsColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DatasetRecordsColumn.HeaderText = "Records"
        Me.DatasetRecordsColumn.Name = "DatasetRecordsColumn"
        Me.DatasetRecordsColumn.ReadOnly = True
        Me.DatasetRecordsColumn.Width = 72
        '
        'ToolStrip1
        '
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshButton, Me.DeleteDatasetButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(1, 27)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(470, 25)
        Me.ToolStrip1.TabIndex = 3
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'DeleteDatasetButton
        '
        Me.DeleteDatasetButton.Enabled = False
        Me.DeleteDatasetButton.Image = Global.Nrc.Qualisys.QLoader.My.Resources.Resources.Undo32
        Me.DeleteDatasetButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteDatasetButton.Name = "DeleteDatasetButton"
        Me.DeleteDatasetButton.Size = New System.Drawing.Size(99, 22)
        Me.DeleteDatasetButton.Text = "Delete Dataset"
        '
        'RefreshButton
        '
        Me.RefreshButton.Image = CType(resources.GetObject("RefreshButton.Image"), System.Drawing.Image)
        Me.RefreshButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RefreshButton.Name = "RefreshButton"
        Me.RefreshButton.Size = New System.Drawing.Size(65, 22)
        Me.RefreshButton.Text = "Refresh"
        '
        'RollbacksSection
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "RollbacksSection"
        Me.Size = New System.Drawing.Size(472, 358)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        CType(Me.DatasetGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents DatasetGridView As System.Windows.Forms.DataGridView
    Friend WithEvents DatasetIdColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetCreationColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetRecordsColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents DeleteDatasetButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RefreshButton As System.Windows.Forms.ToolStripButton

End Class
