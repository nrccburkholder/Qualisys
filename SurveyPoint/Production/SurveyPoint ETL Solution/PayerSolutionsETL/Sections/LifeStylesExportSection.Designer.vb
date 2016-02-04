<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class LifeStylesExportSection
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
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.cmdExport = New System.Windows.Forms.Button
        Me.cmdExportAndMark = New System.Windows.Forms.Button
        Me.Label4 = New System.Windows.Forms.Label
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.Label5 = New System.Windows.Forms.Label
        Me.txtExportFile = New System.Windows.Forms.TextBox
        Me.cmdExportFile = New System.Windows.Forms.Button
        Me.HeaderStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Dock = System.Windows.Forms.DockStyle.None
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(609, 25)
        Me.HeaderStrip1.TabIndex = 0
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(152, 22)
        Me.ToolStripLabel1.Text = "Life Styles Export"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'txtDescription
        '
        Me.txtDescription.Enabled = False
        Me.txtDescription.Location = New System.Drawing.Point(15, 80)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtDescription.Size = New System.Drawing.Size(577, 418)
        Me.txtDescription.TabIndex = 13
        '
        'cmdExport
        '
        Me.cmdExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdExport.Location = New System.Drawing.Point(314, 510)
        Me.cmdExport.Name = "cmdExport"
        Me.cmdExport.Size = New System.Drawing.Size(136, 23)
        Me.cmdExport.TabIndex = 14
        Me.cmdExport.Text = "Export"
        Me.cmdExport.UseVisualStyleBackColor = True
        '
        'cmdExportAndMark
        '
        Me.cmdExportAndMark.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdExportAndMark.Location = New System.Drawing.Point(460, 509)
        Me.cmdExportAndMark.Name = "cmdExportAndMark"
        Me.cmdExportAndMark.Size = New System.Drawing.Size(136, 23)
        Me.cmdExportAndMark.TabIndex = 15
        Me.cmdExportAndMark.Text = "Export and Mark 2401"
        Me.cmdExportAndMark.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(12, 64)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(63, 13)
        Me.Label4.TabIndex = 16
        Me.Label4.Text = "Description:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(12, 38)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(59, 13)
        Me.Label5.TabIndex = 17
        Me.Label5.Text = "Export File:"
        '
        'txtExportFile
        '
        Me.txtExportFile.Location = New System.Drawing.Point(115, 35)
        Me.txtExportFile.Name = "txtExportFile"
        Me.txtExportFile.ReadOnly = True
        Me.txtExportFile.Size = New System.Drawing.Size(444, 20)
        Me.txtExportFile.TabIndex = 18
        '
        'cmdExportFile
        '
        Me.cmdExportFile.Location = New System.Drawing.Point(565, 34)
        Me.cmdExportFile.Name = "cmdExportFile"
        Me.cmdExportFile.Size = New System.Drawing.Size(27, 23)
        Me.cmdExportFile.TabIndex = 19
        Me.cmdExportFile.Text = "..."
        Me.cmdExportFile.UseVisualStyleBackColor = True
        '
        'LifeStylesExportSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.cmdExportFile)
        Me.Controls.Add(Me.txtExportFile)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.cmdExportAndMark)
        Me.Controls.Add(Me.cmdExport)
        Me.Controls.Add(Me.txtDescription)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "LifeStylesExportSection"
        Me.Size = New System.Drawing.Size(609, 551)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents cmdExport As System.Windows.Forms.Button
    Friend WithEvents cmdExportAndMark As System.Windows.Forms.Button
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtExportFile As System.Windows.Forms.TextBox
    Friend WithEvents cmdExportFile As System.Windows.Forms.Button

End Class
