<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BusinessRulesEditor
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(BusinessRulesEditor))
        Me.MiscRulesContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.AddRuleToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditRuleToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RemoveRuleToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DQRulesContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.NewExceptionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditExceptionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RemoveExceptionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.BodyPanel = New System.Windows.Forms.Panel
        Me.SplitContainer = New System.Windows.Forms.SplitContainer
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.MiscRulesListView = New System.Windows.Forms.ListView
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.DQRulesListView = New System.Windows.Forms.ListView
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.SectionPanel3 = New Nrc.Framework.WinForms.SectionPanel
        Me.HouseholdingTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.AddRemovePanel = New System.Windows.Forms.Panel
        Me.RemoveButton = New System.Windows.Forms.Button
        Me.AddButton = New System.Windows.Forms.Button
        Me.AvaialableFieldsPanel = New System.Windows.Forms.Panel
        Me.AvailableFieldsListBox = New System.Windows.Forms.ListBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.SelectedFieldsPanel = New System.Windows.Forms.Panel
        Me.SelectedFieldsListBox = New System.Windows.Forms.ListBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.HouseholdingHeaderStrip = New Nrc.Framework.WinForms.HeaderStrip
        Me.NoHouseholdingToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.AllHouseholdingToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.MinorsOnlyHouseholdingToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar
        Me.MiscRulesContextMenuStrip.SuspendLayout()
        Me.DQRulesContextMenuStrip.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        Me.BodyPanel.SuspendLayout()
        Me.SplitContainer.Panel1.SuspendLayout()
        Me.SplitContainer.Panel2.SuspendLayout()
        Me.SplitContainer.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.HouseholdingTableLayoutPanel.SuspendLayout()
        Me.AddRemovePanel.SuspendLayout()
        Me.AvaialableFieldsPanel.SuspendLayout()
        Me.SelectedFieldsPanel.SuspendLayout()
        Me.HouseholdingHeaderStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'MiscRulesContextMenuStrip
        '
        Me.MiscRulesContextMenuStrip.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MiscRulesContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddRuleToolStripMenuItem, Me.EditRuleToolStripMenuItem, Me.RemoveRuleToolStripMenuItem})
        Me.MiscRulesContextMenuStrip.Name = "MiscRulesContextMenuStrip"
        Me.MiscRulesContextMenuStrip.Size = New System.Drawing.Size(187, 70)
        '
        'AddRuleToolStripMenuItem
        '
        Me.AddRuleToolStripMenuItem.Name = "AddRuleToolStripMenuItem"
        Me.AddRuleToolStripMenuItem.Size = New System.Drawing.Size(186, 22)
        Me.AddRuleToolStripMenuItem.Text = "Add Rule Criteria"
        '
        'EditRuleToolStripMenuItem
        '
        Me.EditRuleToolStripMenuItem.Name = "EditRuleToolStripMenuItem"
        Me.EditRuleToolStripMenuItem.Size = New System.Drawing.Size(186, 22)
        Me.EditRuleToolStripMenuItem.Text = "Edit Rule Criteria"
        '
        'RemoveRuleToolStripMenuItem
        '
        Me.RemoveRuleToolStripMenuItem.Name = "RemoveRuleToolStripMenuItem"
        Me.RemoveRuleToolStripMenuItem.Size = New System.Drawing.Size(186, 22)
        Me.RemoveRuleToolStripMenuItem.Text = "Remove Rule Criteria"
        '
        'DQRulesContextMenuStrip
        '
        Me.DQRulesContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewExceptionToolStripMenuItem, Me.EditExceptionToolStripMenuItem, Me.RemoveExceptionToolStripMenuItem})
        Me.DQRulesContextMenuStrip.Name = "DQRulesContextMenuStrip"
        Me.DQRulesContextMenuStrip.Size = New System.Drawing.Size(167, 70)
        '
        'NewExceptionToolStripMenuItem
        '
        Me.NewExceptionToolStripMenuItem.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.NewExceptionToolStripMenuItem.Name = "NewExceptionToolStripMenuItem"
        Me.NewExceptionToolStripMenuItem.Size = New System.Drawing.Size(166, 22)
        Me.NewExceptionToolStripMenuItem.Text = "New DQ Rule"
        '
        'EditExceptionToolStripMenuItem
        '
        Me.EditExceptionToolStripMenuItem.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.EditExceptionToolStripMenuItem.Name = "EditExceptionToolStripMenuItem"
        Me.EditExceptionToolStripMenuItem.Size = New System.Drawing.Size(166, 22)
        Me.EditExceptionToolStripMenuItem.Text = "Edit DQ Rule"
        '
        'RemoveExceptionToolStripMenuItem
        '
        Me.RemoveExceptionToolStripMenuItem.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RemoveExceptionToolStripMenuItem.Name = "RemoveExceptionToolStripMenuItem"
        Me.RemoveExceptionToolStripMenuItem.Size = New System.Drawing.Size(166, 22)
        Me.RemoveExceptionToolStripMenuItem.Text = "Remove DQ Rule"
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 578)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(665, 35)
        Me.BottomPanel.TabIndex = 3
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(501, 5)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(582, 5)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'BodyPanel
        '
        Me.BodyPanel.Controls.Add(Me.SplitContainer)
        Me.BodyPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.BodyPanel.Location = New System.Drawing.Point(0, 20)
        Me.BodyPanel.Name = "BodyPanel"
        Me.BodyPanel.Size = New System.Drawing.Size(665, 558)
        Me.BodyPanel.TabIndex = 6
        '
        'SplitContainer
        '
        Me.SplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer.Name = "SplitContainer"
        Me.SplitContainer.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer.Panel1
        '
        Me.SplitContainer.Panel1.Controls.Add(Me.SectionPanel2)
        Me.SplitContainer.Panel1.Controls.Add(Me.SectionPanel1)
        '
        'SplitContainer.Panel2
        '
        Me.SplitContainer.Panel2.Controls.Add(Me.SectionPanel3)
        Me.SplitContainer.Size = New System.Drawing.Size(665, 558)
        Me.SplitContainer.SplitterDistance = 344
        Me.SplitContainer.TabIndex = 5
        '
        'SectionPanel2
        '
        Me.SectionPanel2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = "Misc Rules"
        Me.SectionPanel2.Controls.Add(Me.MiscRulesListView)
        Me.SectionPanel2.Location = New System.Drawing.Point(6, 203)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(653, 140)
        Me.SectionPanel2.TabIndex = 1
        '
        'MiscRulesListView
        '
        Me.MiscRulesListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MiscRulesListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader3, Me.ColumnHeader4})
        Me.MiscRulesListView.ContextMenuStrip = Me.MiscRulesContextMenuStrip
        Me.MiscRulesListView.FullRowSelect = True
        Me.MiscRulesListView.GridLines = True
        Me.MiscRulesListView.Location = New System.Drawing.Point(1, 27)
        Me.MiscRulesListView.MultiSelect = False
        Me.MiscRulesListView.Name = "MiscRulesListView"
        Me.MiscRulesListView.Size = New System.Drawing.Size(651, 112)
        Me.MiscRulesListView.TabIndex = 1
        Me.MiscRulesListView.UseCompatibleStateImageBehavior = False
        Me.MiscRulesListView.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Rule Name"
        Me.ColumnHeader3.Width = 250
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "Rule Criteria"
        Me.ColumnHeader4.Width = 2000
        '
        'SectionPanel1
        '
        Me.SectionPanel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "DQ Rules"
        Me.SectionPanel1.Controls.Add(Me.DQRulesListView)
        Me.SectionPanel1.Location = New System.Drawing.Point(6, 6)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(653, 191)
        Me.SectionPanel1.TabIndex = 0
        '
        'DQRulesListView
        '
        Me.DQRulesListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DQRulesListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1, Me.ColumnHeader2})
        Me.DQRulesListView.ContextMenuStrip = Me.DQRulesContextMenuStrip
        Me.DQRulesListView.FullRowSelect = True
        Me.DQRulesListView.GridLines = True
        Me.DQRulesListView.Location = New System.Drawing.Point(1, 27)
        Me.DQRulesListView.Name = "DQRulesListView"
        Me.DQRulesListView.Size = New System.Drawing.Size(651, 163)
        Me.DQRulesListView.TabIndex = 1
        Me.DQRulesListView.UseCompatibleStateImageBehavior = False
        Me.DQRulesListView.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "Rule Name"
        Me.ColumnHeader1.Width = 250
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Rule Criteria"
        Me.ColumnHeader2.Width = 2000
        '
        'SectionPanel3
        '
        Me.SectionPanel3.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel3.Caption = "Householding"
        Me.SectionPanel3.Controls.Add(Me.HouseholdingTableLayoutPanel)
        Me.SectionPanel3.Controls.Add(Me.HouseholdingHeaderStrip)
        Me.SectionPanel3.Location = New System.Drawing.Point(6, 1)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel3.ShowCaption = True
        Me.SectionPanel3.Size = New System.Drawing.Size(653, 202)
        Me.SectionPanel3.TabIndex = 1
        '
        'HouseholdingTableLayoutPanel
        '
        Me.HouseholdingTableLayoutPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HouseholdingTableLayoutPanel.ColumnCount = 3
        Me.HouseholdingTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.HouseholdingTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 48.0!))
        Me.HouseholdingTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.HouseholdingTableLayoutPanel.Controls.Add(Me.AddRemovePanel, 1, 0)
        Me.HouseholdingTableLayoutPanel.Controls.Add(Me.AvaialableFieldsPanel, 0, 0)
        Me.HouseholdingTableLayoutPanel.Controls.Add(Me.SelectedFieldsPanel, 2, 0)
        Me.HouseholdingTableLayoutPanel.Location = New System.Drawing.Point(1, 54)
        Me.HouseholdingTableLayoutPanel.Name = "HouseholdingTableLayoutPanel"
        Me.HouseholdingTableLayoutPanel.Padding = New System.Windows.Forms.Padding(5)
        Me.HouseholdingTableLayoutPanel.RowCount = 1
        Me.HouseholdingTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.HouseholdingTableLayoutPanel.Size = New System.Drawing.Size(651, 147)
        Me.HouseholdingTableLayoutPanel.TabIndex = 6
        '
        'AddRemovePanel
        '
        Me.AddRemovePanel.Controls.Add(Me.RemoveButton)
        Me.AddRemovePanel.Controls.Add(Me.AddButton)
        Me.AddRemovePanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AddRemovePanel.Location = New System.Drawing.Point(304, 8)
        Me.AddRemovePanel.Name = "AddRemovePanel"
        Me.AddRemovePanel.Size = New System.Drawing.Size(42, 131)
        Me.AddRemovePanel.TabIndex = 0
        '
        'RemoveButton
        '
        Me.RemoveButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.RemoveButton.Image = CType(resources.GetObject("RemoveButton.Image"), System.Drawing.Image)
        Me.RemoveButton.Location = New System.Drawing.Point(3, 70)
        Me.RemoveButton.Name = "RemoveButton"
        Me.RemoveButton.Size = New System.Drawing.Size(37, 33)
        Me.RemoveButton.TabIndex = 1
        Me.RemoveButton.UseVisualStyleBackColor = True
        '
        'AddButton
        '
        Me.AddButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.AddButton.Image = CType(resources.GetObject("AddButton.Image"), System.Drawing.Image)
        Me.AddButton.Location = New System.Drawing.Point(3, 28)
        Me.AddButton.Name = "AddButton"
        Me.AddButton.Size = New System.Drawing.Size(37, 36)
        Me.AddButton.TabIndex = 0
        Me.AddButton.UseVisualStyleBackColor = True
        '
        'AvaialableFieldsPanel
        '
        Me.AvaialableFieldsPanel.Controls.Add(Me.AvailableFieldsListBox)
        Me.AvaialableFieldsPanel.Controls.Add(Me.Label1)
        Me.AvaialableFieldsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AvaialableFieldsPanel.Location = New System.Drawing.Point(8, 8)
        Me.AvaialableFieldsPanel.Name = "AvaialableFieldsPanel"
        Me.AvaialableFieldsPanel.Size = New System.Drawing.Size(290, 131)
        Me.AvaialableFieldsPanel.TabIndex = 3
        '
        'AvailableFieldsListBox
        '
        Me.AvailableFieldsListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AvailableFieldsListBox.FormattingEnabled = True
        Me.AvailableFieldsListBox.IntegralHeight = False
        Me.AvailableFieldsListBox.Location = New System.Drawing.Point(0, 16)
        Me.AvailableFieldsListBox.Name = "AvailableFieldsListBox"
        Me.AvailableFieldsListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.AvailableFieldsListBox.Size = New System.Drawing.Size(290, 115)
        Me.AvailableFieldsListBox.TabIndex = 5
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(0, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(84, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Avaialble Fields:"
        '
        'SelectedFieldsPanel
        '
        Me.SelectedFieldsPanel.Controls.Add(Me.SelectedFieldsListBox)
        Me.SelectedFieldsPanel.Controls.Add(Me.Label2)
        Me.SelectedFieldsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SelectedFieldsPanel.Location = New System.Drawing.Point(352, 8)
        Me.SelectedFieldsPanel.Name = "SelectedFieldsPanel"
        Me.SelectedFieldsPanel.Size = New System.Drawing.Size(291, 131)
        Me.SelectedFieldsPanel.TabIndex = 4
        '
        'SelectedFieldsListBox
        '
        Me.SelectedFieldsListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SelectedFieldsListBox.FormattingEnabled = True
        Me.SelectedFieldsListBox.IntegralHeight = False
        Me.SelectedFieldsListBox.Location = New System.Drawing.Point(0, 16)
        Me.SelectedFieldsListBox.Name = "SelectedFieldsListBox"
        Me.SelectedFieldsListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.SelectedFieldsListBox.Size = New System.Drawing.Size(291, 115)
        Me.SelectedFieldsListBox.TabIndex = 2
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(0, 0)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(82, 13)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Selected Fields:"
        '
        'HouseholdingHeaderStrip
        '
        Me.HouseholdingHeaderStrip.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HouseholdingHeaderStrip.AutoSize = False
        Me.HouseholdingHeaderStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.HouseholdingHeaderStrip.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HouseholdingHeaderStrip.ForeColor = System.Drawing.Color.Black
        Me.HouseholdingHeaderStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HouseholdingHeaderStrip.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HouseholdingHeaderStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NoHouseholdingToolStripButton, Me.ToolStripSeparator1, Me.AllHouseholdingToolStripButton, Me.ToolStripSeparator2, Me.MinorsOnlyHouseholdingToolStripButton})
        Me.HouseholdingHeaderStrip.Location = New System.Drawing.Point(1, 27)
        Me.HouseholdingHeaderStrip.Name = "HouseholdingHeaderStrip"
        Me.HouseholdingHeaderStrip.Size = New System.Drawing.Size(651, 27)
        Me.HouseholdingHeaderStrip.TabIndex = 1
        '
        'NoHouseholdingToolStripButton
        '
        Me.NoHouseholdingToolStripButton.Checked = True
        Me.NoHouseholdingToolStripButton.CheckState = System.Windows.Forms.CheckState.Checked
        Me.NoHouseholdingToolStripButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.NoHouseholding16
        Me.NoHouseholdingToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NoHouseholdingToolStripButton.Name = "NoHouseholdingToolStripButton"
        Me.NoHouseholdingToolStripButton.Size = New System.Drawing.Size(52, 24)
        Me.NoHouseholdingToolStripButton.Text = "None"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 27)
        '
        'AllHouseholdingToolStripButton
        '
        Me.AllHouseholdingToolStripButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.AllHouseholding16
        Me.AllHouseholdingToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.AllHouseholdingToolStripButton.Name = "AllHouseholdingToolStripButton"
        Me.AllHouseholdingToolStripButton.Size = New System.Drawing.Size(38, 24)
        Me.AllHouseholdingToolStripButton.Text = "All"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 27)
        '
        'MinorsOnlyHouseholdingToolStripButton
        '
        Me.MinorsOnlyHouseholdingToolStripButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.MinorsOnlyHouseholding16
        Me.MinorsOnlyHouseholdingToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MinorsOnlyHouseholdingToolStripButton.Name = "MinorsOnlyHouseholdingToolStripButton"
        Me.MinorsOnlyHouseholdingToolStripButton.Size = New System.Drawing.Size(83, 24)
        Me.MinorsOnlyHouseholdingToolStripButton.Text = "Minors Only"
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = "Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(665, 20)
        Me.InformationBar.TabIndex = 5
        '
        'BusinessRulesEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoScroll = True
        Me.Controls.Add(Me.BodyPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(5, 5)
        Me.MinimumSize = New System.Drawing.Size(400, 360)
        Me.Name = "BusinessRulesEditor"
        Me.Size = New System.Drawing.Size(665, 613)
        Me.MiscRulesContextMenuStrip.ResumeLayout(False)
        Me.DQRulesContextMenuStrip.ResumeLayout(False)
        Me.BottomPanel.ResumeLayout(False)
        Me.BodyPanel.ResumeLayout(False)
        Me.SplitContainer.Panel1.ResumeLayout(False)
        Me.SplitContainer.Panel2.ResumeLayout(False)
        Me.SplitContainer.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.HouseholdingTableLayoutPanel.ResumeLayout(False)
        Me.AddRemovePanel.ResumeLayout(False)
        Me.AvaialableFieldsPanel.ResumeLayout(False)
        Me.AvaialableFieldsPanel.PerformLayout()
        Me.SelectedFieldsPanel.ResumeLayout(False)
        Me.SelectedFieldsPanel.PerformLayout()
        Me.HouseholdingHeaderStrip.ResumeLayout(False)
        Me.HouseholdingHeaderStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents DQRulesContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents NewExceptionToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RemoveExceptionToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MiscRulesContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents EditExceptionToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AddRuleToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditRuleToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RemoveRuleToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents BodyPanel As System.Windows.Forms.Panel
    Friend WithEvents SplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MiscRulesListView As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents DQRulesListView As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents SectionPanel3 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents HouseholdingTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents AddRemovePanel As System.Windows.Forms.Panel
    Friend WithEvents RemoveButton As System.Windows.Forms.Button
    Friend WithEvents AddButton As System.Windows.Forms.Button
    Friend WithEvents AvaialableFieldsPanel As System.Windows.Forms.Panel
    Friend WithEvents AvailableFieldsListBox As System.Windows.Forms.ListBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents SelectedFieldsPanel As System.Windows.Forms.Panel
    Friend WithEvents SelectedFieldsListBox As System.Windows.Forms.ListBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents HouseholdingHeaderStrip As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents NoHouseholdingToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents AllHouseholdingToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MinorsOnlyHouseholdingToolStripButton As System.Windows.Forms.ToolStripButton

End Class
