<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmWeekdaysDetails
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
        Me.cmdOK = New System.Windows.Forms.Button
        Me.grpWeekdays = New System.Windows.Forms.GroupBox
        Me.chkDay4 = New System.Windows.Forms.CheckBox
        Me.chkDay7 = New System.Windows.Forms.CheckBox
        Me.chkDay3 = New System.Windows.Forms.CheckBox
        Me.chkDay6 = New System.Windows.Forms.CheckBox
        Me.chkDay2 = New System.Windows.Forms.CheckBox
        Me.chkDay5 = New System.Windows.Forms.CheckBox
        Me.chkDay1 = New System.Windows.Forms.CheckBox
        Me.cmdCancel = New System.Windows.Forms.Button
        Me.grpWeekdays.SuspendLayout()
        Me.SuspendLayout()
        '
        'cmdOK
        '
        Me.cmdOK.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.cmdOK.Location = New System.Drawing.Point(116, 133)
        Me.cmdOK.Name = "cmdOK"
        Me.cmdOK.Size = New System.Drawing.Size(77, 23)
        Me.cmdOK.TabIndex = 0
        Me.cmdOK.Text = "OK"
        Me.cmdOK.UseVisualStyleBackColor = True
        '
        'grpWeekdays
        '
        Me.grpWeekdays.Controls.Add(Me.chkDay4)
        Me.grpWeekdays.Controls.Add(Me.chkDay7)
        Me.grpWeekdays.Controls.Add(Me.chkDay3)
        Me.grpWeekdays.Controls.Add(Me.chkDay6)
        Me.grpWeekdays.Controls.Add(Me.chkDay2)
        Me.grpWeekdays.Controls.Add(Me.chkDay5)
        Me.grpWeekdays.Controls.Add(Me.chkDay1)
        Me.grpWeekdays.Location = New System.Drawing.Point(12, 12)
        Me.grpWeekdays.Name = "grpWeekdays"
        Me.grpWeekdays.Size = New System.Drawing.Size(188, 115)
        Me.grpWeekdays.TabIndex = 5
        Me.grpWeekdays.TabStop = False
        Me.grpWeekdays.Text = "WeekDays"
        '
        'chkDay4
        '
        Me.chkDay4.AutoSize = True
        Me.chkDay4.Location = New System.Drawing.Point(7, 92)
        Me.chkDay4.Name = "chkDay4"
        Me.chkDay4.Size = New System.Drawing.Size(83, 17)
        Me.chkDay4.TabIndex = 6
        Me.chkDay4.Text = "Wednesday"
        Me.chkDay4.UseVisualStyleBackColor = True
        '
        'chkDay7
        '
        Me.chkDay7.AutoSize = True
        Me.chkDay7.Location = New System.Drawing.Point(104, 68)
        Me.chkDay7.Name = "chkDay7"
        Me.chkDay7.Size = New System.Drawing.Size(68, 17)
        Me.chkDay7.TabIndex = 5
        Me.chkDay7.Text = "Saturday"
        Me.chkDay7.UseVisualStyleBackColor = True
        '
        'chkDay3
        '
        Me.chkDay3.AutoSize = True
        Me.chkDay3.Location = New System.Drawing.Point(7, 68)
        Me.chkDay3.Name = "chkDay3"
        Me.chkDay3.Size = New System.Drawing.Size(67, 17)
        Me.chkDay3.TabIndex = 4
        Me.chkDay3.Text = "Tuesday"
        Me.chkDay3.UseVisualStyleBackColor = True
        '
        'chkDay6
        '
        Me.chkDay6.AutoSize = True
        Me.chkDay6.Location = New System.Drawing.Point(104, 44)
        Me.chkDay6.Name = "chkDay6"
        Me.chkDay6.Size = New System.Drawing.Size(54, 17)
        Me.chkDay6.TabIndex = 3
        Me.chkDay6.Text = "Friday"
        Me.chkDay6.UseVisualStyleBackColor = True
        '
        'chkDay2
        '
        Me.chkDay2.AutoSize = True
        Me.chkDay2.Location = New System.Drawing.Point(7, 44)
        Me.chkDay2.Name = "chkDay2"
        Me.chkDay2.Size = New System.Drawing.Size(64, 17)
        Me.chkDay2.TabIndex = 2
        Me.chkDay2.Text = "Monday"
        Me.chkDay2.UseVisualStyleBackColor = True
        '
        'chkDay5
        '
        Me.chkDay5.AutoSize = True
        Me.chkDay5.Location = New System.Drawing.Point(104, 20)
        Me.chkDay5.Name = "chkDay5"
        Me.chkDay5.Size = New System.Drawing.Size(70, 17)
        Me.chkDay5.TabIndex = 1
        Me.chkDay5.Text = "Thursday"
        Me.chkDay5.UseVisualStyleBackColor = True
        '
        'chkDay1
        '
        Me.chkDay1.AutoSize = True
        Me.chkDay1.Location = New System.Drawing.Point(7, 20)
        Me.chkDay1.Name = "chkDay1"
        Me.chkDay1.Size = New System.Drawing.Size(62, 17)
        Me.chkDay1.TabIndex = 0
        Me.chkDay1.Text = "Sunday"
        Me.chkDay1.UseVisualStyleBackColor = True
        '
        'cmdCancel
        '
        Me.cmdCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.cmdCancel.Location = New System.Drawing.Point(19, 133)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 6
        Me.cmdCancel.Text = "Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'frmWeekdaysDetails
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(214, 168)
        Me.Controls.Add(Me.cmdCancel)
        Me.Controls.Add(Me.grpWeekdays)
        Me.Controls.Add(Me.cmdOK)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmWeekdaysDetails"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Week Days Details"
        Me.grpWeekdays.ResumeLayout(False)
        Me.grpWeekdays.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents cmdOK As System.Windows.Forms.Button
    Friend WithEvents grpWeekdays As System.Windows.Forms.GroupBox
    Friend WithEvents chkDay4 As System.Windows.Forms.CheckBox
    Friend WithEvents chkDay7 As System.Windows.Forms.CheckBox
    Friend WithEvents chkDay3 As System.Windows.Forms.CheckBox
    Friend WithEvents chkDay6 As System.Windows.Forms.CheckBox
    Friend WithEvents chkDay2 As System.Windows.Forms.CheckBox
    Friend WithEvents chkDay5 As System.Windows.Forms.CheckBox
    Friend WithEvents chkDay1 As System.Windows.Forms.CheckBox
    Friend WithEvents cmdCancel As System.Windows.Forms.Button

End Class
