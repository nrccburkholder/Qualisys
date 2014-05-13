<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NotificationTestSection
    Inherits Section

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(NotificationTestSection))
        Me.AddressContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.AddAddressToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditAddressToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RemoveAddressToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.NotificationTestImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.NotificationTestSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.cmdSend = New System.Windows.Forms.Button
        Me.tabTemplate = New System.Windows.Forms.TabControl
        Me.tabConfiguration = New System.Windows.Forms.TabPage
        Me.TemplateNameTextBox = New System.Windows.Forms.TextBox
        Me.TemplateIDTextBox = New System.Windows.Forms.TextBox
        Me.FromButton = New System.Windows.Forms.Button
        Me.FromNameTextBox = New System.Windows.Forms.TextBox
        Me.BccListView = New System.Windows.Forms.ListView
        Me.BccEmailHeader = New System.Windows.Forms.ColumnHeader
        Me.BccNameHeader = New System.Windows.Forms.ColumnHeader
        Me.BccLinkHeader = New System.Windows.Forms.ColumnHeader
        Me.BccMergedHeader = New System.Windows.Forms.ColumnHeader
        Me.CcListView = New System.Windows.Forms.ListView
        Me.CcEmailHeader = New System.Windows.Forms.ColumnHeader
        Me.CcNameHeader = New System.Windows.Forms.ColumnHeader
        Me.CcLinkHeader = New System.Windows.Forms.ColumnHeader
        Me.CcMergedHeader = New System.Windows.Forms.ColumnHeader
        Me.ToListView = New System.Windows.Forms.ListView
        Me.ToEmailHeader = New System.Windows.Forms.ColumnHeader
        Me.ToNameHeader = New System.Windows.Forms.ColumnHeader
        Me.ToLinkHeader = New System.Windows.Forms.ColumnHeader
        Me.ToMergedHeader = New System.Windows.Forms.ColumnHeader
        Me.txtSubject = New System.Windows.Forms.TextBox
        Me.FromEmailTextBox = New System.Windows.Forms.TextBox
        Me.txtSMTPServer = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.tabDefinitions = New System.Windows.Forms.TabPage
        Me.dgTableColumnDefs = New System.Windows.Forms.DataGridView
        Me.cboTableNames = New System.Windows.Forms.ComboBox
        Me.lblTableNames = New System.Windows.Forms.Label
        Me.dgFieldDefinitions = New System.Windows.Forms.DataGridView
        Me.lblTableColumnDefs = New System.Windows.Forms.Label
        Me.Label10 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.tabPreview = New System.Windows.Forms.TabPage
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.txtTextView = New System.Windows.Forms.TextBox
        Me.Label12 = New System.Windows.Forms.Label
        Me.txtSubjectLine1 = New System.Windows.Forms.TextBox
        Me.HeaderStrip2 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.txtSubjectLine2 = New System.Windows.Forms.TextBox
        Me.Label11 = New System.Windows.Forms.Label
        Me.wbPreview = New System.Windows.Forms.WebBrowser
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.tabSummary = New System.Windows.Forms.TabPage
        Me.SectionPanel3 = New Nrc.Framework.WinForms.SectionPanel
        Me.wbSummary = New System.Windows.Forms.WebBrowser
        Me.HeaderStrip3 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel3 = New System.Windows.Forms.ToolStripLabel
        Me.AddressContextMenuStrip.SuspendLayout()
        Me.NotificationTestSectionPanel.SuspendLayout()
        Me.tabTemplate.SuspendLayout()
        Me.tabConfiguration.SuspendLayout()
        Me.tabDefinitions.SuspendLayout()
        CType(Me.dgTableColumnDefs, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgFieldDefinitions, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tabPreview.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.HeaderStrip2.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.HeaderStrip1.SuspendLayout()
        Me.tabSummary.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.HeaderStrip3.SuspendLayout()
        Me.SuspendLayout()
        '
        'AddressContextMenuStrip
        '
        Me.AddressContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddAddressToolStripMenuItem, Me.EditAddressToolStripMenuItem, Me.RemoveAddressToolStripMenuItem})
        Me.AddressContextMenuStrip.Name = "AddressContextMenuStrip"
        Me.AddressContextMenuStrip.Size = New System.Drawing.Size(167, 70)
        '
        'AddAddressToolStripMenuItem
        '
        Me.AddAddressToolStripMenuItem.Name = "AddAddressToolStripMenuItem"
        Me.AddAddressToolStripMenuItem.Size = New System.Drawing.Size(166, 22)
        Me.AddAddressToolStripMenuItem.Text = "Add Address"
        '
        'EditAddressToolStripMenuItem
        '
        Me.EditAddressToolStripMenuItem.Name = "EditAddressToolStripMenuItem"
        Me.EditAddressToolStripMenuItem.Size = New System.Drawing.Size(166, 22)
        Me.EditAddressToolStripMenuItem.Text = "Edit Address"
        '
        'RemoveAddressToolStripMenuItem
        '
        Me.RemoveAddressToolStripMenuItem.Name = "RemoveAddressToolStripMenuItem"
        Me.RemoveAddressToolStripMenuItem.Size = New System.Drawing.Size(166, 22)
        Me.RemoveAddressToolStripMenuItem.Text = "Remove Address"
        '
        'NotificationTestImageList
        '
        Me.NotificationTestImageList.ImageStream = CType(resources.GetObject("NotificationTestImageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.NotificationTestImageList.TransparentColor = System.Drawing.Color.Transparent
        Me.NotificationTestImageList.Images.SetKeyName(0, "EmailAddress")
        '
        'NotificationTestSectionPanel
        '
        Me.NotificationTestSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.NotificationTestSectionPanel.Caption = "Test Template"
        Me.NotificationTestSectionPanel.Controls.Add(Me.cmdSend)
        Me.NotificationTestSectionPanel.Controls.Add(Me.tabTemplate)
        Me.NotificationTestSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.NotificationTestSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.NotificationTestSectionPanel.Name = "NotificationTestSectionPanel"
        Me.NotificationTestSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.NotificationTestSectionPanel.ShowCaption = True
        Me.NotificationTestSectionPanel.Size = New System.Drawing.Size(687, 704)
        Me.NotificationTestSectionPanel.TabIndex = 2
        '
        'cmdSend
        '
        Me.cmdSend.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdSend.Location = New System.Drawing.Point(604, 669)
        Me.cmdSend.Name = "cmdSend"
        Me.cmdSend.Size = New System.Drawing.Size(75, 23)
        Me.cmdSend.TabIndex = 3
        Me.cmdSend.Text = "Send"
        Me.cmdSend.UseVisualStyleBackColor = True
        '
        'tabTemplate
        '
        Me.tabTemplate.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabTemplate.Controls.Add(Me.tabConfiguration)
        Me.tabTemplate.Controls.Add(Me.tabDefinitions)
        Me.tabTemplate.Controls.Add(Me.tabPreview)
        Me.tabTemplate.Controls.Add(Me.tabSummary)
        Me.tabTemplate.Location = New System.Drawing.Point(4, 31)
        Me.tabTemplate.Name = "tabTemplate"
        Me.tabTemplate.SelectedIndex = 0
        Me.tabTemplate.Size = New System.Drawing.Size(679, 627)
        Me.tabTemplate.TabIndex = 1
        '
        'tabConfiguration
        '
        Me.tabConfiguration.Controls.Add(Me.TemplateNameTextBox)
        Me.tabConfiguration.Controls.Add(Me.TemplateIDTextBox)
        Me.tabConfiguration.Controls.Add(Me.FromButton)
        Me.tabConfiguration.Controls.Add(Me.FromNameTextBox)
        Me.tabConfiguration.Controls.Add(Me.BccListView)
        Me.tabConfiguration.Controls.Add(Me.CcListView)
        Me.tabConfiguration.Controls.Add(Me.ToListView)
        Me.tabConfiguration.Controls.Add(Me.txtSubject)
        Me.tabConfiguration.Controls.Add(Me.FromEmailTextBox)
        Me.tabConfiguration.Controls.Add(Me.txtSMTPServer)
        Me.tabConfiguration.Controls.Add(Me.Label8)
        Me.tabConfiguration.Controls.Add(Me.Label7)
        Me.tabConfiguration.Controls.Add(Me.Label6)
        Me.tabConfiguration.Controls.Add(Me.Label2)
        Me.tabConfiguration.Controls.Add(Me.Label5)
        Me.tabConfiguration.Controls.Add(Me.Label4)
        Me.tabConfiguration.Controls.Add(Me.Label3)
        Me.tabConfiguration.Controls.Add(Me.Label1)
        Me.tabConfiguration.Location = New System.Drawing.Point(4, 22)
        Me.tabConfiguration.Name = "tabConfiguration"
        Me.tabConfiguration.Padding = New System.Windows.Forms.Padding(3)
        Me.tabConfiguration.Size = New System.Drawing.Size(671, 601)
        Me.tabConfiguration.TabIndex = 0
        Me.tabConfiguration.Text = "Configuration"
        Me.tabConfiguration.UseVisualStyleBackColor = True
        '
        'TemplateNameTextBox
        '
        Me.TemplateNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TemplateNameTextBox.Location = New System.Drawing.Point(127, 38)
        Me.TemplateNameTextBox.Name = "TemplateNameTextBox"
        Me.TemplateNameTextBox.ReadOnly = True
        Me.TemplateNameTextBox.Size = New System.Drawing.Size(524, 21)
        Me.TemplateNameTextBox.TabIndex = 23
        '
        'TemplateIDTextBox
        '
        Me.TemplateIDTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TemplateIDTextBox.Location = New System.Drawing.Point(127, 11)
        Me.TemplateIDTextBox.Name = "TemplateIDTextBox"
        Me.TemplateIDTextBox.ReadOnly = True
        Me.TemplateIDTextBox.Size = New System.Drawing.Size(524, 21)
        Me.TemplateIDTextBox.TabIndex = 22
        '
        'FromButton
        '
        Me.FromButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FromButton.Location = New System.Drawing.Point(618, 90)
        Me.FromButton.Name = "FromButton"
        Me.FromButton.Size = New System.Drawing.Size(33, 23)
        Me.FromButton.TabIndex = 21
        Me.FromButton.Text = "..."
        Me.FromButton.UseVisualStyleBackColor = True
        '
        'FromNameTextBox
        '
        Me.FromNameTextBox.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FromNameTextBox.Location = New System.Drawing.Point(451, 91)
        Me.FromNameTextBox.Name = "FromNameTextBox"
        Me.FromNameTextBox.ReadOnly = True
        Me.FromNameTextBox.Size = New System.Drawing.Size(161, 21)
        Me.FromNameTextBox.TabIndex = 20
        '
        'BccListView
        '
        Me.BccListView.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BccListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.BccEmailHeader, Me.BccNameHeader, Me.BccLinkHeader, Me.BccMergedHeader})
        Me.BccListView.ContextMenuStrip = Me.AddressContextMenuStrip
        Me.BccListView.FullRowSelect = True
        Me.BccListView.GridLines = True
        Me.BccListView.Location = New System.Drawing.Point(23, 489)
        Me.BccListView.MultiSelect = False
        Me.BccListView.Name = "BccListView"
        Me.BccListView.Size = New System.Drawing.Size(628, 93)
        Me.BccListView.SmallImageList = Me.NotificationTestImageList
        Me.BccListView.TabIndex = 19
        Me.BccListView.UseCompatibleStateImageBehavior = False
        Me.BccListView.View = System.Windows.Forms.View.Details
        '
        'BccEmailHeader
        '
        Me.BccEmailHeader.Text = "Email Address"
        Me.BccEmailHeader.Width = 178
        '
        'BccNameHeader
        '
        Me.BccNameHeader.Text = "Name"
        Me.BccNameHeader.Width = 124
        '
        'BccLinkHeader
        '
        Me.BccLinkHeader.Text = "Link"
        Me.BccLinkHeader.Width = 153
        '
        'BccMergedHeader
        '
        Me.BccMergedHeader.Text = "Merged"
        Me.BccMergedHeader.Width = 167
        '
        'CcListView
        '
        Me.CcListView.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CcListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.CcEmailHeader, Me.CcNameHeader, Me.CcLinkHeader, Me.CcMergedHeader})
        Me.CcListView.ContextMenuStrip = Me.AddressContextMenuStrip
        Me.CcListView.FullRowSelect = True
        Me.CcListView.GridLines = True
        Me.CcListView.Location = New System.Drawing.Point(23, 370)
        Me.CcListView.MultiSelect = False
        Me.CcListView.Name = "CcListView"
        Me.CcListView.Size = New System.Drawing.Size(628, 93)
        Me.CcListView.SmallImageList = Me.NotificationTestImageList
        Me.CcListView.TabIndex = 18
        Me.CcListView.UseCompatibleStateImageBehavior = False
        Me.CcListView.View = System.Windows.Forms.View.Details
        '
        'CcEmailHeader
        '
        Me.CcEmailHeader.Text = "Email Address"
        Me.CcEmailHeader.Width = 178
        '
        'CcNameHeader
        '
        Me.CcNameHeader.Text = "Name"
        Me.CcNameHeader.Width = 124
        '
        'CcLinkHeader
        '
        Me.CcLinkHeader.Text = "Link"
        Me.CcLinkHeader.Width = 153
        '
        'CcMergedHeader
        '
        Me.CcMergedHeader.Text = "Merged"
        Me.CcMergedHeader.Width = 167
        '
        'ToListView
        '
        Me.ToListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ToListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ToEmailHeader, Me.ToNameHeader, Me.ToLinkHeader, Me.ToMergedHeader})
        Me.ToListView.ContextMenuStrip = Me.AddressContextMenuStrip
        Me.ToListView.FullRowSelect = True
        Me.ToListView.GridLines = True
        Me.ToListView.Location = New System.Drawing.Point(23, 160)
        Me.ToListView.MultiSelect = False
        Me.ToListView.Name = "ToListView"
        Me.ToListView.Size = New System.Drawing.Size(628, 182)
        Me.ToListView.SmallImageList = Me.NotificationTestImageList
        Me.ToListView.TabIndex = 17
        Me.ToListView.UseCompatibleStateImageBehavior = False
        Me.ToListView.View = System.Windows.Forms.View.Details
        '
        'ToEmailHeader
        '
        Me.ToEmailHeader.Text = "Email Address"
        Me.ToEmailHeader.Width = 178
        '
        'ToNameHeader
        '
        Me.ToNameHeader.Text = "Name"
        Me.ToNameHeader.Width = 124
        '
        'ToLinkHeader
        '
        Me.ToLinkHeader.Text = "Link"
        Me.ToLinkHeader.Width = 153
        '
        'ToMergedHeader
        '
        Me.ToMergedHeader.Text = "Merged"
        Me.ToMergedHeader.Width = 167
        '
        'txtSubject
        '
        Me.txtSubject.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSubject.Location = New System.Drawing.Point(127, 117)
        Me.txtSubject.Name = "txtSubject"
        Me.txtSubject.ReadOnly = True
        Me.txtSubject.Size = New System.Drawing.Size(524, 21)
        Me.txtSubject.TabIndex = 12
        '
        'FromEmailTextBox
        '
        Me.FromEmailTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FromEmailTextBox.Location = New System.Drawing.Point(127, 91)
        Me.FromEmailTextBox.Name = "FromEmailTextBox"
        Me.FromEmailTextBox.ReadOnly = True
        Me.FromEmailTextBox.Size = New System.Drawing.Size(318, 21)
        Me.FromEmailTextBox.TabIndex = 11
        '
        'txtSMTPServer
        '
        Me.txtSMTPServer.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSMTPServer.Location = New System.Drawing.Point(127, 65)
        Me.txtSMTPServer.Name = "txtSMTPServer"
        Me.txtSMTPServer.ReadOnly = True
        Me.txtSMTPServer.Size = New System.Drawing.Size(524, 21)
        Me.txtSMTPServer.TabIndex = 10
        '
        'Label8
        '
        Me.Label8.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(20, 473)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(54, 13)
        Me.Label8.TabIndex = 8
        Me.Label8.Text = "Email Bcc:"
        '
        'Label7
        '
        Me.Label7.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(20, 354)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(50, 13)
        Me.Label7.TabIndex = 7
        Me.Label7.Text = "Email Cc:"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(20, 143)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(50, 13)
        Me.Label6.TabIndex = 6
        Me.Label6.Text = "Email To:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(20, 120)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(74, 13)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Email Subject:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(20, 94)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(62, 13)
        Me.Label5.TabIndex = 4
        Me.Label5.Text = "Email From:"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(20, 68)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(72, 13)
        Me.Label4.TabIndex = 3
        Me.Label4.Text = "SMTP Server:"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(20, 41)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(85, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Template Name:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(23, 14)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(69, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Template ID:"
        '
        'tabDefinitions
        '
        Me.tabDefinitions.Controls.Add(Me.dgTableColumnDefs)
        Me.tabDefinitions.Controls.Add(Me.cboTableNames)
        Me.tabDefinitions.Controls.Add(Me.lblTableNames)
        Me.tabDefinitions.Controls.Add(Me.dgFieldDefinitions)
        Me.tabDefinitions.Controls.Add(Me.lblTableColumnDefs)
        Me.tabDefinitions.Controls.Add(Me.Label10)
        Me.tabDefinitions.Controls.Add(Me.Label9)
        Me.tabDefinitions.Location = New System.Drawing.Point(4, 22)
        Me.tabDefinitions.Name = "tabDefinitions"
        Me.tabDefinitions.Padding = New System.Windows.Forms.Padding(3)
        Me.tabDefinitions.Size = New System.Drawing.Size(671, 601)
        Me.tabDefinitions.TabIndex = 1
        Me.tabDefinitions.Text = "Definitions"
        Me.tabDefinitions.UseVisualStyleBackColor = True
        '
        'dgTableColumnDefs
        '
        Me.dgTableColumnDefs.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgTableColumnDefs.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgTableColumnDefs.Location = New System.Drawing.Point(23, 348)
        Me.dgTableColumnDefs.Name = "dgTableColumnDefs"
        Me.dgTableColumnDefs.Size = New System.Drawing.Size(636, 279)
        Me.dgTableColumnDefs.TabIndex = 9
        Me.dgTableColumnDefs.Visible = False
        '
        'cboTableNames
        '
        Me.cboTableNames.FormattingEnabled = True
        Me.cboTableNames.Location = New System.Drawing.Point(99, 301)
        Me.cboTableNames.Name = "cboTableNames"
        Me.cboTableNames.Size = New System.Drawing.Size(121, 21)
        Me.cboTableNames.TabIndex = 8
        Me.cboTableNames.Visible = False
        '
        'lblTableNames
        '
        Me.lblTableNames.AutoSize = True
        Me.lblTableNames.Location = New System.Drawing.Point(99, 304)
        Me.lblTableNames.Name = "lblTableNames"
        Me.lblTableNames.Size = New System.Drawing.Size(187, 13)
        Me.lblTableNames.TabIndex = 7
        Me.lblTableNames.Text = "There are no tables for this template."
        '
        'dgFieldDefinitions
        '
        Me.dgFieldDefinitions.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgFieldDefinitions.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgFieldDefinitions.Location = New System.Drawing.Point(23, 36)
        Me.dgFieldDefinitions.Name = "dgFieldDefinitions"
        Me.dgFieldDefinitions.Size = New System.Drawing.Size(636, 259)
        Me.dgFieldDefinitions.TabIndex = 6
        '
        'lblTableColumnDefs
        '
        Me.lblTableColumnDefs.AutoSize = True
        Me.lblTableColumnDefs.Location = New System.Drawing.Point(20, 332)
        Me.lblTableColumnDefs.Name = "lblTableColumnDefs"
        Me.lblTableColumnDefs.Size = New System.Drawing.Size(128, 13)
        Me.lblTableColumnDefs.TabIndex = 5
        Me.lblTableColumnDefs.Text = "Table Column Definitions:"
        Me.lblTableColumnDefs.Visible = False
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(20, 304)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(72, 13)
        Me.Label10.TabIndex = 1
        Me.Label10.Text = "Table Names:"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(20, 20)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(86, 13)
        Me.Label9.TabIndex = 0
        Me.Label9.Text = "Field Definitions:"
        '
        'tabPreview
        '
        Me.tabPreview.Controls.Add(Me.SplitContainer1)
        Me.tabPreview.Location = New System.Drawing.Point(4, 22)
        Me.tabPreview.Name = "tabPreview"
        Me.tabPreview.Size = New System.Drawing.Size(671, 601)
        Me.tabPreview.TabIndex = 2
        Me.tabPreview.Text = "Preview"
        Me.tabPreview.UseVisualStyleBackColor = True
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
        Me.SplitContainer1.Panel1.Controls.Add(Me.SectionPanel2)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.SectionPanel1)
        Me.SplitContainer1.Size = New System.Drawing.Size(671, 601)
        Me.SplitContainer1.SplitterDistance = 259
        Me.SplitContainer1.TabIndex = 1
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = ""
        Me.SectionPanel2.Controls.Add(Me.txtTextView)
        Me.SectionPanel2.Controls.Add(Me.Label12)
        Me.SectionPanel2.Controls.Add(Me.txtSubjectLine1)
        Me.SectionPanel2.Controls.Add(Me.HeaderStrip2)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = False
        Me.SectionPanel2.Size = New System.Drawing.Size(671, 259)
        Me.SectionPanel2.TabIndex = 0
        '
        'txtTextView
        '
        Me.txtTextView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtTextView.Font = New System.Drawing.Font("Times New Roman", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTextView.Location = New System.Drawing.Point(14, 51)
        Me.txtTextView.Multiline = True
        Me.txtTextView.Name = "txtTextView"
        Me.txtTextView.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtTextView.Size = New System.Drawing.Size(636, 204)
        Me.txtTextView.TabIndex = 3
        '
        'Label12
        '
        Me.Label12.AutoSize = True
        Me.Label12.Location = New System.Drawing.Point(11, 35)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(47, 13)
        Me.Label12.TabIndex = 2
        Me.Label12.Text = "Subject:"
        '
        'txtSubjectLine1
        '
        Me.txtSubjectLine1.Location = New System.Drawing.Point(63, 28)
        Me.txtSubjectLine1.Name = "txtSubjectLine1"
        Me.txtSubjectLine1.Size = New System.Drawing.Size(589, 21)
        Me.txtSubjectLine1.TabIndex = 1
        '
        'HeaderStrip2
        '
        Me.HeaderStrip2.AutoSize = False
        Me.HeaderStrip2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip2.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip2.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel2})
        Me.HeaderStrip2.Location = New System.Drawing.Point(1, 1)
        Me.HeaderStrip2.Name = "HeaderStrip2"
        Me.HeaderStrip2.Size = New System.Drawing.Size(669, 25)
        Me.HeaderStrip2.TabIndex = 0
        Me.HeaderStrip2.Text = "HeaderStrip2"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(92, 22)
        Me.ToolStripLabel2.Text = "Text View"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Controls.Add(Me.txtSubjectLine2)
        Me.SectionPanel1.Controls.Add(Me.Label11)
        Me.SectionPanel1.Controls.Add(Me.wbPreview)
        Me.SectionPanel1.Controls.Add(Me.HeaderStrip1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = False
        Me.SectionPanel1.Size = New System.Drawing.Size(671, 338)
        Me.SectionPanel1.TabIndex = 0
        '
        'txtSubjectLine2
        '
        Me.txtSubjectLine2.Location = New System.Drawing.Point(63, 37)
        Me.txtSubjectLine2.Name = "txtSubjectLine2"
        Me.txtSubjectLine2.Size = New System.Drawing.Size(589, 21)
        Me.txtSubjectLine2.TabIndex = 6
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(11, 40)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(47, 13)
        Me.Label11.TabIndex = 5
        Me.Label11.Text = "Subject:"
        '
        'wbPreview
        '
        Me.wbPreview.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.wbPreview.Location = New System.Drawing.Point(14, 63)
        Me.wbPreview.MinimumSize = New System.Drawing.Size(20, 20)
        Me.wbPreview.Name = "wbPreview"
        Me.wbPreview.Size = New System.Drawing.Size(636, 262)
        Me.wbPreview.TabIndex = 4
        Me.wbPreview.Url = New System.Uri("http://www.google.com", System.UriKind.Absolute)
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(1, 1)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(669, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HTML View"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(100, 22)
        Me.ToolStripLabel1.Text = "HTML View"
        '
        'tabSummary
        '
        Me.tabSummary.Controls.Add(Me.SectionPanel3)
        Me.tabSummary.Location = New System.Drawing.Point(4, 22)
        Me.tabSummary.Name = "tabSummary"
        Me.tabSummary.Size = New System.Drawing.Size(671, 601)
        Me.tabSummary.TabIndex = 3
        Me.tabSummary.Text = "Summary"
        Me.tabSummary.UseVisualStyleBackColor = True
        '
        'SectionPanel3
        '
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel3.Caption = ""
        Me.SectionPanel3.Controls.Add(Me.wbSummary)
        Me.SectionPanel3.Controls.Add(Me.HeaderStrip3)
        Me.SectionPanel3.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel3.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel3.ShowCaption = False
        Me.SectionPanel3.Size = New System.Drawing.Size(671, 601)
        Me.SectionPanel3.TabIndex = 0
        '
        'wbSummary
        '
        Me.wbSummary.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.wbSummary.Location = New System.Drawing.Point(4, 29)
        Me.wbSummary.MinimumSize = New System.Drawing.Size(20, 20)
        Me.wbSummary.Name = "wbSummary"
        Me.wbSummary.Size = New System.Drawing.Size(663, 568)
        Me.wbSummary.TabIndex = 3
        Me.wbSummary.Url = New System.Uri("http://www.google.com", System.UriKind.Absolute)
        '
        'HeaderStrip3
        '
        Me.HeaderStrip3.AutoSize = False
        Me.HeaderStrip3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip3.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip3.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip3.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip3.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel3})
        Me.HeaderStrip3.Location = New System.Drawing.Point(1, 1)
        Me.HeaderStrip3.Name = "HeaderStrip3"
        Me.HeaderStrip3.Size = New System.Drawing.Size(669, 25)
        Me.HeaderStrip3.TabIndex = 0
        Me.HeaderStrip3.Text = "HeaderStrip3"
        '
        'ToolStripLabel3
        '
        Me.ToolStripLabel3.Name = "ToolStripLabel3"
        Me.ToolStripLabel3.Size = New System.Drawing.Size(160, 22)
        Me.ToolStripLabel3.Text = "Message Summary"
        '
        'NotificationTestSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoScroll = True
        Me.Controls.Add(Me.NotificationTestSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MinimumSize = New System.Drawing.Size(500, 600)
        Me.Name = "NotificationTestSection"
        Me.Size = New System.Drawing.Size(687, 704)
        Me.AddressContextMenuStrip.ResumeLayout(False)
        Me.NotificationTestSectionPanel.ResumeLayout(False)
        Me.tabTemplate.ResumeLayout(False)
        Me.tabConfiguration.ResumeLayout(False)
        Me.tabConfiguration.PerformLayout()
        Me.tabDefinitions.ResumeLayout(False)
        Me.tabDefinitions.PerformLayout()
        CType(Me.dgTableColumnDefs, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgFieldDefinitions, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tabPreview.ResumeLayout(False)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel2.PerformLayout()
        Me.HeaderStrip2.ResumeLayout(False)
        Me.HeaderStrip2.PerformLayout()
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.tabSummary.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.HeaderStrip3.ResumeLayout(False)
        Me.HeaderStrip3.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents AddressContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents AddAddressToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditAddressToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RemoveAddressToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NotificationTestImageList As System.Windows.Forms.ImageList
    Friend WithEvents NotificationTestSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents tabTemplate As System.Windows.Forms.TabControl
    Friend WithEvents tabConfiguration As System.Windows.Forms.TabPage
    Friend WithEvents TemplateNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents TemplateIDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents FromButton As System.Windows.Forms.Button
    Friend WithEvents FromNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents tabDefinitions As System.Windows.Forms.TabPage
    Friend WithEvents tabPreview As System.Windows.Forms.TabPage
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lblTemplateID As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtSMTPServer As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents tabSummary As System.Windows.Forms.TabPage
    Friend WithEvents txtFrom As System.Windows.Forms.TextBox
    Friend WithEvents txtSubject As System.Windows.Forms.TextBox
    Friend WithEvents cmdSend As System.Windows.Forms.Button
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents lblTableColumnDefs As System.Windows.Forms.Label
    Friend WithEvents lblTemplateName As System.Windows.Forms.Label
    Friend WithEvents dgFieldDefinitions As System.Windows.Forms.DataGridView
    Friend WithEvents dgTableColumnDefs As System.Windows.Forms.DataGridView
    Friend WithEvents cboTableNames As System.Windows.Forms.ComboBox
    Friend WithEvents lblTableNames As System.Windows.Forms.Label
    Friend WithEvents ToListView As System.Windows.Forms.ListView
    Friend WithEvents ToEmailHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents ToNameHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents ToLinkHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents ToMergedHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents BccListView As System.Windows.Forms.ListView
    Friend WithEvents BccEmailHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents BccNameHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents BccLinkHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents BccMergedHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents CcListView As System.Windows.Forms.ListView
    Friend WithEvents CcEmailHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents CcNameHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents CcLinkHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents CcMergedHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents FromEmailTextBox As System.Windows.Forms.TextBox
    Friend WithEvents wbPreview As System.Windows.Forms.WebBrowser
    Friend WithEvents wbSummary As System.Windows.Forms.WebBrowser
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents txtSubjectLine2 As System.Windows.Forms.TextBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents txtSubjectLine1 As System.Windows.Forms.TextBox
    Friend WithEvents HeaderStrip2 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents txtTextView As System.Windows.Forms.TextBox
    Friend WithEvents SectionPanel3 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents HeaderStrip3 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel3 As System.Windows.Forms.ToolStripLabel

End Class
