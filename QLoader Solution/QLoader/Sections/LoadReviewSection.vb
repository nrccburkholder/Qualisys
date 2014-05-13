Option Explicit On 
Option Strict On

Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class LoadReviewSection
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
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents SectionHeader1 As SectionHeader
    Friend WithEvents CaptionSource As NRC.Framework.WinForms.PaneCaption
    Friend WithEvents SectionHeader2 As SectionHeader
    Friend WithEvents lblFMTables As System.Windows.Forms.Label
    Friend WithEvents cboFMTables As System.Windows.Forms.ComboBox
    Friend WithEvents CaptionDestination As NRC.Framework.WinForms.PaneCaption
    Friend WithEvents PaneCaption1 As NRC.Framework.WinForms.PaneCaption
    Friend WithEvents lvwSource As SortableListView
    Friend WithEvents lvwDest As SortableListView
    Friend WithEvents txtFormula As System.Windows.Forms.TextBox
    Friend WithEvents pnlPanelRight As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents pnlPanelLeft As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents splSplitter As System.Windows.Forms.Splitter
    Friend WithEvents btnMoveFirst As System.Windows.Forms.Button
    Friend WithEvents colDestColumnOrdinal As SortableColumn
    Friend WithEvents colDestColumnName As SortableColumn
    Friend WithEvents colDestValue As SortableColumn
    Friend WithEvents colSrcColumnOrdinal As SortableColumn
    Friend WithEvents colSrcColumnName As SortableColumn
    Friend WithEvents colSrcValue As SortableColumn
    Friend WithEvents colDestTable As SortableColumn
    Friend WithEvents pnlBottom As System.Windows.Forms.Panel
    Friend WithEvents pnlNavigation As System.Windows.Forms.Panel
    Friend WithEvents lblLocation As System.Windows.Forms.Label
    Friend WithEvents btnMoveLast As System.Windows.Forms.Button
    Friend WithEvents tmrResetSelection As System.Windows.Forms.Timer
    Friend WithEvents lblGoto As System.Windows.Forms.Label
    Friend WithEvents txtGotoRow As System.Windows.Forms.TextBox
    Friend WithEvents btnGoto As System.Windows.Forms.Button
    Friend WithEvents lblRowRange As System.Windows.Forms.Label
    Friend WithEvents btnForward As System.Windows.Forms.Button
    Friend WithEvents btnBackward As System.Windows.Forms.Button
    Friend WithEvents btnFastBackward As System.Windows.Forms.Button
    Friend WithEvents btnFastForward As System.Windows.Forms.Button
    Friend WithEvents cboGroup As System.Windows.Forms.ComboBox
    Friend WithEvents lblGroup As System.Windows.Forms.Label
    Friend WithEvents cmnReview As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuReviewFile As System.Windows.Forms.MenuItem
    Friend WithEvents mnuRollback As System.Windows.Forms.MenuItem
    Friend WithEvents mnuGroupFiles As System.Windows.Forms.MenuItem
    Friend WithEvents mnuUnGroup As System.Windows.Forms.MenuItem
    Friend WithEvents btnViewSkipped As System.Windows.Forms.LinkLabel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.txtFormula = New System.Windows.Forms.TextBox
        Me.pnlBottom = New System.Windows.Forms.Panel
        Me.pnlNavigation = New System.Windows.Forms.Panel
        Me.btnFastForward = New System.Windows.Forms.Button
        Me.btnFastBackward = New System.Windows.Forms.Button
        Me.lblRowRange = New System.Windows.Forms.Label
        Me.btnGoto = New System.Windows.Forms.Button
        Me.txtGotoRow = New System.Windows.Forms.TextBox
        Me.lblGoto = New System.Windows.Forms.Label
        Me.btnMoveLast = New System.Windows.Forms.Button
        Me.btnForward = New System.Windows.Forms.Button
        Me.lblLocation = New System.Windows.Forms.Label
        Me.btnBackward = New System.Windows.Forms.Button
        Me.btnMoveFirst = New System.Windows.Forms.Button
        Me.btnViewSkipped = New System.Windows.Forms.LinkLabel
        Me.PaneCaption1 = New NRC.Framework.WinForms.PaneCaption
        Me.pnlPanelRight = New NRC.Framework.WinForms.SectionPanel
        Me.lvwDest = New Nrc.Qualisys.QLoader.SortableListView
        Me.colDestTable = New Nrc.Qualisys.QLoader.SortableColumn
        Me.colDestColumnOrdinal = New Nrc.Qualisys.QLoader.SortableColumn
        Me.colDestColumnName = New Nrc.Qualisys.QLoader.SortableColumn
        Me.colDestValue = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SectionHeader2 = New Nrc.Qualisys.QLoader.SectionHeader
        Me.lblFMTables = New System.Windows.Forms.Label
        Me.cboFMTables = New System.Windows.Forms.ComboBox
        Me.CaptionDestination = New NRC.Framework.WinForms.PaneCaption
        Me.splSplitter = New System.Windows.Forms.Splitter
        Me.pnlPanelLeft = New NRC.Framework.WinForms.SectionPanel
        Me.lvwSource = New Nrc.Qualisys.QLoader.SortableListView
        Me.colSrcColumnOrdinal = New Nrc.Qualisys.QLoader.SortableColumn
        Me.colSrcColumnName = New Nrc.Qualisys.QLoader.SortableColumn
        Me.colSrcValue = New Nrc.Qualisys.QLoader.SortableColumn
        Me.SectionHeader1 = New Nrc.Qualisys.QLoader.SectionHeader
        Me.lblGroup = New System.Windows.Forms.Label
        Me.cboGroup = New System.Windows.Forms.ComboBox
        Me.CaptionSource = New Nrc.Framework.WinForms.PaneCaption
        Me.tmrResetSelection = New System.Windows.Forms.Timer(Me.components)
        Me.cmnReview = New System.Windows.Forms.ContextMenu
        Me.mnuReviewFile = New System.Windows.Forms.MenuItem
        Me.mnuRollback = New System.Windows.Forms.MenuItem
        Me.mnuGroupFiles = New System.Windows.Forms.MenuItem
        Me.mnuUnGroup = New System.Windows.Forms.MenuItem
        Me.Panel1.SuspendLayout()
        Me.pnlBottom.SuspendLayout()
        Me.pnlNavigation.SuspendLayout()
        Me.pnlPanelRight.SuspendLayout()
        Me.SectionHeader2.SuspendLayout()
        Me.pnlPanelLeft.SuspendLayout()
        Me.SectionHeader1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.txtFormula)
        Me.Panel1.Controls.Add(Me.pnlBottom)
        Me.Panel1.Controls.Add(Me.PaneCaption1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel1.Location = New System.Drawing.Point(0, 288)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(672, 136)
        Me.Panel1.TabIndex = 0
        '
        'txtFormula
        '
        Me.txtFormula.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtFormula.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtFormula.Location = New System.Drawing.Point(0, 26)
        Me.txtFormula.Multiline = True
        Me.txtFormula.Name = "txtFormula"
        Me.txtFormula.ReadOnly = True
        Me.txtFormula.Size = New System.Drawing.Size(672, 54)
        Me.txtFormula.TabIndex = 1
        '
        'pnlBottom
        '
        Me.pnlBottom.Controls.Add(Me.pnlNavigation)
        Me.pnlBottom.Controls.Add(Me.btnViewSkipped)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(0, 80)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(672, 56)
        Me.pnlBottom.TabIndex = 2
        '
        'pnlNavigation
        '
        Me.pnlNavigation.Controls.Add(Me.btnFastForward)
        Me.pnlNavigation.Controls.Add(Me.btnFastBackward)
        Me.pnlNavigation.Controls.Add(Me.lblRowRange)
        Me.pnlNavigation.Controls.Add(Me.btnGoto)
        Me.pnlNavigation.Controls.Add(Me.txtGotoRow)
        Me.pnlNavigation.Controls.Add(Me.lblGoto)
        Me.pnlNavigation.Controls.Add(Me.btnMoveLast)
        Me.pnlNavigation.Controls.Add(Me.btnForward)
        Me.pnlNavigation.Controls.Add(Me.lblLocation)
        Me.pnlNavigation.Controls.Add(Me.btnBackward)
        Me.pnlNavigation.Controls.Add(Me.btnMoveFirst)
        Me.pnlNavigation.Location = New System.Drawing.Point(0, 0)
        Me.pnlNavigation.Name = "pnlNavigation"
        Me.pnlNavigation.Size = New System.Drawing.Size(472, 64)
        Me.pnlNavigation.TabIndex = 0
        '
        'btnFastForward
        '
        Me.btnFastForward.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnFastForward.Location = New System.Drawing.Point(240, 16)
        Me.btnFastForward.Name = "btnFastForward"
        Me.btnFastForward.Size = New System.Drawing.Size(32, 24)
        Me.btnFastForward.TabIndex = 5
        Me.btnFastForward.Text = ">>"
        '
        'btnFastBackward
        '
        Me.btnFastBackward.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnFastBackward.Location = New System.Drawing.Point(32, 16)
        Me.btnFastBackward.Name = "btnFastBackward"
        Me.btnFastBackward.Size = New System.Drawing.Size(32, 24)
        Me.btnFastBackward.TabIndex = 1
        Me.btnFastBackward.Text = "<<"
        '
        'lblRowRange
        '
        Me.lblRowRange.Font = New System.Drawing.Font("Microsoft Sans Serif", 6.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRowRange.Location = New System.Drawing.Point(392, 40)
        Me.lblRowRange.Name = "lblRowRange"
        Me.lblRowRange.Size = New System.Drawing.Size(56, 16)
        Me.lblRowRange.TabIndex = 9
        '
        'btnGoto
        '
        Me.btnGoto.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnGoto.Location = New System.Drawing.Point(440, 16)
        Me.btnGoto.Name = "btnGoto"
        Me.btnGoto.Size = New System.Drawing.Size(32, 24)
        Me.btnGoto.TabIndex = 10
        Me.btnGoto.Text = "GO"
        '
        'txtGotoRow
        '
        Me.txtGotoRow.Location = New System.Drawing.Point(392, 18)
        Me.txtGotoRow.Name = "txtGotoRow"
        Me.txtGotoRow.Size = New System.Drawing.Size(48, 20)
        Me.txtGotoRow.TabIndex = 8
        '
        'lblGoto
        '
        Me.lblGoto.Location = New System.Drawing.Point(328, 17)
        Me.lblGoto.Name = "lblGoto"
        Me.lblGoto.Size = New System.Drawing.Size(64, 23)
        Me.lblGoto.TabIndex = 7
        Me.lblGoto.Text = "Go To Row"
        Me.lblGoto.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnMoveLast
        '
        Me.btnMoveLast.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnMoveLast.Location = New System.Drawing.Point(272, 16)
        Me.btnMoveLast.Name = "btnMoveLast"
        Me.btnMoveLast.Size = New System.Drawing.Size(32, 24)
        Me.btnMoveLast.TabIndex = 6
        Me.btnMoveLast.Text = ">|"
        '
        'btnForward
        '
        Me.btnForward.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnForward.Location = New System.Drawing.Point(208, 16)
        Me.btnForward.Name = "btnForward"
        Me.btnForward.Size = New System.Drawing.Size(32, 24)
        Me.btnForward.TabIndex = 4
        Me.btnForward.Text = ">"
        '
        'lblLocation
        '
        Me.lblLocation.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.lblLocation.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblLocation.Location = New System.Drawing.Point(96, 16)
        Me.lblLocation.Name = "lblLocation"
        Me.lblLocation.Size = New System.Drawing.Size(112, 24)
        Me.lblLocation.TabIndex = 3
        Me.lblLocation.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnBackward
        '
        Me.btnBackward.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnBackward.Location = New System.Drawing.Point(64, 16)
        Me.btnBackward.Name = "btnBackward"
        Me.btnBackward.Size = New System.Drawing.Size(32, 24)
        Me.btnBackward.TabIndex = 2
        Me.btnBackward.Text = "<"
        '
        'btnMoveFirst
        '
        Me.btnMoveFirst.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnMoveFirst.Location = New System.Drawing.Point(0, 16)
        Me.btnMoveFirst.Name = "btnMoveFirst"
        Me.btnMoveFirst.Size = New System.Drawing.Size(32, 24)
        Me.btnMoveFirst.TabIndex = 0
        Me.btnMoveFirst.Text = "|<"
        '
        'btnViewSkipped
        '
        Me.btnViewSkipped.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnViewSkipped.Enabled = False
        Me.btnViewSkipped.Location = New System.Drawing.Point(496, 16)
        Me.btnViewSkipped.Name = "btnViewSkipped"
        Me.btnViewSkipped.Size = New System.Drawing.Size(168, 24)
        Me.btnViewSkipped.TabIndex = 1
        Me.btnViewSkipped.TabStop = True
        Me.btnViewSkipped.Text = "View Skipped Records"
        Me.btnViewSkipped.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'PaneCaption1
        '
        Me.PaneCaption1.Caption = "Formula"
        Me.PaneCaption1.Dock = System.Windows.Forms.DockStyle.Top
        Me.PaneCaption1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.PaneCaption1.Location = New System.Drawing.Point(0, 0)
        Me.PaneCaption1.Name = "PaneCaption1"
        Me.PaneCaption1.Size = New System.Drawing.Size(672, 26)
        Me.PaneCaption1.TabIndex = 0
        Me.PaneCaption1.Text = "Formula"
        '
        'pnlPanelRight
        '
        Me.pnlPanelRight.BackColor = System.Drawing.SystemColors.Control
        Me.pnlPanelRight.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.pnlPanelRight.Caption = ""
        Me.pnlPanelRight.Controls.Add(Me.lvwDest)
        Me.pnlPanelRight.Controls.Add(Me.SectionHeader2)
        Me.pnlPanelRight.Controls.Add(Me.CaptionDestination)
        Me.pnlPanelRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlPanelRight.Location = New System.Drawing.Point(328, 0)
        Me.pnlPanelRight.Name = "pnlPanelRight"
        Me.pnlPanelRight.Padding = New System.Windows.Forms.Padding(1)
        Me.pnlPanelRight.ShowCaption = False
        Me.pnlPanelRight.Size = New System.Drawing.Size(344, 288)
        Me.pnlPanelRight.TabIndex = 5
        '
        'lvwDest
        '
        Me.lvwDest.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwDest.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colDestTable, Me.colDestColumnOrdinal, Me.colDestColumnName, Me.colDestValue})
        Me.lvwDest.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwDest.FullRowSelect = True
        Me.lvwDest.GridLines = True
        Me.lvwDest.HideSelection = False
        Me.lvwDest.Location = New System.Drawing.Point(8, 64)
        Me.lvwDest.MultiSelect = False
        Me.lvwDest.Name = "lvwDest"
        Me.lvwDest.Size = New System.Drawing.Size(328, 216)
        Me.lvwDest.TabIndex = 2
        Me.lvwDest.UseCompatibleStateImageBehavior = False
        Me.lvwDest.View = System.Windows.Forms.View.Details
        '
        'colDestTable
        '
        Me.colDestTable.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colDestTable.Text = "Table"
        '
        'colDestColumnOrdinal
        '
        Me.colDestColumnOrdinal.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.[Integer]
        Me.colDestColumnOrdinal.Text = "Col"
        Me.colDestColumnOrdinal.Width = 28
        '
        'colDestColumnName
        '
        Me.colDestColumnName.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colDestColumnName.Text = "Field Name"
        Me.colDestColumnName.Width = 84
        '
        'colDestValue
        '
        Me.colDestValue.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colDestValue.Text = "Value"
        Me.colDestValue.Width = 116
        '
        'SectionHeader2
        '
        Me.SectionHeader2.Controls.Add(Me.lblFMTables)
        Me.SectionHeader2.Controls.Add(Me.cboFMTables)
        Me.SectionHeader2.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader2.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader2.Name = "SectionHeader2"
        Me.SectionHeader2.Size = New System.Drawing.Size(342, 29)
        Me.SectionHeader2.TabIndex = 1
        '
        'lblFMTables
        '
        Me.lblFMTables.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblFMTables.BackColor = System.Drawing.Color.Transparent
        Me.lblFMTables.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFMTables.Location = New System.Drawing.Point(104, 8)
        Me.lblFMTables.Name = "lblFMTables"
        Me.lblFMTables.Size = New System.Drawing.Size(44, 16)
        Me.lblFMTables.TabIndex = 0
        Me.lblFMTables.Text = "Tables:"
        '
        'cboFMTables
        '
        Me.cboFMTables.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cboFMTables.DisplayMember = "Text"
        Me.cboFMTables.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFMTables.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cboFMTables.ItemHeight = 13
        Me.cboFMTables.Location = New System.Drawing.Point(152, 4)
        Me.cboFMTables.Name = "cboFMTables"
        Me.cboFMTables.Size = New System.Drawing.Size(184, 21)
        Me.cboFMTables.TabIndex = 1
        Me.cboFMTables.ValueMember = "Value"
        '
        'CaptionDestination
        '
        Me.CaptionDestination.Caption = "Destination Data"
        Me.CaptionDestination.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionDestination.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionDestination.Location = New System.Drawing.Point(1, 1)
        Me.CaptionDestination.Name = "CaptionDestination"
        Me.CaptionDestination.Size = New System.Drawing.Size(342, 26)
        Me.CaptionDestination.TabIndex = 0
        Me.CaptionDestination.Text = "Destination Data"
        '
        'splSplitter
        '
        Me.splSplitter.Location = New System.Drawing.Point(312, 0)
        Me.splSplitter.Name = "splSplitter"
        Me.splSplitter.Size = New System.Drawing.Size(16, 288)
        Me.splSplitter.TabIndex = 4
        Me.splSplitter.TabStop = False
        '
        'pnlPanelLeft
        '
        Me.pnlPanelLeft.BackColor = System.Drawing.SystemColors.Control
        Me.pnlPanelLeft.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.pnlPanelLeft.Caption = ""
        Me.pnlPanelLeft.Controls.Add(Me.lvwSource)
        Me.pnlPanelLeft.Controls.Add(Me.SectionHeader1)
        Me.pnlPanelLeft.Controls.Add(Me.CaptionSource)
        Me.pnlPanelLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlPanelLeft.Location = New System.Drawing.Point(0, 0)
        Me.pnlPanelLeft.Name = "pnlPanelLeft"
        Me.pnlPanelLeft.Padding = New System.Windows.Forms.Padding(1)
        Me.pnlPanelLeft.ShowCaption = False
        Me.pnlPanelLeft.Size = New System.Drawing.Size(312, 288)
        Me.pnlPanelLeft.TabIndex = 3
        '
        'lvwSource
        '
        Me.lvwSource.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwSource.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colSrcColumnOrdinal, Me.colSrcColumnName, Me.colSrcValue})
        Me.lvwSource.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwSource.FullRowSelect = True
        Me.lvwSource.GridLines = True
        Me.lvwSource.HideSelection = False
        Me.lvwSource.Location = New System.Drawing.Point(8, 64)
        Me.lvwSource.Name = "lvwSource"
        Me.lvwSource.Size = New System.Drawing.Size(296, 216)
        Me.lvwSource.TabIndex = 2
        Me.lvwSource.TabStop = False
        Me.lvwSource.UseCompatibleStateImageBehavior = False
        Me.lvwSource.View = System.Windows.Forms.View.Details
        '
        'colSrcColumnOrdinal
        '
        Me.colSrcColumnOrdinal.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.[Integer]
        Me.colSrcColumnOrdinal.Text = "Col"
        Me.colSrcColumnOrdinal.Width = 28
        '
        'colSrcColumnName
        '
        Me.colSrcColumnName.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colSrcColumnName.Text = "Field Name"
        Me.colSrcColumnName.Width = 84
        '
        'colSrcValue
        '
        Me.colSrcValue.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colSrcValue.Text = "Value"
        Me.colSrcValue.Width = 119
        '
        'SectionHeader1
        '
        Me.SectionHeader1.Controls.Add(Me.lblGroup)
        Me.SectionHeader1.Controls.Add(Me.cboGroup)
        Me.SectionHeader1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader1.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader1.Name = "SectionHeader1"
        Me.SectionHeader1.Size = New System.Drawing.Size(310, 29)
        Me.SectionHeader1.TabIndex = 1
        '
        'lblGroup
        '
        Me.lblGroup.BackColor = System.Drawing.Color.Transparent
        Me.lblGroup.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGroup.Location = New System.Drawing.Point(8, 8)
        Me.lblGroup.Name = "lblGroup"
        Me.lblGroup.Size = New System.Drawing.Size(64, 29)
        Me.lblGroup.TabIndex = 2
        Me.lblGroup.Text = "Data Files:"
        Me.lblGroup.Visible = False
        '
        'cboGroup
        '
        Me.cboGroup.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cboGroup.DisplayMember = "Text"
        Me.cboGroup.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboGroup.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cboGroup.ItemHeight = 13
        Me.cboGroup.Location = New System.Drawing.Point(72, 4)
        Me.cboGroup.Name = "cboGroup"
        Me.cboGroup.Size = New System.Drawing.Size(232, 21)
        Me.cboGroup.TabIndex = 3
        Me.cboGroup.ValueMember = "Value"
        Me.cboGroup.Visible = False
        '
        'CaptionSource
        '
        Me.CaptionSource.Caption = "Source Data"
        Me.CaptionSource.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionSource.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionSource.Location = New System.Drawing.Point(1, 1)
        Me.CaptionSource.Name = "CaptionSource"
        Me.CaptionSource.Size = New System.Drawing.Size(310, 26)
        Me.CaptionSource.TabIndex = 0
        Me.CaptionSource.Text = "Source Data"
        '
        'tmrResetSelection
        '
        '
        'cmnReview
        '
        Me.cmnReview.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuReviewFile, Me.mnuRollback, Me.mnuGroupFiles, Me.mnuUnGroup})
        '
        'mnuReviewFile
        '
        Me.mnuReviewFile.Index = 0
        Me.mnuReviewFile.Text = "Review File"
        '
        'mnuRollback
        '
        Me.mnuRollback.Index = 1
        Me.mnuRollback.Text = "Unload File"
        '
        'mnuGroupFiles
        '
        Me.mnuGroupFiles.Index = 2
        Me.mnuGroupFiles.Text = "Group Files"
        '
        'mnuUnGroup
        '
        Me.mnuUnGroup.Index = 3
        Me.mnuUnGroup.Text = "UnGroup Files"
        '
        'LoadReviewSection
        '
        Me.Controls.Add(Me.pnlPanelRight)
        Me.Controls.Add(Me.splSplitter)
        Me.Controls.Add(Me.pnlPanelLeft)
        Me.Controls.Add(Me.Panel1)
        Me.Name = "LoadReviewSection"
        Me.Size = New System.Drawing.Size(672, 424)
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.pnlBottom.ResumeLayout(False)
        Me.pnlNavigation.ResumeLayout(False)
        Me.pnlNavigation.PerformLayout()
        Me.pnlPanelRight.ResumeLayout(False)
        Me.SectionHeader2.ResumeLayout(False)
        Me.pnlPanelLeft.ResumeLayout(False)
        Me.SectionHeader1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


