<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GroupMemberEditor
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
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.OrgUnitMembers = New Nrc.NrcAuthAdmin.MemberGrid
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.GroupMembers = New Nrc.NrcAuthAdmin.MemberGrid
        Me.MainPanel = New System.Windows.Forms.TableLayoutPanel
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.RemoveButton = New System.Windows.Forms.Button
        Me.AddButton = New System.Windows.Forms.Button
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Available Members"
        Me.SectionPanel1.Controls.Add(Me.OrgUnitMembers)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(3, 3)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(297, 303)
        Me.SectionPanel1.TabIndex = 0
        '
        'OrgUnitMembers
        '
        Me.OrgUnitMembers.AllowCreateNewMember = True
        Me.OrgUnitMembers.Dock = System.Windows.Forms.DockStyle.Fill
        Me.OrgUnitMembers.IsAbbreviated = True
        Me.OrgUnitMembers.Location = New System.Drawing.Point(1, 27)
        Me.OrgUnitMembers.MultiSelect = True
        Me.OrgUnitMembers.Name = "OrgUnitMembers"
        Me.OrgUnitMembers.ShowToolStrip = False
        Me.OrgUnitMembers.Size = New System.Drawing.Size(295, 275)
        Me.OrgUnitMembers.TabIndex = 3
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = "Group Members"
        Me.SectionPanel2.Controls.Add(Me.GroupMembers)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.Location = New System.Drawing.Point(356, 3)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(298, 303)
        Me.SectionPanel2.TabIndex = 0
        '
        'GroupMembers
        '
        Me.GroupMembers.AllowCreateNewMember = True
        Me.GroupMembers.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupMembers.IsAbbreviated = True
        Me.GroupMembers.Location = New System.Drawing.Point(1, 27)
        Me.GroupMembers.MultiSelect = True
        Me.GroupMembers.Name = "GroupMembers"
        Me.GroupMembers.ShowToolStrip = False
        Me.GroupMembers.Size = New System.Drawing.Size(296, 275)
        Me.GroupMembers.TabIndex = 3
        '
        'MainPanel
        '
        Me.MainPanel.ColumnCount = 3
        Me.MainPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.MainPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 50.0!))
        Me.MainPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.MainPanel.Controls.Add(Me.SectionPanel2, 2, 0)
        Me.MainPanel.Controls.Add(Me.SectionPanel1, 0, 0)
        Me.MainPanel.Controls.Add(Me.Panel1, 1, 0)
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.RowCount = 1
        Me.MainPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.MainPanel.Size = New System.Drawing.Size(657, 309)
        Me.MainPanel.TabIndex = 1
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.RemoveButton)
        Me.Panel1.Controls.Add(Me.AddButton)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(306, 3)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(44, 303)
        Me.Panel1.TabIndex = 1
        '
        'RemoveButton
        '
        Me.RemoveButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.RemoveButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Back32
        Me.RemoveButton.Location = New System.Drawing.Point(3, 151)
        Me.RemoveButton.Name = "RemoveButton"
        Me.RemoveButton.Size = New System.Drawing.Size(36, 36)
        Me.RemoveButton.TabIndex = 1
        Me.RemoveButton.UseVisualStyleBackColor = True
        '
        'AddButton
        '
        Me.AddButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.AddButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Forward32
        Me.AddButton.Location = New System.Drawing.Point(3, 109)
        Me.AddButton.Name = "AddButton"
        Me.AddButton.Size = New System.Drawing.Size(36, 36)
        Me.AddButton.TabIndex = 0
        Me.AddButton.UseVisualStyleBackColor = True
        '
        'GroupMemberEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.MainPanel)
        Me.Name = "GroupMemberEditor"
        Me.Size = New System.Drawing.Size(657, 309)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MainPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents RemoveButton As System.Windows.Forms.Button
    Friend WithEvents AddButton As System.Windows.Forms.Button
    Friend WithEvents OrgUnitMembers As Nrc.NrcAuthAdmin.MemberGrid
    Friend WithEvents GroupMembers As Nrc.NrcAuthAdmin.MemberGrid

End Class
