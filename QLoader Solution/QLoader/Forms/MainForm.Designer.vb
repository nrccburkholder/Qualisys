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
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FunctionLibraryToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip()
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ServiceStatusLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel()
        Me.MainPanel = New System.Windows.Forms.SplitContainer()
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane()
        Me.PackageSetupTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.LoadingQueueTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.LoadReviewTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.RollbacksTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.ReportsTab = New Nrc.Framework.WinForms.MultiPaneTab()
        Me.svcController = New System.ServiceProcess.ServiceController()
        Me.MenuStrip1.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.MainPanel.Panel1.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.ToolsToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(978, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(37, 20)
        Me.FileToolStripMenuItem.Text = "&File"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(92, 22)
        Me.ExitToolStripMenuItem.Text = "E&xit"
        '
        'ToolsToolStripMenuItem
        '
        Me.ToolsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FunctionLibraryToolStripMenuItem})
        Me.ToolsToolStripMenuItem.Name = "ToolsToolStripMenuItem"
        Me.ToolsToolStripMenuItem.Size = New System.Drawing.Size(48, 20)
        Me.ToolsToolStripMenuItem.Text = "&Tools"
        '
        'FunctionLibraryToolStripMenuItem
        '
        Me.FunctionLibraryToolStripMenuItem.Name = "FunctionLibraryToolStripMenuItem"
        Me.FunctionLibraryToolStripMenuItem.Size = New System.Drawing.Size(169, 22)
        Me.FunctionLibraryToolStripMenuItem.Text = "Function Library..."
        '
        'ToolStrip1
        '
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 24)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(978, 25)
        Me.ToolStrip1.TabIndex = 1
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1, Me.ServiceStatusLabel, Me.EnvironmentLabel, Me.UserNameLabel, Me.VersionLabel})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 614)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(978, 24)
        Me.StatusStrip1.TabIndex = 2
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(667, 19)
        Me.ToolStripStatusLabel1.Spring = True
        '
        'ServiceStatusLabel
        '
        Me.ServiceStatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Left
        Me.ServiceStatusLabel.Name = "ServiceStatusLabel"
        Me.ServiceStatusLabel.Size = New System.Drawing.Size(83, 19)
        Me.ServiceStatusLabel.Text = "Service Status"
        '
        'EnvironmentLabel
        '
        Me.EnvironmentLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Left
        Me.EnvironmentLabel.Name = "EnvironmentLabel"
        Me.EnvironmentLabel.Size = New System.Drawing.Size(99, 19)
        Me.EnvironmentLabel.Text = "Testing (Athena)"
        '
        'UserNameLabel
        '
        Me.UserNameLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Left
        Me.UserNameLabel.Name = "UserNameLabel"
        Me.UserNameLabel.Size = New System.Drawing.Size(36, 19)
        Me.UserNameLabel.Text = "JDoe"
        '
        'VersionLabel
        '
        Me.VersionLabel.AccessibleDescription = ""
        Me.VersionLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Left
        Me.VersionLabel.Name = "VersionLabel"
        Me.VersionLabel.Size = New System.Drawing.Size(78, 19)
        Me.VersionLabel.Text = "VersionLabel"
        '
        'MainPanel
        '
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.FixedPanel = System.Windows.Forms.FixedPanel.Panel1
        Me.MainPanel.Location = New System.Drawing.Point(0, 49)
        Me.MainPanel.Name = "MainPanel"
        '
        'MainPanel.Panel1
        '
        Me.MainPanel.Panel1.Controls.Add(Me.MultiPane)
        Me.MainPanel.Size = New System.Drawing.Size(978, 565)
        Me.MainPanel.SplitterDistance = 193
        Me.MainPanel.TabIndex = 3
        '
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(0, 0)
        Me.MultiPane.MaxShownTabs = 5
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(193, 565)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.PackageSetupTab)
        Me.MultiPane.Tabs.Add(Me.LoadingQueueTab)
        Me.MultiPane.Tabs.Add(Me.LoadReviewTab)
        Me.MultiPane.Tabs.Add(Me.RollbacksTab)
        Me.MultiPane.Tabs.Add(Me.ReportsTab)
        Me.MultiPane.Text = "MultiPane1"
        '
        'PackageSetupTab
        '
        Me.PackageSetupTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PackageSetupTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.PackageSetupTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.PackageSetupTab.Icon = CType(resources.GetObject("PackageSetupTab.Icon"), System.Drawing.Icon)
        Me.PackageSetupTab.Image = CType(resources.GetObject("PackageSetupTab.Image"), System.Drawing.Image)
        Me.PackageSetupTab.IsActive = True
        Me.PackageSetupTab.Location = New System.Drawing.Point(0, 0)
        Me.PackageSetupTab.Name = "PackageSetupTab"
        Me.PackageSetupTab.NavControlId = Nothing
        Me.PackageSetupTab.NavControlType = Nothing
        Me.PackageSetupTab.Size = New System.Drawing.Size(193, 32)
        Me.PackageSetupTab.TabIndex = 0
        Me.PackageSetupTab.Text = "Package Setup"
        '
        'LoadingQueueTab
        '
        Me.LoadingQueueTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LoadingQueueTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.LoadingQueueTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.LoadingQueueTab.Icon = CType(resources.GetObject("LoadingQueueTab.Icon"), System.Drawing.Icon)
        Me.LoadingQueueTab.Image = CType(resources.GetObject("LoadingQueueTab.Image"), System.Drawing.Image)
        Me.LoadingQueueTab.IsActive = False
        Me.LoadingQueueTab.Location = New System.Drawing.Point(0, 32)
        Me.LoadingQueueTab.Name = "LoadingQueueTab"
        Me.LoadingQueueTab.NavControlId = Nothing
        Me.LoadingQueueTab.NavControlType = Nothing
        Me.LoadingQueueTab.Size = New System.Drawing.Size(193, 32)
        Me.LoadingQueueTab.TabIndex = 1
        Me.LoadingQueueTab.Text = "Loading Queue"
        '
        'LoadReviewTab
        '
        Me.LoadReviewTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LoadReviewTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.LoadReviewTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.LoadReviewTab.Icon = CType(resources.GetObject("LoadReviewTab.Icon"), System.Drawing.Icon)
        Me.LoadReviewTab.Image = CType(resources.GetObject("LoadReviewTab.Image"), System.Drawing.Image)
        Me.LoadReviewTab.IsActive = False
        Me.LoadReviewTab.Location = New System.Drawing.Point(0, 64)
        Me.LoadReviewTab.Name = "LoadReviewTab"
        Me.LoadReviewTab.NavControlId = Nothing
        Me.LoadReviewTab.NavControlType = Nothing
        Me.LoadReviewTab.Size = New System.Drawing.Size(193, 32)
        Me.LoadReviewTab.TabIndex = 2
        Me.LoadReviewTab.Text = "Load Review"
        '
        'RollbacksTab
        '
        Me.RollbacksTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RollbacksTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.RollbacksTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.RollbacksTab.Icon = CType(resources.GetObject("RollbacksTab.Icon"), System.Drawing.Icon)
        Me.RollbacksTab.Image = CType(resources.GetObject("RollbacksTab.Image"), System.Drawing.Image)
        Me.RollbacksTab.IsActive = False
        Me.RollbacksTab.Location = New System.Drawing.Point(0, 96)
        Me.RollbacksTab.Name = "RollbacksTab"
        Me.RollbacksTab.NavControlId = Nothing
        Me.RollbacksTab.NavControlType = Nothing
        Me.RollbacksTab.Size = New System.Drawing.Size(193, 32)
        Me.RollbacksTab.TabIndex = 0
        Me.RollbacksTab.Text = "Rollbacks"
        '
        'ReportsTab
        '
        Me.ReportsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ReportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ReportsTab.Icon = CType(resources.GetObject("ReportsTab.Icon"), System.Drawing.Icon)
        Me.ReportsTab.Image = CType(resources.GetObject("ReportsTab.Image"), System.Drawing.Image)
        Me.ReportsTab.IsActive = False
        Me.ReportsTab.Location = New System.Drawing.Point(0, 128)
        Me.ReportsTab.Name = "ReportsTab"
        Me.ReportsTab.NavControlId = Nothing
        Me.ReportsTab.NavControlType = Nothing
        Me.ReportsTab.Size = New System.Drawing.Size(193, 32)
        Me.ReportsTab.TabIndex = 3
        Me.ReportsTab.Text = "Reports"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(978, 638)
        Me.Controls.Add(Me.MainPanel)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.MenuStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainForm"
        Me.Text = "MainForm"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.MainPanel.Panel1.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MultiPane As NRC.Framework.WinForms.MultiPane
    Friend WithEvents PackageSetupTab As NRC.Framework.WinForms.MultiPaneTab
    Friend WithEvents LoadingQueueTab As NRC.Framework.WinForms.MultiPaneTab
    Friend WithEvents LoadReviewTab As NRC.Framework.WinForms.MultiPaneTab
    Friend WithEvents ReportsTab As NRC.Framework.WinForms.MultiPaneTab
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ServiceStatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents svcController As System.ServiceProcess.ServiceController
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FunctionLibraryToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RollbacksTab As Nrc.Framework.WinForms.MultiPaneTab
End Class
