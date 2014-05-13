<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GroupPropertiesEditor
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
        Me.GroupNameLabel = New System.Windows.Forms.Label
        Me.GroupName = New System.Windows.Forms.TextBox
        Me.GroupDescriptionLabel = New System.Windows.Forms.Label
        Me.GroupDescription = New System.Windows.Forms.TextBox
        Me.EmailLabel = New System.Windows.Forms.Label
        Me.GroupEmail = New System.Windows.Forms.TextBox
        Me.ErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        CType(Me.ErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'GroupNameLabel
        '
        Me.GroupNameLabel.AutoSize = True
        Me.GroupNameLabel.Location = New System.Drawing.Point(2, 7)
        Me.GroupNameLabel.Name = "GroupNameLabel"
        Me.GroupNameLabel.Size = New System.Drawing.Size(65, 13)
        Me.GroupNameLabel.TabIndex = 3
        Me.GroupNameLabel.Text = "Group name"
        '
        'GroupName
        '
        Me.GroupName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupName.Location = New System.Drawing.Point(85, 3)
        Me.GroupName.Name = "GroupName"
        Me.GroupName.Size = New System.Drawing.Size(249, 21)
        Me.GroupName.TabIndex = 0
        '
        'GroupDescriptionLabel
        '
        Me.GroupDescriptionLabel.AutoSize = True
        Me.GroupDescriptionLabel.Location = New System.Drawing.Point(2, 34)
        Me.GroupDescriptionLabel.Name = "GroupDescriptionLabel"
        Me.GroupDescriptionLabel.Size = New System.Drawing.Size(60, 13)
        Me.GroupDescriptionLabel.TabIndex = 4
        Me.GroupDescriptionLabel.Text = "Description"
        '
        'GroupDescription
        '
        Me.GroupDescription.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupDescription.Location = New System.Drawing.Point(85, 30)
        Me.GroupDescription.Multiline = True
        Me.GroupDescription.Name = "GroupDescription"
        Me.GroupDescription.Size = New System.Drawing.Size(249, 93)
        Me.GroupDescription.TabIndex = 1
        '
        'EmailLabel
        '
        Me.EmailLabel.AutoSize = True
        Me.EmailLabel.Location = New System.Drawing.Point(2, 133)
        Me.EmailLabel.Name = "EmailLabel"
        Me.EmailLabel.Size = New System.Drawing.Size(63, 13)
        Me.EmailLabel.TabIndex = 5
        Me.EmailLabel.Text = "Group email"
        '
        'GroupEmail
        '
        Me.GroupEmail.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupEmail.Location = New System.Drawing.Point(85, 129)
        Me.GroupEmail.Name = "GroupEmail"
        Me.GroupEmail.Size = New System.Drawing.Size(249, 21)
        Me.GroupEmail.TabIndex = 2
        '
        'ErrorProvider
        '
        Me.ErrorProvider.ContainerControl = Me
        '
        'GroupPropertiesEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupEmail)
        Me.Controls.Add(Me.EmailLabel)
        Me.Controls.Add(Me.GroupDescriptionLabel)
        Me.Controls.Add(Me.GroupDescription)
        Me.Controls.Add(Me.GroupName)
        Me.Controls.Add(Me.GroupNameLabel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MinimumSize = New System.Drawing.Size(355, 163)
        Me.Name = "GroupPropertiesEditor"
        Me.Size = New System.Drawing.Size(355, 163)
        CType(Me.ErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents GroupNameLabel As System.Windows.Forms.Label
    Friend WithEvents GroupName As System.Windows.Forms.TextBox
    Friend WithEvents GroupDescriptionLabel As System.Windows.Forms.Label
    Friend WithEvents GroupDescription As System.Windows.Forms.TextBox
    Friend WithEvents EmailLabel As System.Windows.Forms.Label
    Friend WithEvents GroupEmail As System.Windows.Forms.TextBox
    Friend WithEvents ErrorProvider As System.Windows.Forms.ErrorProvider

End Class
