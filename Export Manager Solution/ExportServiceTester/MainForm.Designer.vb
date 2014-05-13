<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
    Inherits System.Windows.Forms.Form

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
        Me.StartButton = New System.Windows.Forms.LinkLabel
        Me.StopButton = New System.Windows.Forms.LinkLabel
        Me.PauseButton = New System.Windows.Forms.LinkLabel
        Me.ResumeButton = New System.Windows.Forms.LinkLabel
        Me.RestartButton = New System.Windows.Forms.LinkLabel
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.OutputLog = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.ServiceInterval = New System.Windows.Forms.NumericUpDown
        Me.Label3 = New System.Windows.Forms.Label
        Me.OutputFolder = New System.Windows.Forms.TextBox
        Me.ResetButton = New System.Windows.Forms.LinkLabel
        Me.ErroredFolder = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.GroupBox1.SuspendLayout()
        CType(Me.ServiceInterval, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'StartButton
        '
        Me.StartButton.AutoSize = True
        Me.StartButton.Location = New System.Drawing.Point(22, 30)
        Me.StartButton.Name = "StartButton"
        Me.StartButton.Size = New System.Drawing.Size(31, 13)
        Me.StartButton.TabIndex = 0
        Me.StartButton.TabStop = True
        Me.StartButton.Text = "Start"
        '
        'StopButton
        '
        Me.StopButton.AutoSize = True
        Me.StopButton.Location = New System.Drawing.Point(22, 66)
        Me.StopButton.Name = "StopButton"
        Me.StopButton.Size = New System.Drawing.Size(29, 13)
        Me.StopButton.TabIndex = 0
        Me.StopButton.TabStop = True
        Me.StopButton.Text = "Stop"
        '
        'PauseButton
        '
        Me.PauseButton.AutoSize = True
        Me.PauseButton.Location = New System.Drawing.Point(22, 102)
        Me.PauseButton.Name = "PauseButton"
        Me.PauseButton.Size = New System.Drawing.Size(36, 13)
        Me.PauseButton.TabIndex = 0
        Me.PauseButton.TabStop = True
        Me.PauseButton.Text = "Pause"
        '
        'ResumeButton
        '
        Me.ResumeButton.AutoSize = True
        Me.ResumeButton.Location = New System.Drawing.Point(22, 138)
        Me.ResumeButton.Name = "ResumeButton"
        Me.ResumeButton.Size = New System.Drawing.Size(45, 13)
        Me.ResumeButton.TabIndex = 0
        Me.ResumeButton.TabStop = True
        Me.ResumeButton.Text = "Resume"
        '
        'RestartButton
        '
        Me.RestartButton.AutoSize = True
        Me.RestartButton.Location = New System.Drawing.Point(22, 174)
        Me.RestartButton.Name = "RestartButton"
        Me.RestartButton.Size = New System.Drawing.Size(43, 13)
        Me.RestartButton.TabIndex = 0
        Me.RestartButton.TabStop = True
        Me.RestartButton.Text = "Restart"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.StartButton)
        Me.GroupBox1.Controls.Add(Me.RestartButton)
        Me.GroupBox1.Controls.Add(Me.StopButton)
        Me.GroupBox1.Controls.Add(Me.ResumeButton)
        Me.GroupBox1.Controls.Add(Me.PauseButton)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 12)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(112, 347)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Service Operations"
        '
        'OutputLog
        '
        Me.OutputLog.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OutputLog.Location = New System.Drawing.Point(130, 128)
        Me.OutputLog.Multiline = True
        Me.OutputLog.Name = "OutputLog"
        Me.OutputLog.Size = New System.Drawing.Size(552, 232)
        Me.OutputLog.TabIndex = 2
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(130, 112)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(61, 13)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Output Log"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(130, 12)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(137, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Service Interval (seconds):"
        '
        'ServiceInterval
        '
        Me.ServiceInterval.Location = New System.Drawing.Point(269, 8)
        Me.ServiceInterval.Name = "ServiceInterval"
        Me.ServiceInterval.Size = New System.Drawing.Size(51, 21)
        Me.ServiceInterval.TabIndex = 5
        Me.ServiceInterval.Value = New Decimal(New Integer() {10, 0, 0, 0})
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(130, 42)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(78, 13)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Output Folder:"
        '
        'OutputFolder
        '
        Me.OutputFolder.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.OutputFolder.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories
        Me.OutputFolder.Location = New System.Drawing.Point(210, 38)
        Me.OutputFolder.Name = "OutputFolder"
        Me.OutputFolder.Size = New System.Drawing.Size(472, 21)
        Me.OutputFolder.TabIndex = 7
        '
        'ResetButton
        '
        Me.ResetButton.AutoSize = True
        Me.ResetButton.Location = New System.Drawing.Point(647, 101)
        Me.ResetButton.Name = "ResetButton"
        Me.ResetButton.Size = New System.Drawing.Size(35, 13)
        Me.ResetButton.TabIndex = 8
        Me.ResetButton.TabStop = True
        Me.ResetButton.Text = "Reset"
        '
        'ErroredFolder
        '
        Me.ErroredFolder.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.ErroredFolder.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories
        Me.ErroredFolder.Location = New System.Drawing.Point(210, 65)
        Me.ErroredFolder.Name = "ErroredFolder"
        Me.ErroredFolder.Size = New System.Drawing.Size(472, 21)
        Me.ErroredFolder.TabIndex = 10
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(130, 68)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(73, 13)
        Me.Label4.TabIndex = 9
        Me.Label4.Text = "Errors Folder:"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(694, 371)
        Me.Controls.Add(Me.ErroredFolder)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ResetButton)
        Me.Controls.Add(Me.OutputFolder)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.ServiceInterval)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.OutputLog)
        Me.Controls.Add(Me.GroupBox1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Export Service"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        CType(Me.ServiceInterval, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StartButton As System.Windows.Forms.LinkLabel
    Friend WithEvents StopButton As System.Windows.Forms.LinkLabel
    Friend WithEvents PauseButton As System.Windows.Forms.LinkLabel
    Friend WithEvents ResumeButton As System.Windows.Forms.LinkLabel
    Friend WithEvents RestartButton As System.Windows.Forms.LinkLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents OutputLog As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ServiceInterval As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents OutputFolder As System.Windows.Forms.TextBox
    Friend WithEvents ResetButton As System.Windows.Forms.LinkLabel
    Friend WithEvents ErroredFolder As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label

End Class