#Region " Private Members "

    Private mPackageNavigator As PackageNavigator
    Private WithEvents mReviewCtrl As ReviewCtrl
    Private mChangingSelection As Boolean
    Private mSelectedSourceColumns As New ReviewColumnCollection
    Private mToolStripItems As New List(Of ToolStripItem)

    Private Const TABLE_COLUMN_WIDTH As Integer = 80
    Private Const FAST_MOVE_SPEED As Integer = 50

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property ReviewCtrl() As ReviewCtrl
        Get
            Return mReviewCtrl
        End Get
    End Property

    Public Overrides ReadOnly Property ToolStripItems() As System.Collections.Generic.List(Of System.Windows.Forms.ToolStripItem)
        Get
            Return mToolStripItems
        End Get
    End Property

#End Region

#Region " Event Handlers "

    Private Sub Review_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        mReviewCtrl = New ReviewCtrl

    End Sub

    Private Sub Review_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.SizeChanged

        Dim tableName As String = String.Empty

        'resize left panel and right panel size
        If (cboFMTables.SelectedIndex > -1) Then
            tableName = cboFMTables.SelectedItem.ToString
        End If

        If (tableName = ReviewCtrl.ALL_TABLE_LABEL) Then
            pnlPanelLeft.Width = CInt((Width - splSplitter.Width) * 0.45)
            lvwDest.Columns(0).Width = TABLE_COLUMN_WIDTH
        Else
            pnlPanelLeft.Width = CInt((Width - splSplitter.Width) / 2)
            lvwDest.Columns(0).Width = 0
        End If

        lvwSource.Width = pnlPanelLeft.Width - 16
        lvwDest.Width = pnlPanelRight.Width - 16

        'resize the "value" column width 
        With lvwSource
            .Columns(2).Width = .Width - .Columns(0).Width - .Columns(1).Width - 20
        End With

        With lvwDest
            .Columns(3).Width = .Width - .Columns(0).Width - .Columns(1).Width - .Columns(2).Width - 20
        End With

    End Sub

    Private Sub cboFMTables_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboFMTables.SelectedIndexChanged

        If (cboFMTables.SelectedIndex = -1) Then Return

        Review_SizeChanged(Nothing, Nothing)
        InitializeDestColumnName()
        ShowDestData()
        ClearListViewSelection(lvwSource)

    End Sub

    Private Sub btnMoveFirst_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveFirst.Click

        If (mReviewCtrl.CurrentRecordID <= 1) Then Return

        mReviewCtrl.CurrentRecordID = 1
        ShowRecord()

    End Sub

    Private Sub btnFastBackward_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFastBackward.Click

        Dim recordID As Integer = mReviewCtrl.CurrentRecordID - FAST_MOVE_SPEED

        If (recordID < 1) Then recordID = 1
        mReviewCtrl.CurrentRecordID = recordID
        ShowRecord()

    End Sub

    Private Sub btnBackward_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBackward.Click

        If (mReviewCtrl.CurrentRecordID <= 1) Then Return

        mReviewCtrl.CurrentRecordID -= 1
        ShowRecord()

    End Sub

    Private Sub btnForward_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnForward.Click

        If (mReviewCtrl.CurrentRecordID >= mReviewCtrl.RecordCount) Then Return

        mReviewCtrl.CurrentRecordID += 1
        ShowRecord()

    End Sub

    Private Sub btnFastForward_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFastForward.Click

        Dim recordID As Integer = mReviewCtrl.CurrentRecordID + FAST_MOVE_SPEED
        If (recordID > mReviewCtrl.RecordCount) Then recordID = mReviewCtrl.RecordCount
        mReviewCtrl.CurrentRecordID = recordID
        ShowRecord()

    End Sub

    Private Sub btnMoveLast_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveLast.Click

        If (mReviewCtrl.CurrentRecordID >= mReviewCtrl.RecordCount) Then Return

        mReviewCtrl.CurrentRecordID = mReviewCtrl.RecordCount
        ShowRecord()

    End Sub

    Private Sub lvwDest_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwDest.SelectedIndexChanged

        'Clear selection in source column and formula box
        ClearListViewSelection(lvwSource)
        txtFormula.Clear()

        If (lvwDest.SelectedItems.Count <= 0) Then Return

        'Find the selected destincation column
        Dim item As ListViewItem = lvwDest.SelectedItems(0)
        Dim tableName As String = item.SubItems(0).Text
        Dim columnName As String = item.SubItems(2).Text
        Dim formula As String = ""
        Dim sourceColumns As ReviewColumnCollection = Nothing
        Dim firstItem As Boolean = True

        'Find the formula and related source columns for the selected destination column
        If (Not mReviewCtrl.DestColumnFormula(tableName, columnName, formula, sourceColumns)) Then Return

        'Show formula
        txtFormula.Text = formula

        'Highlight related source columns
        mSelectedSourceColumns = sourceColumns
        Dim col As ReviewColumn
        For Each col In sourceColumns
            item = SearchSourceColumn(col.ColumnName)
            If (Not item Is Nothing) Then
                mChangingSelection = True
                item.Selected = True
                If (firstItem) Then
                    item.EnsureVisible()
                    firstItem = False
                End If
            End If
        Next

    End Sub

    Private Sub lvwSource_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwSource.SelectedIndexChanged

        If (mChangingSelection) Then    'if change selection programmatically, do nothing
            mChangingSelection = False
            Return
        Else    'if selected by user click, restore the original selection
            tmrResetSelection.Interval = 1
            tmrResetSelection.Start()
        End If

    End Sub

    'Restore the original selection in source table
    Private Sub tmrResetSelection_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tmrResetSelection.Tick

        tmrResetSelection.Stop()
        ClearListViewSelection(lvwSource)

        For Each col As ReviewColumn In mSelectedSourceColumns
            Dim item As ListViewItem = SearchSourceColumn(col.ColumnName)
            If (Not item Is Nothing) Then
                mChangingSelection = True
                item.Selected = True
            End If
        Next

    End Sub

    Private Sub btnGoto_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGoto.Click

        If ((mReviewCtrl Is Nothing) OrElse (Not mReviewCtrl.DataAvailable)) Then Return

        Try
            Dim row As Integer = Integer.Parse(txtGotoRow.Text)

            If (row < 1) Then row = 1
            If (row > mReviewCtrl.RecordCount) Then row = mReviewCtrl.RecordCount

            txtGotoRow.Text = row.ToString

            If (mReviewCtrl.CurrentRecordID = row) Then Return

            mReviewCtrl.CurrentRecordID = row
            ShowRecord()

        Catch ex As Exception
            ReportException(ex, "Go To Error")

        End Try

    End Sub

    'another file in the group combo box is selected
    Private Sub cboGroup_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboGroup.SelectedIndexChanged

        Dim fileID As Integer = CInt(cboGroup.SelectedValue)

        If (fileID <= 0) Then Return

        mReviewCtrl.Initial(fileID, True)

    End Sub

    'Review control: a new group is selected
    Private Sub ReviewCtrl_GroupChanged() Handles mReviewCtrl.GroupChanged

        InitSettings()
        PopulateFileList()
        PopulateTableList()
        InitializeColumnName()
        ShowRecord()
        ShowRecordCount()
        SetViewSkippedButton()

    End Sub

    'Review control: another file in the group is selected
    Private Sub ReviewCtrl_FileSwitched() Handles mReviewCtrl.FileSwitched

        InitSettings()
        PopulateTableList()
        InitializeColumnName()
        ShowRecord()
        ShowRecordCount()
        SetViewSkippedButton()

    End Sub

    'View skipped record
    Private Sub btnViewSkipped_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnViewSkipped.LinkClicked

        Dim dataFileID As Integer = mReviewCtrl.DataFileID

        If (dataFileID <= 0) Then Return

        Dim table As DataTable = PackageDB.GetSkippedRecord(dataFileID)
        Dim form As New frmDataGrid(table)

        form.FormBorderStyle = FormBorderStyle.Sizable
        form.ShowDialog()

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mPackageNavigator = TryCast(navCtrl, PackageNavigator)
        If mPackageNavigator Is Nothing Then
            Throw New ArgumentException("The LoadReview section control expects a navigator of type 'PackageNavigator'")
        End If

    End Sub

    Public Overrides Sub ActivateSection()

        If mPackageNavigator IsNot Nothing Then
            AddHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.AllowMultiSelect = True
            mPackageNavigator.RefreshTree(ClientTreeTypes.FilesInQueue)
            mPackageNavigator.TreeContextMenu = cmnReview
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

