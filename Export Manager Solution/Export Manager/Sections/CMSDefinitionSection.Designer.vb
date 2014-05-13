<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CmsDefinitionSection
    Inherits DataMart.ExportManager.Section

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
        Me.CreateDefinitionControl1 = New Nrc.DataMart.ExportManager.CreateDefinitionControl
        Me.ExistingDefinitionsControl1 = New Nrc.DataMart.ExportManager.ExistingDefinitionsControl
        Me.SuspendLayout()
        '
        'CreateDefinitionControl1
        '
        Me.CreateDefinitionControl1.DateSelectionMode = Nrc.DataMart.ExportManager.CreateDefinitionControl.DateMode.SingleMonth
        Me.CreateDefinitionControl1.Dock = System.Windows.Forms.DockStyle.Top
        Me.CreateDefinitionControl1.Location = New System.Drawing.Point(0, 0)
        Me.CreateDefinitionControl1.Name = "CreateDefinitionControl1"
        Me.CreateDefinitionControl1.Size = New System.Drawing.Size(627, 140)
        Me.CreateDefinitionControl1.TabIndex = 0
        '
        'ExistingDefinitionsControl1
        '
        Me.ExistingDefinitionsControl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExistingDefinitionsControl1.Location = New System.Drawing.Point(0, 145)
        Me.ExistingDefinitionsControl1.Name = "ExistingDefinitionsControl1"
        Me.ExistingDefinitionsControl1.ShowCutoffFieldColumn = False
        Me.ExistingDefinitionsControl1.ShowEndDateColumn = False
        Me.ExistingDefinitionsControl1.ShowStartDateColumn = False
        Me.ExistingDefinitionsControl1.ShowStartMonthColumn = True
        Me.ExistingDefinitionsControl1.ShowUnitColumn = True
        Me.ExistingDefinitionsControl1.Size = New System.Drawing.Size(627, 289)
        Me.ExistingDefinitionsControl1.TabIndex = 1
        '
        'CmsDefinitionSection
        '
        Me.Controls.Add(Me.ExistingDefinitionsControl1)
        Me.Controls.Add(Me.CreateDefinitionControl1)
        Me.Name = "CmsDefinitionSection"
        Me.Size = New System.Drawing.Size(627, 434)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents CreateDefinitionControl1 As Nrc.DataMart.ExportManager.CreateDefinitionControl
    Friend WithEvents ExistingDefinitionsControl1 As Nrc.DataMart.ExportManager.ExistingDefinitionsControl

End Class
