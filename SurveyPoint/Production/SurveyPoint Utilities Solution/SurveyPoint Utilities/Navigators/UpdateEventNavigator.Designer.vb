<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class UpdateEventNavigator
    Inherits SurveyPointUtilities.Navigator

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
        Me.UpdateEventToolStrip = New System.Windows.Forms.ToolStrip
        Me.UpdateEventCodesTSButton = New System.Windows.Forms.ToolStripButton
        Me.UpdateEventLogTSButton = New System.Windows.Forms.ToolStripButton
        Me.UpdateEventToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'UpdateEventToolStrip
        '
        Me.UpdateEventToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.UpdateEventToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateEventCodesTSButton, Me.UpdateEventLogTSButton})
        Me.UpdateEventToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.UpdateEventToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.UpdateEventToolStrip.Name = "UpdateEventToolStrip"
        Me.UpdateEventToolStrip.Size = New System.Drawing.Size(189, 67)
        Me.UpdateEventToolStrip.TabIndex = 4
        Me.UpdateEventToolStrip.Text = "ToolStrip1"
        '
        'UpdateEventCodesTSButton
        '
        Me.UpdateEventCodesTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Validation16
        Me.UpdateEventCodesTSButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.UpdateEventCodesTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateEventCodesTSButton.Name = "UpdateEventCodesTSButton"
        Me.UpdateEventCodesTSButton.Size = New System.Drawing.Size(187, 20)
        Me.UpdateEventCodesTSButton.Text = "Update Event Codes"
        '
        'UpdateEventLogTSButton
        '
        Me.UpdateEventLogTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Document16
        Me.UpdateEventLogTSButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.UpdateEventLogTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateEventLogTSButton.Name = "UpdateEventLogTSButton"
        Me.UpdateEventLogTSButton.Size = New System.Drawing.Size(187, 20)
        Me.UpdateEventLogTSButton.Text = "View Update Log"
        '
        'UpdateEventNavigator
        '
        Me.Controls.Add(Me.UpdateEventToolStrip)
        Me.Name = "UpdateEventNavigator"
        Me.Size = New System.Drawing.Size(189, 446)
        Me.UpdateEventToolStrip.ResumeLayout(False)
        Me.UpdateEventToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents UpdateEventToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents UpdateEventCodesTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateEventLogTSButton As System.Windows.Forms.ToolStripButton

End Class
