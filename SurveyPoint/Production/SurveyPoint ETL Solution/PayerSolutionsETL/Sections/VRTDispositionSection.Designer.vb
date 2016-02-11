<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VRTDispositionSection
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
        Me.Label3 = New System.Windows.Forms.Label
        Me.txtResults = New System.Windows.Forms.TextBox
        Me.txtLogFilePath = New System.Windows.Forms.TextBox
        Me.txtDispositionPath = New System.Windows.Forms.TextBox
        Me.cmdLogFileOpen = New System.Windows.Forms.Button
        Me.cmdDispOpen = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.cmdImport = New System.Windows.Forms.Button
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
        Me.HeaderStrip1.Size = New System.Drawing.Size(704, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(146, 22)
        Me.ToolStripLabel1.Text = "VRT Dispositions"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.txtResults)
        Me.GroupBox1.Controls.Add(Me.txtLogFilePath)
        Me.GroupBox1.Controls.Add(Me.txtDispositionPath)
        Me.GroupBox1.Controls.Add(Me.cmdLogFileOpen)
        Me.GroupBox1.Controls.Add(Me.cmdDispOpen)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.cmdImport)
        Me.GroupBox1.Location = New System.Drawing.Point(3, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(698, 551)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(15, 87)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(42, 13)
        Me.Label3.TabIndex = 8
        Me.Label3.Text = "Results"
        '
        'txtResults
        '
        Me.txtResults.Location = New System.Drawing.Point(18, 103)
        Me.txtResults.Multiline = True
        Me.txtResults.Name = "txtResults"
        Me.txtResults.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtResults.Size = New System.Drawing.Size(674, 432)
        Me.txtResults.TabIndex = 7
        '
        'txtLogFilePath
        '
        Me.txtLogFilePath.Location = New System.Drawing.Point(101, 39)
        Me.txtLogFilePath.Name = "txtLogFilePath"
        Me.txtLogFilePath.Size = New System.Drawing.Size(556, 20)
        Me.txtLogFilePath.TabIndex = 6
        '
        'txtDispositionPath
        '
        Me.txtDispositionPath.Location = New System.Drawing.Point(101, 13)
        Me.txtDispositionPath.Name = "txtDispositionPath"
        Me.txtDispositionPath.Size = New System.Drawing.Size(556, 20)
        Me.txtDispositionPath.TabIndex = 5
        '
        'cmdLogFileOpen
        '
        Me.cmdLogFileOpen.Location = New System.Drawing.Point(663, 36)
        Me.cmdLogFileOpen.Name = "cmdLogFileOpen"
        Me.cmdLogFileOpen.Size = New System.Drawing.Size(29, 23)
        Me.cmdLogFileOpen.TabIndex = 4
        Me.cmdLogFileOpen.Text = "..."
        Me.cmdLogFileOpen.UseVisualStyleBackColor = True
        '
        'cmdDispOpen
        '
        Me.cmdDispOpen.Location = New System.Drawing.Point(663, 11)
        Me.cmdDispOpen.Name = "cmdDispOpen"
        Me.cmdDispOpen.Size = New System.Drawing.Size(29, 23)
        Me.cmdDispOpen.TabIndex = 3
        Me.cmdDispOpen.Text = "..."
        Me.cmdDispOpen.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(15, 16)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(80, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Disposition File:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(15, 42)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(47, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Log File:"
        '
        'cmdImport
        '
        Me.cmdImport.Location = New System.Drawing.Point(564, 65)
        Me.cmdImport.Name = "cmdImport"
        Me.cmdImport.Size = New System.Drawing.Size(128, 23)
        Me.cmdImport.TabIndex = 0
        Me.cmdImport.Text = "Import Dispositions"
        Me.cmdImport.UseVisualStyleBackColor = True
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        Me.OpenFileDialog1.Filter = "Text Files|*.txt|CSV files|*.csv"
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.DefaultExt = "txt"
        Me.SaveFileDialog1.Filter = "Text Files|*.txt"
        '
        'VRTDispositionSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "VRTDispositionSection"
        Me.Size = New System.Drawing.Size(704, 582)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents txtLogFilePath As System.Windows.Forms.TextBox
    Friend WithEvents txtDispositionPath As System.Windows.Forms.TextBox
    Friend WithEvents cmdLogFileOpen As System.Windows.Forms.Button
    Friend WithEvents cmdDispOpen As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cmdImport As System.Windows.Forms.Button
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents txtResults As System.Windows.Forms.TextBox
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog

End Class