#End Region

#Region " Private Methods "

    Private Sub InitSettings()

        mChangingSelection = False
        mSelectedSourceColumns.Clear()

        lvwSource.BeginUpdate()
        For Each item As ListViewItem In lvwSource.Items
            item.SubItems(2).Text = ""
        Next
        lvwSource.EndUpdate()

        lvwDest.BeginUpdate()
        For Each item As ListViewItem In lvwDest.Items
            item.SubItems(3).Text = ""
        Next
        lvwDest.EndUpdate()

        txtFormula.Clear()

        lblLocation.Text = "0 / 0"
        txtGotoRow.Clear()
        lblRowRange.Text = String.Empty

    End Sub

    Private Sub InitializeToolStripItems()

        Dim item As ToolStripItem = New ToolStripButton("Unload File", My.Resources.Undo32, New EventHandler(AddressOf UnloadFileButton_Clicked))
        item.Enabled = CurrentUser.IsFileLoader
        mToolStripItems.Add(item)

    End Sub

    Private Sub PopulateFileList()

        If (Not mReviewCtrl.IsGrouped) Then
            lblGroup.Visible = False
            cboGroup.Visible = False
            Return
        Else
            cboGroup.DataSource = mReviewCtrl.GroupList
            cboGroup.SelectedIndex = 0
            lblGroup.Visible = True
            cboGroup.Visible = True
        End If

    End Sub

    'Populate table list in destination table combo box
    Private Sub PopulateTableList()

        Dim destTableList() As String = mReviewCtrl.DestTableList

        'Clear table combo box
        cboFMTables.Items.Clear()

        'Add entry to table combo box
        For cnt As Integer = 0 To destTableList.Length - 1
            cboFMTables.Items.Add(destTableList(cnt))
        Next

        'Select the first entry 
        cboFMTables.SelectedIndex = 0

    End Sub

    Private Sub InitializeColumnName()

        InitializeSrcColumnName()
        InitializeDestColumnName()

    End Sub

    'Show source table column names
    Private Sub InitializeSrcColumnName()

        Dim columns As ReviewColumnCollection = mReviewCtrl.SourceColumns

        lvwSource.BeginUpdate()
        lvwSource.Items.Clear()

        For Each col As ReviewColumn In columns
            Dim item As ListViewItem = New ListViewItem(col.Ordinal.ToString)
            item.SubItems.Add(col.ColumnName)
            item.SubItems.Add("")   'value column
            lvwSource.Items.Add(item)
        Next

        lvwSource.EndUpdate()

    End Sub

    'Show destination table column names
    Private Sub InitializeDestColumnName()

        Dim mDestTableName As String = cboFMTables.SelectedItem.ToString
        Dim columns As ReviewColumnCollection = mReviewCtrl.DestColumns(mDestTableName)

        lvwDest.BeginUpdate()
        lvwDest.Items.Clear()

        For Each col As ReviewColumn In columns
            Dim item As ListViewItem = New ListViewItem(col.TableName)
            item.SubItems.Add(col.Ordinal.ToString)
            item.SubItems.Add(col.ColumnName)
            item.SubItems.Add("")   'value column
            lvwDest.Items.Add(item)
        Next

        lvwDest.EndUpdate()

    End Sub

    'Show current record of source/destination tables.
    'Update the position label
    Private Sub ShowRecord()

        If (ReviewCtrl.NoData) Then Return

        UpdateTrackBarLabel()
        ShowSrcData()
        ShowDestData()

    End Sub

    'Update the position label
    Private Sub UpdateTrackBarLabel()

        lblLocation.Text = String.Format("{0} of {1}", mReviewCtrl.CurrentRecordID, mReviewCtrl.RecordCount)

    End Sub

    'Show current record of source table
    Private Sub ShowSrcData()

        lvwSource.BeginUpdate()

        For Each item As ListViewItem In lvwSource.Items
            Dim colName As String = item.SubItems(1).Text
            item.SubItems(2).Text = mReviewCtrl.SourceValue(colName)
        Next

        lvwSource.EndUpdate()

    End Sub

    'Show current record of destination table
    Private Sub ShowDestData()

        lvwDest.BeginUpdate()

        For Each item As ListViewItem In lvwDest.Items
            Dim tableName As String = item.SubItems(0).Text
            Dim colName As String = item.SubItems(2).Text
            item.SubItems(3).Text = mReviewCtrl.DestValue(tableName, colName)
        Next

        lvwDest.EndUpdate()

    End Sub

    Private Sub ShowRecordCount()

        lblRowRange.Text = String.Format("({0} - {1})", mReviewCtrl.FirstRecordID, mReviewCtrl.RecordCount)

    End Sub

    'Clear selections in specfic listview
    Private Sub ClearListViewSelection(ByVal lvw As ListView)

        For Each item As ListViewItem In lvw.SelectedItems
            mChangingSelection = True
            item.Selected = False
        Next

    End Sub

    'Search item in source table with the column name
    Private Function SearchSourceColumn(ByVal columnName As String) As ListViewItem

        columnName = columnName.ToLower

        For Each item As ListViewItem In lvwSource.Items
            If (item.SubItems(1).Text.ToLower = columnName) Then Return item
        Next

        Return Nothing

    End Function

    Private Sub SetViewSkippedButton()

        btnViewSkipped.Text = String.Format("View Skipped Records ({0})", mReviewCtrl.SkippedCount)
        btnViewSkipped.Enabled = (mReviewCtrl.SkippedCount > 0)

    End Sub

    Private Sub mPackageNavigator_SelectedPackageChanged(ByVal sender As Object, ByVal e As SelectedPackageChangedEventArgs)

        ReviewFileCommand()

    End Sub

    Private Sub UnloadFileButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)

        RollBackCommand()

    End Sub

