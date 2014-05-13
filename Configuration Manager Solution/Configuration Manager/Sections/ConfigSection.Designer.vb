<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ConfigSection
    Inherits ConfigurationManager.Section

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
        Me.MainPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ConfigPanel = New System.Windows.Forms.Panel
        Me.ConfigToolStrip = New System.Windows.Forms.ToolStrip
        Me.MainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainPanel
        '
        Me.MainPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainPanel.Caption = ""
        Me.MainPanel.Controls.Add(Me.ConfigPanel)
        Me.MainPanel.Controls.Add(Me.ConfigToolStrip)
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainPanel.ShowCaption = True
        Me.MainPanel.Size = New System.Drawing.Size(632, 360)
        Me.MainPanel.TabIndex = 0
        '
        'ConfigPanel
        '
        Me.ConfigPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ConfigPanel.Location = New System.Drawing.Point(1, 52)
        Me.ConfigPanel.Name = "ConfigPanel"
        Me.ConfigPanel.Size = New System.Drawing.Size(630, 307)
        Me.ConfigPanel.TabIndex = 5
        '
        'ConfigToolStrip
        '
        Me.ConfigToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ConfigToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.HorizontalStackWithOverflow
        Me.ConfigToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.ConfigToolStrip.Name = "ConfigToolStrip"
        Me.ConfigToolStrip.Size = New System.Drawing.Size(630, 25)
        Me.ConfigToolStrip.TabIndex = 2
        Me.ConfigToolStrip.Text = "ToolStrip1"
        '
        'ConfigSection
        '
        Me.Controls.Add(Me.MainPanel)
        Me.Name = "ConfigSection"
        Me.Size = New System.Drawing.Size(632, 360)
        Me.MainPanel.ResumeLayout(False)
        Me.MainPanel.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ConfigToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ConfigPanel As System.Windows.Forms.Panel

End Class
