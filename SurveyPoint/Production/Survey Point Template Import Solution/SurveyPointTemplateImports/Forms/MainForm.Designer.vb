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
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.StatusStrip = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane
        Me.tabFileTemplates = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabImportExport = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabExportDefinitionLog = New Nrc.Framework.WinForms.MultiPaneTab
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
        Me.MainMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem})
        Me.MainMenu.Location = New System.Drawing.Point(0, 0)
        Me.MainMenu.Name = "MainMenu"
        Me.MainMenu.Size = New System.Drawing.Size(620, 24)
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
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(103, 22)
        Me.ExitToolStripMenuItem.Text = "E&xit"
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
        Me.ToolStripContainer1.ContentPanel.Size = New System.Drawing.Size(620, 424)
        Me.ToolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStripContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStripContainer1.Name = "ToolStripContainer1"
        Me.ToolStripContainer1.Size = New System.Drawing.Size(620, 470)
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
        Me.StatusStrip.Size = New System.Drawing.Size(620, 22)
        Me.StatusStrip.TabIndex = 0
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(447, 17)
        Me.StatusLabel.Spring = True
        Me.StatusLabel.Text = "Ready."
        Me.StatusLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'UserNameLabel
        '
        Me.UserNameLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.UserNameLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.UserNameLabel.Name = "UserNameLabel"
        Me.UserNameLabel.Size = New System.Drawing.Size(35, 17)
        Me.UserNameLabel.Text = "JDoe"
        '
        'VersionLabel
        '
        Me.VersionLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.VersionLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.VersionLabel.Name = "VersionLabel"
        Me.VersionLabel.Size = New System.Drawing.Size(53, 17)
        Me.VersionLabel.Text = "v1.0.0.0"
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
        Me.MainPanel.Size = New System.Drawing.Size(620, 424)
        Me.MainPanel.SplitterDistance = 218
        Me.MainPanel.TabIndex = 0
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(1, 1)
        Me.MultiPane.MaxShownTabs = 4
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(216, 422)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.tabFileTemplates)
        Me.MultiPane.Tabs.Add(Me.tabImportExport)
        Me.MultiPane.Tabs.Add(Me.tabExportDefinitionLog)
        Me.MultiPane.Text = "MultiPane"
        '
        'tabFileTemplates
        '
        Me.tabFileTemplates.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabFileTemplates.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabFileTemplates.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabFileTemplates.Icon = Nothing
        Me.tabFileTemplates.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources.applic_f
        Me.tabFileTemplates.IsActive = True
        Me.tabFileTemplates.Location = New System.Drawing.Point(0, 0)
        Me.tabFileTemplates.Name = "tabFileTemplates"
        Me.tabFileTemplates.NavControlId = Nothing
        Me.tabFileTemplates.NavControlType = Nothing
        Me.tabFileTemplates.Size = New System.Drawing.Size(216, 32)
        Me.tabFileTemplates.TabIndex = 3
        Me.tabFileTemplates.Text = "File Templates"
        '
        'tabImportExport
        '
        Me.tabImportExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabImportExport.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabImportExport.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabImportExport.Icon = CType(resources.GetObject("tabImportExport.Icon"), System.Drawing.Icon)
        Me.tabImportExport.Image = CType(resources.GetObject("tabImportExport.Image"), System.Drawing.Image)
        Me.tabImportExport.IsActive = False
        Me.tabImportExport.Location = New System.Drawing.Point(0, 32)
        Me.tabImportExport.Name = "tabImportExport"
        Me.tabImportExport.NavControlId = Nothing
        Me.tabImportExport.NavControlType = Nothing
        Me.tabImportExport.Size = New System.Drawing.Size(216, 32)
        Me.tabImportExport.TabIndex = 4
        Me.tabImportExport.Text = "Import - Export"
        '
        'tabExportDefinitionLog
        '
        Me.tabExportDefinitionLog.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabExportDefinitionLog.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabExportDefinitionLog.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabExportDefinitionLog.Icon = Nothing
        Me.tabExportDefinitionLog.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources.info
        Me.tabExportDefinitionLog.IsActive = False
        Me.tabExportDefinitionLog.Location = New System.Drawing.Point(0, 64)
        Me.tabExportDefinitionLog.Name = "tabExportDefinitionLog"
        Me.tabExportDefinitionLog.NavControlId = Nothing
        Me.tabExportDefinitionLog.NavControlType = Nothing
        Me.tabExportDefinitionLog.Size = New System.Drawing.Size(216, 32)
        Me.tabExportDefinitionLog.TabIndex = 5
        Me.tabExportDefinitionLog.Text = " Export Definition Log"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(620, 470)
        Me.Controls.Add(Me.ToolStripContainer1)
        Me.MainMenuStrip = Me.MainMenu
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Survey Point File Defintions and Import Export Utility"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
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
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents StatusStrip As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents tabFileTemplates As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabImportExport As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabExportDefinitionLog As Nrc.Framework.WinForms.MultiPaneTab
End Class
