<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
    Partial Class ExportOryxDialog
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
        Me.gbOutput = New System.Windows.Forms.GroupBox
        Me.btnBrowseOutput = New System.Windows.Forms.Button
        Me.txtOutput = New System.Windows.Forms.TextBox
        Me.FontDialog1 = New System.Windows.Forms.FontDialog
        Me.btnExport = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.ProgressBar = New System.Windows.Forms.ProgressBar
        Me.Label2 = New System.Windows.Forms.Label
        Me.cbYear = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.cbQuarter = New System.Windows.Forms.ComboBox
        Me.lblStatus = New System.Windows.Forms.Label
        Me.llExports = New System.Windows.Forms.LinkLabel
        Me.gbOutput.SuspendLayout()
        Me.SuspendLayout()
        '
        'gbOutput
        '
        Me.gbOutput.Controls.Add(Me.btnBrowseOutput)
        Me.gbOutput.Controls.Add(Me.txtOutput)
        Me.gbOutput.Location = New System.Drawing.Point(12, 34)
        Me.gbOutput.Name = "gbOutput"
        Me.gbOutput.Size = New System.Drawing.Size(356, 54)
        Me.gbOutput.TabIndex = 0
        Me.gbOutput.TabStop = False
        Me.gbOutput.Text = "Output Path"
        '
        'btnBrowseOutput
        '
        Me.btnBrowseOutput.Location = New System.Drawing.Point(270, 17)
        Me.btnBrowseOutput.Name = "btnBrowseOutput"
        Me.btnBrowseOutput.Size = New System.Drawing.Size(75, 23)
        Me.btnBrowseOutput.TabIndex = 1
        Me.btnBrowseOutput.Text = "Browse"
        Me.btnBrowseOutput.UseVisualStyleBackColor = True
        '
        'txtOutput
        '
        Me.txtOutput.Location = New System.Drawing.Point(6, 19)
        Me.txtOutput.Name = "txtOutput"
        Me.txtOutput.Size = New System.Drawing.Size(258, 20)
        Me.txtOutput.TabIndex = 0
        '
        'btnExport
        '
        Me.btnExport.Location = New System.Drawing.Point(214, 111)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(75, 23)
        Me.btnExport.TabIndex = 8
        Me.btnExport.Text = "Export"
        Me.btnExport.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Location = New System.Drawing.Point(293, 111)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 9
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'ProgressBar
        '
        Me.ProgressBar.Location = New System.Drawing.Point(12, 110)
        Me.ProgressBar.Name = "ProgressBar"
        Me.ProgressBar.Size = New System.Drawing.Size(192, 23)
        Me.ProgressBar.TabIndex = 10
        Me.ProgressBar.Visible = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(105, 10)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(29, 13)
        Me.Label2.TabIndex = 18
        Me.Label2.Text = "Year"
        '
        'cbYear
        '
        Me.cbYear.FormattingEnabled = True
        Me.cbYear.Location = New System.Drawing.Point(140, 7)
        Me.cbYear.Name = "cbYear"
        Me.cbYear.Size = New System.Drawing.Size(67, 21)
        Me.cbYear.TabIndex = 17
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(13, 10)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(42, 13)
        Me.Label1.TabIndex = 16
        Me.Label1.Text = "Quarter"
        '
        'cbQuarter
        '
        Me.cbQuarter.FormattingEnabled = True
        Me.cbQuarter.Location = New System.Drawing.Point(61, 7)
        Me.cbQuarter.Name = "cbQuarter"
        Me.cbQuarter.Size = New System.Drawing.Size(38, 21)
        Me.cbQuarter.TabIndex = 15
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Location = New System.Drawing.Point(15, 92)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(83, 13)
        Me.lblStatus.TabIndex = 19
        Me.lblStatus.Text = "Status Message"
        Me.lblStatus.Visible = False
        '
        'llExports
        '
        Me.llExports.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.llExports.AutoSize = True
        Me.llExports.Location = New System.Drawing.Point(233, 10)
        Me.llExports.Name = "llExports"
        Me.llExports.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.llExports.Size = New System.Drawing.Size(59, 13)
        Me.llExports.TabIndex = 20
        Me.llExports.TabStop = True
        Me.llExports.Text = "LinkLabel1"
        '
        'ExportOryxDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(379, 144)
        Me.ControlBox = False
        Me.Controls.Add(Me.llExports)
        Me.Controls.Add(Me.lblStatus)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.cbYear)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.cbQuarter)
        Me.Controls.Add(Me.ProgressBar)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnExport)
        Me.Controls.Add(Me.gbOutput)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "ExportOryxDialog"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Export Oryx Files"
        Me.gbOutput.ResumeLayout(False)
        Me.gbOutput.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents gbOutput As System.Windows.Forms.GroupBox
    Friend WithEvents txtOutput As System.Windows.Forms.TextBox
    Friend WithEvents btnBrowseOutput As System.Windows.Forms.Button
    Friend WithEvents FontDialog1 As System.Windows.Forms.FontDialog
    Friend WithEvents btnExport As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents ProgressBar As System.Windows.Forms.ProgressBar
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents cbYear As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cbQuarter As System.Windows.Forms.ComboBox
    Friend WithEvents lblStatus As System.Windows.Forms.Label
    Friend WithEvents llExports As System.Windows.Forms.LinkLabel
End Class