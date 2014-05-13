<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientSection
    Inherits Qualisys.ConfigurationManager.Section

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
        Me.components = New System.ComponentModel.Container
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar
        Me.WorkAreaPanel = New System.Windows.Forms.Panel
        Me.ClientGroupLabel = New System.Windows.Forms.Label
        Me.ClientGroupComboBox = New System.Windows.Forms.ComboBox
        Me.ClientInActivateCheckBox = New System.Windows.Forms.CheckBox
        Me.ClientNameLabel = New System.Windows.Forms.Label
        Me.ClientNameTextBox = New System.Windows.Forms.TextBox
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.ClientGroupBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.WorkAreaPanel.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        CType(Me.ClientGroupBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = "Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(507, 20)
        Me.InformationBar.TabIndex = 3
        Me.InformationBar.TabStop = False
        '
        'WorkAreaPanel
        '
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupLabel)
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.ClientInActivateCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.ClientNameLabel)
        Me.WorkAreaPanel.Controls.Add(Me.ClientNameTextBox)
        Me.WorkAreaPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WorkAreaPanel.Location = New System.Drawing.Point(0, 0)
        Me.WorkAreaPanel.Name = "WorkAreaPanel"
        Me.WorkAreaPanel.Size = New System.Drawing.Size(507, 479)
        Me.WorkAreaPanel.TabIndex = 4
        '
        'ClientGroupLabel
        '
        Me.ClientGroupLabel.AutoSize = True
        Me.ClientGroupLabel.Location = New System.Drawing.Point(52, 81)
        Me.ClientGroupLabel.Name = "ClientGroupLabel"
        Me.ClientGroupLabel.Size = New System.Drawing.Size(65, 13)
        Me.ClientGroupLabel.TabIndex = 8
        Me.ClientGroupLabel.Text = "Client Group"
        '
        'ClientGroupComboBox
        '
        Me.ClientGroupComboBox.FormattingEnabled = True
        Me.ClientGroupComboBox.Location = New System.Drawing.Point(123, 78)
        Me.ClientGroupComboBox.Name = "ClientGroupComboBox"
        Me.ClientGroupComboBox.Size = New System.Drawing.Size(257, 21)
        Me.ClientGroupComboBox.TabIndex = 7
        '
        'ClientInActivateCheckBox
        '
        Me.ClientInActivateCheckBox.AutoSize = True
        Me.ClientInActivateCheckBox.Checked = True
        Me.ClientInActivateCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.ClientInActivateCheckBox.Location = New System.Drawing.Point(123, 105)
        Me.ClientInActivateCheckBox.Name = "ClientInActivateCheckBox"
        Me.ClientInActivateCheckBox.Size = New System.Drawing.Size(103, 17)
        Me.ClientInActivateCheckBox.TabIndex = 6
        Me.ClientInActivateCheckBox.Text = "InActivate Client"
        Me.ClientInActivateCheckBox.UseVisualStyleBackColor = True
        '
        'ClientNameLabel
        '
        Me.ClientNameLabel.AutoSize = True
        Me.ClientNameLabel.Location = New System.Drawing.Point(52, 55)
        Me.ClientNameLabel.Name = "ClientNameLabel"
        Me.ClientNameLabel.Size = New System.Drawing.Size(64, 13)
        Me.ClientNameLabel.TabIndex = 2
        Me.ClientNameLabel.Text = "Client Name"
        '
        'ClientNameTextBox
        '
        Me.ClientNameTextBox.Location = New System.Drawing.Point(123, 52)
        Me.ClientNameTextBox.MaxLength = 40
        Me.ClientNameTextBox.Name = "ClientNameTextBox"
        Me.ClientNameTextBox.Size = New System.Drawing.Size(257, 20)
        Me.ClientNameTextBox.TabIndex = 3
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 479)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(507, 32)
        Me.BottomPanel.TabIndex = 5
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(328, 3)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(409, 3)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'ClientGroupBindingSource
        '
        Me.ClientGroupBindingSource.AllowNew = True
        Me.ClientGroupBindingSource.DataSource = GetType(Nrc.Qualisys.Library.ClientGroup)
        '
        'ClientSection
        '
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.WorkAreaPanel)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "ClientSection"
        Me.Size = New System.Drawing.Size(507, 511)
        Me.WorkAreaPanel.ResumeLayout(False)
        Me.WorkAreaPanel.PerformLayout()
        Me.BottomPanel.ResumeLayout(False)
        CType(Me.ClientGroupBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents WorkAreaPanel As System.Windows.Forms.Panel
    Friend WithEvents ClientInActivateCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents ClientNameLabel As System.Windows.Forms.Label
    Friend WithEvents ClientNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents ClientGroupLabel As System.Windows.Forms.Label
    Friend WithEvents ClientGroupComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents ClientGroupBindingSource As System.Windows.Forms.BindingSource

End Class
