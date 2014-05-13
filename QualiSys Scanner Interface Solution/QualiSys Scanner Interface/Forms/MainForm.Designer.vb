<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
    Inherits System.Windows.Forms.Form

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
        Me.MainMenu = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.toolStripSeparator = New System.Windows.Forms.ToolStripSeparator
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.HelpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ContentsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.IndexToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.SearchToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.toolStripSeparator5 = New System.Windows.Forms.ToolStripSeparator
        Me.AboutToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.StatusStrip = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane
        Me.ImportTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.BarcodeTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.TransferResultsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.VendorMaintenanceTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.SurveyVendorTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.VendorFileTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.DataEntryTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.DataVerificationTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.MainMenu.SuspendLayout()
        Me.ToolStripContainer1.BottomToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.ContentPanel.SuspendLayout()
        Me.ToolStripContainer1.TopToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.SuspendLayout()
        Me.StatusStrip.SuspendLayout()
        Me.MainPanel.Panel1.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainMenu
        '
        Me.MainMenu.Dock = System.Windows.Forms.DockStyle.None
        Me.MainMenu.GripStyle = System.Windows.Forms.ToolStripGripStyle.Visible
        Me.MainMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.ToolsToolStripMenuItem, Me.HelpToolStripMenuItem})
        Me.MainMenu.Location = New System.Drawing.Point(0, 0)
        Me.MainMenu.Name = "MainMenu"
        Me.MainMenu.Size = New System.Drawing.Size(712, 24)
        Me.MainMenu.TabIndex = 0
        Me.MainMenu.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.toolStripSeparator, Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(37, 20)
        Me.FileToolStripMenuItem.Text = "&File"
        '
        'toolStripSeparator
        '
        Me.toolStripSeparator.Name = "toolStripSeparator"
        Me.toolStripSeparator.Size = New System.Drawing.Size(89, 6)
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(92, 22)
        Me.ExitToolStripMenuItem.Text = "E&xit"
        '
        'ToolsToolStripMenuItem
        '
        Me.ToolsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OptionsToolStripMenuItem})
        Me.ToolsToolStripMenuItem.Name = "ToolsToolStripMenuItem"
        Me.ToolsToolStripMenuItem.Size = New System.Drawing.Size(48, 20)
        Me.ToolsToolStripMenuItem.Text = "&Tools"
        '
        'OptionsToolStripMenuItem
        '
        Me.OptionsToolStripMenuItem.Name = "OptionsToolStripMenuItem"
        Me.OptionsToolStripMenuItem.Size = New System.Drawing.Size(125, 22)
        Me.OptionsToolStripMenuItem.Text = "&Options..."
        '
        'HelpToolStripMenuItem
        '
        Me.HelpToolStripMenuItem.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.HelpToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ContentsToolStripMenuItem, Me.IndexToolStripMenuItem, Me.SearchToolStripMenuItem, Me.toolStripSeparator5, Me.AboutToolStripMenuItem})
        Me.HelpToolStripMenuItem.Name = "HelpToolStripMenuItem"
        Me.HelpToolStripMenuItem.Size = New System.Drawing.Size(44, 20)
        Me.HelpToolStripMenuItem.Text = "&Help"
        Me.HelpToolStripMenuItem.Visible = False
        '
        'ContentsToolStripMenuItem
        '
        Me.ContentsToolStripMenuItem.Name = "ContentsToolStripMenuItem"
        Me.ContentsToolStripMenuItem.Size = New System.Drawing.Size(122, 22)
        Me.ContentsToolStripMenuItem.Text = "&Contents"
        '
        'IndexToolStripMenuItem
        '
        Me.IndexToolStripMenuItem.Name = "IndexToolStripMenuItem"
        Me.IndexToolStripMenuItem.Size = New System.Drawing.Size(122, 22)
        Me.IndexToolStripMenuItem.Text = "&Index"
        '
        'SearchToolStripMenuItem
        '
        Me.SearchToolStripMenuItem.Name = "SearchToolStripMenuItem"
        Me.SearchToolStripMenuItem.Size = New System.Drawing.Size(122, 22)
        Me.SearchToolStripMenuItem.Text = "&Search"
        '
        'toolStripSeparator5
        '
        Me.toolStripSeparator5.Name = "toolStripSeparator5"
        Me.toolStripSeparator5.Size = New System.Drawing.Size(119, 6)
        '
        'AboutToolStripMenuItem
        '
        Me.AboutToolStripMenuItem.Name = "AboutToolStripMenuItem"
        Me.AboutToolStripMenuItem.Size = New System.Drawing.Size(122, 22)
        Me.AboutToolStripMenuItem.Text = "&About..."
        '
        'ToolStripContainer1
        '
        '
        'ToolStripContainer1.BottomToolStripPanel
        '
        Me.ToolStripContainer1.BottomToolStripPanel.Controls.Add(Me.StatusStrip)
        '
        'ToolStripContainer1.ContentPanel
        '
        Me.ToolStripContainer1.ContentPanel.Controls.Add(Me.MainPanel)
        Me.ToolStripContainer1.ContentPanel.Size = New System.Drawing.Size(712, 425)
        Me.ToolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStripContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStripContainer1.Name = "ToolStripContainer1"
        Me.ToolStripContainer1.Size = New System.Drawing.Size(712, 473)
        Me.ToolStripContainer1.TabIndex = 1
        Me.ToolStripContainer1.Text = "ToolStripContainer1"
        '
        'ToolStripContainer1.TopToolStripPanel
        '
        Me.ToolStripContainer1.TopToolStripPanel.Controls.Add(Me.MainMenu)
        '
        'StatusStrip
        '
        Me.StatusStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.StatusStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Visible
        Me.StatusStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StatusLabel, Me.UserNameLabel, Me.VersionLabel, Me.EnvironmentLabel})
        Me.StatusStrip.Location = New System.Drawing.Point(0, 0)
        Me.StatusStrip.Name = "StatusStrip"
        Me.StatusStrip.Size = New System.Drawing.Size(712, 24)
        Me.StatusStrip.TabIndex = 0
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(533, 19)
        Me.StatusLabel.Spring = True
        Me.StatusLabel.Text = "Ready."
        Me.StatusLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'UserNameLabel
        '
        Me.UserNameLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.UserNameLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.UserNameLabel.Name = "UserNameLabel"
        Me.UserNameLabel.Size = New System.Drawing.Size(36, 19)
        Me.UserNameLabel.Text = "JDoe"
        '
        'VersionLabel
        '
        Me.VersionLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.VersionLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.VersionLabel.Name = "VersionLabel"
        Me.VersionLabel.Size = New System.Drawing.Size(50, 19)
        Me.VersionLabel.Text = "v1.0.0.0"
        '
        'EnvironmentLabel
        '
        Me.EnvironmentLabel.Name = "EnvironmentLabel"
        Me.EnvironmentLabel.Size = New System.Drawing.Size(78, 19)
        Me.EnvironmentLabel.Text = "Development"
        '
        'MainPanel
        '
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.FixedPanel = System.Windows.Forms.FixedPanel.Panel1
        Me.MainPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainPanel.Name = "MainPanel"
        '
        'MainPanel.Panel1
        '
        Me.MainPanel.Panel1.Controls.Add(Me.MultiPane)
        Me.MainPanel.Panel1.Padding = New System.Windows.Forms.Padding(1)
        '
        'MainPanel.Panel2
        '
        Me.MainPanel.Panel2.Padding = New System.Windows.Forms.Padding(1)
        Me.MainPanel.Size = New System.Drawing.Size(712, 425)
        Me.MainPanel.SplitterDistance = 218
        Me.MainPanel.TabIndex = 0
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(1, 1)
        Me.MultiPane.MaxShownTabs = 6
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(216, 423)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.ImportTab)
        Me.MultiPane.Tabs.Add(Me.BarcodeTab)
        Me.MultiPane.Tabs.Add(Me.TransferResultsTab)
        Me.MultiPane.Tabs.Add(Me.VendorMaintenanceTab)
        Me.MultiPane.Tabs.Add(Me.SurveyVendorTab)
        Me.MultiPane.Tabs.Add(Me.VendorFileTab)
        Me.MultiPane.Tabs.Add(Me.DataEntryTab)
        Me.MultiPane.Tabs.Add(Me.DataVerificationTab)
        Me.MultiPane.Text = "MultiPane"
        '
        'ImportTab
        '
        Me.ImportTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImportTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ImportTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ImportTab.Icon = CType(resources.GetObject("ImportTab.Icon"), System.Drawing.Icon)
        Me.ImportTab.Image = CType(resources.GetObject("ImportTab.Image"), System.Drawing.Image)
        Me.ImportTab.IsActive = True
        Me.ImportTab.Location = New System.Drawing.Point(0, 0)
        Me.ImportTab.Name = "ImportTab"
        Me.ImportTab.NavControlId = Nothing
        Me.ImportTab.NavControlType = Nothing
        Me.ImportTab.Padding = New System.Windows.Forms.Padding(2)
        Me.ImportTab.Size = New System.Drawing.Size(216, 32)
        Me.ImportTab.TabIndex = 0
        Me.ImportTab.Text = "Import"
        '
        'BarcodeTab
        '
        Me.BarcodeTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodeTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.BarcodeTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.BarcodeTab.Icon = CType(resources.GetObject("BarcodeTab.Icon"), System.Drawing.Icon)
        Me.BarcodeTab.Image = CType(resources.GetObject("BarcodeTab.Image"), System.Drawing.Image)
        Me.BarcodeTab.IsActive = False
        Me.BarcodeTab.Location = New System.Drawing.Point(0, 32)
        Me.BarcodeTab.Name = "BarcodeTab"
        Me.BarcodeTab.NavControlId = Nothing
        Me.BarcodeTab.NavControlType = Nothing
        Me.BarcodeTab.Padding = New System.Windows.Forms.Padding(2)
        Me.BarcodeTab.Size = New System.Drawing.Size(216, 32)
        Me.BarcodeTab.TabIndex = 1
        Me.BarcodeTab.Text = "Barcode Search"
        '
        'TransferResultsTab
        '
        Me.TransferResultsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TransferResultsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.TransferResultsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.TransferResultsTab.Icon = CType(resources.GetObject("TransferResultsTab.Icon"), System.Drawing.Icon)
        Me.TransferResultsTab.Image = CType(resources.GetObject("TransferResultsTab.Image"), System.Drawing.Image)
        Me.TransferResultsTab.IsActive = False
        Me.TransferResultsTab.Location = New System.Drawing.Point(0, 64)
        Me.TransferResultsTab.Name = "TransferResultsTab"
        Me.TransferResultsTab.NavControlId = Nothing
        Me.TransferResultsTab.NavControlType = Nothing
        Me.TransferResultsTab.Size = New System.Drawing.Size(216, 32)
        Me.TransferResultsTab.TabIndex = 2
        Me.TransferResultsTab.Text = "Transfer Results"
        '
        'VendorMaintenanceTab
        '
        Me.VendorMaintenanceTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorMaintenanceTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.VendorMaintenanceTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.VendorMaintenanceTab.Icon = CType(resources.GetObject("VendorMaintenanceTab.Icon"), System.Drawing.Icon)
        Me.VendorMaintenanceTab.Image = CType(resources.GetObject("VendorMaintenanceTab.Image"), System.Drawing.Image)
        Me.VendorMaintenanceTab.IsActive = False
        Me.VendorMaintenanceTab.Location = New System.Drawing.Point(0, 96)
        Me.VendorMaintenanceTab.Name = "VendorMaintenanceTab"
        Me.VendorMaintenanceTab.NavControlId = Nothing
        Me.VendorMaintenanceTab.NavControlType = Nothing
        Me.VendorMaintenanceTab.Size = New System.Drawing.Size(216, 32)
        Me.VendorMaintenanceTab.TabIndex = 3
        Me.VendorMaintenanceTab.Text = "Vendor Maintenance"
        '
        'SurveyVendorTab
        '
        Me.SurveyVendorTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SurveyVendorTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.SurveyVendorTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.SurveyVendorTab.Icon = CType(resources.GetObject("SurveyVendorTab.Icon"), System.Drawing.Icon)
        Me.SurveyVendorTab.Image = CType(resources.GetObject("SurveyVendorTab.Image"), System.Drawing.Image)
        Me.SurveyVendorTab.IsActive = False
        Me.SurveyVendorTab.Location = New System.Drawing.Point(0, 128)
        Me.SurveyVendorTab.Name = "SurveyVendorTab"
        Me.SurveyVendorTab.NavControlId = Nothing
        Me.SurveyVendorTab.NavControlType = Nothing
        Me.SurveyVendorTab.Size = New System.Drawing.Size(216, 32)
        Me.SurveyVendorTab.TabIndex = 4
        Me.SurveyVendorTab.Text = "Survey-Vendor Link"
        '
        'VendorFileTab
        '
        Me.VendorFileTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.VendorFileTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.VendorFileTab.Icon = CType(resources.GetObject("VendorFileTab.Icon"), System.Drawing.Icon)
        Me.VendorFileTab.Image = CType(resources.GetObject("VendorFileTab.Image"), System.Drawing.Image)
        Me.VendorFileTab.IsActive = False
        Me.VendorFileTab.Location = New System.Drawing.Point(0, 160)
        Me.VendorFileTab.Name = "VendorFileTab"
        Me.VendorFileTab.NavControlId = Nothing
        Me.VendorFileTab.NavControlType = Nothing
        Me.VendorFileTab.Size = New System.Drawing.Size(216, 32)
        Me.VendorFileTab.TabIndex = 0
        Me.VendorFileTab.Text = "Vendor File Validation"
        '
        'DataEntryTab
        '
        Me.DataEntryTab.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.DataEntryTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.DataEntryTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.DataEntryTab.Icon = CType(resources.GetObject("DataEntryTab.Icon"), System.Drawing.Icon)
        Me.DataEntryTab.Image = CType(resources.GetObject("DataEntryTab.Image"), System.Drawing.Image)
        Me.DataEntryTab.IsActive = False
        Me.DataEntryTab.Location = New System.Drawing.Point(141, 1)
        Me.DataEntryTab.Name = "DataEntryTab"
        Me.DataEntryTab.NavControlId = Nothing
        Me.DataEntryTab.NavControlType = Nothing
        Me.DataEntryTab.Size = New System.Drawing.Size(32, 32)
        Me.DataEntryTab.TabIndex = 0
        Me.DataEntryTab.Text = "Data Entry"
        '
        'DataVerificationTab
        '
        Me.DataVerificationTab.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.DataVerificationTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.DataVerificationTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.DataVerificationTab.Icon = CType(resources.GetObject("DataVerificationTab.Icon"), System.Drawing.Icon)
        Me.DataVerificationTab.Image = CType(resources.GetObject("DataVerificationTab.Image"), System.Drawing.Image)
        Me.DataVerificationTab.IsActive = False
        Me.DataVerificationTab.Location = New System.Drawing.Point(176, 1)
        Me.DataVerificationTab.Name = "DataVerificationTab"
        Me.DataVerificationTab.NavControlId = Nothing
        Me.DataVerificationTab.NavControlType = Nothing
        Me.DataVerificationTab.Size = New System.Drawing.Size(32, 32)
        Me.DataVerificationTab.TabIndex = 1
        Me.DataVerificationTab.Text = "Data Verification"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(712, 473)
        Me.Controls.Add(Me.ToolStripContainer1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.MainMenu
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.Manual
        Me.Text = "MainForm"
        Me.MainMenu.ResumeLayout(False)
        Me.MainMenu.PerformLayout()
        Me.ToolStripContainer1.BottomToolStripPanel.ResumeLayout(False)
        Me.ToolStripContainer1.BottomToolStripPanel.PerformLayout()
        Me.ToolStripContainer1.ContentPanel.ResumeLayout(False)
        Me.ToolStripContainer1.TopToolStripPanel.ResumeLayout(False)
        Me.ToolStripContainer1.TopToolStripPanel.PerformLayout()
        Me.ToolStripContainer1.ResumeLayout(False)
        Me.ToolStripContainer1.PerformLayout()
        Me.StatusStrip.ResumeLayout(False)
        Me.StatusStrip.PerformLayout()
        Me.MainPanel.Panel1.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainMenu As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents toolStripSeparator As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents HelpToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ContentsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents IndexToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SearchToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents toolStripSeparator5 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents AboutToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents StatusStrip As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents ImportTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents BarcodeTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents TransferResultsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents VendorMaintenanceTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents SurveyVendorTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents VendorFileTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents DataEntryTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents DataVerificationTab As Nrc.Framework.WinForms.MultiPaneTab
End Class
