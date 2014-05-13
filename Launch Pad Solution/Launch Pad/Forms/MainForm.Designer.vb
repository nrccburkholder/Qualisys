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
        Me.ToolTip = New System.Windows.Forms.ToolTip(Me.components)
        Me.MenuContainer = New System.Windows.Forms.ToolStripContainer
        Me.MenuPanel = New System.Windows.Forms.Panel
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.FileMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OptionsMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MinimizeOnLaunchToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StartMinimizedToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RunOnStartupToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ViewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.TileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ListToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AdministrationMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.TrayIcon = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.TrayMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.ShowLaunchPadToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.LaunchToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ExitLaunchPadToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CategoryTabs = New Nrc.LaunchPad.TabPanel
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.DescriptionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblUserName = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblVersion = New System.Windows.Forms.ToolStripStatusLabel
        Me.MenuContainer.SuspendLayout()
        Me.MenuPanel.SuspendLayout()
        Me.MenuStrip1.SuspendLayout()
        Me.TrayMenu.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuContainer
        '
        '
        'MenuContainer.ContentPanel
        '
        Me.MenuContainer.ContentPanel.Size = New System.Drawing.Size(682, 0)
        Me.MenuContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MenuContainer.Location = New System.Drawing.Point(0, 24)
        Me.MenuContainer.Name = "MenuContainer"
        Me.MenuContainer.Size = New System.Drawing.Size(682, 1)
        Me.MenuContainer.TabIndex = 4
        Me.MenuContainer.Text = "ToolStripContainer1"
        '
        'MenuPanel
        '
        Me.MenuPanel.Controls.Add(Me.MenuContainer)
        Me.MenuPanel.Controls.Add(Me.MenuStrip1)
        Me.MenuPanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.MenuPanel.Location = New System.Drawing.Point(1, 1)
        Me.MenuPanel.Name = "MenuPanel"
        Me.MenuPanel.Size = New System.Drawing.Size(682, 25)
        Me.MenuPanel.TabIndex = 5
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileMenuItem, Me.OptionsMenuItem, Me.ViewToolStripMenuItem, Me.AdministrationMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(682, 24)
        Me.MenuStrip1.TabIndex = 5
        Me.MenuStrip1.Text = "MainMenu"
        '
        'FileMenuItem
        '
        Me.FileMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitMenuItem})
        Me.FileMenuItem.Name = "FileMenuItem"
        Me.FileMenuItem.Size = New System.Drawing.Size(35, 20)
        Me.FileMenuItem.Text = "&File"
        '
        'ExitMenuItem
        '
        Me.ExitMenuItem.Name = "ExitMenuItem"
        Me.ExitMenuItem.Size = New System.Drawing.Size(103, 22)
        Me.ExitMenuItem.Text = "E&xit"
        '
        'OptionsMenuItem
        '
        Me.OptionsMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MinimizeOnLaunchToolStripMenuItem, Me.StartMinimizedToolStripMenuItem, Me.RunOnStartupToolStripMenuItem})
        Me.OptionsMenuItem.Name = "OptionsMenuItem"
        Me.OptionsMenuItem.Size = New System.Drawing.Size(56, 20)
        Me.OptionsMenuItem.Text = "&Options"
        '
        'MinimizeOnLaunchToolStripMenuItem
        '
        Me.MinimizeOnLaunchToolStripMenuItem.CheckOnClick = True
        Me.MinimizeOnLaunchToolStripMenuItem.Name = "MinimizeOnLaunchToolStripMenuItem"
        Me.MinimizeOnLaunchToolStripMenuItem.Size = New System.Drawing.Size(178, 22)
        Me.MinimizeOnLaunchToolStripMenuItem.Text = "Minimize On Launch"
        '
        'StartMinimizedToolStripMenuItem
        '
        Me.StartMinimizedToolStripMenuItem.CheckOnClick = True
        Me.StartMinimizedToolStripMenuItem.Name = "StartMinimizedToolStripMenuItem"
        Me.StartMinimizedToolStripMenuItem.Size = New System.Drawing.Size(178, 22)
        Me.StartMinimizedToolStripMenuItem.Text = "Start Minimized"
        '
        'RunOnStartupToolStripMenuItem
        '
        Me.RunOnStartupToolStripMenuItem.CheckOnClick = True
        Me.RunOnStartupToolStripMenuItem.Name = "RunOnStartupToolStripMenuItem"
        Me.RunOnStartupToolStripMenuItem.Size = New System.Drawing.Size(178, 22)
        Me.RunOnStartupToolStripMenuItem.Text = "Run On Startup"
        '
        'ViewToolStripMenuItem
        '
        Me.ViewToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TileToolStripMenuItem, Me.ListToolStripMenuItem})
        Me.ViewToolStripMenuItem.Name = "ViewToolStripMenuItem"
        Me.ViewToolStripMenuItem.Size = New System.Drawing.Size(46, 20)
        Me.ViewToolStripMenuItem.Text = "Views"
        '
        'TileToolStripMenuItem
        '
        Me.TileToolStripMenuItem.Checked = True
        Me.TileToolStripMenuItem.CheckState = System.Windows.Forms.CheckState.Checked
        Me.TileToolStripMenuItem.Name = "TileToolStripMenuItem"
        Me.TileToolStripMenuItem.Size = New System.Drawing.Size(106, 22)
        Me.TileToolStripMenuItem.Text = "Tiles"
        '
        'ListToolStripMenuItem
        '
        Me.ListToolStripMenuItem.Name = "ListToolStripMenuItem"
        Me.ListToolStripMenuItem.Size = New System.Drawing.Size(106, 22)
        Me.ListToolStripMenuItem.Text = "List"
        '
        'AdministrationMenuItem
        '
        Me.AdministrationMenuItem.Name = "AdministrationMenuItem"
        Me.AdministrationMenuItem.Size = New System.Drawing.Size(87, 20)
        Me.AdministrationMenuItem.Text = "&Administration"
        '
        'TrayIcon
        '
        Me.TrayIcon.ContextMenuStrip = Me.TrayMenu
        Me.TrayIcon.Icon = CType(resources.GetObject("TrayIcon.Icon"), System.Drawing.Icon)
        Me.TrayIcon.Text = "Launch Pad"
        '
        'TrayMenu
        '
        Me.TrayMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ShowLaunchPadToolStripMenuItem, Me.ToolStripSeparator1, Me.LaunchToolStripMenuItem, Me.ToolStripSeparator2, Me.ExitLaunchPadToolStripMenuItem})
        Me.TrayMenu.Name = "TrayMenu"
        Me.TrayMenu.Size = New System.Drawing.Size(170, 82)
        '
        'ShowLaunchPadToolStripMenuItem
        '
        Me.ShowLaunchPadToolStripMenuItem.Name = "ShowLaunchPadToolStripMenuItem"
        Me.ShowLaunchPadToolStripMenuItem.Size = New System.Drawing.Size(169, 22)
        Me.ShowLaunchPadToolStripMenuItem.Text = "Show Launch Pad"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(166, 6)
        '
        'LaunchToolStripMenuItem
        '
        Me.LaunchToolStripMenuItem.Name = "LaunchToolStripMenuItem"
        Me.LaunchToolStripMenuItem.Size = New System.Drawing.Size(169, 22)
        Me.LaunchToolStripMenuItem.Text = "Launch"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(166, 6)
        '
        'ExitLaunchPadToolStripMenuItem
        '
        Me.ExitLaunchPadToolStripMenuItem.Name = "ExitLaunchPadToolStripMenuItem"
        Me.ExitLaunchPadToolStripMenuItem.Size = New System.Drawing.Size(169, 22)
        Me.ExitLaunchPadToolStripMenuItem.Text = "Exit Launch Pad"
        '
        'CategoryTabs
        '
        Me.CategoryTabs.AllowDrop = True
        Me.CategoryTabs.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CategoryTabs.Location = New System.Drawing.Point(1, 26)
        Me.CategoryTabs.Name = "CategoryTabs"
        Me.CategoryTabs.Padding = New System.Windows.Forms.Padding(0, 25, 0, 0)
        Me.CategoryTabs.Size = New System.Drawing.Size(682, 437)
        Me.CategoryTabs.TabIndex = 7
        Me.CategoryTabs.TabLocation = Nrc.LaunchPad.TabLocation.Top
        Me.CategoryTabs.Text = "o"
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DescriptionLabel, Me.lblUserName, Me.lblVersion})
        Me.StatusStrip1.Location = New System.Drawing.Point(1, 441)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(682, 22)
        Me.StatusStrip1.TabIndex = 8
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'DescriptionLabel
        '
        Me.DescriptionLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.DescriptionLabel.Name = "DescriptionLabel"
        Me.DescriptionLabel.Size = New System.Drawing.Size(575, 17)
        Me.DescriptionLabel.Spring = True
        Me.DescriptionLabel.Text = "DescriptionLabel"
        Me.DescriptionLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblUserName
        '
        Me.lblUserName.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.lblUserName.Name = "lblUserName"
        Me.lblUserName.Size = New System.Drawing.Size(43, 17)
        Me.lblUserName.Text = "tpiccoli"
        '
        'lblVersion
        '
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(49, 17)
        Me.lblVersion.Text = "v1.0.0.0"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.LightSteelBlue
        Me.ClientSize = New System.Drawing.Size(684, 464)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.CategoryTabs)
        Me.Controls.Add(Me.MenuPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainForm"
        Me.Padding = New System.Windows.Forms.Padding(1)
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Launch Pad"
        Me.MenuContainer.ResumeLayout(False)
        Me.MenuContainer.PerformLayout()
        Me.MenuPanel.ResumeLayout(False)
        Me.MenuPanel.PerformLayout()
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.TrayMenu.ResumeLayout(False)
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ToolTip As System.Windows.Forms.ToolTip
    Friend WithEvents MenuContainer As System.Windows.Forms.ToolStripContainer
    Friend WithEvents MenuPanel As System.Windows.Forms.Panel
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents FileMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OptionsMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AdministrationMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CategoryTabs As Nrc.LaunchPad.TabPanel
    Friend WithEvents ViewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ListToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TrayIcon As System.Windows.Forms.NotifyIcon
    Friend WithEvents TrayMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents ShowLaunchPadToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents LaunchToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ExitLaunchPadToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MinimizeOnLaunchToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StartMinimizedToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RunOnStartupToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents DescriptionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblUserName As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblVersion As System.Windows.Forms.ToolStripStatusLabel
End Class
