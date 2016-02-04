<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SplitFileSection
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
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.txtDescription = New System.Windows.Forms.RichTextBox
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtFile = New System.Windows.Forms.TextBox
        Me.txtDestination = New System.Windows.Forms.TextBox
        Me.cmdSplit = New System.Windows.Forms.Button
        Me.cmdOpen = New System.Windows.Forms.Button
        Me.cmdDestination = New System.Windows.Forms.Button
        Me.cboCoventryFile = New System.Windows.Forms.ComboBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
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
        Me.SectionPanel1.Caption = "Coventry Split File"
        Me.SectionPanel1.Controls.Add(Me.GroupBox2)
        Me.SectionPanel1.Controls.Add(Me.GroupBox1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(742, 555)
        Me.SectionPanel1.TabIndex = 0
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.txtDescription)
        Me.GroupBox2.Location = New System.Drawing.Point(21, 166)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(649, 360)
        Me.GroupBox2.TabIndex = 3
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Description"
        '
        'txtDescription
        '
        Me.txtDescription.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtDescription.Location = New System.Drawing.Point(20, 19)
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ReadOnly = True
        Me.txtDescription.Size = New System.Drawing.Size(619, 324)
        Me.txtDescription.TabIndex = 0
        Me.txtDescription.Text = ""
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.txtFile)
        Me.GroupBox1.Controls.Add(Me.txtDestination)
        Me.GroupBox1.Controls.Add(Me.cmdSplit)
        Me.GroupBox1.Controls.Add(Me.cmdOpen)
        Me.GroupBox1.Controls.Add(Me.cmdDestination)
        Me.GroupBox1.Controls.Add(Me.cboCoventryFile)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(21, 38)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(649, 122)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        '
        'txtFile
        '
        Me.txtFile.Location = New System.Drawing.Point(108, 55)
        Me.txtFile.Name = "txtFile"
        Me.txtFile.Size = New System.Drawing.Size(408, 20)
        Me.txtFile.TabIndex = 2
        '
        'txtDestination
        '
        Me.txtDestination.Location = New System.Drawing.Point(108, 82)
        Me.txtDestination.Name = "txtDestination"
        Me.txtDestination.Size = New System.Drawing.Size(408, 20)
        Me.txtDestination.TabIndex = 3
        '
        'cmdSplit
        '
        Me.cmdSplit.Location = New System.Drawing.Point(556, 55)
        Me.cmdSplit.Name = "cmdSplit"
        Me.cmdSplit.Size = New System.Drawing.Size(75, 23)
        Me.cmdSplit.TabIndex = 6
        Me.cmdSplit.Text = "Split Files"
        Me.cmdSplit.UseVisualStyleBackColor = True
        '
        'cmdOpen
        '
        Me.cmdOpen.Location = New System.Drawing.Point(522, 55)
        Me.cmdOpen.Name = "cmdOpen"
        Me.cmdOpen.Size = New System.Drawing.Size(28, 23)
        Me.cmdOpen.TabIndex = 4
        Me.cmdOpen.Text = "..."
        Me.cmdOpen.UseVisualStyleBackColor = True
        '
        'cmdDestination
        '
        Me.cmdDestination.Location = New System.Drawing.Point(522, 82)
        Me.cmdDestination.Name = "cmdDestination"
        Me.cmdDestination.Size = New System.Drawing.Size(28, 23)
        Me.cmdDestination.TabIndex = 5
        Me.cmdDestination.Text = "..."
        Me.cmdDestination.UseVisualStyleBackColor = True
        '
        'cboCoventryFile
        '
        Me.cboCoventryFile.FormattingEnabled = True
        Me.cboCoventryFile.Location = New System.Drawing.Point(108, 23)
        Me.cboCoventryFile.Name = "cboCoventryFile"
        Me.cboCoventryFile.Size = New System.Drawing.Size(523, 21)
        Me.cboCoventryFile.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(17, 26)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(71, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Coventry File:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(17, 58)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(63, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Source File:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(17, 85)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(79, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Destination Dir:"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'SplitFileSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "SplitFileSection"
        Me.Size = New System.Drawing.Size(742, 555)
        Me.SectionPanel1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents cboCoventryFile As System.Windows.Forms.ComboBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtFile As System.Windows.Forms.TextBox
    Friend WithEvents txtDestination As System.Windows.Forms.TextBox
    Friend WithEvents cmdSplit As System.Windows.Forms.Button
    Friend WithEvents cmdOpen As System.Windows.Forms.Button
    Friend WithEvents cmdDestination As System.Windows.Forms.Button
    Friend WithEvents FolderBrowserDialog1 As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents txtDescription As System.Windows.Forms.RichTextBox

End Class
