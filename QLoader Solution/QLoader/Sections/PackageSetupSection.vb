Option Strict Off

Imports Nrc.Qualisys.QLoader.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class PackageSetupSection
    Inherits Section

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.UserPaint Or _
        ControlStyles.AllPaintingInWmPaint Or ControlStyles.ResizeRedraw, True)

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
    Friend WithEvents PanelTop As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents PanelBottom As System.Windows.Forms.Panel
    Friend WithEvents Splitter2 As System.Windows.Forms.Splitter
    Friend WithEvents PanelLeft As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents PanelRight As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents SectionHeader1 As SectionHeader
    Friend WithEvents SectionHeader2 As SectionHeader
    Friend WithEvents lblFMTables As System.Windows.Forms.Label
    Friend WithEvents btnConfigure As System.Windows.Forms.LinkLabel
    Friend WithEvents lvwStudyTables As System.Windows.Forms.ListView
    Friend WithEvents colCheckedTable As System.Windows.Forms.ColumnHeader
    Friend WithEvents colStudyTables As System.Windows.Forms.ColumnHeader
    Friend WithEvents lblStudyTables As System.Windows.Forms.Label
    Friend WithEvents lblPackageName As System.Windows.Forms.Label
    Friend WithEvents txtPackageName As System.Windows.Forms.TextBox
    Friend WithEvents cboPackageOwners As System.Windows.Forms.ComboBox
    Friend WithEvents lblPackageOwner As System.Windows.Forms.Label
    Friend WithEvents cmnSource As System.Windows.Forms.ContextMenu
    Friend WithEvents MenuItem8 As System.Windows.Forms.MenuItem
    Friend WithEvents cmnDestination As System.Windows.Forms.ContextMenu
    Friend WithEvents MenuItem1 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem5 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem2 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem7 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem3 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem4 As System.Windows.Forms.MenuItem
    Friend WithEvents lvwTarget As SortableListView
    Friend WithEvents colTTMapped As SortableColumn
    Friend WithEvents colTTTable As SortableColumn
    Friend WithEvents colTTField As SortableColumn
    Friend WithEvents colTTType As SortableColumn
    Friend WithEvents colTTFreqs As SortableColumn
    Friend WithEvents colTTNulls As SortableColumn
    Friend WithEvents colTTSourceField As SortableColumn
    Friend WithEvents lvwSource As SortableListView
    Friend WithEvents colSTMapped As SortableColumn
    Friend WithEvents colSTColumn As SortableColumn
    Friend WithEvents colSTField As SortableColumn
    Friend WithEvents colSTType As SortableColumn
    Friend WithEvents CaptionPackage As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents CaptionDestination As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents CaptionSource As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents OpenFile As System.Windows.Forms.OpenFileDialog
    Friend WithEvents colMapCount As SortableColumn
    Friend WithEvents imlSmall As System.Windows.Forms.ImageList
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents btnModifySource As System.Windows.Forms.LinkLabel
    Friend WithEvents ToolTip As System.Windows.Forms.ToolTip
    Friend WithEvents cboTableFilter As System.Windows.Forms.ComboBox
    Friend WithEvents mnuMapField As System.Windows.Forms.MenuItem
    Friend WithEvents lvwNotes As System.Windows.Forms.ListView
    Friend WithEvents btnNotes As System.Windows.Forms.LinkLabel
    Friend WithEvents txtNotes As System.Windows.Forms.TextBox
    Friend WithEvents cmnNotes As System.Windows.Forms.ContextMenu
    Friend WithEvents btnNewNote As System.Windows.Forms.MenuItem
    Friend WithEvents colNotes As System.Windows.Forms.ColumnHeader
    Friend WithEvents btnSaveNote As System.Windows.Forms.LinkLabel
    Friend WithEvents btnCancelNote As System.Windows.Forms.LinkLabel
    Friend WithEvents colTTPII As SortableColumn
    Friend WithEvents cmnSetup As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuOpenPackage As System.Windows.Forms.MenuItem
    Friend WithEvents mnuNewPackage As System.Windows.Forms.MenuItem
    Friend WithEvents mnuSaveAs As System.Windows.Forms.MenuItem
    Friend WithEvents mnuDeletePackage As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem6 As System.Windows.Forms.MenuItem
    Friend WithEvents mnuMFV As System.Windows.Forms.MenuItem
    Friend WithEvents mnuClientFunction As System.Windows.Forms.MenuItem
    Friend WithEvents mnuUnlockPackage As System.Windows.Forms.MenuItem
    Friend WithEvents lblPackageFriendlyName As System.Windows.Forms.Label
    Friend WithEvents txtPackageFriendlyName As System.Windows.Forms.TextBox
    Friend WithEvents tlpPackage As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents chkInactive As System.Windows.Forms.CheckBox
    Friend WithEvents tlpNotes As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents mnuRestorePackage As System.Windows.Forms.MenuItem
    Friend WithEvents colTTTransferUS As SortableColumn
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim ListViewItem1 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem("15 JUN 2004 (JCamp)", 3)
        Dim ListViewItem2 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem("6/16/2004 (BDohmen)", 3)
        Dim ListViewItem3 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem("June 17 2004 (JFleming)", 3)
        Dim ListViewItem4 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem("June 18 2004 (DPetersen)", 3)
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PackageSetupSection))
        Dim ListViewItem5 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population"}, -1)
        Dim ListViewItem6 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Encounter"}, -1)
        Dim ListViewItem7 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Provider"}, 5)
        Dim ListViewItem8 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New System.Windows.Forms.ListViewItem.ListViewSubItem() {New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, ""), New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, "Population"), New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, "MRN", System.Drawing.Color.Red, System.Drawing.SystemColors.Window, New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))), New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, "varchar (42)"), New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, ""), New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, "X"), New System.Windows.Forms.ListViewItem.ListViewSubItem(Nothing, "MRN")}, 1)
        Dim ListViewItem9 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "LName", "varchar (100)", "", "X", "TRIM(LName)"}, 2)
        Dim ListViewItem10 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "FName", "varchar(100)", "", "X", "TRIM(FName)"}, 2)
        Dim ListViewItem11 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "MName", "varchar (1)", "", "", "TRIM(MName)"}, -1)
        Dim ListViewItem12 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Addr", "varchar (100)", "6", "X", ""}, -1)
        Dim ListViewItem13 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "City", "varchar (100)", "", "X", ""}, -1)
        Dim ListViewItem14 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "ST", "varchar (2)", "", "X", ""}, -1)
        Dim ListViewItem15 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "ZIP5", "varchar (5)", "", "X", ""}, -1)
        Dim ListViewItem16 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "DOB", "datetime (8)", "1", "X", "DOB"}, -1)
        Dim ListViewItem17 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Sex", "varchar (1)", "1", "X", "Sex"}, -1)
        Dim ListViewItem18 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Age", "Integer (4)", "1", "X", "INT((TODAY-DOB)/365.25)"}, -1)
        Dim ListViewItem19 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "AddrStat", "varchar (100)", "1", "", ""}, -1)
        Dim ListViewItem20 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "AddrErr", "varchar (100)", "", "", ""}, -1)
        Dim ListViewItem21 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Zip4", "varchar (4)", "", "", ""}, -1)
        Dim ListViewItem22 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "NewRecordDate", "datetime (8)", "", "", "TODAY"}, -1)
        Dim ListViewItem23 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "LangID", "integer (4)", "", "", "1"}, -1)
        Dim ListViewItem24 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Del_pt", "varchar (3)", "", "", ""}, -1)
        Dim ListViewItem25 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Race", "varchar (100)", "1", "", "Race"}, -1)
        Dim ListViewItem26 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "Phone", "varchar (10)", "", "", "Phone"}, -1)
        Dim ListViewItem27 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "PhoneStat", "integer (4)", "", "", ""}, -1)
        Dim ListViewItem28 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "pop_id", "integer (4)", "", "", ""}, -1)
        Dim ListViewItem29 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "AreaCode", "varchar (3)", "", "", "AreaCode"}, -1)
        Dim ListViewItem30 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "Population", "NameStat", "varchar (10)", "", "", ""}, -1)
        Dim ListViewItem31 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "1", "LName", "varchar (100)"}, -1)
        Dim ListViewItem32 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "2", "FName", "varchar (100)"}, -1)
        Dim ListViewItem33 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "3", "Middle", "varchar (1)"}, -1)
        Dim ListViewItem34 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "4", "Addr", "varchar (100)"}, -1)
        Dim ListViewItem35 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "5", "City", "varchar (100)"}, -1)
        Dim ListViewItem36 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "6", "ST", "varchar (2)"}, -1)
        Dim ListViewItem37 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "7", "ZIP", "varchar (5)"}, -1)
        Dim ListViewItem38 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "8", "Phone", "varchar (10)"}, -1)
        Dim ListViewItem39 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "9", "AreaCode", "varchar (3)"}, -1)
        Dim ListViewItem40 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "10", "MRN", "varchar (100)"}, -1)
        Dim ListViewItem41 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "1", "11", "DOB", "datetime (8)"}, -1)
        Dim ListViewItem42 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "2", "12", "Sex", "varchar (1)"}, -1)
        Dim ListViewItem43 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"", "0", "13", "Race", "varchar (100)"}, -1)
        Me.PanelTop = New Nrc.Framework.WinForms.SectionPanel()
        Me.tlpPackage = New System.Windows.Forms.TableLayoutPanel()
        Me.tlpNotes = New System.Windows.Forms.TableLayoutPanel()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.lvwNotes = New System.Windows.Forms.ListView()
        Me.colNotes = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.cmnNotes = New System.Windows.Forms.ContextMenu()
        Me.btnNewNote = New System.Windows.Forms.MenuItem()
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.btnCancelNote = New System.Windows.Forms.LinkLabel()
        Me.btnSaveNote = New System.Windows.Forms.LinkLabel()
        Me.btnNotes = New System.Windows.Forms.LinkLabel()
        Me.lblPackageOwner = New System.Windows.Forms.Label()
        Me.lblPackageName = New System.Windows.Forms.Label()
        Me.lblStudyTables = New System.Windows.Forms.Label()
        Me.cboPackageOwners = New System.Windows.Forms.ComboBox()
        Me.txtPackageName = New System.Windows.Forms.TextBox()
        Me.lblPackageFriendlyName = New System.Windows.Forms.Label()
        Me.txtPackageFriendlyName = New System.Windows.Forms.TextBox()
        Me.lvwStudyTables = New System.Windows.Forms.ListView()
        Me.colCheckedTable = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.colStudyTables = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.imlSmall = New System.Windows.Forms.ImageList(Me.components)
        Me.chkInactive = New System.Windows.Forms.CheckBox()
        Me.CaptionPackage = New Nrc.Framework.WinForms.PaneCaption()
        Me.PanelBottom = New System.Windows.Forms.Panel()
        Me.PanelRight = New Nrc.Framework.WinForms.SectionPanel()
        Me.lvwTarget = New Nrc.Qualisys.QLoader.SortableListView()
        Me.colTTMapped = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTTable = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTField = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTType = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTFreqs = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTNulls = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTSourceField = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTPII = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colTTTransferUS = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.cmnDestination = New System.Windows.Forms.ContextMenu()
        Me.MenuItem1 = New System.Windows.Forms.MenuItem()
        Me.MenuItem5 = New System.Windows.Forms.MenuItem()
        Me.mnuMapField = New System.Windows.Forms.MenuItem()
        Me.MenuItem2 = New System.Windows.Forms.MenuItem()
        Me.MenuItem7 = New System.Windows.Forms.MenuItem()
        Me.MenuItem3 = New System.Windows.Forms.MenuItem()
        Me.MenuItem4 = New System.Windows.Forms.MenuItem()
        Me.SectionHeader2 = New Nrc.Qualisys.QLoader.SectionHeader()
        Me.lblFMTables = New System.Windows.Forms.Label()
        Me.cboTableFilter = New System.Windows.Forms.ComboBox()
        Me.CaptionDestination = New Nrc.Framework.WinForms.PaneCaption()
        Me.Splitter2 = New System.Windows.Forms.Splitter()
        Me.PanelLeft = New Nrc.Framework.WinForms.SectionPanel()
        Me.lvwSource = New Nrc.Qualisys.QLoader.SortableListView()
        Me.colSTMapped = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colMapCount = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colSTColumn = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colSTField = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.colSTType = CType(New Nrc.Qualisys.QLoader.SortableColumn(), Nrc.Qualisys.QLoader.SortableColumn)
        Me.cmnSource = New System.Windows.Forms.ContextMenu()
        Me.MenuItem8 = New System.Windows.Forms.MenuItem()
        Me.SectionHeader1 = New Nrc.Qualisys.QLoader.SectionHeader()
        Me.btnConfigure = New System.Windows.Forms.LinkLabel()
        Me.btnModifySource = New System.Windows.Forms.LinkLabel()
        Me.CaptionSource = New Nrc.Framework.WinForms.PaneCaption()
        Me.OpenFile = New System.Windows.Forms.OpenFileDialog()
        Me.ToolTip = New System.Windows.Forms.ToolTip(Me.components)
        Me.cmnSetup = New System.Windows.Forms.ContextMenu()
        Me.mnuOpenPackage = New System.Windows.Forms.MenuItem()
        Me.mnuNewPackage = New System.Windows.Forms.MenuItem()
        Me.mnuSaveAs = New System.Windows.Forms.MenuItem()
        Me.mnuDeletePackage = New System.Windows.Forms.MenuItem()
        Me.mnuUnlockPackage = New System.Windows.Forms.MenuItem()
        Me.MenuItem6 = New System.Windows.Forms.MenuItem()
        Me.mnuMFV = New System.Windows.Forms.MenuItem()
        Me.mnuClientFunction = New System.Windows.Forms.MenuItem()
        Me.mnuRestorePackage = New System.Windows.Forms.MenuItem()
        Me.PanelTop.SuspendLayout()
        Me.tlpPackage.SuspendLayout()
        Me.tlpNotes.SuspendLayout()
        Me.PanelBottom.SuspendLayout()
        Me.PanelRight.SuspendLayout()
        Me.SectionHeader2.SuspendLayout()
        Me.PanelLeft.SuspendLayout()
        Me.SectionHeader1.SuspendLayout()
        Me.SuspendLayout()
        '
        'PanelTop
        '
        Me.PanelTop.BackColor = System.Drawing.SystemColors.Control
        Me.PanelTop.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.PanelTop.Caption = ""
        Me.PanelTop.Controls.Add(Me.tlpPackage)
        Me.PanelTop.Controls.Add(Me.CaptionPackage)
        Me.PanelTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.PanelTop.Location = New System.Drawing.Point(0, 0)
        Me.PanelTop.Name = "PanelTop"
        Me.PanelTop.Padding = New System.Windows.Forms.Padding(1)
        Me.PanelTop.ShowCaption = False
        Me.PanelTop.Size = New System.Drawing.Size(1040, 137)
        Me.PanelTop.TabIndex = 0
        '
        'tlpPackage
        '
        Me.tlpPackage.AutoSize = True
        Me.tlpPackage.ColumnCount = 3
        Me.tlpPackage.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 15.0!))
        Me.tlpPackage.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 55.0!))
        Me.tlpPackage.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 30.0!))
        Me.tlpPackage.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.tlpPackage.Controls.Add(Me.tlpNotes, 0, 4)
        Me.tlpPackage.Controls.Add(Me.lblPackageOwner, 0, 0)
        Me.tlpPackage.Controls.Add(Me.lblPackageName, 1, 0)
        Me.tlpPackage.Controls.Add(Me.lblStudyTables, 2, 0)
        Me.tlpPackage.Controls.Add(Me.cboPackageOwners, 0, 1)
        Me.tlpPackage.Controls.Add(Me.txtPackageName, 1, 1)
        Me.tlpPackage.Controls.Add(Me.lblPackageFriendlyName, 1, 2)
        Me.tlpPackage.Controls.Add(Me.txtPackageFriendlyName, 1, 3)
        Me.tlpPackage.Controls.Add(Me.lvwStudyTables, 2, 1)
        Me.tlpPackage.Controls.Add(Me.chkInactive, 0, 3)
        Me.tlpPackage.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tlpPackage.Location = New System.Drawing.Point(1, 27)
        Me.tlpPackage.Name = "tlpPackage"
        Me.tlpPackage.RowCount = 5
        Me.tlpPackage.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22.0!))
        Me.tlpPackage.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22.0!))
        Me.tlpPackage.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22.0!))
        Me.tlpPackage.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22.0!))
        Me.tlpPackage.RowStyles.Add(New System.Windows.Forms.RowStyle())
        Me.tlpPackage.Size = New System.Drawing.Size(1038, 109)
        Me.tlpPackage.TabIndex = 62
        '
        'tlpNotes
        '
        Me.tlpNotes.ColumnCount = 3
        Me.tlpPackage.SetColumnSpan(Me.tlpNotes, 3)
        Me.tlpNotes.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle())
        Me.tlpNotes.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle())
        Me.tlpNotes.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.tlpNotes.Controls.Add(Me.txtNotes, 2, 0)
        Me.tlpNotes.Controls.Add(Me.lvwNotes, 1, 0)
        Me.tlpNotes.Controls.Add(Me.btnCancelNote, 0, 2)
        Me.tlpNotes.Controls.Add(Me.btnSaveNote, 0, 1)
        Me.tlpNotes.Controls.Add(Me.btnNotes, 0, 0)
        Me.tlpNotes.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tlpNotes.Location = New System.Drawing.Point(3, 91)
        Me.tlpNotes.Name = "tlpNotes"
        Me.tlpNotes.RowCount = 3
        Me.tlpNotes.RowStyles.Add(New System.Windows.Forms.RowStyle())
        Me.tlpNotes.RowStyles.Add(New System.Windows.Forms.RowStyle())
        Me.tlpNotes.RowStyles.Add(New System.Windows.Forms.RowStyle())
        Me.tlpNotes.Size = New System.Drawing.Size(1032, 100)
        Me.tlpNotes.TabIndex = 3
        '
        'txtNotes
        '
        Me.txtNotes.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtNotes.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNotes.Location = New System.Drawing.Point(252, 3)
        Me.txtNotes.Multiline = True
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.ReadOnly = True
        Me.tlpNotes.SetRowSpan(Me.txtNotes, 3)
        Me.txtNotes.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtNotes.Size = New System.Drawing.Size(777, 200)
        Me.txtNotes.TabIndex = 59
        Me.txtNotes.Visible = False
        '
        'lvwNotes
        '
        Me.lvwNotes.Alignment = System.Windows.Forms.ListViewAlignment.[Default]
        Me.lvwNotes.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lvwNotes.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colNotes})
        Me.lvwNotes.ContextMenu = Me.cmnNotes
        Me.lvwNotes.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwNotes.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.None
        Me.lvwNotes.HideSelection = False
        ListViewItem1.StateImageIndex = 0
        Me.lvwNotes.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem1, ListViewItem2, ListViewItem3, ListViewItem4})
        Me.lvwNotes.Location = New System.Drawing.Point(89, 3)
        Me.lvwNotes.MultiSelect = False
        Me.lvwNotes.Name = "lvwNotes"
        Me.tlpNotes.SetRowSpan(Me.lvwNotes, 3)
        Me.lvwNotes.Size = New System.Drawing.Size(157, 200)
        Me.lvwNotes.SmallImageList = Me.ImageList1
        Me.lvwNotes.TabIndex = 57
        Me.lvwNotes.UseCompatibleStateImageBehavior = False
        Me.lvwNotes.View = System.Windows.Forms.View.Details
        Me.lvwNotes.Visible = False
        '
        'colNotes
        '
        Me.colNotes.Text = "Notes"
        Me.colNotes.Width = 200
        '
        'cmnNotes
        '
        Me.cmnNotes.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.btnNewNote})
        '
        'btnNewNote
        '
        Me.btnNewNote.Index = 0
        Me.btnNewNote.Text = "New Note..."
        '
        'ImageList1
        '
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        Me.ImageList1.Images.SetKeyName(0, "")
        Me.ImageList1.Images.SetKeyName(1, "")
        Me.ImageList1.Images.SetKeyName(2, "")
        Me.ImageList1.Images.SetKeyName(3, "")
        '
        'btnCancelNote
        '
        Me.btnCancelNote.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancelNote.Location = New System.Drawing.Point(3, 40)
        Me.btnCancelNote.Name = "btnCancelNote"
        Me.btnCancelNote.Size = New System.Drawing.Size(80, 20)
        Me.btnCancelNote.TabIndex = 61
        Me.btnCancelNote.TabStop = True
        Me.btnCancelNote.Text = "Cancel Note"
        Me.btnCancelNote.Visible = False
        '
        'btnSaveNote
        '
        Me.btnSaveNote.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSaveNote.Location = New System.Drawing.Point(3, 20)
        Me.btnSaveNote.Name = "btnSaveNote"
        Me.btnSaveNote.Size = New System.Drawing.Size(80, 20)
        Me.btnSaveNote.TabIndex = 60
        Me.btnSaveNote.TabStop = True
        Me.btnSaveNote.Text = "Save Note"
        Me.btnSaveNote.Visible = False
        '
        'btnNotes
        '
        Me.btnNotes.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnNotes.Location = New System.Drawing.Point(3, 0)
        Me.btnNotes.Name = "btnNotes"
        Me.btnNotes.Size = New System.Drawing.Size(80, 20)
        Me.btnNotes.TabIndex = 58
        Me.btnNotes.TabStop = True
        Me.btnNotes.Text = "Show Notes..."
        '
        'lblPackageOwner
        '
        Me.lblPackageOwner.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblPackageOwner.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPackageOwner.Location = New System.Drawing.Point(3, 6)
        Me.lblPackageOwner.Name = "lblPackageOwner"
        Me.lblPackageOwner.Size = New System.Drawing.Size(98, 16)
        Me.lblPackageOwner.TabIndex = 48
        Me.lblPackageOwner.Text = "Package Owner:"
        '
        'lblPackageName
        '
        Me.lblPackageName.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblPackageName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPackageName.Location = New System.Drawing.Point(158, 6)
        Me.lblPackageName.Name = "lblPackageName"
        Me.lblPackageName.Size = New System.Drawing.Size(88, 16)
        Me.lblPackageName.TabIndex = 53
        Me.lblPackageName.Text = "Package Name:"
        '
        'lblStudyTables
        '
        Me.lblStudyTables.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblStudyTables.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblStudyTables.Location = New System.Drawing.Point(728, 6)
        Me.lblStudyTables.Name = "lblStudyTables"
        Me.lblStudyTables.Size = New System.Drawing.Size(80, 16)
        Me.lblStudyTables.TabIndex = 54
        Me.lblStudyTables.Text = "Study Tables:"
        '
        'cboPackageOwners
        '
        Me.cboPackageOwners.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPackageOwners.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cboPackageOwners.Location = New System.Drawing.Point(3, 25)
        Me.cboPackageOwners.Name = "cboPackageOwners"
        Me.cboPackageOwners.Size = New System.Drawing.Size(149, 21)
        Me.cboPackageOwners.TabIndex = 49
        '
        'txtPackageName
        '
        Me.txtPackageName.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtPackageName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtPackageName.Location = New System.Drawing.Point(158, 25)
        Me.txtPackageName.Name = "txtPackageName"
        Me.txtPackageName.Size = New System.Drawing.Size(564, 21)
        Me.txtPackageName.TabIndex = 52
        '
        'lblPackageFriendlyName
        '
        Me.lblPackageFriendlyName.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblPackageFriendlyName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPackageFriendlyName.Location = New System.Drawing.Point(158, 50)
        Me.lblPackageFriendlyName.Name = "lblPackageFriendlyName"
        Me.lblPackageFriendlyName.Size = New System.Drawing.Size(152, 16)
        Me.lblPackageFriendlyName.TabIndex = 53
        Me.lblPackageFriendlyName.Text = "Client-Facing Package Name:"
        '
        'txtPackageFriendlyName
        '
        Me.txtPackageFriendlyName.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtPackageFriendlyName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtPackageFriendlyName.Location = New System.Drawing.Point(158, 69)
        Me.txtPackageFriendlyName.MaxLength = 100
        Me.txtPackageFriendlyName.Name = "txtPackageFriendlyName"
        Me.txtPackageFriendlyName.Size = New System.Drawing.Size(564, 21)
        Me.txtPackageFriendlyName.TabIndex = 52
        '
        'lvwStudyTables
        '
        Me.lvwStudyTables.CheckBoxes = True
        Me.lvwStudyTables.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colCheckedTable, Me.colStudyTables})
        Me.lvwStudyTables.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwStudyTables.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwStudyTables.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.None
        ListViewItem5.Checked = True
        ListViewItem5.StateImageIndex = 1
        ListViewItem6.Checked = True
        ListViewItem6.StateImageIndex = 1
        ListViewItem7.StateImageIndex = 0
        Me.lvwStudyTables.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem5, ListViewItem6, ListViewItem7})
        Me.lvwStudyTables.Location = New System.Drawing.Point(728, 25)
        Me.lvwStudyTables.Name = "lvwStudyTables"
        Me.tlpPackage.SetRowSpan(Me.lvwStudyTables, 3)
        Me.lvwStudyTables.Size = New System.Drawing.Size(307, 60)
        Me.lvwStudyTables.SmallImageList = Me.imlSmall
        Me.lvwStudyTables.TabIndex = 55
        Me.lvwStudyTables.UseCompatibleStateImageBehavior = False
        Me.lvwStudyTables.View = System.Windows.Forms.View.Details
        '
        'colCheckedTable
        '
        Me.colCheckedTable.Text = ""
        Me.colCheckedTable.Width = 40
        '
        'colStudyTables
        '
        Me.colStudyTables.Text = ""
        Me.colStudyTables.Width = 200
        '
        'imlSmall
        '
        Me.imlSmall.ImageStream = CType(resources.GetObject("imlSmall.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlSmall.TransparentColor = System.Drawing.Color.Red
        Me.imlSmall.Images.SetKeyName(0, "")
        Me.imlSmall.Images.SetKeyName(1, "")
        Me.imlSmall.Images.SetKeyName(2, "")
        Me.imlSmall.Images.SetKeyName(3, "")
        Me.imlSmall.Images.SetKeyName(4, "")
        Me.imlSmall.Images.SetKeyName(5, "")
        Me.imlSmall.Images.SetKeyName(6, "")
        Me.imlSmall.Images.SetKeyName(7, "")
        '
        'chkInactive
        '
        Me.chkInactive.AutoSize = True
        Me.chkInactive.Location = New System.Drawing.Point(3, 69)
        Me.chkInactive.Name = "chkInactive"
        Me.chkInactive.Size = New System.Drawing.Size(64, 16)
        Me.chkInactive.TabIndex = 60
        Me.chkInactive.Text = "Inactive"
        Me.chkInactive.UseVisualStyleBackColor = True
        '
        'CaptionPackage
        '
        Me.CaptionPackage.Caption = "Package Information"
        Me.CaptionPackage.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionPackage.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionPackage.Location = New System.Drawing.Point(1, 1)
        Me.CaptionPackage.Name = "CaptionPackage"
        Me.CaptionPackage.Size = New System.Drawing.Size(1038, 26)
        Me.CaptionPackage.TabIndex = 0
        Me.CaptionPackage.Text = "Package Information"
        '
        'PanelBottom
        '
        Me.PanelBottom.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PanelBottom.Controls.Add(Me.PanelRight)
        Me.PanelBottom.Controls.Add(Me.Splitter2)
        Me.PanelBottom.Controls.Add(Me.PanelLeft)
        Me.PanelBottom.Location = New System.Drawing.Point(0, 138)
        Me.PanelBottom.Name = "PanelBottom"
        Me.PanelBottom.Size = New System.Drawing.Size(1040, 526)
        Me.PanelBottom.TabIndex = 2
        '
        'PanelRight
        '
        Me.PanelRight.BackColor = System.Drawing.SystemColors.Control
        Me.PanelRight.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.PanelRight.Caption = ""
        Me.PanelRight.Controls.Add(Me.lvwTarget)
        Me.PanelRight.Controls.Add(Me.SectionHeader2)
        Me.PanelRight.Controls.Add(Me.CaptionDestination)
        Me.PanelRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PanelRight.Location = New System.Drawing.Point(394, 0)
        Me.PanelRight.Name = "PanelRight"
        Me.PanelRight.Padding = New System.Windows.Forms.Padding(1)
        Me.PanelRight.ShowCaption = False
        Me.PanelRight.Size = New System.Drawing.Size(646, 526)
        Me.PanelRight.TabIndex = 2
        '
        'lvwTarget
        '
        Me.lvwTarget.AllowDrop = True
        Me.lvwTarget.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwTarget.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colTTMapped, Me.colTTTable, Me.colTTField, Me.colTTType, Me.colTTFreqs, Me.colTTNulls, Me.colTTSourceField, Me.colTTPII, Me.colTTTransferUS})
        Me.lvwTarget.ContextMenu = Me.cmnDestination
        Me.lvwTarget.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwTarget.FullRowSelect = True
        Me.lvwTarget.GridLines = True
        Me.lvwTarget.HideSelection = False
        ListViewItem8.StateImageIndex = 0
        ListViewItem9.StateImageIndex = 0
        ListViewItem10.StateImageIndex = 0
        ListViewItem11.StateImageIndex = 0
        ListViewItem12.StateImageIndex = 0
        ListViewItem13.StateImageIndex = 0
        ListViewItem14.StateImageIndex = 0
        ListViewItem15.StateImageIndex = 0
        ListViewItem16.StateImageIndex = 0
        ListViewItem17.StateImageIndex = 0
        ListViewItem18.StateImageIndex = 0
        ListViewItem19.StateImageIndex = 0
        ListViewItem20.StateImageIndex = 0
        ListViewItem21.StateImageIndex = 0
        ListViewItem22.StateImageIndex = 0
        ListViewItem23.StateImageIndex = 0
        ListViewItem24.StateImageIndex = 0
        ListViewItem25.StateImageIndex = 0
        ListViewItem26.StateImageIndex = 0
        ListViewItem27.StateImageIndex = 0
        ListViewItem28.StateImageIndex = 0
        ListViewItem29.StateImageIndex = 0
        ListViewItem30.StateImageIndex = 0
        Me.lvwTarget.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem8, ListViewItem9, ListViewItem10, ListViewItem11, ListViewItem12, ListViewItem13, ListViewItem14, ListViewItem15, ListViewItem16, ListViewItem17, ListViewItem18, ListViewItem19, ListViewItem20, ListViewItem21, ListViewItem22, ListViewItem23, ListViewItem24, ListViewItem25, ListViewItem26, ListViewItem27, ListViewItem28, ListViewItem29, ListViewItem30})
        Me.lvwTarget.Location = New System.Drawing.Point(8, 64)
        Me.lvwTarget.MultiSelect = False
        Me.lvwTarget.Name = "lvwTarget"
        Me.lvwTarget.Size = New System.Drawing.Size(630, 454)
        Me.lvwTarget.SmallImageList = Me.ImageList1
        Me.lvwTarget.StateImageList = Me.ImageList1
        Me.lvwTarget.TabIndex = 14
        Me.lvwTarget.UseCompatibleStateImageBehavior = False
        Me.lvwTarget.View = System.Windows.Forms.View.Details
        '
        'colTTMapped
        '
        Me.colTTMapped.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.CheckBox
        Me.colTTMapped.Text = ""
        Me.colTTMapped.Width = 40
        '
        'colTTTable
        '
        Me.colTTTable.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colTTTable.Text = "Table"
        Me.colTTTable.Width = 77
        '
        'colTTField
        '
        Me.colTTField.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colTTField.Text = "Field Name"
        Me.colTTField.Width = 95
        '
        'colTTType
        '
        Me.colTTType.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colTTType.Text = "Field Type"
        Me.colTTType.Width = 70
        '
        'colTTFreqs
        '
        Me.colTTFreqs.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.[Integer]
        Me.colTTFreqs.Text = "Freqs"
        Me.colTTFreqs.Width = 49
        '
        'colTTNulls
        '
        Me.colTTNulls.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colTTNulls.Text = "Nulls"
        Me.colTTNulls.Width = 44
        '
        'colTTSourceField
        '
        Me.colTTSourceField.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colTTSourceField.Text = "Source Field"
        Me.colTTSourceField.Width = 150
        '
        'colTTPII
        '
        Me.colTTPII.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.CheckBox
        Me.colTTPII.Text = "PII"
        Me.colTTPII.Width = 36
        '
        'colTTTransferUS
        '
        Me.colTTTransferUS.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colTTTransferUS.Text = "Allow US"
        Me.colTTTransferUS.Width = 64
        '
        'cmnDestination
        '
        Me.cmnDestination.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem1, Me.MenuItem5, Me.mnuMapField, Me.MenuItem2, Me.MenuItem7, Me.MenuItem3, Me.MenuItem4})
        '
        'MenuItem1
        '
        Me.MenuItem1.Index = 0
        Me.MenuItem1.Text = "Edit Formula"
        '
        'MenuItem5
        '
        Me.MenuItem5.Index = 1
        Me.MenuItem5.Text = "Set Formula to  Null "
        '
        'mnuMapField
        '
        Me.mnuMapField.Index = 2
        Me.mnuMapField.Text = "Map Field"
        '
        'MenuItem2
        '
        Me.MenuItem2.Index = 3
        Me.MenuItem2.Text = "Unmap Fields"
        '
        'MenuItem7
        '
        Me.MenuItem7.Index = 4
        Me.MenuItem7.Text = "-"
        '
        'MenuItem3
        '
        Me.MenuItem3.Index = 5
        Me.MenuItem3.Text = "Frequency Limit"
        '
        'MenuItem4
        '
        Me.MenuItem4.Index = 6
        Me.MenuItem4.Text = "Check for Nulls"
        '
        'SectionHeader2
        '
        Me.SectionHeader2.Controls.Add(Me.lblFMTables)
        Me.SectionHeader2.Controls.Add(Me.cboTableFilter)
        Me.SectionHeader2.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader2.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader2.Name = "SectionHeader2"
        Me.SectionHeader2.Size = New System.Drawing.Size(644, 29)
        Me.SectionHeader2.TabIndex = 2
        '
        'lblFMTables
        '
        Me.lblFMTables.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblFMTables.BackColor = System.Drawing.Color.Transparent
        Me.lblFMTables.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFMTables.Location = New System.Drawing.Point(398, 8)
        Me.lblFMTables.Name = "lblFMTables"
        Me.lblFMTables.Size = New System.Drawing.Size(44, 16)
        Me.lblFMTables.TabIndex = 12
        Me.lblFMTables.Text = "Tables:"
        '
        'cboTableFilter
        '
        Me.cboTableFilter.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cboTableFilter.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cboTableFilter.ItemHeight = 13
        Me.cboTableFilter.Items.AddRange(New Object() {"All Tables", "Population_load", "Encounter_load", "Provider_load"})
        Me.cboTableFilter.Location = New System.Drawing.Point(446, 4)
        Me.cboTableFilter.Name = "cboTableFilter"
        Me.cboTableFilter.Size = New System.Drawing.Size(188, 21)
        Me.cboTableFilter.TabIndex = 13
        Me.cboTableFilter.Text = "All Tables"
        '
        'CaptionDestination
        '
        Me.CaptionDestination.Caption = "Destination Data"
        Me.CaptionDestination.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionDestination.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionDestination.Location = New System.Drawing.Point(1, 1)
        Me.CaptionDestination.Name = "CaptionDestination"
        Me.CaptionDestination.Size = New System.Drawing.Size(644, 26)
        Me.CaptionDestination.TabIndex = 0
        Me.CaptionDestination.Text = "Destination Data"
        '
        'Splitter2
        '
        Me.Splitter2.Location = New System.Drawing.Point(384, 0)
        Me.Splitter2.Name = "Splitter2"
        Me.Splitter2.Size = New System.Drawing.Size(10, 526)
        Me.Splitter2.TabIndex = 1
        Me.Splitter2.TabStop = False
        '
        'PanelLeft
        '
        Me.PanelLeft.BackColor = System.Drawing.SystemColors.Control
        Me.PanelLeft.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.PanelLeft.Caption = ""
        Me.PanelLeft.Controls.Add(Me.lvwSource)
        Me.PanelLeft.Controls.Add(Me.SectionHeader1)
        Me.PanelLeft.Controls.Add(Me.CaptionSource)
        Me.PanelLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.PanelLeft.Location = New System.Drawing.Point(0, 0)
        Me.PanelLeft.Name = "PanelLeft"
        Me.PanelLeft.Padding = New System.Windows.Forms.Padding(1)
        Me.PanelLeft.ShowCaption = False
        Me.PanelLeft.Size = New System.Drawing.Size(384, 526)
        Me.PanelLeft.TabIndex = 0
        '
        'lvwSource
        '
        Me.lvwSource.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwSource.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colSTMapped, Me.colMapCount, Me.colSTColumn, Me.colSTField, Me.colSTType})
        Me.lvwSource.ContextMenu = Me.cmnSource
        Me.lvwSource.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwSource.FullRowSelect = True
        Me.lvwSource.GridLines = True
        Me.lvwSource.HideSelection = False
        ListViewItem31.StateImageIndex = 0
        ListViewItem32.StateImageIndex = 0
        ListViewItem33.StateImageIndex = 0
        ListViewItem34.StateImageIndex = 0
        ListViewItem35.StateImageIndex = 0
        ListViewItem36.StateImageIndex = 0
        ListViewItem37.StateImageIndex = 0
        ListViewItem40.StateImageIndex = 0
        ListViewItem41.StateImageIndex = 0
        ListViewItem42.StateImageIndex = 0
        ListViewItem43.StateImageIndex = 0
        Me.lvwSource.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem31, ListViewItem32, ListViewItem33, ListViewItem34, ListViewItem35, ListViewItem36, ListViewItem37, ListViewItem38, ListViewItem39, ListViewItem40, ListViewItem41, ListViewItem42, ListViewItem43})
        Me.lvwSource.Location = New System.Drawing.Point(8, 64)
        Me.lvwSource.Name = "lvwSource"
        Me.lvwSource.Size = New System.Drawing.Size(368, 454)
        Me.lvwSource.SmallImageList = Me.ImageList1
        Me.lvwSource.StateImageList = Me.ImageList1
        Me.lvwSource.TabIndex = 13
        Me.lvwSource.UseCompatibleStateImageBehavior = False
        Me.lvwSource.View = System.Windows.Forms.View.Details
        '
        'colSTMapped
        '
        Me.colSTMapped.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.CheckBox
        Me.colSTMapped.Text = ""
        Me.colSTMapped.Width = 35
        '
        'colMapCount
        '
        Me.colMapCount.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colMapCount.Text = "Map Count"
        Me.colMapCount.Width = 71
        '
        'colSTColumn
        '
        Me.colSTColumn.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.[Integer]
        Me.colSTColumn.Text = "Col"
        Me.colSTColumn.Width = 30
        '
        'colSTField
        '
        Me.colSTField.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colSTField.Text = "Field Name"
        Me.colSTField.Width = 95
        '
        'colSTType
        '
        Me.colSTType.DataType = Nrc.Qualisys.QLoader.SortableColumn.ColumnDataType.Text
        Me.colSTType.Text = "Field Type"
        Me.colSTType.Width = 70
        '
        'cmnSource
        '
        Me.cmnSource.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem8})
        '
        'MenuItem8
        '
        Me.MenuItem8.Index = 0
        Me.MenuItem8.Text = "View Template File"
        '
        'SectionHeader1
        '
        Me.SectionHeader1.Controls.Add(Me.btnConfigure)
        Me.SectionHeader1.Controls.Add(Me.btnModifySource)
        Me.SectionHeader1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader1.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader1.Name = "SectionHeader1"
        Me.SectionHeader1.Size = New System.Drawing.Size(382, 29)
        Me.SectionHeader1.TabIndex = 1
        '
        'btnConfigure
        '
        Me.btnConfigure.BackColor = System.Drawing.Color.Transparent
        Me.btnConfigure.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnConfigure.Location = New System.Drawing.Point(8, 8)
        Me.btnConfigure.Name = "btnConfigure"
        Me.btnConfigure.Size = New System.Drawing.Size(136, 23)
        Me.btnConfigure.TabIndex = 0
        Me.btnConfigure.TabStop = True
        Me.btnConfigure.Text = "Configure Source..."
        '
        'btnModifySource
        '
        Me.btnModifySource.BackColor = System.Drawing.Color.Transparent
        Me.btnModifySource.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnModifySource.Location = New System.Drawing.Point(240, 8)
        Me.btnModifySource.Name = "btnModifySource"
        Me.btnModifySource.Size = New System.Drawing.Size(136, 23)
        Me.btnModifySource.TabIndex = 0
        Me.btnModifySource.TabStop = True
        Me.btnModifySource.Text = "Modify Source..."
        Me.btnModifySource.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'CaptionSource
        '
        Me.CaptionSource.Caption = "Source Data"
        Me.CaptionSource.Dock = System.Windows.Forms.DockStyle.Top
        Me.CaptionSource.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.CaptionSource.Location = New System.Drawing.Point(1, 1)
        Me.CaptionSource.Name = "CaptionSource"
        Me.CaptionSource.Size = New System.Drawing.Size(382, 26)
        Me.CaptionSource.TabIndex = 0
        Me.CaptionSource.Text = "Source Data"
        '
        'OpenFile
        '
        Me.OpenFile.FilterIndex = 4
        '
        'cmnSetup
        '
        Me.cmnSetup.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuOpenPackage, Me.mnuNewPackage, Me.mnuSaveAs, Me.mnuDeletePackage, Me.mnuUnlockPackage, Me.MenuItem6, Me.mnuMFV, Me.mnuClientFunction, Me.mnuRestorePackage})
        '
        'mnuOpenPackage
        '
        Me.mnuOpenPackage.Index = 0
        Me.mnuOpenPackage.Text = "Open Package"
        '
        'mnuNewPackage
        '
        Me.mnuNewPackage.Index = 1
        Me.mnuNewPackage.Text = "New Package"
        '
        'mnuSaveAs
        '
        Me.mnuSaveAs.Index = 2
        Me.mnuSaveAs.Text = "Save Package As..."
        '
        'mnuDeletePackage
        '
        Me.mnuDeletePackage.Index = 3
        Me.mnuDeletePackage.Text = "Delete Package"
        '
        'mnuUnlockPackage
        '
        Me.mnuUnlockPackage.Index = 4
        Me.mnuUnlockPackage.Text = "Unlock Package"
        '
        'MenuItem6
        '
        Me.MenuItem6.Index = 5
        Me.MenuItem6.Text = "-"
        '
        'mnuMFV
        '
        Me.mnuMFV.Index = 6
        Me.mnuMFV.Text = "Match Field Validation"
        '
        'mnuClientFunction
        '
        Me.mnuClientFunction.Index = 7
        Me.mnuClientFunction.Text = "Function Library"
        '
        'mnuRestorePackage
        '
        Me.mnuRestorePackage.Index = 8
        Me.mnuRestorePackage.Text = "Restore Package"
        '
        'PackageSetupSection
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.PanelBottom)
        Me.Controls.Add(Me.PanelTop)
        Me.Name = "PackageSetupSection"
        Me.Size = New System.Drawing.Size(1040, 664)
        Me.PanelTop.ResumeLayout(False)
        Me.PanelTop.PerformLayout()
        Me.tlpPackage.ResumeLayout(False)
        Me.tlpPackage.PerformLayout()
        Me.tlpNotes.ResumeLayout(False)
        Me.tlpNotes.PerformLayout()
        Me.PanelBottom.ResumeLayout(False)
        Me.PanelRight.ResumeLayout(False)
        Me.SectionHeader2.ResumeLayout(False)
        Me.PanelLeft.ResumeLayout(False)
        Me.SectionHeader1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "

    Private WithEvents mPackageNavigator As PackageNavigator
    Private WithEvents mPackage As DTSPackage
    Private mNotesShown As Boolean
    Private mIsNoteEditing As Boolean
    Private mToolStripItems As New List(Of ToolStripItem)
    Private mErrorMessage As New System.Text.StringBuilder


