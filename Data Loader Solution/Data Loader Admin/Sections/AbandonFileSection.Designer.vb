<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AbandonFileSection
    Inherits DataLoaderAdmin.Section

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
        Me.lblUploadFileID = New System.Windows.Forms.Label
        Me.btnAbandon = New System.Windows.Forms.Button
        Me.lblMessage = New System.Windows.Forms.Label
        Me.txtUploadFileID = New DevExpress.XtraEditors.TextEdit
        Me.pnlMessage = New System.Windows.Forms.Panel
        Me.pnlAbandon = New System.Windows.Forms.Panel
        Me.btnRestore = New System.Windows.Forms.Button
        Me.pbStatus = New System.Windows.Forms.PictureBox
        CType(Me.txtUploadFileID.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlMessage.SuspendLayout()
        Me.pnlAbandon.SuspendLayout()
        CType(Me.pbStatus, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblUploadFileID
        '
        Me.lblUploadFileID.AutoSize = True
        Me.lblUploadFileID.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(204, Byte))
        Me.lblUploadFileID.Location = New System.Drawing.Point(32, 44)
        Me.lblUploadFileID.Name = "lblUploadFileID"
        Me.lblUploadFileID.Size = New System.Drawing.Size(163, 13)
        Me.lblUploadFileID.TabIndex = 4
        Me.lblUploadFileID.Text = "Please enter UploadFile_id "
        '
        'btnAbandon
        '
        Me.btnAbandon.Location = New System.Drawing.Point(199, 82)
        Me.btnAbandon.Name = "btnAbandon"
        Me.btnAbandon.Size = New System.Drawing.Size(75, 23)
        Me.btnAbandon.TabIndex = 1
        Me.btnAbandon.Text = "Abandon"
        Me.btnAbandon.UseVisualStyleBackColor = True
        '
        'lblMessage
        '
        Me.lblMessage.AutoSize = True
        Me.lblMessage.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(204, Byte))
        Me.lblMessage.Location = New System.Drawing.Point(54, 0)
        Me.lblMessage.Name = "lblMessage"
        Me.lblMessage.Size = New System.Drawing.Size(116, 13)
        Me.lblMessage.TabIndex = 3
        Me.lblMessage.Text = "Feedback message"
        Me.lblMessage.Visible = False
        '
        'txtUploadFileID
        '
        Me.txtUploadFileID.Location = New System.Drawing.Point(199, 41)
        Me.txtUploadFileID.Name = "txtUploadFileID"
        Me.txtUploadFileID.Properties.Mask.EditMask = "d"
        Me.txtUploadFileID.Properties.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric
        Me.txtUploadFileID.Size = New System.Drawing.Size(165, 20)
        Me.txtUploadFileID.TabIndex = 0
        '
        'pnlMessage
        '
        Me.pnlMessage.AutoSize = True
        Me.pnlMessage.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.pnlMessage.Controls.Add(Me.lblMessage)
        Me.pnlMessage.Controls.Add(Me.pbStatus)
        Me.pnlMessage.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlMessage.Location = New System.Drawing.Point(0, 113)
        Me.pnlMessage.Name = "pnlMessage"
        Me.pnlMessage.Size = New System.Drawing.Size(901, 21)
        Me.pnlMessage.TabIndex = 6
        '
        'pnlAbandon
        '
        Me.pnlAbandon.Controls.Add(Me.lblUploadFileID)
        Me.pnlAbandon.Controls.Add(Me.pnlMessage)
        Me.pnlAbandon.Controls.Add(Me.btnRestore)
        Me.pnlAbandon.Controls.Add(Me.btnAbandon)
        Me.pnlAbandon.Controls.Add(Me.txtUploadFileID)
        Me.pnlAbandon.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlAbandon.Location = New System.Drawing.Point(0, 0)
        Me.pnlAbandon.Name = "pnlAbandon"
        Me.pnlAbandon.Size = New System.Drawing.Size(901, 134)
        Me.pnlAbandon.TabIndex = 7
        '
        'btnRestore
        '
        Me.btnRestore.Location = New System.Drawing.Point(289, 82)
        Me.btnRestore.Name = "btnRestore"
        Me.btnRestore.Size = New System.Drawing.Size(75, 23)
        Me.btnRestore.TabIndex = 1
        Me.btnRestore.Text = "Restore"
        Me.btnRestore.UseVisualStyleBackColor = True
        '
        'pbStatus
        '
        Me.pbStatus.Image = Global.Nrc.DataLoaderAdmin.My.Resources.Resources.Greenlight
        Me.pbStatus.Location = New System.Drawing.Point(32, -2)
        Me.pbStatus.Name = "pbStatus"
        Me.pbStatus.Size = New System.Drawing.Size(16, 16)
        Me.pbStatus.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.pbStatus.TabIndex = 5
        Me.pbStatus.TabStop = False
        Me.pbStatus.Visible = False
        '
        'AbandonFileSection
        '
        Me.Controls.Add(Me.pnlAbandon)
        Me.Name = "AbandonFileSection"
        Me.Size = New System.Drawing.Size(901, 665)
        CType(Me.txtUploadFileID.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlMessage.ResumeLayout(False)
        Me.pnlMessage.PerformLayout()
        Me.pnlAbandon.ResumeLayout(False)
        Me.pnlAbandon.PerformLayout()
        CType(Me.pbStatus, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents lblUploadFileID As System.Windows.Forms.Label
    Friend WithEvents btnAbandon As System.Windows.Forms.Button
    Friend WithEvents lblMessage As System.Windows.Forms.Label
    Friend WithEvents txtUploadFileID As DevExpress.XtraEditors.TextEdit
    Friend WithEvents pbStatus As System.Windows.Forms.PictureBox
    Friend WithEvents pnlMessage As System.Windows.Forms.Panel
    Friend WithEvents pnlAbandon As System.Windows.Forms.Panel
    Friend WithEvents btnRestore As System.Windows.Forms.Button

End Class
