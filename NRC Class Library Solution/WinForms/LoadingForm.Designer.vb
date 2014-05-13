<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class LoadingForm
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
        Me.LoadingLabel = New System.Windows.Forms.Label
        Me.Box = New System.Windows.Forms.GroupBox
        Me.Box.SuspendLayout()
        Me.SuspendLayout()
        '
        'LoadingLabel
        '
        Me.LoadingLabel.AutoSize = True
        Me.LoadingLabel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LoadingLabel.Location = New System.Drawing.Point(3, 16)
        Me.LoadingLabel.Margin = New System.Windows.Forms.Padding(0)
        Me.LoadingLabel.Name = "LoadingLabel"
        Me.LoadingLabel.Padding = New System.Windows.Forms.Padding(15)
        Me.LoadingLabel.Size = New System.Drawing.Size(69, 43)
        Me.LoadingLabel.TabIndex = 0
        Me.LoadingLabel.Text = "Label1"
        '
        'Box
        '
        Me.Box.AutoSize = True
        Me.Box.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Box.Controls.Add(Me.LoadingLabel)
        Me.Box.Location = New System.Drawing.Point(0, 0)
        Me.Box.Name = "Box"
        Me.Box.Size = New System.Drawing.Size(75, 62)
        Me.Box.TabIndex = 1
        Me.Box.TabStop = False
        '
        'LoadingForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.ClientSize = New System.Drawing.Size(200, 100)
        Me.Controls.Add(Me.Box)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.Name = "LoadingForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.TopMost = True
        Me.Box.ResumeLayout(False)
        Me.Box.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents LoadingLabel As System.Windows.Forms.Label
    Friend WithEvents Box As System.Windows.Forms.GroupBox
End Class