#End Region

#Region " Private ReadOnly Properties "

    'Just a shortcut to the currently selected destination
    Private ReadOnly Property SelectedTarget() As ListViewItem
        Get
            Return lvwTarget.SelectedItems(0)
        End Get
    End Property

#End Region

#Region " Public Methods "

    'Initializes the control with a certain package
    Public Sub AttachPackage(ByVal package As DTSPackage)

        'Store the package
        If Not mPackage Is Nothing Then
            DetachPackage()
        End If
        mPackage = package

        'If package is nothing then show empty control
        If package Is Nothing Then
            InitializeForm()
        Else
            PopulateStudyTables()    'Populate Study Table list
            PopulatePackageInfo()    'Populate Package info pane

            'Populate table list and source/dest fields
            PopulateTableList()
            PopulateSourceMappings()
            PopulateDestMappings()
            LoadNotes()

            'Add the TableUsed handler to each destination table
            Dim dest As DTSDestination
            For Each dest In mPackage.Destinations
                AddHandler dest.mUsedInPackageChanged, AddressOf UsedTablesChanged
            Next

            'Set the caption with package name info etc.
            SetPackageCaption()

            'Enable the controls
            EnableControls(True)

            'If this is a text or excel package then the user can modify
            'the configuration
            EnableModifyButton()
        End If

    End Sub

    Private Sub DetachPackage()

        For Each dest As DTSDestination In mPackage.Destinations
            RemoveHandler dest.mUsedInPackageChanged, AddressOf UsedTablesChanged
        Next

    End Sub

    'Automatically map columns that have the same name
    Public Sub AutoMap()

        Dim destCol As DestinationColumn
        Dim sourceCol As SourceColumn

        'Go through each visible destination item
        For Each dest As ListViewItem In lvwTarget.Items
            destCol = dest.Tag      'Get the destination column
            'If the column is there and has not been mapped
            If Not destCol Is Nothing AndAlso destCol.Formula = "" Then
                'Go through each source item
                For Each source As ListViewItem In lvwSource.Items
                    sourceCol = source.Tag      'Get the source column
                    If Not sourceCol Is Nothing Then
                        'If the destination column name matches the source column name
                        If sourceCol.ColumnName.ToLower = destCol.ColumnName.ToLower Then
                            'Add this source to the destination
                            destCol.SourceColumns.Add(sourceCol)
                            'Add the 1 to 1 map formula
                            destCol.Formula = String.Format("{0} = {1}", destCol, sourceCol)
                            'Increment source column map count
                            sourceCol.MapCount += 1
                            Exit For
                        End If
                    End If
                Next
            End If
        Next

        PopulateDestMappings()
        mPackage.Modified = True

    End Sub

    Public Sub SavePackageInfo()

        mPackage.PackageName = txtPackageName.Text
        mPackage.PackageFriendlyName = txtPackageFriendlyName.Text
        mPackage.OwnerMemberID = cboPackageOwners.SelectedValue
        mPackage.BitActive = Not chkInactive.Checked

    End Sub

    Public Sub ClearMappings()

        If Not mPackage Is Nothing Then
            mPackage.ClearAllMappings()

            PopulateDestMappings()
        End If

    End Sub

