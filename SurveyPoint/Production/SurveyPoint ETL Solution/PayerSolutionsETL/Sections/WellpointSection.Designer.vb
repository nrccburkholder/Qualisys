<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class WellpointSection
    Inherits PayerSolutionsETL.Section

    'UserControl overrides dispose to clean up the component list.
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
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.txtDescription = New System.Windows.Forms.RichTextBox
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtClientID = New System.Windows.Forms.TextBox
        Me.dteSurveyInstanceStartDate = New System.Windows.Forms.DateTimePicker
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.cmdRemoveDups = New System.Windows.Forms.Button
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtDestinationFolder = New System.Windows.Forms.TextBox
        Me.txtSourceFile = New System.Windows.Forms.TextBox
        Me.cmdSplitFile = New System.Windows.Forms.Button
        Me.cmdSourceFile = New System.Windows.Forms.Button
        Me.cmdDestinationFolder = New System.Windows.Forms.Button
        Me.FolderBrowserDialog1 = New System.Windows.Forms.FolderBrowserDialog
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.SectionPanel1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Wellpoint File Split - Under Construction"
        Me.SectionPanel1.Controls.Add(Me.GroupBox3)
        Me.SectionPanel1.Controls.Add(Me.GroupBox2)
        Me.SectionPanel1.Controls.Add(Me.GroupBox1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(831, 615)
        Me.SectionPanel1.TabIndex = 0
        '
        'GroupBox3
        '
        Me.GroupBox3.Location = New System.Drawing.Point(4, 467)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(813, 129)
        Me.GroupBox3.TabIndex = 5
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Duplicate Records"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.txtDescription)
        Me.GroupBox2.Location = New System.Drawing.Point(4, 194)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(813, 258)
        Me.GroupBox2.TabIndex = 3
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Description"
        '
        'txtDescription
        '
        Me.txtDescription.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtDescription.Location = New System.Drawing.Point(13, 19)
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ReadOnly = True
        Me.txtDescription.Size = New System.Drawing.Size(786, 223)
        Me.txtDescription.TabIndex = 0
        Me.txtDescription.Text = ""
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.txtClientID)
        Me.GroupBox1.Controls.Add(Me.dteSurveyInstanceStartDate)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.cmdRemoveDups)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.txtDestinationFolder)
        Me.GroupBox1.Controls.Add(Me.txtSourceFile)
        Me.GroupBox1.Controls.Add(Me.cmdSplitFile)
        Me.GroupBox1.Controls.Add(Me.cmdSourceFile)
        Me.GroupBox1.Controls.Add(Me.cmdDestinationFolder)
        Me.GroupBox1.Location = New System.Drawing.Point(4, 31)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(813, 157)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        '
        'txtClientID
        '
        Me.txtClientID.Location = New System.Drawing.Point(151, 14)
        Me.txtClientID.Name = "txtClientID"
        Me.txtClientID.Size = New System.Drawing.Size(100, 20)
        Me.txtClientID.TabIndex = 13
        '
        'dteSurveyInstanceStartDate
        '
        Me.dteSurveyInstanceStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dteSurveyInstanceStartDate.Location = New System.Drawing.Point(151, 40)
        Me.dteSurveyInstanceStartDate.Name = "dteSurveyInstanceStartDate"
        Me.dteSurveyInstanceStartDate.Size = New System.Drawing.Size(200, 20)
        Me.dteSurveyInstanceStartDate.TabIndex = 12
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(10, 43)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(138, 13)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "Survey Instance Start Date:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(10, 17)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(50, 13)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "Client ID:"
        '
        'cmdRemoveDups
        '
        Me.cmdRemoveDups.Enabled = False
        Me.cmdRemoveDups.Location = New System.Drawing.Point(482, 119)
        Me.cmdRemoveDups.Name = "cmdRemoveDups"
        Me.cmdRemoveDups.Size = New System.Drawing.Size(112, 23)
        Me.cmdRemoveDups.TabIndex = 9
        Me.cmdRemoveDups.Text = "Remove Dups"
        Me.cmdRemoveDups.UseVisualStyleBackColor = True
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(10, 95)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(95, 13)
        Me.Label3.TabIndex = 8
        Me.Label3.Text = "Destination Folder:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(10, 69)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(63, 13)
        Me.Label2.TabIndex = 7
        Me.Label2.Text = "Source File:"
        '
        'txtDestinationFolder
        '
        Me.txtDestinationFolder.Location = New System.Drawing.Point(151, 90)
        Me.txtDestinationFolder.Name = "txtDestinationFolder"
        Me.txtDestinationFolder.Size = New System.Drawing.Size(526, 20)
        Me.txtDestinationFolder.TabIndex = 3
        '
        'txtSourceFile
        '
        Me.txtSourceFile.Location = New System.Drawing.Point(151, 66)
        Me.txtSourceFile.Name = "txtSourceFile"
        Me.txtSourceFile.Size = New System.Drawing.Size(526, 20)
        Me.txtSourceFile.TabIndex = 2
        '
        'cmdSplitFile
        '
        Me.cmdSplitFile.Enabled = False
        Me.cmdSplitFile.Location = New System.Drawing.Point(600, 119)
        Me.cmdSplitFile.Name = "cmdSplitFile"
        Me.cmdSplitFile.Size = New System.Drawing.Size(112, 23)
        Me.cmdSplitFile.TabIndex = 6
        Me.cmdSplitFile.Text = "Split File"
        Me.cmdSplitFile.UseVisualStyleBackColor = True
        '
        'cmdSourceFile
        '
        Me.cmdSourceFile.Location = New System.Drawing.Point(683, 64)
        Me.cmdSourceFile.Name = "cmdSourceFile"
        Me.cmdSourceFile.Size = New System.Drawing.Size(29, 23)
        Me.cmdSourceFile.TabIndex = 4
        Me.cmdSourceFile.Text = "..."
        Me.cmdSourceFile.UseVisualStyleBackColor = True
        '
        'cmdDestinationFolder
        '
        Me.cmdDestinationFolder.Location = New System.Drawing.Point(683, 90)
        Me.cmdDestinationFolder.Name = "cmdDestinationFolder"
        Me.cmdDestinationFolder.Size = New System.Drawing.Size(29, 23)
        Me.cmdDestinationFolder.TabIndex = 5
        Me.cmdDestinationFolder.Text = "..."
        Me.cmdDestinationFolder.UseVisualStyleBackColor = True
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'WellpointSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "WellpointSection"
        Me.Size = New System.Drawing.Size(831, 615)
        Me.SectionPanel1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents FolderBrowserDialog1 As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtDestinationFolder As System.Windows.Forms.TextBox
    Friend WithEvents txtSourceFile As System.Windows.Forms.TextBox
    Friend WithEvents cmdSplitFile As System.Windows.Forms.Button
    Friend WithEvents cmdSourceFile As System.Windows.Forms.Button
    Friend WithEvents cmdDestinationFolder As System.Windows.Forms.Button
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents txtDescription As System.Windows.Forms.RichTextBox
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents cmdRemoveDups As System.Windows.Forms.Button
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtClientID As System.Windows.Forms.TextBox
    Friend WithEvents dteSurveyInstanceStartDate As System.Windows.Forms.DateTimePicker

End Class
