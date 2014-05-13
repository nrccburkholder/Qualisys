<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ApplicationNavigator
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
        Me.ApplicationToolStrip = New System.Windows.Forms.ToolStrip
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.NewApplicationButton = New System.Windows.Forms.ToolStripButton
        Me.Panel1.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'ApplicationToolStrip
        '
        Me.ApplicationToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ApplicationToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.ApplicationToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.ApplicationToolStrip.Name = "ApplicationToolStrip"
        Me.ApplicationToolStrip.RenderMode = System.Windows.Forms.ToolStripRenderMode.System
        Me.ApplicationToolStrip.Size = New System.Drawing.Size(230, 102)
        Me.ApplicationToolStrip.TabIndex = 0
        Me.ApplicationToolStrip.Text = "ToolStrip1"
        '
        'Panel1
        '
        Me.Panel1.AutoScroll = True
        Me.Panel1.Controls.Add(Me.ApplicationToolStrip)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(0, 25)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(230, 317)
        Me.Panel1.TabIndex = 1
        '
        'ToolStrip1
        '
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewApplicationButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(230, 25)
        Me.ToolStrip1.TabIndex = 1
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'NewApplicationButton
        '
        Me.NewApplicationButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.New16
        Me.NewApplicationButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NewApplicationButton.Name = "NewApplicationButton"
        Me.NewApplicationButton.Size = New System.Drawing.Size(103, 22)
        Me.NewApplicationButton.Text = "New Application"
        '
        'ApplicationNavigator
        '
        Me.AutoScroll = True
        Me.AutoSize = True
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.Panel1)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Name = "ApplicationNavigator"
        Me.Size = New System.Drawing.Size(230, 342)
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ApplicationToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents NewApplicationButton As System.Windows.Forms.ToolStripButton

End Class
