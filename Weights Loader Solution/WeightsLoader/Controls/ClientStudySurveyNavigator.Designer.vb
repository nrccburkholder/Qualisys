<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientStudySurveyNavigator
    Inherits DataMart.WeightsLoader.Navigator

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
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ClientStudySurveyTree = New NRC.DataMart.WeightsLoader.MultiSelectTreeView
        Me.HeaderStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(232, 19)
        Me.HeaderStrip1.TabIndex = 2
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(160, 16)
        Me.ToolStripLabel1.Text = "Select a client, study or survey."
        '
        'ClientStudySurveyTree
        '
        Me.ClientStudySurveyTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ClientStudySurveyTree.HideSelection = False
        Me.ClientStudySurveyTree.Location = New System.Drawing.Point(0, 19)
        Me.ClientStudySurveyTree.Name = "ClientStudySurveyTree"
        Me.ClientStudySurveyTree.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.ClientStudySurveyTree.Size = New System.Drawing.Size(232, 375)
        Me.ClientStudySurveyTree.TabIndex = 3
        '
        'ClientStudySurveyNavigator
        '
        Me.Controls.Add(Me.ClientStudySurveyTree)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "ClientStudySurveyNavigator"
        Me.Size = New System.Drawing.Size(232, 394)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ClientStudySurveyTree As NRC.DataMart.WeightsLoader.MultiSelectTreeView

End Class
