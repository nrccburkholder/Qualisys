Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports Nrc.Qualisys.QLoader.Library20

Public Class LoadingQueueSection
    Inherits Section

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        InitializeToolStripItems()

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents imgResults As System.Windows.Forms.ImageList
    Friend WithEvents lblResults As System.Windows.Forms.Label
    Friend WithEvents ofdOpenFile As System.Windows.Forms.OpenFileDialog
    Friend WithEvents PanelExecute As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents CaptionExecute As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents lblIcon As System.Windows.Forms.Label
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents CaptionFile As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents lblFileName As System.Windows.Forms.Label
    Friend WithEvents lblFileSize As System.Windows.Forms.Label
    Friend WithEvents lblRecordCount As System.Windows.Forms.Label
    Friend WithEvents lblPackage As System.Windows.Forms.Label
    Friend WithEvents lblStudy As System.Windows.Forms.Label
    Friend WithEvents lblClient As System.Windows.Forms.Label
    Friend WithEvents btnExecute As System.Windows.Forms.Button
    Friend WithEvents imgFiles As System.Windows.Forms.ImageList
    Friend WithEvents cmnQueueMenu As System.Windows.Forms.ContextMenu
    Friend WithEvents MenuItem3 As System.Windows.Forms.MenuItem
    Friend WithEvents SectionHeader1 As SectionHeader
    Friend WithEvents rbInProgress As System.Windows.Forms.RadioButton
    Friend WithEvents rbCompleted As System.Windows.Forms.RadioButton
    Friend WithEvents startDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents lblDate1 As System.Windows.Forms.Label
    Friend WithEvents lblDate2 As System.Windows.Forms.Label
    Friend WithEvents endDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents mnuShowDetails As System.Windows.Forms.MenuItem
    Friend WithEvents mnuShowExceptions As System.Windows.Forms.MenuItem
    Friend WithEvents mnuLoadReview As System.Windows.Forms.MenuItem
    Friend WithEvents mnuReports As System.Windows.Forms.MenuItem
    Friend WithEvents SortableColumn1 As SortableColumn
    Friend WithEvents SortableColumn2 As SortableColumn
    Friend WithEvents SortableColumn3 As SortableColumn
    Friend WithEvents SortableColumn4 As SortableColumn
    Friend WithEvents SortableColumn5 As SortableColumn
    Friend WithEvents SortableColumn6 As SortableColumn
    Friend WithEvents cmnExecute As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuLoadFile As System.Windows.Forms.MenuItem
    Friend WithEvents lvwQueue As SortableListView
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents DateTimePicker2 As System.Windows.Forms.DateTimePicker
    Friend WithEvents mnuAbandon As System.Windows.Forms.MenuItem
    Friend WithEvents btnExecuteDRG As System.Windows.Forms.Button
    Friend WithEvents btnExecuteLoadToLive As System.Windows.Forms.Button
    Friend WithEvents mnuLoadToLiveDuplicates As System.Windows.Forms.MenuItem
    Friend WithEvents Label1 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim ListViewItem1 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"Package One", "1234.DBF", "47556", "47554", "5/11/2004 1:15:23 PM", "FileQueued"}, 0)
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(LoadingQueueSection))
        Me.PanelExecute = New Nrc.Framework.WinForms.SectionPanel
        Me.SectionHeader1 = New Nrc.Qualisys.QLoader.SectionHeader
        Me.startDate = New System.Windows.Forms.DateTimePicker
        Me.lblDate1 = New System.Windows.Forms.Label
        Me.rbInProgress = New System.Windows.Forms.RadioButton
        Me.rbCompleted = New System.Windows.Forms.RadioButton
        Me.lblDate2 = New System.Windows.Forms.Label
        Me.endDate = New System.Windows.Forms.DateTimePicker
        Me.CaptionExecute = New Nrc.Framework.WinForms.PaneCaption
        Me.lvwQueue = New Nrc.Qualisys.QLoader.SortableListView
        Me.SortableColumn1 = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SortableColumn2 = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SortableColumn3 = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SortableColumn4 = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SortableColumn5 = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SortableColumn6 = New Nrc.Qualisys.QLoader.SortableColumn
        Me.cmnQueueMenu = New System.Windows.Forms.ContextMenu
        Me.mnuShowDetails = New System.Windows.Forms.MenuItem
        Me.mnuLoadReview = New System.Windows.Forms.MenuItem
        Me.mnuReports = New System.Windows.Forms.MenuItem
        Me.mnuAbandon = New System.Windows.Forms.MenuItem
        Me.MenuItem3 = New System.Windows.Forms.MenuItem
        Me.mnuShowExceptions = New System.Windows.Forms.MenuItem
        Me.imgFiles = New System.Windows.Forms.ImageList(Me.components)
        Me.lblResults = New System.Windows.Forms.Label
        Me.lblIcon = New System.Windows.Forms.Label
        Me.imgResults = New System.Windows.Forms.ImageList(Me.components)
        Me.ofdOpenFile = New System.Windows.Forms.OpenFileDialog
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.btnExecuteLoadToLive = New System.Windows.Forms.Button
        Me.btnExecuteDRG = New System.Windows.Forms.Button
        Me.btnExecute = New System.Windows.Forms.Button
        Me.lblFileName = New System.Windows.Forms.Label
        Me.CaptionFile = New Nrc.Framework.WinForms.PaneCaption
        Me.lblFileSize = New System.Windows.Forms.Label
        Me.lblRecordCount = New System.Windows.Forms.Label
        Me.lblPackage = New System.Windows.Forms.Label
        Me.lblStudy = New System.Windows.Forms.Label
        Me.lblClient = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.DateTimePicker2 = New System.Windows.Forms.DateTimePicker
        Me.Label3 = New System.Windows.Forms.Label
        Me.cmnExecute = New System.Windows.Forms.ContextMenu
        Me.mnuLoadFile = New System.Windows.Forms.MenuItem
        Me.mnuLoadToLiveDuplicates = New System.Windows.Forms.MenuItem
        Me.PanelExecute.SuspendLayout()
        Me.SectionHeader1.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'PanelExecute
        '
        Me.PanelExecute.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PanelExecute.BackColor = System.Drawing.SystemColors.Control
        Me.PanelExecute.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.PanelExecute.Caption = ""
        Me.PanelExecute.Controls.Add(Me.SectionHeader1)
        Me.PanelExecute.Controls.Add(Me.CaptionExecute)
        Me.PanelExecute.Controls.Add(Me.lvwQueue)
        Me.PanelExecute.Location = New System.Drawing.Point(0, 196)
        Me.PanelExecute.Name = "PanelExecute"
        Me.PanelExecute.Padding = New System.Windows.Forms.Padding(1)
        Me.PanelExecute.ShowCaption = False
        Me.PanelExecute.Size = New System.Drawing.Size(736, 364)
        Me.PanelExecute.TabIndex = 4
        '
        'SectionHeader1
        '
        Me.SectionHeader1.Controls.Add(Me.startDate)
        Me.SectionHeader1.Controls.Add(Me.lblDate1)
        Me.SectionHeader1.Controls.Add(Me.rbInProgress)
        Me.SectionHeader1.Controls.Add(Me.rbCompleted)
        Me.SectionHeader1.Controls.Add(Me.lblDate2)
        Me.SectionHeader1.Controls.Add(Me.endDate)
        Me.SectionHeader1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader1.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader1.Name = "SectionHeader1"
        Me.SectionHeader1.Size = New System.Drawing.Size(734, 32)
        Me.SectionHeader1.TabIndex = 7
        '
        'startDate
        '
        Me.startDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.startDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.startDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.startDate.Location = New System.Drawing.Point(520, 8)
        Me.startDate.Name = "startDate"
        Me.startDate.Size = New System.Drawing.Size(80, 21)
        Me.startDate.TabIndex = 2
        Me.startDate.Visible = False
        '
        'lblDate1
        '
        Me.lblDate1.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblDate1.BackColor = System.Drawing.Color.Transparent
        Me.lblDate1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDate1.Location = New System.Drawing.Point(408, 8)
        Me.lblDate1.Name = "lblDate1"
        Me.lblDate1.Size = New System.Drawing.Size(112, 23)
        Me.lblDate1.TabIndex = 1
        Me.lblDate1.Text = "Occurrence between"
        Me.lblDate1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lblDate1.Visible = False
        '
        'rbInProgress
        '
        Me.rbInProgress.BackColor = System.Drawing.Color.Transparent
        Me.rbInProgress.Checked = True
        Me.rbInProgress.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.rbInProgress.Location = New System.Drawing.Point(16, 8)
        Me.rbInProgress.Name = "rbInProgress"
        Me.rbInProgress.Size = New System.Drawing.Size(80, 20)
        Me.rbInProgress.TabIndex = 0
        Me.rbInProgress.TabStop = True
        Me.rbInProgress.Text = "In Progress"
        Me.rbInProgress.UseVisualStyleBackColor = False
        '
        'rbCompleted
        '
        Me.rbCompleted.BackColor = System.Drawing.Color.Transparent
        Me.rbCompleted.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.rbCompleted.Location = New System.Drawing.Point(104, 8)
        Me.rbCompleted.Name = "rbCompleted"
        Me.rbCompleted.Size = New System.Drawing.Size(80, 20)
        Me.rbCompleted.TabIndex = 0
        Me.rbCompleted.Text = "Completed"
        Me.rbCompleted.UseVisualStyleBackColor = False
        '
        'lblDate2
        '
        Me.lblDate2.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblDate2.BackColor = System.Drawing.Color.Transparent
        Me.lblDate2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDate2.Location = New System.Drawing.Point(608, 8)
        Me.lblDate2.Name = "lblDate2"
        Me.lblDate2.Size = New System.Drawing.Size(32, 23)
        Me.lblDate2.TabIndex = 1
        Me.lblDate2.Text = "and"
        Me.lblDate2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lblDate2.Visible = False
        '
        'endDate
        '
        Me.endDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.endDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.endDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.endDate.Location = New System.Drawing.Point(640, 8)
        Me.endDate.Name = "endDate"
        Me.endDate.Size = New System.Drawing.Size(80, 21)
        Me.endDate.TabIndex = 2
        Me.endDate.Visible = False
        '
        'CaptionExecute
        '
        Me.CaptionExecute.Caption = "Data File Queue"
        Me.CaptionExecute.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionExecute.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionExecute.Location = New System.Drawing.Point(1, 1)
        Me.CaptionExecute.Name = "CaptionExecute"
        Me.CaptionExecute.Size = New System.Drawing.Size(734, 26)
        Me.CaptionExecute.TabIndex = 0
        Me.CaptionExecute.Text = "Data File Queue"
        '
        'lvwQueue
        '
        Me.lvwQueue.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwQueue.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.SortableColumn1, Me.SortableColumn2, Me.SortableColumn3, Me.SortableColumn4, Me.SortableColumn5, Me.SortableColumn6})
        Me.lvwQueue.ContextMenu = Me.cmnQueueMenu
        Me.lvwQueue.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwQueue.FullRowSelect = True
        Me.lvwQueue.GridLines = True
        Me.lvwQueue.HideSelection = False
        Me.lvwQueue.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem1})
        Me.lvwQueue.Location = New System.Drawing.Point(8, 64)
        Me.lvwQueue.Name = "lvwQueue"
        Me.lvwQueue.Size = New System.Drawing.Size(720, 292)
        Me.lvwQueue.SmallImageList = Me.imgFiles
        Me.lvwQueue.TabIndex = 6
        Me.lvwQueue.UseCompatibleStateImageBehavior = False
        Me.lvwQueue.View = System.Windows.Forms.View.Details
        '
        'SortableColumn1
        '
        Me.SortableColumn1.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.SortableColumn1.Text = "Package"
        Me.SortableColumn1.Width = 140
        '
        'SortableColumn2
        '
        Me.SortableColumn2.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.SortableColumn2.Text = "File Name"
        Me.SortableColumn2.Width = 175
        '
        'SortableColumn3
        '
        Me.SortableColumn3.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.[Integer]
        Me.SortableColumn3.Text = "Records"
        Me.SortableColumn3.Width = 66
        '
        'SortableColumn4
        '
        Me.SortableColumn4.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.[Integer]
        Me.SortableColumn4.Text = "Loaded"
        Me.SortableColumn4.Width = 62
        '
        'SortableColumn5
        '
        Me.SortableColumn5.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.SortableColumn5.Text = "Occurred"
        Me.SortableColumn5.Width = 137
        '
        'SortableColumn6
        '
        Me.SortableColumn6.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.SortableColumn6.Text = "Status"
        Me.SortableColumn6.Width = 128
        '
        'cmnQueueMenu
        '
        Me.cmnQueueMenu.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuShowDetails, Me.mnuLoadReview, Me.mnuReports, Me.mnuLoadToLiveDuplicates, Me.mnuAbandon, Me.MenuItem3, Me.mnuShowExceptions})
        '
        'mnuShowDetails
        '
        Me.mnuShowDetails.Index = 0
        Me.mnuShowDetails.Text = "Show Details..."
        '
        'mnuLoadReview
        '
        Me.mnuLoadReview.Index = 1
        Me.mnuLoadReview.Text = "Load Review..."
        '
        'mnuReports
        '
        Me.mnuReports.Index = 2
        Me.mnuReports.Text = "View Reports..."
        '
        'mnuAbandon
        '
        Me.mnuAbandon.Index = 4
        Me.mnuAbandon.Text = "Unload File"
        '
        'MenuItem3
        '
        Me.MenuItem3.Index = 5
        Me.MenuItem3.Text = "-"
        '
        'mnuShowExceptions
        '
        Me.mnuShowExceptions.Index = 6
        Me.mnuShowExceptions.Text = "Show Exception Report"
        '
        'imgFiles
        '
        Me.imgFiles.ImageStream = CType(resources.GetObject("imgFiles.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imgFiles.TransparentColor = System.Drawing.Color.Transparent
        Me.imgFiles.Images.SetKeyName(0, "")
        '
        'lblResults
        '
        Me.lblResults.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblResults.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblResults.Location = New System.Drawing.Point(349, 136)
        Me.lblResults.Name = "lblResults"
        Me.lblResults.Size = New System.Drawing.Size(379, 42)
        Me.lblResults.TabIndex = 5
        Me.lblResults.Text = "The file could not be loaded with this DTS Package because the file does not matc" & _
            "h the template defined."
        Me.lblResults.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblIcon
        '
        Me.lblIcon.ImageIndex = 0
        Me.lblIcon.ImageList = Me.imgResults
        Me.lblIcon.Location = New System.Drawing.Point(303, 136)
        Me.lblIcon.Name = "lblIcon"
        Me.lblIcon.Size = New System.Drawing.Size(40, 40)
        Me.lblIcon.TabIndex = 4
        '
        'imgResults
        '
        Me.imgResults.ImageStream = CType(resources.GetObject("imgResults.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imgResults.TransparentColor = System.Drawing.Color.Transparent
        Me.imgResults.Images.SetKeyName(0, "")
        Me.imgResults.Images.SetKeyName(1, "")
        Me.imgResults.Images.SetKeyName(2, "")
        '
        'SectionPanel1
        '
        Me.SectionPanel1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel1.BackColor = System.Drawing.SystemColors.Control
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Controls.Add(Me.btnExecuteLoadToLive)
        Me.SectionPanel1.Controls.Add(Me.btnExecuteDRG)
        Me.SectionPanel1.Controls.Add(Me.btnExecute)
        Me.SectionPanel1.Controls.Add(Me.lblFileName)
        Me.SectionPanel1.Controls.Add(Me.CaptionFile)
        Me.SectionPanel1.Controls.Add(Me.lblFileSize)
        Me.SectionPanel1.Controls.Add(Me.lblRecordCount)
        Me.SectionPanel1.Controls.Add(Me.lblPackage)
        Me.SectionPanel1.Controls.Add(Me.lblStudy)
        Me.SectionPanel1.Controls.Add(Me.lblClient)
        Me.SectionPanel1.Controls.Add(Me.lblIcon)
        Me.SectionPanel1.Controls.Add(Me.lblResults)
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = False
        Me.SectionPanel1.Size = New System.Drawing.Size(736, 190)
        Me.SectionPanel1.TabIndex = 5
        '
        'btnExecuteLoadToLive
        '
        Me.btnExecuteLoadToLive.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnExecuteLoadToLive.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnExecuteLoadToLive.Location = New System.Drawing.Point(192, 136)
        Me.btnExecuteLoadToLive.Name = "btnExecuteLoadToLive"
        Me.btnExecuteLoadToLive.Size = New System.Drawing.Size(83, 40)
        Me.btnExecuteLoadToLive.TabIndex = 6
        Me.btnExecuteLoadToLive.Text = "Execute Load to Live"
        '
        'btnExecuteDRG
        '
        Me.btnExecuteDRG.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnExecuteDRG.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnExecuteDRG.Location = New System.Drawing.Point(103, 136)
        Me.btnExecuteDRG.Name = "btnExecuteDRG"
        Me.btnExecuteDRG.Size = New System.Drawing.Size(83, 40)
        Me.btnExecuteDRG.TabIndex = 3
        Me.btnExecuteDRG.Text = "Add to Queue DRG Update"
        '
        'btnExecute
        '
        Me.btnExecute.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnExecute.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnExecute.Location = New System.Drawing.Point(14, 136)
        Me.btnExecute.Name = "btnExecute"
        Me.btnExecute.Size = New System.Drawing.Size(83, 40)
        Me.btnExecute.TabIndex = 2
        Me.btnExecute.Text = "Add to Queue"
        '
        'lblFileName
        '
        Me.lblFileName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblFileName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFileName.Location = New System.Drawing.Point(320, 37)
        Me.lblFileName.Name = "lblFileName"
        Me.lblFileName.Size = New System.Drawing.Size(408, 32)
        Me.lblFileName.TabIndex = 1
        Me.lblFileName.Text = "File Name:"
        '
        'CaptionFile
        '
        Me.CaptionFile.Caption = "File Information"
        Me.CaptionFile.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionFile.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionFile.Location = New System.Drawing.Point(1, 1)
        Me.CaptionFile.Name = "CaptionFile"
        Me.CaptionFile.Size = New System.Drawing.Size(734, 26)
        Me.CaptionFile.TabIndex = 0
        Me.CaptionFile.Text = "File Information"
        '
        'lblFileSize
        '
        Me.lblFileSize.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblFileSize.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFileSize.Location = New System.Drawing.Point(320, 69)
        Me.lblFileSize.Name = "lblFileSize"
        Me.lblFileSize.Size = New System.Drawing.Size(408, 32)
        Me.lblFileSize.TabIndex = 1
        Me.lblFileSize.Text = "File Size:"
        '
        'lblRecordCount
        '
        Me.lblRecordCount.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRecordCount.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRecordCount.Location = New System.Drawing.Point(320, 101)
        Me.lblRecordCount.Name = "lblRecordCount"
        Me.lblRecordCount.Size = New System.Drawing.Size(408, 32)
        Me.lblRecordCount.TabIndex = 1
        Me.lblRecordCount.Text = "Record Count:"
        '
        'lblPackage
        '
        Me.lblPackage.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPackage.Location = New System.Drawing.Point(11, 101)
        Me.lblPackage.Name = "lblPackage"
        Me.lblPackage.Size = New System.Drawing.Size(293, 32)
        Me.lblPackage.TabIndex = 1
        Me.lblPackage.Text = "Packge:"
        '
        'lblStudy
        '
        Me.lblStudy.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblStudy.Location = New System.Drawing.Point(11, 69)
        Me.lblStudy.Name = "lblStudy"
        Me.lblStudy.Size = New System.Drawing.Size(293, 32)
        Me.lblStudy.TabIndex = 1
        Me.lblStudy.Text = "Study:"
        '
        'lblClient
        '
        Me.lblClient.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblClient.Location = New System.Drawing.Point(11, 37)
        Me.lblClient.Name = "lblClient"
        Me.lblClient.Size = New System.Drawing.Size(293, 32)
        Me.lblClient.TabIndex = 1
        Me.lblClient.Text = "Client"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.Color.Transparent
        Me.Label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(344, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(100, 23)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Queued between"
        '
        'DateTimePicker2
        '
        Me.DateTimePicker2.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.DateTimePicker2.Location = New System.Drawing.Point(440, 8)
        Me.DateTimePicker2.Name = "DateTimePicker2"
        Me.DateTimePicker2.Size = New System.Drawing.Size(96, 20)
        Me.DateTimePicker2.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.Color.Transparent
        Me.Label3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(544, 8)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(24, 23)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "and"
        '
        'cmnExecute
        '
        Me.cmnExecute.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuLoadFile})
        '
        'mnuLoadFile
        '
        Me.mnuLoadFile.Index = 0
        Me.mnuLoadFile.Text = "Load a File..."
        '
        'mnuLoadToLiveDuplicates
        '
        Me.mnuLoadToLiveDuplicates.Index = 3
        Me.mnuLoadToLiveDuplicates.Text = "Load to Live Duplicates..."
        '
        'LoadingQueueSection
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Controls.Add(Me.PanelExecute)
        Me.Name = "LoadingQueueSection"
        Me.Size = New System.Drawing.Size(736, 560)
        Me.PanelExecute.ResumeLayout(False)
        Me.SectionHeader1.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Private Members"

    Private mFile As IO.FileInfo
    Private mRecordCount As Integer
    Private WithEvents package As DTSPackage
    Private mToolStripItems As New List(Of ToolStripItem)
    Private mPackageNavigator As PackageNavigator

#End Region

#Region "Public Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mPackageNavigator = TryCast(navCtrl, PackageNavigator)
        If mPackageNavigator Is Nothing Then
            Throw New ArgumentException("The LoadingQueue section control expects a navigator of type 'PackageNavigator'")
        End If

    End Sub

    Public Overrides Sub ActivateSection()

        If mPackageNavigator IsNot Nothing Then
            AddHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.AllowMultiSelect = False
            mPackageNavigator.RefreshTree(ClientTreeTypes.DefinedPackages)
            mPackageNavigator.TreeContextMenu = cmnExecute

            RefreshQueue()
        End If

    End Sub

    Public Overrides Sub InactivateSection()

        If mPackageNavigator IsNot Nothing Then
            RemoveHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.TreeContextMenu = Nothing
        End If

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Return True

    End Function

    Public Overrides ReadOnly Property ToolStripItems() As System.Collections.Generic.List(Of System.Windows.Forms.ToolStripItem)
        Get
            Return mToolStripItems
        End Get
    End Property

#End Region

#Region "Events"

#Region "Events - Form"

    Private Sub frmPackageExecute_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        EnableFileControls(False)
        startDate.Value = DateTime.Now.AddDays(-1)
        endDate.Value = DateTime.Now

        lblIcon.Visible = False
        lblResults.Visible = False

        LoadQueue()

    End Sub

    Private Sub btnExecute_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExecute.Click

        AddToQueue(LoadTypes.Normal)

    End Sub

    Private Sub btnExecuteDRG_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExecuteDRG.Click

        AddToQueue(LoadTypes.DRGUpdate)

    End Sub

    Private Sub btnExecuteLoadToLive_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExecuteLoadToLive.Click

        LoadToLive()

    End Sub

    Private Sub lvwQueue_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwQueue.DoubleClick

        ViewHistoryCommand()

    End Sub

    Private Sub rbInProgress_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rbInProgress.CheckedChanged

        lblDate1.Visible = Not rbInProgress.Checked
        lblDate2.Visible = Not rbInProgress.Checked
        startDate.Visible = Not rbInProgress.Checked
        endDate.Visible = Not rbInProgress.Checked

        LoadQueue()
        lvwQueue.SortList()

    End Sub

    Private Sub RefreshQueueButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)

        RefreshQueue()

    End Sub

    Private Sub mPackageNavigator_SelectedPackageChanged(ByVal sender As Object, ByVal e As SelectedPackageChangedEventArgs)

        LoadFile(e.NewPackageId)

    End Sub

#End Region

#Region "Events - Menu"

    Private Sub cmnQueueMenu_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmnQueueMenu.Popup

        Dim reviewStates As String = ""

        If lvwQueue.SelectedItems.Count > 0 Then
            'Make all visible
            For Each menuItem As MenuItem In cmnQueueMenu.MenuItems
                menuItem.Visible = True
            Next

            'Get the selected item from the queue
            Dim item As ListViewItem = lvwQueue.SelectedItems(0)

            'Get a list of the file states that would allow for load review and reports
            reviewStates = System.Enum.GetName(GetType(DataFileStates), DataFileStates.AwaitingFirstApproval) & ","
            reviewStates &= System.Enum.GetName(GetType(DataFileStates), DataFileStates.AwaitingFinalApproval) & ","
            reviewStates &= System.Enum.GetName(GetType(DataFileStates), DataFileStates.AwaitingApply)
            reviewStates &= System.Enum.GetName(GetType(DataFileStates), DataFileStates.Applied)

            'Set the visability of the load review and reports menu options
            mnuLoadReview.Visible = (reviewStates.IndexOf(item.SubItems(5).Text) > -1)
            mnuReports.Visible = (reviewStates.IndexOf(item.SubItems(5).Text) > -1)

            'Determine if we can see the Load to Live Duplicates menu option
            mnuLoadToLiveDuplicates.Visible = (item.SubItems(5).Text = System.Enum.GetName(GetType(DataFileStates), DataFileStates.LoadToLiveAwaitingDupApproval) AndAlso CurrentUser.IsFileLoader)

            'Determine if we can see the Abandon menu option
            mnuAbandon.Visible = (rbInProgress.Checked AndAlso CurrentUser.IsFileLoader)
        Else
            'Make all invisible
            For Each menuItem As MenuItem In cmnQueueMenu.MenuItems
                menuItem.Visible = False
            Next
        End If

    End Sub

    Private Sub mnuShowDetails_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuShowDetails.Click

        ViewHistoryCommand()

    End Sub

    Private Sub mnuAbandon_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuAbandon.Click

        Dim item As ListViewItem = lvwQueue.SelectedItems(0)
        Dim dataFileID As Integer

        If Not item Is Nothing Then
            dataFileID = CInt(item.Tag)

            Dim df As New DataFile
            df.LoadFromDB(dataFileID)
            df.Unload(CurrentUser)

            RefreshQueue()
        End If

    End Sub

    Private Sub mnuShowExceptions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuShowExceptions.Click

        Dim item As ListViewItem = lvwQueue.SelectedItems(0)
        Dim dataFileID As Integer
        Dim file As DataFile

        If Not item Is Nothing Then
            dataFileID = CInt(item.Tag)
            file = New DataFile
            file.LoadFromDB(dataFileID)

            If IO.File.Exists(file.ExceptionFilePath) Then
                System.Diagnostics.Process.Start("notepad.exe", file.ExceptionFilePath)
            Else
                MessageBox.Show("There is no exception report for this file.", "DTS Exception Report", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        End If

    End Sub

    Private Sub mnuLoadReview_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuLoadReview.Click

        Dim item As ListViewItem = lvwQueue.SelectedItems(0)
        Dim dataFileID As Integer
        Dim file As DataFile
        Dim main As MainForm = CType(ParentForm, MainForm)

        If Not item Is Nothing Then
            dataFileID = CInt(item.Tag)
            file = New DataFile
            file.LoadFromDB(dataFileID)

            main.QuickReview(file.ClientID, file.StudyID, file.PackageID, file.DataFileID)
        End If

    End Sub

    Private Sub mnuReports_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuReports.Click

        Dim item As ListViewItem = lvwQueue.SelectedItems(0)
        Dim dataFileID As Integer
        Dim file As DataFile
        Dim main As MainForm = CType(ParentForm, MainForm)

        If Not item Is Nothing Then
            dataFileID = CInt(item.Tag)
            file = New DataFile
            file.LoadFromDB(dataFileID)

            main.QuickReport(file.ClientID, file.StudyID, file.PackageID, file.DataFileID)
        End If

    End Sub

    Private Sub cmnExecute_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmnExecute.Popup

        If mPackageNavigator.SelectedNode.PackageID > 0 Then
            mnuLoadFile.Visible = True
        Else
            mnuLoadFile.Visible = False
        End If

    End Sub

    Private Sub mnuLoadFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuLoadFile.Click

        LoadFile(mPackageNavigator.SelectedNode.PackageID)

    End Sub

    Private Sub mnuLoadToLiveDuplicates_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuLoadToLiveDuplicates.Click

        Dim item As ListViewItem = lvwQueue.SelectedItems(0)

        If item Is Nothing Then Exit Sub

        'Get the DataFile
        Dim dataFileID As Integer = CInt(item.Tag)
        Dim file As New DataFile
        file.LoadFromDB(dataFileID)

        'Get the DTSPackage
        Dim package As DTSPackage = New DTSPackage(file.PackageID, file.Version)

        'Get the load to live definitions for this file
        Dim definitions As LoadToLiveDefinitionCollection = LoadToLiveDefinition.GetByDataFileID(dataFileID)

        'Get the tables to be checked
        Dim tableNames As List(Of String) = definitions.GetTableList

        'Loop through all tables and check for duplicates
        For Each tableName As String In tableNames
            'Check this table for duplicates
            Dim duplicatesTable As DataTable = LoadToLiveDefinition.LoadToLiveDuplicateCheck(dataFileID, tableName, package, definitions)

            'If duplicates exist then show the dialog
            If duplicatesTable.Rows.Count > 0 Then
                Using duplicatesForm As New frmLoadToLiveDups(tableName, duplicatesTable, package, dataFileID, definitions)
                    If duplicatesForm.ShowDialog() <> DialogResult.OK Then
                        Exit Sub
                    End If
                End Using
            End If
        Next

        'Set the data file status to LoadToLiveAwaitingUpdate
        file.ChangeState(DataFileStates.LoadToLiveAwaitingUpdate, String.Format("Dups Cleared by {0}", CurrentUser.LoginName), CurrentUser.MemberId)

        'Notify the user that dup checks are complete and the file is scheduled for updating.
        MessageBox.Show("The Load to Live Duplicate Check is complete and your file is queued for updating.", "Load To Live Duplicate Check", MessageBoxButtons.OK, MessageBoxIcon.Information)

    End Sub

#End Region

#End Region

#Region "Public Methods"

    Public Sub LoadFile(ByVal packageID As Integer)

        'When the user selects "Load File" from tree we need to select one and inspect it
        Try
            Cursor = Cursors.WaitCursor
            lblIcon.Visible = False
            lblIcon.ImageIndex = -1
            lblResults.Visible = False
            lblResults.Text = ""

            If packageID > 0 Then
                'Open the package and store it in class variable
                package = New DTSPackage(packageID)

                'Prompt the user for a file
                mFile = GetFileToLoad()
                Cursor = Cursors.WaitCursor

                'If a file was selected then enable all the controls and display the info
                If Not mFile Is Nothing Then
                    EnableFileControls(True)
                    'Inspects the file and displays all info (ie size, record count, etc)
                    DisplayFileInfo()
                End If
            End If

        Catch ex As Exception
            'Show error message
            lblIcon.Visible = True
            lblIcon.ImageIndex = 0
            lblResults.Visible = True
            lblResults.Text = ex.Message
            EnableFileControls(False)

        Finally
            Cursor = Cursors.Default

        End Try

    End Sub

#End Region

#Region "Private Methods"

    Private Sub InitializeToolStripItems()

        Dim item As ToolStripItem = New ToolStripButton("Refresh Queue", My.Resources.Refresh32, New EventHandler(AddressOf RefreshQueueButton_Clicked))
        mToolStripItems.Add(item)

    End Sub

    Private Sub EnableFileControls(ByVal enable As Boolean)

        lblClient.Enabled = enable
        lblStudy.Enabled = enable
        lblPackage.Enabled = enable
        lblFileName.Enabled = enable
        lblFileSize.Enabled = enable
        lblRecordCount.Enabled = enable
        btnExecute.Enabled = enable
        btnExecuteDRG.Enabled = enable
        btnExecuteLoadToLive.Enabled = enable

    End Sub

    Private Function GetFileToLoad() As IO.FileInfo

        'Prompts the user for a file...
        ofdOpenFile.Filter = "All files (*.*)|*.*|Data files (*.txt;*.xls;*.xlsx;*.xlsm;*.dbf;*.mdb;*.xml)|*.txt;*.xls;*.xlsx;*.xlsm;*.dbf;*.mdb;*.xml"
        ofdOpenFile.FilterIndex = 2

        ofdOpenFile.Title = "Select a file to load"
        If ofdOpenFile.ShowDialog() = DialogResult.OK Then
            Return New IO.FileInfo(ofdOpenFile.FileName)
        End If

        Return Nothing

    End Function

    Private Sub DisplayFileInfo()

        'Opens and inspects the file and displays all the info

        'Show client/study/package names
        If Not package Is Nothing Then
            lblClient.Text = String.Format("Client: {0} ({1})", package.Study.ClientName.Trim, package.Study.ClientID)
            lblStudy.Text = String.Format("Study: {0} ({1})", package.Study.StudyName.Trim, package.Study.StudyID)
            lblPackage.Text = String.Format("Package: {0} ({1})", package.PackageName.Trim, package.PackageID)
        End If

        If Not mFile Is Nothing Then
            If mFile.Exists Then
                'Show file name
                lblFileName.Text = String.Format("File Name: {0}", mFile.Name)

                'Show size
                lblFileSize.Text = String.Format("File Size: {0}KB", CInt(mFile.Length / 1024))

                'Get and display record count
                mRecordCount = package.Source.GetRecordCount(mFile.FullName)
                lblRecordCount.Text = String.Format("Record Count: {0}", mRecordCount)

                'Validate the file layout matches the defined package
                Dim errorMessage As String = ""
                Select Case package.Source.ValidateFile(mFile.FullName, errorMessage)
                    Case FileValidationResults.InvalidFile
                        Throw New Exception(errorMessage)

                    Case FileValidationResults.FileWarning
                        If MessageBox.Show(String.Format("{0}{1}Are you sure you want to continue?", errorMessage, vbCrLf), "File Validation Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = DialogResult.No Then
                            Throw New Exception(errorMessage)
                        End If

                    Case FileValidationResults.ValidFile
                        'File is valid so we can display info with no warnings and no errors

                    Case Else
                        Throw New Exception("Could not validate file.  Unknown validation result encountered.")

                End Select
            End If
        End If

    End Sub

    Private Function AddToQueue(ByVal loadType As LoadTypes) As Integer

        'Now the file has been inspected and all looks good so we can add the file to the queue
        Dim newFile As DataFile
        Dim newID As Integer

        Try
            'Show a wait cursor
            Cursor = Cursors.WaitCursor

            'Disable "Add File" controls
            lblIcon.Visible = False
            lblResults.Visible = False
            EnableFileControls(False)

            'Make sure the package is valid
            If Not package.IsValid Then
                Throw New Exception("Invalid package setup.  Please ensure that all destination columns have been mapped.")
            End If

            'Create a new DataFile object and set the properties
            newFile = New DataFile
            With newFile
                .FileSize = CInt(mFile.Length)
                .OriginalFileName = mFile.Name
                .FileName = mFile.Extension
                .Folder = package.DataStorePath & "\"
                .RecordCount = mRecordCount
                .DataSetType = package.Source.DataSetType
                .IsDRGUpdate = (loadType = LoadTypes.DRGUpdate)
                .IsLoadToLive = (loadType = LoadTypes.LoadToLive)
            End With

            'Add the file to the queue
            newID = newFile.QueueDataFile(package.PackageID, package.Version)

            'Now copy the file to the network location specified in app.config
            CopyFileToNetwork(newID.ToString)

            newFile.ChangeState(DataFileStates.FileQueued, "Loaded by " & CurrentUser.LoginName, CurrentUser.MemberId)

            'Show feedback
            lblIcon.Visible = True
            lblIcon.ImageIndex = 1
            lblResults.Visible = True
            lblResults.Text = "File was successfully added to the queue."

            'Refresh the queue
            RefreshQueue()

        Catch ex As SqlClient.SqlException
            'Show error message
            lblIcon.Visible = True
            lblIcon.ImageIndex = 0
            lblResults.Visible = True
            lblResults.Text = String.Format("SQL Exception ({0}){1}{2}", ex.Procedure, vbCrLf, ex.Message)
            newID = -1

        Catch ex As Exception
            'Show error message
            lblIcon.Visible = True
            lblIcon.ImageIndex = 0
            lblResults.Visible = True
            lblResults.Text = ex.Message
            newID = -1

        Finally
            Cursor = Cursors.Default

        End Try

        Return newID

    End Function

    Private Sub CopyFileToNetwork(ByVal newFileName As String)

        'Get the filename which is just a timestamp formatted okay for files
        'New path will be \\NetworkShare\ClientID\StudyID\PackageID\NewFileName.Extension
        Dim newPath As String = String.Format("{0}\{1}{2}", package.DataStorePath, newFileName, mFile.Extension)

        'Make sure the file we are trying to copy exists
        If mFile.Exists Then
            'If the new file already exists (two people trying to queue at EXACT same time) throw exception
            If System.IO.File.Exists(newFileName) Then
                Throw New Exception("File name is not unique.")
            End If

            If package.Source.DataSetType = DataSetTypes.Text Then
                DirectCast(package.Source, DTSTextData).CleanFile(mFile.FullName, newPath)
            Else
                'Copy the file
                mFile.CopyTo(newPath)
            End If

            'Now store the new file in class variable
            mFile = New IO.FileInfo(newPath)
        End If

    End Sub

    Public Sub RefreshQueue()

        'Just reload
        Try
            LoadQueue()
            lvwQueue.SortList()

        Catch ex As Exception
            ReportException(ex, "Refresh Queue Error")

        End Try

    End Sub

    Private Sub LoadQueue()

        'Loads the current File Queue from the database
        'Get the table
        Dim tblQueue As DataTable

        If rbInProgress.Checked Then
            tblQueue = PackageDB.GetLoadingQueue("0,1,2,3,4,5,6,7,8,9,13,15,16,17,18,23", Nothing, Nothing)
        Else
            If Not startDate.Value <= endDate.Value Then
                Throw New Exception("Beginning date must be before the ending date.")
            End If
            tblQueue = PackageDB.GetLoadingQueue("10,11,12,14,19", startDate.Value, endDate.Value)
        End If

        Dim row As DataRow
        Dim item As ListViewItem
        Dim locked As Boolean

        'Clear all current items
        lvwQueue.Items.Clear()

        If Not tblQueue Is Nothing Then
            'Add each file
            For Each row In tblQueue.Rows
                item = New ListViewItem
                item.Text = String.Format("{0} ({1}.{2})", row("strPackage_nm").ToString, row("Package_id"), row("intVersion").ToString)
                item.SubItems.Add(String.Format("{0} ({1})", row("FileName").ToString, row("DataFile_id").ToString))
                item.SubItems.Add(row("intRecords").ToString)
                item.SubItems.Add(row("intLoaded").ToString)
                item.SubItems.Add(row("datOccurred").ToString)
                item.SubItems.Add(row("StateDescription").ToString)
                item.Tag = row("DataFile_id")

                locked = CBool(row("Locked"))
                If locked Then
                    item.ImageIndex = 0
                Else
                    item.ImageIndex = -1
                End If

                lvwQueue.Items.Add(item)
            Next
        End If

    End Sub

    Private Sub ViewHistoryCommand()

        Dim item As ListViewItem = lvwQueue.SelectedItems(0)
        Dim dataFileID As Integer

        If Not item Is Nothing Then
            dataFileID = CInt(item.Tag)

            Dim frmHistory As New frmFileHistory(dataFileID)
            frmHistory.ShowDialog()
        End If

    End Sub

    Private Sub LoadToLive()

        Using loadToLiveForm As New frmLoadToLive(package)
            If loadToLiveForm.ShowDialog() = DialogResult.OK Then
                'Add the file to the queue
                Dim dataFileID As Integer = AddToQueue(LoadTypes.LoadToLive)

                'Check for error condition
                If dataFileID > 0 Then
                    'Get the fields the user selected to be updated
                    Dim updateFields As LoadToLiveDefinitionCollection = loadToLiveForm.SelectedFields(dataFileID)

                    'Save the update fields
                    For Each definition As LoadToLiveDefinition In updateFields
                        definition.Save()
                    Next
                End If
            End If
        End Using

    End Sub

#End Region

End Class
