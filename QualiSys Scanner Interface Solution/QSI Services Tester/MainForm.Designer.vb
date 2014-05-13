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
        Me.TransferResultsServiceButton = New System.Windows.Forms.Button
        Me.FileMoverServiceButton = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.QSIFileMoverServiceStatusLabel = New System.Windows.Forms.Label
        Me.QSITransferResultsServiceStatusLabel = New System.Windows.Forms.Label
        Me.RefreshButton = New System.Windows.Forms.Button
        Me.QSIServiceController = New System.ServiceProcess.ServiceController
        Me.VoviciServiceButton = New System.Windows.Forms.Button
        Me.QSIVoviciServiceLabel = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.VendorFileServiceButton = New System.Windows.Forms.Button
        Me.QSIVendorFileServiceLabel = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.PhoneCancelFileMoverServiceButton = New System.Windows.Forms.Button
        Me.QSIPhoneCancelFileMoverServiceStatusLabel = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'TransferResultsServiceButton
        '
        Me.TransferResultsServiceButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TransferResultsServiceButton.Location = New System.Drawing.Point(13, 13)
        Me.TransferResultsServiceButton.Name = "TransferResultsServiceButton"
        Me.TransferResultsServiceButton.Size = New System.Drawing.Size(263, 23)
        Me.TransferResultsServiceButton.TabIndex = 0
        Me.TransferResultsServiceButton.Text = "Transfer Results Service"
        Me.TransferResultsServiceButton.UseVisualStyleBackColor = True
        '
        'FileMoverServiceButton
        '
        Me.FileMoverServiceButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileMoverServiceButton.Location = New System.Drawing.Point(13, 42)
        Me.FileMoverServiceButton.Name = "FileMoverServiceButton"
        Me.FileMoverServiceButton.Size = New System.Drawing.Size(263, 23)
        Me.FileMoverServiceButton.TabIndex = 1
        Me.FileMoverServiceButton.Text = "File Mover Service"
        Me.FileMoverServiceButton.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(15, 166)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(119, 13)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "QSI File Mover Service:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(15, 197)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(147, 13)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "QSI Transfer Results Service:"
        '
        'QSIFileMoverServiceStatusLabel
        '
        Me.QSIFileMoverServiceStatusLabel.AutoSize = True
        Me.QSIFileMoverServiceStatusLabel.Location = New System.Drawing.Point(224, 166)
        Me.QSIFileMoverServiceStatusLabel.Name = "QSIFileMoverServiceStatusLabel"
        Me.QSIFileMoverServiceStatusLabel.Size = New System.Drawing.Size(47, 13)
        Me.QSIFileMoverServiceStatusLabel.TabIndex = 5
        Me.QSIFileMoverServiceStatusLabel.Text = "Running"
        '
        'QSITransferResultsServiceStatusLabel
        '
        Me.QSITransferResultsServiceStatusLabel.AutoSize = True
        Me.QSITransferResultsServiceStatusLabel.Location = New System.Drawing.Point(224, 197)
        Me.QSITransferResultsServiceStatusLabel.Name = "QSITransferResultsServiceStatusLabel"
        Me.QSITransferResultsServiceStatusLabel.Size = New System.Drawing.Size(43, 13)
        Me.QSITransferResultsServiceStatusLabel.TabIndex = 6
        Me.QSITransferResultsServiceStatusLabel.Text = "Paused"
        '
        'RefreshButton
        '
        Me.RefreshButton.Location = New System.Drawing.Point(171, 311)
        Me.RefreshButton.Name = "RefreshButton"
        Me.RefreshButton.Size = New System.Drawing.Size(91, 23)
        Me.RefreshButton.TabIndex = 8
        Me.RefreshButton.Text = "Refresh Status"
        Me.RefreshButton.UseVisualStyleBackColor = True
        '
        'VoviciServiceButton
        '
        Me.VoviciServiceButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VoviciServiceButton.Location = New System.Drawing.Point(12, 71)
        Me.VoviciServiceButton.Name = "VoviciServiceButton"
        Me.VoviciServiceButton.Size = New System.Drawing.Size(263, 23)
        Me.VoviciServiceButton.TabIndex = 11
        Me.VoviciServiceButton.Text = "Vovici Service"
        Me.VoviciServiceButton.UseVisualStyleBackColor = True
        '
        'QSIVoviciServiceLabel
        '
        Me.QSIVoviciServiceLabel.AutoSize = True
        Me.QSIVoviciServiceLabel.Location = New System.Drawing.Point(224, 227)
        Me.QSIVoviciServiceLabel.Name = "QSIVoviciServiceLabel"
        Me.QSIVoviciServiceLabel.Size = New System.Drawing.Size(33, 13)
        Me.QSIVoviciServiceLabel.TabIndex = 13
        Me.QSIVoviciServiceLabel.Text = "Dead"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(15, 227)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(99, 13)
        Me.Label5.TabIndex = 12
        Me.Label5.Text = "QSI Vovici Service:"
        '
        'VendorFileServiceButton
        '
        Me.VendorFileServiceButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileServiceButton.Location = New System.Drawing.Point(12, 100)
        Me.VendorFileServiceButton.Name = "VendorFileServiceButton"
        Me.VendorFileServiceButton.Size = New System.Drawing.Size(263, 23)
        Me.VendorFileServiceButton.TabIndex = 14
        Me.VendorFileServiceButton.Text = "Vendor File Service"
        Me.VendorFileServiceButton.UseVisualStyleBackColor = True
        '
        'QSIVendorFileServiceLabel
        '
        Me.QSIVendorFileServiceLabel.AutoSize = True
        Me.QSIVendorFileServiceLabel.Location = New System.Drawing.Point(224, 256)
        Me.QSIVendorFileServiceLabel.Name = "QSIVendorFileServiceLabel"
        Me.QSIVendorFileServiceLabel.Size = New System.Drawing.Size(33, 13)
        Me.QSIVendorFileServiceLabel.TabIndex = 16
        Me.QSIVendorFileServiceLabel.Text = "Dead"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(15, 255)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(123, 13)
        Me.Label4.TabIndex = 15
        Me.Label4.Text = "QSI Vendor File Service:"
        '
        'PhoneCancelFileMoverServiceButton
        '
        Me.PhoneCancelFileMoverServiceButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PhoneCancelFileMoverServiceButton.Location = New System.Drawing.Point(13, 129)
        Me.PhoneCancelFileMoverServiceButton.Name = "PhoneCancelFileMoverServiceButton"
        Me.PhoneCancelFileMoverServiceButton.Size = New System.Drawing.Size(263, 23)
        Me.PhoneCancelFileMoverServiceButton.TabIndex = 17
        Me.PhoneCancelFileMoverServiceButton.Text = "Phone Cancel File Mover Service"
        Me.PhoneCancelFileMoverServiceButton.UseVisualStyleBackColor = True
        '
        'QSIPhoneCancelFileMoverServiceStatusLabel
        '
        Me.QSIPhoneCancelFileMoverServiceStatusLabel.AutoSize = True
        Me.QSIPhoneCancelFileMoverServiceStatusLabel.Location = New System.Drawing.Point(224, 285)
        Me.QSIPhoneCancelFileMoverServiceStatusLabel.Name = "QSIPhoneCancelFileMoverServiceStatusLabel"
        Me.QSIPhoneCancelFileMoverServiceStatusLabel.Size = New System.Drawing.Size(47, 13)
        Me.QSIPhoneCancelFileMoverServiceStatusLabel.TabIndex = 19
        Me.QSIPhoneCancelFileMoverServiceStatusLabel.Text = "Running"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(15, 285)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(190, 13)
        Me.Label6.TabIndex = 18
        Me.Label6.Text = "QSI Phone Vendor File Mover Service:"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(288, 336)
        Me.Controls.Add(Me.QSIPhoneCancelFileMoverServiceStatusLabel)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.PhoneCancelFileMoverServiceButton)
        Me.Controls.Add(Me.QSIVendorFileServiceLabel)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.VendorFileServiceButton)
        Me.Controls.Add(Me.QSIVoviciServiceLabel)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.VoviciServiceButton)
        Me.Controls.Add(Me.RefreshButton)
        Me.Controls.Add(Me.QSITransferResultsServiceStatusLabel)
        Me.Controls.Add(Me.QSIFileMoverServiceStatusLabel)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.FileMoverServiceButton)
        Me.Controls.Add(Me.TransferResultsServiceButton)
        Me.Name = "MainForm"
        Me.Text = "QSI Services Tester"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TransferResultsServiceButton As System.Windows.Forms.Button
    Friend WithEvents FileMoverServiceButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents QSIFileMoverServiceStatusLabel As System.Windows.Forms.Label
    Friend WithEvents QSITransferResultsServiceStatusLabel As System.Windows.Forms.Label
    Friend WithEvents RefreshButton As System.Windows.Forms.Button
    Friend WithEvents QSIServiceController As System.ServiceProcess.ServiceController
    Friend WithEvents VoviciServiceButton As System.Windows.Forms.Button
    Friend WithEvents QSIVoviciServiceLabel As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents VendorFileServiceButton As System.Windows.Forms.Button
    Friend WithEvents QSIVendorFileServiceLabel As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents PhoneCancelFileMoverServiceButton As System.Windows.Forms.Button
    Friend WithEvents QSIPhoneCancelFileMoverServiceStatusLabel As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label

End Class
