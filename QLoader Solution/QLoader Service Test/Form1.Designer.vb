<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents StartButton As System.Windows.Forms.Button
    Friend WithEvents StopButton As System.Windows.Forms.Button
    Friend WithEvents TextBox1 As System.Windows.Forms.TextBox
    Friend WithEvents FileLoaderButton As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.StartButton = New System.Windows.Forms.Button
        Me.StopButton = New System.Windows.Forms.Button
        Me.TextBox1 = New System.Windows.Forms.TextBox
        Me.FileLoaderButton = New System.Windows.Forms.Button
        Me.PervasiveAddressCleaningButton = New System.Windows.Forms.Button
        Me.CheckForWorkButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'StartButton
        '
        Me.StartButton.Location = New System.Drawing.Point(16, 24)
        Me.StartButton.Name = "StartButton"
        Me.StartButton.Size = New System.Drawing.Size(75, 23)
        Me.StartButton.TabIndex = 0
        Me.StartButton.Text = "Start"
        '
        'StopButton
        '
        Me.StopButton.Location = New System.Drawing.Point(97, 24)
        Me.StopButton.Name = "StopButton"
        Me.StopButton.Size = New System.Drawing.Size(75, 23)
        Me.StopButton.TabIndex = 1
        Me.StopButton.Text = "Stop"
        '
        'TextBox1
        '
        Me.TextBox1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TextBox1.Location = New System.Drawing.Point(16, 72)
        Me.TextBox1.Multiline = True
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New System.Drawing.Size(584, 288)
        Me.TextBox1.TabIndex = 2
        '
        'FileLoaderButton
        '
        Me.FileLoaderButton.Location = New System.Drawing.Point(340, 24)
        Me.FileLoaderButton.Name = "FileLoaderButton"
        Me.FileLoaderButton.Size = New System.Drawing.Size(75, 23)
        Me.FileLoaderButton.TabIndex = 3
        Me.FileLoaderButton.Text = "File Loader"
        '
        'PervasiveAddressCleaningButton
        '
        Me.PervasiveAddressCleaningButton.Location = New System.Drawing.Point(421, 24)
        Me.PervasiveAddressCleaningButton.Name = "PervasiveAddressCleaningButton"
        Me.PervasiveAddressCleaningButton.Size = New System.Drawing.Size(140, 23)
        Me.PervasiveAddressCleaningButton.TabIndex = 4
        Me.PervasiveAddressCleaningButton.Text = "Pervasive Address Clean"
        Me.PervasiveAddressCleaningButton.UseVisualStyleBackColor = True
        '
        'CheckForWorkButton
        '
        Me.CheckForWorkButton.Location = New System.Drawing.Point(205, 24)
        Me.CheckForWorkButton.Name = "CheckForWorkButton"
        Me.CheckForWorkButton.Size = New System.Drawing.Size(102, 23)
        Me.CheckForWorkButton.TabIndex = 5
        Me.CheckForWorkButton.Text = "Check for Work"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(616, 374)
        Me.Controls.Add(Me.CheckForWorkButton)
        Me.Controls.Add(Me.PervasiveAddressCleaningButton)
        Me.Controls.Add(Me.FileLoaderButton)
        Me.Controls.Add(Me.TextBox1)
        Me.Controls.Add(Me.StopButton)
        Me.Controls.Add(Me.StartButton)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents PervasiveAddressCleaningButton As System.Windows.Forms.Button
    Friend WithEvents CheckForWorkButton As System.Windows.Forms.Button

End Class
