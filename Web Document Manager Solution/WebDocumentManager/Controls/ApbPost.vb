Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports System.Threading
Imports NRC.WinForms

Public Class ApbPost
    Inherits System.Windows.Forms.UserControl

#Region " Private Classes"

    Private Class ListBoxTextItem

        Private mValue As String
        Private mText As String

        Public Property Value() As String
            Get
                Return mValue
            End Get
            Set(ByVal Value As String)
                mValue = Value
            End Set
        End Property

        Public Property Text() As String
            Get
                Return mText
            End Get
            Set(ByVal Value As String)
                mText = Value
            End Set
        End Property

        Public Sub New(ByVal value As String, ByVal text As String)
            mValue = value
            mText = text
        End Sub

        Public Overrides Function ToString() As String
            Return mText
        End Function

    End Class

#End Region

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

        'Move tab upward to hide the tabulars
        Me.tabWizard.Top -= 22
        Me.tabWizard.Height += 22
        Me.tabWizard.SendToBack()

        'Set wizard step info
        InitWizardStepInfo()
        mWizard = New MapWizard(mWizardData)

        'Set init data
        tabGroupPageGrouping.SelectedIndex = 1

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
    Friend WithEvents lblStepFinish As System.Windows.Forms.Label
    Friend WithEvents lblStepStart As System.Windows.Forms.Label
    Friend WithEvents pnlStepFinish As System.Windows.Forms.Panel
    Friend WithEvents pnlStepStart As System.Windows.Forms.Panel
    Friend WithEvents btnFinish As System.Windows.Forms.Button
    Friend WithEvents btnNext As System.Windows.Forms.Button
    Friend WithEvents btnBack As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents lblStepVerifyGroup As System.Windows.Forms.Label
    Friend WithEvents lblStepSelectApb As System.Windows.Forms.Label
    Friend WithEvents pnlStepVerifyGroup As System.Windows.Forms.Panel
    Friend WithEvents pnlStepSelectApb As System.Windows.Forms.Panel
    Friend WithEvents lblStepPreview As System.Windows.Forms.Label
    Friend WithEvents pnlStepPreview As System.Windows.Forms.Panel
    Friend WithEvents tpgStepStart As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepSelectApb As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepVerifyGroup As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepFinish As System.Windows.Forms.TabPage
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents pnlBackPanel As NRC.WinForms.SectionPanel
    Friend WithEvents lstApbPageClient As System.Windows.Forms.ListBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents PictureBox2 As System.Windows.Forms.PictureBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents lstApbPageNotify As System.Windows.Forms.ListBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents btnApbPageFilterData As System.Windows.Forms.Button
    Friend WithEvents btnApbPageResetFilter As System.Windows.Forms.Button
    Friend WithEvents lvwApbPageApbList As System.Windows.Forms.ListView
    Friend WithEvents ApID As System.Windows.Forms.ColumnHeader
    Friend WithEvents DateGenerated As System.Windows.Forms.ColumnHeader
    Friend WithEvents JobID As System.Windows.Forms.ColumnHeader
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents lnkApbPageSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbPageDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents imlApbPageReport As System.Windows.Forms.ImageList
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents lvwGroupPageGroup1 As System.Windows.Forms.ListView
    Friend WithEvents tpgGroupPageApb As System.Windows.Forms.TabPage
    Friend WithEvents tpgGroupPageGroup As System.Windows.Forms.TabPage
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents tabWizard As System.Windows.Forms.TabControl
    Friend WithEvents Splitter3 As System.Windows.Forms.Splitter
    Friend WithEvents pnlRight As System.Windows.Forms.Panel
    Friend WithEvents pnlLeft As System.Windows.Forms.Panel
    Friend WithEvents pnlBottom As System.Windows.Forms.Panel
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader6 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader7 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader8 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader11 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader12 As System.Windows.Forms.ColumnHeader
    Friend WithEvents lvwGroupPageGroup2 As System.Windows.Forms.ListView
    Friend WithEvents lvwGroupPageApb2 As System.Windows.Forms.ListView
    Friend WithEvents DocumentName As System.Windows.Forms.ColumnHeader
    Friend WithEvents DateRangeBegin As System.Windows.Forms.ColumnHeader
    Friend WithEvents DateRangeEnd As System.Windows.Forms.ColumnHeader
    Friend WithEvents tpgStepDuplicateCheck As System.Windows.Forms.TabPage
    Friend WithEvents lblStepDuplicateCheck As System.Windows.Forms.Label
    Friend WithEvents pnlStepDuplicateCheck As System.Windows.Forms.Panel
    Friend WithEvents lblStepRepostCheck As System.Windows.Forms.Label
    Friend WithEvents pnlStepRepostCheck As System.Windows.Forms.Panel
    Friend WithEvents lvwDupCheckPagePath As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader13 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Splitter4 As System.Windows.Forms.Splitter
    Friend WithEvents lvwDupCheckPageApb As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader14 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader15 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader16 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader17 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader20 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader21 As System.Windows.Forms.ColumnHeader
    Friend WithEvents pnlDupCheckPageBack As System.Windows.Forms.Panel
    Friend WithEvents pnlDupCheckPageApbBack As System.Windows.Forms.Panel
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents tpgStepRepostCheck As System.Windows.Forms.TabPage
    Friend WithEvents pbrRepostPageProgress As System.Windows.Forms.ProgressBar
    Friend WithEvents lblRepostPageProgress As System.Windows.Forms.Label
    Friend WithEvents PictureBox3 As System.Windows.Forms.PictureBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents lnkApbPageSelectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkApbPageDeselectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lblStepPosting As System.Windows.Forms.Label
    Friend WithEvents pnlStepPosting As System.Windows.Forms.Panel
    Friend WithEvents tpgStepSummary As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepPosting As System.Windows.Forms.TabPage
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents PictureBox4 As System.Windows.Forms.PictureBox
    Friend WithEvents lnkDupCheckPageRefresh As System.Windows.Forms.LinkLabel
    Friend WithEvents lblPostPageProgress As System.Windows.Forms.Label
    Friend WithEvents pbrPostPageProgress As System.Windows.Forms.ProgressBar
    Friend WithEvents PictureBox5 As System.Windows.Forms.PictureBox
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents lblPostPageMessage As System.Windows.Forms.Label
    Friend WithEvents tmrTimer As System.Windows.Forms.Timer
    Friend WithEvents lvwGroupPageApb1 As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader9 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader10 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents Panel3 As System.Windows.Forms.Panel
    Friend WithEvents Panel4 As System.Windows.Forms.Panel
    Friend WithEvents Splitter2 As System.Windows.Forms.Splitter
    Friend WithEvents lnkGroupPageApbTabApbDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabApbSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabApbDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabApbSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabGroupDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabGroupSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabGroupDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageApbTabGroupSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabGroupDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabGroupSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabGroupDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabGroupSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabApbDeselectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabApbSelectHighlighted As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabApbDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkGroupPageGroupTabApbSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents tabGroupPageGrouping As System.Windows.Forms.TabControl
    Friend WithEvents Panel5 As System.Windows.Forms.Panel
    Friend WithEvents Panel6 As System.Windows.Forms.Panel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents lvwSummaryPageList As NRC.WinForms.NRCListView
    Friend WithEvents chdSummaryPageApID As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdSummaryPageDocName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdSummaryPageGroupName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdSummaryPagePath As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdSummaryPagePathIcon As System.Windows.Forms.ColumnHeader
    Friend WithEvents lblDupCheckPageTitle As System.Windows.Forms.Label
    Friend WithEvents chdSummaryPageApIcon As System.Windows.Forms.ColumnHeader
    Friend WithEvents btnSummaryPageExport As System.Windows.Forms.Button
    Friend WithEvents sfdSave As System.Windows.Forms.SaveFileDialog
    Friend WithEvents ApDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents lblSummaryPageApbCount As System.Windows.Forms.Label
    Friend WithEvents lblSummaryPageGroupCount As System.Windows.Forms.Label
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents chkApbPageGenerateDateAll As System.Windows.Forms.CheckBox
    Friend WithEvents dtpApbPageGenerateDateEnd As System.Windows.Forms.DateTimePicker
    Friend WithEvents dtpApbPageGenerateDateBegin As System.Windows.Forms.DateTimePicker
    Friend WithEvents Label19 As System.Windows.Forms.Label
    Friend WithEvents lblApbPageSelectCount As System.Windows.Forms.Label
    Friend WithEvents lblApbPageTotalCount As System.Windows.Forms.Label
    Friend WithEvents PictureBox6 As System.Windows.Forms.PictureBox
    Friend WithEvents PictureBox7 As System.Windows.Forms.PictureBox
    Friend WithEvents PictureBox8 As System.Windows.Forms.PictureBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ApbPost))
        Me.pnlBackPanel = New NRC.WinForms.SectionPanel
        Me.pnlRight = New System.Windows.Forms.Panel
        Me.tabWizard = New System.Windows.Forms.TabControl
        Me.tpgStepStart = New System.Windows.Forms.TabPage
        Me.PictureBox6 = New System.Windows.Forms.PictureBox
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.tpgStepSelectApb = New System.Windows.Forms.TabPage
        Me.Label19 = New System.Windows.Forms.Label
        Me.lblApbPageTotalCount = New System.Windows.Forms.Label
        Me.Label10 = New System.Windows.Forms.Label
        Me.lblApbPageSelectCount = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.dtpApbPageGenerateDateEnd = New System.Windows.Forms.DateTimePicker
        Me.dtpApbPageGenerateDateBegin = New System.Windows.Forms.DateTimePicker
        Me.Label17 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.lstApbPageClient = New System.Windows.Forms.ListBox
        Me.lstApbPageNotify = New System.Windows.Forms.ListBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.chkApbPageGenerateDateAll = New System.Windows.Forms.CheckBox
        Me.lnkApbPageDeselectHighlight = New System.Windows.Forms.LinkLabel
        Me.lnkApbPageSelectHighlight = New System.Windows.Forms.LinkLabel
        Me.lnkApbPageDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkApbPageSelectAll = New System.Windows.Forms.LinkLabel
        Me.lvwApbPageApbList = New System.Windows.Forms.ListView
        Me.ApID = New System.Windows.Forms.ColumnHeader
        Me.ApDescription = New System.Windows.Forms.ColumnHeader
        Me.DocumentName = New System.Windows.Forms.ColumnHeader
        Me.DateRangeBegin = New System.Windows.Forms.ColumnHeader
        Me.DateRangeEnd = New System.Windows.Forms.ColumnHeader
        Me.DateGenerated = New System.Windows.Forms.ColumnHeader
        Me.JobID = New System.Windows.Forms.ColumnHeader
        Me.imlApbPageReport = New System.Windows.Forms.ImageList(Me.components)
        Me.Label11 = New System.Windows.Forms.Label
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.PictureBox2 = New System.Windows.Forms.PictureBox
        Me.btnApbPageResetFilter = New System.Windows.Forms.Button
        Me.btnApbPageFilterData = New System.Windows.Forms.Button
        Me.tpgStepVerifyGroup = New System.Windows.Forms.TabPage
        Me.tabGroupPageGrouping = New System.Windows.Forms.TabControl
        Me.tpgGroupPageApb = New System.Windows.Forms.TabPage
        Me.Panel5 = New System.Windows.Forms.Panel
        Me.lvwGroupPageApb1 = New System.Windows.Forms.ListView
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader9 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader10 = New System.Windows.Forms.ColumnHeader
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.lvwGroupPageGroup1 = New System.Windows.Forms.ListView
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.lnkGroupPageApbTabGroupDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabGroupSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabGroupDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabGroupSelectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabApbDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabApbSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabApbDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageApbTabApbSelectAll = New System.Windows.Forms.LinkLabel
        Me.tpgGroupPageGroup = New System.Windows.Forms.TabPage
        Me.Panel6 = New System.Windows.Forms.Panel
        Me.lvwGroupPageApb2 = New System.Windows.Forms.ListView
        Me.ColumnHeader7 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader8 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader11 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader12 = New System.Windows.Forms.ColumnHeader
        Me.Splitter2 = New System.Windows.Forms.Splitter
        Me.Panel4 = New System.Windows.Forms.Panel
        Me.lvwGroupPageGroup2 = New System.Windows.Forms.ListView
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader6 = New System.Windows.Forms.ColumnHeader
        Me.Panel3 = New System.Windows.Forms.Panel
        Me.lnkGroupPageGroupTabApbDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabApbSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabApbDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabApbSelectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabGroupSelectHighlighted = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabGroupDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkGroupPageGroupTabGroupSelectAll = New System.Windows.Forms.LinkLabel
        Me.Label6 = New System.Windows.Forms.Label
        Me.tpgStepDuplicateCheck = New System.Windows.Forms.TabPage
        Me.lnkDupCheckPageRefresh = New System.Windows.Forms.LinkLabel
        Me.pnlDupCheckPageBack = New System.Windows.Forms.Panel
        Me.pnlDupCheckPageApbBack = New System.Windows.Forms.Panel
        Me.lvwDupCheckPageApb = New System.Windows.Forms.ListView
        Me.ColumnHeader14 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader15 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader21 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader16 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader17 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader20 = New System.Windows.Forms.ColumnHeader
        Me.Splitter4 = New System.Windows.Forms.Splitter
        Me.lvwDupCheckPagePath = New System.Windows.Forms.ListView
        Me.ColumnHeader13 = New System.Windows.Forms.ColumnHeader
        Me.lblDupCheckPageTitle = New System.Windows.Forms.Label
        Me.tpgStepRepostCheck = New System.Windows.Forms.TabPage
        Me.PictureBox5 = New System.Windows.Forms.PictureBox
        Me.lblRepostPageProgress = New System.Windows.Forms.Label
        Me.pbrRepostPageProgress = New System.Windows.Forms.ProgressBar
        Me.Label8 = New System.Windows.Forms.Label
        Me.tpgStepSummary = New System.Windows.Forms.TabPage
        Me.Label16 = New System.Windows.Forms.Label
        Me.Label12 = New System.Windows.Forms.Label
        Me.lblSummaryPageGroupCount = New System.Windows.Forms.Label
        Me.lblSummaryPageApbCount = New System.Windows.Forms.Label
        Me.btnSummaryPageExport = New System.Windows.Forms.Button
        Me.lvwSummaryPageList = New NRC.WinForms.NRCListView
        Me.chdSummaryPageApIcon = New System.Windows.Forms.ColumnHeader
        Me.chdSummaryPageApID = New System.Windows.Forms.ColumnHeader
        Me.chdSummaryPageDocName = New System.Windows.Forms.ColumnHeader
        Me.chdSummaryPageGroupName = New System.Windows.Forms.ColumnHeader
        Me.chdSummaryPagePathIcon = New System.Windows.Forms.ColumnHeader
        Me.chdSummaryPagePath = New System.Windows.Forms.ColumnHeader
        Me.Label14 = New System.Windows.Forms.Label
        Me.tpgStepPosting = New System.Windows.Forms.TabPage
        Me.lblPostPageMessage = New System.Windows.Forms.Label
        Me.Label15 = New System.Windows.Forms.Label
        Me.PictureBox4 = New System.Windows.Forms.PictureBox
        Me.lblPostPageProgress = New System.Windows.Forms.Label
        Me.pbrPostPageProgress = New System.Windows.Forms.ProgressBar
        Me.tpgStepFinish = New System.Windows.Forms.TabPage
        Me.PictureBox8 = New System.Windows.Forms.PictureBox
        Me.PictureBox7 = New System.Windows.Forms.PictureBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.PictureBox3 = New System.Windows.Forms.PictureBox
        Me.Splitter3 = New System.Windows.Forms.Splitter
        Me.pnlLeft = New System.Windows.Forms.Panel
        Me.lblStepPosting = New System.Windows.Forms.Label
        Me.pnlStepPosting = New System.Windows.Forms.Panel
        Me.lblStepRepostCheck = New System.Windows.Forms.Label
        Me.pnlStepRepostCheck = New System.Windows.Forms.Panel
        Me.lblStepPreview = New System.Windows.Forms.Label
        Me.pnlStepPreview = New System.Windows.Forms.Panel
        Me.lblStepFinish = New System.Windows.Forms.Label
        Me.lblStepDuplicateCheck = New System.Windows.Forms.Label
        Me.lblStepVerifyGroup = New System.Windows.Forms.Label
        Me.lblStepSelectApb = New System.Windows.Forms.Label
        Me.lblStepStart = New System.Windows.Forms.Label
        Me.pnlStepFinish = New System.Windows.Forms.Panel
        Me.pnlStepDuplicateCheck = New System.Windows.Forms.Panel
        Me.pnlStepVerifyGroup = New System.Windows.Forms.Panel
        Me.pnlStepSelectApb = New System.Windows.Forms.Panel
        Me.pnlStepStart = New System.Windows.Forms.Panel
        Me.pnlBottom = New System.Windows.Forms.Panel
        Me.btnFinish = New System.Windows.Forms.Button
        Me.btnNext = New System.Windows.Forms.Button
        Me.btnBack = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.tmrTimer = New System.Windows.Forms.Timer(Me.components)
        Me.sfdSave = New System.Windows.Forms.SaveFileDialog
        Me.pnlBackPanel.SuspendLayout()
        Me.pnlRight.SuspendLayout()
        Me.tabWizard.SuspendLayout()
        Me.tpgStepStart.SuspendLayout()
        Me.tpgStepSelectApb.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.tpgStepVerifyGroup.SuspendLayout()
        Me.tabGroupPageGrouping.SuspendLayout()
        Me.tpgGroupPageApb.SuspendLayout()
        Me.Panel5.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.tpgGroupPageGroup.SuspendLayout()
        Me.Panel6.SuspendLayout()
        Me.Panel4.SuspendLayout()
        Me.Panel3.SuspendLayout()
        Me.tpgStepDuplicateCheck.SuspendLayout()
        Me.pnlDupCheckPageBack.SuspendLayout()
        Me.pnlDupCheckPageApbBack.SuspendLayout()
        Me.tpgStepRepostCheck.SuspendLayout()
        Me.tpgStepSummary.SuspendLayout()
        Me.tpgStepPosting.SuspendLayout()
        Me.tpgStepFinish.SuspendLayout()
        Me.pnlLeft.SuspendLayout()
        Me.pnlBottom.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlBackPanel
        '
        Me.pnlBackPanel.BackColor = System.Drawing.Color.Black
        Me.pnlBackPanel.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.pnlBackPanel.Caption = "Action Plan Report Posting Wizard"
        Me.pnlBackPanel.Controls.Add(Me.pnlRight)
        Me.pnlBackPanel.Controls.Add(Me.Splitter3)
        Me.pnlBackPanel.Controls.Add(Me.pnlLeft)
        Me.pnlBackPanel.Controls.Add(Me.pnlBottom)
        Me.pnlBackPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlBackPanel.DockPadding.All = 1
        Me.pnlBackPanel.Location = New System.Drawing.Point(0, 0)
        Me.pnlBackPanel.Name = "pnlBackPanel"
        Me.pnlBackPanel.ShowCaption = True
        Me.pnlBackPanel.Size = New System.Drawing.Size(864, 688)
        Me.pnlBackPanel.TabIndex = 0
        '
        'pnlRight
        '
        Me.pnlRight.BackColor = System.Drawing.Color.Black
        Me.pnlRight.Controls.Add(Me.tabWizard)
        Me.pnlRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRight.Location = New System.Drawing.Point(147, 27)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Size = New System.Drawing.Size(716, 620)
        Me.pnlRight.TabIndex = 43
        '
        'tabWizard
        '
        Me.tabWizard.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabWizard.Controls.Add(Me.tpgStepStart)
        Me.tabWizard.Controls.Add(Me.tpgStepSelectApb)
        Me.tabWizard.Controls.Add(Me.tpgStepVerifyGroup)
        Me.tabWizard.Controls.Add(Me.tpgStepDuplicateCheck)
        Me.tabWizard.Controls.Add(Me.tpgStepRepostCheck)
        Me.tabWizard.Controls.Add(Me.tpgStepSummary)
        Me.tabWizard.Controls.Add(Me.tpgStepPosting)
        Me.tabWizard.Controls.Add(Me.tpgStepFinish)
        Me.tabWizard.Location = New System.Drawing.Point(0, 0)
        Me.tabWizard.Name = "tabWizard"
        Me.tabWizard.SelectedIndex = 0
        Me.tabWizard.Size = New System.Drawing.Size(2025, 616)
        Me.tabWizard.TabIndex = 0
        '
        'tpgStepStart
        '
        Me.tpgStepStart.Controls.Add(Me.PictureBox6)
        Me.tpgStepStart.Controls.Add(Me.PictureBox1)
        Me.tpgStepStart.Controls.Add(Me.Label2)
        Me.tpgStepStart.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepStart.Name = "tpgStepStart"
        Me.tpgStepStart.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepStart.TabIndex = 0
        Me.tpgStepStart.Text = "Start"
        '
        'PictureBox6
        '
        Me.PictureBox6.Image = CType(resources.GetObject("PictureBox6.Image"), System.Drawing.Image)
        Me.PictureBox6.Location = New System.Drawing.Point(24, 24)
        Me.PictureBox6.Name = "PictureBox6"
        Me.PictureBox6.Size = New System.Drawing.Size(416, 32)
        Me.PictureBox6.TabIndex = 5
        Me.PictureBox6.TabStop = False
        '
        'PictureBox1
        '
        Me.PictureBox1.BackColor = System.Drawing.Color.White
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(88, 136)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(352, 216)
        Me.PictureBox1.TabIndex = 4
        Me.PictureBox1.TabStop = False
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.Color.White
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(88, 64)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(352, 72)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "This wizard will take you step by step  through the process of posting Action Pla" & _
        "n Builder reports."
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'tpgStepSelectApb
        '
        Me.tpgStepSelectApb.Controls.Add(Me.Label19)
        Me.tpgStepSelectApb.Controls.Add(Me.lblApbPageTotalCount)
        Me.tpgStepSelectApb.Controls.Add(Me.Label10)
        Me.tpgStepSelectApb.Controls.Add(Me.lblApbPageSelectCount)
        Me.tpgStepSelectApb.Controls.Add(Me.GroupBox1)
        Me.tpgStepSelectApb.Controls.Add(Me.lnkApbPageDeselectHighlight)
        Me.tpgStepSelectApb.Controls.Add(Me.lnkApbPageSelectHighlight)
        Me.tpgStepSelectApb.Controls.Add(Me.lnkApbPageDeselectAll)
        Me.tpgStepSelectApb.Controls.Add(Me.lnkApbPageSelectAll)
        Me.tpgStepSelectApb.Controls.Add(Me.lvwApbPageApbList)
        Me.tpgStepSelectApb.Controls.Add(Me.Label11)
        Me.tpgStepSelectApb.Controls.Add(Me.GroupBox2)
        Me.tpgStepSelectApb.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepSelectApb.Name = "tpgStepSelectApb"
        Me.tpgStepSelectApb.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepSelectApb.TabIndex = 1
        Me.tpgStepSelectApb.Text = "Select APB"
        '
        'Label19
        '
        Me.Label19.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label19.Location = New System.Drawing.Point(574, 568)
        Me.Label19.Name = "Label19"
        Me.Label19.Size = New System.Drawing.Size(32, 16)
        Me.Label19.TabIndex = 17
        Me.Label19.Text = "total"
        Me.Label19.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApbPageTotalCount
        '
        Me.lblApbPageTotalCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblApbPageTotalCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApbPageTotalCount.Location = New System.Drawing.Point(536, 568)
        Me.lblApbPageTotalCount.Name = "lblApbPageTotalCount"
        Me.lblApbPageTotalCount.Size = New System.Drawing.Size(32, 16)
        Me.lblApbPageTotalCount.TabIndex = 16
        Me.lblApbPageTotalCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label10
        '
        Me.Label10.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label10.Location = New System.Drawing.Point(648, 568)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(48, 16)
        Me.Label10.TabIndex = 15
        Me.Label10.Text = "selected"
        Me.Label10.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApbPageSelectCount
        '
        Me.lblApbPageSelectCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblApbPageSelectCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApbPageSelectCount.Location = New System.Drawing.Point(616, 568)
        Me.lblApbPageSelectCount.Name = "lblApbPageSelectCount"
        Me.lblApbPageSelectCount.Size = New System.Drawing.Size(32, 16)
        Me.lblApbPageSelectCount.TabIndex = 14
        Me.lblApbPageSelectCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'GroupBox1
        '
        Me.GroupBox1.BackColor = System.Drawing.SystemColors.InactiveBorder
        Me.GroupBox1.Controls.Add(Me.dtpApbPageGenerateDateEnd)
        Me.GroupBox1.Controls.Add(Me.dtpApbPageGenerateDateBegin)
        Me.GroupBox1.Controls.Add(Me.Label17)
        Me.GroupBox1.Controls.Add(Me.Label5)
        Me.GroupBox1.Controls.Add(Me.lstApbPageClient)
        Me.GroupBox1.Controls.Add(Me.lstApbPageNotify)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.chkApbPageGenerateDateAll)
        Me.GroupBox1.Location = New System.Drawing.Point(16, 32)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(560, 96)
        Me.GroupBox1.TabIndex = 13
        Me.GroupBox1.TabStop = False
        '
        'dtpApbPageGenerateDateEnd
        '
        Me.dtpApbPageGenerateDateEnd.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpApbPageGenerateDateEnd.Location = New System.Drawing.Point(136, 56)
        Me.dtpApbPageGenerateDateEnd.Name = "dtpApbPageGenerateDateEnd"
        Me.dtpApbPageGenerateDateEnd.Size = New System.Drawing.Size(96, 20)
        Me.dtpApbPageGenerateDateEnd.TabIndex = 18
        '
        'dtpApbPageGenerateDateBegin
        '
        Me.dtpApbPageGenerateDateBegin.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpApbPageGenerateDateBegin.Location = New System.Drawing.Point(136, 24)
        Me.dtpApbPageGenerateDateBegin.Name = "dtpApbPageGenerateDateBegin"
        Me.dtpApbPageGenerateDateBegin.Size = New System.Drawing.Size(96, 20)
        Me.dtpApbPageGenerateDateBegin.TabIndex = 16
        '
        'Label17
        '
        Me.Label17.Font = New System.Drawing.Font("Microsoft Sans Serif", 6.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label17.Location = New System.Drawing.Point(136, 41)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(96, 16)
        Me.Label17.TabIndex = 17
        Me.Label17.Text = "through"
        Me.Label17.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'Label5
        '
        Me.Label5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label5.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.Location = New System.Drawing.Point(136, 8)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(96, 16)
        Me.Label5.TabIndex = 3
        Me.Label5.Text = "When Generated"
        '
        'lstApbPageClient
        '
        Me.lstApbPageClient.Location = New System.Drawing.Point(232, 24)
        Me.lstApbPageClient.Name = "lstApbPageClient"
        Me.lstApbPageClient.Size = New System.Drawing.Size(326, 69)
        Me.lstApbPageClient.TabIndex = 6
        '
        'lstApbPageNotify
        '
        Me.lstApbPageNotify.Location = New System.Drawing.Point(0, 24)
        Me.lstApbPageNotify.Name = "lstApbPageNotify"
        Me.lstApbPageNotify.Size = New System.Drawing.Size(136, 69)
        Me.lstApbPageNotify.TabIndex = 2
        '
        'Label3
        '
        Me.Label3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(232, 8)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(326, 16)
        Me.Label3.TabIndex = 5
        Me.Label3.Text = "Which Client"
        '
        'Label4
        '
        Me.Label4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.Location = New System.Drawing.Point(0, 8)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(136, 16)
        Me.Label4.TabIndex = 1
        Me.Label4.Text = "Who Generated"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'chkApbPageGenerateDateAll
        '
        Me.chkApbPageGenerateDateAll.Location = New System.Drawing.Point(140, 80)
        Me.chkApbPageGenerateDateAll.Name = "chkApbPageGenerateDateAll"
        Me.chkApbPageGenerateDateAll.Size = New System.Drawing.Size(64, 14)
        Me.chkApbPageGenerateDateAll.TabIndex = 19
        Me.chkApbPageGenerateDateAll.Text = "All Date"
        '
        'lnkApbPageDeselectHighlight
        '
        Me.lnkApbPageDeselectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbPageDeselectHighlight.Image = CType(resources.GetObject("lnkApbPageDeselectHighlight.Image"), System.Drawing.Image)
        Me.lnkApbPageDeselectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbPageDeselectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbPageDeselectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkApbPageDeselectHighlight.Location = New System.Drawing.Point(288, 568)
        Me.lnkApbPageDeselectHighlight.Name = "lnkApbPageDeselectHighlight"
        Me.lnkApbPageDeselectHighlight.Size = New System.Drawing.Size(120, 16)
        Me.lnkApbPageDeselectHighlight.TabIndex = 12
        Me.lnkApbPageDeselectHighlight.TabStop = True
        Me.lnkApbPageDeselectHighlight.Text = "Deselect Highlights"
        Me.lnkApbPageDeselectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbPageDeselectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbPageSelectHighlight
        '
        Me.lnkApbPageSelectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbPageSelectHighlight.Image = CType(resources.GetObject("lnkApbPageSelectHighlight.Image"), System.Drawing.Image)
        Me.lnkApbPageSelectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbPageSelectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbPageSelectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkApbPageSelectHighlight.Location = New System.Drawing.Point(176, 568)
        Me.lnkApbPageSelectHighlight.Name = "lnkApbPageSelectHighlight"
        Me.lnkApbPageSelectHighlight.Size = New System.Drawing.Size(104, 16)
        Me.lnkApbPageSelectHighlight.TabIndex = 11
        Me.lnkApbPageSelectHighlight.TabStop = True
        Me.lnkApbPageSelectHighlight.Text = "Select Highlights"
        Me.lnkApbPageSelectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbPageSelectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbPageDeselectAll
        '
        Me.lnkApbPageDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbPageDeselectAll.Image = CType(resources.GetObject("lnkApbPageDeselectAll.Image"), System.Drawing.Image)
        Me.lnkApbPageDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbPageDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbPageDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkApbPageDeselectAll.Location = New System.Drawing.Point(88, 568)
        Me.lnkApbPageDeselectAll.Name = "lnkApbPageDeselectAll"
        Me.lnkApbPageDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkApbPageDeselectAll.TabIndex = 10
        Me.lnkApbPageDeselectAll.TabStop = True
        Me.lnkApbPageDeselectAll.Text = "Deselect All"
        Me.lnkApbPageDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbPageDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkApbPageSelectAll
        '
        Me.lnkApbPageSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkApbPageSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkApbPageSelectAll.Image = CType(resources.GetObject("lnkApbPageSelectAll.Image"), System.Drawing.Image)
        Me.lnkApbPageSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkApbPageSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkApbPageSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkApbPageSelectAll.Location = New System.Drawing.Point(16, 568)
        Me.lnkApbPageSelectAll.Name = "lnkApbPageSelectAll"
        Me.lnkApbPageSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkApbPageSelectAll.TabIndex = 9
        Me.lnkApbPageSelectAll.TabStop = True
        Me.lnkApbPageSelectAll.Text = "Select All"
        Me.lnkApbPageSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkApbPageSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lvwApbPageApbList
        '
        Me.lvwApbPageApbList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwApbPageApbList.CheckBoxes = True
        Me.lvwApbPageApbList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ApID, Me.ApDescription, Me.DocumentName, Me.DateRangeBegin, Me.DateRangeEnd, Me.DateGenerated, Me.JobID})
        Me.lvwApbPageApbList.FullRowSelect = True
        Me.lvwApbPageApbList.Location = New System.Drawing.Point(16, 168)
        Me.lvwApbPageApbList.Name = "lvwApbPageApbList"
        Me.lvwApbPageApbList.Size = New System.Drawing.Size(681, 392)
        Me.lvwApbPageApbList.SmallImageList = Me.imlApbPageReport
        Me.lvwApbPageApbList.TabIndex = 8
        Me.lvwApbPageApbList.View = System.Windows.Forms.View.Details
        '
        'ApID
        '
        Me.ApID.Text = "AP ID"
        Me.ApID.Width = 145
        '
        'ApDescription
        '
        Me.ApDescription.Text = "AP Description"
        Me.ApDescription.Width = 100
        '
        'DocumentName
        '
        Me.DocumentName.Text = "Document Name"
        Me.DocumentName.Width = 100
        '
        'DateRangeBegin
        '
        Me.DateRangeBegin.Text = "Begin"
        '
        'DateRangeEnd
        '
        Me.DateRangeEnd.Text = "End"
        '
        'DateGenerated
        '
        Me.DateGenerated.Text = "Generated On"
        Me.DateGenerated.Width = 99
        '
        'JobID
        '
        Me.JobID.Text = "Job ID"
        Me.JobID.Width = 62
        '
        'imlApbPageReport
        '
        Me.imlApbPageReport.ImageSize = New System.Drawing.Size(20, 16)
        Me.imlApbPageReport.ImageStream = CType(resources.GetObject("imlApbPageReport.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlApbPageReport.TransparentColor = System.Drawing.Color.Transparent
        '
        'Label11
        '
        Me.Label11.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label11.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.Location = New System.Drawing.Point(16, 8)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(681, 24)
        Me.Label11.TabIndex = 0
        Me.Label11.Text = "Which Action Plan reports do you want to post?"
        '
        'GroupBox2
        '
        Me.GroupBox2.BackColor = System.Drawing.SystemColors.InactiveBorder
        Me.GroupBox2.Controls.Add(Me.PictureBox2)
        Me.GroupBox2.Controls.Add(Me.btnApbPageResetFilter)
        Me.GroupBox2.Controls.Add(Me.btnApbPageFilterData)
        Me.GroupBox2.Location = New System.Drawing.Point(16, 120)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(560, 40)
        Me.GroupBox2.TabIndex = 7
        Me.GroupBox2.TabStop = False
        '
        'PictureBox2
        '
        Me.PictureBox2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PictureBox2.Image = CType(resources.GetObject("PictureBox2.Image"), System.Drawing.Image)
        Me.PictureBox2.Location = New System.Drawing.Point(463, 18)
        Me.PictureBox2.Name = "PictureBox2"
        Me.PictureBox2.Size = New System.Drawing.Size(88, 16)
        Me.PictureBox2.TabIndex = 1
        Me.PictureBox2.TabStop = False
        '
        'btnApbPageResetFilter
        '
        Me.btnApbPageResetFilter.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnApbPageResetFilter.Location = New System.Drawing.Point(90, 12)
        Me.btnApbPageResetFilter.Name = "btnApbPageResetFilter"
        Me.btnApbPageResetFilter.Size = New System.Drawing.Size(75, 20)
        Me.btnApbPageResetFilter.TabIndex = 1
        Me.btnApbPageResetFilter.Text = "Reset Filter"
        '
        'btnApbPageFilterData
        '
        Me.btnApbPageFilterData.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnApbPageFilterData.Location = New System.Drawing.Point(8, 12)
        Me.btnApbPageFilterData.Name = "btnApbPageFilterData"
        Me.btnApbPageFilterData.Size = New System.Drawing.Size(75, 20)
        Me.btnApbPageFilterData.TabIndex = 0
        Me.btnApbPageFilterData.Text = "Filter Data"
        '
        'tpgStepVerifyGroup
        '
        Me.tpgStepVerifyGroup.Controls.Add(Me.tabGroupPageGrouping)
        Me.tpgStepVerifyGroup.Controls.Add(Me.Label6)
        Me.tpgStepVerifyGroup.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepVerifyGroup.Name = "tpgStepVerifyGroup"
        Me.tpgStepVerifyGroup.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepVerifyGroup.TabIndex = 2
        Me.tpgStepVerifyGroup.Text = "Select Group"
        '
        'tabGroupPageGrouping
        '
        Me.tabGroupPageGrouping.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabGroupPageGrouping.Appearance = System.Windows.Forms.TabAppearance.FlatButtons
        Me.tabGroupPageGrouping.Controls.Add(Me.tpgGroupPageApb)
        Me.tabGroupPageGrouping.Controls.Add(Me.tpgGroupPageGroup)
        Me.tabGroupPageGrouping.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tabGroupPageGrouping.Location = New System.Drawing.Point(16, 56)
        Me.tabGroupPageGrouping.Name = "tabGroupPageGrouping"
        Me.tabGroupPageGrouping.SelectedIndex = 0
        Me.tabGroupPageGrouping.Size = New System.Drawing.Size(689, 528)
        Me.tabGroupPageGrouping.TabIndex = 1
        '
        'tpgGroupPageApb
        '
        Me.tpgGroupPageApb.Controls.Add(Me.Panel5)
        Me.tpgGroupPageApb.Controls.Add(Me.Splitter1)
        Me.tpgGroupPageApb.Controls.Add(Me.Panel2)
        Me.tpgGroupPageApb.Controls.Add(Me.Panel1)
        Me.tpgGroupPageApb.Location = New System.Drawing.Point(4, 27)
        Me.tpgGroupPageApb.Name = "tpgGroupPageApb"
        Me.tpgGroupPageApb.Size = New System.Drawing.Size(681, 497)
        Me.tpgGroupPageApb.TabIndex = 0
        Me.tpgGroupPageApb.Text = "Group by APB"
        '
        'Panel5
        '
        Me.Panel5.Controls.Add(Me.lvwGroupPageApb1)
        Me.Panel5.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel5.Location = New System.Drawing.Point(0, 0)
        Me.Panel5.Name = "Panel5"
        Me.Panel5.Size = New System.Drawing.Size(484, 457)
        Me.Panel5.TabIndex = 4
        '
        'lvwGroupPageApb1
        '
        Me.lvwGroupPageApb1.CheckBoxes = True
        Me.lvwGroupPageApb1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader9, Me.ColumnHeader10})
        Me.lvwGroupPageApb1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwGroupPageApb1.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwGroupPageApb1.FullRowSelect = True
        Me.lvwGroupPageApb1.Location = New System.Drawing.Point(0, 0)
        Me.lvwGroupPageApb1.Name = "lvwGroupPageApb1"
        Me.lvwGroupPageApb1.Size = New System.Drawing.Size(484, 457)
        Me.lvwGroupPageApb1.SmallImageList = Me.imlApbPageReport
        Me.lvwGroupPageApb1.TabIndex = 0
        Me.lvwGroupPageApb1.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "AP ID"
        Me.ColumnHeader1.Width = 145
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Document Name"
        Me.ColumnHeader2.Width = 150
        '
        'ColumnHeader9
        '
        Me.ColumnHeader9.Text = "Begin"
        '
        'ColumnHeader10
        '
        Me.ColumnHeader10.Text = "End"
        '
        'Splitter1
        '
        Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Right
        Me.Splitter1.Location = New System.Drawing.Point(484, 0)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(5, 457)
        Me.Splitter1.TabIndex = 0
        Me.Splitter1.TabStop = False
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.lvwGroupPageGroup1)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Right
        Me.Panel2.Location = New System.Drawing.Point(489, 0)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(192, 457)
        Me.Panel2.TabIndex = 2
        '
        'lvwGroupPageGroup1
        '
        Me.lvwGroupPageGroup1.CheckBoxes = True
        Me.lvwGroupPageGroup1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader3, Me.ColumnHeader4})
        Me.lvwGroupPageGroup1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwGroupPageGroup1.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwGroupPageGroup1.FullRowSelect = True
        Me.lvwGroupPageGroup1.Location = New System.Drawing.Point(0, 0)
        Me.lvwGroupPageGroup1.Name = "lvwGroupPageGroup1"
        Me.lvwGroupPageGroup1.Size = New System.Drawing.Size(192, 457)
        Me.lvwGroupPageGroup1.TabIndex = 0
        Me.lvwGroupPageGroup1.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Group ID"
        Me.ColumnHeader3.Width = 75
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "Group Name"
        Me.ColumnHeader4.Width = 100
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabGroupDeselectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabGroupSelectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabGroupDeselectAll)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabGroupSelectAll)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabApbDeselectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabApbSelectHighlighted)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabApbDeselectAll)
        Me.Panel1.Controls.Add(Me.lnkGroupPageApbTabApbSelectAll)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel1.Location = New System.Drawing.Point(0, 457)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(681, 40)
        Me.Panel1.TabIndex = 1
        '
        'lnkGroupPageApbTabGroupDeselectHighlighted
        '
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Image = CType(resources.GetObject("lnkGroupPageApbTabGroupDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Location = New System.Drawing.Point(560, 24)
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Name = "lnkGroupPageApbTabGroupDeselectHighlighted"
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.TabIndex = 7
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.TabStop = True
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabGroupDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabGroupSelectHighlighted
        '
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Image = CType(resources.GetObject("lnkGroupPageApbTabGroupSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabGroupSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabGroupSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabGroupSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Location = New System.Drawing.Point(560, 4)
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Name = "lnkGroupPageApbTabGroupSelectHighlighted"
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkGroupPageApbTabGroupSelectHighlighted.TabIndex = 5
        Me.lnkGroupPageApbTabGroupSelectHighlighted.TabStop = True
        Me.lnkGroupPageApbTabGroupSelectHighlighted.Text = "Select Highlighted"
        Me.lnkGroupPageApbTabGroupSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabGroupSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabGroupDeselectAll
        '
        Me.lnkGroupPageApbTabGroupDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabGroupDeselectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabGroupDeselectAll.Image = CType(resources.GetObject("lnkGroupPageApbTabGroupDeselectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabGroupDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabGroupDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabGroupDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabGroupDeselectAll.Location = New System.Drawing.Point(472, 24)
        Me.lnkGroupPageApbTabGroupDeselectAll.Name = "lnkGroupPageApbTabGroupDeselectAll"
        Me.lnkGroupPageApbTabGroupDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkGroupPageApbTabGroupDeselectAll.TabIndex = 6
        Me.lnkGroupPageApbTabGroupDeselectAll.TabStop = True
        Me.lnkGroupPageApbTabGroupDeselectAll.Text = "Deselect All"
        Me.lnkGroupPageApbTabGroupDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabGroupDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabGroupSelectAll
        '
        Me.lnkGroupPageApbTabGroupSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabGroupSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkGroupPageApbTabGroupSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabGroupSelectAll.Image = CType(resources.GetObject("lnkGroupPageApbTabGroupSelectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabGroupSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabGroupSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabGroupSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabGroupSelectAll.Location = New System.Drawing.Point(472, 4)
        Me.lnkGroupPageApbTabGroupSelectAll.Name = "lnkGroupPageApbTabGroupSelectAll"
        Me.lnkGroupPageApbTabGroupSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkGroupPageApbTabGroupSelectAll.TabIndex = 4
        Me.lnkGroupPageApbTabGroupSelectAll.TabStop = True
        Me.lnkGroupPageApbTabGroupSelectAll.Text = "Select All"
        Me.lnkGroupPageApbTabGroupSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabGroupSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabApbDeselectHighlighted
        '
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Image = CType(resources.GetObject("lnkGroupPageApbTabApbDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabApbDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabApbDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabApbDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Location = New System.Drawing.Point(88, 24)
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Name = "lnkGroupPageApbTabApbDeselectHighlighted"
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkGroupPageApbTabApbDeselectHighlighted.TabIndex = 3
        Me.lnkGroupPageApbTabApbDeselectHighlighted.TabStop = True
        Me.lnkGroupPageApbTabApbDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkGroupPageApbTabApbDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabApbDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabApbSelectHighlighted
        '
        Me.lnkGroupPageApbTabApbSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabApbSelectHighlighted.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabApbSelectHighlighted.Image = CType(resources.GetObject("lnkGroupPageApbTabApbSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabApbSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabApbSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabApbSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabApbSelectHighlighted.Location = New System.Drawing.Point(88, 4)
        Me.lnkGroupPageApbTabApbSelectHighlighted.Name = "lnkGroupPageApbTabApbSelectHighlighted"
        Me.lnkGroupPageApbTabApbSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkGroupPageApbTabApbSelectHighlighted.TabIndex = 1
        Me.lnkGroupPageApbTabApbSelectHighlighted.TabStop = True
        Me.lnkGroupPageApbTabApbSelectHighlighted.Text = "Select Highlighted"
        Me.lnkGroupPageApbTabApbSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabApbSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabApbDeselectAll
        '
        Me.lnkGroupPageApbTabApbDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabApbDeselectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabApbDeselectAll.Image = CType(resources.GetObject("lnkGroupPageApbTabApbDeselectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabApbDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabApbDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabApbDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabApbDeselectAll.Location = New System.Drawing.Point(0, 24)
        Me.lnkGroupPageApbTabApbDeselectAll.Name = "lnkGroupPageApbTabApbDeselectAll"
        Me.lnkGroupPageApbTabApbDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkGroupPageApbTabApbDeselectAll.TabIndex = 2
        Me.lnkGroupPageApbTabApbDeselectAll.TabStop = True
        Me.lnkGroupPageApbTabApbDeselectAll.Text = "Deselect All"
        Me.lnkGroupPageApbTabApbDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabApbDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageApbTabApbSelectAll
        '
        Me.lnkGroupPageApbTabApbSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageApbTabApbSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkGroupPageApbTabApbSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkGroupPageApbTabApbSelectAll.Image = CType(resources.GetObject("lnkGroupPageApbTabApbSelectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageApbTabApbSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageApbTabApbSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageApbTabApbSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageApbTabApbSelectAll.Location = New System.Drawing.Point(0, 4)
        Me.lnkGroupPageApbTabApbSelectAll.Name = "lnkGroupPageApbTabApbSelectAll"
        Me.lnkGroupPageApbTabApbSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkGroupPageApbTabApbSelectAll.TabIndex = 0
        Me.lnkGroupPageApbTabApbSelectAll.TabStop = True
        Me.lnkGroupPageApbTabApbSelectAll.Text = "Select All"
        Me.lnkGroupPageApbTabApbSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageApbTabApbSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'tpgGroupPageGroup
        '
        Me.tpgGroupPageGroup.Controls.Add(Me.Panel6)
        Me.tpgGroupPageGroup.Controls.Add(Me.Splitter2)
        Me.tpgGroupPageGroup.Controls.Add(Me.Panel4)
        Me.tpgGroupPageGroup.Controls.Add(Me.Panel3)
        Me.tpgGroupPageGroup.Location = New System.Drawing.Point(4, 27)
        Me.tpgGroupPageGroup.Name = "tpgGroupPageGroup"
        Me.tpgGroupPageGroup.Size = New System.Drawing.Size(681, 497)
        Me.tpgGroupPageGroup.TabIndex = 1
        Me.tpgGroupPageGroup.Text = "Group by User Group"
        '
        'Panel6
        '
        Me.Panel6.Controls.Add(Me.lvwGroupPageApb2)
        Me.Panel6.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel6.Location = New System.Drawing.Point(197, 0)
        Me.Panel6.Name = "Panel6"
        Me.Panel6.Size = New System.Drawing.Size(484, 457)
        Me.Panel6.TabIndex = 25
        '
        'lvwGroupPageApb2
        '
        Me.lvwGroupPageApb2.CheckBoxes = True
        Me.lvwGroupPageApb2.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader7, Me.ColumnHeader8, Me.ColumnHeader11, Me.ColumnHeader12})
        Me.lvwGroupPageApb2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwGroupPageApb2.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwGroupPageApb2.FullRowSelect = True
        Me.lvwGroupPageApb2.Location = New System.Drawing.Point(0, 0)
        Me.lvwGroupPageApb2.Name = "lvwGroupPageApb2"
        Me.lvwGroupPageApb2.Size = New System.Drawing.Size(484, 457)
        Me.lvwGroupPageApb2.SmallImageList = Me.imlApbPageReport
        Me.lvwGroupPageApb2.TabIndex = 0
        Me.lvwGroupPageApb2.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader7
        '
        Me.ColumnHeader7.Text = "AP ID"
        Me.ColumnHeader7.Width = 145
        '
        'ColumnHeader8
        '
        Me.ColumnHeader8.Text = "Document Name"
        Me.ColumnHeader8.Width = 150
        '
        'ColumnHeader11
        '
        Me.ColumnHeader11.Text = "Begin"
        '
        'ColumnHeader12
        '
        Me.ColumnHeader12.Text = "End"
        '
        'Splitter2
        '
        Me.Splitter2.Location = New System.Drawing.Point(192, 0)
        Me.Splitter2.Name = "Splitter2"
        Me.Splitter2.Size = New System.Drawing.Size(5, 457)
        Me.Splitter2.TabIndex = 1
        Me.Splitter2.TabStop = False
        '
        'Panel4
        '
        Me.Panel4.Controls.Add(Me.lvwGroupPageGroup2)
        Me.Panel4.Dock = System.Windows.Forms.DockStyle.Left
        Me.Panel4.Location = New System.Drawing.Point(0, 0)
        Me.Panel4.Name = "Panel4"
        Me.Panel4.Size = New System.Drawing.Size(192, 457)
        Me.Panel4.TabIndex = 23
        '
        'lvwGroupPageGroup2
        '
        Me.lvwGroupPageGroup2.CheckBoxes = True
        Me.lvwGroupPageGroup2.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader5, Me.ColumnHeader6})
        Me.lvwGroupPageGroup2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwGroupPageGroup2.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvwGroupPageGroup2.FullRowSelect = True
        Me.lvwGroupPageGroup2.Location = New System.Drawing.Point(0, 0)
        Me.lvwGroupPageGroup2.Name = "lvwGroupPageGroup2"
        Me.lvwGroupPageGroup2.Size = New System.Drawing.Size(192, 457)
        Me.lvwGroupPageGroup2.TabIndex = 0
        Me.lvwGroupPageGroup2.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "Group ID"
        Me.ColumnHeader5.Width = 75
        '
        'ColumnHeader6
        '
        Me.ColumnHeader6.Text = "Group Name"
        Me.ColumnHeader6.Width = 100
        '
        'Panel3
        '
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabApbDeselectHighlighted)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabApbSelectHighlighted)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabApbDeselectAll)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabApbSelectAll)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabGroupDeselectHighlighted)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabGroupSelectHighlighted)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabGroupDeselectAll)
        Me.Panel3.Controls.Add(Me.lnkGroupPageGroupTabGroupSelectAll)
        Me.Panel3.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Panel3.Location = New System.Drawing.Point(0, 457)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(681, 40)
        Me.Panel3.TabIndex = 2
        '
        'lnkGroupPageGroupTabApbDeselectHighlighted
        '
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.Image = CType(resources.GetObject("lnkGroupPageGroupTabApbDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.Location = New System.Drawing.Point(560, 24)
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.Name = "lnkGroupPageGroupTabApbDeselectHighlighted"
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.TabIndex = 7
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.TabStop = True
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabApbDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabApbSelectHighlighted
        '
        Me.lnkGroupPageGroupTabApbSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabApbSelectHighlighted.Image = CType(resources.GetObject("lnkGroupPageGroupTabApbSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabApbSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabApbSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabApbSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabApbSelectHighlighted.Location = New System.Drawing.Point(560, 4)
        Me.lnkGroupPageGroupTabApbSelectHighlighted.Name = "lnkGroupPageGroupTabApbSelectHighlighted"
        Me.lnkGroupPageGroupTabApbSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkGroupPageGroupTabApbSelectHighlighted.TabIndex = 5
        Me.lnkGroupPageGroupTabApbSelectHighlighted.TabStop = True
        Me.lnkGroupPageGroupTabApbSelectHighlighted.Text = "Select Highlighted"
        Me.lnkGroupPageGroupTabApbSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabApbSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabApbDeselectAll
        '
        Me.lnkGroupPageGroupTabApbDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabApbDeselectAll.Image = CType(resources.GetObject("lnkGroupPageGroupTabApbDeselectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabApbDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabApbDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabApbDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabApbDeselectAll.Location = New System.Drawing.Point(472, 24)
        Me.lnkGroupPageGroupTabApbDeselectAll.Name = "lnkGroupPageGroupTabApbDeselectAll"
        Me.lnkGroupPageGroupTabApbDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkGroupPageGroupTabApbDeselectAll.TabIndex = 6
        Me.lnkGroupPageGroupTabApbDeselectAll.TabStop = True
        Me.lnkGroupPageGroupTabApbDeselectAll.Text = "Deselect All"
        Me.lnkGroupPageGroupTabApbDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabApbDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabApbSelectAll
        '
        Me.lnkGroupPageGroupTabApbSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabApbSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkGroupPageGroupTabApbSelectAll.Image = CType(resources.GetObject("lnkGroupPageGroupTabApbSelectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabApbSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabApbSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabApbSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabApbSelectAll.Location = New System.Drawing.Point(472, 4)
        Me.lnkGroupPageGroupTabApbSelectAll.Name = "lnkGroupPageGroupTabApbSelectAll"
        Me.lnkGroupPageGroupTabApbSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkGroupPageGroupTabApbSelectAll.TabIndex = 4
        Me.lnkGroupPageGroupTabApbSelectAll.TabStop = True
        Me.lnkGroupPageGroupTabApbSelectAll.Text = "Select All"
        Me.lnkGroupPageGroupTabApbSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabApbSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabGroupDeselectHighlighted
        '
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.Image = CType(resources.GetObject("lnkGroupPageGroupTabGroupDeselectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.Location = New System.Drawing.Point(88, 24)
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.Name = "lnkGroupPageGroupTabGroupDeselectHighlighted"
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.Size = New System.Drawing.Size(120, 16)
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.TabIndex = 3
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.TabStop = True
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.Text = "Deselect Highlighted"
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabGroupDeselectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabGroupSelectHighlighted
        '
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.Image = CType(resources.GetObject("lnkGroupPageGroupTabGroupSelectHighlighted.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.Location = New System.Drawing.Point(88, 4)
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.Name = "lnkGroupPageGroupTabGroupSelectHighlighted"
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.Size = New System.Drawing.Size(112, 16)
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.TabIndex = 1
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.TabStop = True
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.Text = "Select Highlighted"
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabGroupSelectHighlighted.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabGroupDeselectAll
        '
        Me.lnkGroupPageGroupTabGroupDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabGroupDeselectAll.Image = CType(resources.GetObject("lnkGroupPageGroupTabGroupDeselectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabGroupDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabGroupDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabGroupDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabGroupDeselectAll.Location = New System.Drawing.Point(0, 24)
        Me.lnkGroupPageGroupTabGroupDeselectAll.Name = "lnkGroupPageGroupTabGroupDeselectAll"
        Me.lnkGroupPageGroupTabGroupDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkGroupPageGroupTabGroupDeselectAll.TabIndex = 2
        Me.lnkGroupPageGroupTabGroupDeselectAll.TabStop = True
        Me.lnkGroupPageGroupTabGroupDeselectAll.Text = "Deselect All"
        Me.lnkGroupPageGroupTabGroupDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabGroupDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkGroupPageGroupTabGroupSelectAll
        '
        Me.lnkGroupPageGroupTabGroupSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkGroupPageGroupTabGroupSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkGroupPageGroupTabGroupSelectAll.Image = CType(resources.GetObject("lnkGroupPageGroupTabGroupSelectAll.Image"), System.Drawing.Image)
        Me.lnkGroupPageGroupTabGroupSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkGroupPageGroupTabGroupSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkGroupPageGroupTabGroupSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkGroupPageGroupTabGroupSelectAll.Location = New System.Drawing.Point(0, 4)
        Me.lnkGroupPageGroupTabGroupSelectAll.Name = "lnkGroupPageGroupTabGroupSelectAll"
        Me.lnkGroupPageGroupTabGroupSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkGroupPageGroupTabGroupSelectAll.TabIndex = 0
        Me.lnkGroupPageGroupTabGroupSelectAll.TabStop = True
        Me.lnkGroupPageGroupTabGroupSelectAll.Text = "Select All"
        Me.lnkGroupPageGroupTabGroupSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkGroupPageGroupTabGroupSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'Label6
        '
        Me.Label6.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label6.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.Location = New System.Drawing.Point(16, 16)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(681, 24)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Which groups do you want to post?"
        '
        'tpgStepDuplicateCheck
        '
        Me.tpgStepDuplicateCheck.Controls.Add(Me.lnkDupCheckPageRefresh)
        Me.tpgStepDuplicateCheck.Controls.Add(Me.pnlDupCheckPageBack)
        Me.tpgStepDuplicateCheck.Controls.Add(Me.lblDupCheckPageTitle)
        Me.tpgStepDuplicateCheck.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepDuplicateCheck.Name = "tpgStepDuplicateCheck"
        Me.tpgStepDuplicateCheck.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepDuplicateCheck.TabIndex = 3
        Me.tpgStepDuplicateCheck.Text = "Duplicate Check"
        '
        'lnkDupCheckPageRefresh
        '
        Me.lnkDupCheckPageRefresh.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkDupCheckPageRefresh.Image = CType(resources.GetObject("lnkDupCheckPageRefresh.Image"), System.Drawing.Image)
        Me.lnkDupCheckPageRefresh.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkDupCheckPageRefresh.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkDupCheckPageRefresh.LinkColor = System.Drawing.Color.Black
        Me.lnkDupCheckPageRefresh.Location = New System.Drawing.Point(16, 568)
        Me.lnkDupCheckPageRefresh.Name = "lnkDupCheckPageRefresh"
        Me.lnkDupCheckPageRefresh.Size = New System.Drawing.Size(64, 16)
        Me.lnkDupCheckPageRefresh.TabIndex = 2
        Me.lnkDupCheckPageRefresh.TabStop = True
        Me.lnkDupCheckPageRefresh.Text = "Refresh"
        Me.lnkDupCheckPageRefresh.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkDupCheckPageRefresh.VisitedLinkColor = System.Drawing.Color.Black
        '
        'pnlDupCheckPageBack
        '
        Me.pnlDupCheckPageBack.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlDupCheckPageBack.Controls.Add(Me.pnlDupCheckPageApbBack)
        Me.pnlDupCheckPageBack.Controls.Add(Me.Splitter4)
        Me.pnlDupCheckPageBack.Controls.Add(Me.lvwDupCheckPagePath)
        Me.pnlDupCheckPageBack.Location = New System.Drawing.Point(16, 72)
        Me.pnlDupCheckPageBack.Name = "pnlDupCheckPageBack"
        Me.pnlDupCheckPageBack.Size = New System.Drawing.Size(681, 488)
        Me.pnlDupCheckPageBack.TabIndex = 12
        '
        'pnlDupCheckPageApbBack
        '
        Me.pnlDupCheckPageApbBack.Controls.Add(Me.lvwDupCheckPageApb)
        Me.pnlDupCheckPageApbBack.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlDupCheckPageApbBack.Location = New System.Drawing.Point(0, 272)
        Me.pnlDupCheckPageApbBack.Name = "pnlDupCheckPageApbBack"
        Me.pnlDupCheckPageApbBack.Size = New System.Drawing.Size(681, 216)
        Me.pnlDupCheckPageApbBack.TabIndex = 9
        '
        'lvwDupCheckPageApb
        '
        Me.lvwDupCheckPageApb.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader14, Me.ColumnHeader15, Me.ColumnHeader21, Me.ColumnHeader16, Me.ColumnHeader17, Me.ColumnHeader20})
        Me.lvwDupCheckPageApb.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwDupCheckPageApb.Location = New System.Drawing.Point(0, 0)
        Me.lvwDupCheckPageApb.MultiSelect = False
        Me.lvwDupCheckPageApb.Name = "lvwDupCheckPageApb"
        Me.lvwDupCheckPageApb.Size = New System.Drawing.Size(681, 216)
        Me.lvwDupCheckPageApb.SmallImageList = Me.imlApbPageReport
        Me.lvwDupCheckPageApb.TabIndex = 0
        Me.lvwDupCheckPageApb.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader14
        '
        Me.ColumnHeader14.Text = "AP ID"
        Me.ColumnHeader14.Width = 120
        '
        'ColumnHeader15
        '
        Me.ColumnHeader15.Text = "Document Name"
        Me.ColumnHeader15.Width = 150
        '
        'ColumnHeader21
        '
        Me.ColumnHeader21.Text = "Group Name"
        Me.ColumnHeader21.Width = 120
        '
        'ColumnHeader16
        '
        Me.ColumnHeader16.Text = "Begin"
        '
        'ColumnHeader17
        '
        Me.ColumnHeader17.Text = "End"
        '
        'ColumnHeader20
        '
        Me.ColumnHeader20.Text = "Job ID"
        Me.ColumnHeader20.Width = 50
        '
        'Splitter4
        '
        Me.Splitter4.Dock = System.Windows.Forms.DockStyle.Top
        Me.Splitter4.Location = New System.Drawing.Point(0, 264)
        Me.Splitter4.Name = "Splitter4"
        Me.Splitter4.Size = New System.Drawing.Size(681, 8)
        Me.Splitter4.TabIndex = 1
        Me.Splitter4.TabStop = False
        '
        'lvwDupCheckPagePath
        '
        Me.lvwDupCheckPagePath.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader13})
        Me.lvwDupCheckPagePath.Dock = System.Windows.Forms.DockStyle.Top
        Me.lvwDupCheckPagePath.Location = New System.Drawing.Point(0, 0)
        Me.lvwDupCheckPagePath.Name = "lvwDupCheckPagePath"
        Me.lvwDupCheckPagePath.Size = New System.Drawing.Size(681, 264)
        Me.lvwDupCheckPagePath.SmallImageList = Me.imlApbPageReport
        Me.lvwDupCheckPagePath.TabIndex = 0
        Me.lvwDupCheckPagePath.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader13
        '
        Me.ColumnHeader13.Text = "Document Path"
        Me.ColumnHeader13.Width = 300
        '
        'lblDupCheckPageTitle
        '
        Me.lblDupCheckPageTitle.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblDupCheckPageTitle.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDupCheckPageTitle.Location = New System.Drawing.Point(16, 16)
        Me.lblDupCheckPageTitle.Name = "lblDupCheckPageTitle"
        Me.lblDupCheckPageTitle.Size = New System.Drawing.Size(681, 48)
        Me.lblDupCheckPageTitle.TabIndex = 0
        Me.lblDupCheckPageTitle.Text = "Perform checks on duplicate AP reports"
        '
        'tpgStepRepostCheck
        '
        Me.tpgStepRepostCheck.Controls.Add(Me.PictureBox5)
        Me.tpgStepRepostCheck.Controls.Add(Me.lblRepostPageProgress)
        Me.tpgStepRepostCheck.Controls.Add(Me.pbrRepostPageProgress)
        Me.tpgStepRepostCheck.Controls.Add(Me.Label8)
        Me.tpgStepRepostCheck.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepRepostCheck.Name = "tpgStepRepostCheck"
        Me.tpgStepRepostCheck.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepRepostCheck.TabIndex = 6
        Me.tpgStepRepostCheck.Text = "Repost Check"
        '
        'PictureBox5
        '
        Me.PictureBox5.Image = CType(resources.GetObject("PictureBox5.Image"), System.Drawing.Image)
        Me.PictureBox5.Location = New System.Drawing.Point(24, 96)
        Me.PictureBox5.Name = "PictureBox5"
        Me.PictureBox5.Size = New System.Drawing.Size(128, 128)
        Me.PictureBox5.TabIndex = 17
        Me.PictureBox5.TabStop = False
        '
        'lblRepostPageProgress
        '
        Me.lblRepostPageProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRepostPageProgress.Location = New System.Drawing.Point(176, 176)
        Me.lblRepostPageProgress.Name = "lblRepostPageProgress"
        Me.lblRepostPageProgress.Size = New System.Drawing.Size(512, 23)
        Me.lblRepostPageProgress.TabIndex = 1
        Me.lblRepostPageProgress.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pbrRepostPageProgress
        '
        Me.pbrRepostPageProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pbrRepostPageProgress.Location = New System.Drawing.Point(176, 200)
        Me.pbrRepostPageProgress.Name = "pbrRepostPageProgress"
        Me.pbrRepostPageProgress.Size = New System.Drawing.Size(512, 23)
        Me.pbrRepostPageProgress.TabIndex = 2
        '
        'Label8
        '
        Me.Label8.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label8.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.Location = New System.Drawing.Point(16, 16)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(681, 23)
        Me.Label8.TabIndex = 0
        Me.Label8.Text = "Performing checks on APB report reposting"
        '
        'tpgStepSummary
        '
        Me.tpgStepSummary.Controls.Add(Me.Label16)
        Me.tpgStepSummary.Controls.Add(Me.Label12)
        Me.tpgStepSummary.Controls.Add(Me.lblSummaryPageGroupCount)
        Me.tpgStepSummary.Controls.Add(Me.lblSummaryPageApbCount)
        Me.tpgStepSummary.Controls.Add(Me.btnSummaryPageExport)
        Me.tpgStepSummary.Controls.Add(Me.lvwSummaryPageList)
        Me.tpgStepSummary.Controls.Add(Me.Label14)
        Me.tpgStepSummary.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepSummary.Name = "tpgStepSummary"
        Me.tpgStepSummary.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepSummary.TabIndex = 4
        Me.tpgStepSummary.Text = "Summary"
        '
        'Label16
        '
        Me.Label16.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label16.Location = New System.Drawing.Point(472, 563)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(96, 16)
        Me.Label16.TabIndex = 18
        Me.Label16.Text = "posted AP reports"
        Me.Label16.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label12
        '
        Me.Label12.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label12.Location = New System.Drawing.Point(608, 563)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(88, 16)
        Me.Label12.TabIndex = 17
        Me.Label12.Text = "groups posted to"
        Me.Label12.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblSummaryPageGroupCount
        '
        Me.lblSummaryPageGroupCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblSummaryPageGroupCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSummaryPageGroupCount.Location = New System.Drawing.Point(576, 563)
        Me.lblSummaryPageGroupCount.Name = "lblSummaryPageGroupCount"
        Me.lblSummaryPageGroupCount.Size = New System.Drawing.Size(32, 16)
        Me.lblSummaryPageGroupCount.TabIndex = 16
        Me.lblSummaryPageGroupCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblSummaryPageApbCount
        '
        Me.lblSummaryPageApbCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblSummaryPageApbCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSummaryPageApbCount.Location = New System.Drawing.Point(432, 563)
        Me.lblSummaryPageApbCount.Name = "lblSummaryPageApbCount"
        Me.lblSummaryPageApbCount.Size = New System.Drawing.Size(32, 16)
        Me.lblSummaryPageApbCount.TabIndex = 15
        Me.lblSummaryPageApbCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'btnSummaryPageExport
        '
        Me.btnSummaryPageExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnSummaryPageExport.Location = New System.Drawing.Point(16, 560)
        Me.btnSummaryPageExport.Name = "btnSummaryPageExport"
        Me.btnSummaryPageExport.Size = New System.Drawing.Size(96, 23)
        Me.btnSummaryPageExport.TabIndex = 3
        Me.btnSummaryPageExport.Text = "Export To Excel"
        '
        'lvwSummaryPageList
        '
        Me.lvwSummaryPageList.AlternateColor1 = System.Drawing.Color.White
        Me.lvwSummaryPageList.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwSummaryPageList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwSummaryPageList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdSummaryPageApIcon, Me.chdSummaryPageApID, Me.chdSummaryPageDocName, Me.chdSummaryPageGroupName, Me.chdSummaryPagePathIcon, Me.chdSummaryPagePath})
        Me.lvwSummaryPageList.FullRowSelect = True
        Me.lvwSummaryPageList.GridLines = True
        Me.lvwSummaryPageList.Location = New System.Drawing.Point(16, 48)
        Me.lvwSummaryPageList.Name = "lvwSummaryPageList"
        Me.lvwSummaryPageList.Size = New System.Drawing.Size(680, 504)
        Me.lvwSummaryPageList.SmallImageList = Me.imlApbPageReport
        Me.lvwSummaryPageList.SortColumn = -1
        Me.lvwSummaryPageList.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwSummaryPageList.TabIndex = 2
        Me.lvwSummaryPageList.View = System.Windows.Forms.View.Details
        '
        'chdSummaryPageApIcon
        '
        Me.chdSummaryPageApIcon.Text = ""
        Me.chdSummaryPageApIcon.Width = 25
        '
        'chdSummaryPageApID
        '
        Me.chdSummaryPageApID.Text = "AP ID"
        Me.chdSummaryPageApID.Width = 110
        '
        'chdSummaryPageDocName
        '
        Me.chdSummaryPageDocName.Text = "Document Name"
        Me.chdSummaryPageDocName.Width = 150
        '
        'chdSummaryPageGroupName
        '
        Me.chdSummaryPageGroupName.Text = "Group Name"
        Me.chdSummaryPageGroupName.Width = 120
        '
        'chdSummaryPagePathIcon
        '
        Me.chdSummaryPagePathIcon.Text = ""
        Me.chdSummaryPagePathIcon.Width = 21
        '
        'chdSummaryPagePath
        '
        Me.chdSummaryPagePath.Text = "Path"
        Me.chdSummaryPagePath.Width = 206
        '
        'Label14
        '
        Me.Label14.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label14.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label14.Location = New System.Drawing.Point(16, 16)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(681, 23)
        Me.Label14.TabIndex = 0
        Me.Label14.Text = "Summary of Action Plan reports to be posted"
        '
        'tpgStepPosting
        '
        Me.tpgStepPosting.Controls.Add(Me.lblPostPageMessage)
        Me.tpgStepPosting.Controls.Add(Me.Label15)
        Me.tpgStepPosting.Controls.Add(Me.PictureBox4)
        Me.tpgStepPosting.Controls.Add(Me.lblPostPageProgress)
        Me.tpgStepPosting.Controls.Add(Me.pbrPostPageProgress)
        Me.tpgStepPosting.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepPosting.Name = "tpgStepPosting"
        Me.tpgStepPosting.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepPosting.TabIndex = 7
        Me.tpgStepPosting.Text = "Posting"
        '
        'lblPostPageMessage
        '
        Me.lblPostPageMessage.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblPostPageMessage.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblPostPageMessage.Location = New System.Drawing.Point(144, 168)
        Me.lblPostPageMessage.Name = "lblPostPageMessage"
        Me.lblPostPageMessage.Size = New System.Drawing.Size(544, 144)
        Me.lblPostPageMessage.TabIndex = 3
        '
        'Label15
        '
        Me.Label15.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label15.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label15.Location = New System.Drawing.Point(16, 16)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(681, 23)
        Me.Label15.TabIndex = 0
        Me.Label15.Text = "Posting Action Plan reports ..."
        '
        'PictureBox4
        '
        Me.PictureBox4.Image = CType(resources.GetObject("PictureBox4.Image"), System.Drawing.Image)
        Me.PictureBox4.Location = New System.Drawing.Point(24, 96)
        Me.PictureBox4.Name = "PictureBox4"
        Me.PictureBox4.Size = New System.Drawing.Size(104, 96)
        Me.PictureBox4.TabIndex = 16
        Me.PictureBox4.TabStop = False
        '
        'lblPostPageProgress
        '
        Me.lblPostPageProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblPostPageProgress.Location = New System.Drawing.Point(144, 104)
        Me.lblPostPageProgress.Name = "lblPostPageProgress"
        Me.lblPostPageProgress.Size = New System.Drawing.Size(544, 16)
        Me.lblPostPageProgress.TabIndex = 1
        Me.lblPostPageProgress.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pbrPostPageProgress
        '
        Me.pbrPostPageProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pbrPostPageProgress.Location = New System.Drawing.Point(144, 120)
        Me.pbrPostPageProgress.Maximum = 3
        Me.pbrPostPageProgress.Name = "pbrPostPageProgress"
        Me.pbrPostPageProgress.Size = New System.Drawing.Size(544, 23)
        Me.pbrPostPageProgress.TabIndex = 2
        '
        'tpgStepFinish
        '
        Me.tpgStepFinish.Controls.Add(Me.PictureBox8)
        Me.tpgStepFinish.Controls.Add(Me.PictureBox7)
        Me.tpgStepFinish.Controls.Add(Me.Label9)
        Me.tpgStepFinish.Controls.Add(Me.PictureBox3)
        Me.tpgStepFinish.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepFinish.Name = "tpgStepFinish"
        Me.tpgStepFinish.Size = New System.Drawing.Size(2017, 590)
        Me.tpgStepFinish.TabIndex = 5
        Me.tpgStepFinish.Text = "Finish"
        '
        'PictureBox8
        '
        Me.PictureBox8.Image = CType(resources.GetObject("PictureBox8.Image"), System.Drawing.Image)
        Me.PictureBox8.Location = New System.Drawing.Point(148, 170)
        Me.PictureBox8.Name = "PictureBox8"
        Me.PictureBox8.Size = New System.Drawing.Size(288, 40)
        Me.PictureBox8.TabIndex = 4
        Me.PictureBox8.TabStop = False
        '
        'PictureBox7
        '
        Me.PictureBox7.Image = CType(resources.GetObject("PictureBox7.Image"), System.Drawing.Image)
        Me.PictureBox7.Location = New System.Drawing.Point(21, 24)
        Me.PictureBox7.Name = "PictureBox7"
        Me.PictureBox7.Size = New System.Drawing.Size(416, 32)
        Me.PictureBox7.TabIndex = 3
        Me.PictureBox7.TabStop = False
        '
        'Label9
        '
        Me.Label9.BackColor = System.Drawing.Color.White
        Me.Label9.Font = New System.Drawing.Font("Times New Roman", 9.818182!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.Location = New System.Drawing.Point(200, 216)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(232, 58)
        Me.Label9.TabIndex = 2
        Me.Label9.Text = "Use document manager to verify the posted documents"
        Me.Label9.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'PictureBox3
        '
        Me.PictureBox3.Image = CType(resources.GetObject("PictureBox3.Image"), System.Drawing.Image)
        Me.PictureBox3.Location = New System.Drawing.Point(88, 64)
        Me.PictureBox3.Name = "PictureBox3"
        Me.PictureBox3.Size = New System.Drawing.Size(352, 304)
        Me.PictureBox3.TabIndex = 0
        Me.PictureBox3.TabStop = False
        '
        'Splitter3
        '
        Me.Splitter3.Location = New System.Drawing.Point(144, 27)
        Me.Splitter3.MinSize = 8
        Me.Splitter3.Name = "Splitter3"
        Me.Splitter3.Size = New System.Drawing.Size(3, 620)
        Me.Splitter3.TabIndex = 42
        Me.Splitter3.TabStop = False
        '
        'pnlLeft
        '
        Me.pnlLeft.BackColor = System.Drawing.Color.Black
        Me.pnlLeft.Controls.Add(Me.lblStepPosting)
        Me.pnlLeft.Controls.Add(Me.pnlStepPosting)
        Me.pnlLeft.Controls.Add(Me.lblStepRepostCheck)
        Me.pnlLeft.Controls.Add(Me.pnlStepRepostCheck)
        Me.pnlLeft.Controls.Add(Me.lblStepPreview)
        Me.pnlLeft.Controls.Add(Me.pnlStepPreview)
        Me.pnlLeft.Controls.Add(Me.lblStepFinish)
        Me.pnlLeft.Controls.Add(Me.lblStepDuplicateCheck)
        Me.pnlLeft.Controls.Add(Me.lblStepVerifyGroup)
        Me.pnlLeft.Controls.Add(Me.lblStepSelectApb)
        Me.pnlLeft.Controls.Add(Me.lblStepStart)
        Me.pnlLeft.Controls.Add(Me.pnlStepFinish)
        Me.pnlLeft.Controls.Add(Me.pnlStepDuplicateCheck)
        Me.pnlLeft.Controls.Add(Me.pnlStepVerifyGroup)
        Me.pnlLeft.Controls.Add(Me.pnlStepSelectApb)
        Me.pnlLeft.Controls.Add(Me.pnlStepStart)
        Me.pnlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlLeft.Location = New System.Drawing.Point(1, 27)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Size = New System.Drawing.Size(143, 620)
        Me.pnlLeft.TabIndex = 41
        '
        'lblStepPosting
        '
        Me.lblStepPosting.ForeColor = System.Drawing.Color.White
        Me.lblStepPosting.Location = New System.Drawing.Point(48, 208)
        Me.lblStepPosting.Name = "lblStepPosting"
        Me.lblStepPosting.Size = New System.Drawing.Size(88, 16)
        Me.lblStepPosting.TabIndex = 41
        Me.lblStepPosting.Text = "Posting"
        Me.lblStepPosting.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepPosting
        '
        Me.pnlStepPosting.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepPosting.Location = New System.Drawing.Point(24, 208)
        Me.pnlStepPosting.Name = "pnlStepPosting"
        Me.pnlStepPosting.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepPosting.TabIndex = 40
        '
        'lblStepRepostCheck
        '
        Me.lblStepRepostCheck.ForeColor = System.Drawing.Color.White
        Me.lblStepRepostCheck.Location = New System.Drawing.Point(48, 144)
        Me.lblStepRepostCheck.Name = "lblStepRepostCheck"
        Me.lblStepRepostCheck.Size = New System.Drawing.Size(88, 16)
        Me.lblStepRepostCheck.TabIndex = 39
        Me.lblStepRepostCheck.Text = "Repost Check"
        Me.lblStepRepostCheck.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepRepostCheck
        '
        Me.pnlStepRepostCheck.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepRepostCheck.Location = New System.Drawing.Point(24, 144)
        Me.pnlStepRepostCheck.Name = "pnlStepRepostCheck"
        Me.pnlStepRepostCheck.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepRepostCheck.TabIndex = 38
        '
        'lblStepPreview
        '
        Me.lblStepPreview.ForeColor = System.Drawing.Color.White
        Me.lblStepPreview.Location = New System.Drawing.Point(48, 176)
        Me.lblStepPreview.Name = "lblStepPreview"
        Me.lblStepPreview.Size = New System.Drawing.Size(88, 16)
        Me.lblStepPreview.TabIndex = 37
        Me.lblStepPreview.Text = "Summary"
        Me.lblStepPreview.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepPreview
        '
        Me.pnlStepPreview.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepPreview.Location = New System.Drawing.Point(24, 176)
        Me.pnlStepPreview.Name = "pnlStepPreview"
        Me.pnlStepPreview.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepPreview.TabIndex = 36
        '
        'lblStepFinish
        '
        Me.lblStepFinish.ForeColor = System.Drawing.Color.White
        Me.lblStepFinish.Location = New System.Drawing.Point(40, 240)
        Me.lblStepFinish.Name = "lblStepFinish"
        Me.lblStepFinish.Size = New System.Drawing.Size(88, 16)
        Me.lblStepFinish.TabIndex = 35
        Me.lblStepFinish.Text = "Finish"
        Me.lblStepFinish.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepDuplicateCheck
        '
        Me.lblStepDuplicateCheck.ForeColor = System.Drawing.Color.White
        Me.lblStepDuplicateCheck.Location = New System.Drawing.Point(48, 112)
        Me.lblStepDuplicateCheck.Name = "lblStepDuplicateCheck"
        Me.lblStepDuplicateCheck.Size = New System.Drawing.Size(100, 16)
        Me.lblStepDuplicateCheck.TabIndex = 34
        Me.lblStepDuplicateCheck.Text = "Duplicate Check"
        Me.lblStepDuplicateCheck.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepVerifyGroup
        '
        Me.lblStepVerifyGroup.ForeColor = System.Drawing.Color.White
        Me.lblStepVerifyGroup.Location = New System.Drawing.Point(48, 80)
        Me.lblStepVerifyGroup.Name = "lblStepVerifyGroup"
        Me.lblStepVerifyGroup.Size = New System.Drawing.Size(88, 16)
        Me.lblStepVerifyGroup.TabIndex = 33
        Me.lblStepVerifyGroup.Text = "Select Group"
        Me.lblStepVerifyGroup.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepSelectApb
        '
        Me.lblStepSelectApb.ForeColor = System.Drawing.Color.White
        Me.lblStepSelectApb.Location = New System.Drawing.Point(48, 48)
        Me.lblStepSelectApb.Name = "lblStepSelectApb"
        Me.lblStepSelectApb.Size = New System.Drawing.Size(88, 16)
        Me.lblStepSelectApb.TabIndex = 32
        Me.lblStepSelectApb.Text = "Select APB"
        Me.lblStepSelectApb.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepStart
        '
        Me.lblStepStart.ForeColor = System.Drawing.Color.White
        Me.lblStepStart.Location = New System.Drawing.Point(40, 16)
        Me.lblStepStart.Name = "lblStepStart"
        Me.lblStepStart.Size = New System.Drawing.Size(88, 16)
        Me.lblStepStart.TabIndex = 31
        Me.lblStepStart.Text = "Start"
        Me.lblStepStart.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepFinish
        '
        Me.pnlStepFinish.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepFinish.Location = New System.Drawing.Point(8, 240)
        Me.pnlStepFinish.Name = "pnlStepFinish"
        Me.pnlStepFinish.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepFinish.TabIndex = 30
        '
        'pnlStepDuplicateCheck
        '
        Me.pnlStepDuplicateCheck.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepDuplicateCheck.Location = New System.Drawing.Point(24, 112)
        Me.pnlStepDuplicateCheck.Name = "pnlStepDuplicateCheck"
        Me.pnlStepDuplicateCheck.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepDuplicateCheck.TabIndex = 29
        '
        'pnlStepVerifyGroup
        '
        Me.pnlStepVerifyGroup.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepVerifyGroup.Location = New System.Drawing.Point(24, 80)
        Me.pnlStepVerifyGroup.Name = "pnlStepVerifyGroup"
        Me.pnlStepVerifyGroup.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepVerifyGroup.TabIndex = 28
        '
        'pnlStepSelectApb
        '
        Me.pnlStepSelectApb.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepSelectApb.Location = New System.Drawing.Point(24, 48)
        Me.pnlStepSelectApb.Name = "pnlStepSelectApb"
        Me.pnlStepSelectApb.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepSelectApb.TabIndex = 27
        '
        'pnlStepStart
        '
        Me.pnlStepStart.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepStart.Location = New System.Drawing.Point(8, 16)
        Me.pnlStepStart.Name = "pnlStepStart"
        Me.pnlStepStart.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepStart.TabIndex = 26
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.SystemColors.Control
        Me.pnlBottom.Controls.Add(Me.btnFinish)
        Me.pnlBottom.Controls.Add(Me.btnNext)
        Me.pnlBottom.Controls.Add(Me.btnBack)
        Me.pnlBottom.Controls.Add(Me.btnCancel)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(1, 647)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(862, 40)
        Me.pnlBottom.TabIndex = 0
        '
        'btnFinish
        '
        Me.btnFinish.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnFinish.Location = New System.Drawing.Point(776, 9)
        Me.btnFinish.Name = "btnFinish"
        Me.btnFinish.Size = New System.Drawing.Size(72, 23)
        Me.btnFinish.TabIndex = 3
        Me.btnFinish.Text = "&Finish"
        '
        'btnNext
        '
        Me.btnNext.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNext.Location = New System.Drawing.Point(696, 9)
        Me.btnNext.Name = "btnNext"
        Me.btnNext.TabIndex = 2
        Me.btnNext.Text = "&Next >>"
        '
        'btnBack
        '
        Me.btnBack.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnBack.Location = New System.Drawing.Point(616, 9)
        Me.btnBack.Name = "btnBack"
        Me.btnBack.TabIndex = 1
        Me.btnBack.Text = "<< &Back"
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Location = New System.Drawing.Point(536, 9)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 0
        Me.btnCancel.Text = "&Cancel"
        '
        'tmrTimer
        '
        Me.tmrTimer.Interval = 200
        '
        'sfdSave
        '
        Me.sfdSave.DefaultExt = "xls"
        Me.sfdSave.Filter = "Excel Files|.xls"
        '
        'ApbPost
        '
        Me.Controls.Add(Me.pnlBackPanel)
        Me.Name = "ApbPost"
        Me.Size = New System.Drawing.Size(864, 688)
        Me.pnlBackPanel.ResumeLayout(False)
        Me.pnlRight.ResumeLayout(False)
        Me.tabWizard.ResumeLayout(False)
        Me.tpgStepStart.ResumeLayout(False)
        Me.tpgStepSelectApb.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.tpgStepVerifyGroup.ResumeLayout(False)
        Me.tabGroupPageGrouping.ResumeLayout(False)
        Me.tpgGroupPageApb.ResumeLayout(False)
        Me.Panel5.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.tpgGroupPageGroup.ResumeLayout(False)
        Me.Panel6.ResumeLayout(False)
        Me.Panel4.ResumeLayout(False)
        Me.Panel3.ResumeLayout(False)
        Me.tpgStepDuplicateCheck.ResumeLayout(False)
        Me.pnlDupCheckPageBack.ResumeLayout(False)
        Me.pnlDupCheckPageApbBack.ResumeLayout(False)
        Me.tpgStepRepostCheck.ResumeLayout(False)
        Me.tpgStepSummary.ResumeLayout(False)
        Me.tpgStepPosting.ResumeLayout(False)
        Me.tpgStepFinish.ResumeLayout(False)
        Me.pnlLeft.ResumeLayout(False)
        Me.pnlBottom.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members"

    Private Shared CANCEL_BUTTON As String = "Cancel"
    Private Shared BACK_BUTTON As String = "<< Back"
    Private Shared NEXT_BUTTON As String = "Next >>"
    Private Shared FINISH_BUTTON As String = "Finish"


    Public Enum WizardStep
        Start = 0
        SelectApb = 1
        VerifyGroup = 2
        DuplicateCheck = 3
        RepostCheck = 4
        Summary = 5
        Posting = 6
        Finish = 7
    End Enum

    Private Enum ApbPageField
        ApID = 0
        ApDescription = 1
        DocumentName = 2
        DateRangeBegin = 3
        DateRangeEnd = 4
        DateGenerated = 5
        JobID = 6
        Url = 7
        Path = 8
    End Enum

    Private mApbPageColumnText() As String = {"AP ID", "AP Description", "Document Name", "Begin", "End", "Generated On", "Job ID", "Url", "Path"}
    Private mListViewApbPageSort As New ListViewSortCriteria(ApbPageField.ApDescription, DataType.String, SortOrder.Ascend)

    Private Enum GroupPageTabular
        GroupByApb = 0
        GroupByGroup = 1
    End Enum

    Private Enum GroupPageApbField
        ApID = 0
        DocumentName = 1
        DateRangeBegin = 2
        DateRangeEnd = 3
        Url = 4
        JobID = 5
        GroupID = 6     'Only used for lvwGroupPageApb2 to link back to group
    End Enum

    Private Enum GroupPageGroupField
        GroupID = 0
        GroupName = 1
        ApID = 2        'Only used for lvwGroupPageGroup1 to link back to report
    End Enum

    'APB grouping tabular, APB list view
    Private mApb1ColumnText() As String = {"AP ID", "Document Name", "Begin", "End", "Url", "Job ID"}
    Private mListViewApb1Sort As New ListViewSortCriteria(GroupPageApbField.DocumentName, DataType.String, SortOrder.Ascend)

    'APB grouping tabular, group list view
    Private mGroup1ColumnText() As String = {"Group ID", "Group Name", "AP ID"}
    Private mListViewGroup1Sort As New ListViewSortCriteria(GroupPageGroupField.GroupName, DataType.String, SortOrder.Ascend)

    'Group grouping tabular, group list view
    Private mGroup2ColumnText() As String = {"Group ID", "Group Name"}
    Private mListViewGroup2Sort As New ListViewSortCriteria(GroupPageGroupField.GroupName, DataType.String, SortOrder.Ascend)

    'Group grouping tabular, APB list view
    Private mApb2ColumnText() As String = {"AP ID", "Document Name", "Begin", "End", "Url", "Job ID", "Group ID"}
    Private mListViewApb2Sort As New ListViewSortCriteria(GroupPageApbField.DocumentName, DataType.String, SortOrder.Ascend)

    Private Enum DupCheckPagePathField
        Path = 0
        GroupID = 1
    End Enum

    Private Enum DupCheckPageApbField
        ApID = 0
        DocumentName = 1
        GroupName = 2
        DateRangeBegin = 3
        DateRangeEnd = 4
        JobID = 5
        Url = 6
    End Enum

    Private Enum SummaryPageField
        ApIcon = 0
        ApID = 1
        DocumentName = 2
        GroupName = 3
        PathIcon = 4
        Path = 5
        Url = 6
    End Enum

    Private WithEvents mController As New ApbPostController
    Private WithEvents mNotifyPdfMissing As New NotifyPdfMissing
    Private WithEvents mWizard As MapWizard
    Private mWizardData(WizardStep.Finish) As MapWizardData
    Private mTriggeredByProgram As Boolean = False
    Private mThread As Thread
    Private mFrmPath As New ApbDocTree

#End Region

#Region " Public Methods"

    Public Sub Start()
        mController = New ApbPostController
        InitializeApbPageData()
        ResetWizard()
        mWizard.CurrentStep = WizardStep.Start
    End Sub

#End Region

#Region " Event Handlers for overall"

    Private Sub BackPanel_Paint(ByVal sender As System.Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles pnlLeft.Paint
        'Draw lines between step boxes
        Dim p As New Pen(Color.White, 1)
        Dim rect As New Rectangle(16, 24, pnlStepStart.Width, pnlStepStart.Width * 2 * WizardStep.Finish)
        Dim gr As Graphics = e.Graphics
        gr.DrawRectangle(p, rect)
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.Start()
    End Sub

    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click
        mWizard.MoveBack()
    End Sub

    Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click
        mWizard.MoveNext()
    End Sub

    Private Sub btnFinish_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        mWizard.Finish()
        Me.Start()
    End Sub

    Private Sub lnkLabel_MouseEnter(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkApbPageSelectAll.MouseEnter, lnkApbPageDeselectAll.MouseEnter, lnkApbPageSelectHighlight.MouseEnter, lnkApbPageDeselectHighlight.MouseEnter, lnkDupCheckPageRefresh.MouseEnter
        Dim lnkLabel As LinkLabel = CType(sender, LinkLabel)
        lnkLabel.LinkColor = Color.Blue
    End Sub

    Private Sub lnkLabel_MouseLeave(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkApbPageSelectAll.MouseLeave, lnkApbPageDeselectAll.MouseLeave, lnkApbPageSelectHighlight.MouseLeave, lnkApbPageDeselectHighlight.MouseLeave, lnkDupCheckPageRefresh.MouseLeave
        Dim lnkLabel As LinkLabel = CType(sender, LinkLabel)
        lnkLabel.LinkColor = Color.Black
    End Sub

    Private Sub Wizard_Validate(ByVal currentStep As Integer, ByRef CancelMove As Boolean) Handles mWizard.Validate
        Select Case currentStep
            Case WizardStep.SelectApb
                ValidatePageSelectApb(currentStep, CancelMove)
            Case WizardStep.VerifyGroup
        End Select
    End Sub

    Private Sub mWizard_DisplayStep(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean) Handles mWizard.DisplayStep
        Dim wizardData As MapWizardData = CType(page, MapWizardData)
        Dim i As Integer

        'Set color for step boxes, set font for step labels
        For i = 0 To mWizardData.Length - 1
            With mWizardData(i)
                .StepBox.BackColor = .StepBoxColor
                .StepLabel.Font = .StepLabelFont
            End With
        Next

        'Select tab
        tabWizard.SelectedIndex = wizardData.StepID

        'Set wizard navigating buttons
        With wizardData
            btnCancel.Enabled = .EnableCancelButton
            btnCancel.Text = .CancelButtonText

            btnBack.Enabled = .EnableBackButton
            btnBack.Text = .BackButtonText

            btnNext.Enabled = .EnableNextButton
            btnNext.Text = .NextButtonText

            btnFinish.Enabled = .EnableFinishButton
            btnFinish.Text = .FinishButtonText
        End With

        Select Case currentStep
            Case WizardStep.SelectApb
                DisplayPageSelectApb(currentStep, page, moveForward)
            Case WizardStep.VerifyGroup
                DisplayPageGroup(currentStep, page, moveForward)
            Case WizardStep.DuplicateCheck
                DisplayPageDuplicateCheck(currentStep, page, moveForward)
            Case WizardStep.RepostCheck
                DisplayPageRepostCheck(currentStep, page, moveForward)
            Case WizardStep.Summary
                DisplayPageSummary(currentStep, page, moveForward)
            Case WizardStep.Posting
                DisplayPagePosting(currentStep, page, moveForward)
        End Select

    End Sub

    Private Sub mWizard_Terminate() Handles mWizard.Terminate

    End Sub

#End Region

#Region " Event handlers for page <Select APB>"

    Private Sub lstApbPageNotify_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstApbPageNotify.SelectedIndexChanged
        If (lstApbPageNotify.SelectedIndex < 0) Then Return
        Me.mController.Notify = CType(lstApbPageNotify.SelectedItem, ListBoxTextItem).Value
        If (Not mTriggeredByProgram) Then ShowApbPageClient()
    End Sub

    Private Sub btnApbPageFilterData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApbPageFilterData.Click
        Dim itmListItem As ListViewItem
        Dim apID As String

        Me.Cursor = Cursors.WaitCursor

        'Query data
        Dim rdr As SqlDataReader = Me.mController.PullPostableApList()

        'Show data
        lvwApbPageApbList.BeginUpdate()
        lvwApbPageApbList.Items.Clear()
        Do While rdr.Read
            itmListItem = New ListViewItem
            itmListItem.ImageIndex = 0
            apID = CStr(rdr("AP_ID"))
            itmListItem.Text = apID
            itmListItem.SubItems.Add(CStr(rdr("strAP_Description")))
            itmListItem.SubItems.Add(CStr(rdr("strDocument_NM")))
            itmListItem.SubItems.Add(CDate(rdr("dtiCurrentTimeBegin")).ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(CDate(rdr("dtiCurrentTimeEnd")).ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(CDate(rdr("JobEndTime")).ToString("MM/dd/yy hh:mm"))
            itmListItem.SubItems.Add(CInt(rdr("Job_ID")).ToString)
            itmListItem.SubItems.Add(CStr(rdr("Url")) + apID + ".pdf")
            itmListItem.SubItems.Add(CStr(rdr("Path")) + apID + ".pdf")
            lvwApbPageApbList.Items.Add(itmListItem)
        Loop
        rdr.Close()

        'Set sorting criteria
        With lvwApbPageApbList
            .ListViewItemSorter = New ListViewComparer(Me.mListViewApbPageSort)
            .Sort()
            .Columns(Me.mListViewApbPageSort.SortColumn).Text = _
                mApbPageColumnText(Me.mListViewApbPageSort.SortColumn) + mListViewApbPageSort.SortOrderIcon
        End With

        lvwApbPageApbList.EndUpdate()

        lvwApbPageApbList.Focus()

        'Show counts
        lblApbPageTotalCount.Text = lvwApbPageApbList.Items.Count.ToString
        lblApbPageSelectCount.Text = "0"

        Me.Cursor = Cursors.Default
    End Sub

    Private Sub btnApbPageResetFilter_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApbPageResetFilter.Click
        InitializeApbPageData()
    End Sub

    Private Sub lnkApbPageSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbPageSelectAll.LinkClicked
        Dim item As ListViewItem

        Me.mTriggeredByProgram = True

        lvwApbPageApbList.BeginUpdate()
        For Each item In lvwApbPageApbList.Items
            item.Checked = True
        Next
        lvwApbPageApbList.EndUpdate()
        lvwApbPageApbList.Focus()

        Me.mTriggeredByProgram = False
        ApbPageShowSelectCount()
    End Sub

    Private Sub lnkApbPageDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbPageDeselectAll.LinkClicked
        Dim item As ListViewItem

        Me.mTriggeredByProgram = True

        lvwApbPageApbList.BeginUpdate()
        For Each item In lvwApbPageApbList.Items
            item.Checked = False
        Next
        lvwApbPageApbList.EndUpdate()
        lvwApbPageApbList.Focus()

        Me.mTriggeredByProgram = False
        ApbPageShowSelectCount()
    End Sub

    Private Sub lnkApbPageSelectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbPageSelectHighlight.LinkClicked
        Dim item As ListViewItem

        Me.mTriggeredByProgram = True

        lvwApbPageApbList.BeginUpdate()
        For Each item In lvwApbPageApbList.SelectedItems
            item.Checked = True
        Next
        lvwApbPageApbList.EndUpdate()
        lvwApbPageApbList.Focus()

        Me.mTriggeredByProgram = False
        ApbPageShowSelectCount()
    End Sub

    Private Sub lnkApbPageDeselectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkApbPageDeselectHighlight.LinkClicked
        Dim item As ListViewItem

        Me.mTriggeredByProgram = True

        lvwApbPageApbList.BeginUpdate()
        For Each item In lvwApbPageApbList.SelectedItems
            item.Checked = False
        Next
        lvwApbPageApbList.EndUpdate()
        lvwApbPageApbList.Focus()

        Me.mTriggeredByProgram = False
        ApbPageShowSelectCount()
    End Sub

    Private Sub lvwApbPageApbList_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwApbPageApbList.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewApbPageSort.SortColumn

        'Set new sort column index
        Me.mListViewApbPageSort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case ApbPageField.ApID, ApbPageField.DocumentName, ApbPageField.Url, ApbPageField.Path
                Me.mListViewApbPageSort.DataType = DataType.String
            Case ApbPageField.JobID
                Me.mListViewApbPageSort.DataType = DataType.Integer
            Case ApbPageField.DateRangeBegin, ApbPageField.DateRangeEnd, ApbPageField.DateGenerated
                Me.mListViewApbPageSort.DataType = DataType.Date
        End Select

        'Append ascend/descend arrow to the column header text
        Dim text As String = Me.mApbPageColumnText(e.Column) + Me.mListViewApbPageSort.SortOrderIcon
        lvw.Columns(e.Column).Text = text

        'Delete ascend/descend arrow from the header text of the original sort column
        If (origSortColumn <> e.Column) Then
            lvw.Columns(origSortColumn).Text = Me.mApbPageColumnText(origSortColumn)
        End If

        'Sort
        lvw.Sort()

        lvw.EndUpdate()

    End Sub

    Private Sub lvwApbPageApbList_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwApbPageApbList.MouseDown
        If (e.X < 25 OrElse e.X > 45) Then Return
        Dim item As ListViewItem = lvwApbPageApbList.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then Return
        Dim url As String = item.SubItems(ApbPageField.Url).Text
        Me.Cursor = Cursors.WaitCursor
        System.Diagnostics.Process.Start(url)
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub lvwApbPageApbList_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwApbPageApbList.MouseMove
        If (e.X < 25 OrElse e.X > 45) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (lvwApbPageApbList.GetItemAt(e.X, e.Y) Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        Me.Cursor = Cursors.Hand
    End Sub

    Private Sub lvwApbPageApbList_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwApbPageApbList.SizeChanged
        ListViewResize(CType(sender, ListView), ApbPageField.ApDescription, 5, ApbPageField.DocumentName, 5)
    End Sub

    Private Sub lvwApbPageApbList_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwApbPageApbList.ItemCheck
        If (Me.mTriggeredByProgram) Then Return

        Dim lvw As ListView = CType(sender, ListView)
        Dim count As Integer = lvw.CheckedItems.Count
        If (e.CurrentValue <> e.NewValue) Then
            If (e.NewValue = CheckState.Checked) Then count += 1
            If (e.NewValue = CheckState.Unchecked) Then count -= 1
        End If
        lblApbPageSelectCount.Text = count.ToString
    End Sub

#End Region

#Region " Event handlers for page <Select Group>"

    Private Sub lvwGroupPageApb1_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwGroupPageApb1.SelectedIndexChanged
        DrawGroupPageApbTabularGroupList()
    End Sub

    Private Sub lvwGroupPageGroup2_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroupPageGroup2.SelectedIndexChanged
        DrawGroupPageGroupTabularApbList()
    End Sub

    Private Sub lvwGroupPageApb1_ItemCheck(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwGroupPageApb1.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        'Get current AP and its check status
        Dim item As ListViewItem = lvwGroupPageApb1.Items(e.Index)
        Dim checked As Boolean = CBool(IIf(e.NewValue = CheckState.Checked, True, False))

        'Set post status of all the groups that assigned to this AP to be same as AP
        Dim apID As String = item.SubItems(GroupPageApbField.ApID).Text
        Dim report As ApbReport = Me.mController.Reports(apID)
        Dim group As ApbGroup
        For Each group In report.Groups.Values
            group.DoPost = checked
        Next

        'if check item is not currently selected, select it
        lvwGroupPageApb1.SelectedItems.Clear()
        item.Selected = True
        item.Focused = True
    End Sub

    Private Sub lvwGroupPageGroup1_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwGroupPageGroup1.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        Dim item As ListViewItem = lvwGroupPageGroup1.Items(e.Index)
        Dim checkApID As String = item.SubItems(GroupPageGroupField.ApID).Text
        Dim checkGroupID As Integer = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
        Dim apID As String
        Dim checkedCount As Integer = 0
        Dim checked As Boolean

        'Save the check status
        Dim report As ApbReport = Me.mController.Reports(checkApID)
        If (report Is Nothing) Then Return

        Dim group As ApbGroup = report.Groups(checkGroupID)
        If (group Is Nothing) Then Return

        If (e.NewValue = CheckState.Checked) Then
            group.DoPost = True
        Else
            group.DoPost = False
        End If

        'Find out how many checkbox in group list are checked
        For Each group In report.Groups.Values
            If (group.DoPost) Then checkedCount += 1
        Next
        checked = CBool(IIf(checkedCount > 0, True, False))

        'Set check box for report
        For Each item In lvwGroupPageApb1.Items
            apID = item.SubItems(GroupPageApbField.ApID).Text
            If (apID = checkApID) Then
                If (item.Checked <> checked) Then
                    mTriggeredByProgram = True
                    item.Checked = checked
                    mTriggeredByProgram = False
                End If
                Exit For
            End If
        Next

        lvwGroupPageApb1.Focus()
    End Sub

    Private Sub lvwGroupPageGroup2_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwGroupPageGroup2.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        'Get current group and its check status
        Dim item As ListViewItem = lvwGroupPageGroup2.Items(e.Index)
        Dim checked As Boolean = CBool(IIf(e.NewValue = CheckState.Checked, True, False))

        'Set post status of this group for all the APs
        Dim groupID As Integer = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        Dim report As ApbReport
        For Each report In groupListItem.Reports.Values
            report.DoPost(groupID) = checked
        Next

        'if check item is not currently selected, select it
        lvwGroupPageGroup2.SelectedItems.Clear()
        item.Selected = True
        item.Focused = True
    End Sub

    Private Sub lvwGroupPageApb2_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwGroupPageApb2.ItemCheck
        'If this event is triggered by child list, don't do anything
        If (mTriggeredByProgram) Then Return

        Dim item As ListViewItem = lvwGroupPageApb2.Items(e.Index)
        Dim checkGroupID As Integer = CInt(item.SubItems(GroupPageApbField.GroupID).Text)
        Dim checkApID As String = item.SubItems(GroupPageApbField.ApID).Text
        Dim groupID As Integer
        Dim checkedCount As Integer = 0
        Dim checked As Boolean

        'Save the check status
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(checkGroupID)
        If (groupListItem Is Nothing) Then Return

        Dim report As ApbReport = groupListItem.Reports(checkApID)
        If (report Is Nothing) Then Return

        If (e.NewValue = CheckState.Checked) Then
            report.DoPost(checkGroupID) = True
        Else
            report.DoPost(checkGroupID) = False
        End If

        'Find out how many checkbox in group list are checked
        For Each report In groupListItem.Reports.Values
            If (report.DoPost(checkGroupID)) Then checkedCount += 1
        Next
        checked = CBool(IIf(checkedCount > 0, True, False))

        'Set check box for group list item
        For Each item In lvwGroupPageGroup2.Items
            groupID = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
            If (groupID = checkGroupID) Then
                If (item.Checked <> checked) Then
                    mTriggeredByProgram = True
                    item.Checked = checked
                    mTriggeredByProgram = False
                End If
                Exit For
            End If
        Next

        lvwGroupPageGroup2.Focus()
    End Sub

    Private Sub lvwGroupPageApb1_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwGroupPageApb1.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewApb1Sort.SortColumn

        'Set new sort column index
        Me.mListViewApb1Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case GroupPageApbField.ApID, GroupPageApbField.DocumentName
                Me.mListViewApb1Sort.DataType = DataType.String
            Case GroupPageApbField.JobID, GroupPageApbField.GroupID
                Me.mListViewApb1Sort.DataType = DataType.Integer
            Case GroupPageApbField.DateRangeBegin, GroupPageApbField.DateRangeEnd
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

    Private Sub lvwGroupPageGroup1_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwGroupPageGroup1.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewGroup1Sort.SortColumn

        'Set new sort column index
        Me.mListViewGroup1Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case GroupPageGroupField.GroupName, GroupPageGroupField.ApID
                Me.mListViewGroup1Sort.DataType = DataType.String
            Case GroupPageGroupField.GroupID
                Me.mListViewGroup1Sort.DataType = DataType.Integer
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

    Private Sub lvwGroupPageGroup2_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwGroupPageGroup2.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewGroup2Sort.SortColumn

        'Set new sort column index
        Me.mListViewGroup2Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case GroupPageGroupField.GroupName, GroupPageGroupField.ApID
                Me.mListViewGroup2Sort.DataType = DataType.String
            Case GroupPageGroupField.GroupID
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

    Private Sub lvwGroupPageApb2_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwGroupPageApb2.ColumnClick
        Dim lvw As ListView = CType(sender, ListView)

        lvw.BeginUpdate()

        'Backup the original sort column
        Dim origSortColumn As Integer = Me.mListViewApb2Sort.SortColumn

        'Set new sort column index
        Me.mListViewApb2Sort.SortColumn = e.Column

        'Set sort column data type
        Select Case e.Column
            Case GroupPageApbField.ApID, GroupPageApbField.DocumentName
                Me.mListViewApb2Sort.DataType = DataType.String
            Case GroupPageApbField.JobID, GroupPageApbField.GroupID
                Me.mListViewApb2Sort.DataType = DataType.Integer
            Case GroupPageApbField.DateRangeBegin, GroupPageApbField.DateRangeEnd
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

    Private Sub tabGroupPageTabular_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tabGroupPageGrouping.SelectedIndexChanged
        Me.Cursor = Cursors.WaitCursor
        If (tabGroupPageGrouping.SelectedIndex = GroupPageTabular.GroupByApb) Then
            DrawGroupPageApbTabularApbList()
            lvwGroupPageApb1.Focus()
        Else
            DrawGroupPageGroupTabularGroupList()
            lvwGroupPageGroup2.Focus()
        End If
        Me.Cursor = Cursors.Default
    End Sub

    'Private Sub lvwGroupPageGroup1_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroupPageGroup1.GotFocus
    '    lvwGroupPageApb1.Focus()
    'End Sub

    'Private Sub lvwGroupPageApb2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroupPageApb2.GotFocus
    '    lvwGroupPageGroup2.Focus()
    'End Sub

    Private Sub lvwGroupPageApb_SizeChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwGroupPageApb2.SizeChanged, lvwGroupPageApb1.SizeChanged
        ListViewResize(CType(sender, ListView), GroupPageApbField.DocumentName)
    End Sub

    Private Sub lvwGroupPageGroup_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwGroupPageGroup1.SizeChanged, lvwGroupPageGroup2.SizeChanged
        ListViewResize(CType(sender, ListView), GroupPageGroupField.GroupName)
    End Sub

    Private Sub lvwGroupPageApb_MouseDown(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwGroupPageApb2.MouseDown, lvwGroupPageApb1.MouseDown
        If (e.X < 25 OrElse e.X > 45) Then Return
        Dim item As ListViewItem = lvwGroupPageApb1.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then Return
        Dim url As String = item.SubItems(GroupPageApbField.Url).Text
        Me.Cursor = Cursors.WaitCursor
        System.Diagnostics.Process.Start(url)
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub lvwGroupPageApb_MouseMove(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwGroupPageApb2.MouseMove, lvwGroupPageApb1.MouseMove
        If (e.X < 25 OrElse e.X > 45) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (lvwGroupPageApb1.GetItemAt(e.X, e.Y) Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        Me.Cursor = Cursors.Hand

    End Sub

#Region " Event handlers for <Select XXX> buttons"

    Private Sub lnkApbTabApbSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabApbSelectAll.LinkClicked
        SelectAllApbAndGroup(True)
        lvwGroupPageApb1.Focus()
    End Sub

    Private Sub lnkApbTabApbDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabApbDeselectAll.LinkClicked
        SelectAllApbAndGroup(False)
        lvwGroupPageApb1.Focus()
    End Sub

    Private Sub lnkApbTabApbSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabApbSelectHighlighted.LinkClicked
        SelectApbTabHighlightedApb(True)
        lvwGroupPageApb1.Focus()
    End Sub

    Private Sub lnkApbTabApbDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabApbDeselectHighlighted.LinkClicked
        SelectApbTabHighlightedApb(False)
        lvwGroupPageApb1.Focus()
    End Sub


    Private Sub lnkApbTabGroupSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabGroupSelectAll.LinkClicked
        SelectApbTabAllGroup(True)
        lvwGroupPageGroup1.Focus()
    End Sub

    Private Sub lnkApbTabGroupDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabGroupDeselectAll.LinkClicked
        SelectApbTabAllGroup(False)
        lvwGroupPageGroup1.Focus()
    End Sub

    Private Sub lnkApbTabGroupSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabGroupSelectHighlighted.LinkClicked
        SelectApbTabHighlightedGroup(True)
        lvwGroupPageGroup1.Focus()
    End Sub

    Private Sub lnkApbTabGroupDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageApbTabGroupDeselectHighlighted.LinkClicked
        SelectApbTabHighlightedGroup(False)
        lvwGroupPageGroup1.Focus()
    End Sub

    Private Sub lnkGroupTabGroupSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabGroupSelectAll.LinkClicked
        SelectAllApbAndGroup(True)
        lvwGroupPageGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabGroupDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabGroupDeselectAll.LinkClicked
        SelectAllApbAndGroup(False)
        lvwGroupPageGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabGroupSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabGroupSelectHighlighted.LinkClicked
        SelectGroupTabHighlightedGroup(True)
        lvwGroupPageGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabGroupDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabGroupDeselectHighlighted.LinkClicked
        SelectGroupTabHighlightedGroup(False)
        lvwGroupPageGroup2.Focus()
    End Sub

    Private Sub lnkGroupTabApbSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabApbSelectAll.LinkClicked
        SelectGroupTabAllApb(True)
        lvwGroupPageApb2.Focus()
    End Sub

    Private Sub lnkGroupTabApbDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabApbDeselectAll.LinkClicked
        SelectGroupTabAllApb(False)
        lvwGroupPageApb2.Focus()
    End Sub

    Private Sub lnkGroupTabApbSelectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabApbSelectHighlighted.LinkClicked
        SelectGroupTabHighlightedApb(True)
        lvwGroupPageApb2.Focus()
    End Sub

    Private Sub lnkGroupTabApbDeselectHighlighted_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkGroupPageGroupTabApbDeselectHighlighted.LinkClicked
        SelectGroupTabHighlightedApb(False)
        lvwGroupPageApb2.Focus()
    End Sub

#End Region

#End Region

#Region " Event handlers for page <Duplication Check>"

    Private Sub lvwDupCheckPagePath_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwDupCheckPagePath.SizeChanged
        ListViewResize(CType(sender, ListView), DupCheckPagePathField.Path)
    End Sub

    Private Sub pnlDupCheckPageBack_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles pnlDupCheckPageBack.SizeChanged
        lvwDupCheckPagePath.Height = CInt(pnlDupCheckPageBack.Height * 2 / 5)
    End Sub

    Private Sub lvwDupCheckPageApb_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwDupCheckPageApb.SizeChanged
        ListViewResize(CType(sender, ListView), DupCheckPageApbField.DocumentName, 2, DupCheckPageApbField.GroupName, 3)
    End Sub

    Private Sub lvwDupCheckPagePath_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwDupCheckPagePath.SelectedIndexChanged
        'Look up the selected path
        If (lvwDupCheckPagePath.SelectedItems.Count <= 0) Then Return
        Dim item As ListViewItem = lvwDupCheckPagePath.SelectedItems(0)
        Dim groupID As Integer = CInt(item.SubItems(DupCheckPagePathField.GroupID).Text)
        Dim pathStr As String = item.SubItems(DupCheckPagePathField.Path).Text
        Dim pathKey As String = groupID & ":" & pathStr
        Dim path As ApbPath = Me.mController.Paths(pathKey)
        If (path Is Nothing) Then
            lvwDupCheckPageApb.Items.Clear()
            Return
        End If

        'Redraw apb list
        Dim report As ApbReport
        Dim group As ApbGroup

        lvwDupCheckPageApb.BeginUpdate()
        lvwDupCheckPageApb.Items.Clear()
        For Each report In path.Reports
            item = New ListViewItem
            item.ImageIndex = 0
            item.Text = report.ApID
            item.SubItems.Add(report.DocumentName)
            For Each group In report.Groups.Values
                item.SubItems.Add(group.GroupName)
            Next
            item.SubItems.Add(report.DateRangeBegin.ToString("MM/dd/yy"))
            item.SubItems.Add(report.DateRangeEnd.ToString("MM/dd/yy"))
            item.SubItems.Add(report.JobID.ToString)
            item.SubItems.Add(report.Url)
            lvwDupCheckPageApb.Items.Add(item)
        Next
        lvwDupCheckPageApb.EndUpdate()

    End Sub

    Private Sub lnkDupCheckPageRefresh_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkDupCheckPageRefresh.LinkClicked
        Me.mController.Refresh()
        DisplayPageDuplicateCheck(WizardStep.DuplicateCheck, Nothing, True)
    End Sub

    Private Sub lvwDupCheckPageApb_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwDupCheckPageApb.MouseDown
        If (e.X < 3 OrElse e.X > 22) Then Return
        Dim item As ListViewItem = lvwDupCheckPageApb.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then Return
        Dim url As String = item.SubItems(DupCheckPageApbField.Url).Text
        Me.Cursor = Cursors.WaitCursor
        System.Diagnostics.Process.Start(url)
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub lvwDupCheckPageApb_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwDupCheckPageApb.MouseMove
        If (e.X < 3 OrElse e.X > 22) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (lvwApbPageApbList.GetItemAt(e.X, e.Y) Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        Me.Cursor = Cursors.Hand

    End Sub

    Private Sub lvwDupCheckPageApb_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwDupCheckPageApb.GotFocus
        lvwDupCheckPagePath.Focus()
    End Sub

    Private Sub lvwDupCheckPagePath_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwDupCheckPagePath.MouseDown
        If (e.X < 1 OrElse e.X > 21) Then Return
        Dim item As ListViewItem = lvwDupCheckPagePath.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then Return
        Dim path As String = item.SubItems(DupCheckPagePathField.Path).Text
        Me.Cursor = Cursors.WaitCursor
        With mFrmPath
            .Path = path
            .ShowDialog(Me)
        End With
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub lvwDupCheckPagePath_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwDupCheckPagePath.MouseMove
        If (e.X < 1 OrElse e.X > 21) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (lvwDupCheckPagePath.GetItemAt(e.X, e.Y) Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        Me.Cursor = Cursors.Hand
    End Sub

#End Region

#Region " Event handlers for page <Repost Check>"

    Private Sub mController_DocumentExist(ByVal report As ApbReport, ByVal group As ApbGroup, ByVal docCopy As ApbDocCopy, ByVal nodeID As Integer) Handles mController.DocumentExist
        Static frmConfirm As New ConfirmReplaceDialog
        'EnableThemes(frmConfirm)
        Dim confirmResult As ApbPostController.ComfirmResult

        With frmConfirm
            .FolderPath = docCopy.FullNodePath
            .DocumentName = docCopy.DocumentName
            Dim result As DialogResult = .ShowDialog(Me)
            Select Case result
                Case DialogResult.Cancel
                    confirmResult = ApbPostController.ComfirmResult.Cancel
                Case DialogResult.Yes
                    confirmResult = ApbPostController.ComfirmResult.Yes
                Case DialogResult.OK
                    confirmResult = ApbPostController.ComfirmResult.YesToAll
                Case DialogResult.No
                    confirmResult = ApbPostController.ComfirmResult.No
                Case DialogResult.Ignore
                    confirmResult = ApbPostController.ComfirmResult.NoToAll
                Case Else
                    confirmResult = ApbPostController.ComfirmResult.Cancel
            End Select
            Me.mController.ReplaceConfirmResult = confirmResult

        End With

    End Sub

    Private Sub mController_DocumentExistChecked(ByVal checkedCount As Integer) Handles mController.DocumentExistChecked
        Me.pbrRepostPageProgress.Value = checkedCount
        Me.lblRepostPageProgress.Text = checkedCount & " of " & Me.pbrRepostPageProgress.Maximum
        Me.lblRepostPageProgress.Refresh()
        If (checkedCount Mod 50 = 0) Then Me.Refresh()
    End Sub

#End Region

#Region " Event handlers for page <Summary>"

    Private Sub lvwSummaryPageList_MouseDown(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwSummaryPageList.MouseDown
        Dim icon1BeginX As Integer = 3
        Dim icon1EndX As Integer = 22
        Dim icon2BeginX, icon2EndX As Integer
        Dim i, x As Integer
        Dim item As ListViewItem

        x = 0
        For i = 0 To SummaryPageField.PathIcon - 1
            x += lvwSummaryPageList.Columns(i).Width
        Next i
        icon2BeginX = x + 1
        icon2EndX = x + 19
        If (e.X < icon1BeginX OrElse (e.X > icon1EndX AndAlso e.X < icon2BeginX) OrElse e.X > icon2EndX) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        item = lvwSummaryPageList.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (e.X >= icon1BeginX AndAlso e.X <= icon1EndX) Then
            If (item.ImageIndex < 0) Then
                Me.Cursor = Cursors.Default
                Return
            End If
        End If

        Me.Cursor = Cursors.WaitCursor
        If (e.X >= icon1BeginX AndAlso e.X <= icon1EndX) Then
            Dim url As String = item.SubItems(SummaryPageField.Url).Text
            System.Diagnostics.Process.Start(url)
        Else
            Dim path As String = item.SubItems(SummaryPageField.Path).Text
            With mFrmPath
                .Path = path
                .ShowDialog(Me)
            End With
        End If
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub lvwSummaryPageList_MouseMove(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwSummaryPageList.MouseMove
        Dim icon1BeginX As Integer = 3
        Dim icon1EndX As Integer = 22
        Dim icon2BeginX, icon2EndX As Integer
        Dim i, x As Integer
        Dim item As ListViewItem

        x = 0
        For i = 0 To SummaryPageField.PathIcon - 1
            x += lvwSummaryPageList.Columns(i).Width
        Next i
        icon2BeginX = x + 1
        icon2EndX = x + 19

        If (e.X < icon1BeginX OrElse (e.X > icon1EndX AndAlso e.X < icon2BeginX) OrElse e.X > icon2EndX) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        item = lvwSummaryPageList.GetItemAt(e.X, e.Y)
        If (item Is Nothing) Then
            Me.Cursor = Cursors.Default
            Return
        End If

        If (e.X >= icon1BeginX AndAlso e.X <= icon1EndX) Then
            If (item.ImageIndex < 0) Then
                Me.Cursor = Cursors.Default
                Return
            End If
        End If

        Me.Cursor = Cursors.Hand
    End Sub

    Private Sub lvwSummaryPageList_SizeChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwSummaryPageList.SizeChanged
        ListViewResize(CType(sender, ListView), SummaryPageField.Path)
    End Sub

    Private Sub btnSummaryPageExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSummaryPageExport.Click
        'Get Excel file path
        If sfdSave.ShowDialog <> DialogResult.OK Then Return

        'Create data table
        Dim dtSummary As New DataTable("Summary")
        dtSummary.CaseSensitive = False

        'Create columns
        With dtSummary
            .Columns.Add("[AP ID]", GetType(String))
            .Columns.Add("[Job ID]", GetType(Integer))
            .Columns.Add("[Document Name]", GetType(String))
            .Columns.Add("[Group Name]", GetType(String))
            .Columns.Add("Path", GetType(String))
        End With

        'Add data
        Dim report As ApbReport
        Dim curApID As String
        Dim group As ApbGroup
        Dim curGroupID As Integer
        Dim docCopy As ApbDocCopy
        Dim dopost As Boolean
        Dim dr As DataRow

        For Each report In Me.mController.Reports.Values
            curApID = report.ApID
            For Each group In report.Groups.Values
                curGroupID = group.GroupID
                If (Not group.DoPost) Then GoTo NextLoopGroup

                For Each docCopy In group.DocCopies
                    Select Case docCopy.DocumentExisting
                        Case ApbDocCopy.DocumentExistStatus.Unknown, _
                             ApbDocCopy.DocumentExistStatus.NotExist
                            dopost = True
                        Case ApbDocCopy.DocumentExistStatus.Exist
                            dopost = docCopy.ReplaceExistingDocument
                    End Select
                    If (Not dopost) Then GoTo NextLoopDocCopy

                    dr = dtSummary.NewRow
                    dr("[AP ID]") = report.ApID
                    dr("[Job ID]") = report.JobID
                    dr("[Document Name]") = report.DocumentName
                    dr("[Group Name]") = group.GroupName + " (" & group.GroupID & ")"
                    dr("Path") = docCopy.FullPath

                    dtSummary.Rows.Add(dr)
NextLoopDocCopy:
                Next docCopy
NextLoopGroup:
            Next group
        Next report

        NRC.Data.ExcelData.ExportToExcel(dtSummary, sfdSave.FileName, "Results", True)

    End Sub

#End Region

#Region " Event handlers for page <Posting>"

    Private Sub tmrTimer_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tmrTimer.Tick
        Select Case Me.mController.PostResult
            Case ApbPostController.PostStatus.Posting
                If (lblPostPageMessage.Text <> Me.mController.PostMessage) Then
                    lblPostPageMessage.Text = Me.mController.PostMessage
                End If
                If (IsCountChanged(Me.mController.PostedCount)) Then
                    pbrPostPageProgress.Value = Me.mController.PostedCount
                    lblPostPageProgress.Text = pbrPostPageProgress.Value & " of " & pbrPostPageProgress.Maximum & " posted"
                End If
            Case ApbPostController.PostStatus.Failed
                tmrTimer.Stop()
                lblPostPageMessage.Text = Me.mController.PostMessage
                pbrPostPageProgress.Value = Me.mController.PostedCount
                lblPostPageProgress.Text = pbrPostPageProgress.Value & " of " & pbrPostPageProgress.Maximum & " posted"
                btnCancel.Enabled = True
            Case ApbPostController.PostStatus.Succeed
                tmrTimer.Stop()
                Me.mWizard.MoveNext()
        End Select
    End Sub

#End Region

#Region " Display Pages"

    Private Sub DisplayPageSelectApb(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        lstApbPageNotify.Focus()
        'If (Not moveForward) Then Return
        'DefaultPageSelectApbSelection()
    End Sub

    Private Sub DisplayPageGroup(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        If (Not moveForward) Then Return

        'if job list is unchanged, needn't reflush the group list
        If (Not mController.JobListChanged) Then Return

        Me.Cursor = Cursors.WaitCursor

        'Load AP and group info
        mController.PopulateReportGroupList(False)

        'Set focus
        If (tabGroupPageGrouping.SelectedIndex = GroupPageTabular.GroupByApb) Then
            DrawGroupPageApbTabularApbList()
            lvwGroupPageApb1.Focus()
        Else
            DrawGroupPageGroupTabularGroupList()
            lvwGroupPageGroup2.Focus()
        End If

        Me.Cursor = Cursors.Default

    End Sub

    Private Sub DisplayPageDuplicateCheck(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        If (Not moveForward) Then
            Me.mWizard.MoveBack()
            Return
        End If

        Me.Cursor = Cursors.WaitCursor
        lblDupCheckPageTitle.Text = "Perform checks on duplicate AP reports"

        If (Not Me.mController.DuplicatedPath) Then
            lvwDupCheckPagePath.Items.Clear()
            lvwDupCheckPageApb.Items.Clear()
            Me.mWizard.MoveNext()
            Me.Cursor = Cursors.Default
            Me.Refresh()
            Return
        End If

        Dim paths As ApbPathCollection = Me.mController.Paths
        Dim path As ApbPath
        Dim item As ListViewItem

        lblDupCheckPageTitle.Text = "Can not post multiple AP reports to the same location." _
                                    & vbCrLf & "Change the post settings before going on."

        lvwDupCheckPagePath.BeginUpdate()
        lvwDupCheckPagePath.Items.Clear()
        For Each path In paths.Values
            If (path.Reports.Count > 1) Then
                item = New ListViewItem
                item.ImageIndex = 1
                item.Text = path.FullPath
                item.SubItems.Add(path.GroupID.ToString)
                lvwDupCheckPagePath.Items.Add(item)
            End If
        Next
        lvwDupCheckPagePath.EndUpdate()

        If (lvwDupCheckPagePath.Items.Count > 0) Then
            lvwDupCheckPagePath.Items(0).Selected = True
        End If

        lvwDupCheckPagePath.Focus()
        btnBack.Enabled = True
        btnCancel.Enabled = True

        Me.Cursor = Cursors.Default

    End Sub

    Private Sub DisplayPageRepostCheck(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        If (Not moveForward) Then
            Me.mWizard.MoveBack()
            Return
        End If

        Me.Cursor = Cursors.WaitCursor
        Me.Refresh()
        Dim selectedDocumentCount As Integer = Me.mController.SelectedDocumentCount
        Me.pbrRepostPageProgress.Maximum = selectedDocumentCount
        Me.pbrRepostPageProgress.Value = 0
        Me.mController.RepostCheck()

        Me.Cursor = Cursors.Default

        Select Case Me.mController.ReplaceConfirmResult
            Case ApbPostController.ComfirmResult.Cancel
                Me.mWizard.MoveBack()
            Case Else
                Me.mWizard.MoveNext()
        End Select


    End Sub

    Private Sub DisplayPageSummary(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        Dim item As ListViewItem
        Dim subitem As NRCListViewSubItem
        Dim report As ApbReport
        Dim group As ApbGroup
        Dim docCopy As ApbDocCopy
        Dim prevApID As String = Nothing
        Dim prevGroupID As Integer
        Dim curApID As String
        Dim curGroupID As Integer
        Dim doPost As Boolean
        Dim backColor As Color = lvwSummaryPageList.BackColor
        Dim apbCount As Integer = 0
        Dim groupCount As Integer = 0
        Dim postGroups As New ApbGroupCollection
        Dim postGroup As ApbGroup


        lvwSummaryPageList.BeginUpdate()
        lvwSummaryPageList.Items.Clear()
        For Each report In Me.mController.Reports.Values
            curApID = report.ApID
            For Each group In report.Groups.Values
                curGroupID = group.GroupID
                If (Not group.DoPost) Then GoTo NextLoopGroup

                For Each docCopy In group.DocCopies
                    Select Case docCopy.DocumentExisting
                        Case ApbDocCopy.DocumentExistStatus.Unknown, _
                             ApbDocCopy.DocumentExistStatus.NotExist
                            doPost = True
                        Case ApbDocCopy.DocumentExistStatus.Exist
                            doPost = docCopy.ReplaceExistingDocument
                    End Select
                    If (Not doPost) Then GoTo NextLoopDocCopy

                    item = New ListViewItem

                    item.UseItemStyleForSubItems = False
                    item.Text = ""
                    item.SubItems.Add(report.ApID)
                    item.SubItems.Add(report.DocumentName)
                    item.SubItems.Add(group.GroupName + " (" & group.GroupID & ")")
                    subitem = New NRCListViewSubItem
                    subitem.ImageIndex = 1
                    item.SubItems.Add(subitem)
                    item.SubItems.Add(docCopy.FullPath)
                    item.SubItems.Add(report.Url)

                    If (prevApID <> curApID) Then
                        prevApID = curApID
                        prevGroupID = 0
                        apbCount += 1
                        item.ImageIndex = 0
                    Else
                        item.SubItems(SummaryPageField.ApID).ForeColor = backColor
                        item.SubItems(SummaryPageField.DocumentName).ForeColor = backColor
                    End If

                    If (prevGroupID <> curGroupID) Then
                        prevGroupID = curGroupID

                        postGroup = postGroups.Item(curGroupID)
                        If (postGroup Is Nothing) Then
                            postGroups.Add(curGroupID, group)
                        End If
                    Else
                        item.SubItems(SummaryPageField.GroupName).ForeColor = backColor
                    End If

                    lvwSummaryPageList.Items.Add(item)
NextLoopDocCopy:
                Next docCopy
NextLoopGroup:
            Next group
        Next report
        lvwSummaryPageList.SortColumn = SummaryPageField.DocumentName
        lvwSummaryPageList.SortOrder = NRC.WinForms.SortOrder.Ascend
        lvwSummaryPageList.ShowSubItemImage()
        lvwSummaryPageList.EndUpdate()

        groupCount = postGroups.Count
        lblSummaryPageApbCount.Text = apbCount.ToString
        lblSummaryPageGroupCount.Text = groupCount.ToString
    End Sub

    Private Sub DisplayPagePosting(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        'Initiate
        Dim count As Integer = Me.mController.SelectedDocumentCount
        pbrPostPageProgress.Maximum = count
        pbrPostPageProgress.Value = 0
        lblPostPageMessage.Text = "Preparing post ..."
        lblPostPageMessage.ForeColor = System.Drawing.SystemColors.ControlText
        IsCountChanged(-1)

        'Start a thread to do the posting
        'Dim thrd As New Thread(AddressOf Post)
        mThread = New Thread(New ThreadStart(AddressOf Post))
        mThread.Start()

        'Start timer to monitor the posting status routinely
        tmrTimer.Start()
    End Sub

#End Region

#Region " Validate Pages"

    Private Sub ValidatePageSelectApb(ByVal currentStep As Integer, ByRef cancelMove As Boolean)
        'Check PDF avaiable for selected APs
        Dim isPdfUnavailabe As Boolean = False
        Dim item As ListViewItem
        Dim pdfItem As ListViewItem
        Dim itemIndex As Integer

        Me.Cursor = Cursors.WaitCursor

        mNotifyPdfMissing.lvwApb.Items.Clear()
        For Each item In lvwApbPageApbList.CheckedItems
            If (Not System.IO.File.Exists(item.SubItems(ApbPageField.Path).Text)) Then
                isPdfUnavailabe = True
                pdfItem = New ListViewItem(item.SubItems(ApbPageField.ApID).Text)
                pdfItem.SubItems.Add(item.SubItems(ApbPageField.DocumentName).Text)
                pdfItem.SubItems.Add(item.SubItems(ApbPageField.JobID).Text)
                pdfItem.SubItems.Add(item.Index.ToString)
                mNotifyPdfMissing.lvwApb.Items.Add(pdfItem)
            End If
        Next

        Me.Cursor = Cursors.Default

        If (mNotifyPdfMissing.lvwApb.Items.Count > 0) Then
            With mNotifyPdfMissing
                .lvwApb.SortColumn = NotifyPdfMissing.ListField.DocumentName
                .lvwApb.SortOrder = NRC.WinForms.SortOrder.Ascend
                Dim result As DialogResult = .ShowDialog(Me)
                Select Case result
                    Case DialogResult.OK
                        For Each pdfItem In mNotifyPdfMissing.lvwApb.Items
                            itemIndex = CInt(pdfItem.SubItems(NotifyPdfMissing.ListField.ItemIndex).Text)
                            Me.lvwApbPageApbList.Items(itemIndex).Checked = False
                        Next
                    Case DialogResult.Cancel
                        cancelMove = True
                        Return
                    Case Else
                        cancelMove = True
                        Return
                End Select
            End With
        End If

        'Check if any AP is selected
        Dim checkedItemCount As Integer = lvwApbPageApbList.CheckedItems.Count
        If (checkedItemCount <= 0) Then
            MessageBox.Show("No APB report is selected to post", "Action Plan Builder Report Post Wizard", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cancelMove = True
            Return
        End If

        'Pass the selected APs to controller
        Dim jobList(checkedItemCount - 1) As Integer
        Dim i As Integer = 0
        For Each item In lvwApbPageApbList.CheckedItems
            jobList(i) = CInt(item.SubItems(ApbPageField.JobID).Text)
            i += 1
        Next
        mController.JobList = jobList
    End Sub

    Private Sub ValidatePageVerifyGroup(ByVal currentStep As Integer, ByRef cancelMove As Boolean)
    End Sub

#End Region

#Region " Private Methods for overall"

    Private Sub InitWizardStepInfo()
        mWizardData(WizardStep.Start) = _
                    New MapWizardData(WizardStep.Start, pnlStepStart, lblStepStart, True, False, True, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.SelectApb) = _
                    New MapWizardData(WizardStep.SelectApb, pnlStepSelectApb, lblStepSelectApb, True, True, True, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.VerifyGroup) = _
                    New MapWizardData(WizardStep.VerifyGroup, pnlStepVerifyGroup, lblStepVerifyGroup, True, True, True, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.DuplicateCheck) = _
                    New MapWizardData(WizardStep.DuplicateCheck, pnlStepDuplicateCheck, lblStepDuplicateCheck, False, False, False, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.RepostCheck) = _
                    New MapWizardData(WizardStep.RepostCheck, pnlStepRepostCheck, lblStepRepostCheck, False, False, False, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Summary) = _
                    New MapWizardData(WizardStep.Summary, pnlStepPreview, lblStepPreview, True, True, True, False, CANCEL_BUTTON, BACK_BUTTON, "Post", FINISH_BUTTON)
        mWizardData(WizardStep.Posting) = _
                    New MapWizardData(WizardStep.Posting, pnlStepPosting, lblStepPosting, False, False, False, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Finish) = _
                    New MapWizardData(WizardStep.Finish, pnlStepFinish, lblStepFinish, False, False, False, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON, Color.Red)

    End Sub

    Private Sub ResetWizard()
        Dim i As Integer

        'Reset wizard step objects
        For i = 0 To mWizardData.Length - 1
            mWizardData(i).Reset()
        Next

    End Sub

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
        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
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

    Private Sub ListViewResize(ByVal lvw As ListView, ByVal resizableColumnIndex1 As Integer, ByVal proportion1 As Double, ByVal resizableColumnIndex2 As Integer, ByVal proportion2 As Double)
        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex1 AndAlso _
                    columnId <> resizableColumnIndex2) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            Dim width1 As Integer = CInt(Math.Round(width * proportion1 / (proportion1 + proportion2), 0))
            Dim width2 As Integer = width - width1
            If width1 < 50 Then width1 = 50
            .Columns(resizableColumnIndex1).Width = width1
            If width2 < 50 Then width2 = 50
            .Columns(resizableColumnIndex2).Width = width2
        End With

    End Sub

#End Region

#Region " Private Methods for Page <Select APB>"

    Private Sub InitializeApbPageData()
        InitializeApbPageNotify()
        InitializeApbPageGenerateDate()
        ShowApbPageClient()
        InitializeApbPageListview()
    End Sub

    Private Sub InitializeApbPageNotify()
        Dim notify As String
        Dim employeeName As String
        Dim item As ListBoxTextItem
        Dim index As Integer

        mTriggeredByProgram = True

        'Pull notify list
        Dim rdr As SqlDataReader = Me.mController.PullNotifyList

        'Draw notify list
        lstApbPageNotify.Items.Clear()
        Do While rdr.Read
            notify = CStr(rdr("Notify"))
            employeeName = CStr(rdr("EmployeeName"))
            item = New ListBoxTextItem(notify, employeeName)
            index = lstApbPageNotify.Items.Add(item)
            If (notify.ToUpper = CurrentUser.LoginName.ToUpper) Then
                lstApbPageNotify.SetSelected(index, True)
            End If
        Loop
        rdr.Close()

        If (lstApbPageNotify.Items.Count > 0 AndAlso lstApbPageNotify.SelectedIndex < 0) Then
            lstApbPageNotify.SetSelected(0, True)
        End If

        mTriggeredByProgram = False
    End Sub

    Private Sub InitializeApbPageGenerateDate()
        mTriggeredByProgram = True

        dtpApbPageGenerateDateBegin.Value = Date.Today
        dtpApbPageGenerateDateEnd.Value = Date.Today
        chkApbPageGenerateDateAll.Checked = False

        mTriggeredByProgram = False
    End Sub


    'Private Sub ResetData()
    '    InitializeApbPageData()
    '    ResetApbPageListview()
    'End Sub

    'Private Sub ResetApbPageDay()
    '    InitializeApbPageDay()
    'End Sub

    'Private Sub ResetApbPageNotify()
    '    Dim i As Integer
    '    Dim item As ListBoxTextItem

    '    For i = 0 To lstApbPageNotify.Items.Count - 1
    '        item = CType(lstApbPageNotify.Items(i), ListBoxTextItem)
    '        If (item.Value.ToUpper = modMain.CurrentUser.LoginName.ToUpper) Then
    '            lstApbPageNotify.SetSelected(i, True)
    '            Exit For
    '        End If
    '    Next
    '    If (lstApbPageNotify.Items.Count > 0 AndAlso lstApbPageNotify.SelectedIndex < 0) Then
    '        lstApbPageNotify.SetSelected(0, True)
    '    End If
    'End Sub

    Private Sub InitializeApbPageListview()
        lvwApbPageApbList.Items.Clear()
        lblApbPageTotalCount.Text = ""
        lblApbPageSelectCount.Text = ""
    End Sub

    Private Sub ShowApbPageClient()
        Dim item As ListBoxItem
        Dim clientID As Integer
        Dim clientName As String
        Dim rdr As SqlDataReader = Me.mController.PullClientList()

        lstApbPageClient.BeginUpdate()

        lstApbPageClient.Items.Clear()
        Do While rdr.Read
            clientID = CInt(rdr("Client_ID"))
            clientName = CStr(rdr("ClientName"))
            item = New ListBoxItem(clientID, clientName)
            lstApbPageClient.Items.Add(item)
        Loop
        rdr.Close()

        If (lstApbPageClient.Items.Count > 0) Then
            lstApbPageClient.SetSelected(0, True)
        End If
        lstApbPageClient.EndUpdate()
    End Sub

    'Private Sub DefaultPageSelectApbSelection()
    '    If (lstApbPageNotify.Items.Count > 0 AndAlso lstApbPageNotify.SelectedIndex < 0) Then
    '        lstApbPageNotify.SetSelected(0, True)
    '    End If
    '    If (lstApbPageClient.Items.Count > 0 AndAlso lstApbPageClient.SelectedIndex < 0) Then
    '        lstApbPageClient.SetSelected(0, True)
    '    End If
    'End Sub

#End Region

#Region " Private Methods for Page <Select Group>"

    Private Sub DrawGroupPageApbTabularApbList()
        mTriggeredByProgram = True
        lvwGroupPageApb1.Items.Clear()
        lvwGroupPageGroup1.Items.Clear()
        mTriggeredByProgram = False

        Dim reports As ApbReportCollection = mController.Reports
        If (reports Is Nothing) Then Return
        Dim report As ApbReport
        Dim itmListItem As ListViewItem

        'Show APB list
        mTriggeredByProgram = True
        lvwGroupPageApb1.BeginUpdate()
        For Each report In reports.Values
            itmListItem = New ListViewItem
            itmListItem.Checked = report.DoPost
            itmListItem.ImageIndex = 0
            itmListItem.Text = report.ApID
            itmListItem.SubItems.Add(report.DocumentName)
            itmListItem.SubItems.Add(report.DateRangeBegin.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.DateRangeEnd.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.Url)
            itmListItem.SubItems.Add(report.JobID.ToString)
            lvwGroupPageApb1.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwGroupPageApb1
            .ListViewItemSorter = New ListViewComparer(Me.mListViewApb1Sort)
            .Sort()
            .Columns(Me.mListViewApb1Sort.SortColumn).Text = _
                mApb1ColumnText(Me.mListViewApb1Sort.SortColumn) + mListViewApb1Sort.SortOrderIcon
        End With

        lvwGroupPageApb1.EndUpdate()
        mTriggeredByProgram = False

        If (lvwGroupPageApb1.Items.Count > 0) Then
            lvwGroupPageApb1.Items(0).Selected = True
        End If

    End Sub

    Private Sub DrawGroupPageApbTabularGroupList()
        mTriggeredByProgram = True
        lvwGroupPageGroup1.Items.Clear()
        mTriggeredByProgram = False

        If (lvwGroupPageApb1.SelectedItems.Count <= 0) Then Return

        'Find the selected ApbReport object
        Dim item As ListViewItem = lvwGroupPageApb1.SelectedItems(0)
        Dim apID As String = item.SubItems(GroupPageApbField.ApID).Text
        Dim report As ApbReport = Me.mController.Reports(apID)
        Dim groups As ApbGroupCollection = report.Groups
        Dim group As ApbGroup
        Dim itmListItem As ListViewItem

        'Show ApbGroup objects in the group list
        mTriggeredByProgram = True
        lvwGroupPageGroup1.BeginUpdate()
        For Each group In groups.Values
            mTriggeredByProgram = True
            itmListItem = New ListViewItem
            itmListItem.Checked = group.DoPost
            itmListItem.Text = group.GroupID.ToString
            itmListItem.SubItems.Add(group.GroupName)
            itmListItem.SubItems.Add(apID)
            lvwGroupPageGroup1.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwGroupPageGroup1
            .ListViewItemSorter = New ListViewComparer(Me.mListViewGroup1Sort)
            .Sort()
            .Columns(Me.mListViewGroup1Sort.SortColumn).Text = _
                mGroup1ColumnText(Me.mListViewGroup1Sort.SortColumn) + mListViewGroup1Sort.SortOrderIcon
        End With

        lvwGroupPageGroup1.EndUpdate()
        mTriggeredByProgram = False
    End Sub

    Private Sub DrawGroupPageGroupTabularGroupList()
        mTriggeredByProgram = True
        lvwGroupPageGroup2.Items.Clear()
        lvwGroupPageApb2.Items.Clear()
        mTriggeredByProgram = False

        Dim groupListItems As ApbGroupListItemCollection = Me.mController.GroupListItems
        If (groupListItems Is Nothing) Then Return
        Dim groupItem As ApbGroupListItem
        Dim itmListItem As ListViewItem

        mTriggeredByProgram = True
        lvwGroupPageGroup2.BeginUpdate()
        For Each groupItem In groupListItems.Values
            mTriggeredByProgram = True
            itmListItem = New ListViewItem
            itmListItem.Checked = groupItem.DoPost
            itmListItem.Text = groupItem.GroupID.ToString
            itmListItem.SubItems.Add(groupItem.GroupName)
            lvwGroupPageGroup2.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwGroupPageGroup2
            .ListViewItemSorter = New ListViewComparer(Me.mListViewGroup2Sort)
            .Sort()
            .Columns(Me.mListViewGroup2Sort.SortColumn).Text = _
                mGroup2ColumnText(Me.mListViewGroup2Sort.SortColumn) + mListViewGroup2Sort.SortOrderIcon
        End With

        lvwGroupPageGroup2.EndUpdate()
        mTriggeredByProgram = False

        If (lvwGroupPageGroup2.Items.Count > 0) Then
            lvwGroupPageGroup2.Items(0).Selected = True
        End If

    End Sub

    Private Sub DrawGroupPageGroupTabularApbList()
        mTriggeredByProgram = True
        lvwGroupPageApb2.Items.Clear()
        mTriggeredByProgram = False

        If (lvwGroupPageGroup2.SelectedItems.Count <= 0) Then Return

        'Find the selected ApbGroupListItem object
        Dim item As ListViewItem = lvwGroupPageGroup2.SelectedItems(0)
        Dim groupID As Integer = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        Dim reports As ApbReportCollection = groupListItem.Reports
        Dim report As ApbReport
        Dim itmListItem As ListViewItem

        'Show APB list
        mTriggeredByProgram = True
        lvwGroupPageApb2.BeginUpdate()
        For Each report In reports.Values
            itmListItem = New ListViewItem
            itmListItem.Checked = report.DoPost(groupID)
            itmListItem.ImageIndex = 0
            itmListItem.Text = report.ApID
            itmListItem.SubItems.Add(report.DocumentName)
            itmListItem.SubItems.Add(report.DateRangeBegin.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.DateRangeEnd.ToString("MM/dd/yy"))
            itmListItem.SubItems.Add(report.Url)
            itmListItem.SubItems.Add(report.JobID.ToString)
            itmListItem.SubItems.Add(groupID.ToString)
            lvwGroupPageApb2.Items.Add(itmListItem)
        Next

        'Set sorting criteria
        With lvwGroupPageApb2
            .ListViewItemSorter = New ListViewComparer(Me.mListViewApb2Sort)
            .Sort()
            .Columns(Me.mListViewApb2Sort.SortColumn).Text = _
                mApb2ColumnText(Me.mListViewApb2Sort.SortColumn) + mListViewApb2Sort.SortOrderIcon
        End With

        lvwGroupPageApb2.EndUpdate()
        mTriggeredByProgram = False

    End Sub

    Private Sub SetGroupPageAllCheckBoxes(ByVal checked As Boolean)
        Dim report As ApbReport
        Dim group As ApbGroup
        For Each report In Me.mController.Reports.Values
            For Each group In report.Groups.Values
                group.DoPost = checked
            Next
        Next
        tabGroupPageTabular_SelectedIndexChanged(Nothing, Nothing)
    End Sub

    Private Sub RefreshCheckBoxes()
        If (tabGroupPageGrouping.SelectedIndex = GroupPageTabular.GroupByApb) Then
            RefreshApbTabCheckBoxes()
        Else
            RefreshGroupTabCheckBoxes()
        End If
    End Sub

    Private Sub RefreshApbTabCheckBoxes()
        Dim item As ListViewItem
        Dim apID As String
        Dim report As ApbReport
        Dim groupID As Integer
        Dim group As ApbGroup

        Me.mTriggeredByProgram = True

        'Set lvwApb1
        For Each item In lvwGroupPageApb1.Items
            apID = item.SubItems(GroupPageApbField.ApID).Text
            item.Checked = Me.mController.Reports(apID).DoPost
        Next

        'Set lvwGroup1
        apID = lvwGroupPageGroup1.Items(0).SubItems(GroupPageGroupField.ApID).Text
        report = Me.mController.Reports(apID)
        If (report Is Nothing) Then
            Me.mTriggeredByProgram = False
            Return
        End If
        For Each item In lvwGroupPageGroup1.Items
            groupID = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
            group = report.Groups(groupID)
            If (Not group Is Nothing) Then item.Checked = group.DoPost
        Next

        Me.mTriggeredByProgram = False
    End Sub

    Private Sub RefreshGroupTabCheckBoxes()
        Dim item As ListViewItem
        Dim groupID As Integer
        Dim groupListItem As ApbGroupListItem
        Dim apID As String
        Dim report As ApbReport

        Me.mTriggeredByProgram = True

        'Set lvwGroup2
        For Each item In lvwGroupPageGroup2.Items
            groupID = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
            item.Checked = Me.mController.GroupListItems(groupID).DoPost
        Next

        'Set lvwApb2
        groupID = CInt(lvwGroupPageApb2.Items(0).SubItems(GroupPageApbField.GroupID).Text)
        groupListItem = Me.mController.GroupListItems(groupID)
        If (groupListItem Is Nothing) Then
            Me.mTriggeredByProgram = False
            Return
        End If
        For Each item In lvwGroupPageApb2.Items
            apID = item.SubItems(GroupPageApbField.ApID).Text
            report = groupListItem.Reports(apID)
            If (Not report Is Nothing) Then item.Checked = report.DoPost(groupID)
        Next

        Me.mTriggeredByProgram = False

    End Sub

#Region " Private methods for selecting report/group"

    Private Sub SelectAllApbAndGroup(ByVal checked As Boolean)
        Dim report As ApbReport
        For Each report In Me.mController.Reports.Values
            report.DoPost = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectApbTabHighlightedApb(ByVal checked As Boolean)
        Dim item As ListViewItem
        Dim apID As String
        Dim report As ApbReport

        For Each item In lvwGroupPageApb1.SelectedItems
            apID = item.SubItems(GroupPageApbField.ApID).Text
            report = Me.mController.Reports(apID)
            If (Not report Is Nothing) Then report.DoPost = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectApbTabAllGroup(ByVal checked As Boolean)
        If lvwGroupPageGroup1.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwGroupPageGroup1.Items(0)
        Dim apID As String = item.SubItems(GroupPageGroupField.ApID).Text
        Dim report As ApbReport = Me.mController.Reports(apID)
        If (report Is Nothing) Then Return
        report.DoPost = checked
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectApbTabHighlightedGroup(ByVal checked As Boolean)
        If lvwGroupPageGroup1.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwGroupPageGroup1.Items(0)
        Dim apID As String = item.SubItems(GroupPageGroupField.ApID).Text
        Dim report As ApbReport = Me.mController.Reports(apID)
        If (report Is Nothing) Then Return
        Dim groupID As Integer
        Dim group As ApbGroup

        For Each item In lvwGroupPageGroup1.SelectedItems
            groupID = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
            group = report.Groups(groupID)
            If (Not group Is Nothing) Then group.DoPost = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectGroupTabHighlightedGroup(ByVal checked As Boolean)
        Dim item As ListViewItem
        Dim groupID As Integer
        Dim groupListItem As ApbGroupListItem

        For Each item In lvwGroupPageGroup2.SelectedItems
            groupID = CInt(item.SubItems(GroupPageGroupField.GroupID).Text)
            groupListItem = Me.mController.GroupListItems(groupID)
            If (Not groupListItem Is Nothing) Then groupListItem.DoPost = checked
        Next
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectGroupTabAllApb(ByVal checked As Boolean)
        If lvwGroupPageApb2.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwGroupPageApb2.Items(0)
        Dim groupID As Integer = CInt(item.SubItems(GroupPageApbField.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        If (groupListItem Is Nothing) Then Return
        groupListItem.DoPost = checked
        RefreshCheckBoxes()
    End Sub

    Private Sub SelectGroupTabHighlightedApb(ByVal checked As Boolean)
        If lvwGroupPageApb2.Items.Count = 0 Then Return
        Dim item As ListViewItem = lvwGroupPageApb2.Items(0)
        Dim groupID As Integer = CInt(item.SubItems(GroupPageApbField.GroupID).Text)
        Dim groupListItem As ApbGroupListItem = Me.mController.GroupListItems(groupID)
        If (groupListItem Is Nothing) Then Return
        Dim apID As String
        Dim report As ApbReport

        For Each item In lvwGroupPageApb2.SelectedItems
            apID = item.SubItems(GroupPageApbField.ApID).Text
            report = groupListItem.Reports(apID)
            If (Not report Is Nothing) Then report.DoPost = checked
        Next
        RefreshCheckBoxes()
    End Sub

#End Region

#End Region

#Region " Private Methods for Page <Posting>"

    Private Sub Post()
        Me.mController.Post()
        'Dim i As Integer
        'i = i + 1
    End Sub

#End Region

#Region " Debug"

    Private Sub ShowMessage()
        If (Me.mController.Reports Is Nothing) Then Return
        Dim msg As String = ""
        Dim report As ApbReport
        For Each report In Me.mController.Reports.Values
            msg += "(" + report.ApID + ") DoPost = " + report.DoPost.ToString + vbCrLf
            Dim group As ApbGroup
            For Each group In report.Groups.Values
                msg += "    " & group.GroupID & " checked = " + group.DoPost.ToString + vbCrLf
            Next
        Next

        msg += vbCrLf
        Dim groupItem As ApbGroupListItem
        Dim groupID As Integer
        For Each groupItem In Me.mController.GroupListItems.Values
            groupID = groupItem.GroupID
            msg += "[" & groupID & "] checked = " + groupItem.DoPost.ToString + vbCrLf
            For Each report In groupItem.Reports.Values
                msg += "  (" + report.ApID + ") checked = " + report.DoPost(groupID).ToString + vbCrLf
                Dim group As ApbGroup
                group = report.Groups(groupID)
                If (Not group Is Nothing) Then
                    msg += "    " & group.GroupID & " checked = " + group.DoPost.ToString + vbCrLf
                End If
            Next
        Next

        MessageBox.Show(msg)
    End Sub


#End Region

    Private Sub dtpApbPageGenerateDateBegin_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dtpApbPageGenerateDateBegin.ValueChanged
        ApbPageGetGenerateDate()
    End Sub

    Private Sub dtpApbPageGenerateDateEnd_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dtpApbPageGenerateDateEnd.ValueChanged
        ApbPageGetGenerateDate()
    End Sub

    Private Sub chkApbPageGenerateDateAll_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkApbPageGenerateDateAll.CheckedChanged
        If (chkApbPageGenerateDateAll.Checked) Then
            dtpApbPageGenerateDateBegin.Enabled = False
            dtpApbPageGenerateDateEnd.Enabled = False
        Else
            dtpApbPageGenerateDateBegin.Enabled = True
            dtpApbPageGenerateDateEnd.Enabled = True
        End If
        ApbPageGetGenerateDate()
    End Sub

    Private Sub ApbPageGetGenerateDate()
        Dim generateDateBegin As DateTime
        Dim generateDateEnd As DateTime

        If (chkApbPageGenerateDateAll.Checked) Then
            generateDateBegin = New Date(1900, 1, 1)
            generateDateEnd = New Date(2999, 12, 31)
        Else
            generateDateBegin = dtpApbPageGenerateDateBegin.Value
            generateDateEnd = dtpApbPageGenerateDateEnd.Value
        End If
        Me.mController.JobGenerateDate = New DateRange(generateDateBegin, generateDateEnd)

        If (Not Me.mTriggeredByProgram) Then ShowApbPageClient()
    End Sub

    Private Sub lstApbPageClient_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstApbPageClient.SelectedIndexChanged
        If (lstApbPageClient.SelectedIndex < 0) Then Return
        Me.mController.ClientID = CType(lstApbPageClient.SelectedItem, ListBoxItem).Value
    End Sub

    Private Sub ApbPageShowSelectCount()
        lblApbPageSelectCount.Text = lvwApbPageApbList.CheckedItems.Count.ToString
    End Sub
End Class
