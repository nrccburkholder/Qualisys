<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmWait
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmWait))
        Me.pbWaitImage = New System.Windows.Forms.PictureBox()
        Me.lblWaitMessage = New System.Windows.Forms.Label()
        CType(Me.pbWaitImage, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pbWaitImage
        '
        Me.pbWaitImage.Image = CType(resources.GetObject("pbWaitImage.Image"), System.Drawing.Image)
        Me.pbWaitImage.Location = New System.Drawing.Point(16, 32)
        Me.pbWaitImage.Margin = New System.Windows.Forms.Padding(4, 4, 4, 4)
        Me.pbWaitImage.Name = "pbWaitImage"
        Me.pbWaitImage.Size = New System.Drawing.Size(43, 38)
        Me.pbWaitImage.TabIndex = 0
        Me.pbWaitImage.TabStop = False
        '
        'lblWaitMessage
        '
        Me.lblWaitMessage.AutoSize = True
        Me.lblWaitMessage.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblWaitMessage.Location = New System.Drawing.Point(80, 46)
        Me.lblWaitMessage.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblWaitMessage.Name = "lblWaitMessage"
        Me.lblWaitMessage.Size = New System.Drawing.Size(131, 25)
        Me.lblWaitMessage.TabIndex = 1
        Me.lblWaitMessage.Text = "Please wait...."
        '
        'frmWait
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(268, 100)
        Me.Controls.Add(Me.lblWaitMessage)
        Me.Controls.Add(Me.pbWaitImage)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Margin = New System.Windows.Forms.Padding(4, 4, 4, 4)
        Me.Name = "frmWait"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "SvcMgr"
        CType(Me.pbWaitImage, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents pbWaitImage As System.Windows.Forms.PictureBox
    Friend WithEvents lblWaitMessage As System.Windows.Forms.Label
End Class
