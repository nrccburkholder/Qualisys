<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
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
        Me.SeededMailingServiceButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'SeededMailingServiceButton
        '
        Me.SeededMailingServiceButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SeededMailingServiceButton.Location = New System.Drawing.Point(13, 13)
        Me.SeededMailingServiceButton.Name = "SeededMailingServiceButton"
        Me.SeededMailingServiceButton.Size = New System.Drawing.Size(260, 23)
        Me.SeededMailingServiceButton.TabIndex = 0
        Me.SeededMailingServiceButton.Text = "Seeded Mailing Service"
        Me.SeededMailingServiceButton.UseVisualStyleBackColor = True
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(285, 53)
        Me.Controls.Add(Me.SeededMailingServiceButton)
        Me.Name = "MainForm"
        Me.Text = "Seeded Mailing Service Tester"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SeededMailingServiceButton As System.Windows.Forms.Button

End Class
