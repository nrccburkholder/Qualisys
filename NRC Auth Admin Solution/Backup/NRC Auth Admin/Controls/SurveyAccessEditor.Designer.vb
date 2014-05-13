<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SurveyAccessEditor
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.TreeView = New System.Windows.Forms.TreeView
        Me.SelectedNodesLabel = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'TreeView
        '
        Me.TreeView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TreeView.CheckBoxes = True
        Me.TreeView.Location = New System.Drawing.Point(0, 0)
        Me.TreeView.Name = "TreeView"
        Me.TreeView.Size = New System.Drawing.Size(465, 256)
        Me.TreeView.TabIndex = 0
        '
        'SelectedNodesLabel
        '
        Me.SelectedNodesLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.SelectedNodesLabel.AutoSize = True
        Me.SelectedNodesLabel.Location = New System.Drawing.Point(4, 263)
        Me.SelectedNodesLabel.Name = "SelectedNodesLabel"
        Me.SelectedNodesLabel.Size = New System.Drawing.Size(103, 13)
        Me.SelectedNodesLabel.TabIndex = 1
        Me.SelectedNodesLabel.Text = "0 items are selected"
        Me.SelectedNodesLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyResultEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SelectedNodesLabel)
        Me.Controls.Add(Me.TreeView)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "SurveyResultEditor"
        Me.Size = New System.Drawing.Size(465, 285)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TreeView As System.Windows.Forms.TreeView
    Friend WithEvents SelectedNodesLabel As System.Windows.Forms.Label

End Class
