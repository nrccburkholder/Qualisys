<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CAHPSNavigator
    Inherits DataMart.ExportManager.Navigator

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
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.SelectHeaderStrip = New Nrc.Framework.WinForms.HeaderStrip
        Me.CAHPSTreeView = New System.Windows.Forms.TreeView
        Me.SelectHeaderStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(153, 15)
        Me.ToolStripLabel1.Text = "Select a CAHPS export type."
        '
        'SelectHeaderStrip
        '
        Me.SelectHeaderStrip.AutoSize = False
        Me.SelectHeaderStrip.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.SelectHeaderStrip.ForeColor = System.Drawing.Color.Black
        Me.SelectHeaderStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.SelectHeaderStrip.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.SelectHeaderStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.SelectHeaderStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.Table
        Me.SelectHeaderStrip.Location = New System.Drawing.Point(0, 0)
        Me.SelectHeaderStrip.Name = "SelectHeaderStrip"
        Me.SelectHeaderStrip.Size = New System.Drawing.Size(234, 19)
        Me.SelectHeaderStrip.TabIndex = 6
        Me.SelectHeaderStrip.Text = "HeaderStrip1"
        '
        'CAHPSTreeView
        '
        Me.CAHPSTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CAHPSTreeView.FullRowSelect = True
        Me.CAHPSTreeView.HideSelection = False
        Me.CAHPSTreeView.Location = New System.Drawing.Point(0, 19)
        Me.CAHPSTreeView.Name = "CAHPSTreeView"
        Me.CAHPSTreeView.ShowLines = False
        Me.CAHPSTreeView.ShowPlusMinus = False
        Me.CAHPSTreeView.ShowRootLines = False
        Me.CAHPSTreeView.Size = New System.Drawing.Size(234, 382)
        Me.CAHPSTreeView.TabIndex = 8
        '
        'CAHPSNavigator
        '
        Me.Controls.Add(Me.CAHPSTreeView)
        Me.Controls.Add(Me.SelectHeaderStrip)
        Me.Name = "CAHPSNavigator"
        Me.Size = New System.Drawing.Size(234, 401)
        Me.SelectHeaderStrip.ResumeLayout(False)
        Me.SelectHeaderStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Protected WithEvents SelectHeaderStrip As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents CAHPSTreeView As System.Windows.Forms.TreeView

End Class
