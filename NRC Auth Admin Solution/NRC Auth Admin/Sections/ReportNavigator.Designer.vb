<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportNavigator
    Inherits NrcAuthAdmin.Navigator

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
        Me.ReportsToolStrip = New System.Windows.Forms.ToolStrip
        Me.LoadingLabel = New System.Windows.Forms.Label
        Me.BackgroundReportLoader = New System.ComponentModel.BackgroundWorker
        Me.SuspendLayout()
        '
        'ReportsToolStrip
        '
        Me.ReportsToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ReportsToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.ReportsToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.ReportsToolStrip.Name = "ReportsToolStrip"
        Me.ReportsToolStrip.RenderMode = System.Windows.Forms.ToolStripRenderMode.System
        Me.ReportsToolStrip.Size = New System.Drawing.Size(185, 102)
        Me.ReportsToolStrip.TabIndex = 1
        Me.ReportsToolStrip.Text = "Reports"
        '
        'LoadingLabel
        '
        Me.LoadingLabel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LoadingLabel.ForeColor = System.Drawing.SystemColors.ControlDarkDark
        Me.LoadingLabel.Location = New System.Drawing.Point(0, 102)
        Me.LoadingLabel.Name = "LoadingLabel"
        Me.LoadingLabel.Size = New System.Drawing.Size(185, 283)
        Me.LoadingLabel.TabIndex = 2
        Me.LoadingLabel.Text = "Loading..."
        Me.LoadingLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'BackgroundReportLoader
        '
        '
        'ReportNavigator
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.LoadingLabel)
        Me.Controls.Add(Me.ReportsToolStrip)
        Me.Name = "ReportNavigator"
        Me.Size = New System.Drawing.Size(185, 385)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ReportsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LoadingLabel As System.Windows.Forms.Label
    Friend WithEvents BackgroundReportLoader As System.ComponentModel.BackgroundWorker

End Class
