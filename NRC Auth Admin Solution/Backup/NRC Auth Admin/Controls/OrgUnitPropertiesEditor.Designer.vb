<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OrgUnitPropertiesEditor
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.components = New System.ComponentModel.Container
        Me.OrgUnitLabel = New System.Windows.Forms.Label
        Me.OrgUnitName = New System.Windows.Forms.TextBox
        Me.DescriptionLabel = New System.Windows.Forms.Label
        Me.Description = New System.Windows.Forms.TextBox
        Me.UnitTypeLable = New System.Windows.Forms.Label
        Me.ClientLabel = New System.Windows.Forms.Label
        Me.UnitTypeList = New System.Windows.Forms.ComboBox
        Me.ClientList = New System.Windows.Forms.ComboBox
        Me.ErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        CType(Me.ErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'OrgUnitLabel
        '
        Me.OrgUnitLabel.AutoSize = True
        Me.OrgUnitLabel.Location = New System.Drawing.Point(5, 8)
        Me.OrgUnitLabel.Name = "OrgUnitLabel"
        Me.OrgUnitLabel.Size = New System.Drawing.Size(98, 13)
        Me.OrgUnitLabel.TabIndex = 4
        Me.OrgUnitLabel.Text = "Organization name:"
        Me.OrgUnitLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'OrgUnitName
        '
        Me.OrgUnitName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OrgUnitName.Location = New System.Drawing.Point(109, 6)
        Me.OrgUnitName.Name = "OrgUnitName"
        Me.OrgUnitName.Size = New System.Drawing.Size(270, 20)
        Me.OrgUnitName.TabIndex = 0
        '
        'DescriptionLabel
        '
        Me.DescriptionLabel.AutoSize = True
        Me.DescriptionLabel.Location = New System.Drawing.Point(5, 34)
        Me.DescriptionLabel.Name = "DescriptionLabel"
        Me.DescriptionLabel.Size = New System.Drawing.Size(63, 13)
        Me.DescriptionLabel.TabIndex = 5
        Me.DescriptionLabel.Text = "Description:"
        Me.DescriptionLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Description
        '
        Me.Description.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Description.Location = New System.Drawing.Point(109, 32)
        Me.Description.Name = "Description"
        Me.Description.Size = New System.Drawing.Size(270, 20)
        Me.Description.TabIndex = 1
        '
        'UnitTypeLable
        '
        Me.UnitTypeLable.AutoSize = True
        Me.UnitTypeLable.Location = New System.Drawing.Point(5, 60)
        Me.UnitTypeLable.Name = "UnitTypeLable"
        Me.UnitTypeLable.Size = New System.Drawing.Size(56, 13)
        Me.UnitTypeLable.TabIndex = 6
        Me.UnitTypeLable.Text = "Unit Type:"
        Me.UnitTypeLable.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ClientLabel
        '
        Me.ClientLabel.AutoSize = True
        Me.ClientLabel.Location = New System.Drawing.Point(5, 86)
        Me.ClientLabel.Name = "ClientLabel"
        Me.ClientLabel.Size = New System.Drawing.Size(78, 13)
        Me.ClientLabel.TabIndex = 7
        Me.ClientLabel.Text = "Qualisys Client:"
        Me.ClientLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'UnitTypeList
        '
        Me.UnitTypeList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UnitTypeList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.UnitTypeList.FormattingEnabled = True
        Me.UnitTypeList.Location = New System.Drawing.Point(109, 57)
        Me.UnitTypeList.Name = "UnitTypeList"
        Me.UnitTypeList.Size = New System.Drawing.Size(270, 21)
        Me.UnitTypeList.TabIndex = 2
        '
        'ClientList
        '
        Me.ClientList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ClientList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ClientList.FormattingEnabled = True
        Me.ClientList.Location = New System.Drawing.Point(109, 83)
        Me.ClientList.Name = "ClientList"
        Me.ClientList.Size = New System.Drawing.Size(270, 21)
        Me.ClientList.TabIndex = 3
        '
        'ErrorProvider
        '
        Me.ErrorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink
        Me.ErrorProvider.ContainerControl = Me
        '
        'OrgUnitPropertiesEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.ClientList)
        Me.Controls.Add(Me.UnitTypeList)
        Me.Controls.Add(Me.ClientLabel)
        Me.Controls.Add(Me.UnitTypeLable)
        Me.Controls.Add(Me.Description)
        Me.Controls.Add(Me.DescriptionLabel)
        Me.Controls.Add(Me.OrgUnitName)
        Me.Controls.Add(Me.OrgUnitLabel)
        Me.MinimumSize = New System.Drawing.Size(404, 115)
        Me.Name = "OrgUnitPropertiesEditor"
        Me.Size = New System.Drawing.Size(404, 115)
        CType(Me.ErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents OrgUnitLabel As System.Windows.Forms.Label
    Friend WithEvents OrgUnitName As System.Windows.Forms.TextBox
    Friend WithEvents DescriptionLabel As System.Windows.Forms.Label
    Friend WithEvents Description As System.Windows.Forms.TextBox
    Friend WithEvents UnitTypeLable As System.Windows.Forms.Label
    Friend WithEvents ClientLabel As System.Windows.Forms.Label
    Friend WithEvents UnitTypeList As System.Windows.Forms.ComboBox
    Friend WithEvents ClientList As System.Windows.Forms.ComboBox
    Friend WithEvents ErrorProvider As System.Windows.Forms.ErrorProvider

End Class
