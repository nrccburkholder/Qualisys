<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DemoNavigator
    Inherits PS.ResponseImport.WinServiceTester.Navigator

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
        Me.hsDemoStrip = New PS.Framework.WinForms.HeaderStrip
        Me.tvDemo = New System.Windows.Forms.TreeView
        Me.SuspendLayout()
        '
        'hsDemoStrip
        '
        Me.hsDemoStrip.AutoSize = False
        Me.hsDemoStrip.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.hsDemoStrip.ForeColor = System.Drawing.Color.White
        Me.hsDemoStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.hsDemoStrip.HeaderStyle = PS.Framework.WinForms.HeaderStripStyle.Large
        Me.hsDemoStrip.Location = New System.Drawing.Point(0, 0)
        Me.hsDemoStrip.Name = "hsDemoStrip"
        Me.hsDemoStrip.Size = New System.Drawing.Size(245, 25)
        Me.hsDemoStrip.TabIndex = 0
        Me.hsDemoStrip.Text = "HeaderStrip1"
        '
        'tvDemo
        '
        Me.tvDemo.Location = New System.Drawing.Point(3, 28)
        Me.tvDemo.Name = "tvDemo"
        Me.tvDemo.Size = New System.Drawing.Size(239, 527)
        Me.tvDemo.TabIndex = 1
        '
        'DemoNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.tvDemo)
        Me.Controls.Add(Me.hsDemoStrip)
        Me.Name = "DemoNavigator"
        Me.Size = New System.Drawing.Size(245, 558)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents hsDemoStrip As PS.Framework.WinForms.HeaderStrip
    Friend WithEvents tvDemo As System.Windows.Forms.TreeView

End Class