#End Region

#Region " Private Methods "

#Region " Form Population/Initialization Methods "

    Private Sub PackageSetup_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not DesignMode Then
            InitializeForm()
        End If

    End Sub

    Private Sub EnableControls(ByVal enable As Boolean)

        'Enable all controls on the form
        For Each ctrl As Control In Controls
            ctrl.Enabled = enable
        Next

        For Each item As ToolStripItem In mToolStripItems
            item.Enabled = enable
        Next

    End Sub

    Private Sub EnableModifyButton()

        'Enable "modify source" only when the source type is Text or Excel, and column definition is available
        If (mPackage.Source.DataSetType = DataSetTypes.Text OrElse mPackage.Source.DataSetType = DataSetTypes.Excel) AndAlso mPackage.Source.Columns.Count > 0 Then
            btnModifySource.Enabled = True
        Else
            btnModifySource.Enabled = False
        End If

    End Sub

    Private Sub SetPackageCaption()

        'Set the caption on the control
        With mPackage
            CaptionPackage.Caption = String.Format("Client: {0}({1}) Study: {2}({3}) Package: {4}({5})", .Study.ClientName.Trim, .Study.ClientID, .Study.StudyName.Trim, .Study.StudyID, .PackageName.Trim, .PackageID)
        End With

    End Sub

    Private Sub InitializeForm()

        'When form is first loaded with no package yet
        PopulateOwnerCombo()      ' Populate Team Combo Box

        lvwSource.Items.Clear()
        lvwTarget.Items.Clear()
        lvwStudyTables.Items.Clear()
        txtPackageName.Text = String.Empty
        txtPackageFriendlyName.Text = String.Empty
        lvwNotes.Items.Clear()
        txtNotes.Text = String.Empty
        txtNotes.ReadOnly = True

        cboPackageOwners.SelectedIndex = -1

        'Disable all controls since no package has been attached yet
        EnableControls(False)

    End Sub

    Private Sub InitializeToolStripItems()

        Dim item As ToolStripItem = New ToolStripButton("Save Package", My.Resources.Save16, New EventHandler(AddressOf SavePackageButton_Clicked))
        mToolStripItems.Add(item)

        item = New ToolStripButton("Auto-Map", My.Resources.AutoMap32, New EventHandler(AddressOf AutoMapButton_Clicked))
        mToolStripItems.Add(item)

        item = New ToolStripButton("Clear Mappings", My.Resources.ClearMappings32, New EventHandler(AddressOf ClearMappingsButton_Clicked))
        mToolStripItems.Add(item)

    End Sub

    Private Sub PopulatePackageInfo()

        If mPackage.OwnerMemberID.HasValue Then
            cboPackageOwners.SelectedValue = mPackage.OwnerMemberID
        End If

        txtPackageName.Text = mPackage.PackageName
        txtPackageFriendlyName.Text = mPackage.PackageFriendlyName
        chkInactive.Checked = Not mPackage.BitActive

    End Sub

    Private Sub PopulateOwnerCombo()

        'Clear the combo
        cboPackageOwners.DataSource = Nothing
        cboPackageOwners.Items.Clear()
        Dim projectManagers As ProjectManagerCollection = ProjectManager.GetAll
        projectManagers.Sort(New PropertyComparer(Of ProjectManager)("FullName", SortDirection.Ascending))

        With cboPackageOwners
            .DataSource = projectManagers
            .DisplayMember = "FullName"
            .ValueMember = "MemberID"
        End With
        cboPackageOwners.SelectedIndex = -1

    End Sub

    Private Sub PopulateStudyTables()

        Dim item As ListViewItem

        'Clear the list
        lvwStudyTables.Items.Clear()

        'For each destination table in the package
        For Each dest As DTSDestination In mPackage.Destinations
            item = New ListViewItem
            item.SubItems.Add(dest.TableName)
            item.Checked = dest.UsedInPackage
            item.Tag = dest

            'If it has Match Field Validation defined then show no icon
            If dest.HasDupCheckDefined Then
                item.ImageIndex = -1
            Else        'Show warning icon
                item.ImageIndex = 5
            End If

            'Add the item
            lvwStudyTables.Items.Add(item)
        Next
    End Sub

    Private Sub PopulateTableList()

        cboTableFilter.Items.Clear()
        cboTableFilter.Items.Add("All Tables")
        cboTableFilter.SelectedIndex = 0

        If Not mPackage Is Nothing Then
            For Each dest As DTSDestination In mPackage.Destinations
                If dest.UsedInPackage Then
                    cboTableFilter.Items.Add(dest.TableName)
                End If
            Next
        End If

    End Sub

    'Populates the listview of the source columns for the mapping tab
    Private Sub PopulateSourceMappings()

        Dim item As ListViewItem

        lvwSource.Items.Clear()      'Clear the current items
        If mPackage Is Nothing Then Exit Sub

        'Add each column in the source definition to the listview
        For Each col As SourceColumn In mPackage.Source.Columns
            item = New ListViewItem
            item.Tag = col

            'Format the listview item
            LoadSourceMappingItem(item)

            'Add it
            lvwSource.Items.Add(item)
        Next

        lvwSource.SortList()

    End Sub

    'Populates the listview of the destinations for the mapping tab columns are only displayed if
    '1)  The destination table is used in package
    '2)  The destination is selected in the Table Display Drop Down
    '3)  The column is not a system column (pop_id, df_id, addrerr, etc.)
    Private Sub PopulateDestMappings()

        lvwTarget.Items.Clear()      'Clear the current items
        If mPackage Is Nothing Then Exit Sub

        'Get the table display selection ("All Tables", etc)
        Dim showTable As String = cboTableFilter.SelectedItem
        Dim item As ListViewItem

        'Loop through every destination table possible
        For Each dest As DTSDestination In mPackage.Destinations
            'If this table is used in package
            If dest.UsedInPackage Then
                'If we are showing "All Tables" or this one then populate the list view
                If showTable = "All Tables" OrElse dest.TableName = showTable Then
                    'Now for each column in this destination table
                    For Each col As DestinationColumn In dest.Columns
                        'Finally...if this is not a system field then add it!
                        If Not col.IsSystemField Then
                            item = New ListViewItem
                            item.Tag = col
                            LoadDestMappingItem(item)    'Format the item
                            lvwTarget.Items.Add(item)    'Add it
                        End If
                    Next
                End If
            End If
        Next

        lvwTarget.SortList()

    End Sub

    'Format the ListView Item Assuming that the SourceColumn as been placed in the .Tag attribute
    Private Sub LoadSourceMappingItem(ByVal item As ListViewItem)

        Dim sourceCol As SourceColumn = item.Tag    'Get the SourceColumn
        item.SubItems.Clear()                       'Clear the subitems

        'If the Column has been mapped then show the mapped icon
        If sourceCol.MapCount > 0 Then
            item.StateImageIndex = 0
        Else
            item.StateImageIndex = -1
        End If

        'Load the columns
        item.SubItems.Add(sourceCol.MapCount)
        item.SubItems.Add(sourceCol.Ordinal)
        item.SubItems.Add(sourceCol.ColumnName)
        item.SubItems.Add(sourceCol.DataTypeStringFull)

    End Sub

    'Populate the ListView Item Assuming that the DestinationColumn as been placed in the .Tag attribute
    Private Sub LoadDestMappingItem(ByVal item As ListViewItem)

        Dim destCol As DestinationColumn = item.Tag     'Get the DestinationColumn
        item.SubItems.Clear()       'Clear the current subItems

        'If this is a matchfield then show the icon
        If destCol.IsMatchField Then
            item.ImageIndex = 1
        End If

        'If this is a study dup check field then show icon
        If destCol.IsDupCheckField Then
            item.ImageIndex = 2
        End If

        'If this field has been mapped then show the mapped icon
        If Not destCol.Formula = "" Then
            item.StateImageIndex = 0
        Else
            item.StateImageIndex = -1
        End If

        'Load the column info
        item.SubItems.Add(DirectCast(destCol.Parent, DTSDestination).TableName)
        item.SubItems.Add(destCol.ColumnName)
        item.SubItems.Add(destCol.DataTypeStringFull)
        item.SubItems.Add(destCol.FrequencyLimit)
        If destCol.CheckNulls Then
            item.SubItems.Add("x")
        Else
            item.SubItems.Add("")
        End If
        item.SubItems.Add(destCol.Formula.Replace(String.Format("{0} =", destCol), "").Trim)

        If destCol.IsPIIField Then
            item.SubItems.Add("x")
        Else
            item.SubItems.Add("")
        End If

        If destCol.IsTransferedToUS Then
            item.SubItems.Add("x")
        Else
            item.SubItems.Add("")
        End If

    End Sub

