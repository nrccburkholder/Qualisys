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
        Me.toolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.toolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.StatusStrip = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane
        Me.tabPivot = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabWebCSV = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabLifeStylesExport = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabVRTFileExpand = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabRespImportValidator = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabVoviciUnpivot = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabVRTDisp = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabWebFileConvert = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabTVXDisposition = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabWestDisposition = New Nrc.Framework.WinForms.MultiPaneTab
        Me.AdminTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ReportsTab = New Nrc.Framework.WinForms.MultiPaneTab
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
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.toolStripSeparator, Me.toolStripSeparator1, Me.toolStripSeparator2, Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(35, 20)
        Me.FileToolStripMenuItem.Text = "&File"
        '
        'toolStripSeparator
        '
        Me.toolStripSeparator.Name = "toolStripSeparator"
        Me.toolStripSeparator.Size = New System.Drawing.Size(91, 6)
        '
        'toolStripSeparator1
        '
        Me.toolStripSeparator1.Name = "toolStripSeparator1"
        Me.toolStripSeparator1.Size = New System.Drawing.Size(91, 6)
        '
        'toolStripSeparator2
        '
        Me.toolStripSeparator2.Name = "toolStripSeparator2"
        Me.toolStripSeparator2.Size = New System.Drawing.Size(91, 6)
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(94, 22)
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
        Me.StatusLabel.Size = New System.Drawing.Size(449, 17)
        Me.StatusLabel.Spring = True
        Me.StatusLabel.Text = "Ready."
        Me.StatusLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
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
        Me.MultiPane.MaxShownTabs = 10
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(216, 422)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.tabWebCSV)
        Me.MultiPane.Tabs.Add(Me.tabPivot)
        Me.MultiPane.Tabs.Add(Me.tabLifeStylesExport)
        Me.MultiPane.Tabs.Add(Me.tabVRTFileExpand)
        Me.MultiPane.Tabs.Add(Me.tabRespImportValidator)
        Me.MultiPane.Tabs.Add(Me.tabVoviciUnpivot)
        Me.MultiPane.Tabs.Add(Me.tabVRTDisp)
        Me.MultiPane.Tabs.Add(Me.tabWebFileConvert)
        Me.MultiPane.Tabs.Add(Me.tabTVXDisposition)
        Me.MultiPane.Tabs.Add(Me.tabWestDisposition)
        Me.MultiPane.Text = "MultiPane"
        '
        'tabPivot
        '
        Me.tabPivot.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabPivot.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabPivot.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabPivot.Icon = Nothing
        Me.tabPivot.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.MostlyHarmless
        Me.tabPivot.IsActive = False
        Me.tabPivot.Location = New System.Drawing.Point(0, 32)
        Me.tabPivot.Name = "tabPivot"
        Me.tabPivot.NavControlId = Nothing
        Me.tabPivot.NavControlType = Nothing
        Me.tabPivot.Size = New System.Drawing.Size(216, 32)
        Me.tabPivot.TabIndex = 2
        Me.tabPivot.Text = "Pivot CSV"
        '
        'tabWebCSV
        '
        Me.tabWebCSV.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabWebCSV.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabWebCSV.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabWebCSV.Icon = Nothing
        Me.tabWebCSV.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.web
        Me.tabWebCSV.IsActive = True
        Me.tabWebCSV.Location = New System.Drawing.Point(0, 0)
        Me.tabWebCSV.Name = "tabWebCSV"
        Me.tabWebCSV.NavControlId = Nothing
        Me.tabWebCSV.NavControlType = Nothing
        Me.tabWebCSV.Size = New System.Drawing.Size(216, 32)
        Me.tabWebCSV.TabIndex = 2
        Me.tabWebCSV.Text = "Web CSV to Fixed"
        '
        'tabLifeStylesExport
        '
        Me.tabLifeStylesExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabLifeStylesExport.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabLifeStylesExport.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabLifeStylesExport.Icon = Nothing
        Me.tabLifeStylesExport.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.heart
        Me.tabLifeStylesExport.IsActive = False
        Me.tabLifeStylesExport.Location = New System.Drawing.Point(0, 64)
        Me.tabLifeStylesExport.Name = "tabLifeStylesExport"
        Me.tabLifeStylesExport.NavControlId = Nothing
        Me.tabLifeStylesExport.NavControlType = Nothing
        Me.tabLifeStylesExport.Size = New System.Drawing.Size(216, 32)
        Me.tabLifeStylesExport.TabIndex = 3
        Me.tabLifeStylesExport.Text = "Lifestyles Export"
        '
        'tabVRTFileExpand
        '
        Me.tabVRTFileExpand.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabVRTFileExpand.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabVRTFileExpand.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabVRTFileExpand.Icon = Nothing
        Me.tabVRTFileExpand.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.africanDaisy
        Me.tabVRTFileExpand.IsActive = False
        Me.tabVRTFileExpand.Location = New System.Drawing.Point(0, 96)
        Me.tabVRTFileExpand.Name = "tabVRTFileExpand"
        Me.tabVRTFileExpand.NavControlId = Nothing
        Me.tabVRTFileExpand.NavControlType = Nothing
        Me.tabVRTFileExpand.Size = New System.Drawing.Size(216, 32)
        Me.tabVRTFileExpand.TabIndex = 6
        Me.tabVRTFileExpand.Text = "VRT File Expand"
        '
        'tabRespImportValidator
        '
        Me.tabRespImportValidator.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabRespImportValidator.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabRespImportValidator.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabRespImportValidator.Icon = Nothing
        Me.tabRespImportValidator.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources._Check
        Me.tabRespImportValidator.IsActive = False
        Me.tabRespImportValidator.Location = New System.Drawing.Point(0, 128)
        Me.tabRespImportValidator.Name = "tabRespImportValidator"
        Me.tabRespImportValidator.NavControlId = Nothing
        Me.tabRespImportValidator.NavControlType = Nothing
        Me.tabRespImportValidator.Size = New System.Drawing.Size(216, 32)
        Me.tabRespImportValidator.TabIndex = 7
        Me.tabRespImportValidator.Text = "Resp Import Validator"
        '
        'tabVoviciUnpivot
        '
        Me.tabVoviciUnpivot.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabVoviciUnpivot.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabVoviciUnpivot.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabVoviciUnpivot.Icon = Nothing
        Me.tabVoviciUnpivot.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.application
        Me.tabVoviciUnpivot.IsActive = False
        Me.tabVoviciUnpivot.Location = New System.Drawing.Point(0, 160)
        Me.tabVoviciUnpivot.Name = "tabVoviciUnpivot"
        Me.tabVoviciUnpivot.NavControlId = Nothing
        Me.tabVoviciUnpivot.NavControlType = Nothing
        Me.tabVoviciUnpivot.Size = New System.Drawing.Size(216, 32)
        Me.tabVoviciUnpivot.TabIndex = 8
        Me.tabVoviciUnpivot.Text = "Vovici Unpivot"
        '
        'tabVRTDisp
        '
        Me.tabVRTDisp.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabVRTDisp.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabVRTDisp.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabVRTDisp.Icon = Nothing
        Me.tabVRTDisp.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.Derek_s_Segway_Icon
        Me.tabVRTDisp.IsActive = False
        Me.tabVRTDisp.Location = New System.Drawing.Point(0, 192)
        Me.tabVRTDisp.Name = "tabVRTDisp"
        Me.tabVRTDisp.NavControlId = Nothing
        Me.tabVRTDisp.NavControlType = Nothing
        Me.tabVRTDisp.Size = New System.Drawing.Size(216, 32)
        Me.tabVRTDisp.TabIndex = 9
        Me.tabVRTDisp.Text = "VRT Dispositions"
        '
        'tabWebFileConvert
        '
        Me.tabWebFileConvert.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabWebFileConvert.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabWebFileConvert.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabWebFileConvert.Icon = Nothing
        Me.tabWebFileConvert.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.doc_f2
        Me.tabWebFileConvert.IsActive = False
        Me.tabWebFileConvert.Location = New System.Drawing.Point(0, 224)
        Me.tabWebFileConvert.Name = "tabWebFileConvert"
        Me.tabWebFileConvert.NavControlId = Nothing
        Me.tabWebFileConvert.NavControlType = Nothing
        Me.tabWebFileConvert.Size = New System.Drawing.Size(216, 32)
        Me.tabWebFileConvert.TabIndex = 10
        Me.tabWebFileConvert.Text = "Web File Convert"
        '
        'tabTVXDisposition
        '
        Me.tabTVXDisposition.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabTVXDisposition.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabTVXDisposition.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabTVXDisposition.Icon = Nothing
        Me.tabTVXDisposition.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.down
        Me.tabTVXDisposition.IsActive = False
        Me.tabTVXDisposition.Location = New System.Drawing.Point(0, 256)
        Me.tabTVXDisposition.Name = "tabTVXDisposition"
        Me.tabTVXDisposition.NavControlId = Nothing
        Me.tabTVXDisposition.NavControlType = Nothing
        Me.tabTVXDisposition.Size = New System.Drawing.Size(216, 32)
        Me.tabTVXDisposition.TabIndex = 11
        Me.tabTVXDisposition.Text = "Tuvox Dispositions"

        '
        'tabWestDisposition
        '
        Me.tabWestDisposition.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabWestDisposition.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabWestDisposition.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.tabWestDisposition.Icon = Nothing
        Me.tabWestDisposition.Image = Global.Nrc.PayerSolutionsETL.My.Resources.Resources.west_down
        Me.tabWestDisposition.IsActive = False
        Me.tabWestDisposition.Location = New System.Drawing.Point(0, 288)
        Me.tabWestDisposition.Name = "tabWestDisposition"
        Me.tabWestDisposition.NavControlId = Nothing
        Me.tabWestDisposition.NavControlType = Nothing
        Me.tabWestDisposition.Size = New System.Drawing.Size(216, 32)
        Me.tabWestDisposition.TabIndex = 12
        Me.tabWestDisposition.Text = "West Dispositions"

        '
        'AdminTab
        '
        Me.AdminTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AdminTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.AdminTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.AdminTab.Icon = CType(resources.GetObject("AdminTab.Icon"), System.Drawing.Icon)
        Me.AdminTab.Image = CType(resources.GetObject("AdminTab.Image"), System.Drawing.Image)
        Me.AdminTab.IsActive = False
        Me.AdminTab.Location = New System.Drawing.Point(0, 64)
        Me.AdminTab.Name = "AdminTab"
        Me.AdminTab.NavControlId = Nothing
        Me.AdminTab.NavControlType = Nothing
        Me.AdminTab.Padding = New System.Windows.Forms.Padding(2)
        Me.AdminTab.Size = New System.Drawing.Size(216, 32)
        Me.AdminTab.TabIndex = 2
        Me.AdminTab.Text = "Administration"
        '
        'ReportsTab
        '
        Me.ReportsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ReportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ReportsTab.Icon = CType(resources.GetObject("ReportsTab.Icon"), System.Drawing.Icon)
        Me.ReportsTab.Image = CType(resources.GetObject("ReportsTab.Image"), System.Drawing.Image)
        Me.ReportsTab.IsActive = False
        Me.ReportsTab.Location = New System.Drawing.Point(0, 32)
        Me.ReportsTab.Name = "ReportsTab"
        Me.ReportsTab.NavControlId = Nothing
        Me.ReportsTab.NavControlType = Nothing
        Me.ReportsTab.Padding = New System.Windows.Forms.Padding(2)
        Me.ReportsTab.Size = New System.Drawing.Size(216, 32)
        Me.ReportsTab.TabIndex = 1
        Me.ReportsTab.Text = "Reports"
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
        Me.Text = "MainForm"
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
    Friend WithEvents toolStripSeparator As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents toolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents toolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents StatusStrip As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents AdminTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ReportsTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabWebCSV As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabLifeStylesExport As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabVRTFileExpand As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabRespImportValidator As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabVoviciUnpivot As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabVRTDisp As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabWebFileConvert As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabTVXDisposition As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabWestDisposition As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabPivot As Nrc.Framework.WinForms.MultiPaneTab
End Class
