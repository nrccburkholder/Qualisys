<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VRTFileExpandSection
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
        Me.txtDestination = New System.Windows.Forms.TextBox
        Me.txtSource = New System.Windows.Forms.TextBox
        Me.cmdSource = New System.Windows.Forms.Button
        Me.cmdDestination = New System.Windows.Forms.Button
        Me.cmdExecute = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.HeaderStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
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
        Me.HeaderStrip1.Size = New System.Drawing.Size(714, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(159, 22)
        Me.ToolStripLabel1.Text = "VRT File Expander"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.txtDestination)
        Me.GroupBox1.Controls.Add(Me.txtSource)
        Me.GroupBox1.Controls.Add(Me.cmdSource)
        Me.GroupBox1.Controls.Add(Me.cmdDestination)
        Me.GroupBox1.Controls.Add(Me.cmdExecute)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(3, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(708, 83)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Configuration"
        '
        'txtDestination
        '
        Me.txtDestination.Enabled = False
        Me.txtDestination.Location = New System.Drawing.Point(111, 51)
        Me.txtDestination.Name = "txtDestination"
        Me.txtDestination.Size = New System.Drawing.Size(442, 20)
        Me.txtDestination.TabIndex = 6
        '
        'txtSource
        '
        Me.txtSource.Enabled = False
        Me.txtSource.Location = New System.Drawing.Point(111, 25)
        Me.txtSource.Name = "txtSource"
        Me.txtSource.Size = New System.Drawing.Size(442, 20)
        Me.txtSource.TabIndex = 5
        '
        'cmdSource
        '
        Me.cmdSource.Location = New System.Drawing.Point(561, 25)
        Me.cmdSource.Name = "cmdSource"
        Me.cmdSource.Size = New System.Drawing.Size(26, 23)
        Me.cmdSource.TabIndex = 4
        Me.cmdSource.Text = "..."
        Me.cmdSource.UseVisualStyleBackColor = True
        '
        'cmdDestination
        '
        Me.cmdDestination.Location = New System.Drawing.Point(561, 51)
        Me.cmdDestination.Name = "cmdDestination"
        Me.cmdDestination.Size = New System.Drawing.Size(26, 23)
        Me.cmdDestination.TabIndex = 3
        Me.cmdDestination.Text = "..."
        Me.cmdDestination.UseVisualStyleBackColor = True
        '
        'cmdExecute
        '
        Me.cmdExecute.Location = New System.Drawing.Point(606, 25)
        Me.cmdExecute.Name = "cmdExecute"
        Me.cmdExecute.Size = New System.Drawing.Size(75, 23)
        Me.cmdExecute.TabIndex = 2
        Me.cmdExecute.Text = "Execute"
        Me.cmdExecute.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(15, 52)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(82, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Destination File:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(15, 25)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(63, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Source File:"
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.txtDescription)
        Me.GroupBox2.Location = New System.Drawing.Point(3, 117)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(708, 467)
        Me.GroupBox2.TabIndex = 2
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Description"
        '
        'txtDescription
        '
        Me.txtDescription.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtDescription.Enabled = False
        Me.txtDescription.Location = New System.Drawing.Point(6, 19)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtDescription.Size = New System.Drawing.Size(696, 442)
        Me.txtDescription.TabIndex = 0
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'VRTFileExpandSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "VRTFileExpandSection"
        Me.Size = New System.Drawing.Size(714, 587)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtDestination As System.Windows.Forms.TextBox
    Friend WithEvents txtSource As System.Windows.Forms.TextBox
    Friend WithEvents cmdSource As System.Windows.Forms.Button
    Friend WithEvents cmdDestination As System.Windows.Forms.Button
    Friend WithEvents cmdExecute As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog

End Class
