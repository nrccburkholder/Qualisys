<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CriteriaEditorDialog
    Inherits Nrc.Framework.WinForms.DialogForm

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
        Me.OKButton = New System.Windows.Forms.Button
        Me.CanclButton = New System.Windows.Forms.Button
        Me.CriteriaEditorControl = New Nrc.Qualisys.ConfigurationManager.CriteriaEditor
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Criteria Editor"
        Me.mPaneCaption.Size = New System.Drawing.Size(612, 26)
        Me.mPaneCaption.Text = "Criteria Editor"
        '
        'OKButton
        '
        Me.OKButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.OKButton.Location = New System.Drawing.Point(452, 310)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 2
        Me.OKButton.Text = "OK"
        '
        'CanclButton
        '
        Me.CanclButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.CanclButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CanclButton.Location = New System.Drawing.Point(533, 310)
        Me.CanclButton.Name = "CanclButton"
        Me.CanclButton.Size = New System.Drawing.Size(75, 23)
        Me.CanclButton.TabIndex = 3
        Me.CanclButton.Text = "Cancel"
        '
        'CriteriaEditorControl
        '
        Me.CriteriaEditorControl.CriteriaStmt = Nothing
        Me.CriteriaEditorControl.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CriteriaEditorControl.Location = New System.Drawing.Point(1, 27)
        Me.CriteriaEditorControl.Name = "CriteriaEditorControl"
        Me.CriteriaEditorControl.ShowCriteriaStatement = True
        Me.CriteriaEditorControl.ShowRuleName = True
        Me.CriteriaEditorControl.Size = New System.Drawing.Size(612, 282)
        Me.CriteriaEditorControl.TabIndex = 4
        '
        'CriteriaEditorDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Caption = "Criteria Editor"
        Me.ClientSize = New System.Drawing.Size(614, 339)
        Me.Controls.Add(Me.CriteriaEditorControl)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.CanclButton)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "CriteriaEditorDialog"
        Me.Text = "Criteria Editor"
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.CanclButton, 0)
        Me.Controls.SetChildIndex(Me.OKButton, 0)
        Me.Controls.SetChildIndex(Me.CriteriaEditorControl, 0)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CanclButton As System.Windows.Forms.Button
    Friend WithEvents CriteriaEditorControl As Nrc.Qualisys.ConfigurationManager.CriteriaEditor

End Class
