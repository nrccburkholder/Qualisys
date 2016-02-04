<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.HelpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AboutToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.lblStatus = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblUser = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblVersion = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblEnvironment = New System.Windows.Forms.ToolStripStatusLabel
        Me.spltMainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New PS.Framework.WinForms.MultiPane
        Me.DemoTab = New PS.Framework.WinForms.MultiPaneTab
        Me.MenuStrip1.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.spltMainPanel.Panel1.SuspendLayout()
        Me.spltMainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.HelpToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(724, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(35, 20)
        Me.FileToolStripMenuItem.Text = "&File"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(103, 22)
        Me.ExitToolStripMenuItem.Text = "E&xit"
        '
        'HelpToolStripMenuItem
        '
        Me.HelpToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AboutToolStripMenuItem})
        Me.HelpToolStripMenuItem.Name = "HelpToolStripMenuItem"
        Me.HelpToolStripMenuItem.Size = New System.Drawing.Size(40, 20)
        Me.HelpToolStripMenuItem.Text = "&Help"
        '
        'AboutToolStripMenuItem
        '
        Me.AboutToolStripMenuItem.Name = "AboutToolStripMenuItem"
        Me.AboutToolStripMenuItem.Size = New System.Drawing.Size(114, 22)
        Me.AboutToolStripMenuItem.Text = "&About"
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.lblStatus, Me.lblUser, Me.lblVersion, Me.lblEnvironment})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 503)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(724, 22)
        Me.StatusStrip1.TabIndex = 1
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'lblStatus
        '
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(549, 17)
        Me.lblStatus.Spring = True
        Me.lblStatus.Text = "Ready."
        Me.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblUser
        '
        Me.lblUser.Name = "lblUser"
        Me.lblUser.Size = New System.Drawing.Size(41, 17)
        Me.lblUser.Text = "TPiccoli"
        '
        'lblVersion
        '
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(49, 17)
        Me.lblVersion.Text = "V1.0.0.0"
        '
        'lblEnvironment
        '
        Me.lblEnvironment.Name = "lblEnvironment"
        Me.lblEnvironment.Size = New System.Drawing.Size(70, 17)
        Me.lblEnvironment.Text = "Development"
        '
        'spltMainPanel
        '
        Me.spltMainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spltMainPanel.Location = New System.Drawing.Point(0, 24)
        Me.spltMainPanel.Name = "spltMainPanel"
        '
        'spltMainPanel.Panel1
        '
        Me.spltMainPanel.Panel1.Controls.Add(Me.MultiPane)
        Me.spltMainPanel.Size = New System.Drawing.Size(724, 479)
        Me.spltMainPanel.SplitterDistance = 220
        Me.spltMainPanel.TabIndex = 2
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(0, 0)
        Me.MultiPane.MaxShownTabs = 4
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(220, 479)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.DemoTab)
        Me.MultiPane.Text = "MultiPane"
        '
        'DemoTab
        '
        Me.DemoTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DemoTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.DemoTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.DemoTab.Icon = Nothing
        Me.DemoTab.Image = Global.PS.ResponseImport.WinServiceTester.My.Resources.Resources.run_III
        Me.DemoTab.IsActive = True
        Me.DemoTab.Location = New System.Drawing.Point(0, 0)
        Me.DemoTab.Name = "DemoTab"
        Me.DemoTab.NavControlId = Nothing
        Me.DemoTab.NavControlType = Nothing
        Me.DemoTab.Size = New System.Drawing.Size(220, 32)
        Me.DemoTab.TabIndex = 0
        Me.DemoTab.Text = "Response Tester"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(724, 525)
        Me.Controls.Add(Me.spltMainPanel)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainForm"
        Me.Text = "MainForm"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.spltMainPanel.Panel1.ResumeLayout(False)
        Me.spltMainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents HelpToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AboutToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents lblStatus As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblUser As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblVersion As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblEnvironment As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents spltMainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As PS.Framework.WinForms.MultiPane
    Friend WithEvents DemoTab As PS.Framework.WinForms.MultiPaneTab
End Class
