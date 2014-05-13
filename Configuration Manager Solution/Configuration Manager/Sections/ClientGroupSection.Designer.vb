<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientGroupSection
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
        Me.ClientGroupInActivateCheckBox = New System.Windows.Forms.CheckBox
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.WorkAreaPanel = New System.Windows.Forms.Panel
        Me.ClientGroupNameLabel = New System.Windows.Forms.Label
        Me.ClientGroupNameTextBox = New System.Windows.Forms.TextBox
        Me.ClientGroupReportNameLabel = New System.Windows.Forms.Label
        Me.ClientGroupReportNameTextBox = New System.Windows.Forms.TextBox
        Me.BottomPanel.SuspendLayout()
        Me.WorkAreaPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'ClientGroupInActivateCheckBox
        '
        Me.ClientGroupInActivateCheckBox.AutoSize = True
        Me.ClientGroupInActivateCheckBox.Checked = True
        Me.ClientGroupInActivateCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.ClientGroupInActivateCheckBox.Location = New System.Drawing.Point(158, 104)
        Me.ClientGroupInActivateCheckBox.Name = "ClientGroupInActivateCheckBox"
        Me.ClientGroupInActivateCheckBox.Size = New System.Drawing.Size(135, 17)
        Me.ClientGroupInActivateCheckBox.TabIndex = 6
        Me.ClientGroupInActivateCheckBox.Text = "InActivate Client Group"
        Me.ClientGroupInActivateCheckBox.UseVisualStyleBackColor = True
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
        Me.InformationBar.TabIndex = 6
        Me.InformationBar.TabStop = False
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
        Me.BottomPanel.TabIndex = 8
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
        'WorkAreaPanel
        '
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupReportNameLabel)
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupReportNameTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupInActivateCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupNameLabel)
        Me.WorkAreaPanel.Controls.Add(Me.ClientGroupNameTextBox)
        Me.WorkAreaPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WorkAreaPanel.Location = New System.Drawing.Point(0, 0)
        Me.WorkAreaPanel.Name = "WorkAreaPanel"
        Me.WorkAreaPanel.Size = New System.Drawing.Size(507, 511)
        Me.WorkAreaPanel.TabIndex = 7
        '
        'ClientGroupNameLabel
        '
        Me.ClientGroupNameLabel.AutoSize = True
        Me.ClientGroupNameLabel.Location = New System.Drawing.Point(21, 55)
        Me.ClientGroupNameLabel.Name = "ClientGroupNameLabel"
        Me.ClientGroupNameLabel.Size = New System.Drawing.Size(96, 13)
        Me.ClientGroupNameLabel.TabIndex = 2
        Me.ClientGroupNameLabel.Text = "Client Group Name"
        '
        'ClientGroupNameTextBox
        '
        Me.ClientGroupNameTextBox.Location = New System.Drawing.Point(158, 52)
        Me.ClientGroupNameTextBox.MaxLength = 40
        Me.ClientGroupNameTextBox.Name = "ClientGroupNameTextBox"
        Me.ClientGroupNameTextBox.Size = New System.Drawing.Size(257, 20)
        Me.ClientGroupNameTextBox.TabIndex = 3
        '
        'ClientGroupReportNameLabel
        '
        Me.ClientGroupReportNameLabel.AutoSize = True
        Me.ClientGroupReportNameLabel.Location = New System.Drawing.Point(21, 81)
        Me.ClientGroupReportNameLabel.Name = "ClientGroupReportNameLabel"
        Me.ClientGroupReportNameLabel.Size = New System.Drawing.Size(131, 13)
        Me.ClientGroupReportNameLabel.TabIndex = 4
        Me.ClientGroupReportNameLabel.Text = "Client Group Report Name"
        '
        'ClientGroupReportNameTextBox
        '
        Me.ClientGroupReportNameTextBox.Location = New System.Drawing.Point(158, 78)
        Me.ClientGroupReportNameTextBox.MaxLength = 40
        Me.ClientGroupReportNameTextBox.Name = "ClientGroupReportNameTextBox"
        Me.ClientGroupReportNameTextBox.Size = New System.Drawing.Size(257, 20)
        Me.ClientGroupReportNameTextBox.TabIndex = 5
        '
        'ClientGroupSection
        '
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.WorkAreaPanel)
        Me.Name = "ClientGroupSection"
        Me.Size = New System.Drawing.Size(507, 511)
        Me.BottomPanel.ResumeLayout(False)
        Me.WorkAreaPanel.ResumeLayout(False)
        Me.WorkAreaPanel.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ClientGroupInActivateCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents WorkAreaPanel As System.Windows.Forms.Panel
    Friend WithEvents ClientGroupNameLabel As System.Windows.Forms.Label
    Friend WithEvents ClientGroupNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents ClientGroupReportNameLabel As System.Windows.Forms.Label
    Friend WithEvents ClientGroupReportNameTextBox As System.Windows.Forms.TextBox

End Class
