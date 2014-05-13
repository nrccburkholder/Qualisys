<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class QSIVendorFileServiceTest
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
        Me.components = New System.ComponentModel.Container
        Me.RunAsServiceGroupBox = New System.Windows.Forms.GroupBox
        Me.ServiceStatusLabel = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.ServiceTextBox = New System.Windows.Forms.TextBox
        Me.StopButton = New System.Windows.Forms.Button
        Me.ContinueButton = New System.Windows.Forms.Button
        Me.PauseButton = New System.Windows.Forms.Button
        Me.StartButton = New System.Windows.Forms.Button
        Me.ServiceTimer = New System.Windows.Forms.Timer(Me.components)
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.VendorFileTelematchLogIDTextBox = New System.Windows.Forms.TextBox
        Me.VendorFileIDTextBox = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.TelematchReceiveButton = New System.Windows.Forms.Button
        Me.TelematchSendButton = New System.Windows.Forms.Button
        Me.RunAsServiceGroupBox.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'RunAsServiceGroupBox
        '
        Me.RunAsServiceGroupBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RunAsServiceGroupBox.Controls.Add(Me.ServiceStatusLabel)
        Me.RunAsServiceGroupBox.Controls.Add(Me.Label1)
        Me.RunAsServiceGroupBox.Controls.Add(Me.ServiceTextBox)
        Me.RunAsServiceGroupBox.Controls.Add(Me.StopButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.ContinueButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.PauseButton)
        Me.RunAsServiceGroupBox.Controls.Add(Me.StartButton)
        Me.RunAsServiceGroupBox.Location = New System.Drawing.Point(12, 12)
        Me.RunAsServiceGroupBox.Name = "RunAsServiceGroupBox"
        Me.RunAsServiceGroupBox.Size = New System.Drawing.Size(490, 207)
        Me.RunAsServiceGroupBox.TabIndex = 9
        Me.RunAsServiceGroupBox.TabStop = False
        Me.RunAsServiceGroupBox.Text = "Run As Service"
        '
        'ServiceStatusLabel
        '
        Me.ServiceStatusLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ServiceStatusLabel.AutoSize = True
        Me.ServiceStatusLabel.Location = New System.Drawing.Point(88, 188)
        Me.ServiceStatusLabel.Name = "ServiceStatusLabel"
        Me.ServiceStatusLabel.Size = New System.Drawing.Size(47, 13)
        Me.ServiceStatusLabel.TabIndex = 6
        Me.ServiceStatusLabel.Text = "Stopped"
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 188)
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
        Me.ServiceTextBox.Size = New System.Drawing.Size(396, 152)
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
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.VendorFileTelematchLogIDTextBox)
        Me.GroupBox1.Controls.Add(Me.VendorFileIDTextBox)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.TelematchReceiveButton)
        Me.GroupBox1.Controls.Add(Me.TelematchSendButton)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 225)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(490, 112)
        Me.GroupBox1.TabIndex = 10
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Telematch Testing"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(7, 51)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(151, 13)
        Me.Label3.TabIndex = 18
        Me.Label3.Text = "Vendor File Telematch Log ID:"
        '
        'VendorFileTelematchLogIDTextBox
        '
        Me.VendorFileTelematchLogIDTextBox.Location = New System.Drawing.Point(164, 48)
        Me.VendorFileTelematchLogIDTextBox.Name = "VendorFileTelematchLogIDTextBox"
        Me.VendorFileTelematchLogIDTextBox.Size = New System.Drawing.Size(69, 20)
        Me.VendorFileTelematchLogIDTextBox.TabIndex = 17
        '
        'VendorFileIDTextBox
        '
        Me.VendorFileIDTextBox.Location = New System.Drawing.Point(164, 19)
        Me.VendorFileIDTextBox.Name = "VendorFileIDTextBox"
        Me.VendorFileIDTextBox.Size = New System.Drawing.Size(69, 20)
        Me.VendorFileIDTextBox.TabIndex = 16
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(7, 22)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(77, 13)
        Me.Label2.TabIndex = 15
        Me.Label2.Text = "Vendor File ID:"
        '
        'TelematchReceiveButton
        '
        Me.TelematchReceiveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TelematchReceiveButton.Location = New System.Drawing.Point(359, 81)
        Me.TelematchReceiveButton.Name = "TelematchReceiveButton"
        Me.TelematchReceiveButton.Size = New System.Drawing.Size(125, 23)
        Me.TelematchReceiveButton.TabIndex = 14
        Me.TelematchReceiveButton.Text = "Telematch Receive"
        Me.TelematchReceiveButton.UseVisualStyleBackColor = True
        '
        'TelematchSendButton
        '
        Me.TelematchSendButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TelematchSendButton.Location = New System.Drawing.Point(228, 81)
        Me.TelematchSendButton.Name = "TelematchSendButton"
        Me.TelematchSendButton.Size = New System.Drawing.Size(125, 23)
        Me.TelematchSendButton.TabIndex = 13
        Me.TelematchSendButton.Text = "Telematch Send"
        Me.TelematchSendButton.UseVisualStyleBackColor = True
        '
        'VendorFileTestForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 349)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.RunAsServiceGroupBox)
        Me.Name = "VendorFileTestForm"
        Me.Text = "File Mover Service Test"
        Me.RunAsServiceGroupBox.ResumeLayout(False)
        Me.RunAsServiceGroupBox.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents RunAsServiceGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents StartButton As System.Windows.Forms.Button
    Friend WithEvents StopButton As System.Windows.Forms.Button
    Friend WithEvents ContinueButton As System.Windows.Forms.Button
    Friend WithEvents PauseButton As System.Windows.Forms.Button
    Friend WithEvents ServiceTextBox As System.Windows.Forms.TextBox
    Friend WithEvents ServiceStatusLabel As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ServiceTimer As System.Windows.Forms.Timer
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents VendorFileTelematchLogIDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents VendorFileIDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents TelematchReceiveButton As System.Windows.Forms.Button
    Friend WithEvents TelematchSendButton As System.Windows.Forms.Button
End Class
