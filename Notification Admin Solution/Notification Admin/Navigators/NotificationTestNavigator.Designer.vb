<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NotificationTestNavigator
    Inherits Navigator

    'UserControl overrides dispose to clean up the component list.
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
        Me.tvTemplates = New System.Windows.Forms.TreeView
        Me.SuspendLayout()
        '
        'tvTemplates
        '
        Me.tvTemplates.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tvTemplates.HideSelection = False
        Me.tvTemplates.Location = New System.Drawing.Point(0, 0)
        Me.tvTemplates.Name = "tvTemplates"
        Me.tvTemplates.Size = New System.Drawing.Size(218, 404)
        Me.tvTemplates.TabIndex = 0
        '
        'NotificationTestNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.tvTemplates)
        Me.Name = "NotificationTestNavigator"
        Me.Size = New System.Drawing.Size(218, 404)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents tvTemplates As System.Windows.Forms.TreeView

End Class
