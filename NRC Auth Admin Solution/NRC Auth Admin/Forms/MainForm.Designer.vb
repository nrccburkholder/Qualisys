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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.StatusStrip = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane
        Me.UserManagementTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ApplicationsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ReportsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.OneClickTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.EReportsFiltersTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.CommentFilterTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.MassEmailTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MainMenu = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.HelpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AboutToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.DefaultLookAndFeel1 = New DevExpress.LookAndFeel.DefaultLookAndFeel(Me.components)
        Me.MainPanel.Panel1.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.ToolStripContainer1.BottomToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.ContentPanel.SuspendLayout()
        Me.ToolStripContainer1.TopToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.SuspendLayout()
        Me.SuspendLayout()
        '
        'UserNameLabel
        '
        Me.UserNameLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.UserNameLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.UserNameLabel.Name = "UserNameLabel"
        Me.UserNameLabel.Size = New System.Drawing.Size(36, 17)
        Me.UserNameLabel.Text = "JDoe"
        '
        'VersionLabel
        '
        Me.VersionLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.VersionLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.VersionLabel.Name = "VersionLabel"
        Me.VersionLabel.Size = New System.Drawing.Size(50, 17)
        Me.VersionLabel.Text = "v1.0.0.0"
        '
        'StatusStrip
        '
        Me.StatusStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.StatusStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Visible
        Me.StatusStrip.Location = New System.Drawing.Point(0, 0)
        Me.StatusStrip.Name = "StatusStrip"
        Me.StatusStrip.Size = New System.Drawing.Size(627, 22)
        Me.StatusStrip.TabIndex = 0
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(456, 17)
        Me.StatusLabel.Spring = True
        Me.StatusLabel.Text = "Ready."
        Me.StatusLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'EnvironmentLabel
        '
        Me.EnvironmentLabel.Name = "EnvironmentLabel"
        Me.EnvironmentLabel.Size = New System.Drawing.Size(70, 17)
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
        Me.MainPanel.Size = New System.Drawing.Size(627, 423)
        Me.MainPanel.SplitterDistance = 218
        Me.MainPanel.TabIndex = 0
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(1, 1)
        Me.MultiPane.MaxShownTabs = 7
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(216, 421)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.UserManagementTab)
        Me.MultiPane.Tabs.Add(Me.ApplicationsTab)
        Me.MultiPane.Tabs.Add(Me.ReportsTab)
        Me.MultiPane.Tabs.Add(Me.OneClickTab)
        Me.MultiPane.Tabs.Add(Me.EReportsFiltersTab)
        Me.MultiPane.Tabs.Add(Me.CommentFilterTab)
        Me.MultiPane.Tabs.Add(Me.MassEmailTab)
        Me.MultiPane.Text = "MultiPane"
        '
        'UserManagementTab
        '
        Me.UserManagementTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UserManagementTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.UserManagementTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.UserManagementTab.Icon = Nothing
        Me.UserManagementTab.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Member32
        Me.UserManagementTab.IsActive = True
        Me.UserManagementTab.Location = New System.Drawing.Point(0, 0)
        Me.UserManagementTab.Name = "UserManagementTab"
        Me.UserManagementTab.NavControlId = Nothing
        Me.UserManagementTab.NavControlType = Nothing
        Me.UserManagementTab.Size = New System.Drawing.Size(216, 32)
        Me.UserManagementTab.TabIndex = 3
        Me.UserManagementTab.Text = "User Management"
        '
        'ApplicationsTab
        '
        Me.ApplicationsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplicationsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ApplicationsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ApplicationsTab.Icon = CType(resources.GetObject("ApplicationsTab.Icon"), System.Drawing.Icon)
        Me.ApplicationsTab.Image = CType(resources.GetObject("ApplicationsTab.Image"), System.Drawing.Image)
        Me.ApplicationsTab.IsActive = False
        Me.ApplicationsTab.Location = New System.Drawing.Point(0, 32)
        Me.ApplicationsTab.Name = "ApplicationsTab"
        Me.ApplicationsTab.NavControlId = Nothing
        Me.ApplicationsTab.NavControlType = Nothing
        Me.ApplicationsTab.Padding = New System.Windows.Forms.Padding(4)
        Me.ApplicationsTab.Size = New System.Drawing.Size(216, 32)
        Me.ApplicationsTab.TabIndex = 5
        Me.ApplicationsTab.Text = "Application Managment"
        '
        'ReportsTab
        '
        Me.ReportsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ReportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ReportsTab.Icon = Nothing
        Me.ReportsTab.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Reports32
        Me.ReportsTab.IsActive = False
        Me.ReportsTab.Location = New System.Drawing.Point(0, 64)
        Me.ReportsTab.Name = "ReportsTab"
        Me.ReportsTab.NavControlId = Nothing
        Me.ReportsTab.NavControlType = Nothing
        Me.ReportsTab.Padding = New System.Windows.Forms.Padding(2)
        Me.ReportsTab.Size = New System.Drawing.Size(216, 32)
        Me.ReportsTab.TabIndex = 4
        Me.ReportsTab.Text = "Web Usage Reports"
        '
        'OneClickTab
        '
        Me.OneClickTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OneClickTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.OneClickTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.OneClickTab.Icon = Nothing
        Me.OneClickTab.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Document32
        Me.OneClickTab.IsActive = False
        Me.OneClickTab.Location = New System.Drawing.Point(0, 96)
        Me.OneClickTab.Name = "OneClickTab"
        Me.OneClickTab.NavControlId = Nothing
        Me.OneClickTab.NavControlType = Nothing
        Me.OneClickTab.Padding = New System.Windows.Forms.Padding(4)
        Me.OneClickTab.Size = New System.Drawing.Size(216, 32)
        Me.OneClickTab.TabIndex = 6
        Me.OneClickTab.Text = "One Click Reports"
        '
        'EReportsFiltersTab
        '
        Me.EReportsFiltersTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EReportsFiltersTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.EReportsFiltersTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.EReportsFiltersTab.Icon = Nothing
        Me.EReportsFiltersTab.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Filter16
        Me.EReportsFiltersTab.IsActive = False
        Me.EReportsFiltersTab.Location = New System.Drawing.Point(0, 128)
        Me.EReportsFiltersTab.Name = "EReportsFiltersTab"
        Me.EReportsFiltersTab.NavControlId = Nothing
        Me.EReportsFiltersTab.NavControlType = Nothing
        Me.EReportsFiltersTab.Padding = New System.Windows.Forms.Padding(4)
        Me.EReportsFiltersTab.Size = New System.Drawing.Size(216, 32)
        Me.EReportsFiltersTab.TabIndex = 0
        Me.EReportsFiltersTab.Text = "eReports Filters"
        '
        'CommentFilterTab
        '
        Me.CommentFilterTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CommentFilterTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.CommentFilterTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.CommentFilterTab.Icon = Nothing
        Me.CommentFilterTab.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.CommentFilter32
        Me.CommentFilterTab.IsActive = False
        Me.CommentFilterTab.Location = New System.Drawing.Point(0, 160)
        Me.CommentFilterTab.Name = "CommentFilterTab"
        Me.CommentFilterTab.NavControlId = Nothing
        Me.CommentFilterTab.NavControlType = Nothing
        Me.CommentFilterTab.Padding = New System.Windows.Forms.Padding(4)
        Me.CommentFilterTab.Size = New System.Drawing.Size(216, 32)
        Me.CommentFilterTab.TabIndex = 0
        Me.CommentFilterTab.Text = "eComments Filters"
        '
        'MassEmailTab
        '
        Me.MassEmailTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MassEmailTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.MassEmailTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.MassEmailTab.Icon = Nothing
        Me.MassEmailTab.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Envelope
        Me.MassEmailTab.IsActive = False
        Me.MassEmailTab.Location = New System.Drawing.Point(0, 192)
        Me.MassEmailTab.Name = "MassEmailTab"
        Me.MassEmailTab.NavControlId = Nothing
        Me.MassEmailTab.NavControlType = Nothing
        Me.MassEmailTab.Size = New System.Drawing.Size(216, 32)
        Me.MassEmailTab.TabIndex = 0
        Me.MassEmailTab.Text = "Mass E-mail"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(94, 22)
        Me.ExitToolStripMenuItem.Text = "E&xit"
        '
        'ToolsToolStripMenuItem
        '
        Me.ToolsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OptionsToolStripMenuItem})
        Me.ToolsToolStripMenuItem.Name = "ToolsToolStripMenuItem"
        Me.ToolsToolStripMenuItem.Size = New System.Drawing.Size(45, 20)
        Me.ToolsToolStripMenuItem.Text = "&Tools"
        '
        'OptionsToolStripMenuItem
        '
        Me.OptionsToolStripMenuItem.Name = "OptionsToolStripMenuItem"
        Me.OptionsToolStripMenuItem.Size = New System.Drawing.Size(113, 22)
        Me.OptionsToolStripMenuItem.Text = "&Options"
        '
        'MainMenu
        '
        Me.MainMenu.Dock = System.Windows.Forms.DockStyle.None
        Me.MainMenu.Location = New System.Drawing.Point(0, 0)
        Me.MainMenu.Name = "MainMenu"
        Me.MainMenu.Size = New System.Drawing.Size(627, 24)
        Me.MainMenu.TabIndex = 0
        Me.MainMenu.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(35, 20)
        Me.FileToolStripMenuItem.Text = "&File"
        '
        'HelpToolStripMenuItem
        '
        Me.HelpToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AboutToolStripMenuItem})
        Me.HelpToolStripMenuItem.Name = "HelpToolStripMenuItem"
        Me.HelpToolStripMenuItem.Size = New System.Drawing.Size(41, 20)
        Me.HelpToolStripMenuItem.Text = "&Help"
        '
        'AboutToolStripMenuItem
        '
        Me.AboutToolStripMenuItem.Name = "AboutToolStripMenuItem"
        Me.AboutToolStripMenuItem.Size = New System.Drawing.Size(114, 22)
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
        Me.ToolStripContainer1.ContentPanel.Size = New System.Drawing.Size(627, 423)
        Me.ToolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStripContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStripContainer1.Name = "ToolStripContainer1"
        Me.ToolStripContainer1.Size = New System.Drawing.Size(627, 469)
        Me.ToolStripContainer1.TabIndex = 3
        Me.ToolStripContainer1.Text = "ToolStripContainer1"
        '
        'ToolStripContainer1.TopToolStripPanel
        '
        Me.ToolStripContainer1.TopToolStripPanel.Controls.Add(Me.MainMenu)
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(627, 469)
        Me.Controls.Add(Me.ToolStripContainer1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.KeyPreview = True
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Sampling Tool"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MainPanel.Panel1.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.ToolStripContainer1.BottomToolStripPanel.ResumeLayout(False)
        Me.ToolStripContainer1.BottomToolStripPanel.PerformLayout()
        Me.ToolStripContainer1.ContentPanel.ResumeLayout(False)
        Me.ToolStripContainer1.TopToolStripPanel.ResumeLayout(False)
        Me.ToolStripContainer1.TopToolStripPanel.PerformLayout()
        Me.ToolStripContainer1.ResumeLayout(False)
        Me.ToolStripContainer1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents StatusStrip As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents MultiPane As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MainMenu As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents HelpToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AboutToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents UserManagementTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ReportsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ApplicationsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents DefaultLookAndFeel1 As DevExpress.LookAndFeel.DefaultLookAndFeel
    Friend WithEvents OneClickTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents EReportsFiltersTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents CommentFilterTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents MassEmailTab As Nrc.Framework.WinForms.MultiPaneTab
End Class
