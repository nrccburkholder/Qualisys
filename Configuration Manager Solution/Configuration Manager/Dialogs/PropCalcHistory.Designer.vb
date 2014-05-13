<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PropCalcHistory
    Inherits Nrc.Framework.WinForms.DialogForm

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
        Me.cmdClose = New System.Windows.Forms.Button
        Me.wbReport = New System.Windows.Forms.WebBrowser
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Size = New System.Drawing.Size(905, 26)
        '
        'cmdClose
        '
        Me.cmdClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdClose.Location = New System.Drawing.Point(828, 740)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(75, 23)
        Me.cmdClose.TabIndex = 1
        Me.cmdClose.Text = "&Close"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'wbReport
        '
        Me.wbReport.Location = New System.Drawing.Point(4, 33)
        Me.wbReport.MinimumSize = New System.Drawing.Size(20, 20)
        Me.wbReport.Name = "wbReport"
        Me.wbReport.Size = New System.Drawing.Size(903, 701)
        Me.wbReport.TabIndex = 2
        '
        'PropCalcHistory
        '
        Me.ClientSize = New System.Drawing.Size(907, 767)
        Me.ControlBox = False
        Me.Controls.Add(Me.cmdClose)
        Me.Controls.Add(Me.wbReport)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "PropCalcHistory"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.wbReport, 0)
        Me.Controls.SetChildIndex(Me.cmdClose, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents cmdClose As System.Windows.Forms.Button
    Friend WithEvents wbReport As System.Windows.Forms.WebBrowser

End Class
