<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportIndividualFilesErrorDialog
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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ExportIndividualFilesErrorDialog))
        Me.ErrorMessageLabel = New System.Windows.Forms.Label
        Me.OKButton = New System.Windows.Forms.Button
        Me.CreateFileButton = New System.Windows.Forms.Button
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.Error_Message_Textbox = New System.Windows.Forms.TextBox
        Me.Error_Message_Label = New System.Windows.Forms.Label
        Me.IDsArentUnique_Label = New System.Windows.Forms.Label
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Error Exporting to Files"
        Me.mPaneCaption.Size = New System.Drawing.Size(702, 26)
        Me.mPaneCaption.Text = "Error Exporting to Files"
        '
        'ErrorMessageLabel
        '
        Me.ErrorMessageLabel.AutoSize = True
        Me.ErrorMessageLabel.Location = New System.Drawing.Point(217, 62)
        Me.ErrorMessageLabel.Name = "ErrorMessageLabel"
        Me.ErrorMessageLabel.Size = New System.Drawing.Size(0, 13)
        Me.ErrorMessageLabel.TabIndex = 1
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(594, 169)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(91, 30)
        Me.OKButton.TabIndex = 3
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CreateFileButton
        '
        Me.CreateFileButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CreateFileButton.DialogResult = System.Windows.Forms.DialogResult.Yes
        Me.CreateFileButton.Location = New System.Drawing.Point(497, 169)
        Me.CreateFileButton.Name = "CreateFileButton"
        Me.CreateFileButton.Size = New System.Drawing.Size(91, 30)
        Me.CreateFileButton.TabIndex = 4
        Me.CreateFileButton.Text = "Override"
        Me.CreateFileButton.UseVisualStyleBackColor = True
        Me.CreateFileButton.Visible = False
        '
        'ImageList1
        '
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.White
        Me.ImageList1.Images.SetKeyName(0, "error.bmp")
        '
        'PictureBox1
        '
        Me.PictureBox1.ErrorImage = Nothing
        Me.PictureBox1.InitialImage = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.error1
        Me.PictureBox1.Location = New System.Drawing.Point(15, 47)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(50, 50)
        Me.PictureBox1.TabIndex = 2
        Me.PictureBox1.TabStop = False
        '
        'Error_Message_Textbox
        '
        Me.Error_Message_Textbox.BackColor = System.Drawing.SystemColors.Control
        Me.Error_Message_Textbox.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.Error_Message_Textbox.Location = New System.Drawing.Point(83, 47)
        Me.Error_Message_Textbox.Multiline = True
        Me.Error_Message_Textbox.Name = "Error_Message_Textbox"
        Me.Error_Message_Textbox.ReadOnly = True
        Me.Error_Message_Textbox.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.Error_Message_Textbox.Size = New System.Drawing.Size(602, 71)
        Me.Error_Message_Textbox.TabIndex = 5
        '
        'Error_Message_Label
        '
        Me.Error_Message_Label.AutoSize = True
        Me.Error_Message_Label.Location = New System.Drawing.Point(80, 133)
        Me.Error_Message_Label.Name = "Error_Message_Label"
        Me.Error_Message_Label.Size = New System.Drawing.Size(110, 13)
        Me.Error_Message_Label.TabIndex = 6
        Me.Error_Message_Label.Text = "Error_Message_Label"
        '
        'IDsArentUnique_Label
        '
        Me.IDsArentUnique_Label.AutoSize = True
        Me.IDsArentUnique_Label.Location = New System.Drawing.Point(147, 178)
        Me.IDsArentUnique_Label.Name = "IDsArentUnique_Label"
        Me.IDsArentUnique_Label.Size = New System.Drawing.Size(325, 13)
        Me.IDsArentUnique_Label.TabIndex = 7
        Me.IDsArentUnique_Label.Text = "Medicare Override is disabled under multiple file override conditions."
        Me.IDsArentUnique_Label.Visible = False
        '
        'ExportIndividualFilesErrorDialog
        '
        Me.Caption = "Error Exporting to File(s)"
        Me.ClientSize = New System.Drawing.Size(704, 211)
        Me.ControlBox = False
        Me.Controls.Add(Me.Error_Message_Textbox)
        Me.Controls.Add(Me.Error_Message_Label)
        Me.Controls.Add(Me.IDsArentUnique_Label)
        Me.Controls.Add(Me.ErrorMessageLabel)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.CreateFileButton)
        Me.Controls.Add(Me.OKButton)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "ExportIndividualFilesErrorDialog"
        Me.Controls.SetChildIndex(Me.OKButton, 0)
        Me.Controls.SetChildIndex(Me.CreateFileButton, 0)
        Me.Controls.SetChildIndex(Me.PictureBox1, 0)
        Me.Controls.SetChildIndex(Me.ErrorMessageLabel, 0)
        Me.Controls.SetChildIndex(Me.IDsArentUnique_Label, 0)
        Me.Controls.SetChildIndex(Me.Error_Message_Label, 0)
        Me.Controls.SetChildIndex(Me.Error_Message_Textbox, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ErrorMessageLabel As System.Windows.Forms.Label
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CreateFileButton As System.Windows.Forms.Button
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents Error_Message_Textbox As System.Windows.Forms.TextBox
    Friend WithEvents Error_Message_Label As System.Windows.Forms.Label
    Friend WithEvents IDsArentUnique_Label As System.Windows.Forms.Label

End Class