#End Region

#Region " Loading Review Methods "

    Private Sub cmnReview_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmnReview.Popup

        Dim item As MenuItem

        'Hide all menu items
        For Each item In cmnReview.MenuItems
            item.Visible = False
        Next

        Dim canGroup As Boolean = True
        Dim canUnGroup As Boolean = True

        If Not mPackageNavigator.SelectedNode Is Nothing AndAlso mPackageNavigator.SelectedNode.FileID > 0 Then
            mnuReviewFile.Visible = True
            mnuRollback.Visible = CurrentUser.IsFileLoader

            'If multiple nodes selected then deal with group/ungroup
            If mPackageNavigator.SelectedNodes.Count > 1 Then
                'Determine if these nodes can be grouped/ungrouped
                For Each node As PackageNode In mPackageNavigator.SelectedNodes
                    canGroup = (canGroup AndAlso Not node.IsGrouped)
                    canUnGroup = (canUnGroup AndAlso node.IsGrouped)
                Next

                'Can't rollback multiple files
                mnuRollback.Visible = False
                mnuGroupFiles.Visible = canGroup AndAlso CurrentUser.IsFileLoader
                mnuUnGroup.Visible = canUnGroup AndAlso CurrentUser.IsFileLoader

                'Can see review option on multiple files only if in a group
                mnuReviewFile.Visible = canUnGroup
            End If
        End If

    End Sub

    Private Sub mnuGroupFiles_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuGroupFiles.Click

        Dim fileList As String = String.Empty

        If Not mPackageNavigator.SelectedNode Is Nothing Then
            If mPackageNavigator.SelectedNodes.Count > 1 Then
                For Each node As PackageNode In mPackageNavigator.SelectedNodes
                    fileList &= node.FileID & ","
                Next

                If fileList.Length > 0 Then
                    fileList = fileList.Substring(0, fileList.Length - 1)
                End If

                If Not PackageDB.GroupFiles(fileList) Then
                    Throw New Exception("Grouping exception.  Stored procedure returned an error code.")
                End If
            End If
        End If

        mPackageNavigator.RefreshTree()

    End Sub

    Private Sub mnuUnGroup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuUnGroup.Click

        Dim fileList As String = String.Empty

        If Not mPackageNavigator.SelectedNode Is Nothing Then
            fileList = mPackageNavigator.SelectedNode.GroupList

            If Not PackageDB.UnGroupFiles(fileList) Then
                Throw New Exception("Ungrouping exception.  Stored procedure returned an error code.")
            End If
        End If

        mPackageNavigator.RefreshTree()

    End Sub

    Private Sub mnuReviewFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuReviewFile.Click

        ReviewFileCommand()

    End Sub

    Private Sub ReviewFileCommand()

        Dim pack As DTSPackage

        If Not mPackageNavigator.SelectedNode Is Nothing AndAlso mPackageNavigator.SelectedNode.FileID > 0 Then
            pack = New DTSPackage(mPackageNavigator.SelectedNode.PackageID)
            ReviewCtrl.Initial(mPackageNavigator.SelectedNode.FileID, False)
        End If

    End Sub

    Public Sub QuickReview(ByVal clientID As Integer, ByVal studyID As Integer, ByVal packageID As Integer, ByVal dataFileID As Integer)

        Dim nodeID As String = clientID & studyID & packageID & dataFileID

        mPackageNavigator.SelectNode(nodeID, "")
        ReviewCtrl.Initial(dataFileID, False)

    End Sub

    Private Sub mnuRollback_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuRollback.Click

        RollBackCommand()

    End Sub

    Private Sub RollBackCommand()

        If mPackageNavigator.SelectedNode Is Nothing OrElse mPackageNavigator.SelectedNode.FileID < 1 Then
            MessageBox.Show("You must select a file to unload.", "Unload Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Try
            Cursor = Cursors.WaitCursor

            Dim file As New DataFile
            file.LoadFromDB(mPackageNavigator.SelectedNode.FileID)
            file.Unload(CurrentUser)

            'Now refresh the tree
            mPackageNavigator.RefreshTree()

        Catch ex As Exception
            ReportException(ex, "File Unload Error")

        Finally
            Cursor = Cursors.Default

        End Try

    End Sub

#End Region

End Class
