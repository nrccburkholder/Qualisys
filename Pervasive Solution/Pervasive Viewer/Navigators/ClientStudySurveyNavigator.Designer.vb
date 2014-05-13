<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientStudySurveyNavigator
    Inherits Navigator

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
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ShowAllTSButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ShowClientGroupsTSButton = New System.Windows.Forms.ToolStripButton
        Me.ClientFilterList = New System.Windows.Forms.ToolStripComboBox
        Me.ClientStudySurveyTree = New System.Windows.Forms.TreeView
        Me.HeaderStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ShowAllTSButton, Me.ToolStripSeparator2, Me.ShowClientGroupsTSButton, Me.ClientFilterList})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(187, 21)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ShowAllTSButton
        '
        Me.ShowAllTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ShowAllTSButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.ShowAllTSButton.Image = Global.Nrc.PervasiveViewer.My.Resources.Resources.YellowLight
        Me.ShowAllTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ShowAllTSButton.Name = "ShowAllTSButton"
        Me.ShowAllTSButton.Size = New System.Drawing.Size(23, 18)
        Me.ShowAllTSButton.Text = "Show All"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 21)
        '
        'ShowClientGroupsTSButton
        '
        Me.ShowClientGroupsTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ShowClientGroupsTSButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.ShowClientGroupsTSButton.Image = Global.Nrc.PervasiveViewer.My.Resources.Resources.SamplePlan16
        Me.ShowClientGroupsTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ShowClientGroupsTSButton.Name = "ShowClientGroupsTSButton"
        Me.ShowClientGroupsTSButton.Size = New System.Drawing.Size(23, 18)
        Me.ShowClientGroupsTSButton.Text = "Show Client Groups"
        '
        'ClientFilterList
        '
        Me.ClientFilterList.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ClientFilterList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ClientFilterList.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ClientFilterList.Items.AddRange(New Object() {"My Clients", "All Clients"})
        Me.ClientFilterList.Name = "ClientFilterList"
        Me.ClientFilterList.Size = New System.Drawing.Size(85, 21)
        '
        'ClientStudySurveyTree
        '
        Me.ClientStudySurveyTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ClientStudySurveyTree.HideSelection = False
        Me.ClientStudySurveyTree.Location = New System.Drawing.Point(0, 21)
        Me.ClientStudySurveyTree.Name = "ClientStudySurveyTree"
        Me.ClientStudySurveyTree.Size = New System.Drawing.Size(187, 327)
        Me.ClientStudySurveyTree.TabIndex = 1
        '
        'ClientStudySurveyNavigator
        '
        Me.Controls.Add(Me.ClientStudySurveyTree)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ClientStudySurveyNavigator"
        Me.Size = New System.Drawing.Size(187, 348)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ClientStudySurveyTree As System.Windows.Forms.TreeView
    Friend WithEvents ClientFilterList As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents ShowAllTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ShowClientGroupsTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator

End Class
