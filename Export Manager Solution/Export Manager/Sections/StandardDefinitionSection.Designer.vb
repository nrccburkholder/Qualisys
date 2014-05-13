<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StandardDefinitionSection
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
        Me.ExistingDefinitions = New Nrc.DataMart.ExportManager.ExistingDefinitionsControl
        Me.CreateDefinition = New Nrc.DataMart.ExportManager.CreateDefinitionControl
        Me.SuspendLayout()
        '
        'ExistingDefinitions
        '
        Me.ExistingDefinitions.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExistingDefinitions.ExportSetType = Nrc.DataMart.Library.ExportSetType.None
        Me.ExistingDefinitions.Location = New System.Drawing.Point(0, 147)
        Me.ExistingDefinitions.Name = "ExistingDefinitions"
        Me.ExistingDefinitions.Navigator = Nothing
        Me.ExistingDefinitions.ShowCutoffFieldColumn = True
        Me.ExistingDefinitions.ShowEndDateColumn = True
        Me.ExistingDefinitions.ShowStartDateColumn = True
        Me.ExistingDefinitions.ShowStartMonthColumn = True
        Me.ExistingDefinitions.ShowUnitColumn = True
        Me.ExistingDefinitions.Size = New System.Drawing.Size(672, 251)
        Me.ExistingDefinitions.TabIndex = 3
        '
        'CreateDefinition
        '
        Me.CreateDefinition.DateSelectionMode = Nrc.DataMart.ExportManager.CreateDefinitionControl.DateMode.StartAndEndDate
        Me.CreateDefinition.Dock = System.Windows.Forms.DockStyle.Top
        Me.CreateDefinition.Enabled = False
        Me.CreateDefinition.ExportSetType = Nrc.DataMart.Library.ExportSetType.None
        Me.CreateDefinition.Location = New System.Drawing.Point(0, 0)
        Me.CreateDefinition.Name = "CreateDefinition"
        Me.CreateDefinition.Navigator = Nothing
        Me.CreateDefinition.Size = New System.Drawing.Size(672, 141)
        Me.CreateDefinition.TabIndex = 2
        '
        'StandardDefinitionSection
        '
        Me.Controls.Add(Me.ExistingDefinitions)
        Me.Controls.Add(Me.CreateDefinition)
        Me.Name = "StandardDefinitionSection"
        Me.Size = New System.Drawing.Size(672, 398)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ExistingDefinitions As Nrc.DataMart.ExportManager.ExistingDefinitionsControl
    Friend WithEvents CreateDefinition As Nrc.DataMart.ExportManager.CreateDefinitionControl

End Class
