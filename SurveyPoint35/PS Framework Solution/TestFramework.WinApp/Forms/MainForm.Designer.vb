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
        Me.splitMainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New PS.Framework.WinForms.MultiPane
        Me.tabCustomer = New PS.Framework.WinForms.MultiPaneTab
        Me.tabTest = New PS.Framework.WinForms.MultiPaneTab
        Me.MenuStrip1.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.splitMainPanel.Panel1.SuspendLayout()
        Me.splitMainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.HelpToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(786, 24)
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
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 560)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(786, 22)
        Me.StatusStrip1.TabIndex = 1
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'lblStatus
        '
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(611, 17)
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
        'splitMainPanel
        '
        Me.splitMainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.splitMainPanel.Location = New System.Drawing.Point(0, 24)
        Me.splitMainPanel.Name = "splitMainPanel"
        '
        'splitMainPanel.Panel1
        '
        Me.splitMainPanel.Panel1.Controls.Add(Me.MultiPane)
        Me.splitMainPanel.Size = New System.Drawing.Size(786, 536)
        Me.splitMainPanel.SplitterDistance = 218
        Me.splitMainPanel.TabIndex = 2
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(0, 0)
        Me.MultiPane.MaxShownTabs = 8
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(218, 536)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.tabCustomer)
        Me.MultiPane.Tabs.Add(Me.tabTest)
        Me.MultiPane.Text = "MultiPane"
        '
        'tabCustomer
        '
        Me.tabCustomer.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabCustomer.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabCustomer.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabCustomer.Icon = Nothing
        Me.tabCustomer.Image = Global.TestFramework.WinApp.My.Resources.Resources.Happy_Face
        Me.tabCustomer.IsActive = True
        Me.tabCustomer.Location = New System.Drawing.Point(0, 0)
        Me.tabCustomer.Name = "tabCustomer"
        Me.tabCustomer.NavControlId = Nothing
        Me.tabCustomer.NavControlType = Nothing
        Me.tabCustomer.Size = New System.Drawing.Size(216, 32)
        Me.tabCustomer.TabIndex = 0
        Me.tabCustomer.Text = "Customers"
        '
        'tabTest
        '
        Me.tabTest.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabTest.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabTest.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabTest.Icon = Nothing
        Me.tabTest.Image = Global.TestFramework.WinApp.My.Resources.Resources.searchweb
        Me.tabTest.IsActive = False
        Me.tabTest.Location = New System.Drawing.Point(0, 32)
        Me.tabTest.Name = "tabTest"
        Me.tabTest.NavControlId = Nothing
        Me.tabTest.NavControlType = Nothing
        Me.tabTest.Size = New System.Drawing.Size(216, 32)
        Me.tabTest.TabIndex = 1
        Me.tabTest.Text = "Test"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(786, 582)
        Me.Controls.Add(Me.splitMainPanel)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainForm"
        Me.Text = "MainForm"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.splitMainPanel.Panel1.ResumeLayout(False)
        Me.splitMainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents HelpToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AboutToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents splitMainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As PS.Framework.WinForms.MultiPane
    Friend WithEvents lblStatus As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblUser As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblVersion As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents lblEnvironment As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents tabCustomer As PS.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabTest As PS.Framework.WinForms.MultiPaneTab
End Class
