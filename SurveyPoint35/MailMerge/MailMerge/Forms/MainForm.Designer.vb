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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
        Me.SectionPanel1 = New PS.Framework.WinForms.SectionPanel
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.HelpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AboutToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.lblStatus = New System.Windows.Forms.ToolStripStatusLabel
        Me.pgBar = New System.Windows.Forms.ToolStripProgressBar
        Me.lblUser = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblVersion = New System.Windows.Forms.ToolStripStatusLabel
        Me.lblEnvironment = New System.Windows.Forms.ToolStripStatusLabel
        Me.splitMainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New PS.Framework.WinForms.MultiPane
        Me.tabMailMerge = New PS.Framework.WinForms.MultiPaneTab
        Me.tabReporting = New PS.Framework.WinForms.MultiPaneTab
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.tabXMLViewer = New PS.Framework.WinForms.MultiPaneTab
        Me.MenuStrip1.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.splitMainPanel.Panel1.SuspendLayout()
        Me.splitMainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Location = New System.Drawing.Point(288, 147)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = False
        Me.SectionPanel1.Size = New System.Drawing.Size(8, 8)
        Me.SectionPanel1.TabIndex = 0
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.HelpToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(1026, 24)
        Me.MenuStrip1.TabIndex = 1
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
        Me.AboutToolStripMenuItem.Text = "A&bout"
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.lblStatus, Me.pgBar, Me.lblUser, Me.lblVersion, Me.lblEnvironment})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 544)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(1026, 22)
        Me.StatusStrip1.TabIndex = 2
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'lblStatus
        '
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(851, 17)
        Me.lblStatus.Spring = True
        Me.lblStatus.Text = "Ready."
        Me.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pgBar
        '
        Me.pgBar.Name = "pgBar"
        Me.pgBar.Size = New System.Drawing.Size(100, 16)
        Me.pgBar.Visible = False
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
        Me.splitMainPanel.Size = New System.Drawing.Size(1026, 520)
        Me.splitMainPanel.SplitterDistance = 218
        Me.splitMainPanel.TabIndex = 3
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(0, 0)
        Me.MultiPane.MaxShownTabs = 4
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(218, 520)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.tabMailMerge)
        Me.MultiPane.Tabs.Add(Me.tabReporting)
        Me.MultiPane.Tabs.Add(Me.tabXMLViewer)
        Me.MultiPane.Text = "MultiPane1"
        '
        'tabMailMerge
        '
        Me.tabMailMerge.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabMailMerge.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabMailMerge.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabMailMerge.Icon = Nothing
        Me.tabMailMerge.Image = Global.MailMerge.My.Resources.Resources.Mail
        Me.tabMailMerge.IsActive = True
        Me.tabMailMerge.Location = New System.Drawing.Point(0, 0)
        Me.tabMailMerge.Name = "tabMailMerge"
        Me.tabMailMerge.NavControlId = Nothing
        Me.tabMailMerge.NavControlType = Nothing
        Me.tabMailMerge.Size = New System.Drawing.Size(218, 32)
        Me.tabMailMerge.TabIndex = 0
        Me.tabMailMerge.Text = "Survey Merge"
        '
        'tabReporting
        '
        Me.tabReporting.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabReporting.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabReporting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabReporting.Icon = Nothing
        Me.tabReporting.Image = Global.MailMerge.My.Resources.Resources.searchweb
        Me.tabReporting.IsActive = False
        Me.tabReporting.Location = New System.Drawing.Point(0, 32)
        Me.tabReporting.Name = "tabReporting"
        Me.tabReporting.NavControlId = Nothing
        Me.tabReporting.NavControlType = Nothing
        Me.tabReporting.Size = New System.Drawing.Size(218, 32)
        Me.tabReporting.TabIndex = 1
        Me.tabReporting.Text = "Reporting"
        '
        'Timer1
        '
        Me.Timer1.Interval = 1000
        '
        'tabXMLViewer
        '
        Me.tabXMLViewer.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabXMLViewer.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabXMLViewer.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabXMLViewer.Icon = CType(resources.GetObject("tabXMLViewer.Icon"), System.Drawing.Icon)
        Me.tabXMLViewer.Image = CType(resources.GetObject("tabXMLViewer.Image"), System.Drawing.Image)
        Me.tabXMLViewer.IsActive = False
        Me.tabXMLViewer.Location = New System.Drawing.Point(0, 64)
        Me.tabXMLViewer.Name = "tabXMLViewer"
        Me.tabXMLViewer.NavControlId = Nothing
        Me.tabXMLViewer.NavControlType = Nothing
        Me.tabXMLViewer.Size = New System.Drawing.Size(218, 32)
        Me.tabXMLViewer.TabIndex = 2
        Me.tabXMLViewer.Text = "XML Dataset Viewer"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1026, 566)
        Me.Controls.Add(Me.splitMainPanel)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.SectionPanel1)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainForm"
        Me.Text = "Mail Merge"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.splitMainPanel.Panel1.ResumeLayout(False)
        Me.splitMainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents SectionPanel1 As PS.Framework.WinForms.SectionPanel
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
    Friend WithEvents splitMainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As PS.Framework.WinForms.MultiPane
    Friend WithEvents tabMailMerge As PS.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabReporting As PS.Framework.WinForms.MultiPaneTab
    Friend WithEvents pgBar As System.Windows.Forms.ToolStripProgressBar
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents tabXMLViewer As PS.Framework.WinForms.MultiPaneTab

End Class
