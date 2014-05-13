<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ScheduledExportSection
    Inherits DataMart.ExportManager.Section

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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Me.ExportSetsPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ExportSetsGrid = New System.Windows.Forms.DataGridView
        Me.ClientDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StudyDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SurveyDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.UnitDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.NameDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CreationDateDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StartDateDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.EndDateDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ExportTypeDGC = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CutoffFieldDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.FilterStartDate = New System.Windows.Forms.DateTimePicker
        Me.FilterEndDate = New System.Windows.Forms.DateTimePicker
        Me.FilterToolStrip = New System.Windows.Forms.ToolStrip
        Me.FilterStartLabel = New System.Windows.Forms.ToolStripLabel
        Me.FilterEndLabel = New System.Windows.Forms.ToolStripLabel
        Me.FilterButton = New System.Windows.Forms.ToolStripButton
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.ExportFilesPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ScheduledExportDataGridView = New System.Windows.Forms.DataGridView
        Me.ScheduledExportContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.UpdateScheduledDateToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ScheduledExportsEditsToolStrip = New System.Windows.Forms.ToolStrip
        Me.UpdateRunDateButton = New System.Windows.Forms.ToolStripButton
        Me.UnScheduleFileButton = New System.Windows.Forms.ToolStripButton
        Me.RunDateDGColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ReturnsOnlyDGColumn = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.DirectsOnlyDGColumn = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.FileTypeDGColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DateScheduledDGColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ScheduledByDGColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ExportSetsDGColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.FileNameDGColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ExportSetsPanel.SuspendLayout()
        CType(Me.ExportSetsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.FilterToolStrip.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.ExportFilesPanel.SuspendLayout()
        CType(Me.ScheduledExportDataGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ScheduledExportContextMenuStrip.SuspendLayout()
        Me.ScheduledExportsEditsToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'ExportSetsPanel
        '
        Me.ExportSetsPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.ExportSetsPanel.Caption = "Export Definitions"
        Me.ExportSetsPanel.Controls.Add(Me.ExportSetsGrid)
        Me.ExportSetsPanel.Controls.Add(Me.FilterStartDate)
        Me.ExportSetsPanel.Controls.Add(Me.FilterEndDate)
        Me.ExportSetsPanel.Controls.Add(Me.FilterToolStrip)
        Me.ExportSetsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ExportSetsPanel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ExportSetsPanel.Location = New System.Drawing.Point(0, 0)
        Me.ExportSetsPanel.Name = "ExportSetsPanel"
        Me.ExportSetsPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.ExportSetsPanel.ShowCaption = True
        Me.ExportSetsPanel.Size = New System.Drawing.Size(849, 255)
        Me.ExportSetsPanel.TabIndex = 6
        '
        'ExportSetsGrid
        '
        Me.ExportSetsGrid.AllowUserToAddRows = False
        Me.ExportSetsGrid.AllowUserToDeleteRows = False
        Me.ExportSetsGrid.AllowUserToOrderColumns = True
        Me.ExportSetsGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
        Me.ExportSetsGrid.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.ExportSetsGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.ClientDgColumn, Me.StudyDgColumn, Me.SurveyDgColumn, Me.UnitDgColumn, Me.NameDgColumn, Me.CreationDateDgColumn, Me.StartDateDgColumn, Me.EndDateDgColumn, Me.ExportTypeDGC, Me.CutoffFieldDgColumn})
        Me.ExportSetsGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ExportSetsGrid.Location = New System.Drawing.Point(1, 52)
        Me.ExportSetsGrid.Name = "ExportSetsGrid"
        Me.ExportSetsGrid.ReadOnly = True
        Me.ExportSetsGrid.RowHeadersVisible = False
        Me.ExportSetsGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ExportSetsGrid.Size = New System.Drawing.Size(847, 202)
        Me.ExportSetsGrid.TabIndex = 32
        '
        'ClientDgColumn
        '
        Me.ClientDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.ClientDgColumn.HeaderText = "Client"
        Me.ClientDgColumn.Name = "ClientDgColumn"
        Me.ClientDgColumn.ReadOnly = True
        Me.ClientDgColumn.Width = 59
        '
        'StudyDgColumn
        '
        Me.StudyDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.StudyDgColumn.HeaderText = "Study"
        Me.StudyDgColumn.Name = "StudyDgColumn"
        Me.StudyDgColumn.ReadOnly = True
        Me.StudyDgColumn.Width = 60
        '
        'SurveyDgColumn
        '
        Me.SurveyDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SurveyDgColumn.HeaderText = "Survey"
        Me.SurveyDgColumn.Name = "SurveyDgColumn"
        Me.SurveyDgColumn.ReadOnly = True
        Me.SurveyDgColumn.Width = 66
        '
        'UnitDgColumn
        '
        Me.UnitDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.UnitDgColumn.HeaderText = "Unit"
        Me.UnitDgColumn.Name = "UnitDgColumn"
        Me.UnitDgColumn.ReadOnly = True
        Me.UnitDgColumn.Width = 51
        '
        'NameDgColumn
        '
        Me.NameDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.NameDgColumn.HeaderText = "Name"
        Me.NameDgColumn.Name = "NameDgColumn"
        Me.NameDgColumn.ReadOnly = True
        Me.NameDgColumn.Width = 59
        '
        'CreationDateDgColumn
        '
        Me.CreationDateDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.CreationDateDgColumn.HeaderText = "Creation Date"
        Me.CreationDateDgColumn.Name = "CreationDateDgColumn"
        Me.CreationDateDgColumn.ReadOnly = True
        Me.CreationDateDgColumn.Width = 99
        '
        'StartDateDgColumn
        '
        Me.StartDateDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.StartDateDgColumn.HeaderText = "Start Date"
        Me.StartDateDgColumn.Name = "StartDateDgColumn"
        Me.StartDateDgColumn.ReadOnly = True
        Me.StartDateDgColumn.Width = 82
        '
        'EndDateDgColumn
        '
        Me.EndDateDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.EndDateDgColumn.HeaderText = "End Date"
        Me.EndDateDgColumn.Name = "EndDateDgColumn"
        Me.EndDateDgColumn.ReadOnly = True
        Me.EndDateDgColumn.Width = 76
        '
        'ExportTypeDGC
        '
        Me.ExportTypeDGC.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.ExportTypeDGC.HeaderText = "Export Type"
        Me.ExportTypeDGC.Name = "ExportTypeDGC"
        Me.ExportTypeDGC.ReadOnly = True
        Me.ExportTypeDGC.Width = 91
        '
        'CutoffFieldDgColumn
        '
        Me.CutoffFieldDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.CutoffFieldDgColumn.HeaderText = "Cutoff Field"
        Me.CutoffFieldDgColumn.Name = "CutoffFieldDgColumn"
        Me.CutoffFieldDgColumn.ReadOnly = True
        Me.CutoffFieldDgColumn.Width = 88
        '
        'FilterStartDate
        '
        Me.FilterStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterStartDate.Location = New System.Drawing.Point(99, 27)
        Me.FilterStartDate.Name = "FilterStartDate"
        Me.FilterStartDate.Size = New System.Drawing.Size(98, 21)
        Me.FilterStartDate.TabIndex = 28
        '
        'FilterEndDate
        '
        Me.FilterEndDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterEndDate.Location = New System.Drawing.Point(225, 27)
        Me.FilterEndDate.Name = "FilterEndDate"
        Me.FilterEndDate.Size = New System.Drawing.Size(97, 21)
        Me.FilterEndDate.TabIndex = 27
        '
        'FilterToolStrip
        '
        Me.FilterToolStrip.CanOverflow = False
        Me.FilterToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.FilterToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FilterStartLabel, Me.FilterEndLabel, Me.FilterButton})
        Me.FilterToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.FilterToolStrip.Name = "FilterToolStrip"
        Me.FilterToolStrip.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.FilterToolStrip.Size = New System.Drawing.Size(847, 25)
        Me.FilterToolStrip.TabIndex = 31
        Me.FilterToolStrip.Text = "Filters"
        '
        'FilterStartLabel
        '
        Me.FilterStartLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterStartLabel.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.FilterStartLabel.Name = "FilterStartLabel"
        Me.FilterStartLabel.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.FilterStartLabel.Size = New System.Drawing.Size(97, 22)
        Me.FilterStartLabel.Text = "Run Date between"
        '
        'FilterEndLabel
        '
        Me.FilterEndLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterEndLabel.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.FilterEndLabel.Name = "FilterEndLabel"
        Me.FilterEndLabel.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.FilterEndLabel.Size = New System.Drawing.Size(25, 22)
        Me.FilterEndLabel.Text = "and"
        '
        'FilterButton
        '
        Me.FilterButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.GoLtr
        Me.FilterButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterButton.Name = "FilterButton"
        Me.FilterButton.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.FilterButton.Size = New System.Drawing.Size(23, 22)
        Me.FilterButton.Text = "Filter"
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.ExportSetsPanel)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.ExportFilesPanel)
        Me.SplitContainer1.Size = New System.Drawing.Size(849, 537)
        Me.SplitContainer1.SplitterDistance = 255
        Me.SplitContainer1.TabIndex = 25
        '
        'ExportFilesPanel
        '
        Me.ExportFilesPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.ExportFilesPanel.Caption = "Scheduled Files"
        Me.ExportFilesPanel.Controls.Add(Me.ScheduledExportDataGridView)
        Me.ExportFilesPanel.Controls.Add(Me.ScheduledExportsEditsToolStrip)
        Me.ExportFilesPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ExportFilesPanel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ExportFilesPanel.Location = New System.Drawing.Point(0, 0)
        Me.ExportFilesPanel.Name = "ExportFilesPanel"
        Me.ExportFilesPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.ExportFilesPanel.ShowCaption = True
        Me.ExportFilesPanel.Size = New System.Drawing.Size(849, 278)
        Me.ExportFilesPanel.TabIndex = 32
        '
        'ScheduledExportDataGridView
        '
        Me.ScheduledExportDataGridView.AllowUserToAddRows = False
        Me.ScheduledExportDataGridView.AllowUserToOrderColumns = True
        DataGridViewCellStyle2.BackColor = System.Drawing.Color.Gainsboro
        Me.ScheduledExportDataGridView.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle2
        Me.ScheduledExportDataGridView.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.RunDateDGColumn, Me.ReturnsOnlyDGColumn, Me.DirectsOnlyDGColumn, Me.FileTypeDGColumn, Me.DateScheduledDGColumn, Me.ScheduledByDGColumn, Me.ExportSetsDGColumn, Me.FileNameDGColumn})
        Me.ScheduledExportDataGridView.ContextMenuStrip = Me.ScheduledExportContextMenuStrip
        Me.ScheduledExportDataGridView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ScheduledExportDataGridView.Location = New System.Drawing.Point(1, 52)
        Me.ScheduledExportDataGridView.Name = "ScheduledExportDataGridView"
        Me.ScheduledExportDataGridView.ReadOnly = True
        Me.ScheduledExportDataGridView.RowHeadersVisible = False
        Me.ScheduledExportDataGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ScheduledExportDataGridView.Size = New System.Drawing.Size(847, 225)
        Me.ScheduledExportDataGridView.TabIndex = 31
        '
        'ScheduledExportContextMenuStrip
        '
        Me.ScheduledExportContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DeleteToolStripMenuItem, Me.UpdateScheduledDateToolStripMenuItem})
        Me.ScheduledExportContextMenuStrip.Name = "ScheduledFileContextMenuStrip"
        Me.ScheduledExportContextMenuStrip.Size = New System.Drawing.Size(199, 48)
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(198, 22)
        Me.DeleteToolStripMenuItem.Text = "Delete"
        '
        'UpdateScheduledDateToolStripMenuItem
        '
        Me.UpdateScheduledDateToolStripMenuItem.Name = "UpdateScheduledDateToolStripMenuItem"
        Me.UpdateScheduledDateToolStripMenuItem.Size = New System.Drawing.Size(198, 22)
        Me.UpdateScheduledDateToolStripMenuItem.Text = "Update Scheduled Date"
        '
        'ScheduledExportsEditsToolStrip
        '
        Me.ScheduledExportsEditsToolStrip.CanOverflow = False
        Me.ScheduledExportsEditsToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ScheduledExportsEditsToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateRunDateButton, Me.UnScheduleFileButton})
        Me.ScheduledExportsEditsToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.ScheduledExportsEditsToolStrip.Name = "ScheduledExportsEditsToolStrip"
        Me.ScheduledExportsEditsToolStrip.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ScheduledExportsEditsToolStrip.Size = New System.Drawing.Size(847, 25)
        Me.ScheduledExportsEditsToolStrip.TabIndex = 30
        Me.ScheduledExportsEditsToolStrip.Text = "Scheduled File Edits"
        '
        'UpdateRunDateButton
        '
        Me.UpdateRunDateButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Calendar_schedule
        Me.UpdateRunDateButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateRunDateButton.Name = "UpdateRunDateButton"
        Me.UpdateRunDateButton.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.UpdateRunDateButton.Size = New System.Drawing.Size(140, 22)
        Me.UpdateRunDateButton.Text = "Update Scheduled Date"
        '
        'UnScheduleFileButton
        '
        Me.UnScheduleFileButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Undo
        Me.UnScheduleFileButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UnScheduleFileButton.Name = "UnScheduleFileButton"
        Me.UnScheduleFileButton.Size = New System.Drawing.Size(82, 22)
        Me.UnScheduleFileButton.Text = "Unschedule"
        '
        'RunDateDGColumn
        '
        Me.RunDateDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.RunDateDGColumn.HeaderText = "Run Date"
        Me.RunDateDGColumn.Name = "RunDateDGColumn"
        Me.RunDateDGColumn.ReadOnly = True
        Me.RunDateDGColumn.Width = 77
        '
        'ReturnsOnlyDGColumn
        '
        Me.ReturnsOnlyDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.ReturnsOnlyDGColumn.HeaderText = "Returns Only"
        Me.ReturnsOnlyDGColumn.Name = "ReturnsOnlyDGColumn"
        Me.ReturnsOnlyDGColumn.ReadOnly = True
        Me.ReturnsOnlyDGColumn.Width = 76
        '
        'DirectsOnlyDGColumn
        '
        Me.DirectsOnlyDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.DirectsOnlyDGColumn.HeaderText = "Directs Only"
        Me.DirectsOnlyDGColumn.Name = "DirectsOnlyDGColumn"
        Me.DirectsOnlyDGColumn.ReadOnly = True
        Me.DirectsOnlyDGColumn.Width = 71
        '
        'FileTypeDGColumn
        '
        Me.FileTypeDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.FileTypeDGColumn.HeaderText = "File Type"
        Me.FileTypeDGColumn.Name = "FileTypeDGColumn"
        Me.FileTypeDGColumn.ReadOnly = True
        Me.FileTypeDGColumn.Width = 75
        '
        'DateScheduledDGColumn
        '
        Me.DateScheduledDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.DateScheduledDGColumn.HeaderText = "Date Scheduled"
        Me.DateScheduledDGColumn.Name = "DateScheduledDGColumn"
        Me.DateScheduledDGColumn.ReadOnly = True
        Me.DateScheduledDGColumn.Width = 107
        '
        'ScheduledByDGColumn
        '
        Me.ScheduledByDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.ScheduledByDGColumn.HeaderText = "Scheduled By"
        Me.ScheduledByDGColumn.Name = "ScheduledByDGColumn"
        Me.ScheduledByDGColumn.ReadOnly = True
        Me.ScheduledByDGColumn.Width = 96
        '
        'ExportSetsDGColumn
        '
        Me.ExportSetsDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.ExportSetsDGColumn.HeaderText = "Defintion Name(s)"
        Me.ExportSetsDGColumn.Name = "ExportSetsDGColumn"
        Me.ExportSetsDGColumn.ReadOnly = True
        Me.ExportSetsDGColumn.Width = 200
        '
        'FileNameDGColumn
        '
        Me.FileNameDGColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None
        Me.FileNameDGColumn.HeaderText = "File Name"
        Me.FileNameDGColumn.Name = "FileNameDGColumn"
        Me.FileNameDGColumn.ReadOnly = True
        Me.FileNameDGColumn.Width = 300
        '
        'ScheduledExportSection
        '
        Me.Controls.Add(Me.SplitContainer1)
        Me.Name = "ScheduledExportSection"
        Me.Size = New System.Drawing.Size(849, 537)
        Me.ExportSetsPanel.ResumeLayout(False)
        Me.ExportSetsPanel.PerformLayout()
        CType(Me.ExportSetsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.FilterToolStrip.ResumeLayout(False)
        Me.FilterToolStrip.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.ExportFilesPanel.ResumeLayout(False)
        Me.ExportFilesPanel.PerformLayout()
        CType(Me.ScheduledExportDataGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ScheduledExportContextMenuStrip.ResumeLayout(False)
        Me.ScheduledExportsEditsToolStrip.ResumeLayout(False)
        Me.ScheduledExportsEditsToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ExportSetsPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents FilterStartDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents FilterEndDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents ScheduledExportDataGridView As System.Windows.Forms.DataGridView
    Friend WithEvents ScheduledExportsEditsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents UpdateRunDateButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UnScheduleFileButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ScheduledExportContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents FilterToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FilterStartLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents FilterEndLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents FilterButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ExportSetsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UpdateScheduledDateToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportFilesPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ClientDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StudyDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SurveyDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents UnitDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NameDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CreationDateDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StartDateDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents EndDateDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ExportTypeDGC As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CutoffFieldDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents RunDateDGColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ReturnsOnlyDGColumn As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents DirectsOnlyDGColumn As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents FileTypeDGColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DateScheduledDGColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ScheduledByDGColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ExportSetsDGColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents FileNameDGColumn As System.Windows.Forms.DataGridViewTextBoxColumn

End Class
