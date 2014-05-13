Option Explicit On 
Option Strict On

Imports System.Text

Public Class frmTextWizard
    Inherits System.Windows.Forms.Form

#Region " Private Constants "

    Private Const FORMAT_TAB As Integer = 0
    Private Const DELIMITED_TAB As Integer = 1
    Private Const FIXED_TAB As Integer = 2
    Private Const FIELD_TAB As Integer = 3

    Private Const STEP_FORMAT As Integer = 0
    Private Const STEP_BREAK As Integer = 1
    Private Const STEP_FIELD As Integer = 2

    Private Const STEP_NUMBER As Integer = 3

    Private Const TEXT_QUALIFIER_NONE As Integer = 2
#End Region

#Region " Private Members "

    Private mTextDataCtrl As TextDataCtrl
    Private WithEvents mWizardCtrl As New Wizard(STEP_NUMBER)

#End Region

#Region " Public Properties "

    Public Property TextDataCtrl() As TextDataCtrl
        Get
            Return (mTextDataCtrl)
        End Get
        Set(ByVal Value As TextDataCtrl)
            mTextDataCtrl = Value
        End Set
    End Property

#End Region

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
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
    Friend WithEvents btnNext As System.Windows.Forms.Button
    Friend WithEvents btnBack As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents FormatTab As System.Windows.Forms.TabPage
    Friend WithEvents Tab1Msg As System.Windows.Forms.Label
    Friend WithEvents DelimitedTab As System.Windows.Forms.TabPage
    Friend WithEvents FixedTab As System.Windows.Forms.TabPage
    Friend WithEvents FieldTab As System.Windows.Forms.TabPage
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents optTab2Tab As System.Windows.Forms.RadioButton
    Friend WithEvents optTab2Semicolon As System.Windows.Forms.RadioButton
    Friend WithEvents optTab2Comma As System.Windows.Forms.RadioButton
    Friend WithEvents optTab2Space As System.Windows.Forms.RadioButton
    Friend WithEvents optTab2Other As System.Windows.Forms.RadioButton
    Friend WithEvents txtTab2OtherDelimiter As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents optTab1FixedRadio As System.Windows.Forms.RadioButton
    Friend WithEvents optTab1DelimitedRadio As System.Windows.Forms.RadioButton
    Friend WithEvents ctlTab2TextColumn As Nrc.Qualisys.QLoader.Library.TextColumn
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents ctlTab4TextColumn As Nrc.Qualisys.QLoader.Library.TextColumn
    Friend WithEvents txtTab1TextView As System.Windows.Forms.TextBox
    Friend WithEvents tabWizard As System.Windows.Forms.TabControl
    Friend WithEvents cboTab2Qualifier As System.Windows.Forms.ComboBox
    Friend WithEvents chkTab2HasHeader As System.Windows.Forms.CheckBox
    Friend WithEvents ctlTab3FixedTextUtil As Nrc.Qualisys.QLoader.Library.FixedTextColumns
    Friend WithEvents tmrTimer As System.Windows.Forms.Timer
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents lblTab4ColumnLength As System.Windows.Forms.Label
    Friend WithEvents ofdProfile As System.Windows.Forms.OpenFileDialog
    Friend WithEvents txtTab4ColumnName As Nrc.Qualisys.QLoader.Library.MyTextBox
    Friend WithEvents btnTab1Profile As System.Windows.Forms.LinkLabel
    Friend WithEvents btnTab4ExportProfile As System.Windows.Forms.LinkLabel
    Friend WithEvents sfdProfile As System.Windows.Forms.SaveFileDialog
    Friend WithEvents PaneCaption1 As NRC.Framework.WinForms.PaneCaption
    Friend WithEvents pnlRight As System.Windows.Forms.Panel
    Friend WithEvents pnlLeft As System.Windows.Forms.Panel
    Friend WithEvents pnlBottom As System.Windows.Forms.Panel
    Friend WithEvents optTab3ZeroBased As System.Windows.Forms.RadioButton
    Friend WithEvents optTab3OneBased As System.Windows.Forms.RadioButton
    Friend WithEvents GroupBox5 As System.Windows.Forms.GroupBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.btnNext = New System.Windows.Forms.Button
        Me.btnBack = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.tabWizard = New System.Windows.Forms.TabControl
        Me.FormatTab = New System.Windows.Forms.TabPage
        Me.btnTab1Profile = New System.Windows.Forms.LinkLabel
        Me.txtTab1TextView = New System.Windows.Forms.TextBox
        Me.Tab1Msg = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.optTab1FixedRadio = New System.Windows.Forms.RadioButton
        Me.optTab1DelimitedRadio = New System.Windows.Forms.RadioButton
        Me.DelimitedTab = New System.Windows.Forms.TabPage
        Me.ctlTab2TextColumn = New Nrc.Qualisys.QLoader.Library.TextColumn
        Me.cboTab2Qualifier = New System.Windows.Forms.ComboBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.chkTab2HasHeader = New System.Windows.Forms.CheckBox
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.txtTab2OtherDelimiter = New System.Windows.Forms.TextBox
        Me.optTab2Other = New System.Windows.Forms.RadioButton
        Me.optTab2Space = New System.Windows.Forms.RadioButton
        Me.optTab2Comma = New System.Windows.Forms.RadioButton
        Me.optTab2Semicolon = New System.Windows.Forms.RadioButton
        Me.optTab2Tab = New System.Windows.Forms.RadioButton
        Me.Label5 = New System.Windows.Forms.Label
        Me.FixedTab = New System.Windows.Forms.TabPage
        Me.optTab3OneBased = New System.Windows.Forms.RadioButton
        Me.optTab3ZeroBased = New System.Windows.Forms.RadioButton
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.ctlTab3FixedTextUtil = New Nrc.Qualisys.QLoader.Library.FixedTextColumns
        Me.FieldTab = New System.Windows.Forms.TabPage
        Me.btnTab4ExportProfile = New System.Windows.Forms.LinkLabel
        Me.ctlTab4TextColumn = New Nrc.Qualisys.QLoader.Library.TextColumn
        Me.GroupBox4 = New System.Windows.Forms.GroupBox
        Me.txtTab4ColumnName = New Nrc.Qualisys.QLoader.Library.MyTextBox
        Me.lblTab4ColumnLength = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.tmrTimer = New System.Windows.Forms.Timer(Me.components)
        Me.ofdProfile = New System.Windows.Forms.OpenFileDialog
        Me.sfdProfile = New System.Windows.Forms.SaveFileDialog
        Me.pnlRight = New System.Windows.Forms.Panel
        Me.pnlLeft = New System.Windows.Forms.Panel
        Me.PaneCaption1 = New NRC.Framework.WinForms.PaneCaption
        Me.pnlBottom = New System.Windows.Forms.Panel
        Me.GroupBox5 = New System.Windows.Forms.GroupBox
        Me.tabWizard.SuspendLayout()
        Me.FormatTab.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.DelimitedTab.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.FixedTab.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.FieldTab.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        Me.GroupBox5.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnNext
        '
        Me.btnNext.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnNext.Location = New System.Drawing.Point(576, 408)
        Me.btnNext.Name = "btnNext"
        Me.btnNext.TabIndex = 7
        Me.btnNext.Text = "&Next >"
        '
        'btnBack
        '
        Me.btnBack.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnBack.Location = New System.Drawing.Point(496, 408)
        Me.btnBack.Name = "btnBack"
        Me.btnBack.TabIndex = 6
        Me.btnBack.Text = "< &Back"
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(416, 408)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 5
        Me.btnCancel.Text = "&Cancel"
        '
        'tabWizard
        '
        Me.tabWizard.Controls.Add(Me.FormatTab)
        Me.tabWizard.Controls.Add(Me.DelimitedTab)
        Me.tabWizard.Controls.Add(Me.FixedTab)
        Me.tabWizard.Controls.Add(Me.FieldTab)
        Me.tabWizard.Location = New System.Drawing.Point(16, 24)
        Me.tabWizard.Name = "tabWizard"
        Me.tabWizard.SelectedIndex = 0
        Me.tabWizard.Size = New System.Drawing.Size(664, 376)
        Me.tabWizard.TabIndex = 4
        '
        'FormatTab
        '
        Me.FormatTab.Controls.Add(Me.btnTab1Profile)
        Me.FormatTab.Controls.Add(Me.txtTab1TextView)
        Me.FormatTab.Controls.Add(Me.Tab1Msg)
        Me.FormatTab.Controls.Add(Me.Label1)
        Me.FormatTab.Controls.Add(Me.GroupBox1)
        Me.FormatTab.Location = New System.Drawing.Point(4, 22)
        Me.FormatTab.Name = "FormatTab"
        Me.FormatTab.Size = New System.Drawing.Size(656, 350)
        Me.FormatTab.TabIndex = 0
        Me.FormatTab.Text = "FormatTab"
        '
        'btnTab1Profile
        '
        Me.btnTab1Profile.BackColor = System.Drawing.Color.Transparent
        Me.btnTab1Profile.Location = New System.Drawing.Point(552, 24)
        Me.btnTab1Profile.Name = "btnTab1Profile"
        Me.btnTab1Profile.Size = New System.Drawing.Size(80, 16)
        Me.btnTab1Profile.TabIndex = 8
        Me.btnTab1Profile.TabStop = True
        Me.btnTab1Profile.Text = "Load Profile..."
        Me.btnTab1Profile.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtTab1TextView
        '
        Me.txtTab1TextView.BackColor = System.Drawing.Color.White
        Me.txtTab1TextView.CausesValidation = False
        Me.txtTab1TextView.Cursor = System.Windows.Forms.Cursors.Arrow
        Me.txtTab1TextView.Font = New System.Drawing.Font("Courier New", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTab1TextView.Location = New System.Drawing.Point(24, 168)
        Me.txtTab1TextView.MaxLength = 0
        Me.txtTab1TextView.Multiline = True
        Me.txtTab1TextView.Name = "txtTab1TextView"
        Me.txtTab1TextView.ReadOnly = True
        Me.txtTab1TextView.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtTab1TextView.Size = New System.Drawing.Size(608, 168)
        Me.txtTab1TextView.TabIndex = 3
        Me.txtTab1TextView.Text = ""
        Me.txtTab1TextView.WordWrap = False
        '
        'Tab1Msg
        '
        Me.Tab1Msg.Location = New System.Drawing.Point(24, 140)
        Me.Tab1Msg.Name = "Tab1Msg"
        Me.Tab1Msg.Size = New System.Drawing.Size(608, 24)
        Me.Tab1Msg.TabIndex = 2
        Me.Tab1Msg.TextAlign = System.Drawing.ContentAlignment.BottomLeft
        '
        'Label1
        '
        Me.Label1.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label1.Location = New System.Drawing.Point(24, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(416, 16)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Choose the format that describes your data."
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.optTab1FixedRadio)
        Me.GroupBox1.Controls.Add(Me.optTab1DelimitedRadio)
        Me.GroupBox1.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.GroupBox1.Location = New System.Drawing.Point(24, 48)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(608, 72)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'optTab1FixedRadio
        '
        Me.optTab1FixedRadio.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab1FixedRadio.Location = New System.Drawing.Point(16, 40)
        Me.optTab1FixedRadio.Name = "optTab1FixedRadio"
        Me.optTab1FixedRadio.Size = New System.Drawing.Size(408, 24)
        Me.optTab1FixedRadio.TabIndex = 1
        Me.optTab1FixedRadio.Text = "Fixed &Width - Fields are aligned in columns with spaces between each field"
        '
        'optTab1DelimitedRadio
        '
        Me.optTab1DelimitedRadio.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab1DelimitedRadio.Location = New System.Drawing.Point(16, 16)
        Me.optTab1DelimitedRadio.Name = "optTab1DelimitedRadio"
        Me.optTab1DelimitedRadio.Size = New System.Drawing.Size(408, 24)
        Me.optTab1DelimitedRadio.TabIndex = 0
        Me.optTab1DelimitedRadio.Text = "&Delimited - Characters such as comma or tab separate each field"
        '
        'DelimitedTab
        '
        Me.DelimitedTab.Controls.Add(Me.ctlTab2TextColumn)
        Me.DelimitedTab.Controls.Add(Me.cboTab2Qualifier)
        Me.DelimitedTab.Controls.Add(Me.Label6)
        Me.DelimitedTab.Controls.Add(Me.chkTab2HasHeader)
        Me.DelimitedTab.Controls.Add(Me.GroupBox3)
        Me.DelimitedTab.Controls.Add(Me.Label5)
        Me.DelimitedTab.Location = New System.Drawing.Point(4, 22)
        Me.DelimitedTab.Name = "DelimitedTab"
        Me.DelimitedTab.Size = New System.Drawing.Size(656, 350)
        Me.DelimitedTab.TabIndex = 1
        Me.DelimitedTab.Text = "DelimitedTab"
        Me.DelimitedTab.Visible = False
        '
        'ctlTab2TextColumn
        '
        Me.ctlTab2TextColumn.CanSelectColumn = False
        Me.ctlTab2TextColumn.Columns = Nothing
        Me.ctlTab2TextColumn.DrawColumnBorder = True
        Me.ctlTab2TextColumn.Font = New System.Drawing.Font("Courier New", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ctlTab2TextColumn.Location = New System.Drawing.Point(24, 152)
        Me.ctlTab2TextColumn.Name = "ctlTab2TextColumn"
        Me.ctlTab2TextColumn.SelectedColumn = -1
        Me.ctlTab2TextColumn.SelectedColumnName = ""
        Me.ctlTab2TextColumn.ShowHeader = False
        Me.ctlTab2TextColumn.Size = New System.Drawing.Size(608, 184)
        Me.ctlTab2TextColumn.TabIndex = 6
        '
        'cboTab2Qualifier
        '
        Me.cboTab2Qualifier.Items.AddRange(New Object() {"'", """", "{none}"})
        Me.cboTab2Qualifier.Location = New System.Drawing.Point(568, 110)
        Me.cboTab2Qualifier.MaxLength = 1
        Me.cboTab2Qualifier.Name = "cboTab2Qualifier"
        Me.cboTab2Qualifier.Size = New System.Drawing.Size(64, 21)
        Me.cboTab2Qualifier.TabIndex = 5
        '
        'Label6
        '
        Me.Label6.Location = New System.Drawing.Point(472, 112)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(80, 16)
        Me.Label6.TabIndex = 4
        Me.Label6.Text = "Text &Qualifier:"
        '
        'chkTab2HasHeader
        '
        Me.chkTab2HasHeader.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.chkTab2HasHeader.Location = New System.Drawing.Point(24, 108)
        Me.chkTab2HasHeader.Name = "chkTab2HasHeader"
        Me.chkTab2HasHeader.Size = New System.Drawing.Size(200, 24)
        Me.chkTab2HasHeader.TabIndex = 3
        Me.chkTab2HasHeader.Text = "First &Row Contains Field Names"
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.txtTab2OtherDelimiter)
        Me.GroupBox3.Controls.Add(Me.optTab2Other)
        Me.GroupBox3.Controls.Add(Me.optTab2Space)
        Me.GroupBox3.Controls.Add(Me.optTab2Comma)
        Me.GroupBox3.Controls.Add(Me.optTab2Semicolon)
        Me.GroupBox3.Controls.Add(Me.optTab2Tab)
        Me.GroupBox3.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.GroupBox3.Location = New System.Drawing.Point(24, 56)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(608, 48)
        Me.GroupBox3.TabIndex = 2
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Choose the delimiter that separates your fields:"
        '
        'txtTab2OtherDelimiter
        '
        Me.txtTab2OtherDelimiter.Location = New System.Drawing.Point(528, 16)
        Me.txtTab2OtherDelimiter.MaxLength = 1
        Me.txtTab2OtherDelimiter.Name = "txtTab2OtherDelimiter"
        Me.txtTab2OtherDelimiter.Size = New System.Drawing.Size(24, 20)
        Me.txtTab2OtherDelimiter.TabIndex = 5
        Me.txtTab2OtherDelimiter.Text = ""
        '
        'optTab2Other
        '
        Me.optTab2Other.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab2Other.Location = New System.Drawing.Point(472, 16)
        Me.optTab2Other.Name = "optTab2Other"
        Me.optTab2Other.Size = New System.Drawing.Size(56, 24)
        Me.optTab2Other.TabIndex = 4
        Me.optTab2Other.Text = "&Other:"
        '
        'optTab2Space
        '
        Me.optTab2Space.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab2Space.Location = New System.Drawing.Point(368, 16)
        Me.optTab2Space.Name = "optTab2Space"
        Me.optTab2Space.Size = New System.Drawing.Size(56, 24)
        Me.optTab2Space.TabIndex = 3
        Me.optTab2Space.Text = "S&pace"
        '
        'optTab2Comma
        '
        Me.optTab2Comma.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab2Comma.Location = New System.Drawing.Point(248, 16)
        Me.optTab2Comma.Name = "optTab2Comma"
        Me.optTab2Comma.Size = New System.Drawing.Size(64, 24)
        Me.optTab2Comma.TabIndex = 2
        Me.optTab2Comma.Text = "&Comma"
        '
        'optTab2Semicolon
        '
        Me.optTab2Semicolon.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab2Semicolon.Location = New System.Drawing.Point(112, 16)
        Me.optTab2Semicolon.Name = "optTab2Semicolon"
        Me.optTab2Semicolon.Size = New System.Drawing.Size(80, 24)
        Me.optTab2Semicolon.TabIndex = 1
        Me.optTab2Semicolon.Text = "&Semicolon"
        '
        'optTab2Tab
        '
        Me.optTab2Tab.Checked = True
        Me.optTab2Tab.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.optTab2Tab.Location = New System.Drawing.Point(16, 16)
        Me.optTab2Tab.Name = "optTab2Tab"
        Me.optTab2Tab.Size = New System.Drawing.Size(48, 24)
        Me.optTab2Tab.TabIndex = 0
        Me.optTab2Tab.TabStop = True
        Me.optTab2Tab.Text = "&Tab"
        '
        'Label5
        '
        Me.Label5.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label5.Location = New System.Drawing.Point(24, 24)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(624, 16)
        Me.Label5.TabIndex = 1
        Me.Label5.Text = "What delimiter separates your fields? Select the appropriate delimiter and see ho" & _
        "w your text is affectd in the preview below."
        '
        'FixedTab
        '
        Me.FixedTab.Controls.Add(Me.GroupBox5)
        Me.FixedTab.Controls.Add(Me.GroupBox2)
        Me.FixedTab.Controls.Add(Me.ctlTab3FixedTextUtil)
        Me.FixedTab.Location = New System.Drawing.Point(4, 22)
        Me.FixedTab.Name = "FixedTab"
        Me.FixedTab.Size = New System.Drawing.Size(656, 350)
        Me.FixedTab.TabIndex = 2
        Me.FixedTab.Text = "FixedTab"
        Me.FixedTab.Visible = False
        '
        'optTab3OneBased
        '
        Me.optTab3OneBased.Location = New System.Drawing.Point(24, 48)
        Me.optTab3OneBased.Name = "optTab3OneBased"
        Me.optTab3OneBased.Size = New System.Drawing.Size(64, 24)
        Me.optTab3OneBased.TabIndex = 4
        Me.optTab3OneBased.Text = "1-Based"
        '
        'optTab3ZeroBased
        '
        Me.optTab3ZeroBased.Checked = True
        Me.optTab3ZeroBased.Location = New System.Drawing.Point(24, 24)
        Me.optTab3ZeroBased.Name = "optTab3ZeroBased"
        Me.optTab3ZeroBased.Size = New System.Drawing.Size(64, 24)
        Me.optTab3ZeroBased.TabIndex = 3
        Me.optTab3ZeroBased.TabStop = True
        Me.optTab3ZeroBased.Text = "0-Based"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.Label4)
        Me.GroupBox2.Controls.Add(Me.Label3)
        Me.GroupBox2.Controls.Add(Me.Label2)
        Me.GroupBox2.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.GroupBox2.Location = New System.Drawing.Point(24, 24)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(488, 80)
        Me.GroupBox2.TabIndex = 0
        Me.GroupBox2.TabStop = False
        '
        'Label4
        '
        Me.Label4.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label4.Location = New System.Drawing.Point(8, 56)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(256, 16)
        Me.Label4.TabIndex = 2
        Me.Label4.Text = "To DELETE a break line, double click on the line"
        '
        'Label3
        '
        Me.Label3.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label3.Location = New System.Drawing.Point(8, 16)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(128, 23)
        Me.Label3.TabIndex = 1
        Me.Label3.Text = "Lines signify field breaks"
        '
        'Label2
        '
        Me.Label2.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label2.Location = New System.Drawing.Point(8, 40)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(256, 16)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "To CREATE a break line, click at the desired position."
        '
        'ctlTab3FixedTextUtil
        '
        Me.ctlTab3FixedTextUtil.ColumnLengths = New Integer() {1}
        Me.ctlTab3FixedTextUtil.Font = New System.Drawing.Font("Courier New", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ctlTab3FixedTextUtil.Location = New System.Drawing.Point(24, 120)
        Me.ctlTab3FixedTextUtil.Name = "ctlTab3FixedTextUtil"
        Me.ctlTab3FixedTextUtil.Size = New System.Drawing.Size(608, 216)
        Me.ctlTab3FixedTextUtil.TabIndex = 1
        '
        'FieldTab
        '
        Me.FieldTab.Controls.Add(Me.btnTab4ExportProfile)
        Me.FieldTab.Controls.Add(Me.ctlTab4TextColumn)
        Me.FieldTab.Controls.Add(Me.GroupBox4)
        Me.FieldTab.Controls.Add(Me.Label7)
        Me.FieldTab.Location = New System.Drawing.Point(4, 22)
        Me.FieldTab.Name = "FieldTab"
        Me.FieldTab.Size = New System.Drawing.Size(656, 350)
        Me.FieldTab.TabIndex = 3
        Me.FieldTab.Text = "FieldTab"
        '
        'btnTab4ExportProfile
        '
        Me.btnTab4ExportProfile.BackColor = System.Drawing.Color.Transparent
        Me.btnTab4ExportProfile.Location = New System.Drawing.Point(528, 64)
        Me.btnTab4ExportProfile.Name = "btnTab4ExportProfile"
        Me.btnTab4ExportProfile.Size = New System.Drawing.Size(104, 16)
        Me.btnTab4ExportProfile.TabIndex = 9
        Me.btnTab4ExportProfile.TabStop = True
        Me.btnTab4ExportProfile.Text = "Export Profile..."
        Me.btnTab4ExportProfile.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'ctlTab4TextColumn
        '
        Me.ctlTab4TextColumn.CanSelectColumn = False
        Me.ctlTab4TextColumn.Columns = Nothing
        Me.ctlTab4TextColumn.DrawColumnBorder = True
        Me.ctlTab4TextColumn.Font = New System.Drawing.Font("Courier New", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ctlTab4TextColumn.Location = New System.Drawing.Point(24, 152)
        Me.ctlTab4TextColumn.Name = "ctlTab4TextColumn"
        Me.ctlTab4TextColumn.SelectedColumn = -1
        Me.ctlTab4TextColumn.SelectedColumnName = ""
        Me.ctlTab4TextColumn.ShowHeader = False
        Me.ctlTab4TextColumn.Size = New System.Drawing.Size(608, 184)
        Me.ctlTab4TextColumn.TabIndex = 2
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.txtTab4ColumnName)
        Me.GroupBox4.Controls.Add(Me.lblTab4ColumnLength)
        Me.GroupBox4.Controls.Add(Me.Label9)
        Me.GroupBox4.Controls.Add(Me.Label8)
        Me.GroupBox4.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.GroupBox4.Location = New System.Drawing.Point(24, 80)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(608, 56)
        Me.GroupBox4.TabIndex = 1
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Field Options"
        '
        'txtTab4ColumnName
        '
        Me.txtTab4ColumnName.Location = New System.Drawing.Point(72, 24)
        Me.txtTab4ColumnName.MaxLength = 128
        Me.txtTab4ColumnName.Name = "txtTab4ColumnName"
        Me.txtTab4ColumnName.Size = New System.Drawing.Size(384, 20)
        Me.txtTab4ColumnName.TabIndex = 4
        Me.txtTab4ColumnName.Text = ""
        '
        'lblTab4ColumnLength
        '
        Me.lblTab4ColumnLength.BackColor = System.Drawing.SystemColors.HighlightText
        Me.lblTab4ColumnLength.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblTab4ColumnLength.Location = New System.Drawing.Point(560, 24)
        Me.lblTab4ColumnLength.Name = "lblTab4ColumnLength"
        Me.lblTab4ColumnLength.Size = New System.Drawing.Size(32, 20)
        Me.lblTab4ColumnLength.TabIndex = 3
        Me.lblTab4ColumnLength.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label9
        '
        Me.Label9.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label9.Location = New System.Drawing.Point(488, 26)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(64, 16)
        Me.Label9.TabIndex = 2
        Me.Label9.Text = "Field Length:"
        Me.Label9.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label8
        '
        Me.Label8.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label8.Location = New System.Drawing.Point(8, 26)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(72, 16)
        Me.Label8.TabIndex = 0
        Me.Label8.Text = "Field Na&me:"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label7
        '
        Me.Label7.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label7.Location = New System.Drawing.Point(24, 24)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(608, 40)
        Me.Label7.TabIndex = 0
        Me.Label7.Text = "You can specify information about each of the fields you are importing. Select fi" & _
        "elds in the area below. You can then modify field information in the 'Field Opti" & _
        "ons' area.  Pressing the TAB key selects the next column forward. SHIFT-TAB sele" & _
        "cts the previous column backward."
        '
        'tmrTimer
        '
        '
        'ofdProfile
        '
        Me.ofdProfile.ShowReadOnly = True
        '
        'sfdProfile
        '
        Me.sfdProfile.DefaultExt = "ini"
        Me.sfdProfile.DereferenceLinks = False
        '
        'pnlRight
        '
        Me.pnlRight.Location = New System.Drawing.Point(656, 16)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Size = New System.Drawing.Size(32, 392)
        Me.pnlRight.TabIndex = 2
        '
        'pnlLeft
        '
        Me.pnlLeft.Location = New System.Drawing.Point(8, 16)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Size = New System.Drawing.Size(32, 384)
        Me.pnlLeft.TabIndex = 1
        '
        'PaneCaption1
        '
        Me.PaneCaption1.Caption = "Import Excel Wizard"
        Me.PaneCaption1.Dock = System.Windows.Forms.DockStyle.Top
        Me.PaneCaption1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.PaneCaption1.Location = New System.Drawing.Point(0, 0)
        Me.PaneCaption1.Name = "PaneCaption1"
        Me.PaneCaption1.Size = New System.Drawing.Size(696, 26)
        Me.PaneCaption1.TabIndex = 0
        '
        'pnlBottom
        '
        Me.pnlBottom.Location = New System.Drawing.Point(8, 392)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(680, 16)
        Me.pnlBottom.TabIndex = 3
        '
        'GroupBox5
        '
        Me.GroupBox5.Controls.Add(Me.optTab3ZeroBased)
        Me.GroupBox5.Controls.Add(Me.optTab3OneBased)
        Me.GroupBox5.Location = New System.Drawing.Point(520, 24)
        Me.GroupBox5.Name = "GroupBox5"
        Me.GroupBox5.Size = New System.Drawing.Size(112, 80)
        Me.GroupBox5.TabIndex = 5
        Me.GroupBox5.TabStop = False
        Me.GroupBox5.Text = "Ruler Scale"
        '
        'frmTextWizard
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(696, 464)
        Me.Controls.Add(Me.pnlBottom)
        Me.Controls.Add(Me.PaneCaption1)
        Me.Controls.Add(Me.pnlLeft)
        Me.Controls.Add(Me.pnlRight)
        Me.Controls.Add(Me.tabWizard)
        Me.Controls.Add(Me.btnNext)
        Me.Controls.Add(Me.btnBack)
        Me.Controls.Add(Me.btnCancel)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmTextWizard"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Import Text Wizard"
        Me.tabWizard.ResumeLayout(False)
        Me.FormatTab.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.DelimitedTab.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.FixedTab.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.FieldTab.ResumeLayout(False)
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox5.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub TextWizard_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Set form style
        Me.SetStyle(ControlStyles.AllPaintingInWmPaint Or _
                    ControlStyles.UserPaint Or _
                    ControlStyles.DoubleBuffer, _
                    True)

        'Init form content
        InitForm()

        'Init wizard
        SetWizardSteps()
        mWizardCtrl.CurrentStep = FORMAT_TAB

    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click
        mWizardCtrl.MoveBack()
    End Sub

    Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click
        mWizardCtrl.MoveNext()
    End Sub

    Private Sub WizardCtrl_Validate(ByVal currentStep As Integer, ByRef CancelMove As Boolean) Handles mWizardCtrl.Validate
        Select Case currentStep
            Case STEP_FORMAT
                ValidateFormatTab(CancelMove)

            Case STEP_BREAK
                If mTextDataCtrl.IsDelimited Then
                    ValidateDelimitedTextBreak(CancelMove)
                Else
                    ValidateFixedTextBreak(CancelMove)
                End If

            Case STEP_FIELD
                ValidateFieldNameTab(CancelMove)
        End Select

    End Sub

    Private Sub WizardCtrl_DisplayStep(ByVal currentStep As Integer, ByVal page As Object) Handles mWizardCtrl.DisplayStep
        Dim index As Integer = CInt(page)
        tabWizard.SelectedIndex = index

        'Enable "Back" button
        btnBack.Enabled = True

        'Change "Next" button text
        btnNext.Text = "&Next >"

        Select Case currentStep
            Case STEP_FORMAT
                DisplayFormatTab()

            Case STEP_BREAK
                If mTextDataCtrl.IsDelimited Then
                    DisplayDelimitedTab()
                Else
                    DisplayFixedWidthTab()
                End If

            Case STEP_FIELD
                DisplayFieldTab()
        End Select

    End Sub

    Private Sub WizardCtrl_Finish() Handles mWizardCtrl.Finish
        'mTextDataCtrl.SaveSettings()
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub btnTab1Profile_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnTab1Profile.LinkClicked
        Dim path As String

        Try
            Me.Cursor = Cursors.WaitCursor

            'Browser profile
            Dim filter As String
            filter = "Initialization files (*.ini)|*.ini"
            filter += "|Package files (*.pkg)|*.pkg"
            filter += "|All files (*.*)|*.*"
            ofdProfile.Filter = filter
            ofdProfile.FilterIndex = 1

            ofdProfile.Title = "Select the text format profile."
            If ofdProfile.ShowDialog <> Windows.Forms.DialogResult.OK Then Return
            path = ofdProfile.FileName

            'Check if profile is for Kitchensynk and has multiple sections
            Dim sectionList() As String = {}
            Dim section As String = ""
            If (TextDataCtrl.IsKitchensynkProfile(path, sectionList)) Then
                If (sectionList.Length = 1) Then    'single section
                    section = sectionList(0)
                Else    'multi sections
                    'Open a dialogue let user select a section
                    Dim sections As New ArrayList
                    Dim i As Integer
                    For i = 0 To sectionList.Length - 1
                        sections.Add(New ListItem(sectionList(i)))
                    Next

                    Dim form As New frmListBox
                    With form
                        .Caption = "Sections"
                        .Title = "Select a section"
                        .DisplayMember = "Text"
                        .ValueMember = "Value"
                        .DataSource = sections
                        .SelectedIndex = 0
                        If (.ShowDialog(Me) <> Windows.Forms.DialogResult.OK) Then Return
                        section = CStr(.SelectedValue)
                    End With
                End If
            End If

            'Load profile
            TextDataCtrl.LoadProfile(path, section)

            'Refresh wizard steps 
            SetWizardSteps()

            'Reset file type radio button
            If TextDataCtrl.IsDelimited Then
                optTab1DelimitedRadio.Checked = True
            Else
                optTab1FixedRadio.Checked = True
            End If

        Catch ex As Exception
            ReportException(ex, "Text Wizard Error")
            'MessageBox.Show(ex.Message, "Text Wizard Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub Tab2Delimiter_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) _
                                    Handles optTab2Tab.CheckedChanged, _
                                            optTab2Semicolon.CheckedChanged, _
                                            optTab2Comma.CheckedChanged, _
                                            optTab2Space.CheckedChanged, _
                                            optTab2Other.CheckedChanged

        If (mTextDataCtrl Is Nothing) Then Return
        Dim delimiter As String = ""

        If (optTab2Tab.Checked) Then
            delimiter = vbTab
        ElseIf (optTab2Semicolon.Checked) Then
            delimiter = ";"
        ElseIf (optTab2Comma.Checked) Then
            delimiter = ","
        ElseIf (optTab2Space.Checked) Then
            delimiter = " "
        ElseIf (optTab2Other.Checked) Then
            If (txtTab2OtherDelimiter.Text.Length <= 0) Then
                txtTab2OtherDelimiter.Text = " "
                delimiter = " "
            Else
                delimiter = txtTab2OtherDelimiter.Text.Substring(0, 1)
            End If
            txtTab2OtherDelimiter.Focus()
        End If

        'Delimiter changed?
        If (delimiter = mTextDataCtrl.Delimiter) Then Return
        mTextDataCtrl.Delimiter = delimiter

        'check if delimiter is the same as qualifier
        If (delimiter = mTextDataCtrl.TextQualifier) Then
            cboTab2Qualifier.SelectedIndex = TEXT_QUALIFIER_NONE
        End If

        'Show the new formatted text
        With ctlTab2TextColumn
            .Columns = mTextDataCtrl.Columns
            .Fields = mTextDataCtrl.Fields
            .ResetPosition()
        End With

    End Sub

    Private Sub txtTab2OtherDelimiter_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtTab2OtherDelimiter.GotFocus
        txtTab2OtherDelimiter.SelectAll()
    End Sub

    Private Sub txtTab2OtherDelimiter_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtTab2OtherDelimiter.TextChanged
        If (Not optTab2Other.Checked) Then Return
        If (txtTab2OtherDelimiter.Text = "") Then Return
        Dim delimiter As String = txtTab2OtherDelimiter.Text

        'Delimiter changed?
        If (delimiter = mTextDataCtrl.Delimiter) Then Return
        mTextDataCtrl.Delimiter = delimiter

        'check if delimiter is the same as qualifier
        If (delimiter = mTextDataCtrl.TextQualifier) Then
            cboTab2Qualifier.SelectedIndex = TEXT_QUALIFIER_NONE
        End If

        'Show the new formatted text
        With ctlTab2TextColumn
            .Columns = mTextDataCtrl.Columns
            .Fields = mTextDataCtrl.Fields
            .ResetPosition()
        End With

    End Sub

    Private Sub chkTab2HasHeader_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkTab2HasHeader.CheckedChanged
        Dim hasHeader As Boolean = chkTab2HasHeader.Checked

        '"has header" changed?
        If (hasHeader <> mTextDataCtrl.HasHeader) Then
            mTextDataCtrl.HasHeader = hasHeader
        End If

        'Check if the original names are valid
        Dim errMsg As String = ""
        Dim errColumn As Integer
        If (hasHeader AndAlso _
            Not mTextDataCtrl.AreOriginalNameValid(errColumn, errMsg)) Then
            MessageBox.Show(errMsg, "Text Wizard Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            chkTab2HasHeader.Checked = False
        End If

        'Show the new formatted text
        With ctlTab2TextColumn
            .ShowHeader = hasHeader
            .Columns = mTextDataCtrl.Columns
            .Fields = mTextDataCtrl.Fields
            .ResetPosition()
        End With

    End Sub

    Private Sub cboTab2Qualifier_Changed(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTab2Qualifier.TextChanged
        Dim qualifier As String = cboTab2Qualifier.Text
        If (qualifier = "{none}") Then qualifier = ""

        If (mTextDataCtrl.Delimiter = qualifier) Then
            MessageBox.Show("Text qualifier can not be the same as field delimiter.", "Text Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            ResetTextQualifier()
            Return
        End If

        'Qualifier changed?
        If (qualifier <> mTextDataCtrl.TextQualifier) Then
            mTextDataCtrl.TextQualifier = qualifier
        End If

        'Show the new formatted text
        With ctlTab2TextColumn
            .Columns = mTextDataCtrl.Columns
            .Fields = mTextDataCtrl.Fields
            .ResetPosition()
        End With

    End Sub

    Private Sub ctlTab4TextColumn_ColumnSelected( _
                    ByVal columnName As String, _
                    ByVal columnLength As Integer _
            ) Handles ctlTab4TextColumn.ColumnSelected

        txtTab4ColumnName.Text = ctlTab4TextColumn.SelectedColumnName
        lblTab4ColumnLength.Text = columnLength.ToString
    End Sub

    Private Sub txtTab4ColumnName_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtTab4ColumnName.TextChanged
        ctlTab4TextColumn.SelectedColumnName = Trim(txtTab4ColumnName.Text)
    End Sub

    Private Sub txtTab4ColumnName_Moving(ByVal direction As MoveDirections) Handles txtTab4ColumnName.Moving
        ctlTab4TextColumn.Moving(direction)
    End Sub

    Private Sub ctlTab4TextColumn_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles ctlTab4TextColumn.Enter
        txtTab4ColumnName.Focus()
    End Sub

    Private Sub btnTab4ExportProfile_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnTab4ExportProfile.LinkClicked
        Dim cancelMove As Boolean
        Dim path As String

        Try
            Me.Cursor = Cursors.WaitCursor

            'Check settings
            ValidateFieldNameTab(cancelMove)
            If (cancelMove) Then Return

            'Input a file name to save
            Dim filter As String
            filter = "Initialization files (*.ini)|*.ini"
            sfdProfile.Filter = filter
            sfdProfile.FilterIndex = 1

            sfdProfile.Title = "Save Profile As"
            If sfdProfile.ShowDialog <> Windows.Forms.DialogResult.OK Then Return
            path = sfdProfile.FileName

            'Save profile
            TextDataCtrl.SaveProfile(path)

        Catch ex As Exception
            ReportException(ex, "Text Wizard Error")
            'MessageBox.Show(ex.Message, "Text Wizard Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub frmTextWizard_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles MyBase.Paint
        Dim penBorder As New Pen(Color.FromArgb(0, 45, 150))
        Dim g As Graphics = e.Graphics

        'Top Border
        g.DrawLine(penBorder, 0, 0, Me.Width - 1, 0)
        'Bottom Border
        g.DrawLine(penBorder, 0, Me.Height - 1, Me.Width - 1, Me.Height - 1)
        'Left Border
        g.DrawLine(penBorder, 0, 0, 0, Me.Height - 1)
        'Right Border
        g.DrawLine(penBorder, Me.Width - 1, 0, Me.Width - 1, Me.Height - 1)

    End Sub

    Private Sub tmrTimer_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles tmrTimer.Tick
        tmrTimer.Stop()
        cboTab2Qualifier.SelectedIndex = TEXT_QUALIFIER_NONE
    End Sub

#End Region

#Region " Private Methods "

    Private Sub InitForm()
        Dim i As Integer

        'Move Tab control and buttons upward to hide the tabulars
        Dim offset As Integer = 25
        tabWizard.Top -= offset
        pnlLeft.Top -= offset
        pnlRight.Top -= offset
        pnlBottom.Top -= offset
        btnCancel.Top -= offset
        btnBack.Top -= offset
        btnNext.Top -= offset

        Me.Height -= offset

        'file location
        Tab1Msg.Text = "Sample data from file: " + mTextDataCtrl.TemplateFile

        'Show text content in tab "Format"
        Dim text As New StringBuilder(2000)
        Dim lines As String() = mTextDataCtrl.Lines
        For i = 0 To lines.Length - 1
            text.Append(lines(i) + vbCrLf)
        Next
        txtTab1TextView.Text = text.ToString

        'Set properties for TextColumn in "Delimited Text" tab
        ctlTab2TextColumn.CanSelectColumn = False

        'Show text content in tab "Fixed Width"
        ctlTab3FixedTextUtil.StringLines = mTextDataCtrl.Lines

        'Set properties for TextColumn in "Field Name" tab
        ctlTab4TextColumn.CanSelectColumn = True

    End Sub

    Private Sub SetWizardSteps()
        Dim tabStep(2) As Object

        tabStep(0) = FORMAT_TAB
        tabStep(1) = CInt(IIf(mTextDataCtrl.IsDelimited, DELIMITED_TAB, FIXED_TAB))
        tabStep(2) = FIELD_TAB
        mWizardCtrl.StepPage = tabStep
    End Sub



    Private Sub ValidateFormatTab(ByRef CancelMove As Boolean)
        Dim isDelimited As Boolean

        If (optTab1DelimitedRadio.Checked) Then
            isDelimited = True
        ElseIf (optTab1FixedRadio.Checked) Then
            isDelimited = False
        Else
            MessageBox.Show("Choose the format that describes your data before move next.", "Import Text Wizard")
            CancelMove = True
            Return
        End If

        'format unchanged, needn't do anything
        If (mTextDataCtrl.IsDelimited = isDelimited) Then Return

        'format changed
        mTextDataCtrl.IsDelimited = isDelimited

        '-- reset wizard steps
        SetWizardSteps()
    End Sub

    Private Sub ValidateDelimitedTextBreak(ByRef CancelMove As Boolean)
        'Check if delimiter has been set
        If (optTab2Other.Checked AndAlso txtTab2OtherDelimiter.Text.Length = 0) Then
            MessageBox.Show("No field delimiter is selected", "Text Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            CancelMove = True
            Return
        End If

        'Check delimiter is valid char
        If (Not DTSTextData.IsValidDelimiter(mTextDataCtrl.Delimiter)) Then
            MessageBox.Show("Delimiter is not a valid character", "Text Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            CancelMove = True
            Return
        End If
        mTextDataCtrl.Delimiter = mTextDataCtrl.Delimiter.Substring(0, 1)

        'Check text qualifier is valid char
        If (mTextDataCtrl.TextQualifier <> "") Then
            If (Not DTSTextData.IsValidDelimiter(mTextDataCtrl.TextQualifier)) Then
                MessageBox.Show("Text qualifier is not a valid character", "Text Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                CancelMove = True
                Return
            End If
            mTextDataCtrl.TextQualifier = mTextDataCtrl.TextQualifier.Substring(0, 1)
        End If

        'Check if delimter is the same as text qualifier
        If (mTextDataCtrl.Delimiter = mTextDataCtrl.TextQualifier) Then
            MessageBox.Show("Field delimiter can not be the same as text qualifier", "Text Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            CancelMove = True
            Return
        End If

    End Sub

    Private Sub ValidateFixedTextBreak(ByRef CancelMove As Boolean)
        Dim lengths() As Integer = ctlTab3FixedTextUtil.ColumnLengths
        Dim columns As New ColumnCollection
        Dim col As SourceColumn
        Dim i As Integer
        Dim totalLength As Integer = 0

        'get length of each column
        For i = 0 To lengths.Length - 1
            col = New SourceColumn
            col.Length = lengths(i)
            col.ColumnName = ""
            col.OriginalName = ""
            columns.Add(col)
            'FixedTextColumns control can set a break at the end
            'This break should be skipped
            totalLength += lengths(i)
            If (totalLength >= mTextDataCtrl.MaxRowLength) Then Exit For
        Next

        'copy column names from original columns
        Dim location As Integer = 0
        Dim columnName As String
        For i = 0 To columns.Count - 1
            columnName = GetColumnNameAtLocation(location)
            If (columnName <> "" AndAlso _
                Not IsDefaultColumnName(columnName)) Then
                columns(i).ColumnName = columnName
            End If
            location += columns(i).Length
        Next i

        'copy columns to control class
        mTextDataCtrl.Columns = columns

    End Sub

    Private Sub ValidateFieldNameTab(ByRef CancelMove As Boolean)
        Dim errColumn As Integer
        Dim errMsg As String = ""

        If (Not mTextDataCtrl.ValidateColumnName(errColumn, errMsg)) Then
            ctlTab4TextColumn.SelectedColumn = errColumn
            ctlTab4TextColumn.VisibleColumn(errColumn)
            errMsg = "Column name error." + vbCrLf + vbCrLf + errMsg
            MessageBox.Show(errMsg, "Text Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            CancelMove = True
            Return
        End If
    End Sub

    Private Function IsDefaultColumnName(ByVal columnName As String) As Boolean
        Dim defaultColumnName As String = Column.DEFAULT_COLUMN_NAME
        If (Not columnName.StartsWith(defaultColumnName)) Then Return False
        If (columnName.Length <= defaultColumnName.Length) Then Return False
        If (Not Char.IsDigit(columnName, defaultColumnName.Length)) Then Return False
        Return True
    End Function

    Private Function GetColumnNameAtLocation(ByVal lookupLocation As Integer) As String
        Dim columns As ColumnCollection = mTextDataCtrl.Columns
        Dim col As SourceColumn
        Dim location As Integer = 0

        For Each col In columns
            If (lookupLocation = location) Then Return col.ColumnName
            location += col.Length
            If (location > lookupLocation) Then Return ("")
        Next
        Return ("")

    End Function

    Private Sub DisplayFormatTab()
        'Disable "Back" button
        btnBack.Enabled = False

        'format
        If mTextDataCtrl.IsDelimited Then
            optTab1DelimitedRadio.Checked = True
        Else
            optTab1FixedRadio.Checked = True
        End If

    End Sub

    Private Sub DisplayDelimitedTab()
        'delimiter
        txtTab2OtherDelimiter.Text = ""
        Select Case mTextDataCtrl.Delimiter
            Case vbTab
                optTab2Tab.Checked = True
            Case ";"
                optTab2Semicolon.Checked = True
            Case ","
                optTab2Comma.Checked = True
            Case " "
                optTab2Space.Checked = True
            Case Else
                txtTab2OtherDelimiter.Text = mTextDataCtrl.Delimiter
                optTab2Other.Checked = True
        End Select

        'First row contains field names
        chkTab2HasHeader.Checked = mTextDataCtrl.HasHeader

        'Text qualifier
        cboTab2Qualifier.Text = mTextDataCtrl.TextQualifier

        'Text column control
        With ctlTab2TextColumn
            .Columns = mTextDataCtrl.Columns
            .Fields = mTextDataCtrl.Fields
            .ShowHeader = mTextDataCtrl.HasHeader
            .ResetPosition()
        End With

    End Sub

    Private Sub DisplayFixedWidthTab()
        Dim row As Integer = mTextDataCtrl.RowNum
        Dim i As Integer

        'Ruler scale
        If (mTextDataCtrl.RulerScale = RulerScales.ZeroBased) Then
            optTab3ZeroBased.Checked = True
        Else
            optTab3OneBased.Checked = True
        End If

        'Data
        Dim columns As ColumnCollection = mTextDataCtrl.Columns
        Dim lengths(columns.Count - 1) As Integer
        For i = 0 To columns.Count - 1
            lengths(i) = columns(i).Length
        Next
        ctlTab3FixedTextUtil.ColumnLengths = lengths

    End Sub

    Private Sub DisplayFieldTab()
        'Change "Next" button text
        btnNext.Text = "&Finish"

        'assign a default names to columns that don't have one
        mTextDataCtrl.FillColumnNames()

        'Text column control
        With ctlTab4TextColumn
            .Columns = mTextDataCtrl.Columns
            .Fields = mTextDataCtrl.Fields
            .ShowHeader = True
            .ResetPosition()
            .SelectedColumn = 0
        End With

    End Sub


    Private Sub ResetTextQualifier()
        tmrTimer.Interval = 1
        tmrTimer.Start()
    End Sub


#End Region

    Private Sub RulerScale_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optTab3ZeroBased.CheckedChanged, optTab3OneBased.CheckedChanged
        Dim rulerScale As RulerScales

        If (optTab3ZeroBased.Checked) Then
            rulerScale = RulerScales.ZeroBased
        Else
            rulerScale = RulerScales.OneBased
        End If

        Me.ctlTab3FixedTextUtil.RulerScale = rulerScale
        If (Not Me.mTextDataCtrl Is Nothing) Then
            Me.mTextDataCtrl.RulerScale = rulerScale
        End If

    End Sub
End Class
