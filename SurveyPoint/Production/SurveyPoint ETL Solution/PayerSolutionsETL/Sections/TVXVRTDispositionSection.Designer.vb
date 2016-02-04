<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class TVXVRTDispositionSection
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
        Me.cmdImportDispositions = New System.Windows.Forms.Button
        Me.cmdLogFile = New System.Windows.Forms.Button
        Me.cmdDispositionFile = New System.Windows.Forms.Button
        Me.txtResults = New System.Windows.Forms.TextBox
        Me.txtLogFile = New System.Windows.Forms.TextBox
        Me.txtDispositionFile = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
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
        Me.HeaderStrip1.Size = New System.Drawing.Size(726, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(201, 22)
        Me.ToolStripLabel1.Text = "Tuvox VRT Dispositions"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.cmdImportDispositions)
        Me.GroupBox1.Controls.Add(Me.cmdLogFile)
        Me.GroupBox1.Controls.Add(Me.cmdDispositionFile)
        Me.GroupBox1.Controls.Add(Me.txtResults)
        Me.GroupBox1.Controls.Add(Me.txtLogFile)
        Me.GroupBox1.Controls.Add(Me.txtDispositionFile)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(3, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(720, 586)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        '
        'cmdImportDispositions
        '
        Me.cmdImportDispositions.Location = New System.Drawing.Point(567, 69)
        Me.cmdImportDispositions.Name = "cmdImportDispositions"
        Me.cmdImportDispositions.Size = New System.Drawing.Size(138, 23)
        Me.cmdImportDispositions.TabIndex = 8
        Me.cmdImportDispositions.Text = "Import Dispositions"
        Me.cmdImportDispositions.UseVisualStyleBackColor = True
        '
        'cmdLogFile
        '
        Me.cmdLogFile.Location = New System.Drawing.Point(677, 40)
        Me.cmdLogFile.Name = "cmdLogFile"
        Me.cmdLogFile.Size = New System.Drawing.Size(28, 23)
        Me.cmdLogFile.TabIndex = 7
        Me.cmdLogFile.Text = "..."
        Me.cmdLogFile.UseVisualStyleBackColor = True
        '
        'cmdDispositionFile
        '
        Me.cmdDispositionFile.Location = New System.Drawing.Point(677, 11)
        Me.cmdDispositionFile.Name = "cmdDispositionFile"
        Me.cmdDispositionFile.Size = New System.Drawing.Size(28, 23)
        Me.cmdDispositionFile.TabIndex = 6
        Me.cmdDispositionFile.Text = "..."
        Me.cmdDispositionFile.UseVisualStyleBackColor = True
        '
        'txtResults
        '
        Me.txtResults.Location = New System.Drawing.Point(20, 95)
        Me.txtResults.Multiline = True
        Me.txtResults.Name = "txtResults"
        Me.txtResults.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtResults.Size = New System.Drawing.Size(685, 485)
        Me.txtResults.TabIndex = 5
        '
        'txtLogFile
        '
        Me.txtLogFile.Location = New System.Drawing.Point(103, 42)
        Me.txtLogFile.Name = "txtLogFile"
        Me.txtLogFile.Size = New System.Drawing.Size(568, 20)
        Me.txtLogFile.TabIndex = 4
        '
        'txtDispositionFile
        '
        Me.txtDispositionFile.Location = New System.Drawing.Point(103, 13)
        Me.txtDispositionFile.Name = "txtDispositionFile"
        Me.txtDispositionFile.Size = New System.Drawing.Size(568, 20)
        Me.txtDispositionFile.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(17, 79)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(45, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Results:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(17, 45)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(47, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Log File:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(17, 16)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(80, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Disposition File:"
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "Text files (*.txt)|*.txt"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'TVXVRTDispositionSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "TVXVRTDispositionSection"
        Me.Size = New System.Drawing.Size(726, 617)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents cmdLogFile As System.Windows.Forms.Button
    Friend WithEvents cmdDispositionFile As System.Windows.Forms.Button
    Friend WithEvents txtResults As System.Windows.Forms.TextBox
    Friend WithEvents txtLogFile As System.Windows.Forms.TextBox
    Friend WithEvents txtDispositionFile As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cmdImportDispositions As System.Windows.Forms.Button

End Class
