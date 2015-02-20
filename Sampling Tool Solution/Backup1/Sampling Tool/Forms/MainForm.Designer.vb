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
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.StatusStrip = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.MultiPane = New Nrc.Framework.WinForms.MultiPane
        Me.SampleTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.ReportsTab = New Nrc.Framework.WinForms.MultiPaneTab
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.StatusStrip.SuspendLayout()
        Me.MainPanel.Panel1.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.ToolStripContainer1.BottomToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.ContentPanel.SuspendLayout()
        Me.ToolStripContainer1.SuspendLayout()
        Me.SuspendLayout()
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
        'StatusStrip
        '
        Me.StatusStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.StatusStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Visible
        Me.StatusStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StatusLabel, Me.UserNameLabel, Me.VersionLabel, Me.EnvironmentLabel})
        Me.StatusStrip.Location = New System.Drawing.Point(0, 0)
        Me.StatusStrip.Name = "StatusStrip"
        Me.StatusStrip.Size = New System.Drawing.Size(792, 22)
        Me.StatusStrip.TabIndex = 0
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.BorderStyle = System.Windows.Forms.Border3DStyle.Etched
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(619, 17)
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
        'MultiPane
        '
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(1, 1)
        Me.MultiPane.MaxShownTabs = 4
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.Size = New System.Drawing.Size(216, 542)
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.SampleTab)
        Me.MultiPane.Tabs.Add(Me.ReportsTab)
        Me.MultiPane.Text = "MultiPane"
        '
        'SampleTab
        '
        Me.SampleTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SampleTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.SampleTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.SampleTab.Icon = CType(resources.GetObject("SampleTab.Icon"), System.Drawing.Icon)
        Me.SampleTab.IsActive = True
        Me.SampleTab.Location = New System.Drawing.Point(0, 0)
        Me.SampleTab.Name = "SampleTab"
        Me.SampleTab.NavControlId = Nothing
        Me.SampleTab.NavControlType = Nothing
        Me.SampleTab.Size = New System.Drawing.Size(216, 32)
        Me.SampleTab.TabIndex = 3
        Me.SampleTab.Text = "Sample"
        '
        'ReportsTab
        '
        Me.ReportsTab.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportsTab.Cursor = System.Windows.Forms.Cursors.Hand
        Me.ReportsTab.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ReportsTab.Icon = CType(resources.GetObject("ReportsTab.Icon"), System.Drawing.Icon)
        Me.ReportsTab.IsActive = False
        Me.ReportsTab.Location = New System.Drawing.Point(0, 32)
        Me.ReportsTab.Name = "ReportsTab"
        Me.ReportsTab.NavControlId = Nothing
        Me.ReportsTab.NavControlType = Nothing
        Me.ReportsTab.Size = New System.Drawing.Size(216, 32)
        Me.ReportsTab.TabIndex = 4
        Me.ReportsTab.Text = "Reports"
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
        Me.MainPanel.Size = New System.Drawing.Size(792, 544)
        Me.MainPanel.SplitterDistance = 218
        Me.MainPanel.TabIndex = 0
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
        Me.ToolStripContainer1.ContentPanel.Size = New System.Drawing.Size(792, 544)
        Me.ToolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStripContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStripContainer1.Name = "ToolStripContainer1"
        Me.ToolStripContainer1.Size = New System.Drawing.Size(792, 566)
        Me.ToolStripContainer1.TabIndex = 3
        Me.ToolStripContainer1.Text = "ToolStripContainer1"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(792, 566)
        Me.Controls.Add(Me.ToolStripContainer1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimumSize = New System.Drawing.Size(800, 600)
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Sampling Tool"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.StatusStrip.ResumeLayout(False)
        Me.StatusStrip.PerformLayout()
        Me.MainPanel.Panel1.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.ToolStripContainer1.BottomToolStripPanel.ResumeLayout(False)
        Me.ToolStripContainer1.BottomToolStripPanel.PerformLayout()
        Me.ToolStripContainer1.ContentPanel.ResumeLayout(False)
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
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents SampleTab As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents ReportsTab As Nrc.Framework.WinForms.MultiPaneTab
End Class
