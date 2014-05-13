<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExistingDefinitionsControl
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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ExistingDefinitionsControl))
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.ExistingExportsGrid = New System.Windows.Forms.DataGridView
        Me.FilterStartDate = New System.Windows.Forms.DateTimePicker
        Me.FilterEndDate = New System.Windows.Forms.DateTimePicker
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.DeleteButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.ExportButton = New System.Windows.Forms.ToolStripSplitButton
        Me.ExportIndividualButton = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportCombinedButton = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportORYXDataToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportOryxDataToolStripMenuItem2 = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportQueuedORYXDataToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ClearORYXQueueToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.FilterButton = New System.Windows.Forms.ToolStripButton
        Me.FilterEndLabel = New System.Windows.Forms.ToolStripLabel
        Me.FilterStartLabel = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.ScheduleButton = New System.Windows.Forms.ToolStripDropDownButton
        Me.ScheduleIndividualButton = New System.Windows.Forms.ToolStripMenuItem
        Me.ScheduleCombinedButton = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ShowHistoryButton = New System.Windows.Forms.ToolStripButton
        Me.ExportSetsContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.DeleteMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator6 = New System.Windows.Forms.ToolStripSeparator
        Me.ExportIndividualMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportCombinedMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ORYXToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportORYXDataToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.QueueForORYXExportToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator5 = New System.Windows.Forms.ToolStripSeparator
        Me.ScheduleIndividualMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ScheduleCombinedMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator4 = New System.Windows.Forms.ToolStripSeparator
        Me.ShowHistoryMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.QueueForORYXExportToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExportQueuedORYXDataToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn5 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn6 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn7 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn8 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn9 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn10 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ClientDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StudyDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SurveyDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.UnitDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.NameDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CreationDateDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StartDateDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.EndDateDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StartMonthDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CutoffFieldDgColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SectionPanel1.SuspendLayout()
        CType(Me.ExistingExportsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.ExportSetsContextMenu.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Existing Export Definitions"
        Me.SectionPanel1.Controls.Add(Me.ExistingExportsGrid)
        Me.SectionPanel1.Controls.Add(Me.FilterStartDate)
        Me.SectionPanel1.Controls.Add(Me.FilterEndDate)
        Me.SectionPanel1.Controls.Add(Me.ToolStrip1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(783, 429)
        Me.SectionPanel1.TabIndex = 6
        '
        'ExistingExportsGrid
        '
        Me.ExistingExportsGrid.AllowUserToAddRows = False
        Me.ExistingExportsGrid.AllowUserToDeleteRows = False
        Me.ExistingExportsGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
        Me.ExistingExportsGrid.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.ExistingExportsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ExistingExportsGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.ClientDgColumn, Me.StudyDgColumn, Me.SurveyDgColumn, Me.UnitDgColumn, Me.NameDgColumn, Me.CreationDateDgColumn, Me.StartDateDgColumn, Me.EndDateDgColumn, Me.StartMonthDgColumn, Me.CutoffFieldDgColumn})
        Me.ExistingExportsGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ExistingExportsGrid.Location = New System.Drawing.Point(1, 26)
        Me.ExistingExportsGrid.Name = "ExistingExportsGrid"
        Me.ExistingExportsGrid.RowHeadersVisible = False
        Me.ExistingExportsGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ExistingExportsGrid.Size = New System.Drawing.Size(781, 402)
        Me.ExistingExportsGrid.TabIndex = 16
        '
        'FilterStartDate
        '
        Me.FilterStartDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterStartDate.Location = New System.Drawing.Point(535, 29)
        Me.FilterStartDate.Name = "FilterStartDate"
        Me.FilterStartDate.Size = New System.Drawing.Size(98, 20)
        Me.FilterStartDate.TabIndex = 14
        '
        'FilterEndDate
        '
        Me.FilterEndDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterEndDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterEndDate.Location = New System.Drawing.Point(662, 29)
        Me.FilterEndDate.Name = "FilterEndDate"
        Me.FilterEndDate.Size = New System.Drawing.Size(97, 20)
        Me.FilterEndDate.TabIndex = 14
        '
        'ToolStrip1
        '
        Me.ToolStrip1.CanOverflow = False
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DeleteButton, Me.ToolStripSeparator1, Me.ExportButton, Me.FilterButton, Me.FilterEndLabel, Me.FilterStartLabel, Me.ToolStripSeparator3, Me.ScheduleButton, Me.ToolStripSeparator2, Me.ShowHistoryButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(1, 1)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(781, 25)
        Me.ToolStrip1.TabIndex = 12
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'DeleteButton
        '
        Me.DeleteButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.DeleteButton.Enabled = False
        Me.DeleteButton.Image = CType(resources.GetObject("DeleteButton.Image"), System.Drawing.Image)
        Me.DeleteButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteButton.Name = "DeleteButton"
        Me.DeleteButton.Size = New System.Drawing.Size(75, 22)
        Me.DeleteButton.Text = "Delete Export"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'ExportButton
        '
        Me.ExportButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ExportButton.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportIndividualButton, Me.ExportCombinedButton, Me.ExportORYXDataToolStripMenuItem1})
        Me.ExportButton.Enabled = False
        Me.ExportButton.Image = CType(resources.GetObject("ExportButton.Image"), System.Drawing.Image)
        Me.ExportButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(81, 22)
        Me.ExportButton.Text = "Export File..."
        '
        'ExportIndividualButton
        '
        Me.ExportIndividualButton.Name = "ExportIndividualButton"
        Me.ExportIndividualButton.Size = New System.Drawing.Size(202, 22)
        Me.ExportIndividualButton.Text = "Export to individual file(s)..."
        '
        'ExportCombinedButton
        '
        Me.ExportCombinedButton.Name = "ExportCombinedButton"
        Me.ExportCombinedButton.Size = New System.Drawing.Size(202, 22)
        Me.ExportCombinedButton.Text = "Export to combined file..."
        '
        'ExportORYXDataToolStripMenuItem1
        '
        Me.ExportORYXDataToolStripMenuItem1.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportOryxDataToolStripMenuItem2, Me.QueueForORYXExportToolStripMenuItem, Me.ExportQueuedORYXDataToolStripMenuItem, Me.ClearORYXQueueToolStripMenuItem})
        Me.ExportORYXDataToolStripMenuItem1.Name = "ExportORYXDataToolStripMenuItem1"
        Me.ExportORYXDataToolStripMenuItem1.Size = New System.Drawing.Size(202, 22)
        Me.ExportORYXDataToolStripMenuItem1.Text = "ORYX"
        Me.ExportORYXDataToolStripMenuItem1.Visible = False
        '
        'ExportOryxDataToolStripMenuItem2
        '
        Me.ExportOryxDataToolStripMenuItem2.Name = "ExportOryxDataToolStripMenuItem2"
        Me.ExportOryxDataToolStripMenuItem2.Size = New System.Drawing.Size(203, 22)
        Me.ExportOryxDataToolStripMenuItem2.Text = "Export ORYX data"
        '
        'ExportQueuedORYXDataToolStripMenuItem
        '
        Me.ExportQueuedORYXDataToolStripMenuItem.Name = "ExportQueuedORYXDataToolStripMenuItem"
        Me.ExportQueuedORYXDataToolStripMenuItem.Size = New System.Drawing.Size(203, 22)
        Me.ExportQueuedORYXDataToolStripMenuItem.Text = "Export queued ORYX data"
        '
        'ClearORYXQueueToolStripMenuItem
        '
        Me.ClearORYXQueueToolStripMenuItem.Name = "ClearORYXQueueToolStripMenuItem"
        Me.ClearORYXQueueToolStripMenuItem.Size = New System.Drawing.Size(203, 22)
        Me.ClearORYXQueueToolStripMenuItem.Text = "Clear ORYX queue"
        '
        'FilterButton
        '
        Me.FilterButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.GoLtr
        Me.FilterButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterButton.Name = "FilterButton"
        Me.FilterButton.Size = New System.Drawing.Size(23, 22)
        Me.FilterButton.Text = "Filter"
        '
        'FilterEndLabel
        '
        Me.FilterEndLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterEndLabel.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.FilterEndLabel.Name = "FilterEndLabel"
        Me.FilterEndLabel.Size = New System.Drawing.Size(25, 22)
        Me.FilterEndLabel.Text = "and"
        '
        'FilterStartLabel
        '
        Me.FilterStartLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterStartLabel.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.FilterStartLabel.Name = "FilterStartLabel"
        Me.FilterStartLabel.Size = New System.Drawing.Size(88, 22)
        Me.FilterStartLabel.Text = "Created between"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'ScheduleButton
        '
        Me.ScheduleButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ScheduleButton.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ScheduleIndividualButton, Me.ScheduleCombinedButton})
        Me.ScheduleButton.Enabled = False
        Me.ScheduleButton.Image = CType(resources.GetObject("ScheduleButton.Image"), System.Drawing.Image)
        Me.ScheduleButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ScheduleButton.Name = "ScheduleButton"
        Me.ScheduleButton.Size = New System.Drawing.Size(74, 22)
        Me.ScheduleButton.Text = "Schedule..."
        '
        'ScheduleIndividualButton
        '
        Me.ScheduleIndividualButton.Name = "ScheduleIndividualButton"
        Me.ScheduleIndividualButton.Size = New System.Drawing.Size(205, 22)
        Me.ScheduleIndividualButton.Text = "Schedule individual file(s)..."
        '
        'ScheduleCombinedButton
        '
        Me.ScheduleCombinedButton.Name = "ScheduleCombinedButton"
        Me.ScheduleCombinedButton.Size = New System.Drawing.Size(205, 22)
        Me.ScheduleCombinedButton.Text = "Schedule combined file..."
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'ShowHistoryButton
        '
        Me.ShowHistoryButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ShowHistoryButton.Enabled = False
        Me.ShowHistoryButton.Image = CType(resources.GetObject("ShowHistoryButton.Image"), System.Drawing.Image)
        Me.ShowHistoryButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ShowHistoryButton.Name = "ShowHistoryButton"
        Me.ShowHistoryButton.Size = New System.Drawing.Size(43, 22)
        Me.ShowHistoryButton.Text = "History"
        '
        'ExportSetsContextMenu
        '
        Me.ExportSetsContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DeleteMenuItem, Me.ToolStripSeparator6, Me.ExportIndividualMenuItem, Me.ExportCombinedMenuItem, Me.ORYXToolStripMenuItem, Me.ToolStripSeparator5, Me.ScheduleIndividualMenuItem, Me.ScheduleCombinedMenuItem, Me.ToolStripSeparator4, Me.ShowHistoryMenuItem})
        Me.ExportSetsContextMenu.Name = "ExportSetsContextMenu"
        Me.ExportSetsContextMenu.Size = New System.Drawing.Size(206, 198)
        '
        'DeleteMenuItem
        '
        Me.DeleteMenuItem.Name = "DeleteMenuItem"
        Me.DeleteMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.DeleteMenuItem.Text = "Delete Export"
        '
        'ToolStripSeparator6
        '
        Me.ToolStripSeparator6.Name = "ToolStripSeparator6"
        Me.ToolStripSeparator6.Size = New System.Drawing.Size(202, 6)
        '
        'ExportIndividualMenuItem
        '
        Me.ExportIndividualMenuItem.Name = "ExportIndividualMenuItem"
        Me.ExportIndividualMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.ExportIndividualMenuItem.Text = "Export to individual file(s)..."
        '
        'ExportCombinedMenuItem
        '
        Me.ExportCombinedMenuItem.Name = "ExportCombinedMenuItem"
        Me.ExportCombinedMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.ExportCombinedMenuItem.Text = "Export to combined file..."
        '
        'ORYXToolStripMenuItem
        '
        Me.ORYXToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportORYXDataToolStripMenuItem, Me.QueueForORYXExportToolStripMenuItem1, Me.ExportQueuedORYXDataToolStripMenuItem1})
        Me.ORYXToolStripMenuItem.Name = "ORYXToolStripMenuItem"
        Me.ORYXToolStripMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.ORYXToolStripMenuItem.Text = "ORYX"
        Me.ORYXToolStripMenuItem.Visible = False
        '
        'ExportORYXDataToolStripMenuItem
        '
        Me.ExportORYXDataToolStripMenuItem.Name = "ExportORYXDataToolStripMenuItem"
        Me.ExportORYXDataToolStripMenuItem.Size = New System.Drawing.Size(203, 22)
        Me.ExportORYXDataToolStripMenuItem.Text = "Export ORYX Data"
        '
        'QueueForORYXExportToolStripMenuItem1
        '
        Me.QueueForORYXExportToolStripMenuItem1.Name = "QueueForORYXExportToolStripMenuItem1"
        Me.QueueForORYXExportToolStripMenuItem1.Size = New System.Drawing.Size(203, 22)
        Me.QueueForORYXExportToolStripMenuItem1.Text = "Queue for ORYX Export"
        '
        'ToolStripSeparator5
        '
        Me.ToolStripSeparator5.Name = "ToolStripSeparator5"
        Me.ToolStripSeparator5.Size = New System.Drawing.Size(202, 6)
        '
        'ScheduleIndividualMenuItem
        '
        Me.ScheduleIndividualMenuItem.Name = "ScheduleIndividualMenuItem"
        Me.ScheduleIndividualMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.ScheduleIndividualMenuItem.Text = "Schedule individual file(s)..."
        '
        'ScheduleCombinedMenuItem
        '
        Me.ScheduleCombinedMenuItem.Name = "ScheduleCombinedMenuItem"
        Me.ScheduleCombinedMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.ScheduleCombinedMenuItem.Text = "Schedule combined file..."
        '
        'ToolStripSeparator4
        '
        Me.ToolStripSeparator4.Name = "ToolStripSeparator4"
        Me.ToolStripSeparator4.Size = New System.Drawing.Size(202, 6)
        '
        'ShowHistoryMenuItem
        '
        Me.ShowHistoryMenuItem.Name = "ShowHistoryMenuItem"
        Me.ShowHistoryMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.ShowHistoryMenuItem.Text = "Show History"
        '
        'QueueForORYXExportToolStripMenuItem
        '
        Me.QueueForORYXExportToolStripMenuItem.Name = "QueueForORYXExportToolStripMenuItem"
        Me.QueueForORYXExportToolStripMenuItem.Size = New System.Drawing.Size(203, 22)
        Me.QueueForORYXExportToolStripMenuItem.Text = "Queue for ORYX Export"
        '
        'ExportQueuedORYXDataToolStripMenuItem1
        '
        Me.ExportQueuedORYXDataToolStripMenuItem1.Name = "ExportQueuedORYXDataToolStripMenuItem1"
        Me.ExportQueuedORYXDataToolStripMenuItem1.Size = New System.Drawing.Size(203, 22)
        Me.ExportQueuedORYXDataToolStripMenuItem1.Text = "Export queued ORYX data"
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn1.HeaderText = "Client"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        Me.DataGridViewTextBoxColumn1.Width = 58
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn2.HeaderText = "Study"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        Me.DataGridViewTextBoxColumn2.Width = 59
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn3.HeaderText = "Survey"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        Me.DataGridViewTextBoxColumn3.Width = 65
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn4.HeaderText = "Unit"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        Me.DataGridViewTextBoxColumn4.Width = 51
        '
        'DataGridViewTextBoxColumn5
        '
        Me.DataGridViewTextBoxColumn5.HeaderText = "Name"
        Me.DataGridViewTextBoxColumn5.Name = "DataGridViewTextBoxColumn5"
        '
        'DataGridViewTextBoxColumn6
        '
        Me.DataGridViewTextBoxColumn6.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn6.HeaderText = "Creation Date"
        Me.DataGridViewTextBoxColumn6.Name = "DataGridViewTextBoxColumn6"
        Me.DataGridViewTextBoxColumn6.ReadOnly = True
        Me.DataGridViewTextBoxColumn6.Width = 97
        '
        'DataGridViewTextBoxColumn7
        '
        Me.DataGridViewTextBoxColumn7.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn7.HeaderText = "Start Date"
        Me.DataGridViewTextBoxColumn7.Name = "DataGridViewTextBoxColumn7"
        Me.DataGridViewTextBoxColumn7.ReadOnly = True
        Me.DataGridViewTextBoxColumn7.Width = 80
        '
        'DataGridViewTextBoxColumn8
        '
        Me.DataGridViewTextBoxColumn8.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn8.HeaderText = "End Date"
        Me.DataGridViewTextBoxColumn8.Name = "DataGridViewTextBoxColumn8"
        Me.DataGridViewTextBoxColumn8.ReadOnly = True
        Me.DataGridViewTextBoxColumn8.Width = 77
        '
        'DataGridViewTextBoxColumn9
        '
        Me.DataGridViewTextBoxColumn9.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn9.HeaderText = "Month"
        Me.DataGridViewTextBoxColumn9.Name = "DataGridViewTextBoxColumn9"
        Me.DataGridViewTextBoxColumn9.ReadOnly = True
        Me.DataGridViewTextBoxColumn9.Width = 62
        '
        'DataGridViewTextBoxColumn10
        '
        Me.DataGridViewTextBoxColumn10.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn10.HeaderText = "Cutoff Field"
        Me.DataGridViewTextBoxColumn10.Name = "DataGridViewTextBoxColumn10"
        Me.DataGridViewTextBoxColumn10.ReadOnly = True
        Me.DataGridViewTextBoxColumn10.Width = 85
        '
        'ClientDgColumn
        '
        Me.ClientDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.ClientDgColumn.HeaderText = "Client"
        Me.ClientDgColumn.Name = "ClientDgColumn"
        Me.ClientDgColumn.ReadOnly = True
        Me.ClientDgColumn.Width = 58
        '
        'StudyDgColumn
        '
        Me.StudyDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.StudyDgColumn.HeaderText = "Study"
        Me.StudyDgColumn.Name = "StudyDgColumn"
        Me.StudyDgColumn.ReadOnly = True
        Me.StudyDgColumn.Width = 59
        '
        'SurveyDgColumn
        '
        Me.SurveyDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SurveyDgColumn.HeaderText = "Survey"
        Me.SurveyDgColumn.Name = "SurveyDgColumn"
        Me.SurveyDgColumn.ReadOnly = True
        Me.SurveyDgColumn.Width = 65
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
        Me.NameDgColumn.HeaderText = "Name"
        Me.NameDgColumn.Name = "NameDgColumn"
        '
        'CreationDateDgColumn
        '
        Me.CreationDateDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.CreationDateDgColumn.HeaderText = "Creation Date"
        Me.CreationDateDgColumn.Name = "CreationDateDgColumn"
        Me.CreationDateDgColumn.ReadOnly = True
        Me.CreationDateDgColumn.Width = 97
        '
        'StartDateDgColumn
        '
        Me.StartDateDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.StartDateDgColumn.HeaderText = "Start Date"
        Me.StartDateDgColumn.Name = "StartDateDgColumn"
        Me.StartDateDgColumn.ReadOnly = True
        Me.StartDateDgColumn.Width = 80
        '
        'EndDateDgColumn
        '
        Me.EndDateDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.EndDateDgColumn.HeaderText = "End Date"
        Me.EndDateDgColumn.Name = "EndDateDgColumn"
        Me.EndDateDgColumn.ReadOnly = True
        Me.EndDateDgColumn.Width = 77
        '
        'StartMonthDgColumn
        '
        Me.StartMonthDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.StartMonthDgColumn.HeaderText = "Month"
        Me.StartMonthDgColumn.Name = "StartMonthDgColumn"
        Me.StartMonthDgColumn.ReadOnly = True
        Me.StartMonthDgColumn.Width = 62
        '
        'CutoffFieldDgColumn
        '
        Me.CutoffFieldDgColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.CutoffFieldDgColumn.HeaderText = "Cutoff Field"
        Me.CutoffFieldDgColumn.Name = "CutoffFieldDgColumn"
        Me.CutoffFieldDgColumn.ReadOnly = True
        Me.CutoffFieldDgColumn.Width = 85
        '
        'ExistingDefinitionsControl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ExistingDefinitionsControl"
        Me.Size = New System.Drawing.Size(783, 429)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        CType(Me.ExistingExportsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ExportSetsContextMenu.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ExistingExportsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents FilterStartDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents FilterEndDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents DeleteButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ExportButton As System.Windows.Forms.ToolStripSplitButton
    Friend WithEvents ExportIndividualButton As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportCombinedButton As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FilterButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FilterEndLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents FilterStartLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ShowHistoryButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ExportSetsContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents DeleteMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportIndividualMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportCombinedMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ShowHistoryMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ClientDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StudyDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SurveyDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents UnitDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NameDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CreationDateDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StartDateDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents EndDateDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StartMonthDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CutoffFieldDgColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ScheduleButton As System.Windows.Forms.ToolStripDropDownButton
    Friend WithEvents ScheduleIndividualButton As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ScheduleCombinedButton As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator6 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator5 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ScheduleIndividualMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ScheduleCombinedMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn5 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn6 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn7 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn8 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn9 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn10 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ExportORYXDataToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportOryxDataToolStripMenuItem2 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportQueuedORYXDataToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ORYXToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportORYXDataToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents QueueForORYXExportToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ClearORYXQueueToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents QueueForORYXExportToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportQueuedORYXDataToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem

End Class
