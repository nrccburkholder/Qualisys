Imports System.Configuration

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class WebFileConvertSection
    Inherits Section

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
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtResults = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.cmdConvert = New System.Windows.Forms.Button
        Me.cmdConvertFile = New System.Windows.Forms.Button
        Me.cmdOriginalFile = New System.Windows.Forms.Button
        Me.txtOriginalFile = New System.Windows.Forms.TextBox
        Me.txtConvertFile = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.cboFileType = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.HeaderStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(587, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(148, 22)
        Me.ToolStripLabel1.Text = "Web File Convert"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.txtResults)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.cmdConvert)
        Me.GroupBox1.Controls.Add(Me.cmdConvertFile)
        Me.GroupBox1.Controls.Add(Me.cmdOriginalFile)
        Me.GroupBox1.Controls.Add(Me.txtOriginalFile)
        Me.GroupBox1.Controls.Add(Me.txtConvertFile)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.cboFileType)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(3, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(581, 459)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        '
        'txtResults
        '
        Me.txtResults.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtResults.Location = New System.Drawing.Point(9, 116)
        Me.txtResults.Multiline = True
        Me.txtResults.Name = "txtResults"
        Me.txtResults.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtResults.Size = New System.Drawing.Size(565, 296)
        Me.txtResults.TabIndex = 10
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(7, 92)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(45, 13)
        Me.Label4.TabIndex = 9
        Me.Label4.Text = "Results:"
        '
        'cmdConvert
        '
        Me.cmdConvert.Location = New System.Drawing.Point(500, 87)
        Me.cmdConvert.Name = "cmdConvert"
        Me.cmdConvert.Size = New System.Drawing.Size(75, 23)
        Me.cmdConvert.TabIndex = 8
        Me.cmdConvert.Text = "Convert"
        Me.cmdConvert.UseVisualStyleBackColor = True
        '
        'cmdConvertFile
        '
        Me.cmdConvertFile.Location = New System.Drawing.Point(546, 58)
        Me.cmdConvertFile.Name = "cmdConvertFile"
        Me.cmdConvertFile.Size = New System.Drawing.Size(29, 23)
        Me.cmdConvertFile.TabIndex = 7
        Me.cmdConvertFile.Text = "..."
        Me.cmdConvertFile.UseVisualStyleBackColor = True
        '
        'cmdOriginalFile
        '
        Me.cmdOriginalFile.Location = New System.Drawing.Point(546, 35)
        Me.cmdOriginalFile.Name = "cmdOriginalFile"
        Me.cmdOriginalFile.Size = New System.Drawing.Size(29, 23)
        Me.cmdOriginalFile.TabIndex = 6
        Me.cmdOriginalFile.Text = "..."
        Me.cmdOriginalFile.UseVisualStyleBackColor = True
        '
        'txtOriginalFile
        '
        Me.txtOriginalFile.Location = New System.Drawing.Point(79, 37)
        Me.txtOriginalFile.Name = "txtOriginalFile"
        Me.txtOriginalFile.Size = New System.Drawing.Size(463, 20)
        Me.txtOriginalFile.TabIndex = 4
        '
        'txtConvertFile
        '
        Me.txtConvertFile.Location = New System.Drawing.Point(79, 60)
        Me.txtConvertFile.Name = "txtConvertFile"
        Me.txtConvertFile.Size = New System.Drawing.Size(463, 20)
        Me.txtConvertFile.TabIndex = 5
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(7, 60)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(63, 13)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Convert To:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 37)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(64, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Original File:"
        '
        'cboFileType
        '
        Me.cboFileType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFileType.FormattingEnabled = True
        Dim FileType() As String = ConfigurationManager.AppSettings("FileType").Split(",")
        Me.cboFileType.Items.AddRange(FileType)
        Me.cboFileType.Location = New System.Drawing.Point(79, 13)
        Me.cboFileType.Name = "cboFileType"
        Me.cboFileType.Size = New System.Drawing.Size(496, 21)
        Me.cboFileType.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 16)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(53, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "File Type:"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        Me.OpenFileDialog1.Filter = "Text Files|*.txt|CSV files|*.csv"
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "String Files|*.STR"
        '
        'WebFileConvertSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "WebFileConvertSection"
        Me.Size = New System.Drawing.Size(587, 521)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cboFileType As System.Windows.Forms.ComboBox
    Friend WithEvents cmdConvert As System.Windows.Forms.Button
    Friend WithEvents cmdConvertFile As System.Windows.Forms.Button
    Friend WithEvents cmdOriginalFile As System.Windows.Forms.Button
    Friend WithEvents txtOriginalFile As System.Windows.Forms.TextBox
    Friend WithEvents txtConvertFile As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents txtResults As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label

End Class
