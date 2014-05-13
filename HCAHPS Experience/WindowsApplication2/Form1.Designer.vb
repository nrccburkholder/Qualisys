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
        Me.RenameSplitPDFs = New System.Windows.Forms.Button
        Me.SendAllEmailsTest = New System.Windows.Forms.Button
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel
        Me.AddAttachmentInfo = New System.Windows.Forms.Button
        Me.SendAllEmailsProd = New System.Windows.Forms.Button
        Me.CheckBox1 = New System.Windows.Forms.CheckBox
        Me.FolderBrowserDialog1 = New System.Windows.Forms.FolderBrowserDialog
        Me.pdfLocation = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Button1 = New System.Windows.Forms.Button
        Me.excelFile = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Button2 = New System.Windows.Forms.Button
        Me.EMailBody = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.Label4 = New System.Windows.Forms.Label
        Me.sourceFile = New System.Windows.Forms.TextBox
        Me.Button3 = New System.Windows.Forms.Button
        Me.StatusStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'RenameSplitPDFs
        '
        Me.RenameSplitPDFs.Location = New System.Drawing.Point(483, 52)
        Me.RenameSplitPDFs.Name = "RenameSplitPDFs"
        Me.RenameSplitPDFs.Size = New System.Drawing.Size(209, 29)
        Me.RenameSplitPDFs.TabIndex = 0
        Me.RenameSplitPDFs.Text = "1. Split into PDFs"
        Me.RenameSplitPDFs.UseVisualStyleBackColor = True
        '
        'SendAllEmailsTest
        '
        Me.SendAllEmailsTest.Location = New System.Drawing.Point(483, 128)
        Me.SendAllEmailsTest.Name = "SendAllEmailsTest"
        Me.SendAllEmailsTest.Size = New System.Drawing.Size(209, 32)
        Me.SendAllEmailsTest.TabIndex = 3
        Me.SendAllEmailsTest.Text = "3. Send All Emails (Test)"
        Me.SendAllEmailsTest.UseVisualStyleBackColor = True
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 379)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(705, 22)
        Me.StatusStrip1.SizingGrip = False
        Me.StatusStrip1.Stretch = False
        Me.StatusStrip1.TabIndex = 5
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'AddAttachmentInfo
        '
        Me.AddAttachmentInfo.Location = New System.Drawing.Point(483, 87)
        Me.AddAttachmentInfo.Name = "AddAttachmentInfo"
        Me.AddAttachmentInfo.Size = New System.Drawing.Size(209, 35)
        Me.AddAttachmentInfo.TabIndex = 6
        Me.AddAttachmentInfo.Text = "2. Add Attachment Info"
        Me.AddAttachmentInfo.UseVisualStyleBackColor = True
        '
        'SendAllEmailsProd
        '
        Me.SendAllEmailsProd.Enabled = False
        Me.SendAllEmailsProd.Location = New System.Drawing.Point(483, 169)
        Me.SendAllEmailsProd.Name = "SendAllEmailsProd"
        Me.SendAllEmailsProd.Size = New System.Drawing.Size(209, 32)
        Me.SendAllEmailsProd.TabIndex = 7
        Me.SendAllEmailsProd.Text = "4. Send All Emails (Prod)"
        Me.SendAllEmailsProd.UseVisualStyleBackColor = True
        '
        'CheckBox1
        '
        Me.CheckBox1.AutoSize = True
        Me.CheckBox1.Location = New System.Drawing.Point(483, 207)
        Me.CheckBox1.Name = "CheckBox1"
        Me.CheckBox1.Size = New System.Drawing.Size(113, 17)
        Me.CheckBox1.TabIndex = 8
        Me.CheckBox1.Text = "Enable Production"
        Me.CheckBox1.UseVisualStyleBackColor = True
        '
        'pdfLocation
        '
        Me.pdfLocation.Location = New System.Drawing.Point(19, 95)
        Me.pdfLocation.Name = "pdfLocation"
        Me.pdfLocation.Size = New System.Drawing.Size(337, 20)
        Me.pdfLocation.TabIndex = 9
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(20, 76)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(111, 13)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "Location of PDF Files:"
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(362, 92)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(75, 23)
        Me.Button1.TabIndex = 11
        Me.Button1.Text = "Browse..."
        Me.Button1.UseVisualStyleBackColor = True
        '
        'excelFile
        '
        Me.excelFile.Location = New System.Drawing.Point(19, 136)
        Me.excelFile.Name = "excelFile"
        Me.excelFile.Size = New System.Drawing.Size(337, 20)
        Me.excelFile.TabIndex = 9
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(20, 120)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(55, 13)
        Me.Label2.TabIndex = 10
        Me.Label2.Text = "Excel File:"
        '
        'Button2
        '
        Me.Button2.Location = New System.Drawing.Point(362, 133)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(75, 23)
        Me.Button2.TabIndex = 11
        Me.Button2.Text = "Browse..."
        Me.Button2.UseVisualStyleBackColor = True
        '
        'EMailBody
        '
        Me.EMailBody.AcceptsReturn = True
        Me.EMailBody.Location = New System.Drawing.Point(19, 179)
        Me.EMailBody.Multiline = True
        Me.EMailBody.Name = "EMailBody"
        Me.EMailBody.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.EMailBody.Size = New System.Drawing.Size(418, 172)
        Me.EMailBody.TabIndex = 9
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(20, 163)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(66, 13)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "E-Mail Body:"
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.Button3)
        Me.GroupBox1.Controls.Add(Me.sourceFile)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 17)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(433, 344)
        Me.GroupBox1.TabIndex = 12
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Configuration"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(8, 19)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(68, 13)
        Me.Label4.TabIndex = 0
        Me.Label4.Text = "Source PDF:"
        '
        'sourceFile
        '
        Me.sourceFile.Location = New System.Drawing.Point(7, 35)
        Me.sourceFile.Name = "sourceFile"
        Me.sourceFile.Size = New System.Drawing.Size(337, 20)
        Me.sourceFile.TabIndex = 1
        '
        'Button3
        '
        Me.Button3.Location = New System.Drawing.Point(350, 31)
        Me.Button3.Name = "Button3"
        Me.Button3.Size = New System.Drawing.Size(75, 23)
        Me.Button3.TabIndex = 2
        Me.Button3.Text = "Browse..."
        Me.Button3.UseVisualStyleBackColor = True
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.ClientSize = New System.Drawing.Size(705, 401)
        Me.Controls.Add(Me.Button2)
        Me.Controls.Add(Me.Button1)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.EMailBody)
        Me.Controls.Add(Me.excelFile)
        Me.Controls.Add(Me.pdfLocation)
        Me.Controls.Add(Me.CheckBox1)
        Me.Controls.Add(Me.SendAllEmailsProd)
        Me.Controls.Add(Me.AddAttachmentInfo)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.SendAllEmailsTest)
        Me.Controls.Add(Me.RenameSplitPDFs)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MainForm"
        Me.Text = "HCAHPS One-Off Application"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents RenameSplitPDFs As System.Windows.Forms.Button
    Friend WithEvents SendAllEmailsTest As System.Windows.Forms.Button
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents AddAttachmentInfo As System.Windows.Forms.Button
    Friend WithEvents SendAllEmailsProd As System.Windows.Forms.Button
    Friend WithEvents CheckBox1 As System.Windows.Forms.CheckBox
    Friend WithEvents FolderBrowserDialog1 As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents pdfLocation As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents excelFile As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Button2 As System.Windows.Forms.Button
    Friend WithEvents EMailBody As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents Button3 As System.Windows.Forms.Button
    Friend WithEvents sourceFile As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label

End Class