#End Region

#Region " Control Events "

    Private Sub lvwStudyTables_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwStudyTables.Click

        'Get the clicked item
        Dim pt As Point = lvwStudyTables.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim item As ListViewItem = lvwStudyTables.GetItemAt(pt.X, pt.Y)
        Dim dest As DTSDestination

        If Not item Is Nothing Then
            'Get the DTSDestination object from the item
            dest = item.Tag
            If Not dest Is Nothing Then
                'Set the flag
                dest.UsedInPackage = Not item.Checked
            End If

            'Flag package as modified
            mPackage.Modified = True
        End If

    End Sub

    Private Sub cboTeamList_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboPackageOwners.SelectedIndexChanged

        If Not mPackage Is Nothing AndAlso cboPackageOwners.SelectedIndex > -1 Then
            'If team is different then mark package as changed and update
            If Not mPackage.OwnerMemberID.HasValue OrElse Not mPackage.OwnerMemberID.Value = CInt(cboPackageOwners.SelectedValue) Then
                mPackage.OwnerMemberID = cboPackageOwners.SelectedValue
                mPackage.OwnerName = cboPackageOwners.Text

                mPackage.Modified = True
            End If
        End If

    End Sub

    Private Sub lvwTarget_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwTarget.SelectedIndexChanged

        'If a destination that is already mapped is clicked
        'All of the source columns in that mapping should automatically be selected
        'The following is relatively inefficient...might be something to look at

        'Verify that an item is selected
        If lvwTarget.SelectedItems.Count < 1 Then Exit Sub

        'Get the DestinationColumn
        Dim destCol As DestinationColumn = SelectedTarget.Tag

        'Verify that the column has been mapped
        If destCol.Formula = "" Then Exit Sub

        'For each item in the source list
        For Each item As ListViewItem In lvwSource.Items
            'Check to see if that source column is mapped to the selected destination column
            For Each sourceCol As SourceColumn In destCol.SourceColumns
                'If it is found then select it
                If sourceCol Is item.Tag Then
                    item.Selected = True
                    item.EnsureVisible()
                    Exit For
                Else    'If it is not found then de-select it
                    item.Selected = False
                End If
            Next
        Next

    End Sub

    Private Sub lvwTarget_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwTarget.DoubleClick

        EditFormulaCommand()

    End Sub

    Private Sub lvwSource_ItemDrag(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ItemDragEventArgs) Handles lvwSource.ItemDrag

        'Get the item being drug
        Dim pt As Point = lvwSource.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim item As ListViewItem = lvwSource.GetItemAt(pt.X, pt.Y)

        If Not item Is Nothing Then     'If we really got one...
            'Do the drag drop
            lvwSource.DoDragDrop("", DragDropEffects.All)
        End If

    End Sub

    Private Sub lvwTarget_DragDrop(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles lvwTarget.DragDrop

        'We should already know that the selected destination is valid
        'And that one or more sources are selected so just call mapcolumns
        Dim destCol As DestinationColumn = SelectedTarget.Tag
        MapColumns(destCol)

    End Sub

    Private Sub lvwTarget_DragOver(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles lvwTarget.DragOver

        'Get the item under the cursor
        Dim pt As Point = lvwTarget.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim item As ListViewItem = lvwTarget.GetItemAt(pt.X, pt.Y)
        Dim destCol As DestinationColumn

        'Set the effect to none
        e.Effect = DragDropEffects.None
        If Not item Is Nothing Then     'If there is an item under cursor
            destCol = item.Tag          'Get the Destination Column
            'If the column is unmapped
            If Not destCol Is Nothing AndAlso destCol.Formula = "" Then
                e.Effect = DragDropEffects.Copy     'Show copy effect
                'If the item is not selected then select it
                If Not item.Selected Then
                    item.Selected = True
                End If
            End If
        End If

    End Sub

    Private Sub cboFMTables_SelectionChangeCommitted(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTableFilter.SelectionChangeCommitted

        PopulateDestMappings()

    End Sub

    Private Sub ViewSource_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem8.Click

        Dim templatePath As String = String.Format("{0}\{1}", mPackage.DataStorePath, mPackage.Source.TemplateFileName)
        Dim file As New IO.FileInfo(templatePath)

        If file.Exists Then
            Dim frmSource As New frmSourceViewer(mPackage.Source, file.FullName)
            frmSource.Show()
        End If

    End Sub


    Private Sub btnConfigure_Clicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnConfigure.LinkClicked

        Dim fileType As DataSetTypes

        Try
            Cursor = Cursors.WaitCursor
            OpenFile.Filter = "dBASE (*.dbf)|*.dbf|Microsoft Access (*.mdb)|*.mdb|Microsoft Excel (*.xls;*.xlsx;*.xlsm)|*.xls;*.xlsx;*.xlsm|Text files (*.txt;*.csv;*.tab)|*.txt;*.csv;*.tab|XML Documents (*.xml)|*.xml|All files (*.*)|*.*"
            If OpenFile.FilterIndex <= 0 Then
                OpenFile.FilterIndex = 4
            End If

            OpenFile.Title = "Select the source template file."

            If OpenFile.ShowDialog = DialogResult.OK Then
                Dim file As IO.FileInfo = New IO.FileInfo(OpenFile.FileName)
                Select Case file.Extension.ToLower
                    Case ".txt", ".csv", ".tab", ""
                        fileType = DataSetTypes.Text

                    Case ".xls", ".xlsx", ".xlsm"
                        fileType = DataSetTypes.Excel

                    Case ".dbf"
                        fileType = DataSetTypes.DBF

                    Case ".mdb"
                        fileType = DataSetTypes.AccessDB

                    Case ".xml"
                        fileType = DataSetTypes.XML

                    Case Else
                        Dim items As New ArrayList
                        items.Add(New ListItem(DataSetTypes.DBF, "dBASE"))
                        items.Add(New ListItem(DataSetTypes.AccessDB, "Microsoft Access"))
                        items.Add(New ListItem(DataSetTypes.Excel, "Microsoft Excel"))
                        items.Add(New ListItem(DataSetTypes.Text, "Text File"))
                        items.Add(New ListItem(DataSetTypes.XML, "XML Document"))

                        Dim form As New frmListBox
                        With form
                            .Caption = "File Type"
                            .Title = "Select a file type"
                            .DisplayMember = "Text"
                            .ValueMember = "Value"
                            .DataSource = items
                            .SelectedValue = DataSetTypes.Text
                            If .ShowDialog(Me) <> DialogResult.OK Then Return
                            fileType = CType(.SelectedValue, DataSetTypes)
                        End With

                End Select

                LoadNewSource(fileType, OpenFile.FileName)

                If mPackage.LockStatus = PackageLockStates.LockedByMe Then
                    mPackage.UnlockPackage()
                End If
                mPackage.LoadFromDB(mPackage.PackageID)
                mPackage.LockPackage()

                'Now reattach the package so everything is current
                AttachPackage(mPackage)
            End If

        Catch ex As Exception
            ReportException(ex, "Source Configuration Error")

        Finally
            Cursor = Cursors.Default

        End Try

    End Sub

    Private Sub lvwTarget_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles lvwTarget.KeyDown

        Select Case e.KeyCode
            Case Keys.Delete
                UnmapFieldCommand()

            Case Keys.Back
                SetToNullCommand()

            Case Keys.Enter
                EditFormulaCommand()

        End Select

    End Sub

    Private Sub btnModifySource_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnModifySource.LinkClicked

        Try
            Cursor = Cursors.WaitCursor

            If ModifySource() <> 0 Then Return

            If mPackage.LockStatus = PackageLockStates.LockedByMe Then
                mPackage.UnlockPackage()
            End If

            mPackage.LoadFromDB(mPackage.PackageID)
            mPackage.LockPackage()
            PopulateSourceMappings()
            PopulateDestMappings()

        Catch ex As Exception
            ReportException(ex, "Source Configuration Error")

        Finally
            Cursor = Cursors.Default

        End Try

    End Sub

    Private Sub lvwStudyTables_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwStudyTables.MouseMove

        'Get the item under the mouse
        Dim item As ListViewItem = lvwStudyTables.GetItemAt(e.X, e.Y)
        Dim dest As DTSDestination

        If Not item Is Nothing Then
            'Get the DTSDestination object for this item
            dest = item.Tag
            If Not dest Is Nothing Then
                'If this destination doesn't have match field validation then show tooltip
                If dest.HasDupCheckDefined Then
                    ToolTip.SetToolTip(lvwStudyTables, "")
                Else
                    ToolTip.SetToolTip(lvwStudyTables, dest.TableName & " Match Field Validation Undefined!")
                End If
            End If
        End If

    End Sub

#End Region

#Region " Package Event Handlers "

    Private Sub SourceColumnChanged(ByVal column As SourceColumn) Handles mPackage.SourceColumnChanged

        For Each item As ListViewItem In lvwSource.Items
            Dim col As SourceColumn = item.Tag
            If col Is column Then
                LoadSourceMappingItem(item)
                Exit For
            End If
        Next

    End Sub

    Private Sub UsedTablesChanged(ByVal table As DTSDestination) Handles mPackage.UsedTablesChanged

        Dim current As String = cboTableFilter.SelectedItem.ToString

        PopulateTableList()

        If table.TableName.ToLower = current.ToLower Then
            cboTableFilter.SelectedItem = "All Tables"
        Else
            cboTableFilter.SelectedItem = current
        End If

        PopulateDestMappings()

    End Sub

#End Region

#Region " Destination Context Menu "

    Private Sub cmnDestination_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmnDestination.Popup

        'When the context menu pops up we need to store the item that was being clicked
        'Dim Pt As Point = lvwTarget.PointToClient(Cursor.Position)
        'mClickedItem = lvwTarget.GetItemAt(Pt.X, Pt.Y)

    End Sub

    Private Sub EditFormula_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem1.Click

        'Edit Formula
        EditFormulaCommand()

    End Sub

    Private Sub FreqLimit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem3.Click

        'Set Frequency Limit
        If Not SelectedTarget Is Nothing Then
            Dim destCol As DestinationColumn = SelectedTarget.Tag
            Dim input As New frmInputDialog(frmInputDialog.InputType.TextBox)
            input.Prompt = "Enter the frequency limit."
            input.Title = "Frequency Report Limit"
            input.Input = 0
            If input.ShowDialog = DialogResult.OK Then
                destCol.FrequencyLimit = input.Input
            End If

            LoadDestMappingItem(SelectedTarget)

            mPackage.Modified = True
        End If

    End Sub

    Private Sub CheckNulls_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem4.Click

        'Check NULLS
        If Not SelectedTarget Is Nothing Then
            Dim destCol As DestinationColumn = SelectedTarget.Tag

            destCol.CheckNulls = Not destCol.CheckNulls

            LoadDestMappingItem(SelectedTarget)

            mPackage.Modified = True
        End If

    End Sub

    Private Sub UnmapField_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem2.Click

        'Unmap Field
        UnmapFieldCommand()

    End Sub

    Private Sub SetToNull_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem5.Click

        'Set to NULL
        SetToNullCommand()

    End Sub

    Private Sub mnuMapField_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuMapField.Click

        Dim destCol As DestinationColumn = SelectedTarget.Tag
        MapColumns(destCol)

    End Sub

#End Region

#Region " Package Notes Methods "

    'Loads all of the notes for this package into the Notes listview
    Private Sub LoadNotes()

        'Clear the listview and the text box
        lvwNotes.Items.Clear()
        txtNotes.Text = ""
        txtNotes.ReadOnly = True

        'Add each note to the listview with the text in the tag
        For Each note As PackageNote In mPackage.Notes
            Dim item As ListViewItem = New ListViewItem(note.ToString, 3)
            item.Tag = note.NoteText

            lvwNotes.Items.Add(item)
        Next

    End Sub

    'When the Show/Hide notes button is clicked
    Private Sub btnNotes_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnNotes.LinkClicked

        Dim top As Integer = PanelBottom.Top
        Dim h1 As Integer = PanelBottom.Height
        Dim h2 As Integer = PanelTop.Height

        If mNotesShown Then 'They clicked HIDE notes
            mNotesShown = False
            btnNotes.Text = "Show Notes..."
            lvwNotes.Visible = False
            txtNotes.Visible = False

            'Hmmm...Lets try out a cool "slide" effect here...
            For cnt As Integer = 1 To 7
                PanelBottom.Top = top - (2 ^ cnt)
                PanelBottom.Height = h1 + (2 ^ cnt)
                PanelTop.Height = h2 - (2 ^ cnt)
                PanelTop.Refresh()
            Next

            PanelBottom.Top = top - 200
            PanelBottom.Height = h1 + 200
            PanelTop.Height = h2 - 200
        Else        'They clicked SHOW notes
            mNotesShown = True
            btnNotes.Text = "Hide Notes..."
            lvwNotes.Visible = True
            txtNotes.Visible = True

            'Hmmm...Lets try out a cool "slide" effect here...
            For cnt As Integer = 1 To 7
                PanelBottom.Top = top + (2 ^ cnt)
                PanelBottom.Height = h1 - (2 ^ cnt)
                PanelTop.Height = h2 + (2 ^ cnt)
                PanelTop.Refresh()
            Next

            PanelBottom.Top = top + 200
            PanelBottom.Height = h1 - 200
            PanelTop.Height = h2 + 200
        End If

    End Sub

    'Turns On/Off new note editing mode
    Private Sub EditNewNote(ByVal isEditing As Boolean)

        txtNotes.ReadOnly = Not isEditing
        lvwNotes.Visible = Not isEditing
        mIsNoteEditing = isEditing
        btnSaveNote.Visible = isEditing
        btnCancelNote.Visible = isEditing

        'Hides/Displays the Notes listview
        'Notes listview is hidden when editing a new note
        If isEditing Then
            txtNotes.Left -= 256
            txtNotes.Width += 256
        Else
            txtNotes.Left += 256
            txtNotes.Width -= 256
        End If

    End Sub

    Private Sub btnNewNote_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNewNote.Click

        'Enter the new note default text into the text box and select it
        txtNotes.Text = "Enter new note here..."
        txtNotes.SelectionStart = 0
        txtNotes.SelectionLength = txtNotes.Text.Length

        'Turn on New Note Editing Mode and give focus to the textbox
        EditNewNote(True)
        txtNotes.Focus()

    End Sub

    Private Sub btnSaveNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveNote.Click

        'Get a new note object from the package, store the text and then add it to the collection of notes
        Dim note As PackageNote = mPackage.CreateNewNote(CurrentUser.LoginName)
        note.NoteText = txtNotes.Text
        mPackage.Notes.Insert(0, note)

        'Now reload the notes
        LoadNotes()

        'Select the first note and turn off New Note Editing Mode
        lvwNotes.SelectedItems.Clear()
        lvwNotes.Items(0).Selected = True
        EditNewNote(False)

    End Sub

    Private Sub btnCancelNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelNote.Click

        'Clear the text box and turn off New Note Editing Mode
        txtNotes.Text = ""
        EditNewNote(False)

    End Sub

    Private Sub lvwNotes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwNotes.SelectedIndexChanged

        'When a Note is selected in the Note listview then display the NoteText in the textbox
        If lvwNotes.SelectedItems.Count > 0 Then
            txtNotes.Text = lvwNotes.SelectedItems(0).Tag
        End If

    End Sub


    Private Sub txtNotes_LostFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtNotes.LostFocus

        'If the textbox loses focus while in New Note Editing Mode then prompt the user to Save or Cancel the note first and restore focus
        If mIsNoteEditing AndAlso Not btnCancelNote.Focused AndAlso Not btnSaveNote.Focused Then
            MessageBox.Show("You must first Save or Cancel this new note.", "Unsaved Note Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtNotes.Focus()
        End If

    End Sub
#End Region

    Private Sub MapColumns(ByVal destCol As DestinationColumn)

        Dim sourceCol As SourceColumn = Nothing

        'Increment the MapCount for each source
        For Each item As ListViewItem In lvwSource.SelectedItems
            sourceCol = item.Tag
            sourceCol.MapCount += 1
            destCol.SourceColumns.Add(sourceCol)
        Next

        If lvwSource.SelectedItems.Count > 1 Then 'Many-to-one Mapping
            'Show Formula Editor
            LoadFormulaEditor(destCol)
        Else    'One-to-one Mapping
            'Set the formula
            destCol.Formula = String.Format("{0} = {1}", destCol, sourceCol)

            'Now Re-load the list view items to reflect the changes
            If lvwSource.SelectedItems.Count > 0 Then
                LoadSourceMappingItem(lvwSource.SelectedItems(0))
                LoadDestMappingItem(SelectedTarget)
            End If
        End If

        mPackage.Modified = True

    End Sub

    Private Sub LoadFormulaEditor(ByVal destColumn As DestinationColumn)

        'Show the formula editor for the specified DestinationColumn
        Dim frmFormula As New frmFormula(destColumn, mPackage.Study.ClientID)
        frmFormula.ShowDialog()

        'Reload the Destination list item to reflect the changes
        LoadDestMappingItem(SelectedTarget)

        'Reload each source list item to reflect the changes
        For Each item As ListViewItem In lvwSource.SelectedItems
            LoadSourceMappingItem(item)
        Next

        mPackage.Modified = True

    End Sub

    Private Sub LoadNewSource(ByVal fileType As DataSetTypes, ByVal filePath As String)

        StoreTemplateFile(filePath)

        Select Case fileType
            Case DataSetTypes.DBF
                mPackage.Source = New DTSDbaseData
                mPackage.Source.LoadColumnsFromFile(filePath)

            Case DataSetTypes.Text
                Dim textDataCtrl As New TextDataCtrl(filePath)
                Dim textWizard As New frmTextWizard
                With textWizard
                    .TextDataCtrl = textDataCtrl
                    If (.ShowDialog(Me) <> DialogResult.OK) Then Return
                End With
                mPackage.Source = textDataCtrl.DataSet

            Case DataSetTypes.Excel
                Dim excelDataCtrl As New ExcelDataCtrl(filePath)
                Dim excelWizard As New frmExcelWizard
                With excelWizard
                    .ExcelDataCtrl = excelDataCtrl
                    If (.ShowDialog(Me) <> DialogResult.OK) Then Return
                End With
                mPackage.Source = excelDataCtrl.DataSet

            Case DataSetTypes.AccessDB
                Dim accessDataCtrl As New AccessDataCtrl(filePath)
                If accessDataCtrl.TableList.Count > 1 Then
                    Dim form As New frmListBox
                    With form
                        .Caption = "Access Data"
                        .Title = "Select a table"
                        .DisplayMember = "Text"
                        .ValueMember = "Value"
                        .DataSource = accessDataCtrl.TableList
                        .SelectedIndex = 0
                        If (.ShowDialog(Me) <> DialogResult.OK) Then Return
                        accessDataCtrl.SelectedTable = .SelectedValue
                    End With
                End If
                mPackage.Source = New DTSAccessData(accessDataCtrl.SelectedTable)
                mPackage.Source.LoadColumnsFromFile(filePath)

            Case DataSetTypes.XML
                Dim xmlDataCtrl As New XmlDataCtrl(filePath)
                If (xmlDataCtrl.TableList.Count > 1) Then
                    Dim form As New frmListBox
                    With form
                        .Caption = "XML Data"
                        .Title = "Select a namespace"
                        .DisplayMember = "Text"
                        .ValueMember = "Value"
                        .DataSource = xmlDataCtrl.TableList
                        .SelectedIndex = 0
                        If (.ShowDialog(Me) <> DialogResult.OK) Then Return
                        xmlDataCtrl.SelectedTable = .SelectedValue
                    End With
                End If
                mPackage.Source = New DTSXmlData(xmlDataCtrl.SelectedTable)
                mPackage.Source.LoadColumnsFromFile(filePath)

        End Select

        'Set template file name
        mPackage.Source.SetTemplateFileName(filePath)

        'Code for debugging/testing
        If System.Diagnostics.Debugger.IsAttached Then
            Dim settings As String = mPackage.Source.Settings
            If settings <> "" Then
                MessageBox.Show(settings, "Source Dataset Settings", MessageBoxButtons.OK)
            End If
        End If
        'End of testing code

        SavePackageInfo()
        mPackage.SaveToDB()
        mPackage.SaveSourceColumns()

    End Sub

    Private Sub StoreTemplateFile(ByVal filePath As String)


        Dim oldFile As New IO.FileInfo(filePath)
        Dim templatePath As String = String.Format("{0}\Template{1}", mPackage.DataStorePath, oldFile.Extension)
        Dim newFile As New IO.FileInfo(templatePath)
        If Not newFile.Directory.Exists Then newFile.Directory.Create()
        oldFile.CopyTo(newFile.FullName, True)

    End Sub

    Private Sub SetToNullCommand()

        If Not SelectedTarget Is Nothing Then
            Dim destCol As DestinationColumn = SelectedTarget.Tag

            If destCol.Formula = "" Then
                destCol.Formula = destCol.ToString & " = dbNull"
                LoadDestMappingItem(SelectedTarget)

                mPackage.Modified = True
            Else
                MessageBox.Show("The destination field you selected has already been mapped.  Unmap the field first.", "Mapping Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End If
        End If

    End Sub

    Private Sub UnmapFieldCommand()

        If Not SelectedTarget Is Nothing Then
            Dim destCol As DestinationColumn = SelectedTarget.Tag
            If Not destCol.Formula = "" Then
                For Each sourceCol As SourceColumn In destCol.SourceColumns
                    sourceCol.MapCount -= 1
                Next
                destCol.SourceColumns.Clear()
                destCol.Formula = ""

                LoadDestMappingItem(SelectedTarget)
                For Each item As ListViewItem In lvwSource.SelectedItems
                    LoadSourceMappingItem(item)
                Next

                mPackage.Modified = True
            Else
                MessageBox.Show("Destination field is not mapped.", "Mapping Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        End If

    End Sub

    Private Sub EditFormulaCommand()

        If Not SelectedTarget Is Nothing Then
            Dim destCol As DestinationColumn = SelectedTarget.Tag
            LoadFormulaEditor(destCol)
        End If

    End Sub

    Private Function ModifySource() As Integer

        Dim filePath As String = String.Format("{0}\{1}", mPackage.DataStorePath, mPackage.Source.TemplateFileName)

        Select Case mPackage.Source.DataSetType
            Case DataSetTypes.Text
                Dim textDataCtrl As New TextDataCtrl(mPackage.Source, filePath)
                Dim textWizard As New frmTextWizard
                With textWizard
                    .TextDataCtrl = textDataCtrl
                    If .ShowDialog(Me) <> DialogResult.OK Then Return 1
                End With

                mPackage.Source = textDataCtrl.DataSet

            Case DataSetTypes.Excel
                Dim excelDataCtrl As New ExcelDataCtrl(mPackage.Source, filePath)
                Dim excelWizard As New frmExcelWizard
                With excelWizard
                    .ExcelDataCtrl = excelDataCtrl
                    If (.ShowDialog(Me) <> DialogResult.OK) Then Return 1
                End With

                mPackage.Source = excelDataCtrl.DataSet

            Case Else
                Return 1

        End Select

        'Code for debugging/testing
        If System.Diagnostics.Debugger.IsAttached Then
            Dim settings As String = mPackage.Source.Settings
            If (settings <> "") Then
                MessageBox.Show(settings, "Source Dataset Settings", MessageBoxButtons.OK)
            End If
        End If
        'End of testing code

        SavePackageInfo()
        mPackage.SaveToDB()
        mPackage.SaveSourceColumns()

        Return 0

    End Function

#End Region


#Region " Package Setup Methods "

#Region " Context Menu Events "

    'When the package setup context menu appears, determine which options are visible
    Private Sub cmnSetup_Popup(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmnSetup.Popup

        'Hide all items
        For Each item As MenuItem In cmnSetup.MenuItems
            item.Visible = False
        Next

        If mPackageNavigator.SelectedPackageFilter = PackageFilterTypes.Deleted Then
            mnuRestorePackage.Visible = True
            Exit Sub
        End If

        'Make the right ones visible
        If Not mPackageNavigator.SelectedNode Is Nothing Then
            If mPackageNavigator.SelectedNode.PackageID > 0 Then
                mnuOpenPackage.Visible = True ' Open Package
                mnuSaveAs.Visible = True ' Open Package  
                mnuDeletePackage.Visible = True  'Delete Package
                mnuUnlockPackage.Visible = CurrentUser.IsAdministrator 'Unlock Package
            ElseIf mPackageNavigator.SelectedNode.StudyID > 0 Then
                mnuNewPackage.Visible = True ' New Package
                mnuMFV.Visible = True ' Match Field Validation
            Else
                mnuClientFunction.Visible = True ' Function Library
            End If
        End If

    End Sub

    Private Sub mnuClientFunction_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuClientFunction.Click

        'View, create or modify the function library.
        'The user can create/modify global as well as client level functions.
        Dim customFunctionForm As New frmCustomFunction(mPackageNavigator.SelectedNode.ClientID)
        customFunctionForm.ShowDialog(Me)

    End Sub

    'Setup a new package
    Private Sub mnuNewPackage_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuNewPackage.Click

        NewPackageCommand()

    End Sub

    'Open an existing package
    Private Sub mnuOpenPackage_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuOpenPackage.Click

        mPackageNavigator.SelectPackage()

    End Sub

    'Save a package as a new one
    Private Sub mnuSaveAs_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuSaveAs.Click

        SavePackageAsCommand()

    End Sub

    Private Sub mnuDeletePackage_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuDeletePackage.Click

        If mPackageNavigator.SelectedNode Is Nothing Then Exit Sub

        Dim package As New DTSPackage(mPackageNavigator.SelectedNode.PackageID)

        'Can't delete if the package is locked by someone else
        If package.LockStatus = PackageLockStates.LockedByOther Then
            MessageBox.Show(package.LockMessage, "Delete Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            If MessageBox.Show(String.Format("Are you sure you want to delete ""{0}""?", GetSelectedPackageName()), "Confirm Package Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = Windows.Forms.DialogResult.Yes Then
                DTSPackage.DeletePackage(CurrentUser.LoginName, mPackageNavigator.SelectedNode.PackageID)
                mPackageNavigator.RefreshTree()
                AttachPackage(Nothing)
            End If
        End If

    End Sub

    Private Sub UnlockPackageMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuUnlockPackage.Click

        If mPackageNavigator.SelectedNode IsNot Nothing AndAlso mPackageNavigator.SelectedNode.PackageID > 0 Then
            Dim pack As New DTSPackage(mPackageNavigator.SelectedNode.PackageID)
            pack.UnlockPackage(True)
        End If

    End Sub

    'View the Match Field Validation Screen
    Private Sub mnuMFV_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuMFV.Click

        'Tool to set the fields for match field validation.
        'This will set the match fields at the study not package level.  The user can define the match field validation through the pane navigation.
        Dim DupChecksForm As New frmDupChecks

        With DupChecksForm
            .mStudy.ClientID = mPackageNavigator.SelectedNode.ClientID
            .mStudy.StudyID = mPackageNavigator.SelectedNode.StudyID
            .mStudy.StudyName = mPackageNavigator.SelectedNode.StudyName
            .ShowDialog(Me)
        End With

    End Sub

    'Saves the package information when save button is clicked on the menu.
    Private Sub SavePackageButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)

        If cboPackageOwners.SelectedValue Is Nothing Then
            MessageBox.Show("A package MUST have an owner. Please select an owner.", "The package owner is not selected.", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        SavePackageCommand()

    End Sub

    Private Sub AutoMapButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)

        AutoMap()

    End Sub

    Private Sub ClearMappingsButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)

        ClearMappings()

    End Sub

#End Region

    Private Sub NewPackageCommand()

        If Not PackageClose() Then Exit Sub

        Dim frmNew As New frmNewPackage(mPackageNavigator.SelectedNode.ClientID)
        If frmNew.ShowDialog = Windows.Forms.DialogResult.OK Then
            Try
                Dim pack As New DTSPackage
                pack.Study = New Study(mPackageNavigator.SelectedNode.ClientID, "", mPackageNavigator.SelectedNode.StudyID, "")
                pack.PackageName = frmNew.NewPackageName
                pack.PackageFriendlyName = frmNew.NewFriendlyPackageName
                pack.BitDeleted = False
                pack.BitActive = True

                'By default create the package using a text source file...
                pack.Source = New DTSTextData

                'Save this new package to DB and get the packageID
                Dim newPackageID As Integer = pack.SaveToDB()

                'Now reaload this new package to get all the destination info for the study...
                pack = New DTSPackage(newPackageID)
                pack.LockPackage()
                AttachPackage(pack)

                mPackageNavigator.RefreshTree()

            Catch ex As Exception
                ReportException(ex, "New Package Error")

            End Try
        End If

    End Sub

    Private Sub OpenPackageCommand(ByVal packageId As Integer)

        Dim package As New DTSPackage(packageId)

        If Not package.LockStatus = PackageLockStates.Unlocked Then
            MessageBox.Show(package.LockMessage, "Open Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            package.LockPackage()
            AttachPackage(package)
        End If

    End Sub

    Private Sub SavePackageAsCommand()

        If Not mPackageNavigator.SelectedNode Is Nothing AndAlso mPackageNavigator.SelectedNode.PackageID > 0 Then
            If Not PackageClose() Then Exit Sub

            Try
                Dim saveAs As New frmSaveAs
                If saveAs.ShowDialog = Windows.Forms.DialogResult.OK Then
                    Dim pack As New DTSPackage(mPackageNavigator.SelectedNode.PackageID)
                    Dim newID As Integer = pack.SaveAs(saveAs.ClientID, saveAs.StudyID, saveAs.NewPackageName, saveAs.NewFriendlyPackageName, CurrentUser.LoginName)

                    pack = New DTSPackage(newID)

                    pack.LockPackage()
                    AttachPackage(pack)

                    mPackageNavigator.RefreshTree()
                    mPackageNavigator.SelectNode(String.Format("{0}{1}{2}{3}", saveAs.ClientID, saveAs.StudyID, newID, "0"), "")
                End If

            Catch ex As Exception
                ReportException(ex, "Save As Error")

            End Try
        End If

    End Sub

    Private Function PackageClose() As Boolean

        If mPackage Is Nothing Then Return True

        If mPackage.Modified Then
            If PromptToSave() = Windows.Forms.DialogResult.Cancel Then
                Return False
            End If
        End If

        If mPackage.LockStatus = PackageLockStates.LockedByMe Then
            mPackage.UnlockPackage()
        End If

        mPackage = Nothing
        AttachPackage(Nothing)

        Return True

    End Function

    'Prompt to save the package when needed
    Private Function PromptToSave() As DialogResult

        Dim result As DialogResult = MsgBox("Save changes before closing?", MsgBoxStyle.YesNoCancel, "Save Package")

        Select Case result
            Case Windows.Forms.DialogResult.Cancel
                'Do nothing

            Case Windows.Forms.DialogResult.No
                'Do nothing

            Case Windows.Forms.DialogResult.Yes
                'Save the package
                SavePackageCommand()

        End Select

        Return result

    End Function

    'Saves the package when clicked on the toolbar or selected from a prompt
    Private Sub SavePackageCommand()

        If Not mPackage Is Nothing Then
            If Not ValidatePackageChanges() Then Exit Sub
            Try
                SavePackageInfo()
                mPackage.SaveToDB()
                mPackageNavigator.RefreshTree()

            Catch ex As Exception
                Throw New Exception(ex.Message)
                ReportException(ex, "Save Package Error")

            End Try
        End If

    End Sub
#End Region

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mPackageNavigator = TryCast(navCtrl, PackageNavigator)

        If mPackageNavigator Is Nothing Then
            Throw New ArgumentException("The PackageSetup section control expects a navigator of type 'PackageNavigator'")
        End If

    End Sub

    Public Overrides Sub ActivateSection()

        If mPackageNavigator IsNot Nothing Then
            AddHandler mPackageNavigator.SelectedPackageChanging, AddressOf mPackageNavigator_SelectedPackageChanging
            AddHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.AllowMultiSelect = False

            'QLoader admins and package Admins should be able to see the deleted packages
            If CurrentUser.IsAdministrator OrElse CurrentUser.IsPackageAdmin Then
                Dim tbl As DataTable = CType(mPackageNavigator.cboPackageFilter.ComboBox.DataSource, DataTable)
                tbl.Rows.Add("Deleted", PackageFilterTypes.Deleted)
                mPackageNavigator.cboPackageFilter.ComboBox.DataSource = tbl
            End If

            mPackageNavigator.RefreshTree(ClientTreeTypes.AllStudiesAndPackages)
            mPackageNavigator.TreeContextMenu = cmnSetup
        End If

    End Sub

    Private Sub RemoveDeletedFilterOption()

        Dim tbl As DataTable = CType(mPackageNavigator.cboPackageFilter.ComboBox.DataSource, DataTable)

        For Each row As DataRow In tbl.Rows
            If row("Value") = PackageFilterTypes.Deleted Then
                tbl.Rows.Remove(row)
                mPackageNavigator.cboPackageFilter.ComboBox.DataSource = tbl
                Exit For
            End If
        Next

    End Sub

    Public Overrides Sub InactivateSection()

        If mPackageNavigator IsNot Nothing Then
            RemoveHandler mPackageNavigator.SelectedPackageChanging, AddressOf mPackageNavigator_SelectedPackageChanging
            RemoveHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.TreeContextMenu = Nothing

            RemoveDeletedFilterOption()
        End If

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Return PackageClose()

    End Function

    Public Overrides ReadOnly Property ToolStripItems() As System.Collections.Generic.List(Of System.Windows.Forms.ToolStripItem)
        Get
            Return mToolStripItems
        End Get
    End Property

    Private Sub mPackageNavigator_SelectedPackageChanging(ByVal sender As Object, ByVal e As SelectedPackageChangingEventArgs)

        If Not PackageClose() Then
            e.Cancel = True
        End If

    End Sub

    Private Sub mPackageNavigator_SelectedPackageChanged(ByVal sender As Object, ByVal e As SelectedPackageChangedEventArgs)

        OpenPackageCommand(e.NewPackageId)

    End Sub

#Region "Validation"

    Private Function ValidatePackageFriendlyName() As Boolean

        Dim isValid As Boolean = True

        If txtPackageFriendlyName.Text.Contains("'") Then
            txtPackageFriendlyName.Focus()
            mErrorMessage.AppendLine("Single quote characters are not permitted in Client-Facing Package Name")
            isValid = False
        ElseIf String.IsNullOrEmpty(txtPackageFriendlyName.Text) Then
            mErrorMessage.AppendLine("You must enter a package client-facing name.")
            isValid = False
        ElseIf ((mPackage.PackageFriendlyName.Trim <> txtPackageFriendlyName.Text.Trim) And (DTSPackage.IsUniqueFriendlyPackageName(mPackageNavigator.SelectedNode.ClientID, txtPackageFriendlyName.Text) = False)) Then
            mErrorMessage.AppendLine(String.Format("The client-facing name '{0}' already exists for this client.", txtPackageFriendlyName.Text.Trim))
            isValid = False
        End If

        Return isValid

    End Function

    Private Function ValidatePackageName() As Boolean

        Dim isValid As Boolean = True

        If txtPackageName.Text.Contains("'") Then
            txtPackageName.Focus()
            mErrorMessage.AppendLine("Single quote characters are not permitted in Package Name")
            isValid = False
        ElseIf String.IsNullOrEmpty(txtPackageName.Text) Then
            mErrorMessage.AppendLine("You must enter a package name.")
            isValid = False
        End If

        Return isValid

    End Function


    Private Function ValidatePackageChanges() As Boolean

        mErrorMessage.Remove(0, mErrorMessage.Length)

        Dim IsValid As Boolean = ValidatePackageFriendlyName() And ValidatePackageName()

        If Not IsValid Then
            MessageBox.Show(mErrorMessage.ToString, "Save Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        Return IsValid

    End Function
#End Region

    Private Sub mPackageNavigator_PackageFilterChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mPackageNavigator.PackageFilterChanged

        If mPackageNavigator.SelectedPackageFilter = PackageFilterTypes.Deleted Then
            Visible = False
            PackageClose()
            mPackage = Nothing
        Else
            Visible = True
        End If

    End Sub

    Private Function GetSelectedPackageName() As String

        Return mPackageNavigator.SelectedNode.PackageName

    End Function

    Private Sub mnuRestorePackage_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuRestorePackage.Click

        Dim PackageName As String = GetSelectedPackageName()

        If MessageBox.Show(String.Format("Are you sure you want to put ""{0}"" back?", PackageName), String.Format("You are about to restore {0}.", PackageName), MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            DTSPackage.RestorePackage(CurrentUser.LoginName, mPackageNavigator.SelectedNode.PackageID)
            mPackageNavigator.RefreshTree()
            MessageBox.Show(String.Format("You have successfully restored ""{0}"".", PackageName), "Success!", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If

    End Sub

End Class
