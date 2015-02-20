<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportNavigator
    Inherits Qualisys.SamplingTool.Navigator

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ReportNavigator))
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.UnscheduledSamplesButton = New System.Windows.Forms.ToolStripButton
        Me.UpcomingSamplesButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.SamplingActivityButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'ToolStrip1
        '
        Me.ToolStrip1.AutoSize = False
        Me.ToolStrip1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.ImageScalingSize = New System.Drawing.Size(32, 32)
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UnscheduledSamplesButton, Me.UpcomingSamplesButton, Me.ToolStripSeparator1, Me.SamplingActivityButton})
        Me.ToolStrip1.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(192, 403)
        Me.ToolStrip1.Stretch = True
        Me.ToolStrip1.TabIndex = 0
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'UnscheduledSamplesButton
        '
        Me.UnscheduledSamplesButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Schedule32
        Me.UnscheduledSamplesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UnscheduledSamplesButton.Name = "UnscheduledSamplesButton"
        Me.UnscheduledSamplesButton.Size = New System.Drawing.Size(190, 36)
        Me.UnscheduledSamplesButton.Text = "Unscheduled Samples"
        '
        'UpcomingSamplesButton
        '
        Me.UpcomingSamplesButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Reports32
        Me.UpcomingSamplesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpcomingSamplesButton.Name = "UpcomingSamplesButton"
        Me.UpcomingSamplesButton.Size = New System.Drawing.Size(190, 36)
        Me.UpcomingSamplesButton.Text = "Upcoming Samples"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(190, 6)
        '
        'SamplingActivityButton
        '
        Me.SamplingActivityButton.Image = CType(resources.GetObject("SamplingActivityButton.Image"), System.Drawing.Image)
        Me.SamplingActivityButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SamplingActivityButton.Name = "SamplingActivityButton"
        Me.SamplingActivityButton.Size = New System.Drawing.Size(190, 36)
        Me.SamplingActivityButton.Text = "Sampling Activity"
        '
        'ReportNavigator
        '
        Me.Controls.Add(Me.ToolStrip1)
        Me.Name = "ReportNavigator"
        Me.Size = New System.Drawing.Size(192, 403)
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents UnscheduledSamplesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpcomingSamplesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SamplingActivityButton As System.Windows.Forms.ToolStripButton

End Class
