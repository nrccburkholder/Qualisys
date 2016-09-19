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
        Me.components = New System.ComponentModel.Container()
        Dim DataGridViewCellStyle9 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle10 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RollbacksSection))
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel()
        Me.TabControl1 = New System.Windows.Forms.TabControl()
        Me.tpUnsampleDatasets = New System.Windows.Forms.TabPage()
        Me.DatasetGridView = New System.Windows.Forms.DataGridView()
        Me.DatasetIdColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DatasetCreationColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DatasetRecordsColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip()
        Me.RefreshButton = New System.Windows.Forms.ToolStripButton()
        Me.DeleteDatasetButton = New System.Windows.Forms.ToolStripButton()
        Me.tpDRGRollback = New System.Windows.Forms.TabPage()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.RollbackGridView = New System.Windows.Forms.DataGridView()
        Me.bsDRGUpdate = New System.Windows.Forms.BindingSource(Me.components)
        Me.lbDRGResults = New System.Windows.Forms.ListBox()
        Me.ToolStrip2 = New System.Windows.Forms.ToolStrip()
        Me.RefreshDRGButton = New System.Windows.Forms.ToolStripButton()
        Me.RollbackButton = New System.Windows.Forms.ToolStripButton()
        Me.SectionPanel1.SuspendLayout()
        Me.TabControl1.SuspendLayout()
        Me.tpUnsampleDatasets.SuspendLayout()
        CType(Me.DatasetGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.tpDRGRollback.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        CType(Me.RollbackGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsDRGUpdate, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip2.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Controls.Add(Me.TabControl1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(643, 480)
        Me.SectionPanel1.TabIndex = 0
        '
        'TabControl1
        '
        Me.TabControl1.Controls.Add(Me.tpUnsampleDatasets)
        Me.TabControl1.Controls.Add(Me.tpDRGRollback)
        Me.TabControl1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TabControl1.Location = New System.Drawing.Point(1, 27)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(641, 452)
        Me.TabControl1.TabIndex = 5
        '
        'tpUnsampleDatasets
        '
        Me.tpUnsampleDatasets.Controls.Add(Me.DatasetGridView)
        Me.tpUnsampleDatasets.Controls.Add(Me.ToolStrip1)
        Me.tpUnsampleDatasets.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tpUnsampleDatasets.Location = New System.Drawing.Point(4, 25)
        Me.tpUnsampleDatasets.Name = "tpUnsampleDatasets"
        Me.tpUnsampleDatasets.Padding = New System.Windows.Forms.Padding(3)
        Me.tpUnsampleDatasets.Size = New System.Drawing.Size(633, 423)
        Me.tpUnsampleDatasets.TabIndex = 0
        Me.tpUnsampleDatasets.Text = "Unsampled Datasets"
        Me.tpUnsampleDatasets.UseVisualStyleBackColor = True
        '
        'DatasetGridView
        '
        Me.DatasetGridView.AllowUserToAddRows = False
        Me.DatasetGridView.AllowUserToDeleteRows = False
        Me.DatasetGridView.AllowUserToOrderColumns = True
        Me.DatasetGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells
        DataGridViewCellStyle9.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter
        DataGridViewCellStyle9.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle9.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle9.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle9.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle9.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle9.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetGridView.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle9
        Me.DatasetGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DatasetGridView.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.DatasetIdColumn, Me.DatasetCreationColumn, Me.DatasetRecordsColumn})
        Me.DatasetGridView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.DatasetGridView.Location = New System.Drawing.Point(3, 28)
        Me.DatasetGridView.MultiSelect = False
        Me.DatasetGridView.Name = "DatasetGridView"
        Me.DatasetGridView.ReadOnly = True
        DataGridViewCellStyle10.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle10.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle10.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle10.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle10.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle10.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle10.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetGridView.RowHeadersDefaultCellStyle = DataGridViewCellStyle10
        Me.DatasetGridView.RowHeadersVisible = False
        Me.DatasetGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.DatasetGridView.Size = New System.Drawing.Size(627, 392)
        Me.DatasetGridView.TabIndex = 5
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
        Me.ToolStrip1.Location = New System.Drawing.Point(3, 3)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(627, 25)
        Me.ToolStrip1.TabIndex = 4
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'RefreshButton
        '
        Me.RefreshButton.Image = CType(resources.GetObject("RefreshButton.Image"), System.Drawing.Image)
        Me.RefreshButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RefreshButton.Name = "RefreshButton"
        Me.RefreshButton.Size = New System.Drawing.Size(66, 22)
        Me.RefreshButton.Text = "Refresh"
        '
        'DeleteDatasetButton
        '
        Me.DeleteDatasetButton.Enabled = False
        Me.DeleteDatasetButton.Image = Global.Nrc.QualiSys.QLoader.My.Resources.Resources.Undo32
        Me.DeleteDatasetButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteDatasetButton.Name = "DeleteDatasetButton"
        Me.DeleteDatasetButton.Size = New System.Drawing.Size(102, 22)
        Me.DeleteDatasetButton.Text = "Delete Dataset"
        '
        'tpDRGRollback
        '
        Me.tpDRGRollback.Controls.Add(Me.SplitContainer1)
        Me.tpDRGRollback.Controls.Add(Me.ToolStrip2)
        Me.tpDRGRollback.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tpDRGRollback.Location = New System.Drawing.Point(4, 25)
        Me.tpDRGRollback.Name = "tpDRGRollback"
        Me.tpDRGRollback.Padding = New System.Windows.Forms.Padding(3)
        Me.tpDRGRollback.Size = New System.Drawing.Size(633, 423)
        Me.tpDRGRollback.TabIndex = 1
        Me.tpDRGRollback.Text = "DRG Rollback"
        Me.tpDRGRollback.UseVisualStyleBackColor = True
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.FixedPanel = System.Windows.Forms.FixedPanel.Panel2
        Me.SplitContainer1.IsSplitterFixed = True
        Me.SplitContainer1.Location = New System.Drawing.Point(3, 28)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.RollbackGridView)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.lbDRGResults)
        Me.SplitContainer1.Size = New System.Drawing.Size(627, 392)
        Me.SplitContainer1.SplitterDistance = 199
        Me.SplitContainer1.TabIndex = 6
        '
        'RollbackGridView
        '
        Me.RollbackGridView.AllowUserToAddRows = False
        Me.RollbackGridView.AllowUserToDeleteRows = False
        Me.RollbackGridView.AutoGenerateColumns = False
        Me.RollbackGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.RollbackGridView.DataSource = Me.bsDRGUpdate
        Me.RollbackGridView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.RollbackGridView.Location = New System.Drawing.Point(0, 0)
        Me.RollbackGridView.Name = "RollbackGridView"
        Me.RollbackGridView.ReadOnly = True
        Me.RollbackGridView.RowHeadersVisible = False
        Me.RollbackGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.RollbackGridView.Size = New System.Drawing.Size(627, 199)
        Me.RollbackGridView.TabIndex = 7
        '
        'bsDRGUpdate
        '
        Me.bsDRGUpdate.AllowNew = False
        '
        'lbDRGResults
        '
        Me.lbDRGResults.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lbDRGResults.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lbDRGResults.FormattingEnabled = True
        Me.lbDRGResults.ItemHeight = 16
        Me.lbDRGResults.Location = New System.Drawing.Point(0, 0)
        Me.lbDRGResults.Name = "lbDRGResults"
        Me.lbDRGResults.Size = New System.Drawing.Size(627, 189)
        Me.lbDRGResults.TabIndex = 0
        '
        'ToolStrip2
        '
        Me.ToolStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshDRGButton, Me.RollbackButton})
        Me.ToolStrip2.Location = New System.Drawing.Point(3, 3)
        Me.ToolStrip2.Name = "ToolStrip2"
        Me.ToolStrip2.Size = New System.Drawing.Size(627, 25)
        Me.ToolStrip2.TabIndex = 5
        Me.ToolStrip2.Text = "ToolStrip2"
        '
        'RefreshDRGButton
        '
        Me.RefreshDRGButton.Image = CType(resources.GetObject("RefreshDRGButton.Image"), System.Drawing.Image)
        Me.RefreshDRGButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RefreshDRGButton.Name = "RefreshDRGButton"
        Me.RefreshDRGButton.Size = New System.Drawing.Size(66, 22)
        Me.RefreshDRGButton.Text = "Refresh"
        '
        'RollbackButton
        '
        Me.RollbackButton.Enabled = False
        Me.RollbackButton.Image = Global.Nrc.QualiSys.QLoader.My.Resources.Resources.Undo32
        Me.RollbackButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RollbackButton.Name = "RollbackButton"
        Me.RollbackButton.Size = New System.Drawing.Size(72, 22)
        Me.RollbackButton.Text = "Rollback"
        Me.RollbackButton.ToolTipText = "Rollback "
        '
        'RollbacksSection
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "RollbacksSection"
        Me.Size = New System.Drawing.Size(643, 480)
        Me.SectionPanel1.ResumeLayout(False)
        Me.TabControl1.ResumeLayout(False)
        Me.tpUnsampleDatasets.ResumeLayout(False)
        Me.tpUnsampleDatasets.PerformLayout()
        CType(Me.DatasetGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.tpDRGRollback.ResumeLayout(False)
        Me.tpDRGRollback.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        CType(Me.RollbackGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsDRGUpdate, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip2.ResumeLayout(False)
        Me.ToolStrip2.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents tpUnsampleDatasets As System.Windows.Forms.TabPage
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents RefreshButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DeleteDatasetButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents tpDRGRollback As System.Windows.Forms.TabPage
    Friend WithEvents ToolStrip2 As System.Windows.Forms.ToolStrip
    Friend WithEvents RefreshDRGButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RollbackButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents bsDRGUpdate As System.Windows.Forms.BindingSource
    Friend WithEvents DatasetGridView As System.Windows.Forms.DataGridView
    Friend WithEvents DatasetIdColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetCreationColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetRecordsColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents RollbackGridView As System.Windows.Forms.DataGridView
    Friend WithEvents lbDRGResults As System.Windows.Forms.ListBox

End Class
