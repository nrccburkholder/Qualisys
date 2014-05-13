<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportErrorDialog
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
        Me.DetailsInTPS_Label = New System.Windows.Forms.Label
        Me.FileNotCreated_Label = New System.Windows.Forms.Label
        Me.OK_Button = New System.Windows.Forms.Button
        Me.CreateFile_Button = New System.Windows.Forms.Button
        Me.Button1 = New System.Windows.Forms.Button
        Me.FileNameLabel = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Error"
        Me.mPaneCaption.Size = New System.Drawing.Size(352, 26)
        Me.mPaneCaption.Text = "Error"
        '
        'DetailsInTPS_Label
        '
        Me.DetailsInTPS_Label.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DetailsInTPS_Label.AutoSize = True
        Me.DetailsInTPS_Label.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.DetailsInTPS_Label.Location = New System.Drawing.Point(80, 122)
        Me.DetailsInTPS_Label.Name = "DetailsInTPS_Label"
        Me.DetailsInTPS_Label.Size = New System.Drawing.Size(181, 16)
        Me.DetailsInTPS_Label.TabIndex = 7
        Me.DetailsInTPS_Label.Text = "Details are in the TPS Report"
        '
        'FileNotCreated_Label
        '
        Me.FileNotCreated_Label.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileNotCreated_Label.AutoSize = True
        Me.FileNotCreated_Label.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FileNotCreated_Label.Location = New System.Drawing.Point(27, 46)
        Me.FileNotCreated_Label.Name = "FileNotCreated_Label"
        Me.FileNotCreated_Label.Size = New System.Drawing.Size(307, 16)
        Me.FileNotCreated_Label.TabIndex = 6
        Me.FileNotCreated_Label.Text = "This File Not Created Due To Terminal Conditions."
        '
        'OK_Button
        '
        Me.OK_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OK_Button.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.OK_Button.Location = New System.Drawing.Point(244, 176)
        Me.OK_Button.Name = "OK_Button"
        Me.OK_Button.Size = New System.Drawing.Size(89, 23)
        Me.OK_Button.TabIndex = 4
        Me.OK_Button.Text = "&OK"
        Me.OK_Button.UseVisualStyleBackColor = True
        '
        'CreateFile_Button
        '
        Me.CreateFile_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CreateFile_Button.DialogResult = System.Windows.Forms.DialogResult.No
        Me.CreateFile_Button.Location = New System.Drawing.Point(21, 176)
        Me.CreateFile_Button.Name = "CreateFile_Button"
        Me.CreateFile_Button.Size = New System.Drawing.Size(104, 23)
        Me.CreateFile_Button.TabIndex = 8
        Me.CreateFile_Button.Text = "&Create File"
        Me.CreateFile_Button.UseVisualStyleBackColor = True
        Me.CreateFile_Button.Visible = False
        '
        'Button1
        '
        Me.Button1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button1.Location = New System.Drawing.Point(131, 176)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(107, 23)
        Me.Button1.TabIndex = 10
        Me.Button1.Text = "Open &Report"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'FileNameLabel
        '
        Me.FileNameLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileNameLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FileNameLabel.Location = New System.Drawing.Point(21, 84)
        Me.FileNameLabel.Name = "FileNameLabel"
        Me.FileNameLabel.Size = New System.Drawing.Size(313, 13)
        Me.FileNameLabel.TabIndex = 11
        Me.FileNameLabel.Text = "(place file name here)"
        Me.FileNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'ExportErrorDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Caption = "Error"
        Me.ClientSize = New System.Drawing.Size(354, 211)
        Me.ControlBox = False
        Me.Controls.Add(Me.FileNameLabel)
        Me.Controls.Add(Me.Button1)
        Me.Controls.Add(Me.CreateFile_Button)
        Me.Controls.Add(Me.DetailsInTPS_Label)
        Me.Controls.Add(Me.FileNotCreated_Label)
        Me.Controls.Add(Me.OK_Button)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "ExportErrorDialog"
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.OK_Button, 0)
        Me.Controls.SetChildIndex(Me.FileNotCreated_Label, 0)
        Me.Controls.SetChildIndex(Me.DetailsInTPS_Label, 0)
        Me.Controls.SetChildIndex(Me.CreateFile_Button, 0)
        Me.Controls.SetChildIndex(Me.Button1, 0)
        Me.Controls.SetChildIndex(Me.FileNameLabel, 0)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents DetailsInTPS_Label As System.Windows.Forms.Label
    Friend WithEvents FileNotCreated_Label As System.Windows.Forms.Label
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents CreateFile_Button As System.Windows.Forms.Button
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents FileNameLabel As System.Windows.Forms.Label
End Class
