<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MemberGroupEditor
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
        Me.MainPanel = New System.Windows.Forms.TableLayoutPanel
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.MemberGroups = New Nrc.NrcAuthAdmin.GroupGrid
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.OrgUnitGroups = New Nrc.NrcAuthAdmin.GroupGrid
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.RemoveButton = New System.Windows.Forms.Button
        Me.AddButton = New System.Windows.Forms.Button
        Me.MainPanel.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
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
        Me.MainPanel.Size = New System.Drawing.Size(650, 326)
        Me.MainPanel.TabIndex = 2
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = "Member's Groups"
        Me.SectionPanel2.Controls.Add(Me.MemberGroups)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.Location = New System.Drawing.Point(353, 3)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(294, 320)
        Me.SectionPanel2.TabIndex = 0
        '
        'MemberGroups
        '
        Me.MemberGroups.AllowCreateNewGroup = True
        Me.MemberGroups.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MemberGroups.IsAbbreviated = True
        Me.MemberGroups.Location = New System.Drawing.Point(1, 27)
        Me.MemberGroups.MultiSelect = True
        Me.MemberGroups.Name = "MemberGroups"
        Me.MemberGroups.ShowToolStrip = False
        Me.MemberGroups.Size = New System.Drawing.Size(292, 292)
        Me.MemberGroups.TabIndex = 2
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Available Groups"
        Me.SectionPanel1.Controls.Add(Me.OrgUnitGroups)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(3, 3)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(294, 320)
        Me.SectionPanel1.TabIndex = 0
        '
        'OrgUnitGroups
        '
        Me.OrgUnitGroups.AllowCreateNewGroup = True
        Me.OrgUnitGroups.Dock = System.Windows.Forms.DockStyle.Fill
        Me.OrgUnitGroups.IsAbbreviated = True
        Me.OrgUnitGroups.Location = New System.Drawing.Point(1, 27)
        Me.OrgUnitGroups.MultiSelect = True
        Me.OrgUnitGroups.Name = "OrgUnitGroups"
        Me.OrgUnitGroups.ShowToolStrip = False
        Me.OrgUnitGroups.Size = New System.Drawing.Size(292, 292)
        Me.OrgUnitGroups.TabIndex = 4
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.RemoveButton)
        Me.Panel1.Controls.Add(Me.AddButton)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(303, 3)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(44, 320)
        Me.Panel1.TabIndex = 1
        '
        'RemoveButton
        '
        Me.RemoveButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.RemoveButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Back32
        Me.RemoveButton.Location = New System.Drawing.Point(3, 160)
        Me.RemoveButton.Name = "RemoveButton"
        Me.RemoveButton.Size = New System.Drawing.Size(36, 36)
        Me.RemoveButton.TabIndex = 1
        Me.RemoveButton.UseVisualStyleBackColor = True
        '
        'AddButton
        '
        Me.AddButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.AddButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Forward32
        Me.AddButton.Location = New System.Drawing.Point(3, 118)
        Me.AddButton.Name = "AddButton"
        Me.AddButton.Size = New System.Drawing.Size(36, 36)
        Me.AddButton.TabIndex = 0
        Me.AddButton.UseVisualStyleBackColor = True
        '
        'MemberGroupEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.MainPanel)
        Me.Name = "MemberGroupEditor"
        Me.Size = New System.Drawing.Size(650, 326)
        Me.MainPanel.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents RemoveButton As System.Windows.Forms.Button
    Friend WithEvents AddButton As System.Windows.Forms.Button
    Friend WithEvents MemberGroups As Nrc.NrcAuthAdmin.GroupGrid
    Friend WithEvents OrgUnitGroups As Nrc.NrcAuthAdmin.GroupGrid

End Class
