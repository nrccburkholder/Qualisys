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
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
        Me.StatusBar = New System.Windows.Forms.StatusStrip()
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.MainMenu = New System.Windows.Forms.MenuStrip()
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExitMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.imgToolbar = New System.Windows.Forms.ImageList(Me.components)
        Me.mnuSaveMenu = New System.Windows.Forms.ContextMenu()
        Me.mnuSaveAs = New System.Windows.Forms.MenuItem()
        Me.SplitContainer = New System.Windows.Forms.SplitContainer()
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane()
        Me.MainPanel = New System.Windows.Forms.Panel()
        Me.DispositionTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.SearchTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.USPSAddressUpdatesTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.StatusBar.SuspendLayout()
        Me.MainMenu.SuspendLayout()
        Me.SplitContainer.Panel1.SuspendLayout()
        Me.SplitContainer.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'StatusBar
        '
        Me.StatusBar.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StatusLabel, Me.UserNameLabel, Me.VersionLabel, Me.EnvironmentLabel})
        Me.StatusBar.Location = New System.Drawing.Point(0, 615)
        Me.StatusBar.Name = "StatusBar"
        Me.StatusBar.Size = New System.Drawing.Size(592, 24)
        Me.StatusBar.TabIndex = 9
        Me.StatusBar.Text = "StatusStrip1"
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(413, 19)
        Me.StatusLabel.Spring = True
        Me.StatusLabel.Text = "Ready"
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
        Me.VersionLabel.Text = "v0.0.0.0"
        '
        'EnvironmentLabel
        '
        Me.EnvironmentLabel.Name = "EnvironmentLabel"
        Me.EnvironmentLabel.Size = New System.Drawing.Size(78, 19)
        Me.EnvironmentLabel.Text = "Development"
        '
        'MainMenu
        '
        Me.MainMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem})
        Me.MainMenu.Location = New System.Drawing.Point(0, 0)
        Me.MainMenu.Name = "MainMenu"
        Me.MainMenu.Size = New System.Drawing.Size(592, 24)
        Me.MainMenu.TabIndex = 8
        Me.MainMenu.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(37, 20)
        Me.FileToolStripMenuItem.Text = "&File"
        '
        'ExitMenuItem
        '
        Me.ExitMenuItem.Name = "ExitMenuItem"
        Me.ExitMenuItem.Size = New System.Drawing.Size(92, 22)
        Me.ExitMenuItem.Text = "E&xit"
        '
        'imgToolbar
        '
        Me.imgToolbar.ImageStream = CType(resources.GetObject("imgToolbar.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imgToolbar.TransparentColor = System.Drawing.Color.Transparent
        Me.imgToolbar.Images.SetKeyName(0, "")
        '
        'mnuSaveMenu
        '
        Me.mnuSaveMenu.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuSaveAs})
        '
        'mnuSaveAs
        '
        Me.mnuSaveAs.Index = 0
        Me.mnuSaveAs.Text = "Save As..."
        '
        'SplitContainer
        '
        Me.SplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer.FixedPanel = System.Windows.Forms.FixedPanel.Panel1
        Me.SplitContainer.Location = New System.Drawing.Point(1, 0)
        Me.SplitContainer.Name = "SplitContainer"
        '
        'SplitContainer.Panel1
        '
        Me.SplitContainer.Panel1.Controls.Add(Me.MultiPane)
        Me.SplitContainer.Size = New System.Drawing.Size(590, 590)
        Me.SplitContainer.SplitterDistance = 217
        Me.SplitContainer.TabIndex = 10
        '
        'MultiPane
        '
        Me.MultiPane.BackColor = System.Drawing.Color.White
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(0, 0)
        Me.MultiPane.MaxShownTabs = 4
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(217, 590)
        Me.MultiPane.TabIndex = 1
        Me.MultiPane.Tabs.Add(Me.DispositionTab)
        Me.MultiPane.Tabs.Add(Me.SearchTab)
        Me.MultiPane.Tabs.Add(Me.USPSAddressUpdatesTab)
        '
        'MainPanel
        '
        Me.MainPanel.Controls.Add(Me.SplitContainer)
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.Location = New System.Drawing.Point(0, 24)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.Padding = New System.Windows.Forms.Padding(1, 0, 1, 1)
        Me.MainPanel.Size = New System.Drawing.Size(592, 591)
        Me.MainPanel.TabIndex = 11
        '
        'DispositionTab
        '
        Me.DispositionTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DispositionTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.DispositionTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.DispositionTab.Icon = CType(resources.GetObject("DispositionTab.Icon"), System.Drawing.Icon)
        Me.DispositionTab.Image = CType(resources.GetObject("DispositionTab.Image"), System.Drawing.Image)
        Me.DispositionTab.IsActive = True
        Me.DispositionTab.Location = New System.Drawing.Point(0, 0)
        Me.DispositionTab.Name = "DispositionTab"
        Me.DispositionTab.NavControlId = Nothing
        Me.DispositionTab.NavControlType = Nothing
        Me.DispositionTab.Size = New System.Drawing.Size(217, 32)
        Me.DispositionTab.TabIndex = 0
        Me.DispositionTab.Text = "Respondent Dispositions"
        '
        'SearchTab
        '
        Me.SearchTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.SearchTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.SearchTab.Icon = CType(resources.GetObject("SearchTab.Icon"), System.Drawing.Icon)
        Me.SearchTab.Image = CType(resources.GetObject("SearchTab.Image"), System.Drawing.Image)
        Me.SearchTab.IsActive = False
        Me.SearchTab.Location = New System.Drawing.Point(0, 32)
        Me.SearchTab.Name = "SearchTab"
        Me.SearchTab.NavControlId = Nothing
        Me.SearchTab.NavControlType = Nothing
        Me.SearchTab.Size = New System.Drawing.Size(217, 32)
        Me.SearchTab.TabIndex = 1
        Me.SearchTab.Text = "Respondent Search"
        '
        'USPSAddressUpdatesTab
        '
        Me.USPSAddressUpdatesTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.USPSAddressUpdatesTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.USPSAddressUpdatesTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.USPSAddressUpdatesTab.Icon = Nothing
        Me.USPSAddressUpdatesTab.Image = Global.Nrc.QualiSys.QualiSysExplorer.My.Resources.Resources.usps_icon4
        Me.USPSAddressUpdatesTab.IsActive = False
        Me.USPSAddressUpdatesTab.Location = New System.Drawing.Point(0, 64)
        Me.USPSAddressUpdatesTab.Name = "USPSAddressUpdatesTab"
        Me.USPSAddressUpdatesTab.NavControlId = Nothing
        Me.USPSAddressUpdatesTab.NavControlType = Nothing
        Me.USPSAddressUpdatesTab.Size = New System.Drawing.Size(217, 32)
        Me.USPSAddressUpdatesTab.TabIndex = 2
        Me.USPSAddressUpdatesTab.Text = "USPS Address Update"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(592, 639)
        Me.Controls.Add(Me.MainPanel)
        Me.Controls.Add(Me.StatusBar)
        Me.Controls.Add(Me.MainMenu)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "MainForm"
        Me.Text = "QualiSys Explorer"
        Me.StatusBar.ResumeLayout(False)
        Me.StatusBar.PerformLayout()
        Me.MainMenu.ResumeLayout(False)
        Me.MainMenu.PerformLayout()
        Me.SplitContainer.Panel1.ResumeLayout(False)
        Me.SplitContainer.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusBar As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents MainMenu As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents imgToolbar As System.Windows.Forms.ImageList
    Friend WithEvents mnuSaveMenu As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuSaveAs As System.Windows.Forms.MenuItem
    Friend WithEvents SplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents DispositionTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents SearchTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents MainPanel As System.Windows.Forms.Panel
    Friend WithEvents USPSAddressUpdatesTab As Nrc.Framework.WinForms.MultiPaneTab
End Class
