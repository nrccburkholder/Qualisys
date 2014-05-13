<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MyNavigator
    Inherits SampleApplication.Navigator

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
        Dim TreeNode1 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("UPLOADFILENOTIFICATION")
        Dim TreeNode2 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Templates", New System.Windows.Forms.TreeNode() {TreeNode1})
        Me.MyToolStrip = New System.Windows.Forms.ToolStrip
        Me.TreeView1 = New System.Windows.Forms.TreeView
        Me.SuspendLayout()
        '
        'MyToolStrip
        '
        Me.MyToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.MyToolStrip.Name = "MyToolStrip"
        Me.MyToolStrip.Size = New System.Drawing.Size(208, 25)
        Me.MyToolStrip.TabIndex = 0
        Me.MyToolStrip.Text = "ToolStrip1"
        '
        'TreeView1
        '
        Me.TreeView1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TreeView1.Location = New System.Drawing.Point(3, 28)
        Me.TreeView1.Name = "TreeView1"
        TreeNode1.Name = "Node1"
        TreeNode1.Tag = """UPLOADFILENOTIFICATION"""
        TreeNode1.Text = "UPLOADFILENOTIFICATION"
        TreeNode2.Name = "Node0"
        TreeNode2.Text = "Templates"
        Me.TreeView1.Nodes.AddRange(New System.Windows.Forms.TreeNode() {TreeNode2})
        Me.TreeView1.Size = New System.Drawing.Size(202, 295)
        Me.TreeView1.TabIndex = 1
        '
        'MyNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.TreeView1)
        Me.Controls.Add(Me.MyToolStrip)
        Me.Name = "MyNavigator"
        Me.Size = New System.Drawing.Size(208, 326)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MyToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents TreeView1 As System.Windows.Forms.TreeView

End Class
