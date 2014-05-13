Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports System.Threading
Imports NRC.DataMart.WebDocumentManager.Library

Public Class ApbRollback
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        'Move tab upward to hide the tabulars
        Me.tabBack.Top -= 22
        Me.tabBack.Height += 22
        Me.tabBack.SendToBack()

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
    Friend WithEvents pnlApbRollbackBackgroup As System.Windows.Forms.Panel
    Friend WithEvents PictureBox2 As System.Windows.Forms.PictureBox
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents dtpFilterDateRangeEnd As System.Windows.Forms.DateTimePicker
    Friend WithEvents dtpFilterDateRangeBegin As System.Windows.Forms.DateTimePicker
    Friend WithEvents dtpFilterPostDateEnd As System.Windows.Forms.DateTimePicker
    Friend WithEvents dtpFilterPostDateBegin As System.Windows.Forms.DateTimePicker
    Friend WithEvents lstFilterClient As System.Windows.Forms.ListBox
    Friend WithEvents lstFilterGroup As System.Windows.Forms.ListBox
    Friend WithEvents txtFilterDocName As System.Windows.Forms.TextBox
    Friend WithEvents btnFilterReset As System.Windows.Forms.Button
    Friend WithEvents btnFilterData As System.Windows.Forms.Button
    Friend WithEvents btnRollback As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents tabBack As System.Windows.Forms.TabControl
    Friend WithEvents tpgSelectDoc As System.Windows.Forms.TabPage
    Friend WithEvents tpgProgress As System.Windows.Forms.TabPage
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents PictureBox4 As System.Windows.Forms.PictureBox
    Friend WithEvents tpgFinish As System.Windows.Forms.TabPage
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents PictureBox5 As System.Windows.Forms.PictureBox
    Friend WithEvents lstFilterMember As System.Windows.Forms.ListBox
    Friend WithEvents tpgGroupPageApb As System.Windows.Forms.TabPage
    Friend WithEvents tpgGroupPageGroup As System.Windows.Forms.TabPage
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader9 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader10 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader13 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader6 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Splitter2 As System.Windows.Forms.Splitter
    Friend WithEvents ColumnHeader8 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader11 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader12 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader14 As System.Windows.Forms.ColumnHeader
    Friend WithEvents lvwApb1 As System.Windows.Forms.ListView
    Friend WithEvents lvwGroup1 As System.Windows.Forms.ListView
    Friend WithEvents lvwApb2 As System.Windows.Forms.ListView
    Friend WithEvents lvwGroup2 As System.Windows.Forms.ListView
    Friend WithEvents tabGrouping As System.Windows.Forms.TabControl
    Friend WithEvents tmrTimer As System.Windows.Forms.Timer
    Friend WithEvents lblProgress As System.Windows.Forms.Label
    Friend WithEvents pbrProgress As System.Windows.Forms.ProgressBar
    Friend WithEvents lblProcessMessage As System.Windows.Forms.Label
    Friend WithEvents ColumnHeader7 As System.Windows.Forms.ColumnHeader
    Friend WithEvents lnkApbTabApbDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabApbSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabApbDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabApbSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabGroupDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabGroupSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabGroupDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbTabGroupSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabApbDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabApbSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabApbDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabApbSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabGroupDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabGroupSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabGroupDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupTabGroupSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents btnFinishTabFinish As System.Windows.Forms.Button
    Friend WithEvents btnProgressTabCancel As System.Windows.Forms.Button
    Friend WithEvents imlIcon As System.Windows.Forms.ImageList
    Friend WithEvents chkFilterDateRangeAll As System.Windows.Forms.CheckBox
    Friend WithEvents chkFilterPostDateAll As System.Windows.Forms.CheckBox
    Friend WithEvents ColumnHeader15 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader16 As System.Windows.Forms.ColumnHeader
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ApbRollback))
        Me.pnlApbRollbackBackgroup = New System.Windows.Forms.Panel
        Me.tabGrouping = New System.Windows.Forms.TabControl
        Me.tpgGroupPageApb = New System.Windows.Forms.TabPage
        Me.lvwApb1 = New System.Windows.Forms.ListView
        Me.ColumnHeader15 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.imlIcon = New System.Windows.Forms.ImageList(Me.components)
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.lvwGroup1 = New System.Windows.Forms.ListView
        Me.ColumnHeader9 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader10 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader13 = New System.Windows.Forms.ColumnHeader
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.lnkApbTabGroupDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabGroupSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabGroupDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabGroupSelectAll = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabApbDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabApbSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabApbDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkApbTabApbSelectAll = New System.Windows.Forms.LinkLabel
        Me.tpgGroupPageGroup = New System.Windows.Forms.TabPage
        Me.lvwApb2 = New System.Windows.Forms.ListView
        Me.ColumnHeader16 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader8 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader11 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader12 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader14 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader7 = New System.Windows.Forms.ColumnHeader
        Me.Splitter2 = New System.Windows.Forms.Splitter
        Me.lvwGroup2 = New System.Windows.Forms.ListView
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader6 = New System.Windows.Forms.ColumnHeader
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.lnkGroupTabGroupDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabGroupSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabGroupDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabGroupSelectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabApbDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabApbSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabApbDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupTabApbSelectAll = New System.Windows.Forms.LinkLabel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnRollback = New System.Windows.Forms.Button
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.chkFilterPostDateAll = New System.Windows.Forms.CheckBox
        Me.chkFilterDateRangeAll = New System.Windows.Forms.CheckBox
        Me.dtpFilterDateRangeEnd = New System.Windows.Forms.DateTimePicker
        Me.dtpFilterDateRangeBegin = New System.Windows.Forms.DateTimePicker
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.dtpFilterPostDateEnd = New System.Windows.Forms.DateTimePicker
        Me.dtpFilterPostDateBegin = New System.Windows.Forms.DateTimePicker
        Me.Label9 = New System.Windows.Forms.Label
        Me.Label10 = New System.Windows.Forms.Label
        Me.Label11 = New System.Windows.Forms.Label
        Me.Label12 = New System.Windows.Forms.Label
        Me.lstFilterClient = New System.Windows.Forms.ListBox
        Me.lstFilterMember = New System.Windows.Forms.ListBox
        Me.Label17 = New System.Windows.Forms.Label
        Me.lstFilterGroup = New System.Windows.Forms.ListBox
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.txtFilterDocName = New System.Windows.Forms.TextBox
        Me.Label18 = New System.Windows.Forms.Label
        Me.btnFilterReset = New System.Windows.Forms.Button
        Me.btnFilterData = New System.Windows.Forms.Button
        Me.PictureBox2 = New System.Windows.Forms.PictureBox
        Me.tabBack = New System.Windows.Forms.TabControl
        Me.tpgSelectDoc = New System.Windows.Forms.TabPage
        Me.tpgProgress = New System.Windows.Forms.TabPage
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.PictureBox4 = New System.Windows.Forms.PictureBox
        Me.btnProgressTabCancel = New System.Windows.Forms.Button
        Me.lblProcessMessage = New System.Windows.Forms.Label
        Me.Label15 = New System.Windows.Forms.Label
        Me.lblProgress = New System.Windows.Forms.Label
        Me.pbrProgress = New System.Windows.Forms.ProgressBar
        Me.tpgFinish = New System.Windows.Forms.TabPage
        Me.btnFinishTabFinish = New System.Windows.Forms.Button
        Me.Label13 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.PictureBox5 = New System.Windows.Forms.PictureBox
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.tmrTimer = New System.Windows.Forms.Timer(Me.components)
        Me.pnlApbRollbackBackgroup.SuspendLayout()
        Me.tabGrouping.SuspendLayout()
        Me.tpgGroupPageApb.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.tpgGroupPageGroup.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.tabBack.SuspendLayout()
        Me.tpgSelectDoc.SuspendLayout()
        Me.tpgProgress.SuspendLayout()
        Me.tpgFinish.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlApbRollbackBackgroup
        '
        Me.pnlApbRollbackBackgroup.Controls.Add(Me.tabGrouping)
        Me.pnlApbRollbackBackgroup.Controls.Add(Me.btnCancel)
        Me.pnlApbRollbackBackgroup.Controls.Add(Me.btnRollback)
        Me.pnlApbRollbackBackgroup.Controls.Add(Me.GroupBox1)
        Me.pnlApbRollbackBackgroup.Controls.Add(Me.GroupBox3)
        Me.pnlApbRollbackBackgroup.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlApbRollbackBackgroup.Location = New System.Drawing.Point(0, 0)
        Me.pnlApbRollbackBackgroup.Name = "pnlApbRollbackBackgroup"
        Me.pnlApbRollbackBackgroup.Size = New System.Drawing.Size(824, 438)
        Me.pnlApbRollbackBackgroup.TabIndex = 0
        '
        'tabGrouping
        '
        Me.tabGrouping.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabGrouping.Appearance = System.Windows.Forms.TabAppearance.FlatButtons
        Me.tabGrouping.Controls.Add(Me.tpgGroupPageApb)
        Me.tabGrouping.Controls.Add(Me.tpgGroupPageGroup)
        Me.tabGrouping.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tabGrouping.Location = New System.Drawing.Point(8, 176)
        Me.tabGrouping.Name = "tabGrouping"
        Me.tabGrouping.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.tabGrouping.SelectedIndex = 0
        Me.tabGrouping.Size = New System.Drawing.Size(808, 224)
        Me.tabGrouping.TabIndex = 2
        '
        'tpgGroupPageApb
        '
        Me.tpgGroupPageApb.Controls.Add(Me.lvwApb1)
        Me.tpgGroupPageApb.Controls.Add(Me.Splitter1)
        Me.tpgGroupPageApb.Controls.Add(Me.lvwGroup1)
        Me.tpgGroupPageApb.Controls.Add(Me.Panel1)
        Me.tpgGroupPageApb.Location = New System.Drawing.Point(4, 28)
        Me.tpgGroupPageApb.Name = "tpgGroupPageApb"
        Me.tpgGroupPageApb.Size = New System.Drawing.Size(800, 192)
        Me.tpgGroupPageApb.TabIndex = 0
        Me.tpgGroupPageApb.Text = "Group by APB"
        '
        'lvwApb1
        '
        Me.lvwApb1.CheckBoxes = True
        Me.lvwApb1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader15, Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader3, Me.ColumnHeader4})
        Me.lvwApb1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwApb1.FullRowSelect = True
        Me.lvwApb1.Location = New System.Drawing.Point(0, 0)
        Me.lvwApb1.Name = "lvwApb1"
        Me.lvwApb1.Size = New System.Drawing.Size(517, 152)
        Me.lvwApb1.SmallImageList = Me.imlIcon
        Me.lvwApb1.TabIndex = 0
        Me.lvwApb1.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader15
        '
        Me.ColumnHeader15.Text = "AP ID"
        Me.ColumnHeader15.Width = 145
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "Document Name"
        Me.ColumnHeader1.Width = 120
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Doc ID"
        Me.ColumnHeader2.Width = 65
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Begin"
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "End"
        '
        'imlIcon
        '
        Me.imlIcon.ImageSize = New System.Drawing.Size(20, 16)
        Me.imlIcon.ImageStream = CType(resources.GetObject("imlIcon.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlIcon.TransparentColor = System.Drawing.Color.Transparent
        '
        'Splitter1
        '
        Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Right
        Me.Splitter1.Location = New System.Drawing.Point(517, 0)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(5, 152)
        Me.Splitter1.TabIndex = 1
        Me.Splitter1.TabStop = False
        '
        'lvwGroup1
        '
        Me.lvwGroup1.CheckBoxes = True
        Me.lvwGroup1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader9, Me.ColumnHeader10, Me.ColumnHeader13})
        Me.lvwGroup1.Dock = System.Windows.Forms.DockStyle.Right
        Me.lvwGroup1.FullRowSelect = True
        Me.lvwGroup1.Location = New System.Drawing.Point(522, 0)
        Me.lvwGroup1.Name = "lvwGroup1"
        Me.lvwGroup1.Size = New System.Drawing.Size(278, 152)
        Me.lvwGroup1.TabIndex = 1
        Me.lvwGroup1.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader9
        '
        Me.ColumnHeader9.Text = "Group Name"
        Me.ColumnHeader9.Width = 100
        '
        'ColumnHeader10
        '
        Me.ColumnHeader10.Text = "Group ID"
        Me.ColumnHeader10.Width = 74
        '
        'ColumnHeader13
        '
        Me.ColumnHeader13.Text = "Posted On"
        Me.ColumnHeader13.Width = 90
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.lnkApbTabGroupDeselectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkApbTabGroupSelectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkApbTabGroupDeselectAll)
        Me.Panel1.Controls.Add(Me.lnkApbTabGroupSelectAll)
        Me.Panel1.Controls.Add(Me.lnkApbTabApbDeselectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkApbTabApbSelectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkApbTabApbDeselectAll)
        Me.Panel1.Controls.Add(Me.lnkApbTabApbSelectAll)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Panel1.Location = New System.Drawing.Point(0, 152)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(800, 40)
        Me.Panel1.TabIndex = 0
        '
        'lnkApbTabGroupDeselectHighlighted
        '
        Me.lnkApbTabGroupDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabGroupDeselectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabGroupDeselectHighlighted.Image = CType(resources.GetObject("lnkApbTabGroupDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkApbTabGroupDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabGroupDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabGroupDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabGroupDeselectHighlighted.Location = New System.Drawing.Point(680, 24)
        Me.lnkApbTabGroupDeselectHighlighted.Name = "lnkApbTabGroupDeselectHighlighted"
        Me.lnkApbTabGroupDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkApbTabGroupDeselectHighlighted.TabIndex = 7
        Me.lnkApbTabGroupDeselectHighlighted.TabStop = True
        Me.lnkApbTabGroupDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkApbTabGroupDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabGroupDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabGroupSelectHighlighted
        '
        Me.lnkApbTabGroupSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabGroupSelectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabGroupSelectHighlighted.Image = CType(resources.GetObject("lnkApbTabGroupSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkApbTabGroupSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabGroupSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabGroupSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabGroupSelectHighlighted.Location = New System.Drawing.Point(680, 4)
        Me.lnkApbTabGroupSelectHighlighted.Name = "lnkApbTabGroupSelectHighlighted"
        Me.lnkApbTabGroupSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkApbTabGroupSelectHighlighted.TabIndex = 5
        Me.lnkApbTabGroupSelectHighlighted.TabStop = True
        Me.lnkApbTabGroupSelectHighlighted.Text = "Select Highlighted"
        Me.lnkApbTabGroupSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabGroupSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabGroupDeselectAll
        '
        Me.lnkApbTabGroupDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabGroupDeselectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabGroupDeselectAll.Image = CType(resources.GetObject("lnkApbTabGroupDeselectAll.Image"), System.Drawing.Image)
        Me.lnkApbTabGroupDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabGroupDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabGroupDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabGroupDeselectAll.Location = New System.Drawing.Point(592, 24)
        Me.lnkApbTabGroupDeselectAll.Name = "lnkApbTabGroupDeselectAll"
        Me.lnkApbTabGroupDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkApbTabGroupDeselectAll.TabIndex = 6
        Me.lnkApbTabGroupDeselectAll.TabStop = True
        Me.lnkApbTabGroupDeselectAll.Text = "Deselect All"
        Me.lnkApbTabGroupDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabGroupDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabGroupSelectAll
        '
        Me.lnkApbTabGroupSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabGroupSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkApbTabGroupSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabGroupSelectAll.Image = CType(resources.GetObject("lnkApbTabGroupSelectAll.Image"), System.Drawing.Image)
        Me.lnkApbTabGroupSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabGroupSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabGroupSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabGroupSelectAll.Location = New System.Drawing.Point(592, 4)
        Me.lnkApbTabGroupSelectAll.Name = "lnkApbTabGroupSelectAll"
        Me.lnkApbTabGroupSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkApbTabGroupSelectAll.TabIndex = 4
        Me.lnkApbTabGroupSelectAll.TabStop = True
        Me.lnkApbTabGroupSelectAll.Text = "Select All"
        Me.lnkApbTabGroupSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabGroupSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabApbDeselectHighlighted
        '
        Me.lnkApbTabApbDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabApbDeselectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabApbDeselectHighlighted.Image = CType(resources.GetObject("lnkApbTabApbDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkApbTabApbDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabApbDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabApbDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabApbDeselectHighlighted.Location = New System.Drawing.Point(88, 24)
        Me.lnkApbTabApbDeselectHighlighted.Name = "lnkApbTabApbDeselectHighlighted"
        Me.lnkApbTabApbDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkApbTabApbDeselectHighlighted.TabIndex = 3
        Me.lnkApbTabApbDeselectHighlighted.TabStop = True
        Me.lnkApbTabApbDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkApbTabApbDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabApbDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabApbSelectHighlighted
        '
        Me.lnkApbTabApbSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabApbSelectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabApbSelectHighlighted.Image = CType(resources.GetObject("lnkApbTabApbSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkApbTabApbSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabApbSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabApbSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabApbSelectHighlighted.Location = New System.Drawing.Point(88, 4)
        Me.lnkApbTabApbSelectHighlighted.Name = "lnkApbTabApbSelectHighlighted"
        Me.lnkApbTabApbSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkApbTabApbSelectHighlighted.TabIndex = 1
        Me.lnkApbTabApbSelectHighlighted.TabStop = True
        Me.lnkApbTabApbSelectHighlighted.Text = "Select Highlighted"
        Me.lnkApbTabApbSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabApbSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabApbDeselectAll
        '
        Me.lnkApbTabApbDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabApbDeselectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabApbDeselectAll.Image = CType(resources.GetObject("lnkApbTabApbDeselectAll.Image"), System.Drawing.Image)
        Me.lnkApbTabApbDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabApbDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabApbDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabApbDeselectAll.Location = New System.Drawing.Point(0, 24)
        Me.lnkApbTabApbDeselectAll.Name = "lnkApbTabApbDeselectAll"
        Me.lnkApbTabApbDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkApbTabApbDeselectAll.TabIndex = 2
        Me.lnkApbTabApbDeselectAll.TabStop = True
        Me.lnkApbTabApbDeselectAll.Text = "Deselect All"
        Me.lnkApbTabApbDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabApbDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbTabApbSelectAll
        '
        Me.lnkApbTabApbSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbTabApbSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkApbTabApbSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkApbTabApbSelectAll.Image = CType(resources.GetObject("lnkApbTabApbSelectAll.Image"), System.Drawing.Image)
        Me.lnkApbTabApbSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbTabApbSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbTabApbSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkApbTabApbSelectAll.Location = New System.Drawing.Point(0, 4)
        Me.lnkApbTabApbSelectAll.Name = "lnkApbTabApbSelectAll"
        Me.lnkApbTabApbSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkApbTabApbSelectAll.TabIndex = 0
        Me.lnkApbTabApbSelectAll.TabStop = True
        Me.lnkApbTabApbSelectAll.Text = "Select All"
        Me.lnkApbTabApbSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbTabApbSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'tpgGroupPageGroup
        '
        Me.tpgGroupPageGroup.Controls.Add(Me.lvwApb2)
        Me.tpgGroupPageGroup.Controls.Add(Me.Splitter2)
        Me.tpgGroupPageGroup.Controls.Add(Me.lvwGroup2)
        Me.tpgGroupPageGroup.Controls.Add(Me.Panel2)
        Me.tpgGroupPageGroup.Location = New System.Drawing.Point(4, 28)
        Me.tpgGroupPageGroup.Name = "tpgGroupPageGroup"
        Me.tpgGroupPageGroup.Size = New System.Drawing.Size(800, 192)
        Me.tpgGroupPageGroup.TabIndex = 1
        Me.tpgGroupPageGroup.Text = "Group by User Group"
        Me.tpgGroupPageGroup.Visible = False
        '
        'lvwApb2
        '
        Me.lvwApb2.CheckBoxes = True
        Me.lvwApb2.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader16, Me.ColumnHeader8, Me.ColumnHeader11, Me.ColumnHeader12, Me.ColumnHeader14, Me.ColumnHeader7})
        Me.lvwApb2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwApb2.FullRowSelect = True
        Me.lvwApb2.Location = New System.Drawing.Point(197, 0)
        Me.lvwApb2.Name = "lvwApb2"
        Me.lvwApb2.Size = New System.Drawing.Size(603, 152)
        Me.lvwApb2.SmallImageList = Me.imlIcon
        Me.lvwApb2.TabIndex = 1
        Me.lvwApb2.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader16
        '
        Me.ColumnHeader16.Text = "AP ID"
        Me.ColumnHeader16.Width = 145
        '
        'ColumnHeader8
        '
        Me.ColumnHeader8.Text = "Document Name"
        Me.ColumnHeader8.Width = 120
        '
        'ColumnHeader11
        '
        Me.ColumnHeader11.Text = "Doc ID"
        Me.ColumnHeader11.Width = 65
        '
        'ColumnHeader12
        '
        Me.ColumnHeader12.Text = "Begin"
        '
        'ColumnHeader14
        '
        Me.ColumnHeader14.Text = "End"
        '
        'ColumnHeader7
        '
        Me.ColumnHeader7.Text = "Posted On"
        Me.ColumnHeader7.Width = 90
        '
        'Splitter2
        '
        Me.Splitter2.Location = New System.Drawing.Point(192, 0)
        Me.Splitter2.Name = "Splitter2"
        Me.Splitter2.Size = New System.Drawing.Size(5, 152)
        Me.Splitter2.TabIndex = 3
        Me.Splitter2.TabStop = False
        '
        'lvwGroup2
        '
        Me.lvwGroup2.CheckBoxes = True
        Me.lvwGroup2.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader5, Me.ColumnHeader6})
        Me.lvwGroup2.Dock = System.Windows.Forms.DockStyle.Left
        Me.lvwGroup2.FullRowSelect = True
        Me.lvwGroup2.Location = New System.Drawing.Point(0, 0)
        Me.lvwGroup2.Name = "lvwGroup2"
        Me.lvwGroup2.Size = New System.Drawing.Size(192, 152)
        Me.lvwGroup2.TabIndex = 0
        Me.lvwGroup2.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "Group Name"
        Me.ColumnHeader5.Width = 100
        '
        'ColumnHeader6
        '
        Me.ColumnHeader6.Text = "Group ID"
        Me.ColumnHeader6.Width = 74
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.lnkGroupTabGroupDeselectHighlighted)
        Me.Panel2.Controls.Add(Me.lnkGroupTabGroupSelectHighlighted)
        Me.Panel2.Controls.Add(Me.lnkGroupTabGroupDeselectAll)
        Me.Panel2.Controls.Add(Me.lnkGroupTabGroupSelectAll)
        Me.Panel2.Controls.Add(Me.lnkGroupTabApbDeselectHighlighted)
        Me.Panel2.Controls.Add(Me.lnkGroupTabApbSelectHighlighted)
        Me.Panel2.Controls.Add(Me.lnkGroupTabApbDeselectAll)
        Me.Panel2.Controls.Add(Me.lnkGroupTabApbSelectAll)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Panel2.Location = New System.Drawing.Point(0, 152)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(800, 40)
        Me.Panel2.TabIndex = 2
        '
        'lnkGroupTabGroupDeselectHighlighted
        '
        Me.lnkGroupTabGroupDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabGroupDeselectHighlighted.Image = CType(resources.GetObject("lnkGroupTabGroupDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupTabGroupDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabGroupDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabGroupDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabGroupDeselectHighlighted.Location = New System.Drawing.Point(88, 24)
        Me.lnkGroupTabGroupDeselectHighlighted.Name = "lnkGroupTabGroupDeselectHighlighted"
        Me.lnkGroupTabGroupDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkGroupTabGroupDeselectHighlighted.TabIndex = 3
        Me.lnkGroupTabGroupDeselectHighlighted.TabStop = True
        Me.lnkGroupTabGroupDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkGroupTabGroupDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabGroupDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabGroupSelectHighlighted
        '
        Me.lnkGroupTabGroupSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabGroupSelectHighlighted.Image = CType(resources.GetObject("lnkGroupTabGroupSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupTabGroupSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabGroupSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabGroupSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabGroupSelectHighlighted.Location = New System.Drawing.Point(88, 6)
        Me.lnkGroupTabGroupSelectHighlighted.Name = "lnkGroupTabGroupSelectHighlighted"
        Me.lnkGroupTabGroupSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkGroupTabGroupSelectHighlighted.TabIndex = 1
        Me.lnkGroupTabGroupSelectHighlighted.TabStop = True
        Me.lnkGroupTabGroupSelectHighlighted.Text = "Select Highlighted"
        Me.lnkGroupTabGroupSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabGroupSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabGroupDeselectAll
        '
        Me.lnkGroupTabGroupDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabGroupDeselectAll.Image = CType(resources.GetObject("lnkGroupTabGroupDeselectAll.Image"), System.Drawing.Image)
        Me.lnkGroupTabGroupDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabGroupDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabGroupDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabGroupDeselectAll.Location = New System.Drawing.Point(0, 24)
        Me.lnkGroupTabGroupDeselectAll.Name = "lnkGroupTabGroupDeselectAll"
        Me.lnkGroupTabGroupDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkGroupTabGroupDeselectAll.TabIndex = 2
        Me.lnkGroupTabGroupDeselectAll.TabStop = True
        Me.lnkGroupTabGroupDeselectAll.Text = "Deselect All"
        Me.lnkGroupTabGroupDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabGroupDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabGroupSelectAll
        '
        Me.lnkGroupTabGroupSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabGroupSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkGroupTabGroupSelectAll.Image = CType(resources.GetObject("lnkGroupTabGroupSelectAll.Image"), System.Drawing.Image)
        Me.lnkGroupTabGroupSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabGroupSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabGroupSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabGroupSelectAll.Location = New System.Drawing.Point(0, 6)
        Me.lnkGroupTabGroupSelectAll.Name = "lnkGroupTabGroupSelectAll"
        Me.lnkGroupTabGroupSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkGroupTabGroupSelectAll.TabIndex = 0
        Me.lnkGroupTabGroupSelectAll.TabStop = True
        Me.lnkGroupTabGroupSelectAll.Text = "Select All"
        Me.lnkGroupTabGroupSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabGroupSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabApbDeselectHighlighted
        '
        Me.lnkGroupTabApbDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabApbDeselectHighlighted.Image = CType(resources.GetObject("lnkGroupTabApbDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupTabApbDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabApbDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabApbDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabApbDeselectHighlighted.Location = New System.Drawing.Point(680, 26)
        Me.lnkGroupTabApbDeselectHighlighted.Name = "lnkGroupTabApbDeselectHighlighted"
        Me.lnkGroupTabApbDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkGroupTabApbDeselectHighlighted.TabIndex = 7
        Me.lnkGroupTabApbDeselectHighlighted.TabStop = True
        Me.lnkGroupTabApbDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkGroupTabApbDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabApbDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabApbSelectHighlighted
        '
        Me.lnkGroupTabApbSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabApbSelectHighlighted.Image = CType(resources.GetObject("lnkGroupTabApbSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupTabApbSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabApbSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabApbSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabApbSelectHighlighted.Location = New System.Drawing.Point(680, 6)
        Me.lnkGroupTabApbSelectHighlighted.Name = "lnkGroupTabApbSelectHighlighted"
        Me.lnkGroupTabApbSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkGroupTabApbSelectHighlighted.TabIndex = 5
        Me.lnkGroupTabApbSelectHighlighted.TabStop = True
        Me.lnkGroupTabApbSelectHighlighted.Text = "Select Highlighted"
        Me.lnkGroupTabApbSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabApbSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabApbDeselectAll
        '
        Me.lnkGroupTabApbDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabApbDeselectAll.Image = CType(resources.GetObject("lnkGroupTabApbDeselectAll.Image"), System.Drawing.Image)
        Me.lnkGroupTabApbDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabApbDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabApbDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabApbDeselectAll.Location = New System.Drawing.Point(592, 26)
        Me.lnkGroupTabApbDeselectAll.Name = "lnkGroupTabApbDeselectAll"
        Me.lnkGroupTabApbDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkGroupTabApbDeselectAll.TabIndex = 6
        Me.lnkGroupTabApbDeselectAll.TabStop = True
        Me.lnkGroupTabApbDeselectAll.Text = "Deselect All"
        Me.lnkGroupTabApbDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabApbDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupTabApbSelectAll
        '
        Me.lnkGroupTabApbSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupTabApbSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkGroupTabApbSelectAll.Image = CType(resources.GetObject("lnkGroupTabApbSelectAll.Image"), System.Drawing.Image)
        Me.lnkGroupTabApbSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupTabApbSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupTabApbSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupTabApbSelectAll.Location = New System.Drawing.Point(592, 6)
        Me.lnkGroupTabApbSelectAll.Name = "lnkGroupTabApbSelectAll"
        Me.lnkGroupTabApbSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkGroupTabApbSelectAll.TabIndex = 4
        Me.lnkGroupTabApbSelectAll.TabStop = True
        Me.lnkGroupTabApbSelectAll.Text = "Select All"
        Me.lnkGroupTabApbSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupTabApbSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Location = New System.Drawing.Point(736, 408)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "Cancel"
        '
        'btnRollback
        '
        Me.btnRollback.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnRollback.Location = New System.Drawing.Point(656, 408)
        Me.btnRollback.Name = "btnRollback"
        Me.btnRollback.TabIndex = 0
        Me.btnRollback.Text = "Rollback"
        '
        'GroupBox1
        '
        Me.GroupBox1.BackColor = System.Drawing.SystemColors.InactiveBorder
        Me.GroupBox1.Controls.Add(Me.chkFilterPostDateAll)
        Me.GroupBox1.Controls.Add(Me.chkFilterDateRangeAll)
        Me.GroupBox1.Controls.Add(Me.dtpFilterDateRangeEnd)
        Me.GroupBox1.Controls.Add(Me.dtpFilterDateRangeBegin)
        Me.GroupBox1.Controls.Add(Me.Label7)
        Me.GroupBox1.Controls.Add(Me.Label8)
        Me.GroupBox1.Controls.Add(Me.dtpFilterPostDateEnd)
        Me.GroupBox1.Controls.Add(Me.dtpFilterPostDateBegin)
        Me.GroupBox1.Controls.Add(Me.Label9)
        Me.GroupBox1.Controls.Add(Me.Label10)
        Me.GroupBox1.Controls.Add(Me.Label11)
        Me.GroupBox1.Controls.Add(Me.Label12)
        Me.GroupBox1.Controls.Add(Me.lstFilterClient)
        Me.GroupBox1.Controls.Add(Me.lstFilterMember)
        Me.GroupBox1.Controls.Add(Me.Label17)
        Me.GroupBox1.Controls.Add(Me.lstFilterGroup)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 16)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(794, 109)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'chkFilterPostDateAll
        '
        Me.chkFilterPostDateAll.Location = New System.Drawing.Point(125, 90)
        Me.chkFilterPostDateAll.Name = "chkFilterPostDateAll"
        Me.chkFilterPostDateAll.Size = New System.Drawing.Size(64, 16)
        Me.chkFilterPostDateAll.TabIndex = 15
        Me.chkFilterPostDateAll.Text = "All Date"
        '
        'chkFilterDateRangeAll
        '
        Me.chkFilterDateRangeAll.Location = New System.Drawing.Point(461, 90)
        Me.chkFilterDateRangeAll.Name = "chkFilterDateRangeAll"
        Me.chkFilterDateRangeAll.Size = New System.Drawing.Size(64, 16)
        Me.chkFilterDateRangeAll.TabIndex = 14
        Me.chkFilterDateRangeAll.Text = "All Date"
        '
        'dtpFilterDateRangeEnd
        '
        Me.dtpFilterDateRangeEnd.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpFilterDateRangeEnd.Location = New System.Drawing.Point(456, 62)
        Me.dtpFilterDateRangeEnd.Name = "dtpFilterDateRangeEnd"
        Me.dtpFilterDateRangeEnd.Size = New System.Drawing.Size(88, 20)
        Me.dtpFilterDateRangeEnd.TabIndex = 11
        '
        'dtpFilterDateRangeBegin
        '
        Me.dtpFilterDateRangeBegin.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpFilterDateRangeBegin.Location = New System.Drawing.Point(456, 24)
        Me.dtpFilterDateRangeBegin.Name = "dtpFilterDateRangeBegin"
        Me.dtpFilterDateRangeBegin.Size = New System.Drawing.Size(88, 20)
        Me.dtpFilterDateRangeBegin.TabIndex = 9
        '
        'Label7
        '
        Me.Label7.Font = New System.Drawing.Font("Microsoft Sans Serif", 6.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.Location = New System.Drawing.Point(464, 46)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(72, 12)
        Me.Label7.TabIndex = 10
        Me.Label7.Text = "through"
        Me.Label7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'Label8
        '
        Me.Label8.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label8.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.Location = New System.Drawing.Point(456, 8)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(87, 16)
        Me.Label8.TabIndex = 8
        Me.Label8.Text = "Report Date"
        '
        'dtpFilterPostDateEnd
        '
        Me.dtpFilterPostDateEnd.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpFilterPostDateEnd.Location = New System.Drawing.Point(120, 62)
        Me.dtpFilterPostDateEnd.Name = "dtpFilterPostDateEnd"
        Me.dtpFilterPostDateEnd.Size = New System.Drawing.Size(88, 20)
        Me.dtpFilterPostDateEnd.TabIndex = 5
        '
        'dtpFilterPostDateBegin
        '
        Me.dtpFilterPostDateBegin.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpFilterPostDateBegin.Location = New System.Drawing.Point(120, 24)
        Me.dtpFilterPostDateBegin.Name = "dtpFilterPostDateBegin"
        Me.dtpFilterPostDateBegin.Size = New System.Drawing.Size(88, 20)
        Me.dtpFilterPostDateBegin.TabIndex = 3
        '
        'Label9
        '
        Me.Label9.Font = New System.Drawing.Font("Microsoft Sans Serif", 6.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.Location = New System.Drawing.Point(128, 46)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(72, 12)
        Me.Label9.TabIndex = 4
        Me.Label9.Text = "through"
        Me.Label9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'Label10
        '
        Me.Label10.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label10.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label10.Location = New System.Drawing.Point(208, 8)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(248, 16)
        Me.Label10.TabIndex = 6
        Me.Label10.Text = "Which Client"
        '
        'Label11
        '
        Me.Label11.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label11.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.Location = New System.Drawing.Point(0, 8)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(120, 16)
        Me.Label11.TabIndex = 0
        Me.Label11.Text = "Who Posted"
        '
        'Label12
        '
        Me.Label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label12.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label12.Location = New System.Drawing.Point(120, 8)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(88, 16)
        Me.Label12.TabIndex = 2
        Me.Label12.Text = "When Posted"
        '
        'lstFilterClient
        '
        Me.lstFilterClient.DisplayMember = "Text"
        Me.lstFilterClient.Location = New System.Drawing.Point(208, 24)
        Me.lstFilterClient.Name = "lstFilterClient"
        Me.lstFilterClient.Size = New System.Drawing.Size(248, 82)
        Me.lstFilterClient.TabIndex = 7
        Me.lstFilterClient.ValueMember = "Value"
        '
        'lstFilterMember
        '
        Me.lstFilterMember.DisplayMember = "Text"
        Me.lstFilterMember.Location = New System.Drawing.Point(0, 24)
        Me.lstFilterMember.Name = "lstFilterMember"
        Me.lstFilterMember.Size = New System.Drawing.Size(120, 82)
        Me.lstFilterMember.TabIndex = 1
        Me.lstFilterMember.ValueMember = "Value"
        '
        'Label17
        '
        Me.Label17.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label17.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label17.Location = New System.Drawing.Point(544, 8)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(248, 16)
        Me.Label17.TabIndex = 12
        Me.Label17.Text = "Which Groups"
        '
        'lstFilterGroup
        '
        Me.lstFilterGroup.DisplayMember = "Text"
        Me.lstFilterGroup.Location = New System.Drawing.Point(544, 24)
        Me.lstFilterGroup.Name = "lstFilterGroup"
        Me.lstFilterGroup.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lstFilterGroup.Size = New System.Drawing.Size(248, 82)
        Me.lstFilterGroup.TabIndex = 13
        Me.lstFilterGroup.ValueMember = "Value"
        '
        'GroupBox3
        '
        Me.GroupBox3.BackColor = System.Drawing.SystemColors.InactiveBorder
        Me.GroupBox3.Controls.Add(Me.txtFilterDocName)
        Me.GroupBox3.Controls.Add(Me.Label18)
        Me.GroupBox3.Controls.Add(Me.btnFilterReset)
        Me.GroupBox3.Controls.Add(Me.btnFilterData)
        Me.GroupBox3.Controls.Add(Me.PictureBox2)
        Me.GroupBox3.Location = New System.Drawing.Point(12, 118)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(794, 46)
        Me.GroupBox3.TabIndex = 1
        Me.GroupBox3.TabStop = False
        '
        'txtFilterDocName
        '
        Me.txtFilterDocName.Location = New System.Drawing.Point(0, 24)
        Me.txtFilterDocName.Name = "txtFilterDocName"
        Me.txtFilterDocName.Size = New System.Drawing.Size(208, 20)
        Me.txtFilterDocName.TabIndex = 1
        Me.txtFilterDocName.Text = ""
        '
        'Label18
        '
        Me.Label18.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label18.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label18.Location = New System.Drawing.Point(0, 8)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(208, 16)
        Me.Label18.TabIndex = 0
        Me.Label18.Text = "Document Name Contains"
        '
        'btnFilterReset
        '
        Me.btnFilterReset.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnFilterReset.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnFilterReset.Location = New System.Drawing.Point(712, 16)
        Me.btnFilterReset.Name = "btnFilterReset"
        Me.btnFilterReset.Size = New System.Drawing.Size(75, 24)
        Me.btnFilterReset.TabIndex = 3
        Me.btnFilterReset.Text = "Reset Filter"
        '
        'btnFilterData
        '
        Me.btnFilterData.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnFilterData.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnFilterData.Location = New System.Drawing.Point(632, 16)
        Me.btnFilterData.Name = "btnFilterData"
        Me.btnFilterData.Size = New System.Drawing.Size(75, 24)
        Me.btnFilterData.TabIndex = 2
        Me.btnFilterData.Text = "Filter Data"
        '
        'PictureBox2
        '
        Me.PictureBox2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PictureBox2.Image = CType(resources.GetObject("PictureBox2.Image"), System.Drawing.Image)
        Me.PictureBox2.Location = New System.Drawing.Point(536, 20)
        Me.PictureBox2.Name = "PictureBox2"
        Me.PictureBox2.Size = New System.Drawing.Size(88, 16)
        Me.PictureBox2.TabIndex = 1
        Me.PictureBox2.TabStop = False
        '
        'tabBack
        '
        Me.tabBack.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabBack.Controls.Add(Me.tpgSelectDoc)
        Me.tabBack.Controls.Add(Me.tpgProgress)
        Me.tabBack.Controls.Add(Me.tpgFinish)
        Me.tabBack.Location = New System.Drawing.Point(0, 24)
        Me.tabBack.Name = "tabBack"
        Me.tabBack.SelectedIndex = 0
        Me.tabBack.Size = New System.Drawing.Size(832, 464)
        Me.tabBack.TabIndex = 1
        '
        'tpgSelectDoc
        '
        Me.tpgSelectDoc.Controls.Add(Me.pnlApbRollbackBackgroup)
        Me.tpgSelectDoc.Location = New System.Drawing.Point(4, 22)
        Me.tpgSelectDoc.Name = "tpgSelectDoc"
        Me.tpgSelectDoc.Size = New System.Drawing.Size(824, 438)
        Me.tpgSelectDoc.TabIndex = 0
        Me.tpgSelectDoc.Text = "Select Document"
        '
        'tpgProgress
        '
        Me.tpgProgress.Controls.Add(Me.PictureBox1)
        Me.tpgProgress.Controls.Add(Me.PictureBox4)
        Me.tpgProgress.Controls.Add(Me.btnProgressTabCancel)
        Me.tpgProgress.Controls.Add(Me.lblProcessMessage)
        Me.tpgProgress.Controls.Add(Me.Label15)
        Me.tpgProgress.Controls.Add(Me.lblProgress)
        Me.tpgProgress.Controls.Add(Me.pbrProgress)
        Me.tpgProgress.Location = New System.Drawing.Point(4, 22)
        Me.tpgProgress.Name = "tpgProgress"
        Me.tpgProgress.Size = New System.Drawing.Size(824, 438)
        Me.tpgProgress.TabIndex = 1
        Me.tpgProgress.Text = "Progress"
        '
        'PictureBox1
        '
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(58, 144)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(48, 48)
        Me.PictureBox1.TabIndex = 24
        Me.PictureBox1.TabStop = False
        '
        'PictureBox4
        '
        Me.PictureBox4.Image = CType(resources.GetObject("PictureBox4.Image"), System.Drawing.Image)
        Me.PictureBox4.Location = New System.Drawing.Point(32, 104)
        Me.PictureBox4.Name = "PictureBox4"
        Me.PictureBox4.Size = New System.Drawing.Size(56, 48)
        Me.PictureBox4.TabIndex = 21
        Me.PictureBox4.TabStop = False
        '
        'btnProgressTabCancel
        '
        Me.btnProgressTabCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnProgressTabCancel.Enabled = False
        Me.btnProgressTabCancel.Location = New System.Drawing.Point(720, 400)
        Me.btnProgressTabCancel.Name = "btnProgressTabCancel"
        Me.btnProgressTabCancel.TabIndex = 25
        Me.btnProgressTabCancel.Text = "Cancel"
        '
        'lblProcessMessage
        '
        Me.lblProcessMessage.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblProcessMessage.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblProcessMessage.Location = New System.Drawing.Point(152, 184)
        Me.lblProcessMessage.Name = "lblProcessMessage"
        Me.lblProcessMessage.Size = New System.Drawing.Size(640, 184)
        Me.lblProcessMessage.TabIndex = 3
        '
        'Label15
        '
        Me.Label15.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label15.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label15.Location = New System.Drawing.Point(24, 24)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(768, 23)
        Me.Label15.TabIndex = 0
        Me.Label15.Text = "Rolling back Action Plan reports ..."
        '
        'lblProgress
        '
        Me.lblProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblProgress.Location = New System.Drawing.Point(152, 128)
        Me.lblProgress.Name = "lblProgress"
        Me.lblProgress.Size = New System.Drawing.Size(640, 16)
        Me.lblProgress.TabIndex = 1
        Me.lblProgress.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pbrProgress
        '
        Me.pbrProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pbrProgress.Location = New System.Drawing.Point(152, 144)
        Me.pbrProgress.Maximum = 3
        Me.pbrProgress.Name = "pbrProgress"
        Me.pbrProgress.Size = New System.Drawing.Size(640, 23)
        Me.pbrProgress.TabIndex = 2
        '
        'tpgFinish
        '
        Me.tpgFinish.Controls.Add(Me.btnFinishTabFinish)
        Me.tpgFinish.Controls.Add(Me.Label13)
        Me.tpgFinish.Controls.Add(Me.Label1)
        Me.tpgFinish.Controls.Add(Me.Label2)
        Me.tpgFinish.Controls.Add(Me.PictureBox5)
        Me.tpgFinish.Location = New System.Drawing.Point(4, 22)
        Me.tpgFinish.Name = "tpgFinish"
        Me.tpgFinish.Size = New System.Drawing.Size(824, 438)
        Me.tpgFinish.TabIndex = 2
        Me.tpgFinish.Text = "Finish"
        '
        'btnFinishTabFinish
        '
        Me.btnFinishTabFinish.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnFinishTabFinish.Location = New System.Drawing.Point(720, 400)
        Me.btnFinishTabFinish.Name = "btnFinishTabFinish"
        Me.btnFinishTabFinish.TabIndex = 11
        Me.btnFinishTabFinish.Text = "Finish"
        '
        'Label13
        '
        Me.Label13.BackColor = System.Drawing.Color.Black
        Me.Label13.Font = New System.Drawing.Font("Arial Black", 15.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label13.ForeColor = System.Drawing.Color.White
        Me.Label13.Location = New System.Drawing.Point(80, 47)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(400, 32)
        Me.Label13.TabIndex = 10
        Me.Label13.Text = "Action Plan Report Rollback Tool"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.Color.White
        Me.Label1.Font = New System.Drawing.Font("Times New Roman", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(240, 239)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(232, 58)
        Me.Label1.TabIndex = 9
        Me.Label1.Text = "Use document manager to verify the rollbacked documents"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.Color.DarkGray
        Me.Label2.Font = New System.Drawing.Font("Arial Black", 14.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.Color.White
        Me.Label2.Location = New System.Drawing.Point(184, 193)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(293, 39)
        Me.Label2.TabIndex = 8
        Me.Label2.Text = "APB Reports Rollbacked"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'PictureBox5
        '
        Me.PictureBox5.Image = CType(resources.GetObject("PictureBox5.Image"), System.Drawing.Image)
        Me.PictureBox5.Location = New System.Drawing.Point(128, 87)
        Me.PictureBox5.Name = "PictureBox5"
        Me.PictureBox5.Size = New System.Drawing.Size(360, 304)
        Me.PictureBox5.TabIndex = 7
        Me.PictureBox5.TabStop = False
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Action Plan Report Rollback Tool"
        Me.SectionPanel1.Controls.Add(Me.tabBack)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(832, 488)
        Me.SectionPanel1.TabIndex = 2
        '
        'tmrTimer
        '
        Me.tmrTimer.Interval = 200
        '
        'ApbRollback
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ApbRollback"
        Me.Size = New System.Drawing.Size(832, 488)
        Me.pnlApbRollbackBackgroup.ResumeLayout(False)
        Me.tabGrouping.ResumeLayout(False)
        Me.tpgGroupPageApb.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.tpgGroupPageGroup.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.tabBack.ResumeLayout(False)
        Me.tpgSelectDoc.ResumeLayout(False)
        Me.tpgProgress.ResumeLayout(False)
        Me.tpgFinish.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members"

    Private Enum StepTabular
        SelectDocument = 0
        Rollbacking = 1
        Finish = 2
    End Enum

    Private Enum GroupingTabular
        GroupByApb = 0
        GroupByGroup = 1
    End Enum

    'APB grouping tabular, APB list view
    Private Enum Apb1Field
        ApID = 0
        DocumentName = 1
        DocumentID = 2
        DateRangeBegin = 3
        DateRangeEnd = 4
        JobID = 5
        DocumentNodeID = 6
    End Enum

    Private mApb1ColumnText() As String = {"AP ID", "Document Name", "Doc ID", "Begin", "End", "Job ID"}
    Private mListViewApb1Sort As New ListViewSortCriteria(Apb1Field.DocumentName, DataType.String, SortOrder.Ascend)

    'APB grouping tabular, group list view
    Private Enum Group1Field
        GroupName = 0
        GroupID = 1
        DatePosted = 2
        JobID = 3
    End Enum

    Private mGroup1ColumnText() As String = {"Group Name", "Group ID", "Posted On", "Job ID"}
    Private mListViewGroup1Sort As New ListViewSortCriteria(Group1Field.GroupName, DataType.String, SortOrder.Ascend)

    'Group grouping tabular, group list view
    Private Enum Group2Field
        GroupName = 0
        GroupID = 1
    End Enum

    Private mGroup2ColumnText() As String = {"Group Name", "Group ID"}
    Private mListViewGroup2Sort As New ListViewSortCriteria(Group2Field.GroupName, DataType.String, SortOrder.Ascend)

    'Group grouping tabular, APB list view
    Private Enum Apb2Field
        ApID = 0
        DocumentName = 1
        DocumentID = 2
        DateRangeBegin = 3
        DateRangeEnd = 4
        DatePosted = 5
        JobID = 6
        GroupID = 7
        DocumentNodeID = 8
    End Enum

    Private mApb2ColumnText() As String = {"AP ID", "Document Name", "Doc ID", "Begin", "End", "Posted On", "Job ID", "Group ID"}
    Private mListViewApb2Sort As New ListViewSortCriteria(Apb2Field.DocumentName, DataType.String, SortOrder.Ascend)

    Private mController As New ApbRollbackController
    Private mTriggeredByProgram As Boolean
    Private mThread As Thread


#End Region

#Region " Public Methods"

    Public Sub Start()
        Me.mController = New ApbRollbackController
        InitSelectDocTab()
        Me.tabBack.SelectedIndex = StepTabular.SelectDocument
    End Sub

#End Region

#Region " Event handlers for tab <Select Document>"

    Private Sub btnRollback_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRollback.Click
        'Check if doc is selected
        Dim count As Integer = Me.mController.SelectedDocumentCount
        If count = 0 Then
            MessageBox.Show("Select document to go on", "Action Plan Report Rollback", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        'Show "Processing" tab
        tabBack.SelectedIndex = StepTabular.Rollbacking

        'Initiate
        btnProgressTabCancel.Enabled = False
        pbrProgress.Maximum = count
        pbrProgress.Value = 0
        lblProcessMessage.Text = "Preparing post ..."
        lblProcessMessage.ForeColor = System.Drawing.SystemColors.ControlText
        IsCountChanged(-1)

        'Start a thread to do the posting
        'Dim thrd As New Thread(AddressOf Post)
        mThread = New Thread(New ThreadStart(AddressOf Rollback))
        mThread.Start()

        'Start timer to monitor the posting status routinely
        tmrTimer.Start()

    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click, btnProgressTabCancel.Click, btnFinishTabFinish.Click
        Me.Start()
    End Sub

    Private Sub lstFilterMember_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstFilterMember.SelectedValueChanged
        If (mTriggeredByProgram) Then Return

        Dim memberID As Integer
        If (lstFilterMember.SelectedIndex = -1) Then
            memberID = 0
        Else
            memberID = CInt(lstFilterMember.SelectedValue)
        End If
        Me.mController.FilterMemberID = memberID

        'Refresh other filters
        DrawFilterClient()
    End Sub

    Private Sub dtpFilterPostDate_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dtpFilterPostDateBegin.ValueChanged, dtpFilterPostDateEnd.ValueChanged
        If (mTriggeredByProgram) Then Return

        Dim datePeriod As New DateRange(dtpFilterPostDateBegin.Value, dtpFilterPostDateEnd.Value)
        Me.mController.FilterPostDate = datePeriod

        'Refresh other filters
        DrawFilterClient()
    End Sub

    Private Sub lstFilterClient_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstFilterClient.SelectedValueChanged
        If (mTriggeredByProgram) Then Return

        Dim clientID As Integer
        If (lstFilterClient.SelectedIndex = -1) Then
            clientID = 0
        Else
            clientID = CInt(lstFilterClient.SelectedValue)
        End If
        Me.mController.FilterClientID = clientID

        'Refresh other filters
        DrawFilterGroup()
    End Sub

    Private Sub dtpFilterDateRange_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dtpFilterDateRangeBegin.ValueChanged, dtpFilterDateRangeEnd.ValueChanged
        If (mTriggeredByProgram) Then Return

        Dim datePeriod As New DateRange(dtpFilterDateRangeBegin.Value, dtpFilterDateRangeEnd.Value)
        Me.mController.FilterReportDate = datePeriod

        'Refresh other filters
        DrawFilterGroup()
    End Sub

    Private Sub chkFilterPostDateAll_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkFilterPostDateAll.CheckedChanged
        Dim datePeriod As DateRange
        If (chkFilterPostDateAll.Checked) Then
            dtpFilterPostDateBegin.Enabled = False
            dtpFilterPostDateEnd.Enabled = False
            datePeriod = New DateRange(New Date(1900, 1, 1), New Date(2999, 12, 31))
        Else
            dtpFilterPostDateBegin.Enabled = True
            dtpFilterPostDateEnd.Enabled = True
            datePeriod = New DateRange(dtpFilterPostDateBegin.Value, dtpFilterPostDateEnd.Value)
        End If
        Me.mController.FilterPostDate = datePeriod
        'Refresh other filters
        DrawFilterClient()
    End Sub

    Private Sub chkFilterDateRangeAll_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkFilterDateRangeAll.CheckedChanged
        Dim datePeriod As DateRange
        If (chkFilterDateRangeAll.Checked) Then
            dtpFilterDateRangeBegin.Enabled = False
            dtpFilterDateRangeEnd.Enabled = False
            datePeriod = New DateRange(New Date(1900, 1, 1), New Date(2999, 12, 31))
        Else
            dtpFilterDateRangeBegin.Enabled = True
            dtpFilterDateRangeEnd.Enabled = True
            datePeriod = New DateRange(dtpFilterDateRangeBegin.Value, dtpFilterDateRangeEnd.Value)
        End If

        Me.mController.FilterReportDate = datePeriod
        'Refresh other filters
        DrawFilterGroup()
    End Sub

    Private Sub btnFilterData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFilterData.Click
        Me.Cursor = Cursors.WaitCursor

        'Save all the filter settings
        With Me.mController
            .FilterMemberID = CInt(lstFilterMember.SelectedValue)
            If (chkFilterPostDateAll.Checked) Then
                .FilterPostDate = New DateRange(New Date(1900, 1, 1), New Date(2999, 12, 31))
            Else
                .FilterPostDate = New DateRange(dtpFilterPostDateBegin.Value, dtpFilterPostDateEnd.Value)
            End If
            .FilterClientID = CInt(lstFilterClient.SelectedValue)
            If (chkFilterDateRangeAll.Checked) Then
                .FilterReportDate = New DateRange(New Date(1900, 1, 1), New Date(2999, 12, 31))
            Else
                .FilterReportDate = New DateRange(dtpFilterDateRangeBegin.Value, dtpFilterDateRangeEnd.Value)
            End If
            If (CInt(lstFilterGroup.SelectedValue) = 0) Then
                .FilterGroupIDs = New ArrayList
            Else
                Dim groups As New ArrayList
                Dim groupID As Integer
                Dim item As ListBoxItem
                For Each item In lstFilterGroup.SelectedItems
                    groupID = item.Value
                    groups.Add(groupID)
                Next
                .FilterGroupIDs = groups
            End If
            .FilterDocNameKeyword = txtFilterDocName.Text.Trim

        End With

        'Pull posted document
        Me.mController.SelectDocuments()

        'Set focus
        If (tabGrouping.SelectedIndex = GroupingTabular.GroupByApb) Then
            DrawApbTabularApbList()
            lvwApb1.Focus()
        Else
            DrawGroupTabularGroupList()
            lvwGroup2.Focus()
        End If

        Me.Cursor = Cursors.Default
    End Sub

    Private Sub btnFilterReset_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFilterReset.Click
        InitFilter()
    End Sub

    Private Sub lvwApb1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwApb1.SelectedIndexChanged
        DrawApbTabularGroupList()
    End Sub

    Private Sub lvwGroup2_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroup2.SelectedIndexChanged
        DrawGroupTabularApbList()
    End Sub

    Private Sub lvwApb1_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwApb1.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        'Get current AP and its check status
        Dim item As ListViewItem = lvwApb1.Items(e.Index)
        Dim checked As Boolean = CBool(IIf(e.NewValue = CheckState.Checked, True, False))

        'Set rollback status of all the groups that assigned to this AP to be same as AP
        Dim jobID As Integer = CInt(item.SubItems(Apb1Field.JobID).Text)
        Dim report As ApbReport = Me.mController.Reports(jobID)
        Dim group As ApbGroup
        For Each group In report.Groups.Values
            group.DoRollback = checked
        Next

        'if check item is not currently selected, select it
        lvwApb1.SelectedItems.Clear()
        item.Selected = True
        item.Focused = True
    End Sub

    Private Sub lvwGroup1_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwGroup1.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        Dim item As ListViewItem = lvwGroup1.Items(e.Index)
        Dim checkJobID As Integer = CInt(item.SubItems(Group1Field.JobID).Text)
        Dim checkGroupID As Integer = CInt(item.SubItems(Group1Field.GroupID).Text)
        Dim jobID As Integer
        Dim checkedCount As Integer = 0
        Dim checked As Boolean

        'Save the check status
        Dim report As ApbReport = Me.mController.Reports(checkJobID)
        If (report Is Nothing) Then Return

        Dim group As ApbGroup = report.Groups(checkGroupID)
        If (group Is Nothing) Then Return

        If (e.NewValue = CheckState.Checked) Then
            group.DoRollback = True
        Else
            group.DoRollback = False
        End If

        'Find out how many checkbox in group list are checked
        For Each group In report.Groups.Values
            If (group.DoRollback) Then checkedCount += 1
        Next
        checked = CBool(IIf(checkedCount > 0, True, False))

        'Set check box for report
        For Each item In lvwApb1.Items
            jobID = CInt(item.SubItems(Apb1Field.JobID).Text)
            If (jobID = checkJobID) Then
                If (item.Checked <> checked) Then
                    mTriggeredByProgram = True
                    item.Checked = checked
                    mTriggeredByProgram = False
                End If
                Exit For
            End If
        Next

        lvwApb1.Focus()
    End Sub

    Private Sub lvwGroup2_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwGroup2.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        'Get current group and its check status
        Dim item As ListViewItem = lvwGroup2.Items(e.Index)
        Dim checked As Boolean = CBool(IIf(e.NewValue = CheckState.Checked, True, False))

        'Set rollback status of this group for all the APs
        Dim groupID As Integer = CInt(item.SubItems(Group2Field.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        Dim report As ApbReport
        For Each report In groupListItem.Reports.Values
            report.DoRollback(groupID) = checked
        Next

        'if check item is not currently selected, select it
        lvwGroup2.SelectedItems.Clear()
        item.Selected = True
        item.Focused = True
    End Sub

    Private Sub lvwApb2_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwApb2.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        Dim item As ListViewItem = lvwApb2.Items(e.Index)
        Dim checkGroupID As Integer = CInt(item.SubItems(Apb2Field.GroupID).Text)
        Dim checkJobID As Integer = CInt(item.SubItems(Apb2Field.JobID).Text)
        Dim groupID As Integer
        Dim checkedCount As Integer = 0
        Dim checked As Boolean

        'Save the check status
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(checkGroupID)
        If (groupListItem Is Nothing) Then Return

        Dim report As ApbReport = groupListItem.Reports(checkJobID)
        If (report Is Nothing) Then Return

        If (e.NewValue = CheckState.Checked) Then
            report.DoRollback(checkGroupID) = True
        Else
            report.DoRollback(checkGroupID) = False
        End If

        'Find out how many checkbox in group list are checked
        For Each report In groupListItem.Reports.Values
            If (report.DoRollback(checkGroupID)) Then checkedCount += 1
        Next
        checked = CBool(IIf(checkedCount > 0, True, False))

        'Set check box for group list item
        For Each item In lvwGroup2.Items
            groupID = CInt(item.SubItems(Group2Field.GroupID).Text)
            If (groupID = checkGroupID) Then
                If (item.Checked <> checked) Then
                    mTriggeredByProgram = True
                    item.Checked = checked
                    mTriggeredByProgram = False
                End If
                Exit For
            End If
        Next

        lvwGroup2.Focus()
    End Sub

    Private Sub lvwApb1_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwApb1.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewApb1Sort.SortColumn

        'Set new sort column index
        Me.mListViewApb1Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case Apb1Field.DocumentName
                Me.mListViewApb1Sort.DataType = DataType.String
            Case Apb1Field.DocumentID
                Me.mListViewApb1Sort.DataType = DataType.Integer
            Case Apb1Field.DateRangeBegin, Apb1Field.DateRangeEnd
                Me.mListViewApb1Sort.DataType = DataType.Date
        End Select

        'Append ascend/descend arrow to the column header text
        Dim text As String = Me.mApb1ColumnText(e.Column) + Me.mListViewApb1Sort.SortOrderIcon
        lvw.Columns(e.Column).Text = text

        'Delete ascend/descend arrow from the header text of the original sort column
        If (origSortColumn <> e.Column) Then
            lvw.Columns(origSortColumn).Text = Me.mApb1ColumnText(origSortColumn)
        End If

        'Sort
        lvw.Sort()

        lvw.EndUpdate()
    End Sub

    Private Sub lvwGroup1_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwGroup1.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewGroup1Sort.SortColumn

        'Set new sort column index
        Me.mListViewGroup1Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case Group1Field.GroupName
                Me.mListViewGroup1Sort.DataType = DataType.String
            Case Group1Field.GroupID, Group1Field.JobID
                Me.mListViewGroup1Sort.DataType = DataType.Integer
            Case Group1Field.DatePosted
                Me.mListViewGroup1Sort.DataType = DataType.Date
        End Select

        'Append ascend/descend arrow to the column header text
        Dim text As String = Me.mGroup1ColumnText(e.Column) + Me.mListViewGroup1Sort.SortOrderIcon
        lvw.Columns(e.Column).Text = text

        'Delete ascend/descend arrow from the header text of the original sort column
        If (origSortColumn <> e.Column) Then
            lvw.Columns(origSortColumn).Text = Me.mGroup1ColumnText(origSortColumn)
        End If

        'Sort
        lvw.Sort()

        lvw.EndUpdate()

    End Sub

    Private Sub lvwGroup2_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwGroup2.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewGroup2Sort.SortColumn

        'Set new sort column index
        Me.mListViewGroup2Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case Group2Field.GroupName
                Me.mListViewGroup2Sort.DataType = DataType.String
            Case Group2Field.GroupID
                Me.mListViewGroup2Sort.DataType = DataType.Integer
        End Select

        'Append ascend/descend arrow to the column header text
        Dim text As String = Me.mGroup2ColumnText(e.Column) + Me.mListViewGroup2Sort.SortOrderIcon
        lvw.Columns(e.Column).Text = text

        'Delete ascend/descend arrow from the header text of the original sort column
        If (origSortColumn <> e.Column) Then
            lvw.Columns(origSortColumn).Text = Me.mGroup2ColumnText(origSortColumn)
        End If

        'Sort
        lvw.Sort()

        lvw.EndUpdate()

    End Sub

    Private Sub lvwApb2_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwApb2.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewApb2Sort.SortColumn

        'Set new sort column index
        Me.mListViewApb2Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case Apb2Field.DocumentName
                Me.mListViewApb2Sort.DataType = DataType.String
            Case Apb2Field.DocumentID, Apb2Field.JobID, Apb2Field.GroupID
                Me.mListViewApb2Sort.DataType = DataType.Integer
            Case Apb2Field.DateRangeBegin, Apb2Field.DateRangeEnd, Apb2Field.DatePosted
                Me.mListViewApb2Sort.DataType = DataType.Date
        End Select

        'Append ascend/descend arrow to the column header text
        Dim text As String = Me.mApb2ColumnText(e.Column) + Me.mListViewApb2Sort.SortOrderIcon
        lvw.Columns(e.Column).Text = text

        'Delete ascend/descend arrow from the header text of the original sort column
        If (origSortColumn <> e.Column) Then
            lvw.Columns(origSortColumn).Text = Me.mApb2ColumnText(origSortColumn)
        End If

        'Sort
        lvw.Sort()

        lvw.EndUpdate()
    End Sub

    Private Sub tabGrouping_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tabGrouping.SelectedIndexChanged
        Me.Cursor = Cursors.WaitCursor

        If (tabGrouping.SelectedIndex = GroupingTabular.GroupByApb) Then
            DrawApbTabularApbList()
            lvwApb1.Focus()
        Else
            DrawGroupTabularGroupList()
            lvwGroup2.Focus()
        End If

        Me.Cursor = Cursors.Default
    End Sub

    'Private Sub lvwGroup1_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroup1.GotFocus
    '    lvwApb1.Focus()
    'End Sub

    'Private Sub lvwApb2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwApb2.GotFocus
    '    lvwGroup2.Focus()
    'End Sub

    Private Sub lvwApb1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwApb1.MouseDown
        If (e.X < 25 OrElse e.X > 45) Then Return
        Dim item As ListViewItem = lvwApb1.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then Return
        Dim documentNodeID As Integer = CInt(item.SubItems(Apb1Field.DocumentNodeID).Text)
        If (documentNodeID <= 0) Then Return
        Dim doc As Document = Document.GetDocument(documentNodeID)
        Me.Cursor = Cursors.WaitCursor
        Try
            doc.DisplayFile()
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Display Document", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub lvwApb1_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwApb1.MouseMove
        If (e.X < 25 OrElse e.X > 45) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (lvwApb1.GetItemAt(e.X, e.Y) Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        Me.Cursor = Cursors.Hand

    End Sub

    Private Sub lvwApb2_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwApb2.MouseDown
        If (e.X < 25 OrElse e.X > 45) Then Return
        Dim item As ListViewItem = lvwApb2.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then Return
        Dim documentNodeID As Integer = CInt(item.SubItems(Apb2Field.DocumentNodeID).Text)
        If (documentNodeID <= 0) Then Return
        Dim doc As Document = Document.GetDocument(documentNodeID)
        Me.Cursor = Cursors.WaitCursor
        Try
            doc.DisplayFile()
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Display Document", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub lvwApb2_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwApb2.MouseMove
        If (e.X < 25 OrElse e.X > 45) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (lvwApb2.GetItemAt(e.X, e.Y) Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        Me.Cursor = Cursors.Hand

    End Sub

#Region " Event handlers for <Select XXX> buttons"

    Private Sub lnkApbTabApbSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabApbSelectAll.LinkClicked
        SelectAllApbAndGroup(True)
        lvwApb1.Focus()
    End Sub

    Private Sub lnkApbTabApbDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabApbDeselectAll.LinkClicked
        SelectAllApbAndGroup(False)
        lvwApb1.Focus()
    End Sub

    Private Sub lnkApbTabApbSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabApbSelectHighlighted.LinkClicked
        SelectApbTabHighlightedApb(True)
        lvwApb1.Focus()
    End Sub

    Private Sub lnkApbTabApbDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabApbDeselectHighlighted.LinkClicked
        SelectApbTabHighlightedApb(False)
        lvwApb1.Focus()
    End Sub


    Private Sub lnkApbTabGroupSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabGroupSelectAll.LinkClicked
        SelectApbTabAllGroup(True)
        lvwGroup1.Focus()
    End Sub

    Private Sub lnkApbTabGroupDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabGroupDeselectAll.LinkClicked
        SelectApbTabAllGroup(False)
        lvwGroup1.Focus()
    End Sub

    Private Sub lnkApbTabGroupSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabGroupSelectHighlighted.LinkClicked
        SelectApbTabHighlightedGroup(True)
        lvwGroup1.Focus()
    End Sub

    Private Sub lnkApbTabGroupDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbTabGroupDeselectHighlighted.LinkClicked
        SelectApbTabHighlightedGroup(False)
        lvwGroup1.Focus()
    End Sub

    Private Sub lnkGroupTabGroupSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabGroupSelectAll.LinkClicked
        SelectAllApbAndGroup(True)
        lvwGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabGroupDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabGroupDeselectAll.LinkClicked
        SelectAllApbAndGroup(False)
        lvwGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabGroupSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabGroupSelectHighlighted.LinkClicked
        SelectGroupTabHighlightedGroup(True)
        lvwGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabGroupDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabGroupDeselectHighlighted.LinkClicked
        SelectGroupTabHighlightedGroup(False)
        lvwGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabApbSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabApbSelectAll.LinkClicked
        SelectGroupTabAllApb(True)
        lvwApb2.Focus()
    End Sub

    Private Sub lnkGroupTabApbDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabApbDeselectAll.LinkClicked
        SelectGroupTabAllApb(False)
        lvwApb2.Focus()
    End Sub

    Private Sub lnkGroupTabApbSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabApbSelectHighlighted.LinkClicked
        SelectGroupTabHighlightedApb(True)
        lvwApb2.Focus()
    End Sub

    Private Sub lnkGroupTabApbDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupTabApbDeselectHighlighted.LinkClicked
        SelectGroupTabHighlightedApb(False)
        lvwApb2.Focus()
    End Sub

#End Region

#Region " Event handlers for size change"

    Private Sub lvwApb1_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwApb1.SizeChanged
        ListViewResize(CType(sender, ListView), Apb1Field.DocumentName)
    End Sub

    Private Sub lvwGroup1_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroup1.SizeChanged
        ListViewResize(CType(sender, ListView), Group1Field.GroupName)
    End Sub

    Private Sub lvwApb2_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwApb2.SizeChanged
        ListViewResize(CType(sender, ListView), Apb2Field.DocumentName)
    End Sub

    Private Sub lvwGroup2_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroup2.SizeChanged
        ListViewResize(CType(sender, ListView), Group2Field.GroupName)
    End Sub

#End Region

#End Region

#Region " Event handlers for tab <Rollbacking>"

    Private Sub tmrTimer_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tmrTimer.Tick
        Select Case Me.mController.RollbackResult
            Case ApbRollbackController.RollbackStatus.Rollbacking
                If (lblProcessMessage.Text <> Me.mController.RollbackMessage) Then
                    lblProcessMessage.Text = Me.mController.RollbackMessage
                End If
                If (IsCountChanged(Me.mController.RollbackedCount)) Then
                    pbrProgress.Value = Me.mController.RollbackedCount
                    lblProgress.Text = pbrProgress.Value & " of " & pbrProgress.Maximum & " rollbacked"
                End If
            Case ApbRollbackController.RollbackStatus.Failed
                tmrTimer.Stop()
                lblProcessMessage.Text = Me.mController.RollbackMessage
                pbrProgress.Value = Me.mController.RollbackedCount
                lblProgress.Text = pbrProgress.Value & " of " & pbrProgress.Maximum & " rollbacked"
                btnProgressTabCancel.Enabled = True
            Case ApbRollbackController.RollbackStatus.Succeed
                tmrTimer.Stop()
                tabBack.SelectedIndex = StepTabular.Finish
        End Select

    End Sub

#End Region

#Region " Private Method for Overall"

    Private Function IsCountChanged(ByVal count As Integer) As Boolean
        Static origCount As Integer

        If (origCount <> count) Then
            origCount = count
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub ListViewResize(ByVal lvw As ListView, ByVal resizableColumnIndex As Integer)
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            If width < 50 Then width = 50
            .Columns(resizableColumnIndex).Width = width
        End With

    End Sub

#End Region

#Region " Private Method for tab <Select Document>"

    Private Sub InitFilter()
        mTriggeredByProgram = True
        InitFilterPostDate()
        InitFilterReportDate()
        InitFilterClient()
        InitFilterGroup()
        InitFilterDocNameKeyword()
        mTriggeredByProgram = False
        'Note: Init member will trigger data setting in other filters.
        '      So it must be in the last step
        InitFilterMember()
    End Sub

    Private Sub InitSelectDocTab()
        InitDocListView()
        InitFilter()
    End Sub

    Private Sub InitFilterMember()
        Dim myMemberID As Integer = CurrentUser.Member.MemberId
        Dim memberID As Integer
        Dim name As String
        Dim items As New ArrayList
        Dim mePosted As Boolean = False

        'Pull data
        Dim rdr As SqlDataReader = mController.SelectMembers()
        If (rdr Is Nothing) Then
            lstFilterMember.DataSource = Nothing
        End If

        'Populate data
        While rdr.Read
            memberID = CInt(rdr("Member_ID"))
            name = CStr(rdr("strFName")) + " " + CStr(rdr("strLName"))
            items.Add(New ListBoxItem(memberID, name))
            If (myMemberID = memberID) Then mePosted = True
        End While
        rdr.Close()

        'Show data
        lstFilterMember.BeginUpdate()
        lstFilterMember.DataSource = items
        If mePosted Then
            lstFilterMember.SelectedValue = myMemberID
            lstFilterMember_SelectedValueChanged(lstFilterMember, Nothing)
        ElseIf (lstFilterMember.Items.Count > 0) Then
            lstFilterMember.SelectedIndex = 0
        End If
        lstFilterMember.EndUpdate()
    End Sub

    Private Sub InitFilterPostDate()
        chkFilterPostDateAll.Checked = False
        Dim datePeriod As New DateRange(Today.AddMonths(-1), Today)
        dtpFilterPostDateBegin.Value = datePeriod.DateBegin
        dtpFilterPostDateEnd.Value = datePeriod.DateEnd
        Me.mController.FilterPostDate = datePeriod
    End Sub

    Private Sub InitFilterClient()
        lstFilterClient.DataSource = Nothing
    End Sub

    Private Sub InitFilterReportDate()
        chkFilterDateRangeAll.Checked = False
        Dim currentQuarter As Integer
        Select Case Today.Month
            Case 1, 2, 3
                currentQuarter = 1
            Case 4, 5, 6
                currentQuarter = 2
            Case 7, 8, 9
                currentQuarter = 3
            Case 10, 11, 12
                currentQuarter = 4
        End Select
        Dim firstMonthOfCurrentQuarter As Integer = (currentQuarter - 1) * 3 + 1
        Dim firstDayOfCurrentQuarter As New Date(Today.Year, firstMonthOfCurrentQuarter, 1)

        Dim datePeriod As New DateRange(firstDayOfCurrentQuarter.AddMonths(-3), _
                                        firstDayOfCurrentQuarter.AddDays(-1))
        dtpFilterDateRangeBegin.Value = datePeriod.DateBegin
        dtpFilterDateRangeEnd.Value = datePeriod.DateEnd
        Me.mController.FilterReportDate = datePeriod
    End Sub

    Private Sub InitFilterGroup()
        lstFilterGroup.DataSource = Nothing
    End Sub

    Private Sub InitFilterDocNameKeyword()
        txtFilterDocName.Text = ""
    End Sub

    Private Sub InitDocListView()
        lvwGroup1.Items.Clear()
        lvwApb1.Items.Clear()
        lvwApb2.Items.Clear()
        lvwGroup2.Items.Clear()
    End Sub

    Private Sub DrawFilterClient()
        Dim clientID As Integer
        Dim clientName As String
        Dim items As New ArrayList

        'Pull data
        Dim rdr As SqlDataReader = Me.mController.SelectClients
        If rdr Is Nothing Then
            lstFilterClient.DataSource = Nothing
            Return
        End If

        'Populate data
        While rdr.Read
            clientID = CInt(rdr("Client_ID"))
            clientName = CStr(rdr("strClient_NM")) & " (" & clientID & ")"
            items.Add(New ListBoxItem(clientID, clientName))
        End While
        rdr.Close()

        'Show data
        lstFilterClient.BeginUpdate()
        lstFilterClient.DataSource = items
        If (lstFilterClient.Items.Count > 0) Then lstFilterClient.SelectedIndex = 0
        lstFilterClient.EndUpdate()
    End Sub

    Private Sub DrawFilterGroup()
        Dim groupID As Integer
        Dim groupName As String
        Dim items As New ArrayList

        'Pull data
        Dim rdr As SqlDataReader = Me.mController.SelectGroups
        If rdr Is Nothing Then
            lstFilterGroup.DataSource = Nothing
            Return
        End If

        'Populate data
        While rdr.Read
            'Add first "all" item
            If (items.Count = 0) Then
                items.Add(New ListBoxItem(0, "_All"))
            End If
            groupID = CInt(rdr("Group_ID"))
            groupName = CStr(rdr("strOrgUnit_nm")) + " - " + CStr(rdr("strGroup_NM"))
            items.Add(New ListBoxItem(groupID, groupName))
        End While
        rdr.Close()

        'Show data
        lstFilterGroup.BeginUpdate()
        lstFilterGroup.DataSource = items
        lstFilterGroup.SelectedValue = 0
        lstFilterGroup.EndUpdate()
    End Sub

    Private Sub DrawApbTabularApbList()
        mTriggeredByProgram = True
        lvwApb1.Items.Clear()
        lvwGroup1.Items.Clear()
        mTriggeredByProgram = False

        Dim reports As ApbReportCollection = mController.Reports
        If (reports Is Nothing) Then Return
        Dim report As ApbReport
        Dim itmListItem As ListViewItem
        Dim group As ApbGroup
        Dim documentNodeID As Integer

        mTriggeredByProgram = True
        lvwApb1.BeginUpdate()

        'Show APB list
        For Each report In reports.Values
            itmListItem = New ListViewItem
            itmListItem.Checked = report.DoRollback
            itmListItem.ImageIndex = 0
            itmListItem.Text = report.ApID
            itmListItem.SubItems.Add(report.DocumentName)
            itmListItem.SubItems.Add(report.DocumentID.ToString)
            itmListItem.SubItems.Add(report.DateRangeBegin.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.DateRangeEnd.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.JobID.ToString)
            For Each group In report.Groups.Values
                documentNodeID = group.DocCopies(0).DocumentNodeID
                Exit For
            Next
            itmListItem.SubItems.Add(documentNodeID.ToString)
            lvwApb1.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwApb1
            .ListViewItemSorter = New ListViewComparer(Me.mListViewApb1Sort)
            .Sort()
            .Columns(Me.mListViewApb1Sort.SortColumn).Text = _
                mApb1ColumnText(Me.mListViewApb1Sort.SortColumn) + mListViewApb1Sort.SortOrderIcon
        End With

        lvwApb1.EndUpdate()
        mTriggeredByProgram = False

        If (lvwApb1.Items.Count > 0) Then
            lvwApb1.Items(0).Selected = True
        End If

    End Sub

    Private Sub DrawApbTabularGroupList()
        mTriggeredByProgram = True
        lvwGroup1.Items.Clear()
        mTriggeredByProgram = False

        If (lvwApb1.SelectedItems.Count <= 0) Then Return

        'Find the selected ApbReport object
        Dim item As ListViewItem = lvwApb1.SelectedItems(0)
        Dim jobID As Integer = CInt(item.SubItems(Apb1Field.JobID).Text)
        Dim report As ApbReport = Me.mController.Reports(jobID)
        Dim groups As ApbGroupCollection = report.Groups
        Dim group As ApbGroup
        Dim itmListItem As ListViewItem

        'Show ApbGroup objects in the group list
        mTriggeredByProgram = True
        lvwGroup1.BeginUpdate()
        For Each group In groups.Values
            mTriggeredByProgram = True
            itmListItem = New ListViewItem
            itmListItem.Checked = group.DoRollback
            itmListItem.Text = group.GroupName
            itmListItem.SubItems.Add(group.GroupID.ToString)
            itmListItem.SubItems.Add(group.DatePosted.ToString("MM/dd/yy hh:mm"))
            itmListItem.SubItems.Add(jobID.ToString)
            lvwGroup1.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwGroup1
            .ListViewItemSorter = New ListViewComparer(Me.mListViewGroup1Sort)
            .Sort()
            .Columns(Me.mListViewGroup1Sort.SortColumn).Text = _
                mGroup1ColumnText(Me.mListViewGroup1Sort.SortColumn) + mListViewGroup1Sort.SortOrderIcon
        End With

        lvwGroup1.EndUpdate()
        mTriggeredByProgram = False
    End Sub

    Private Sub DrawGroupTabularGroupList()
        mTriggeredByProgram = True
        lvwGroup2.Items.Clear()
        lvwApb2.Items.Clear()
        mTriggeredByProgram = False

        Dim groupListItems As ApbGroupListItemCollection = Me.mController.GroupListItems
        If (groupListItems Is Nothing) Then Return
        Dim groupItem As ApbGroupListItem
        Dim itmListItem As ListViewItem

        mTriggeredByProgram = True
        lvwGroup2.BeginUpdate()
        For Each groupItem In groupListItems.Values
            mTriggeredByProgram = True
            itmListItem = New ListViewItem
            itmListItem.Checked = groupItem.DoRollback
            itmListItem.Text = groupItem.GroupName
            itmListItem.SubItems.Add(groupItem.GroupID.ToString)
            lvwGroup2.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwGroup2
            .ListViewItemSorter = New ListViewComparer(Me.mListViewGroup2Sort)
            .Sort()
            .Columns(Me.mListViewGroup2Sort.SortColumn).Text = _
                mGroup2ColumnText(Me.mListViewGroup2Sort.SortColumn) + mListViewGroup2Sort.SortOrderIcon
        End With

        lvwGroup2.EndUpdate()
        mTriggeredByProgram = False

        If (lvwGroup2.Items.Count > 0) Then
            lvwGroup2.Items(0).Selected = True
        End If

    End Sub

    Private Sub DrawGroupTabularApbList()
        mTriggeredByProgram = True
        lvwApb2.Items.Clear()
        mTriggeredByProgram = False

        If (lvwGroup2.SelectedItems.Count <= 0) Then Return

        'Find the selected ApbGroupListItem object
        Dim item As ListViewItem = lvwGroup2.SelectedItems(0)
        Dim groupID As Integer = CInt(item.SubItems(Group2Field.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        Dim reports As ApbReportCollection = groupListItem.Reports
        Dim report As ApbReport
        Dim itmListItem As ListViewItem
        Dim group As ApbGroup
        Dim documentNodeID As Integer

        'Show APB list
        mTriggeredByProgram = True
        lvwApb2.BeginUpdate()
        For Each report In reports.Values
            itmListItem = New ListViewItem
            itmListItem.Checked = report.DoRollback(groupID)
            itmListItem.ImageIndex = 0
            itmListItem.Text = report.ApID
            itmListItem.SubItems.Add(report.DocumentName)
            itmListItem.SubItems.Add(report.DocumentID.ToString)
            itmListItem.SubItems.Add(report.DateRangeBegin.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.DateRangeEnd.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.DatePosted(groupID).ToString("MM/dd/yy hh:mm"))
            itmListItem.SubItems.Add(report.JobID.ToString)
            itmListItem.SubItems.Add(groupID.ToString)
            For Each group In report.Groups.Values
                documentNodeID = group.DocCopies(0).DocumentNodeID
                Exit For
            Next
            itmListItem.SubItems.Add(documentNodeID.ToString)
            lvwApb2.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwApb2
            .ListViewItemSorter = New ListViewComparer(Me.mListViewApb2Sort)
            .Sort()
            .Columns(Me.mListViewApb2Sort.SortColumn).Text = _
                mApb2ColumnText(Me.mListViewApb2Sort.SortColumn) + mListViewApb2Sort.SortOrderIcon
        End With

        lvwApb2.EndUpdate()
        mTriggeredByProgram = False

    End Sub

    Private Sub RefreshCheckBoxes()
        If (tabGrouping.SelectedIndex = GroupingTabular.GroupByApb) Then
            RefreshApbTabCheckBoxes()
        Else
            RefreshGroupTabCheckBoxes()
        End If
    End Sub

    Private Sub RefreshApbTabCheckBoxes()
        Dim item As ListViewItem
        Dim jobID As Integer
        Dim report As ApbReport
        Dim groupID As Integer
        Dim group As ApbGroup

        Me.mTriggeredByProgram = True

        'Set lvwApb1
        For Each item In lvwApb1.Items
            jobID = CInt(item.SubItems(Apb1Field.JobID).Text)
            item.Checked = Me.mController.Reports(jobID).DoRollback
        Next

        'Set lvwGroup1
        jobID = CInt(lvwGroup1.Items(0).SubItems(Group1Field.JobID).Text)
        report = Me.mController.Reports(jobID)
        If (report Is Nothing) Then
            Me.mTriggeredByProgram = False
            Return
        End If
        For Each item In lvwGroup1.Items
            groupID = CInt(item.SubItems(Group1Field.GroupID).Text)
            group = report.Groups(groupID)
            If (Not group Is Nothing) Then item.Checked = group.DoRollback
        Next

        Me.mTriggeredByProgram = False
    End Sub

    Private Sub RefreshGroupTabCheckBoxes()
        Dim item As ListViewItem
        Dim groupID As Integer
        Dim groupListItem As ApbGroupListItem
        Dim jobID As Integer
        Dim report As ApbReport

        Me.mTriggeredByProgram = True

        'Set lvwGroup2
        For Each item In lvwGroup2.Items
            groupID = CInt(item.SubItems(Group2Field.GroupID).Text)
            item.Checked = Me.mController.GroupListItems(groupID).DoRollback
        Next

        'Set lvwApb2
        groupID = CInt(lvwApb2.Items(0).SubItems(Apb2Field.GroupID).Text)
        groupListItem = Me.mController.GroupListItems(groupID)
        If (groupListItem Is Nothing) Then
            Me.mTriggeredByProgram = False
            Return
        End If
        For Each item In lvwApb2.Items
            jobID = CInt(item.SubItems(Apb2Field.JobID).Text)
            report = groupListItem.Reports(jobID)
            If (Not report Is Nothing) Then item.Checked = report.DoRollback(groupID)
        Next

        Me.mTriggeredByProgram = False

    End Sub

#Region " Private methods for selecting report/group"

    Private Sub SelectAllApbAndGroup(ByVal checked As Boolean)
        Dim report As ApbReport
        For Each report In Me.mController.Reports.Values
            report.DoRollback = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectApbTabHighlightedApb(ByVal checked As Boolean)
        Dim item As ListViewItem
        Dim jobID As Integer
        Dim report As ApbReport

        For Each item In lvwApb1.SelectedItems
            jobID = CInt(item.SubItems(Apb1Field.JobID).Text)
            report = Me.mController.Reports(jobID)
            If (Not report Is Nothing) Then report.DoRollback = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectApbTabAllGroup(ByVal checked As Boolean)
        If lvwGroup1.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwGroup1.Items(0)
        Dim jobID As Integer = CInt(item.SubItems(Group1Field.JobID).Text)
        Dim report As ApbReport = Me.mController.Reports(jobID)
        If (report Is Nothing) Then Return
        report.DoRollback = checked
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectApbTabHighlightedGroup(ByVal checked As Boolean)
        If lvwGroup1.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwGroup1.Items(0)
        Dim jobID As Integer = CInt(item.SubItems(Group1Field.JobID).Text)
        Dim report As ApbReport = Me.mController.Reports(jobID)
        If (report Is Nothing) Then Return
        Dim groupID As Integer
        Dim group As ApbGroup

        For Each item In lvwGroup1.SelectedItems
            groupID = CInt(item.SubItems(Group1Field.GroupID).Text)
            group = report.Groups(groupID)
            If (Not group Is Nothing) Then group.DoRollback = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectGroupTabHighlightedGroup(ByVal checked As Boolean)
        Dim item As ListViewItem
        Dim groupID As Integer
        Dim groupListItem As ApbGroupListItem

        For Each item In lvwGroup2.SelectedItems
            groupID = CInt(item.SubItems(Group2Field.GroupID).Text)
            groupListItem = Me.mController.GroupListItems(groupID)
            If (Not groupListItem Is Nothing) Then groupListItem.DoRollback = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectGroupTabAllApb(ByVal checked As Boolean)
        If lvwApb2.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwApb2.Items(0)
        Dim groupID As Integer = CInt(item.SubItems(Apb2Field.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        If (groupListItem Is Nothing) Then Return
        groupListItem.DoRollback = checked
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectGroupTabHighlightedApb(ByVal checked As Boolean)
        If lvwApb2.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwApb2.Items(0)
        Dim groupID As Integer = CInt(item.SubItems(Apb2Field.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        If (groupListItem Is Nothing) Then Return
        Dim jobID As Integer
        Dim report As ApbReport

        For Each item In lvwApb2.SelectedItems
            jobID = CInt(item.SubItems(Apb2Field.JobID).Text)
            report = groupListItem.Reports(jobID)
            If (Not report Is Nothing) Then report.DoRollback = checked
        Next
        RefreshCheckBoxes()
    End Sub

#End Region

#End Region

#Region " Private Method for tab <Rollbacking>"

    Private Sub Rollback()
        Me.mController.Rollback()
    End Sub

#End Region

End Class
