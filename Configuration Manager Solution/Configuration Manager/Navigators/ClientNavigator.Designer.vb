<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientNavigator
    Inherits Qualisys.ConfigurationManager.Navigator

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
        Me.FacilityToolStrip = New System.Windows.Forms.ToolStrip
        Me.FacilityAllTSButton = New System.Windows.Forms.ToolStripButton
        Me.FacilityClientTSButton = New System.Windows.Forms.ToolStripButton
        Me.ClientList = New System.Windows.Forms.ListBox
        Me.FacilityToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'FacilityToolStrip
        '
        Me.FacilityToolStrip.CanOverflow = False
        Me.FacilityToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.FacilityToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FacilityAllTSButton, Me.FacilityClientTSButton})
        Me.FacilityToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.FacilityToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.FacilityToolStrip.Name = "FacilityToolStrip"
        Me.FacilityToolStrip.Size = New System.Drawing.Size(207, 67)
        Me.FacilityToolStrip.TabIndex = 5
        '
        'FacilityAllTSButton
        '
        Me.FacilityAllTSButton.CheckOnClick = True
        Me.FacilityAllTSButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Globe16
        Me.FacilityAllTSButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.FacilityAllTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FacilityAllTSButton.Name = "FacilityAllTSButton"
        Me.FacilityAllTSButton.Size = New System.Drawing.Size(205, 20)
        Me.FacilityAllTSButton.Text = "Edit Facility List"
        Me.FacilityAllTSButton.ToolTipText = "Display All Facilities"
        '
        'FacilityClientTSButton
        '
        Me.FacilityClientTSButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Filter16
        Me.FacilityClientTSButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.FacilityClientTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FacilityClientTSButton.Name = "FacilityClientTSButton"
        Me.FacilityClientTSButton.Size = New System.Drawing.Size(205, 20)
        Me.FacilityClientTSButton.Text = "Assign Facilities to Client"
        Me.FacilityClientTSButton.ToolTipText = "Display Facilities linked to selected Client"
        '
        'ClientList
        '
        Me.ClientList.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ClientList.IntegralHeight = False
        Me.ClientList.Location = New System.Drawing.Point(0, 67)
        Me.ClientList.Name = "ClientList"
        Me.ClientList.Size = New System.Drawing.Size(207, 256)
        Me.ClientList.TabIndex = 6
        '
        'ClientNavigator
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.ClientList)
        Me.Controls.Add(Me.FacilityToolStrip)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ClientNavigator"
        Me.Size = New System.Drawing.Size(207, 323)
        Me.FacilityToolStrip.ResumeLayout(False)
        Me.FacilityToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents FacilityToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FacilityClientTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FacilityAllTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ClientList As System.Windows.Forms.ListBox

End Class
