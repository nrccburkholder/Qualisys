<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SeededMailingServiceTest
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
        Me.components = New System.ComponentModel.Container
        Me.RunNowButton = New System.Windows.Forms.Button
        Me.RunAsServiceGroupBox = New System.Windows.Forms.GroupBox
        Me.ServiceStatusLabel = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.ServiceTextBox = New System.Windows.Forms.TextBox
        Me.StopButton = New System.Windows.Forms.Button
        Me.ContinueButton = New System.Windows.Forms.Button
        Me.PauseButton = New System.Windows.Forms.Button
        Me.StartButton = New System.Windows.Forms.Button
        Me.ServiceTimer = New System.Windows.Forms.Timer(Me.components)
        Me.RunAsServiceGroupBox.SuspendLayout()
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
        Me.RunAsServiceGroupBox.Size = New System.Drawing.Size(438, 208)
        Me.RunAsServiceGroupBox.TabIndex = 10
        Me.RunAsServiceGroupBox.TabStop = False
        Me.RunAsServiceGroupBox.Text = "Run As Service"
        '
        'ServiceStatusLabel
        '
        Me.ServiceStatusLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ServiceStatusLabel.AutoSize = True
        Me.ServiceStatusLabel.Location = New System.Drawing.Point(88, 189)
        Me.ServiceStatusLabel.Name = "ServiceStatusLabel"
        Me.ServiceStatusLabel.Size = New System.Drawing.Size(47, 13)
        Me.ServiceStatusLabel.TabIndex = 6
        Me.ServiceStatusLabel.Text = "Stopped"
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 189)
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
        Me.ServiceTextBox.Size = New System.Drawing.Size(344, 153)
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
        'SeededMailingServiceTest
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(462, 266)
        Me.Controls.Add(Me.RunAsServiceGroupBox)
        Me.Name = "SeededMailingServiceTest"
        Me.Text = "VoviciTestForm"
        Me.RunAsServiceGroupBox.ResumeLayout(False)
        Me.RunAsServiceGroupBox.PerformLayout()
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
End Class
