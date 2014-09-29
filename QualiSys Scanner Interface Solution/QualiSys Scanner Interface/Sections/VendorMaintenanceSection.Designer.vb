<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VendorMaintenanceSection
    Inherits QualiSys_Scanner_Interface.Section

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
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(VendorMaintenanceSection))
        Me.VendorInfoSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.VendorInfoTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel()
        Me.VendorInfoRightPanel = New System.Windows.Forms.Panel()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.txtRefusedResponseChar = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.txtDontKnowResponseChar = New System.Windows.Forms.TextBox()
        Me.chkAutoLoad = New System.Windows.Forms.CheckBox()
        Me.lblSkipResponseChar = New System.Windows.Forms.Label()
        Me.txtSkipResponseChar = New System.Windows.Forms.TextBox()
        Me.lblMultiRespItemNotPickedChar = New System.Windows.Forms.Label()
        Me.txtMultiRespItemNotPickedChar = New System.Windows.Forms.TextBox()
        Me.lblNoResponseChar = New System.Windows.Forms.Label()
        Me.txtNoResponseChar = New System.Windows.Forms.TextBox()
        Me.lblAutoLoad = New System.Windows.Forms.Label()
        Me.VendorInfoLeftPanel = New System.Windows.Forms.Panel()
        Me.cboOutgoingFileType = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.txtLocalFTPLoginName = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.txtVendorName = New System.Windows.Forms.TextBox()
        Me.txtVendorCode = New System.Windows.Forms.TextBox()
        Me.lblVendorName = New System.Windows.Forms.Label()
        Me.lblVendorCode = New System.Windows.Forms.Label()
        Me.VendorSplitContainer = New System.Windows.Forms.SplitContainer()
        Me.VendorDetailSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.ButtonPanel = New System.Windows.Forms.Panel()
        Me.Cancel_Button = New System.Windows.Forms.Button()
        Me.ApplyButton = New System.Windows.Forms.Button()
        Me.VendorDetailTabControl = New System.Windows.Forms.TabControl()
        Me.ContactsTabPage = New System.Windows.Forms.TabPage()
        Me.ContactsGridControl = New DevExpress.XtraGrid.GridControl()
        Me.ContactsContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.DeleteRecordToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.VendorContactBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.ContactsGridView = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.colVendorContactId = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colVendorId = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colType = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colFirstName = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colLastName = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colemailAddr1 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colemailAddr2 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colSendFileArrivalEmail = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colPhone1 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.Phone1TextEdit = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit()
        Me.colPhone2 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.Phone2TextEdit = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit()
        Me.colNotes = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.ContactsExportGridView = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.TableTabPage = New System.Windows.Forms.TabPage()
        Me.DispsitionTableToolStrip = New System.Windows.Forms.ToolStrip()
        Me.btnDispoImportFile = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnDispoExportFile = New System.Windows.Forms.ToolStripButton()
        Me.DispositionGridControl = New DevExpress.XtraGrid.GridControl()
        Me.VendorDespositionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.DispositionGridView = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.colVendorDispositionCode = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colVendorDispositionLabel = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colVendorDispositionDesc = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.colNRCDispo = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.NRCDispoLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit()
        Me.DispositionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colHCAHPSDispos = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.HCAHPSDisposLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit()
        Me.colHHCAHPSDispos = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.HHCAHPSDisposLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit()
        Me.colIsFinal = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog()
        Me.OpenFileDialog = New System.Windows.Forms.OpenFileDialog()
        Me.VendorErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.VendorInfoSectionPanel.SuspendLayout()
        Me.VendorInfoTableLayoutPanel.SuspendLayout()
        Me.VendorInfoRightPanel.SuspendLayout()
        Me.VendorInfoLeftPanel.SuspendLayout()
        Me.VendorSplitContainer.Panel1.SuspendLayout()
        Me.VendorSplitContainer.Panel2.SuspendLayout()
        Me.VendorSplitContainer.SuspendLayout()
        Me.VendorDetailSectionPanel.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        Me.ButtonPanel.SuspendLayout()
        Me.VendorDetailTabControl.SuspendLayout()
        Me.ContactsTabPage.SuspendLayout()
        CType(Me.ContactsGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ContactsContextMenuStrip.SuspendLayout()
        CType(Me.VendorContactBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ContactsGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Phone1TextEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Phone2TextEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ContactsExportGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TableTabPage.SuspendLayout()
        Me.DispsitionTableToolStrip.SuspendLayout()
        CType(Me.DispositionGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorDespositionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DispositionGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NRCDispoLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DispositionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.HCAHPSDisposLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.HHCAHPSDisposLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'VendorInfoSectionPanel
        '
        Me.VendorInfoSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.VendorInfoSectionPanel.Caption = "Vendor Information"
        Me.VendorInfoSectionPanel.Controls.Add(Me.VendorInfoTableLayoutPanel)
        Me.VendorInfoSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorInfoSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.VendorInfoSectionPanel.Name = "VendorInfoSectionPanel"
        Me.VendorInfoSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.VendorInfoSectionPanel.ShowCaption = True
        Me.VendorInfoSectionPanel.Size = New System.Drawing.Size(701, 152)
        Me.VendorInfoSectionPanel.TabIndex = 0
        '
        'VendorInfoTableLayoutPanel
        '
        Me.VendorInfoTableLayoutPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorInfoTableLayoutPanel.ColumnCount = 2
        Me.VendorInfoTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.VendorInfoTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 330.0!))
        Me.VendorInfoTableLayoutPanel.Controls.Add(Me.VendorInfoRightPanel, 1, 0)
        Me.VendorInfoTableLayoutPanel.Controls.Add(Me.VendorInfoLeftPanel, 0, 0)
        Me.VendorInfoTableLayoutPanel.Location = New System.Drawing.Point(4, 30)
        Me.VendorInfoTableLayoutPanel.MinimumSize = New System.Drawing.Size(0, 119)
        Me.VendorInfoTableLayoutPanel.Name = "VendorInfoTableLayoutPanel"
        Me.VendorInfoTableLayoutPanel.RowCount = 1
        Me.VendorInfoTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.VendorInfoTableLayoutPanel.Size = New System.Drawing.Size(693, 119)
        Me.VendorInfoTableLayoutPanel.TabIndex = 1
        '
        'VendorInfoRightPanel
        '
        Me.VendorInfoRightPanel.Controls.Add(Me.Label4)
        Me.VendorInfoRightPanel.Controls.Add(Me.txtRefusedResponseChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.Label3)
        Me.VendorInfoRightPanel.Controls.Add(Me.txtDontKnowResponseChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.chkAutoLoad)
        Me.VendorInfoRightPanel.Controls.Add(Me.lblSkipResponseChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.txtSkipResponseChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.lblMultiRespItemNotPickedChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.txtMultiRespItemNotPickedChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.lblNoResponseChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.txtNoResponseChar)
        Me.VendorInfoRightPanel.Controls.Add(Me.lblAutoLoad)
        Me.VendorInfoRightPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorInfoRightPanel.Location = New System.Drawing.Point(366, 3)
        Me.VendorInfoRightPanel.Name = "VendorInfoRightPanel"
        Me.VendorInfoRightPanel.Size = New System.Drawing.Size(324, 113)
        Me.VendorInfoRightPanel.TabIndex = 1
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(187, 39)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(80, 13)
        Me.Label4.TabIndex = 10
        Me.Label4.Text = "Refused Value:"
        '
        'txtRefusedResponseChar
        '
        Me.txtRefusedResponseChar.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtRefusedResponseChar.Location = New System.Drawing.Point(283, 36)
        Me.txtRefusedResponseChar.MaxLength = 1
        Me.txtRefusedResponseChar.Name = "txtRefusedResponseChar"
        Me.txtRefusedResponseChar.Size = New System.Drawing.Size(31, 21)
        Me.txtRefusedResponseChar.TabIndex = 11
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(187, 10)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(94, 13)
        Me.Label3.TabIndex = 8
        Me.Label3.Text = "Don't Know Value:"
        '
        'txtDontKnowResponseChar
        '
        Me.txtDontKnowResponseChar.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtDontKnowResponseChar.Location = New System.Drawing.Point(283, 7)
        Me.txtDontKnowResponseChar.MaxLength = 1
        Me.txtDontKnowResponseChar.Name = "txtDontKnowResponseChar"
        Me.txtDontKnowResponseChar.Size = New System.Drawing.Size(31, 21)
        Me.txtDontKnowResponseChar.TabIndex = 9
        '
        'chkAutoLoad
        '
        Me.chkAutoLoad.AutoSize = True
        Me.chkAutoLoad.Checked = True
        Me.chkAutoLoad.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkAutoLoad.Location = New System.Drawing.Point(150, 85)
        Me.chkAutoLoad.Name = "chkAutoLoad"
        Me.chkAutoLoad.Size = New System.Drawing.Size(15, 14)
        Me.chkAutoLoad.TabIndex = 7
        Me.chkAutoLoad.UseVisualStyleBackColor = True
        '
        'lblSkipResponseChar
        '
        Me.lblSkipResponseChar.AutoSize = True
        Me.lblSkipResponseChar.Location = New System.Drawing.Point(14, 36)
        Me.lblSkipResponseChar.Name = "lblSkipResponseChar"
        Me.lblSkipResponseChar.Size = New System.Drawing.Size(109, 13)
        Me.lblSkipResponseChar.TabIndex = 2
        Me.lblSkipResponseChar.Text = "Skip Response Value:"
        '
        'txtSkipResponseChar
        '
        Me.txtSkipResponseChar.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtSkipResponseChar.Location = New System.Drawing.Point(150, 33)
        Me.txtSkipResponseChar.MaxLength = 1
        Me.txtSkipResponseChar.Name = "txtSkipResponseChar"
        Me.txtSkipResponseChar.Size = New System.Drawing.Size(31, 21)
        Me.txtSkipResponseChar.TabIndex = 3
        '
        'lblMultiRespItemNotPickedChar
        '
        Me.lblMultiRespItemNotPickedChar.AutoSize = True
        Me.lblMultiRespItemNotPickedChar.Location = New System.Drawing.Point(14, 62)
        Me.lblMultiRespItemNotPickedChar.Name = "lblMultiRespItemNotPickedChar"
        Me.lblMultiRespItemNotPickedChar.Size = New System.Drawing.Size(128, 13)
        Me.lblMultiRespItemNotPickedChar.TabIndex = 4
        Me.lblMultiRespItemNotPickedChar.Text = "Multi Response No Value:"
        '
        'txtMultiRespItemNotPickedChar
        '
        Me.txtMultiRespItemNotPickedChar.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtMultiRespItemNotPickedChar.Location = New System.Drawing.Point(150, 59)
        Me.txtMultiRespItemNotPickedChar.MaxLength = 1
        Me.txtMultiRespItemNotPickedChar.Name = "txtMultiRespItemNotPickedChar"
        Me.txtMultiRespItemNotPickedChar.Size = New System.Drawing.Size(31, 21)
        Me.txtMultiRespItemNotPickedChar.TabIndex = 5
        '
        'lblNoResponseChar
        '
        Me.lblNoResponseChar.AutoSize = True
        Me.lblNoResponseChar.Location = New System.Drawing.Point(14, 10)
        Me.lblNoResponseChar.Name = "lblNoResponseChar"
        Me.lblNoResponseChar.Size = New System.Drawing.Size(117, 13)
        Me.lblNoResponseChar.TabIndex = 0
        Me.lblNoResponseChar.Text = "MISSING Option Value:"
        '
        'txtNoResponseChar
        '
        Me.txtNoResponseChar.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtNoResponseChar.Location = New System.Drawing.Point(150, 7)
        Me.txtNoResponseChar.MaxLength = 1
        Me.txtNoResponseChar.Name = "txtNoResponseChar"
        Me.txtNoResponseChar.Size = New System.Drawing.Size(31, 21)
        Me.txtNoResponseChar.TabIndex = 1
        '
        'lblAutoLoad
        '
        Me.lblAutoLoad.AutoSize = True
        Me.lblAutoLoad.Location = New System.Drawing.Point(14, 85)
        Me.lblAutoLoad.Name = "lblAutoLoad"
        Me.lblAutoLoad.Size = New System.Drawing.Size(60, 13)
        Me.lblAutoLoad.TabIndex = 6
        Me.lblAutoLoad.Text = "Auto Load:"
        '
        'VendorInfoLeftPanel
        '
        Me.VendorInfoLeftPanel.Controls.Add(Me.cboOutgoingFileType)
        Me.VendorInfoLeftPanel.Controls.Add(Me.Label2)
        Me.VendorInfoLeftPanel.Controls.Add(Me.txtLocalFTPLoginName)
        Me.VendorInfoLeftPanel.Controls.Add(Me.Label1)
        Me.VendorInfoLeftPanel.Controls.Add(Me.txtVendorName)
        Me.VendorInfoLeftPanel.Controls.Add(Me.txtVendorCode)
        Me.VendorInfoLeftPanel.Controls.Add(Me.lblVendorName)
        Me.VendorInfoLeftPanel.Controls.Add(Me.lblVendorCode)
        Me.VendorInfoLeftPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorInfoLeftPanel.Location = New System.Drawing.Point(3, 3)
        Me.VendorInfoLeftPanel.Name = "VendorInfoLeftPanel"
        Me.VendorInfoLeftPanel.Size = New System.Drawing.Size(357, 113)
        Me.VendorInfoLeftPanel.TabIndex = 0
        '
        'cboOutgoingFileType
        '
        Me.cboOutgoingFileType.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cboOutgoingFileType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboOutgoingFileType.FormattingEnabled = True
        Me.cboOutgoingFileType.Location = New System.Drawing.Point(121, 87)
        Me.cboOutgoingFileType.Name = "cboOutgoingFileType"
        Me.cboOutgoingFileType.Size = New System.Drawing.Size(211, 21)
        Me.cboOutgoingFileType.TabIndex = 7
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(13, 90)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(101, 13)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "Outgoing File Type:"
        '
        'txtLocalFTPLoginName
        '
        Me.txtLocalFTPLoginName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtLocalFTPLoginName.Location = New System.Drawing.Point(107, 59)
        Me.txtLocalFTPLoginName.MaxLength = 20
        Me.txtLocalFTPLoginName.Name = "txtLocalFTPLoginName"
        Me.txtLocalFTPLoginName.Size = New System.Drawing.Size(225, 21)
        Me.txtLocalFTPLoginName.TabIndex = 5
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(13, 62)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(84, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Local FTP Login:"
        '
        'txtVendorName
        '
        Me.txtVendorName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtVendorName.Location = New System.Drawing.Point(107, 33)
        Me.txtVendorName.MaxLength = 100
        Me.txtVendorName.Name = "txtVendorName"
        Me.txtVendorName.Size = New System.Drawing.Size(225, 21)
        Me.txtVendorName.TabIndex = 3
        '
        'txtVendorCode
        '
        Me.txtVendorCode.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtVendorCode.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtVendorCode.Location = New System.Drawing.Point(107, 7)
        Me.txtVendorCode.MaxLength = 25
        Me.txtVendorCode.Name = "txtVendorCode"
        Me.txtVendorCode.Size = New System.Drawing.Size(225, 21)
        Me.txtVendorCode.TabIndex = 1
        '
        'lblVendorName
        '
        Me.lblVendorName.AutoSize = True
        Me.lblVendorName.Location = New System.Drawing.Point(13, 36)
        Me.lblVendorName.Name = "lblVendorName"
        Me.lblVendorName.Size = New System.Drawing.Size(75, 13)
        Me.lblVendorName.TabIndex = 2
        Me.lblVendorName.Text = "Vendor Name:"
        '
        'lblVendorCode
        '
        Me.lblVendorCode.AutoSize = True
        Me.lblVendorCode.Location = New System.Drawing.Point(13, 10)
        Me.lblVendorCode.Name = "lblVendorCode"
        Me.lblVendorCode.Size = New System.Drawing.Size(73, 13)
        Me.lblVendorCode.TabIndex = 0
        Me.lblVendorCode.Text = "Vendor Code:"
        '
        'VendorSplitContainer
        '
        Me.VendorSplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorSplitContainer.Enabled = False
        Me.VendorSplitContainer.FixedPanel = System.Windows.Forms.FixedPanel.Panel1
        Me.VendorSplitContainer.Location = New System.Drawing.Point(0, 0)
        Me.VendorSplitContainer.Name = "VendorSplitContainer"
        Me.VendorSplitContainer.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'VendorSplitContainer.Panel1
        '
        Me.VendorSplitContainer.Panel1.Controls.Add(Me.VendorInfoSectionPanel)
        Me.VendorSplitContainer.Panel1MinSize = 152
        '
        'VendorSplitContainer.Panel2
        '
        Me.VendorSplitContainer.Panel2.Controls.Add(Me.VendorDetailSectionPanel)
        Me.VendorSplitContainer.Size = New System.Drawing.Size(701, 581)
        Me.VendorSplitContainer.SplitterDistance = 152
        Me.VendorSplitContainer.TabIndex = 2
        '
        'VendorDetailSectionPanel
        '
        Me.VendorDetailSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.VendorDetailSectionPanel.Caption = "Vendor Details"
        Me.VendorDetailSectionPanel.Controls.Add(Me.BottomPanel)
        Me.VendorDetailSectionPanel.Controls.Add(Me.VendorDetailTabControl)
        Me.VendorDetailSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorDetailSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.VendorDetailSectionPanel.Name = "VendorDetailSectionPanel"
        Me.VendorDetailSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.VendorDetailSectionPanel.ShowCaption = True
        Me.VendorDetailSectionPanel.Size = New System.Drawing.Size(701, 425)
        Me.VendorDetailSectionPanel.TabIndex = 1
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.ButtonPanel)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(1, 389)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(699, 35)
        Me.BottomPanel.TabIndex = 5
        '
        'ButtonPanel
        '
        Me.ButtonPanel.Controls.Add(Me.Cancel_Button)
        Me.ButtonPanel.Controls.Add(Me.ApplyButton)
        Me.ButtonPanel.Dock = System.Windows.Forms.DockStyle.Right
        Me.ButtonPanel.Location = New System.Drawing.Point(497, 0)
        Me.ButtonPanel.Name = "ButtonPanel"
        Me.ButtonPanel.Size = New System.Drawing.Size(200, 33)
        Me.ButtonPanel.TabIndex = 3
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Cancel_Button.Location = New System.Drawing.Point(119, 5)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(75, 23)
        Me.Cancel_Button.TabIndex = 3
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'ApplyButton
        '
        Me.ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplyButton.Location = New System.Drawing.Point(38, 5)
        Me.ApplyButton.Name = "ApplyButton"
        Me.ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.ApplyButton.TabIndex = 2
        Me.ApplyButton.Text = "Apply"
        Me.ApplyButton.UseVisualStyleBackColor = True
        '
        'VendorDetailTabControl
        '
        Me.VendorDetailTabControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorDetailTabControl.Controls.Add(Me.ContactsTabPage)
        Me.VendorDetailTabControl.Controls.Add(Me.TableTabPage)
        Me.VendorDetailTabControl.Location = New System.Drawing.Point(7, 38)
        Me.VendorDetailTabControl.Name = "VendorDetailTabControl"
        Me.VendorDetailTabControl.SelectedIndex = 0
        Me.VendorDetailTabControl.Size = New System.Drawing.Size(687, 351)
        Me.VendorDetailTabControl.TabIndex = 1
        '
        'ContactsTabPage
        '
        Me.ContactsTabPage.Controls.Add(Me.ContactsGridControl)
        Me.ContactsTabPage.Location = New System.Drawing.Point(4, 22)
        Me.ContactsTabPage.Name = "ContactsTabPage"
        Me.ContactsTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.ContactsTabPage.Size = New System.Drawing.Size(679, 325)
        Me.ContactsTabPage.TabIndex = 0
        Me.ContactsTabPage.Text = "Contacts"
        Me.ContactsTabPage.UseVisualStyleBackColor = True
        '
        'ContactsGridControl
        '
        Me.ContactsGridControl.ContextMenuStrip = Me.ContactsContextMenuStrip
        Me.ContactsGridControl.DataSource = Me.VendorContactBindingSource
        Me.ContactsGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.EndEdit.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.First.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.Last.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.Next.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.NextPage.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.Prev.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Buttons.PrevPage.Visible = False
        Me.ContactsGridControl.EmbeddedNavigator.Name = ""
        Me.ContactsGridControl.EmbeddedNavigator.TextStringFormat = ""
        Me.ContactsGridControl.Location = New System.Drawing.Point(3, 3)
        Me.ContactsGridControl.MainView = Me.ContactsGridView
        Me.ContactsGridControl.Name = "ContactsGridControl"
        Me.ContactsGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.Phone1TextEdit, Me.Phone2TextEdit})
        Me.ContactsGridControl.Size = New System.Drawing.Size(673, 319)
        Me.ContactsGridControl.TabIndex = 0
        Me.ContactsGridControl.UseEmbeddedNavigator = True
        Me.ContactsGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.ContactsGridView, Me.ContactsExportGridView})
        '
        'ContactsContextMenuStrip
        '
        Me.ContactsContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DeleteRecordToolStripMenuItem})
        Me.ContactsContextMenuStrip.Name = "ContactsContextMenuStrip"
        Me.ContactsContextMenuStrip.Size = New System.Drawing.Size(148, 26)
        '
        'DeleteRecordToolStripMenuItem
        '
        Me.DeleteRecordToolStripMenuItem.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DeleteRed16
        Me.DeleteRecordToolStripMenuItem.Name = "DeleteRecordToolStripMenuItem"
        Me.DeleteRecordToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.DeleteRecordToolStripMenuItem.Text = "Delete Record"
        '
        'VendorContactBindingSource
        '
        Me.VendorContactBindingSource.AllowNew = True
        Me.VendorContactBindingSource.DataSource = GetType(Nrc.QualiSys.Scanning.Library.VendorContact)
        '
        'ContactsGridView
        '
        Me.ContactsGridView.ActiveFilterEnabled = False
        Me.ContactsGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colVendorContactId, Me.colVendorId, Me.colType, Me.colFirstName, Me.colLastName, Me.colemailAddr1, Me.colemailAddr2, Me.colSendFileArrivalEmail, Me.colPhone1, Me.colPhone2, Me.colNotes})
        Me.ContactsGridView.GridControl = Me.ContactsGridControl
        Me.ContactsGridView.Name = "ContactsGridView"
        Me.ContactsGridView.NewItemRowText = "Click Here to Add a New Vendor Contact"
        Me.ContactsGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.ContactsGridView.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        Me.ContactsGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colVendorContactId
        '
        Me.colVendorContactId.Caption = "VendorContactId"
        Me.colVendorContactId.FieldName = "VendorContactId"
        Me.colVendorContactId.Name = "colVendorContactId"
        Me.colVendorContactId.OptionsColumn.ReadOnly = True
        '
        'colVendorId
        '
        Me.colVendorId.Caption = "VendorId"
        Me.colVendorId.FieldName = "VendorId"
        Me.colVendorId.Name = "colVendorId"
        '
        'colType
        '
        Me.colType.Caption = "Type"
        Me.colType.FieldName = "Type"
        Me.colType.Name = "colType"
        Me.colType.Visible = True
        Me.colType.VisibleIndex = 0
        '
        'colFirstName
        '
        Me.colFirstName.Caption = "First Name"
        Me.colFirstName.FieldName = "FirstName"
        Me.colFirstName.Name = "colFirstName"
        Me.colFirstName.Visible = True
        Me.colFirstName.VisibleIndex = 1
        '
        'colLastName
        '
        Me.colLastName.Caption = "Last Name"
        Me.colLastName.FieldName = "LastName"
        Me.colLastName.Name = "colLastName"
        Me.colLastName.Visible = True
        Me.colLastName.VisibleIndex = 2
        '
        'colemailAddr1
        '
        Me.colemailAddr1.Caption = "Email Addr1"
        Me.colemailAddr1.FieldName = "emailAddr1"
        Me.colemailAddr1.Name = "colemailAddr1"
        Me.colemailAddr1.Visible = True
        Me.colemailAddr1.VisibleIndex = 3
        '
        'colemailAddr2
        '
        Me.colemailAddr2.Caption = "Email Addr2"
        Me.colemailAddr2.FieldName = "emailAddr2"
        Me.colemailAddr2.Name = "colemailAddr2"
        Me.colemailAddr2.Visible = True
        Me.colemailAddr2.VisibleIndex = 4
        '
        'colSendFileArrivalEmail
        '
        Me.colSendFileArrivalEmail.Caption = "Send File Email"
        Me.colSendFileArrivalEmail.FieldName = "SendFileArrivalEmail"
        Me.colSendFileArrivalEmail.Name = "colSendFileArrivalEmail"
        Me.colSendFileArrivalEmail.Visible = True
        Me.colSendFileArrivalEmail.VisibleIndex = 5
        '
        'colPhone1
        '
        Me.colPhone1.Caption = "Phone1"
        Me.colPhone1.ColumnEdit = Me.Phone1TextEdit
        Me.colPhone1.FieldName = "Phone1"
        Me.colPhone1.Name = "colPhone1"
        Me.colPhone1.Visible = True
        Me.colPhone1.VisibleIndex = 6
        '
        'Phone1TextEdit
        '
        Me.Phone1TextEdit.AutoHeight = False
        Me.Phone1TextEdit.Mask.EditMask = "###-###-####"
        Me.Phone1TextEdit.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric
        Me.Phone1TextEdit.Mask.UseMaskAsDisplayFormat = True
        Me.Phone1TextEdit.Name = "Phone1TextEdit"
        '
        'colPhone2
        '
        Me.colPhone2.Caption = "Phone2"
        Me.colPhone2.ColumnEdit = Me.Phone2TextEdit
        Me.colPhone2.DisplayFormat.FormatString = "###-###-####"
        Me.colPhone2.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Custom
        Me.colPhone2.FieldName = "Phone2"
        Me.colPhone2.Name = "colPhone2"
        Me.colPhone2.Visible = True
        Me.colPhone2.VisibleIndex = 7
        '
        'Phone2TextEdit
        '
        Me.Phone2TextEdit.AutoHeight = False
        Me.Phone2TextEdit.Mask.EditMask = "###-###-####"
        Me.Phone2TextEdit.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric
        Me.Phone2TextEdit.Mask.UseMaskAsDisplayFormat = True
        Me.Phone2TextEdit.Name = "Phone2TextEdit"
        '
        'colNotes
        '
        Me.colNotes.Caption = "Notes"
        Me.colNotes.FieldName = "Notes"
        Me.colNotes.Name = "colNotes"
        Me.colNotes.Visible = True
        Me.colNotes.VisibleIndex = 8
        '
        'ContactsExportGridView
        '
        Me.ContactsExportGridView.GridControl = Me.ContactsGridControl
        Me.ContactsExportGridView.Name = "ContactsExportGridView"
        '
        'TableTabPage
        '
        Me.TableTabPage.Controls.Add(Me.DispsitionTableToolStrip)
        Me.TableTabPage.Controls.Add(Me.DispositionGridControl)
        Me.TableTabPage.Location = New System.Drawing.Point(4, 22)
        Me.TableTabPage.Name = "TableTabPage"
        Me.TableTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.TableTabPage.Size = New System.Drawing.Size(679, 325)
        Me.TableTabPage.TabIndex = 1
        Me.TableTabPage.Text = "Disposition Table"
        Me.TableTabPage.UseVisualStyleBackColor = True
        '
        'DispsitionTableToolStrip
        '
        Me.DispsitionTableToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.btnDispoImportFile, Me.ToolStripSeparator1, Me.btnDispoExportFile})
        Me.DispsitionTableToolStrip.Location = New System.Drawing.Point(3, 3)
        Me.DispsitionTableToolStrip.Name = "DispsitionTableToolStrip"
        Me.DispsitionTableToolStrip.Size = New System.Drawing.Size(673, 25)
        Me.DispsitionTableToolStrip.TabIndex = 1
        '
        'btnDispoImportFile
        '
        Me.btnDispoImportFile.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnDispoImportFile.Image = CType(resources.GetObject("btnDispoImportFile.Image"), System.Drawing.Image)
        Me.btnDispoImportFile.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnDispoImportFile.Name = "btnDispoImportFile"
        Me.btnDispoImportFile.Size = New System.Drawing.Size(68, 22)
        Me.btnDispoImportFile.Text = "Import File"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'btnDispoExportFile
        '
        Me.btnDispoExportFile.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Excel16
        Me.btnDispoExportFile.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnDispoExportFile.Name = "btnDispoExportFile"
        Me.btnDispoExportFile.Size = New System.Drawing.Size(103, 22)
        Me.btnDispoExportFile.Text = "Export to Excel"
        '
        'DispositionGridControl
        '
        Me.DispositionGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DispositionGridControl.DataSource = Me.VendorDespositionBindingSource
        Me.DispositionGridControl.EmbeddedNavigator.Name = ""
        Me.DispositionGridControl.EmbeddedNavigator.TextStringFormat = ""
        Me.DispositionGridControl.Location = New System.Drawing.Point(3, 31)
        Me.DispositionGridControl.MainView = Me.DispositionGridView
        Me.DispositionGridControl.Name = "DispositionGridControl"
        Me.DispositionGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.NRCDispoLookUpEdit, Me.HCAHPSDisposLookUpEdit, Me.HHCAHPSDisposLookUpEdit})
        Me.DispositionGridControl.Size = New System.Drawing.Size(655, 272)
        Me.DispositionGridControl.TabIndex = 0
        Me.DispositionGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.DispositionGridView})
        '
        'VendorDespositionBindingSource
        '
        Me.VendorDespositionBindingSource.AllowNew = True
        Me.VendorDespositionBindingSource.DataSource = GetType(Nrc.QualiSys.Scanning.Library.VendorDisposition)
        '
        'DispositionGridView
        '
        Me.DispositionGridView.ActiveFilterEnabled = False
        Me.DispositionGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colVendorDispositionCode, Me.colVendorDispositionLabel, Me.colVendorDispositionDesc, Me.colNRCDispo, Me.colHCAHPSDispos, Me.colHHCAHPSDispos, Me.colIsFinal})
        Me.DispositionGridView.GridControl = Me.DispositionGridControl
        Me.DispositionGridView.Name = "DispositionGridView"
        Me.DispositionGridView.NewItemRowText = "Click Here to Add a New Disposition"
        Me.DispositionGridView.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        Me.DispositionGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colVendorDispositionCode
        '
        Me.colVendorDispositionCode.Caption = "Vendor Dispo"
        Me.colVendorDispositionCode.FieldName = "VendorDispositionCode"
        Me.colVendorDispositionCode.Name = "colVendorDispositionCode"
        Me.colVendorDispositionCode.OptionsColumn.ReadOnly = True
        Me.colVendorDispositionCode.Visible = True
        Me.colVendorDispositionCode.VisibleIndex = 0
        '
        'colVendorDispositionLabel
        '
        Me.colVendorDispositionLabel.Caption = "Label"
        Me.colVendorDispositionLabel.FieldName = "VendorDispositionLabel"
        Me.colVendorDispositionLabel.Name = "colVendorDispositionLabel"
        Me.colVendorDispositionLabel.Visible = True
        Me.colVendorDispositionLabel.VisibleIndex = 1
        '
        'colVendorDispositionDesc
        '
        Me.colVendorDispositionDesc.Caption = "Description"
        Me.colVendorDispositionDesc.FieldName = "VendorDispositionDesc"
        Me.colVendorDispositionDesc.Name = "colVendorDispositionDesc"
        Me.colVendorDispositionDesc.Visible = True
        Me.colVendorDispositionDesc.VisibleIndex = 2
        '
        'colNRCDispo
        '
        Me.colNRCDispo.Caption = "NRC Dispo"
        Me.colNRCDispo.ColumnEdit = Me.NRCDispoLookUpEdit
        Me.colNRCDispo.FieldName = "DispositionId"
        Me.colNRCDispo.Name = "colNRCDispo"
        Me.colNRCDispo.Visible = True
        Me.colNRCDispo.VisibleIndex = 3
        '
        'NRCDispoLookUpEdit
        '
        Me.NRCDispoLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.NRCDispoLookUpEdit.AutoHeight = False
        Me.NRCDispoLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.NRCDispoLookUpEdit.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Id", "NRC Dispo", 29, DevExpress.Utils.FormatType.Numeric, "", True, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("DispositionLabel", "DispositionLabel", 82, DevExpress.Utils.FormatType.None, "", False, DevExpress.Utils.HorzAlignment.Near, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("ActionId", "ActionId", 46, DevExpress.Utils.FormatType.Numeric, "", False, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("ReportLabel", "Label", 64, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("HCAHPSValue", "HCAHPS Dispo", 72, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("HCAHPSHierarchy", "HCAHPSHierarchy", 92, DevExpress.Utils.FormatType.Numeric, "", False, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("HHCAHPSValue", "HHCAHPS Dispo", 79, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("HHCAHPSHierarchy", "HHCAHPSHierarchy", 99, DevExpress.Utils.FormatType.Numeric, "", False, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("MustHaveResults", "MustHaveResults", 89, DevExpress.Utils.FormatType.None, "", False, DevExpress.Utils.HorzAlignment.Near, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Action", "Action", 36, DevExpress.Utils.FormatType.Numeric, "", False, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None)})
        Me.NRCDispoLookUpEdit.DataSource = Me.DispositionBindingSource
        Me.NRCDispoLookUpEdit.DisplayMember = "DispositionLabel"
        Me.NRCDispoLookUpEdit.Name = "NRCDispoLookUpEdit"
        Me.NRCDispoLookUpEdit.ValueMember = "Id"
        '
        'DispositionBindingSource
        '
        Me.DispositionBindingSource.DataSource = GetType(Nrc.QualiSys.Library.Disposition)
        '
        'colHCAHPSDispos
        '
        Me.colHCAHPSDispos.Caption = "HCAHPS Dispos"
        Me.colHCAHPSDispos.ColumnEdit = Me.HCAHPSDisposLookUpEdit
        Me.colHCAHPSDispos.FieldName = "DispositionId"
        Me.colHCAHPSDispos.Name = "colHCAHPSDispos"
        Me.colHCAHPSDispos.OptionsColumn.AllowEdit = False
        Me.colHCAHPSDispos.OptionsColumn.ReadOnly = True
        Me.colHCAHPSDispos.Visible = True
        Me.colHCAHPSDispos.VisibleIndex = 4
        '
        'HCAHPSDisposLookUpEdit
        '
        Me.HCAHPSDisposLookUpEdit.AutoHeight = False
        Me.HCAHPSDisposLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.HCAHPSDisposLookUpEdit.DataSource = Me.DispositionBindingSource
        Me.HCAHPSDisposLookUpEdit.DisplayMember = "HCAHPSValue"
        Me.HCAHPSDisposLookUpEdit.Name = "HCAHPSDisposLookUpEdit"
        Me.HCAHPSDisposLookUpEdit.ValueMember = "Id"
        '
        'colHHCAHPSDispos
        '
        Me.colHHCAHPSDispos.Caption = "Home Health CAHPS Dispos"
        Me.colHHCAHPSDispos.ColumnEdit = Me.HHCAHPSDisposLookUpEdit
        Me.colHHCAHPSDispos.FieldName = "DispositionId"
        Me.colHHCAHPSDispos.Name = "colHHCAHPSDispos"
        Me.colHHCAHPSDispos.OptionsColumn.AllowEdit = False
        Me.colHHCAHPSDispos.OptionsColumn.ReadOnly = True
        Me.colHHCAHPSDispos.Visible = True
        Me.colHHCAHPSDispos.VisibleIndex = 5
        '
        'HHCAHPSDisposLookUpEdit
        '
        Me.HHCAHPSDisposLookUpEdit.AutoHeight = False
        Me.HHCAHPSDisposLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.HHCAHPSDisposLookUpEdit.DataSource = Me.DispositionBindingSource
        Me.HHCAHPSDisposLookUpEdit.DisplayMember = "HHCAHPSValue"
        Me.HHCAHPSDisposLookUpEdit.Name = "HHCAHPSDisposLookUpEdit"
        Me.HHCAHPSDisposLookUpEdit.ValueMember = "Id"
        '
        'colIsFinal
        '
        Me.colIsFinal.Caption = "Is Final"
        Me.colIsFinal.FieldName = "IsFinalDisplayText"
        Me.colIsFinal.Name = "colIsFinal"
        Me.colIsFinal.Visible = True
        Me.colIsFinal.VisibleIndex = 6
        '
        'OpenFileDialog
        '
        Me.OpenFileDialog.FileName = "OpenFileDialog1"
        '
        'VendorErrorProvider
        '
        Me.VendorErrorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink
        Me.VendorErrorProvider.ContainerControl = Me
        '
        'VendorMaintenanceSection
        '
        Me.Controls.Add(Me.VendorSplitContainer)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "VendorMaintenanceSection"
        Me.Size = New System.Drawing.Size(701, 581)
        Me.VendorInfoSectionPanel.ResumeLayout(False)
        Me.VendorInfoTableLayoutPanel.ResumeLayout(False)
        Me.VendorInfoRightPanel.ResumeLayout(False)
        Me.VendorInfoRightPanel.PerformLayout()
        Me.VendorInfoLeftPanel.ResumeLayout(False)
        Me.VendorInfoLeftPanel.PerformLayout()
        Me.VendorSplitContainer.Panel1.ResumeLayout(False)
        Me.VendorSplitContainer.Panel2.ResumeLayout(False)
        Me.VendorSplitContainer.ResumeLayout(False)
        Me.VendorDetailSectionPanel.ResumeLayout(False)
        Me.BottomPanel.ResumeLayout(False)
        Me.ButtonPanel.ResumeLayout(False)
        Me.VendorDetailTabControl.ResumeLayout(False)
        Me.ContactsTabPage.ResumeLayout(False)
        CType(Me.ContactsGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ContactsContextMenuStrip.ResumeLayout(False)
        CType(Me.VendorContactBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ContactsGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Phone1TextEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Phone2TextEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ContactsExportGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TableTabPage.ResumeLayout(False)
        Me.TableTabPage.PerformLayout()
        Me.DispsitionTableToolStrip.ResumeLayout(False)
        Me.DispsitionTableToolStrip.PerformLayout()
        CType(Me.DispositionGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorDespositionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DispositionGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NRCDispoLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DispositionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.HCAHPSDisposLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.HHCAHPSDisposLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents VendorInfoSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents VendorInfoTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents VendorInfoRightPanel As System.Windows.Forms.Panel
    Friend WithEvents VendorInfoLeftPanel As System.Windows.Forms.Panel
    Friend WithEvents VendorSplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents VendorDetailSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents txtVendorName As System.Windows.Forms.TextBox
    Friend WithEvents txtVendorCode As System.Windows.Forms.TextBox
    Friend WithEvents lblVendorName As System.Windows.Forms.Label
    Friend WithEvents lblVendorCode As System.Windows.Forms.Label
    Friend WithEvents lblAutoLoad As System.Windows.Forms.Label
    Friend WithEvents VendorDetailTabControl As System.Windows.Forms.TabControl
    Friend WithEvents ContactsTabPage As System.Windows.Forms.TabPage
    Friend WithEvents TableTabPage As System.Windows.Forms.TabPage
    Friend WithEvents ContactsGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents ContactsGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents VendorDespositionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents DispositionGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents DispositionGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents txtNoResponseChar As System.Windows.Forms.TextBox
    Friend WithEvents lblSkipResponseChar As System.Windows.Forms.Label
    Friend WithEvents txtSkipResponseChar As System.Windows.Forms.TextBox
    Friend WithEvents lblMultiRespItemNotPickedChar As System.Windows.Forms.Label
    Friend WithEvents txtMultiRespItemNotPickedChar As System.Windows.Forms.TextBox
    Friend WithEvents lblNoResponseChar As System.Windows.Forms.Label
    Friend WithEvents chkAutoLoad As System.Windows.Forms.CheckBox
    Friend WithEvents DispsitionTableToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents btnDispoImportFile As System.Windows.Forms.ToolStripButton
    Friend WithEvents btnDispoExportFile As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents ButtonPanel As System.Windows.Forms.Panel
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents colVendorDispositionCode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorDispositionLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorDispositionDesc As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNRCDispo As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents VendorContactBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colVendorContactId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFirstName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colLastName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colemailAddr1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colemailAddr2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPhone1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPhone2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNotes As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents NRCDispoLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents DispositionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colHCAHPSDispos As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents HCAHPSDisposLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents colSendFileArrivalEmail As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ContactsExportGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents OpenFileDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents VendorErrorProvider As System.Windows.Forms.ErrorProvider
    Friend WithEvents Phone1TextEdit As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
    Friend WithEvents Phone2TextEdit As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
    Friend WithEvents ContactsContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents DeleteRecordToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents txtLocalFTPLoginName As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cboOutgoingFileType As System.Windows.Forms.ComboBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents colHHCAHPSDispos As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents HHCAHPSDisposLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtRefusedResponseChar As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents txtDontKnowResponseChar As System.Windows.Forms.TextBox
    Friend WithEvents colIsFinal As DevExpress.XtraGrid.Columns.GridColumn

End Class
