<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExistingSampleSetViewer
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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ExistingSampleSetViewer))
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.SampleSetToolStrip = New System.Windows.Forms.ToolStrip
        Me.FrequenciesButton = New System.Windows.Forms.ToolStripButton
        Me.ReportButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.ScheduleButton = New System.Windows.Forms.ToolStripButton
        Me.FilterSampleSetsButton = New System.Windows.Forms.ToolStripButton
        Me.SampleSetFilter = New System.Windows.Forms.ToolStripComboBox
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.UnscheduleButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteButton = New System.Windows.Forms.ToolStripButton
        Me.SampleSetGridView = New System.Windows.Forms.DataGridView
        Me.SampleContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.FrequenciesMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ReportMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ScheduleMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.UnscheduleMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn5 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn6 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SamplesetScheduledColumn = New System.Windows.Forms.DataGridViewImageColumn
        Me.SampleSetSurveyColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SampleSetPeriodColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SamplesetCreatedColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SamplesetCreatorColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SampleSetDateScheduledColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SampleSetSampledCountColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SectionPanel2.SuspendLayout()
        Me.SampleSetToolStrip.SuspendLayout()
        CType(Me.SampleSetGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SampleContextMenu.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = "Existing Sample Sets"
        Me.SectionPanel2.Controls.Add(Me.SampleSetToolStrip)
        Me.SectionPanel2.Controls.Add(Me.SampleSetGridView)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(750, 297)
        Me.SectionPanel2.TabIndex = 2
        '
        'SampleSetToolStrip
        '
        Me.SampleSetToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FrequenciesButton, Me.ReportButton, Me.ToolStripSeparator3, Me.ScheduleButton, Me.FilterSampleSetsButton, Me.SampleSetFilter, Me.ToolStripLabel1, Me.ToolStripSeparator1, Me.UnscheduleButton, Me.ToolStripSeparator2, Me.DeleteButton})
        Me.SampleSetToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.HorizontalStackWithOverflow
        Me.SampleSetToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.SampleSetToolStrip.Name = "SampleSetToolStrip"
        Me.SampleSetToolStrip.Size = New System.Drawing.Size(748, 25)
        Me.SampleSetToolStrip.TabIndex = 2
        Me.SampleSetToolStrip.Text = "ToolStrip1"
        '
        'FrequenciesButton
        '
        Me.FrequenciesButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Frequencies32
        Me.FrequenciesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FrequenciesButton.Name = "FrequenciesButton"
        Me.FrequenciesButton.Size = New System.Drawing.Size(85, 22)
        Me.FrequenciesButton.Text = "Frequencies"
        '
        'ReportButton
        '
        Me.ReportButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Reports32
        Me.ReportButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ReportButton.Name = "ReportButton"
        Me.ReportButton.Size = New System.Drawing.Size(60, 22)
        Me.ReportButton.Text = "Report"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'ScheduleButton
        '
        Me.ScheduleButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Schedule32
        Me.ScheduleButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ScheduleButton.Name = "ScheduleButton"
        Me.ScheduleButton.Size = New System.Drawing.Size(70, 22)
        Me.ScheduleButton.Text = "Schedule"
        '
        'FilterSampleSetsButton
        '
        Me.FilterSampleSetsButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterSampleSetsButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterSampleSetsButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Go16
        Me.FilterSampleSetsButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterSampleSetsButton.Name = "FilterSampleSetsButton"
        Me.FilterSampleSetsButton.Size = New System.Drawing.Size(23, 22)
        Me.FilterSampleSetsButton.Text = "Apply Filter"
        '
        'SampleSetFilter
        '
        Me.SampleSetFilter.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.SampleSetFilter.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SampleSetFilter.Items.AddRange(New Object() {"All", "Unscheduled"})
        Me.SampleSetFilter.Name = "SampleSetFilter"
        Me.SampleSetFilter.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never
        Me.SampleSetFilter.Size = New System.Drawing.Size(90, 25)
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never
        Me.ToolStripLabel1.Size = New System.Drawing.Size(38, 22)
        Me.ToolStripLabel1.Text = "Status"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'UnscheduleButton
        '
        Me.UnscheduleButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Undo16
        Me.UnscheduleButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UnscheduleButton.Name = "UnscheduleButton"
        Me.UnscheduleButton.Size = New System.Drawing.Size(82, 22)
        Me.UnscheduleButton.Text = "Unschedule"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'DeleteButton
        '
        Me.DeleteButton.Image = CType(resources.GetObject("DeleteButton.Image"), System.Drawing.Image)
        Me.DeleteButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteButton.Name = "DeleteButton"
        Me.DeleteButton.Size = New System.Drawing.Size(58, 22)
        Me.DeleteButton.Text = "Delete"
        '
        'SampleSetGridView
        '
        Me.SampleSetGridView.AllowUserToAddRows = False
        Me.SampleSetGridView.AllowUserToDeleteRows = False
        Me.SampleSetGridView.AllowUserToOrderColumns = True
        Me.SampleSetGridView.AllowUserToResizeRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SampleSetGridView.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.SampleSetGridView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SampleSetGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells
        Me.SampleSetGridView.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.SampleSetGridView.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
        Me.SampleSetGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.SampleSetGridView.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.SamplesetScheduledColumn, Me.SampleSetSurveyColumn, Me.SampleSetPeriodColumn, Me.SamplesetCreatedColumn, Me.SamplesetCreatorColumn, Me.SampleSetDateScheduledColumn, Me.SampleSetSampledCountColumn})
        Me.SampleSetGridView.GridColor = System.Drawing.Color.LightGray
        Me.SampleSetGridView.Location = New System.Drawing.Point(4, 56)
        Me.SampleSetGridView.Name = "SampleSetGridView"
        Me.SampleSetGridView.ReadOnly = True
        Me.SampleSetGridView.RowHeadersVisible = False
        Me.SampleSetGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.SampleSetGridView.Size = New System.Drawing.Size(742, 237)
        Me.SampleSetGridView.TabIndex = 5
        '
        'SampleContextMenu
        '
        Me.SampleContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FrequenciesMenuItem, Me.ReportMenuItem, Me.ScheduleMenuItem, Me.UnscheduleMenuItem, Me.DeleteMenuItem})
        Me.SampleContextMenu.Name = "ContextMenuStrip1"
        Me.SampleContextMenu.Size = New System.Drawing.Size(193, 114)
        '
        'FrequenciesMenuItem
        '
        Me.FrequenciesMenuItem.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Frequencies32
        Me.FrequenciesMenuItem.Name = "FrequenciesMenuItem"
        Me.FrequenciesMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.FrequenciesMenuItem.Text = "Show frequencies..."
        '
        'ReportMenuItem
        '
        Me.ReportMenuItem.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Reports32
        Me.ReportMenuItem.Name = "ReportMenuItem"
        Me.ReportMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.ReportMenuItem.Text = "View sample report..."
        '
        'ScheduleMenuItem
        '
        Me.ScheduleMenuItem.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Schedule32
        Me.ScheduleMenuItem.Name = "ScheduleMenuItem"
        Me.ScheduleMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.ScheduleMenuItem.Text = "Schedule for mailing..."
        '
        'UnscheduleMenuItem
        '
        Me.UnscheduleMenuItem.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Undo16
        Me.UnscheduleMenuItem.Name = "UnscheduleMenuItem"
        Me.UnscheduleMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.UnscheduleMenuItem.Text = "Unschedule for mailing"
        '
        'DeleteMenuItem
        '
        Me.DeleteMenuItem.Image = CType(resources.GetObject("DeleteMenuItem.Image"), System.Drawing.Image)
        Me.DeleteMenuItem.Name = "DeleteMenuItem"
        Me.DeleteMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.DeleteMenuItem.Text = "Delete sample set"
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn1.HeaderText = "Survey"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn2.HeaderText = "Period"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn3.HeaderText = "Creation Date"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn4.HeaderText = "Created By"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        '
        'DataGridViewTextBoxColumn5
        '
        Me.DataGridViewTextBoxColumn5.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.DataGridViewTextBoxColumn5.HeaderText = "Scheduled Date"
        Me.DataGridViewTextBoxColumn5.Name = "DataGridViewTextBoxColumn5"
        Me.DataGridViewTextBoxColumn5.ReadOnly = True
        '
        'DataGridViewTextBoxColumn6
        '
        Me.DataGridViewTextBoxColumn6.HeaderText = "# Sampled"
        Me.DataGridViewTextBoxColumn6.Name = "DataGridViewTextBoxColumn6"
        Me.DataGridViewTextBoxColumn6.Width = 83
        '
        'SamplesetScheduledColumn
        '
        Me.SamplesetScheduledColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SamplesetScheduledColumn.HeaderText = ""
        Me.SamplesetScheduledColumn.Name = "SamplesetScheduledColumn"
        Me.SamplesetScheduledColumn.ReadOnly = True
        Me.SamplesetScheduledColumn.Width = 5
        '
        'SampleSetSurveyColumn
        '
        Me.SampleSetSurveyColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SampleSetSurveyColumn.HeaderText = "Survey"
        Me.SampleSetSurveyColumn.Name = "SampleSetSurveyColumn"
        Me.SampleSetSurveyColumn.ReadOnly = True
        Me.SampleSetSurveyColumn.Width = 66
        '
        'SampleSetPeriodColumn
        '
        Me.SampleSetPeriodColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SampleSetPeriodColumn.HeaderText = "Period"
        Me.SampleSetPeriodColumn.Name = "SampleSetPeriodColumn"
        Me.SampleSetPeriodColumn.ReadOnly = True
        Me.SampleSetPeriodColumn.Width = 62
        '
        'SamplesetCreatedColumn
        '
        Me.SamplesetCreatedColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SamplesetCreatedColumn.HeaderText = "Creation Date"
        Me.SamplesetCreatedColumn.Name = "SamplesetCreatedColumn"
        Me.SamplesetCreatedColumn.ReadOnly = True
        Me.SamplesetCreatedColumn.Width = 99
        '
        'SamplesetCreatorColumn
        '
        Me.SamplesetCreatorColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SamplesetCreatorColumn.HeaderText = "Created By"
        Me.SamplesetCreatorColumn.Name = "SamplesetCreatorColumn"
        Me.SamplesetCreatorColumn.ReadOnly = True
        Me.SamplesetCreatorColumn.Width = 86
        '
        'SampleSetDateScheduledColumn
        '
        Me.SampleSetDateScheduledColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells
        Me.SampleSetDateScheduledColumn.HeaderText = "Scheduled Date"
        Me.SampleSetDateScheduledColumn.Name = "SampleSetDateScheduledColumn"
        Me.SampleSetDateScheduledColumn.ReadOnly = True
        Me.SampleSetDateScheduledColumn.Width = 107
        '
        'SampleSetSampledCountColumn
        '
        Me.SampleSetSampledCountColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.SampleSetSampledCountColumn.HeaderText = "# Sampled"
        Me.SampleSetSampledCountColumn.Name = "SampleSetSampledCountColumn"
        Me.SampleSetSampledCountColumn.ReadOnly = True
        '
        'ExistingSampleSetViewer
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel2)
        Me.Name = "ExistingSampleSetViewer"
        Me.Size = New System.Drawing.Size(750, 297)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel2.PerformLayout()
        Me.SampleSetToolStrip.ResumeLayout(False)
        Me.SampleSetToolStrip.PerformLayout()
        CType(Me.SampleSetGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SampleContextMenu.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SampleSetToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FrequenciesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ReportButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ScheduleButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FilterSampleSetsButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SampleSetFilter As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents UnscheduleButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SampleSetGridView As System.Windows.Forms.DataGridView
    Friend WithEvents SampleContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents FrequenciesMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ReportMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ScheduleMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UnscheduleMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn5 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn6 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SamplesetScheduledColumn As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents SampleSetSurveyColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SampleSetPeriodColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SamplesetCreatedColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SamplesetCreatorColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SampleSetDateScheduledColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SampleSetSampledCountColumn As System.Windows.Forms.DataGridViewTextBoxColumn

End Class
