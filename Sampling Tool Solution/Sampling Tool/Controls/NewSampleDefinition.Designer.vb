<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NewSampleDefinition
    Inherits System.Windows.Forms.UserControl

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
        Me.components = New System.ComponentModel.Container()
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle4 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle5 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle6 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Me.SectionPanel3 = New Nrc.Framework.WinForms.SectionPanel()
        Me.SampleSeedSpecifiedTextBox = New System.Windows.Forms.TextBox()
        Me.SampleSeedSpecifiedLabel = New System.Windows.Forms.Label()
        Me.MoveUpButton = New System.Windows.Forms.Button()
        Me.MoveDownButton = New System.Windows.Forms.Button()
        Me.SampleStatusLabel = New System.Windows.Forms.Label()
        Me.SampleProgressBar = New System.Windows.Forms.ProgressBar()
        Me.NewSampleGridView = New System.Windows.Forms.DataGridView()
        Me.NewSampleSetOrderColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.NewSampleSetSurveyColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.NewSampleSetPriorityColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.NewSampleEncounterFieldColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.NewSampleSetPeriodColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.NewSampleSetMethodColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.NewSampleSetPeriodStatusColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.NewSampleSetSpecifyDatesColumn = New System.Windows.Forms.DataGridViewCheckBoxColumn()
        Me.NewSampleSetStartDateColumn = New Nrc.Qualisys.SamplingTool.CalendarColumn()
        Me.SampleDefinitionDatesContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.SampleDefinitionCopyDatesMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.NewSampleSetEndDateColumn = New Nrc.Qualisys.SamplingTool.CalendarColumn()
        Me.SampleButton = New System.Windows.Forms.Button()
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel()
        Me.DatasetsToolStrip = New System.Windows.Forms.ToolStrip()
        Me.FilterDatasetsButton2 = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator()
        Me.HoldStatusButton = New System.Windows.Forms.ToolStripButton()
        Me.DeSelectAllButton = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator()
        Me.SelectAllButton = New System.Windows.Forms.ToolStripButton()
        Me.NoDataSetsLabel = New System.Windows.Forms.Label()
        Me.DatasetGridView = New System.Windows.Forms.DataGridView()
        Me.DatasetSelectedColumn = New System.Windows.Forms.DataGridViewCheckBoxColumn()
        Me.DatasetIdColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DatasetCreationColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DatasetRecordsColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DatasetSampledColumn = New System.Windows.Forms.DataGridViewImageColumn()
        Me.SampleWorker = New System.ComponentModel.BackgroundWorker()
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DataGridViewTextBoxColumn5 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DataGridViewTextBoxColumn6 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.DataGridViewTextBoxColumn7 = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.CalendarColumn1 = New Nrc.Qualisys.SamplingTool.CalendarColumn()
        Me.CalendarColumn2 = New Nrc.Qualisys.SamplingTool.CalendarColumn()
        Me.SectionPanel3.SuspendLayout()
        CType(Me.NewSampleGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SampleDefinitionDatesContextMenu.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.DatasetsToolStrip.SuspendLayout()
        CType(Me.DatasetGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SectionPanel3
        '
        Me.SectionPanel3.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel3.Caption = "Sample Definition"
        Me.SectionPanel3.Controls.Add(Me.SampleSeedSpecifiedTextBox)
        Me.SectionPanel3.Controls.Add(Me.SampleSeedSpecifiedLabel)
        Me.SectionPanel3.Controls.Add(Me.MoveUpButton)
        Me.SectionPanel3.Controls.Add(Me.MoveDownButton)
        Me.SectionPanel3.Controls.Add(Me.SampleStatusLabel)
        Me.SectionPanel3.Controls.Add(Me.SampleProgressBar)
        Me.SectionPanel3.Controls.Add(Me.NewSampleGridView)
        Me.SectionPanel3.Controls.Add(Me.SampleButton)
        Me.SectionPanel3.Location = New System.Drawing.Point(0, 200)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel3.ShowCaption = True
        Me.SectionPanel3.Size = New System.Drawing.Size(675, 264)
        Me.SectionPanel3.TabIndex = 3
        '
        'SampleSeedSpecifiedTextBox
        '
        Me.SampleSeedSpecifiedTextBox.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SampleSeedSpecifiedTextBox.Location = New System.Drawing.Point(537, 239)
        Me.SampleSeedSpecifiedTextBox.MaxLength = 15
        Me.SampleSeedSpecifiedTextBox.Name = "SampleSeedSpecifiedTextBox"
        Me.SampleSeedSpecifiedTextBox.Size = New System.Drawing.Size(100, 20)
        Me.SampleSeedSpecifiedTextBox.TabIndex = 19
        '
        'SampleSeedSpecifiedLabel
        '
        Me.SampleSeedSpecifiedLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SampleSeedSpecifiedLabel.AutoSize = True
        Me.SampleSeedSpecifiedLabel.Location = New System.Drawing.Point(446, 242)
        Me.SampleSeedSpecifiedLabel.Name = "SampleSeedSpecifiedLabel"
        Me.SampleSeedSpecifiedLabel.Size = New System.Drawing.Size(85, 13)
        Me.SampleSeedSpecifiedLabel.TabIndex = 18
        Me.SampleSeedSpecifiedLabel.Text = "StaticPlus Seed:"
        '
        'MoveUpButton
        '
        Me.MoveUpButton.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.MoveUpButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.UpArrow16
        Me.MoveUpButton.Location = New System.Drawing.Point(643, 102)
        Me.MoveUpButton.Name = "MoveUpButton"
        Me.MoveUpButton.Size = New System.Drawing.Size(24, 24)
        Me.MoveUpButton.TabIndex = 16
        Me.MoveUpButton.UseVisualStyleBackColor = True
        '
        'MoveDownButton
        '
        Me.MoveDownButton.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.MoveDownButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.DownArrow16
        Me.MoveDownButton.Location = New System.Drawing.Point(643, 129)
        Me.MoveDownButton.Name = "MoveDownButton"
        Me.MoveDownButton.Size = New System.Drawing.Size(24, 24)
        Me.MoveDownButton.TabIndex = 16
        Me.MoveDownButton.UseVisualStyleBackColor = True
        '
        'SampleStatusLabel
        '
        Me.SampleStatusLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.SampleStatusLabel.AutoSize = True
        Me.SampleStatusLabel.Location = New System.Drawing.Point(359, 242)
        Me.SampleStatusLabel.Name = "SampleStatusLabel"
        Me.SampleStatusLabel.Size = New System.Drawing.Size(0, 13)
        Me.SampleStatusLabel.TabIndex = 14
        Me.SampleStatusLabel.Visible = False
        '
        'SampleProgressBar
        '
        Me.SampleProgressBar.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.SampleProgressBar.Location = New System.Drawing.Point(86, 237)
        Me.SampleProgressBar.Name = "SampleProgressBar"
        Me.SampleProgressBar.Size = New System.Drawing.Size(267, 23)
        Me.SampleProgressBar.TabIndex = 13
        Me.SampleProgressBar.Visible = False
        '
        'NewSampleGridView
        '
        Me.NewSampleGridView.AllowDrop = True
        Me.NewSampleGridView.AllowUserToAddRows = False
        Me.NewSampleGridView.AllowUserToDeleteRows = False
        Me.NewSampleGridView.AllowUserToOrderColumns = True
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.WhiteSmoke
        Me.NewSampleGridView.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.NewSampleGridView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.NewSampleGridView.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
        Me.NewSampleGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.NewSampleGridView.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.NewSampleSetOrderColumn, Me.NewSampleSetSurveyColumn, Me.NewSampleSetPriorityColumn, Me.NewSampleEncounterFieldColumn, Me.NewSampleSetPeriodColumn, Me.NewSampleSetMethodColumn, Me.NewSampleSetPeriodStatusColumn, Me.NewSampleSetSpecifyDatesColumn, Me.NewSampleSetStartDateColumn, Me.NewSampleSetEndDateColumn})
        Me.NewSampleGridView.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter
        Me.NewSampleGridView.Location = New System.Drawing.Point(0, 30)
        Me.NewSampleGridView.Name = "NewSampleGridView"
        DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter
        DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.NewSampleGridView.RowHeadersDefaultCellStyle = DataGridViewCellStyle3
        Me.NewSampleGridView.RowHeadersVisible = False
        Me.NewSampleGridView.RowHeadersWidth = 52
        Me.NewSampleGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.NewSampleGridView.ShowEditingIcon = False
        Me.NewSampleGridView.Size = New System.Drawing.Size(633, 201)
        Me.NewSampleGridView.TabIndex = 11
        '
        'NewSampleSetOrderColumn
        '
        Me.NewSampleSetOrderColumn.HeaderText = "Order"
        Me.NewSampleSetOrderColumn.Name = "NewSampleSetOrderColumn"
        Me.NewSampleSetOrderColumn.ReadOnly = True
        Me.NewSampleSetOrderColumn.Width = 50
        '
        'NewSampleSetSurveyColumn
        '
        Me.NewSampleSetSurveyColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NewSampleSetSurveyColumn.HeaderText = "Survey"
        Me.NewSampleSetSurveyColumn.Name = "NewSampleSetSurveyColumn"
        Me.NewSampleSetSurveyColumn.ReadOnly = True
        Me.NewSampleSetSurveyColumn.Width = 66
        '
        'NewSampleSetPriorityColumn
        '
        Me.NewSampleSetPriorityColumn.HeaderText = "Priority"
        Me.NewSampleSetPriorityColumn.Name = "NewSampleSetPriorityColumn"
        Me.NewSampleSetPriorityColumn.ReadOnly = True
        Me.NewSampleSetPriorityColumn.Width = 50
        '
        'NewSampleEncounterFieldColumn
        '
        Me.NewSampleEncounterFieldColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NewSampleEncounterFieldColumn.HeaderText = "Sample Encounter Date"
        Me.NewSampleEncounterFieldColumn.Name = "NewSampleEncounterFieldColumn"
        Me.NewSampleEncounterFieldColumn.ReadOnly = True
        Me.NewSampleEncounterFieldColumn.Width = 144
        '
        'NewSampleSetPeriodColumn
        '
        Me.NewSampleSetPeriodColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NewSampleSetPeriodColumn.HeaderText = "Period"
        Me.NewSampleSetPeriodColumn.Name = "NewSampleSetPeriodColumn"
        Me.NewSampleSetPeriodColumn.Width = 43
        '
        'NewSampleSetMethodColumn
        '
        Me.NewSampleSetMethodColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NewSampleSetMethodColumn.HeaderText = "Sampling Method"
        Me.NewSampleSetMethodColumn.Name = "NewSampleSetMethodColumn"
        Me.NewSampleSetMethodColumn.ReadOnly = True
        Me.NewSampleSetMethodColumn.Width = 113
        '
        'NewSampleSetPeriodStatusColumn
        '
        Me.NewSampleSetPeriodStatusColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader
        Me.NewSampleSetPeriodStatusColumn.HeaderText = "Sample Count"
        Me.NewSampleSetPeriodStatusColumn.Name = "NewSampleSetPeriodStatusColumn"
        Me.NewSampleSetPeriodStatusColumn.ReadOnly = True
        Me.NewSampleSetPeriodStatusColumn.Width = 98
        '
        'NewSampleSetSpecifyDatesColumn
        '
        Me.NewSampleSetSpecifyDatesColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader
        Me.NewSampleSetSpecifyDatesColumn.HeaderText = "Specify Dates"
        Me.NewSampleSetSpecifyDatesColumn.Name = "NewSampleSetSpecifyDatesColumn"
        Me.NewSampleSetSpecifyDatesColumn.Width = 79
        '
        'NewSampleSetStartDateColumn
        '
        Me.NewSampleSetStartDateColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NewSampleSetStartDateColumn.ContextMenuStrip = Me.SampleDefinitionDatesContextMenu
        Me.NewSampleSetStartDateColumn.HeaderText = "Start Date"
        Me.NewSampleSetStartDateColumn.Name = "NewSampleSetStartDateColumn"
        Me.NewSampleSetStartDateColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.NewSampleSetStartDateColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.NewSampleSetStartDateColumn.Width = 82
        '
        'SampleDefinitionDatesContextMenu
        '
        Me.SampleDefinitionDatesContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SampleDefinitionCopyDatesMenuItem})
        Me.SampleDefinitionDatesContextMenu.Name = "SampleDefinitionDatesContextMenu"
        Me.SampleDefinitionDatesContextMenu.Size = New System.Drawing.Size(165, 26)
        '
        'SampleDefinitionCopyDatesMenuItem
        '
        Me.SampleDefinitionCopyDatesMenuItem.Name = "SampleDefinitionCopyDatesMenuItem"
        Me.SampleDefinitionCopyDatesMenuItem.Size = New System.Drawing.Size(164, 22)
        Me.SampleDefinitionCopyDatesMenuItem.Text = "Copy to All Rows"
        '
        'NewSampleSetEndDateColumn
        '
        Me.NewSampleSetEndDateColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NewSampleSetEndDateColumn.ContextMenuStrip = Me.SampleDefinitionDatesContextMenu
        Me.NewSampleSetEndDateColumn.HeaderText = "End Date"
        Me.NewSampleSetEndDateColumn.Name = "NewSampleSetEndDateColumn"
        Me.NewSampleSetEndDateColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.NewSampleSetEndDateColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.NewSampleSetEndDateColumn.Width = 76
        '
        'SampleButton
        '
        Me.SampleButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.SampleButton.Location = New System.Drawing.Point(4, 237)
        Me.SampleButton.Name = "SampleButton"
        Me.SampleButton.Size = New System.Drawing.Size(75, 23)
        Me.SampleButton.TabIndex = 3
        Me.SampleButton.Text = "Sample"
        Me.SampleButton.UseVisualStyleBackColor = True
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Datasets Available for Sampling"
        Me.SectionPanel1.Controls.Add(Me.DatasetsToolStrip)
        Me.SectionPanel1.Controls.Add(Me.NoDataSetsLabel)
        Me.SectionPanel1.Controls.Add(Me.DatasetGridView)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionPanel1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(675, 198)
        Me.SectionPanel1.TabIndex = 2
        '
        'DatasetsToolStrip
        '
        Me.DatasetsToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FilterDatasetsButton2, Me.ToolStripSeparator2, Me.HoldStatusButton, Me.DeSelectAllButton, Me.ToolStripSeparator1, Me.SelectAllButton})
        Me.DatasetsToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.DatasetsToolStrip.Name = "DatasetsToolStrip"
        Me.DatasetsToolStrip.Size = New System.Drawing.Size(673, 25)
        Me.DatasetsToolStrip.TabIndex = 16
        Me.DatasetsToolStrip.Text = "Apply Filter"
        '
        'FilterDatasetsButton2
        '
        Me.FilterDatasetsButton2.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterDatasetsButton2.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Go16
        Me.FilterDatasetsButton2.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterDatasetsButton2.Name = "FilterDatasetsButton2"
        Me.FilterDatasetsButton2.Size = New System.Drawing.Size(23, 22)
        Me.FilterDatasetsButton2.Text = "ToolStripButton1"
        Me.FilterDatasetsButton2.ToolTipText = "Apply Filter"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'HoldStatusButton
        '
        Me.HoldStatusButton.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.HoldStatusButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Caution16
        Me.HoldStatusButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.HoldStatusButton.Name = "HoldStatusButton"
        Me.HoldStatusButton.Size = New System.Drawing.Size(91, 22)
        Me.HoldStatusButton.Text = "Hold Status"
        '
        'DeSelectAllButton
        '
        Me.DeSelectAllButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.DeSelectAllButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.DeSelectAllButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeSelectAllButton.Name = "DeSelectAllButton"
        Me.DeSelectAllButton.Size = New System.Drawing.Size(72, 22)
        Me.DeSelectAllButton.Text = "Deselect All"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'SelectAllButton
        '
        Me.SelectAllButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.SelectAllButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.SelectAllButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SelectAllButton.Name = "SelectAllButton"
        Me.SelectAllButton.Size = New System.Drawing.Size(59, 22)
        Me.SelectAllButton.Text = "Select All"
        '
        'NoDataSetsLabel
        '
        Me.NoDataSetsLabel.AutoSize = True
        Me.NoDataSetsLabel.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.NoDataSetsLabel.Location = New System.Drawing.Point(23, 119)
        Me.NoDataSetsLabel.Name = "NoDataSetsLabel"
        Me.NoDataSetsLabel.Size = New System.Drawing.Size(299, 13)
        Me.NoDataSetsLabel.TabIndex = 14
        Me.NoDataSetsLabel.Text = "There are no data sets available for the date range specified"
        Me.NoDataSetsLabel.Visible = False
        '
        'DatasetGridView
        '
        Me.DatasetGridView.AllowUserToAddRows = False
        Me.DatasetGridView.AllowUserToDeleteRows = False
        Me.DatasetGridView.AllowUserToOrderColumns = True
        Me.DatasetGridView.AllowUserToResizeRows = False
        DataGridViewCellStyle4.BackColor = System.Drawing.Color.WhiteSmoke
        Me.DatasetGridView.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle4
        Me.DatasetGridView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DatasetGridView.BackgroundColor = System.Drawing.SystemColors.Control
        Me.DatasetGridView.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        DataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle5.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle5.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle5.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetGridView.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle5
        Me.DatasetGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DatasetGridView.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.DatasetSelectedColumn, Me.DatasetIdColumn, Me.DatasetCreationColumn, Me.DatasetRecordsColumn, Me.DatasetSampledColumn})
        DataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle6.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetGridView.DefaultCellStyle = DataGridViewCellStyle6
        Me.DatasetGridView.GridColor = System.Drawing.Color.LightGray
        Me.DatasetGridView.Location = New System.Drawing.Point(3, 55)
        Me.DatasetGridView.Name = "DatasetGridView"
        Me.DatasetGridView.RowHeadersVisible = False
        Me.DatasetGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.DatasetGridView.Size = New System.Drawing.Size(668, 139)
        Me.DatasetGridView.TabIndex = 12
        '
        'DatasetSelectedColumn
        '
        Me.DatasetSelectedColumn.HeaderText = ""
        Me.DatasetSelectedColumn.Name = "DatasetSelectedColumn"
        Me.DatasetSelectedColumn.Width = 25
        '
        'DatasetIdColumn
        '
        Me.DatasetIdColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DatasetIdColumn.HeaderText = "ID"
        Me.DatasetIdColumn.Name = "DatasetIdColumn"
        Me.DatasetIdColumn.ReadOnly = True
        Me.DatasetIdColumn.Width = 43
        '
        'DatasetCreationColumn
        '
        Me.DatasetCreationColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DatasetCreationColumn.HeaderText = "Creation Date"
        Me.DatasetCreationColumn.Name = "DatasetCreationColumn"
        Me.DatasetCreationColumn.ReadOnly = True
        Me.DatasetCreationColumn.Width = 99
        '
        'DatasetRecordsColumn
        '
        Me.DatasetRecordsColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DatasetRecordsColumn.HeaderText = "Records"
        Me.DatasetRecordsColumn.Name = "DatasetRecordsColumn"
        Me.DatasetRecordsColumn.ReadOnly = True
        Me.DatasetRecordsColumn.Width = 71
        '
        'DatasetSampledColumn
        '
        Me.DatasetSampledColumn.HeaderText = "Sampled"
        Me.DatasetSampledColumn.Name = "DatasetSampledColumn"
        Me.DatasetSampledColumn.ReadOnly = True
        Me.DatasetSampledColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[False]
        Me.DatasetSampledColumn.Width = 60
        '
        'SampleWorker
        '
        Me.SampleWorker.WorkerReportsProgress = True
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn1.HeaderText = "ID"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn2.HeaderText = "Creation Date"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn3.HeaderText = "Records"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn4.HeaderText = "Survey"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        '
        'DataGridViewTextBoxColumn5
        '
        Me.DataGridViewTextBoxColumn5.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn5.HeaderText = "Cutoff Date"
        Me.DataGridViewTextBoxColumn5.Name = "DataGridViewTextBoxColumn5"
        Me.DataGridViewTextBoxColumn5.ReadOnly = True
        '
        'DataGridViewTextBoxColumn6
        '
        Me.DataGridViewTextBoxColumn6.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn6.HeaderText = "Sampling Method"
        Me.DataGridViewTextBoxColumn6.Name = "DataGridViewTextBoxColumn6"
        Me.DataGridViewTextBoxColumn6.ReadOnly = True
        '
        'DataGridViewTextBoxColumn7
        '
        Me.DataGridViewTextBoxColumn7.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader
        Me.DataGridViewTextBoxColumn7.HeaderText = "Sample Count"
        Me.DataGridViewTextBoxColumn7.Name = "DataGridViewTextBoxColumn7"
        Me.DataGridViewTextBoxColumn7.ReadOnly = True
        '
        'CalendarColumn1
        '
        Me.CalendarColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.CalendarColumn1.HeaderText = "StartDate"
        Me.CalendarColumn1.Name = "CalendarColumn1"
        Me.CalendarColumn1.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.CalendarColumn1.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        '
        'CalendarColumn2
        '
        Me.CalendarColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.CalendarColumn2.HeaderText = "End Date"
        Me.CalendarColumn2.Name = "CalendarColumn2"
        Me.CalendarColumn2.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.CalendarColumn2.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        '
        'NewSampleDefinition
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel3)
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "NewSampleDefinition"
        Me.Size = New System.Drawing.Size(675, 467)
        Me.SectionPanel3.ResumeLayout(False)
        Me.SectionPanel3.PerformLayout()
        CType(Me.NewSampleGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SampleDefinitionDatesContextMenu.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        Me.DatasetsToolStrip.ResumeLayout(False)
        Me.DatasetsToolStrip.PerformLayout()
        CType(Me.DatasetGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel3 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents NewSampleGridView As System.Windows.Forms.DataGridView
    Friend WithEvents SampleButton As System.Windows.Forms.Button
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents DatasetGridView As System.Windows.Forms.DataGridView
    Friend WithEvents SampleStatusLabel As System.Windows.Forms.Label
    Friend WithEvents SampleProgressBar As System.Windows.Forms.ProgressBar
    Friend WithEvents SampleWorker As System.ComponentModel.BackgroundWorker
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn5 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn6 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn7 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CalendarColumn1 As Nrc.Qualisys.SamplingTool.CalendarColumn
    Friend WithEvents CalendarColumn2 As Nrc.Qualisys.SamplingTool.CalendarColumn
    Friend WithEvents DatasetSelectedColumn As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents DatasetIdColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetCreationColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetRecordsColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatasetSampledColumn As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents MoveUpButton As System.Windows.Forms.Button
    Friend WithEvents MoveDownButton As System.Windows.Forms.Button
    Friend WithEvents SampleDefinitionDatesContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents SampleDefinitionCopyDatesMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NoDataSetsLabel As System.Windows.Forms.Label
    Friend WithEvents DatasetsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FilterDatasetsButton2 As System.Windows.Forms.ToolStripButton
    Friend WithEvents SelectAllButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DeSelectAllButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SampleSeedSpecifiedLabel As System.Windows.Forms.Label
    Friend WithEvents SampleSeedSpecifiedTextBox As System.Windows.Forms.TextBox
    Friend WithEvents NewSampleSetOrderColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NewSampleSetSurveyColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NewSampleSetPriorityColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NewSampleEncounterFieldColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NewSampleSetPeriodColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents NewSampleSetMethodColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NewSampleSetPeriodStatusColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NewSampleSetSpecifyDatesColumn As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents NewSampleSetStartDateColumn As Nrc.Qualisys.SamplingTool.CalendarColumn
    Friend WithEvents NewSampleSetEndDateColumn As Nrc.Qualisys.SamplingTool.CalendarColumn
    Friend WithEvents HoldStatusButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator

End Class
