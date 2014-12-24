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
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.StatusStrip = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane
        Me.StandardDefinitionTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.CmsDefinitionTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.CHARTExportsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.CAHPSExportsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.CAHPSFileHistoryTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ACOCAHPSExportsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ScheduledExportsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.SpecialUpdatesTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ORYXToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ManageClientsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MeasurementsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolTip = New System.Windows.Forms.ToolTip(Me.components)
        Me.ToolStripContainer1.BottomToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.ContentPanel.SuspendLayout()
        Me.ToolStripContainer1.TopToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.SuspendLayout()
        Me.StatusStrip.SuspendLayout()
        Me.MainPanel.Panel1.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
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
        Me.ToolStripContainer1.ContentPanel.Size = New System.Drawing.Size(628, 498)
        Me.ToolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStripContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStripContainer1.Name = "ToolStripContainer1"
        Me.ToolStripContainer1.Size = New System.Drawing.Size(628, 546)
        Me.ToolStripContainer1.TabIndex = 1
        Me.ToolStripContainer1.Text = "ToolStripContainer1"
        '
        'ToolStripContainer1.TopToolStripPanel
        '
        Me.ToolStripContainer1.TopToolStripPanel.Controls.Add(Me.MenuStrip1)
        '
        'StatusStrip
        '
        Me.StatusStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.StatusStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Visible
        Me.StatusStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StatusLabel, Me.UserNameLabel, Me.VersionLabel, Me.EnvironmentLabel})
        Me.StatusStrip.Location = New System.Drawing.Point(0, 0)
        Me.StatusStrip.Name = "StatusStrip"
        Me.StatusStrip.Size = New System.Drawing.Size(628, 24)
        Me.StatusStrip.TabIndex = 0
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(449, 19)
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
        Me.MainPanel.Size = New System.Drawing.Size(628, 498)
        Me.MainPanel.SplitterDistance = 218
        Me.MainPanel.TabIndex = 0
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(1, 1)
        Me.MultiPane.MaxShownTabs = 5
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(216, 496)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.StandardDefinitionTab)
        Me.MultiPane.Tabs.Add(Me.CmsDefinitionTab)
        Me.MultiPane.Tabs.Add(Me.CHARTExportsTab)
        Me.MultiPane.Tabs.Add(Me.CAHPSExportsTab)
        Me.MultiPane.Tabs.Add(Me.CAHPSFileHistoryTab)
        Me.MultiPane.Tabs.Add(Me.ACOCAHPSExportsTab)
        Me.MultiPane.Tabs.Add(Me.ScheduledExportsTab)
        Me.MultiPane.Tabs.Add(Me.SpecialUpdatesTab)
        Me.MultiPane.Text = "MultiPane"
        '
        'StandardDefinitionTab
        '
        Me.StandardDefinitionTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.StandardDefinitionTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.StandardDefinitionTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.StandardDefinitionTab.Icon = Nothing
        Me.StandardDefinitionTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.File_export_32
        Me.StandardDefinitionTab.IsActive = True
        Me.StandardDefinitionTab.Location = New System.Drawing.Point(0, 0)
        Me.StandardDefinitionTab.Name = "StandardDefinitionTab"
        Me.StandardDefinitionTab.NavControlId = Nothing
        Me.StandardDefinitionTab.NavControlType = Nothing
        Me.StandardDefinitionTab.Size = New System.Drawing.Size(216, 32)
        Me.StandardDefinitionTab.TabIndex = 1
        Me.StandardDefinitionTab.Text = "Standard Definitions"
        Me.ToolTip.SetToolTip(Me.StandardDefinitionTab, "Standard Definitions")
        '
        'CmsDefinitionTab
        '
        Me.CmsDefinitionTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CmsDefinitionTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.CmsDefinitionTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.CmsDefinitionTab.Icon = Nothing
        Me.CmsDefinitionTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Health___Personal_Care
        Me.CmsDefinitionTab.IsActive = False
        Me.CmsDefinitionTab.Location = New System.Drawing.Point(0, 32)
        Me.CmsDefinitionTab.Name = "CmsDefinitionTab"
        Me.CmsDefinitionTab.NavControlId = Nothing
        Me.CmsDefinitionTab.NavControlType = Nothing
        Me.CmsDefinitionTab.Size = New System.Drawing.Size(216, 32)
        Me.CmsDefinitionTab.TabIndex = 2
        Me.CmsDefinitionTab.Text = "CMS/HCAHPS Definitions"
        Me.ToolTip.SetToolTip(Me.CmsDefinitionTab, "CMS/HCAHPS Definitions")
        '
        'CHARTExportsTab
        '
        Me.CHARTExportsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CHARTExportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.CHARTExportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.CHARTExportsTab.Icon = Nothing
        Me.CHARTExportsTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Chart_Line_32
        Me.CHARTExportsTab.IsActive = False
        Me.CHARTExportsTab.Location = New System.Drawing.Point(0, 64)
        Me.CHARTExportsTab.Name = "CHARTExportsTab"
        Me.CHARTExportsTab.NavControlId = Nothing
        Me.CHARTExportsTab.NavControlType = Nothing
        Me.CHARTExportsTab.Size = New System.Drawing.Size(216, 32)
        Me.CHARTExportsTab.TabIndex = 0
        Me.CHARTExportsTab.Text = "CHART Definitions"
        Me.ToolTip.SetToolTip(Me.CHARTExportsTab, "CHART Definitions")
        '
        'CAHPSExportsTab
        '
        Me.CAHPSExportsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CAHPSExportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.CAHPSExportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.CAHPSExportsTab.Icon = Nothing
        Me.CAHPSExportsTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Green_baseball_cap
        Me.CAHPSExportsTab.IsActive = False
        Me.CAHPSExportsTab.Location = New System.Drawing.Point(0, 96)
        Me.CAHPSExportsTab.Name = "CAHPSExportsTab"
        Me.CAHPSExportsTab.NavControlId = Nothing
        Me.CAHPSExportsTab.NavControlType = Nothing
        Me.CAHPSExportsTab.Size = New System.Drawing.Size(216, 32)
        Me.CAHPSExportsTab.TabIndex = 0
        Me.CAHPSExportsTab.Text = "OCS & HHCAHPS Exports"
        Me.ToolTip.SetToolTip(Me.CAHPSExportsTab, "OCS & HHCAHPS Exports")
        '
        'CAHPSFileHistoryTab
        '
        Me.CAHPSFileHistoryTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CAHPSFileHistoryTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.CAHPSFileHistoryTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.CAHPSFileHistoryTab.Icon = Nothing
        Me.CAHPSFileHistoryTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.History
        Me.CAHPSFileHistoryTab.IsActive = False
        Me.CAHPSFileHistoryTab.Location = New System.Drawing.Point(0, 128)
        Me.CAHPSFileHistoryTab.Name = "CAHPSFileHistoryTab"
        Me.CAHPSFileHistoryTab.NavControlId = Nothing
        Me.CAHPSFileHistoryTab.NavControlType = Nothing
        Me.CAHPSFileHistoryTab.Size = New System.Drawing.Size(216, 32)
        Me.CAHPSFileHistoryTab.TabIndex = 5
        Me.CAHPSFileHistoryTab.Text = "OCS & HHCAHPS Export History"
        '
        'ACOCAHPSExportsTab
        '
        Me.ACOCAHPSExportsTab.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.ACOCAHPSExportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ACOCAHPSExportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ACOCAHPSExportsTab.Icon = Nothing
        Me.ACOCAHPSExportsTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Orange_baseball_cap
        Me.ACOCAHPSExportsTab.IsActive = False
        Me.ACOCAHPSExportsTab.Location = New System.Drawing.Point(106, 1)
        Me.ACOCAHPSExportsTab.Name = "ACOCAHPSExportsTab"
        Me.ACOCAHPSExportsTab.NavControlId = Nothing
        Me.ACOCAHPSExportsTab.NavControlType = Nothing
        Me.ACOCAHPSExportsTab.Size = New System.Drawing.Size(32, 32)
        Me.ACOCAHPSExportsTab.TabIndex = 0
        Me.ACOCAHPSExportsTab.Text = "ACO CAHPS Exports"
        Me.ToolTip.SetToolTip(Me.ACOCAHPSExportsTab, "ACO CAHPS Exports")
        '
        'ScheduledExportsTab
        '
        Me.ScheduledExportsTab.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.ScheduledExportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ScheduledExportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ScheduledExportsTab.Icon = Nothing
        Me.ScheduledExportsTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Schedule
        Me.ScheduledExportsTab.IsActive = False
        Me.ScheduledExportsTab.Location = New System.Drawing.Point(141, 1)
        Me.ScheduledExportsTab.Name = "ScheduledExportsTab"
        Me.ScheduledExportsTab.NavControlId = Nothing
        Me.ScheduledExportsTab.NavControlType = Nothing
        Me.ScheduledExportsTab.Size = New System.Drawing.Size(32, 32)
        Me.ScheduledExportsTab.TabIndex = 3
        Me.ScheduledExportsTab.Text = "Scheduled Exports"
        Me.ToolTip.SetToolTip(Me.ScheduledExportsTab, "Scheduled Exports")
        '
        'SpecialUpdatesTab
        '
        Me.SpecialUpdatesTab.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.SpecialUpdatesTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.SpecialUpdatesTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.SpecialUpdatesTab.Icon = Nothing
        Me.SpecialUpdatesTab.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Update_32
        Me.SpecialUpdatesTab.IsActive = False
        Me.SpecialUpdatesTab.Location = New System.Drawing.Point(176, 1)
        Me.SpecialUpdatesTab.Name = "SpecialUpdatesTab"
        Me.SpecialUpdatesTab.NavControlId = Nothing
        Me.SpecialUpdatesTab.NavControlType = Nothing
        Me.SpecialUpdatesTab.Size = New System.Drawing.Size(32, 32)
        Me.SpecialUpdatesTab.TabIndex = 4
        Me.SpecialUpdatesTab.Text = "Special Updates"
        Me.ToolTip.SetToolTip(Me.SpecialUpdatesTab, "Special Updates")
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Dock = System.Windows.Forms.DockStyle.None
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.OptionsToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(628, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(37, 20)
        Me.FileToolStripMenuItem.Text = "File"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(92, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'OptionsToolStripMenuItem
        '
        Me.OptionsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ORYXToolStripMenuItem})
        Me.OptionsToolStripMenuItem.Name = "OptionsToolStripMenuItem"
        Me.OptionsToolStripMenuItem.Size = New System.Drawing.Size(61, 20)
        Me.OptionsToolStripMenuItem.Text = "Options"
        '
        'ORYXToolStripMenuItem
        '
        Me.ORYXToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ManageClientsToolStripMenuItem, Me.MeasurementsToolStripMenuItem})
        Me.ORYXToolStripMenuItem.Name = "ORYXToolStripMenuItem"
        Me.ORYXToolStripMenuItem.Size = New System.Drawing.Size(104, 22)
        Me.ORYXToolStripMenuItem.Text = "ORYX"
        '
        'ManageClientsToolStripMenuItem
        '
        Me.ManageClientsToolStripMenuItem.Name = "ManageClientsToolStripMenuItem"
        Me.ManageClientsToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.ManageClientsToolStripMenuItem.Text = "Clients"
        '
        'MeasurementsToolStripMenuItem
        '
        Me.MeasurementsToolStripMenuItem.Name = "MeasurementsToolStripMenuItem"
        Me.MeasurementsToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.MeasurementsToolStripMenuItem.Text = "Measurements"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(628, 546)
        Me.Controls.Add(Me.ToolStripContainer1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "MainForm"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
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
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents StatusStrip As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents CmsDefinitionTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ScheduledExportsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents StandardDefinitionTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents SpecialUpdatesTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ORYXToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ManageClientsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MeasurementsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CHARTExportsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents CAHPSExportsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ToolTip As System.Windows.Forms.ToolTip
    Friend WithEvents CAHPSFileHistoryTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ACOCAHPSExportsTab As Nrc.Framework.WinForms.MultiPaneTab
End Class
