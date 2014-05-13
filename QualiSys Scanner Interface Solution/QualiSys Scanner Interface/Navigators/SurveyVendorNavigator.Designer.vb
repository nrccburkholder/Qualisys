<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SurveyVendorNavigator
    Inherits QualiSys_Scanner_Interface.Navigator

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
        Me.SurveyHeaderStrip = New Nrc.Framework.WinForms.HeaderStrip
        Me.ClientFilterList = New System.Windows.Forms.ToolStripComboBox
        Me.SurveyTreeView = New System.Windows.Forms.TreeView
        Me.SurveyHeaderStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'SurveyHeaderStrip
        '
        Me.SurveyHeaderStrip.AutoSize = False
        Me.SurveyHeaderStrip.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.SurveyHeaderStrip.ForeColor = System.Drawing.Color.Black
        Me.SurveyHeaderStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.SurveyHeaderStrip.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.SurveyHeaderStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ClientFilterList})
        Me.SurveyHeaderStrip.Location = New System.Drawing.Point(0, 0)
        Me.SurveyHeaderStrip.Name = "SurveyHeaderStrip"
        Me.SurveyHeaderStrip.Size = New System.Drawing.Size(173, 19)
        Me.SurveyHeaderStrip.TabIndex = 1
        Me.SurveyHeaderStrip.Text = "HeaderStrip1"
        '
        'ClientFilterList
        '
        Me.ClientFilterList.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ClientFilterList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ClientFilterList.Items.AddRange(New Object() {"My Clients", "All Clients"})
        Me.ClientFilterList.Name = "ClientFilterList"
        Me.ClientFilterList.Size = New System.Drawing.Size(85, 19)
        '
        'SurveyTreeView
        '
        Me.SurveyTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SurveyTreeView.HideSelection = False
        Me.SurveyTreeView.Location = New System.Drawing.Point(0, 19)
        Me.SurveyTreeView.Name = "SurveyTreeView"
        Me.SurveyTreeView.Size = New System.Drawing.Size(173, 369)
        Me.SurveyTreeView.TabIndex = 2
        '
        'SurveyVendorNavigator
        '
        Me.Controls.Add(Me.SurveyTreeView)
        Me.Controls.Add(Me.SurveyHeaderStrip)
        Me.Name = "SurveyVendorNavigator"
        Me.Size = New System.Drawing.Size(173, 388)
        Me.SurveyHeaderStrip.ResumeLayout(False)
        Me.SurveyHeaderStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SurveyHeaderStrip As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ClientFilterList As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents SurveyTreeView As System.Windows.Forms.TreeView

End Class
