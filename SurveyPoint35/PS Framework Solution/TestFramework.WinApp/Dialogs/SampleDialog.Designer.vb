<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SampleDialog
    Inherits PS.Framework.WinForms.DialogForm

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
        Me.cmdClose = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Sample Form"
        Me.mPaneCaption.Size = New System.Drawing.Size(298, 26)
        Me.mPaneCaption.Text = "Sample Form"
        '
        'cmdClose
        '
        Me.cmdClose.Location = New System.Drawing.Point(209, 254)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(75, 23)
        Me.cmdClose.TabIndex = 1
        Me.cmdClose.Text = "Close"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'SampleDialog
        '
        Me.Caption = "Sample Form"
        Me.ClientSize = New System.Drawing.Size(300, 300)
        Me.Controls.Add(Me.cmdClose)
        Me.Name = "SampleDialog"
        Me.Controls.SetChildIndex(Me.cmdClose, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents cmdClose As System.Windows.Forms.Button

End Class
