<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class UserManagementSection
    Inherits NrcAuthAdmin.Section

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
        Me.TopPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.MemberGrid = New Nrc.NrcAuthAdmin.MemberGrid
        Me.GroupGrid = New Nrc.NrcAuthAdmin.GroupGrid
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.TopPanelLabel = New System.Windows.Forms.ToolStripLabel
        Me.GroupModeButton = New System.Windows.Forms.ToolStripButton
        Me.MemberModeButton = New System.Windows.Forms.ToolStripButton
        Me.MainSplitPanel = New System.Windows.Forms.SplitContainer
        Me.TopPanel.SuspendLayout()
        Me.HeaderStrip1.SuspendLayout()
        Me.MainSplitPanel.Panel1.SuspendLayout()
        Me.MainSplitPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'TopPanel
        '
        Me.TopPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.TopPanel.Caption = "User Management"
        Me.TopPanel.Controls.Add(Me.MemberGrid)
        Me.TopPanel.Controls.Add(Me.GroupGrid)
        Me.TopPanel.Controls.Add(Me.HeaderStrip1)
        Me.TopPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TopPanel.Location = New System.Drawing.Point(0, 0)
        Me.TopPanel.Name = "TopPanel"
        Me.TopPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.TopPanel.ShowCaption = False
        Me.TopPanel.Size = New System.Drawing.Size(618, 197)
        Me.TopPanel.TabIndex = 0
        '
        'MemberGrid
        '
        Me.MemberGrid.AllowCreateNewMember = True
        Me.MemberGrid.IsAbbreviated = False
        Me.MemberGrid.Location = New System.Drawing.Point(3, 29)
        Me.MemberGrid.MultiSelect = True
        Me.MemberGrid.Name = "MemberGrid"
        Me.MemberGrid.ShowToolStrip = True
        Me.MemberGrid.Size = New System.Drawing.Size(611, 89)
        Me.MemberGrid.TabIndex = 4
        '
        'GroupGrid
        '
        Me.GroupGrid.AllowCreateNewGroup = True
        Me.GroupGrid.IsAbbreviated = False
        Me.GroupGrid.Location = New System.Drawing.Point(4, 124)
        Me.GroupGrid.MultiSelect = True
        Me.GroupGrid.Name = "GroupGrid"
        Me.GroupGrid.ShowToolStrip = True
        Me.GroupGrid.Size = New System.Drawing.Size(610, 69)
        Me.GroupGrid.TabIndex = 3
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TopPanelLabel, Me.GroupModeButton, Me.MemberModeButton})
        Me.HeaderStrip1.Location = New System.Drawing.Point(1, 1)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(616, 25)
        Me.HeaderStrip1.TabIndex = 1
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'TopPanelLabel
        '
        Me.TopPanelLabel.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TopPanelLabel.Name = "TopPanelLabel"
        Me.TopPanelLabel.Size = New System.Drawing.Size(83, 22)
        Me.TopPanelLabel.Text = "Members"
        '
        'GroupModeButton
        '
        Me.GroupModeButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.GroupModeButton.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupModeButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Group32
        Me.GroupModeButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.GroupModeButton.Name = "GroupModeButton"
        Me.GroupModeButton.Size = New System.Drawing.Size(68, 22)
        Me.GroupModeButton.Text = "Groups"
        '
        'MemberModeButton
        '
        Me.MemberModeButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.MemberModeButton.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MemberModeButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Member32
        Me.MemberModeButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MemberModeButton.Name = "MemberModeButton"
        Me.MemberModeButton.Size = New System.Drawing.Size(81, 22)
        Me.MemberModeButton.Text = "Members"
        '
        'MainSplitPanel
        '
        Me.MainSplitPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainSplitPanel.FixedPanel = System.Windows.Forms.FixedPanel.Panel2
        Me.MainSplitPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainSplitPanel.Name = "MainSplitPanel"
        Me.MainSplitPanel.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'MainSplitPanel.Panel1
        '
        Me.MainSplitPanel.Panel1.Controls.Add(Me.TopPanel)
        Me.MainSplitPanel.Size = New System.Drawing.Size(618, 496)
        Me.MainSplitPanel.SplitterDistance = 197
        Me.MainSplitPanel.TabIndex = 1
        '
        'UserManagementSection
        '
        Me.Controls.Add(Me.MainSplitPanel)
        Me.Name = "UserManagementSection"
        Me.Size = New System.Drawing.Size(618, 496)
        Me.TopPanel.ResumeLayout(False)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.MainSplitPanel.Panel1.ResumeLayout(False)
        Me.MainSplitPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents TopPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents TopPanelLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupModeButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MemberModeButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MainSplitPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents GroupGrid As Nrc.NrcAuthAdmin.GroupGrid
    Friend WithEvents MemberGrid As Nrc.NrcAuthAdmin.MemberGrid

End Class
