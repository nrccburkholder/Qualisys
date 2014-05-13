<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OrgUnitNavigator
    Inherits Navigator

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
        Me.GroupBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MainPanel = New System.Windows.Forms.SplitContainer
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.OrgUnitTree = New System.Windows.Forms.TreeView
        Me.OrgUnitMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.NewOrganizationMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.EditPropertiesMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditPrivilegesMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditSurveyAccessMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator4 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteOrganizationMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.SearchTextbox = New System.Windows.Forms.TextBox
        Me.SearchButton = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.OrgUnitHeaderStrip = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.GroupGridControl = New DevExpress.XtraGrid.GridControl
        Me.GroupGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GroupHeaderStrip = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.NewOrgUnitButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.OrgUnitPropertiesButton = New System.Windows.Forms.ToolStripButton
        Me.OrgUnitPrivilegesButton = New System.Windows.Forms.ToolStripButton
        Me.SurveyAccessButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteOrgUnitButton = New System.Windows.Forms.ToolStripButton
        Me.MoveOrganizationMenuItem = New System.Windows.Forms.ToolStripMenuItem
        CType(Me.GroupBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MainPanel.Panel1.SuspendLayout()
        Me.MainPanel.Panel2.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.OrgUnitMenu.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.OrgUnitHeaderStrip.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        CType(Me.GroupGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GroupGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupHeaderStrip.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainPanel
        '
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.Location = New System.Drawing.Point(0, 25)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'MainPanel.Panel1
        '
        Me.MainPanel.Panel1.Controls.Add(Me.SectionPanel1)
        '
        'MainPanel.Panel2
        '
        Me.MainPanel.Panel2.Controls.Add(Me.SectionPanel2)
        Me.MainPanel.Size = New System.Drawing.Size(215, 454)
        Me.MainPanel.SplitterDistance = 268
        Me.MainPanel.TabIndex = 3
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Controls.Add(Me.OrgUnitTree)
        Me.SectionPanel1.Controls.Add(Me.Panel1)
        Me.SectionPanel1.Controls.Add(Me.OrgUnitHeaderStrip)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = False
        Me.SectionPanel1.Size = New System.Drawing.Size(215, 268)
        Me.SectionPanel1.TabIndex = 6
        '
        'OrgUnitTree
        '
        Me.OrgUnitTree.ContextMenuStrip = Me.OrgUnitMenu
        Me.OrgUnitTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.OrgUnitTree.HideSelection = False
        Me.OrgUnitTree.Location = New System.Drawing.Point(1, 46)
        Me.OrgUnitTree.Name = "OrgUnitTree"
        Me.OrgUnitTree.Size = New System.Drawing.Size(213, 221)
        Me.OrgUnitTree.TabIndex = 1
        '
        'OrgUnitMenu
        '
        Me.OrgUnitMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewOrganizationMenuItem, Me.ToolStripSeparator2, Me.EditPropertiesMenuItem, Me.EditPrivilegesMenuItem, Me.EditSurveyAccessMenuItem, Me.MoveOrganizationMenuItem, Me.ToolStripSeparator4, Me.DeleteOrganizationMenuItem})
        Me.OrgUnitMenu.Name = "ContextMenuStrip"
        Me.OrgUnitMenu.Size = New System.Drawing.Size(178, 170)
        '
        'NewOrganizationMenuItem
        '
        Me.NewOrganizationMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.New16
        Me.NewOrganizationMenuItem.Name = "NewOrganizationMenuItem"
        Me.NewOrganizationMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.NewOrganizationMenuItem.Text = "New Organization..."
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(174, 6)
        '
        'EditPropertiesMenuItem
        '
        Me.EditPropertiesMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Properties16
        Me.EditPropertiesMenuItem.Name = "EditPropertiesMenuItem"
        Me.EditPropertiesMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.EditPropertiesMenuItem.Text = "Edit Properties..."
        '
        'EditPrivilegesMenuItem
        '
        Me.EditPrivilegesMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Privileges16
        Me.EditPrivilegesMenuItem.Name = "EditPrivilegesMenuItem"
        Me.EditPrivilegesMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.EditPrivilegesMenuItem.Text = "Edit Privileges..."
        '
        'EditSurveyAccessMenuItem
        '
        Me.EditSurveyAccessMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.SurveyAccess16
        Me.EditSurveyAccessMenuItem.Name = "EditSurveyAccessMenuItem"
        Me.EditSurveyAccessMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.EditSurveyAccessMenuItem.Text = "Edit Survey Access..."
        '
        'ToolStripSeparator4
        '
        Me.ToolStripSeparator4.Name = "ToolStripSeparator4"
        Me.ToolStripSeparator4.Size = New System.Drawing.Size(174, 6)
        '
        'DeleteOrganizationMenuItem
        '
        Me.DeleteOrganizationMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Delete16
        Me.DeleteOrganizationMenuItem.Name = "DeleteOrganizationMenuItem"
        Me.DeleteOrganizationMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.DeleteOrganizationMenuItem.Text = "Delete Organization"
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.SearchTextbox)
        Me.Panel1.Controls.Add(Me.SearchButton)
        Me.Panel1.Controls.Add(Me.Label1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(1, 20)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(213, 26)
        Me.Panel1.TabIndex = 5
        '
        'SearchTextbox
        '
        Me.SearchTextbox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchTextbox.Location = New System.Drawing.Point(47, 3)
        Me.SearchTextbox.Name = "SearchTextbox"
        Me.SearchTextbox.Size = New System.Drawing.Size(133, 20)
        Me.SearchTextbox.TabIndex = 2
        '
        'SearchButton
        '
        Me.SearchButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchButton.Enabled = False
        Me.SearchButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Search16
        Me.SearchButton.Location = New System.Drawing.Point(183, 2)
        Me.SearchButton.Name = "SearchButton"
        Me.SearchButton.Size = New System.Drawing.Size(27, 23)
        Me.SearchButton.TabIndex = 3
        Me.SearchButton.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.Color.Transparent
        Me.Label1.Location = New System.Drawing.Point(4, 7)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(41, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Search"
        '
        'OrgUnitHeaderStrip
        '
        Me.OrgUnitHeaderStrip.AutoSize = False
        Me.OrgUnitHeaderStrip.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.OrgUnitHeaderStrip.ForeColor = System.Drawing.Color.Black
        Me.OrgUnitHeaderStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.OrgUnitHeaderStrip.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.OrgUnitHeaderStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.OrgUnitHeaderStrip.Location = New System.Drawing.Point(1, 1)
        Me.OrgUnitHeaderStrip.Name = "OrgUnitHeaderStrip"
        Me.OrgUnitHeaderStrip.Size = New System.Drawing.Size(213, 19)
        Me.OrgUnitHeaderStrip.TabIndex = 3
        Me.OrgUnitHeaderStrip.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(103, 16)
        Me.ToolStripLabel1.Text = "Organizational Units"
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = ""
        Me.SectionPanel2.Controls.Add(Me.GroupGridControl)
        Me.SectionPanel2.Controls.Add(Me.GroupHeaderStrip)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = False
        Me.SectionPanel2.Size = New System.Drawing.Size(215, 182)
        Me.SectionPanel2.TabIndex = 6
        '
        'GroupGridControl
        '
        Me.GroupGridControl.DataSource = Me.GroupBindingSource
        Me.GroupGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        '
        '
        '
        Me.GroupGridControl.EmbeddedNavigator.Name = ""
        Me.GroupGridControl.Location = New System.Drawing.Point(1, 20)
        Me.GroupGridControl.MainView = Me.GroupGridView
        Me.GroupGridControl.Name = "GroupGridControl"
        Me.GroupGridControl.ShowOnlyPredefinedDetails = True
        Me.GroupGridControl.Size = New System.Drawing.Size(213, 161)
        Me.GroupGridControl.TabIndex = 5
        Me.GroupGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GroupGridView})
        '
        'GroupGridView
        '
        Me.GroupGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colName})
        Me.GroupGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.GroupGridView.GridControl = Me.GroupGridControl
        Me.GroupGridView.GroupSummary.AddRange(New DevExpress.XtraGrid.GridSummaryItem() {New DevExpress.XtraGrid.GridGroupSummaryItem(DevExpress.Data.SummaryItemType.Count, "", Nothing, "")})
        Me.GroupGridView.Name = "GroupGridView"
        Me.GroupGridView.OptionsBehavior.Editable = False
        Me.GroupGridView.OptionsCustomization.AllowGroup = False
        Me.GroupGridView.OptionsDetail.AllowZoomDetail = False
        Me.GroupGridView.OptionsDetail.EnableMasterViewMode = False
        Me.GroupGridView.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.GroupGridView.OptionsView.ShowAutoFilterRow = True
        Me.GroupGridView.OptionsView.ShowDetailButtons = False
        Me.GroupGridView.OptionsView.ShowGroupPanel = False
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 0
        '
        'GroupHeaderStrip
        '
        Me.GroupHeaderStrip.AutoSize = False
        Me.GroupHeaderStrip.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.GroupHeaderStrip.ForeColor = System.Drawing.Color.Black
        Me.GroupHeaderStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.GroupHeaderStrip.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.GroupHeaderStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel2})
        Me.GroupHeaderStrip.Location = New System.Drawing.Point(1, 1)
        Me.GroupHeaderStrip.Name = "GroupHeaderStrip"
        Me.GroupHeaderStrip.Size = New System.Drawing.Size(213, 19)
        Me.GroupHeaderStrip.TabIndex = 4
        Me.GroupHeaderStrip.Text = "HeaderStrip2"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(66, 16)
        Me.ToolStripLabel2.Text = "User Groups"
        '
        'ToolStrip1
        '
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewOrgUnitButton, Me.ToolStripSeparator1, Me.OrgUnitPropertiesButton, Me.OrgUnitPrivilegesButton, Me.SurveyAccessButton, Me.ToolStripSeparator3, Me.DeleteOrgUnitButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(215, 25)
        Me.ToolStrip1.TabIndex = 5
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'NewOrgUnitButton
        '
        Me.NewOrgUnitButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.NewOrgUnitButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.New16
        Me.NewOrgUnitButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NewOrgUnitButton.Name = "NewOrgUnitButton"
        Me.NewOrgUnitButton.Size = New System.Drawing.Size(23, 22)
        Me.NewOrgUnitButton.Text = "New Organization"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'OrgUnitPropertiesButton
        '
        Me.OrgUnitPropertiesButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.OrgUnitPropertiesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Properties16
        Me.OrgUnitPropertiesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OrgUnitPropertiesButton.Name = "OrgUnitPropertiesButton"
        Me.OrgUnitPropertiesButton.Size = New System.Drawing.Size(23, 22)
        Me.OrgUnitPropertiesButton.Text = "Properties"
        '
        'OrgUnitPrivilegesButton
        '
        Me.OrgUnitPrivilegesButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.OrgUnitPrivilegesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Privileges16
        Me.OrgUnitPrivilegesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OrgUnitPrivilegesButton.Name = "OrgUnitPrivilegesButton"
        Me.OrgUnitPrivilegesButton.Size = New System.Drawing.Size(23, 22)
        Me.OrgUnitPrivilegesButton.Text = "Privileges"
        '
        'SurveyAccessButton
        '
        Me.SurveyAccessButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.SurveyAccessButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.SurveyAccess16
        Me.SurveyAccessButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SurveyAccessButton.Name = "SurveyAccessButton"
        Me.SurveyAccessButton.Size = New System.Drawing.Size(23, 22)
        Me.SurveyAccessButton.Text = "Survey Access"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'DeleteOrgUnitButton
        '
        Me.DeleteOrgUnitButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DeleteOrgUnitButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Delete16
        Me.DeleteOrgUnitButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteOrgUnitButton.Name = "DeleteOrgUnitButton"
        Me.DeleteOrgUnitButton.Size = New System.Drawing.Size(23, 22)
        Me.DeleteOrgUnitButton.Text = "Delete Organization"
        '
        'MoveOrganizationMenuItem
        '
        Me.MoveOrganizationMenuItem.Name = "MoveOrganizationMenuItem"
        Me.MoveOrganizationMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.MoveOrganizationMenuItem.Text = "Move Organization..."
        '
        'OrgUnitNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.MainPanel)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Name = "OrgUnitNavigator"
        Me.Size = New System.Drawing.Size(215, 479)
        CType(Me.GroupBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MainPanel.Panel1.ResumeLayout(False)
        Me.MainPanel.Panel2.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.OrgUnitMenu.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.OrgUnitHeaderStrip.ResumeLayout(False)
        Me.OrgUnitHeaderStrip.PerformLayout()
        Me.SectionPanel2.ResumeLayout(False)
        CType(Me.GroupGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GroupGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupHeaderStrip.ResumeLayout(False)
        Me.GroupHeaderStrip.PerformLayout()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MainPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents OrgUnitTree As System.Windows.Forms.TreeView
    Friend WithEvents GroupBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents SearchButton As System.Windows.Forms.Button
    Friend WithEvents SearchTextbox As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents OrgUnitHeaderStrip As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupHeaderStrip As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents GroupGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents OrgUnitMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents NewOrganizationMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents EditPropertiesMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditPrivilegesMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteOrganizationMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents NewOrgUnitButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents OrgUnitPropertiesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OrgUnitPrivilegesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteOrgUnitButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SurveyAccessButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents EditSurveyAccessMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MoveOrganizationMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
