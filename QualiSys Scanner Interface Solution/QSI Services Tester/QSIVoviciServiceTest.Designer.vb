<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class QSIVoviciServiceTest
    Inherits System.Windows.Forms.Form

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
        Me.components = New System.ComponentModel.Container()
        Me.RunNowButton = New System.Windows.Forms.Button()
        Me.RunAsServiceGroupBox = New System.Windows.Forms.GroupBox()
        Me.ServiceStatusLabel = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.ServiceTextBox = New System.Windows.Forms.TextBox()
        Me.StopButton = New System.Windows.Forms.Button()
        Me.ContinueButton = New System.Windows.Forms.Button()
        Me.PauseButton = New System.Windows.Forms.Button()
        Me.StartButton = New System.Windows.Forms.Button()
        Me.ServiceTimer = New System.Windows.Forms.Timer(Me.components)
        Me.DateTimePicker = New System.Windows.Forms.DateTimePicker()
        Me.RadioButSystime = New System.Windows.Forms.RadioButton()
        Me.CurrentTime = New System.Windows.Forms.GroupBox()
        Me.RadioButnSelectTime = New System.Windows.Forms.RadioButton()
        Me.RunAsServiceGroupBox.SuspendLayout()
        Me.CurrentTime.SuspendLayout()
        Me.SuspendLayout()
        '
        'RunNowButton
        '
        Me.RunNowButton.Location = New System.Drawing.Point(7, 149)
        Me.RunNowButton.Name = "RunNowButton"
        Me.RunNowButton.Size = New System.Drawing.Size(75, 23)
        Me.RunNowButton.TabIndex = 7
        Me.RunNowButton.Text = "Run Now"
        Me.RunNowButton.UseVisualStyleBackColor = True
        '
        'RunAsServiceGroupBox
        '
        Me.RunAsServiceGroupBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RunAsServiceGroupBox.Controls.Add(Me.RunNowButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.ServiceStatusLabel)
        Me.RunAsServiceGroupBox.Controls.Add(Me.Label1)
        Me.RunAsServiceGroupBox.Controls.Add(Me.ServiceTextBox)
        Me.RunAsServiceGroupBox.Controls.Add(Me.StopButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.ContinueButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.PauseButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.StartButton)
        Me.RunAsServiceGroupBox.Location = New System.Drawing.Point(12, 12)
        Me.RunAsServiceGroupBox.Name = "RunAsServiceGroupBox"
        Me.RunAsServiceGroupBox.Size = New System.Drawing.Size(438, 222)
        Me.RunAsServiceGroupBox.TabIndex = 10
        Me.RunAsServiceGroupBox.TabStop = False
        Me.RunAsServiceGroupBox.Text = "Run As Service"
        '
        'ServiceStatusLabel
        '
        Me.ServiceStatusLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ServiceStatusLabel.AutoSize = True
        Me.ServiceStatusLabel.Location = New System.Drawing.Point(88, 203)
        Me.ServiceStatusLabel.Name = "ServiceStatusLabel"
        Me.ServiceStatusLabel.Size = New System.Drawing.Size(47, 13)
        Me.ServiceStatusLabel.TabIndex = 6
        Me.ServiceStatusLabel.Text = "Stopped"
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 203)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(74, 13)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Service State:"
        '
        'ServiceTextBox
        '
        Me.ServiceTextBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ServiceTextBox.Location = New System.Drawing.Point(88, 19)
        Me.ServiceTextBox.Multiline = True
        Me.ServiceTextBox.Name = "ServiceTextBox"
        Me.ServiceTextBox.ReadOnly = True
        Me.ServiceTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.ServiceTextBox.Size = New System.Drawing.Size(344, 167)
        Me.ServiceTextBox.TabIndex = 4
        '
        'StopButton
        '
        Me.StopButton.Enabled = False
        Me.StopButton.Location = New System.Drawing.Point(7, 107)
        Me.StopButton.Name = "StopButton"
        Me.StopButton.Size = New System.Drawing.Size(75, 23)
        Me.StopButton.TabIndex = 3
        Me.StopButton.Text = "Stop"
        Me.StopButton.UseVisualStyleBackColor = True
        '
        'ContinueButton
        '
        Me.ContinueButton.Enabled = False
        Me.ContinueButton.Location = New System.Drawing.Point(7, 78)
        Me.ContinueButton.Name = "ContinueButton"
        Me.ContinueButton.Size = New System.Drawing.Size(75, 23)
        Me.ContinueButton.TabIndex = 2
        Me.ContinueButton.Text = "Continue"
        Me.ContinueButton.UseVisualStyleBackColor = True
        '
        'PauseButton
        '
        Me.PauseButton.Enabled = False
        Me.PauseButton.Location = New System.Drawing.Point(7, 49)
        Me.PauseButton.Name = "PauseButton"
        Me.PauseButton.Size = New System.Drawing.Size(75, 23)
        Me.PauseButton.TabIndex = 1
        Me.PauseButton.Text = "Pause"
        Me.PauseButton.UseVisualStyleBackColor = True
        '
        'StartButton
        '
        Me.StartButton.Location = New System.Drawing.Point(7, 20)
        Me.StartButton.Name = "StartButton"
        Me.StartButton.Size = New System.Drawing.Size(75, 23)
        Me.StartButton.TabIndex = 0
        Me.StartButton.Text = "Start"
        Me.StartButton.UseVisualStyleBackColor = True
        '
        'ServiceTimer
        '
        '
        'DateTimePicker
        '
        Me.DateTimePicker.CustomFormat = "MM dd yyyy hh mm ss tt"
        Me.DateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.DateTimePicker.Location = New System.Drawing.Point(281, 256)
        Me.DateTimePicker.Name = "DateTimePicker"
        Me.DateTimePicker.Size = New System.Drawing.Size(163, 20)
        Me.DateTimePicker.TabIndex = 11
        Me.DateTimePicker.Value = New Date(2013, 7, 2, 16, 3, 13, 0)
        '
        'RadioButSystime
        '
        Me.RadioButSystime.AutoSize = True
        Me.RadioButSystime.Checked = True
        Me.RadioButSystime.Location = New System.Drawing.Point(98, 19)
        Me.RadioButSystime.Name = "RadioButSystime"
        Me.RadioButSystime.Size = New System.Drawing.Size(87, 17)
        Me.RadioButSystime.TabIndex = 12
        Me.RadioButSystime.TabStop = True
        Me.RadioButSystime.Text = "Use SysTime"
        Me.RadioButSystime.UseVisualStyleBackColor = True
        '
        'CurrentTime
        '
        Me.CurrentTime.Controls.Add(Me.RadioButnSelectTime)
        Me.CurrentTime.Controls.Add(Me.RadioButSystime)
        Me.CurrentTime.Location = New System.Drawing.Point(-3, 240)
        Me.CurrentTime.Name = "CurrentTime"
        Me.CurrentTime.Size = New System.Drawing.Size(278, 46)
        Me.CurrentTime.TabIndex = 13
        Me.CurrentTime.TabStop = False
        Me.CurrentTime.Text = "On 'RunNow' button the Time  Sent to Vovici"
        '
        'RadioButnSelectTime
        '
        Me.RadioButnSelectTime.AutoSize = True
        Me.RadioButnSelectTime.Location = New System.Drawing.Point(191, 19)
        Me.RadioButnSelectTime.Name = "RadioButnSelectTime"
        Me.RadioButnSelectTime.Size = New System.Drawing.Size(90, 17)
        Me.RadioButnSelectTime.TabIndex = 13
        Me.RadioButnSelectTime.Text = "Select a Time"
        Me.RadioButnSelectTime.UseVisualStyleBackColor = True
        '
        'QSIVoviciServiceTest
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(462, 296)
        Me.Controls.Add(Me.CurrentTime)
        Me.Controls.Add(Me.DateTimePicker)
        Me.Controls.Add(Me.RunAsServiceGroupBox)
        Me.Name = "QSIVoviciServiceTest"
        Me.Text = "VoviciTestForm"
        Me.RunAsServiceGroupBox.ResumeLayout(False)
        Me.RunAsServiceGroupBox.PerformLayout()
        Me.CurrentTime.ResumeLayout(False)
        Me.CurrentTime.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents RunNowButton As System.Windows.Forms.Button
    Friend WithEvents RunAsServiceGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents ServiceStatusLabel As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ServiceTextBox As System.Windows.Forms.TextBox
    Friend WithEvents StopButton As System.Windows.Forms.Button
    Friend WithEvents ContinueButton As System.Windows.Forms.Button
    Friend WithEvents PauseButton As System.Windows.Forms.Button
    Friend WithEvents StartButton As System.Windows.Forms.Button
    Friend WithEvents ServiceTimer As System.Windows.Forms.Timer
    Friend WithEvents DateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents RadioButSystime As System.Windows.Forms.RadioButton
    Friend WithEvents CurrentTime As System.Windows.Forms.GroupBox
    Friend WithEvents RadioButnSelectTime As System.Windows.Forms.RadioButton
End Class
