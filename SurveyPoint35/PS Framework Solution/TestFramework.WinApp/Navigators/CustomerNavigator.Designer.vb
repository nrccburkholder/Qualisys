<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CustomerNavigator
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
        Me.tv1 = New System.Windows.Forms.TreeView
        Me.SuspendLayout()
        '
        'tv1
        '
        Me.tv1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tv1.Location = New System.Drawing.Point(3, 3)
        Me.tv1.Name = "tv1"
        Me.tv1.Size = New System.Drawing.Size(250, 645)
        Me.tv1.TabIndex = 1
        '
        'CustomerNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.tv1)
        Me.Name = "CustomerNavigator"
        Me.Size = New System.Drawing.Size(256, 651)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents tv1 As System.Windows.Forms.TreeView

End Class
