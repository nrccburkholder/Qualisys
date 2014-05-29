<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientStudySurveyNavigator
    Inherits DataMart.ExportManager.Navigator

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
        Me.SelectHeaderStrip = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ClientStudySurveyTree = New Nrc.DataMart.ExportManager.MultiSelectTreeView
        Me.FilterToolStrip = New System.Windows.Forms.ToolStrip
        Me.ShowAllFilesButton = New System.Windows.Forms.ToolStripButton
        Me.FilterButton = New System.Windows.Forms.ToolStripButton
        Me.SelectHeaderStrip.SuspendLayout()
        Me.FilterToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'SelectHeaderStrip
        '
        Me.SelectHeaderStrip.AutoSize = False
        Me.SelectHeaderStrip.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.SelectHeaderStrip.ForeColor = System.Drawing.Color.Black
        Me.SelectHeaderStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.SelectHeaderStrip.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.SelectHeaderStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.SelectHeaderStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.Table
        Me.SelectHeaderStrip.Location = New System.Drawing.Point(0, 0)
        Me.SelectHeaderStrip.Name = "SelectHeaderStrip"
        Me.SelectHeaderStrip.Size = New System.Drawing.Size(232, 21)
        Me.SelectHeaderStrip.TabIndex = 2
        Me.SelectHeaderStrip.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(168, 15)
        Me.ToolStripLabel1.Text = "Select a client, study or survey."
        '
        'ClientStudySurveyTree
        '
        Me.ClientStudySurveyTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ClientStudySurveyTree.HideSelection = False
        Me.ClientStudySurveyTree.Location = New System.Drawing.Point(0, 69)
        Me.ClientStudySurveyTree.Name = "ClientStudySurveyTree"
        Me.ClientStudySurveyTree.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.ClientStudySurveyTree.Size = New System.Drawing.Size(232, 325)
        Me.ClientStudySurveyTree.TabIndex = 3
        '
        'FilterToolStrip
        '
        Me.FilterToolStrip.CanOverflow = False
        Me.FilterToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.FilterToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ShowAllFilesButton, Me.FilterButton})
        Me.FilterToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.FilterToolStrip.Location = New System.Drawing.Point(0, 21)
        Me.FilterToolStrip.Name = "FilterToolStrip"
        Me.FilterToolStrip.Size = New System.Drawing.Size(232, 48)
        Me.FilterToolStrip.TabIndex = 5
        Me.FilterToolStrip.Text = "ToolStrip1"
        '
        'ShowAllFilesButton
        '
        Me.ShowAllFilesButton.Checked = True
        Me.ShowAllFilesButton.CheckState = System.Windows.Forms.CheckState.Checked
        Me.ShowAllFilesButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Globe16
        Me.ShowAllFilesButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.ShowAllFilesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ShowAllFilesButton.Name = "ShowAllFilesButton"
        Me.ShowAllFilesButton.Size = New System.Drawing.Size(230, 20)
        Me.ShowAllFilesButton.Text = "Show All Files"
        Me.ShowAllFilesButton.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FilterButton
        '
        Me.FilterButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Filter
        Me.FilterButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.FilterButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterButton.Name = "FilterButton"
        Me.FilterButton.Size = New System.Drawing.Size(230, 20)
        Me.FilterButton.Text = "Filter by Client, Study, or Survey"
        Me.FilterButton.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ClientStudySurveyNavigator
        '
        Me.Controls.Add(Me.ClientStudySurveyTree)
        Me.Controls.Add(Me.FilterToolStrip)
        Me.Controls.Add(Me.SelectHeaderStrip)
        Me.Name = "ClientStudySurveyNavigator"
        Me.Size = New System.Drawing.Size(232, 394)
        Me.SelectHeaderStrip.ResumeLayout(False)
        Me.SelectHeaderStrip.PerformLayout()
        Me.FilterToolStrip.ResumeLayout(False)
        Me.FilterToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ClientStudySurveyTree As Nrc.DataMart.ExportManager.MultiSelectTreeView
    Protected WithEvents SelectHeaderStrip As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents FilterToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ShowAllFilesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FilterButton As System.Windows.Forms.ToolStripButton

End Class
