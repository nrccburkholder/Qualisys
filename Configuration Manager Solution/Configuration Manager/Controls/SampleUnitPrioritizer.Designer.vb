<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SampleUnitPrioritizer
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SampleUnitPrioritizer))
        Me.LeftPanel = New System.Windows.Forms.Panel
        Me.PriorityGroupPanel = New System.Windows.Forms.FlowLayoutPanel
        Me.CommandPanel = New System.Windows.Forms.SplitContainer
        Me.HeaderStrip3 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel3 = New System.Windows.Forms.ToolStripLabel
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.PrioritySampleUnitPanel = New System.Windows.Forms.SplitContainer
        Me.SampleUnitTree = New System.Windows.Forms.TreeView
        Me.SampleUnitContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.HeaderStrip2 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.SampleUnitList = New System.Windows.Forms.ListView
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader(2)
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader("Ghost16.png")
        Me.SmallImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ToolTipControl = New System.Windows.Forms.ToolTip(Me.components)
        Me.PriorityGroupContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripSeparator
        Me.ToolStripMenuItem2 = New System.Windows.Forms.ToolStripSeparator
        Me.ToolStripMenuItem3 = New System.Windows.Forms.ToolStripSeparator
        Me.MoveToMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripMenuItem5 = New System.Windows.Forms.ToolStripMenuItem
        Me.TreeAndListOption = New System.Windows.Forms.RadioButton
        Me.ListOnlyOption = New System.Windows.Forms.RadioButton
        Me.TreeOnlyOption = New System.Windows.Forms.RadioButton
        Me.MoveDownButton = New System.Windows.Forms.Button
        Me.MoveUpButton = New System.Windows.Forms.Button
        Me.AddAboveButton = New System.Windows.Forms.Button
        Me.AddBelowButton = New System.Windows.Forms.Button
        Me.CleanupButton = New System.Windows.Forms.Button
        Me.DeleteGroupButton = New System.Windows.Forms.Button
        Me.MoveUpMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MoveDownMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AddAboveMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AddBelowMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteGroupMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CleanupMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.LeftPanel.SuspendLayout()
        Me.CommandPanel.Panel1.SuspendLayout()
        Me.CommandPanel.Panel2.SuspendLayout()
        Me.CommandPanel.SuspendLayout()
        Me.HeaderStrip3.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        Me.PrioritySampleUnitPanel.Panel1.SuspendLayout()
        Me.PrioritySampleUnitPanel.Panel2.SuspendLayout()
        Me.PrioritySampleUnitPanel.SuspendLayout()
        Me.SampleUnitContextMenu.SuspendLayout()
        Me.HeaderStrip2.SuspendLayout()
        Me.HeaderStrip1.SuspendLayout()
        Me.PriorityGroupContextMenu.SuspendLayout()
        Me.SuspendLayout()
        '
        'LeftPanel
        '
        Me.LeftPanel.Controls.Add(Me.PriorityGroupPanel)
        Me.LeftPanel.Controls.Add(Me.CommandPanel)
        Me.LeftPanel.Controls.Add(Me.HeaderStrip3)
        Me.LeftPanel.Dock = System.Windows.Forms.DockStyle.Left
        Me.LeftPanel.Location = New System.Drawing.Point(0, 0)
        Me.LeftPanel.Name = "LeftPanel"
        Me.LeftPanel.Padding = New System.Windows.Forms.Padding(0, 0, 2, 0)
        Me.LeftPanel.Size = New System.Drawing.Size(122, 575)
        Me.LeftPanel.TabIndex = 0
        '
        'PriorityGroupPanel
        '
        Me.PriorityGroupPanel.AutoScroll = True
        Me.PriorityGroupPanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.PriorityGroupPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PriorityGroupPanel.FlowDirection = System.Windows.Forms.FlowDirection.TopDown
        Me.PriorityGroupPanel.Location = New System.Drawing.Point(0, 22)
        Me.PriorityGroupPanel.Name = "PriorityGroupPanel"
        Me.PriorityGroupPanel.Padding = New System.Windows.Forms.Padding(5)
        Me.PriorityGroupPanel.Size = New System.Drawing.Size(83, 553)
        Me.PriorityGroupPanel.TabIndex = 1
        Me.PriorityGroupPanel.WrapContents = False
        '
        'CommandPanel
        '
        Me.CommandPanel.Dock = System.Windows.Forms.DockStyle.Right
        Me.CommandPanel.IsSplitterFixed = True
        Me.CommandPanel.Location = New System.Drawing.Point(83, 22)
        Me.CommandPanel.Name = "CommandPanel"
        Me.CommandPanel.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'CommandPanel.Panel1
        '
        Me.CommandPanel.Panel1.BackColor = System.Drawing.Color.Transparent
        Me.CommandPanel.Panel1.Controls.Add(Me.MoveDownButton)
        Me.CommandPanel.Panel1.Controls.Add(Me.MoveUpButton)
        Me.CommandPanel.Panel1.Controls.Add(Me.AddAboveButton)
        '
        'CommandPanel.Panel2
        '
        Me.CommandPanel.Panel2.Controls.Add(Me.AddBelowButton)
        Me.CommandPanel.Panel2.Controls.Add(Me.CleanupButton)
        Me.CommandPanel.Panel2.Controls.Add(Me.DeleteGroupButton)
        Me.CommandPanel.Size = New System.Drawing.Size(37, 553)
        Me.CommandPanel.SplitterDistance = 274
        Me.CommandPanel.SplitterWidth = 2
        Me.CommandPanel.TabIndex = 2
        '
        'HeaderStrip3
        '
        Me.HeaderStrip3.AutoSize = False
        Me.HeaderStrip3.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.HeaderStrip3.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip3.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip3.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip3.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel3})
        Me.HeaderStrip3.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip3.Name = "HeaderStrip3"
        Me.HeaderStrip3.Size = New System.Drawing.Size(120, 22)
        Me.HeaderStrip3.TabIndex = 0
        Me.HeaderStrip3.Text = "HeaderStrip3"
        '
        'ToolStripLabel3
        '
        Me.ToolStripLabel3.Name = "ToolStripLabel3"
        Me.ToolStripLabel3.Size = New System.Drawing.Size(86, 19)
        Me.ToolStripLabel3.Text = "Priority Group"
        '
        'BottomPanel
        '
        Me.BottomPanel.Controls.Add(Me.TreeAndListOption)
        Me.BottomPanel.Controls.Add(Me.ListOnlyOption)
        Me.BottomPanel.Controls.Add(Me.TreeOnlyOption)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(122, 544)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(680, 31)
        Me.BottomPanel.TabIndex = 2
        '
        'PrioritySampleUnitPanel
        '
        Me.PrioritySampleUnitPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PrioritySampleUnitPanel.Location = New System.Drawing.Point(122, 0)
        Me.PrioritySampleUnitPanel.Name = "PrioritySampleUnitPanel"
        '
        'PrioritySampleUnitPanel.Panel1
        '
        Me.PrioritySampleUnitPanel.Panel1.Controls.Add(Me.SampleUnitTree)
        Me.PrioritySampleUnitPanel.Panel1.Controls.Add(Me.HeaderStrip2)
        '
        'PrioritySampleUnitPanel.Panel2
        '
        Me.PrioritySampleUnitPanel.Panel2.Controls.Add(Me.SampleUnitList)
        Me.PrioritySampleUnitPanel.Panel2.Controls.Add(Me.HeaderStrip1)
        Me.PrioritySampleUnitPanel.Size = New System.Drawing.Size(680, 544)
        Me.PrioritySampleUnitPanel.SplitterDistance = 352
        Me.PrioritySampleUnitPanel.SplitterWidth = 3
        Me.PrioritySampleUnitPanel.TabIndex = 1
        '
        'SampleUnitTree
        '
        Me.SampleUnitTree.BackColor = System.Drawing.SystemColors.Window
        Me.SampleUnitTree.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.SampleUnitTree.ContextMenuStrip = Me.SampleUnitContextMenu
        Me.SampleUnitTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleUnitTree.ForeColor = System.Drawing.SystemColors.GrayText
        Me.SampleUnitTree.Location = New System.Drawing.Point(0, 22)
        Me.SampleUnitTree.Name = "SampleUnitTree"
        Me.SampleUnitTree.Size = New System.Drawing.Size(352, 522)
        Me.SampleUnitTree.TabIndex = 1
        '
        'SampleUnitContextMenu
        '
        Me.SampleUnitContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MoveToMenuItem})
        Me.SampleUnitContextMenu.Name = "SampleUnitContextMenu"
        Me.SampleUnitContextMenu.Size = New System.Drawing.Size(122, 26)
        '
        'HeaderStrip2
        '
        Me.HeaderStrip2.AutoSize = False
        Me.HeaderStrip2.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.HeaderStrip2.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip2.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel2})
        Me.HeaderStrip2.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip2.Name = "HeaderStrip2"
        Me.HeaderStrip2.Size = New System.Drawing.Size(352, 22)
        Me.HeaderStrip2.TabIndex = 0
        Me.HeaderStrip2.Text = "HeaderStrip2"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(108, 19)
        Me.ToolStripLabel2.Text = "Sample Unit Tree"
        '
        'SampleUnitList
        '
        Me.SampleUnitList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1, Me.ColumnHeader2})
        Me.SampleUnitList.ContextMenuStrip = Me.SampleUnitContextMenu
        Me.SampleUnitList.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleUnitList.FullRowSelect = True
        Me.SampleUnitList.GridLines = True
        Me.SampleUnitList.HideSelection = False
        Me.SampleUnitList.Location = New System.Drawing.Point(0, 22)
        Me.SampleUnitList.Name = "SampleUnitList"
        Me.SampleUnitList.Size = New System.Drawing.Size(325, 522)
        Me.SampleUnitList.SmallImageList = Me.SmallImageList
        Me.SampleUnitList.TabIndex = 1
        Me.SampleUnitList.UseCompatibleStateImageBehavior = False
        Me.SampleUnitList.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "ID"
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Name"
        Me.ColumnHeader2.Width = 100
        '
        'SmallImageList
        '
        Me.SmallImageList.ImageStream = CType(resources.GetObject("SmallImageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.SmallImageList.TransparentColor = System.Drawing.Color.Transparent
        Me.SmallImageList.Images.SetKeyName(0, "UpTriangle16.png")
        Me.SmallImageList.Images.SetKeyName(1, "DownTriangle16.png")
        Me.SmallImageList.Images.SetKeyName(2, "Ghost16.png")
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(325, 22)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(100, 19)
        Me.ToolStripLabel1.Text = "Sample Unit List"
        '
        'PriorityGroupContextMenu
        '
        Me.PriorityGroupContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MoveUpMenuItem, Me.MoveDownMenuItem, Me.ToolStripMenuItem1, Me.AddAboveMenuItem, Me.AddBelowMenuItem, Me.ToolStripMenuItem2, Me.DeleteGroupMenuItem, Me.ToolStripMenuItem3, Me.CleanupMenuItem})
        Me.PriorityGroupContextMenu.Name = "PriorityGroupContextMenu"
        Me.PriorityGroupContextMenu.Size = New System.Drawing.Size(206, 154)
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(202, 6)
        '
        'ToolStripMenuItem2
        '
        Me.ToolStripMenuItem2.Name = "ToolStripMenuItem2"
        Me.ToolStripMenuItem2.Size = New System.Drawing.Size(202, 6)
        '
        'ToolStripMenuItem3
        '
        Me.ToolStripMenuItem3.Name = "ToolStripMenuItem3"
        Me.ToolStripMenuItem3.Size = New System.Drawing.Size(202, 6)
        '
        'MoveToMenuItem
        '
        Me.MoveToMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripMenuItem5})
        Me.MoveToMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.MoveToFolder16
        Me.MoveToMenuItem.Name = "MoveToMenuItem"
        Me.MoveToMenuItem.Size = New System.Drawing.Size(121, 22)
        Me.MoveToMenuItem.Text = "Move to"
        '
        'ToolStripMenuItem5
        '
        Me.ToolStripMenuItem5.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Folder16
        Me.ToolStripMenuItem5.Name = "ToolStripMenuItem5"
        Me.ToolStripMenuItem5.Size = New System.Drawing.Size(152, 22)
        Me.ToolStripMenuItem5.Text = "Group 1"
        '
        'TreeAndListOption
        '
        Me.TreeAndListOption.Appearance = System.Windows.Forms.Appearance.Button
        Me.TreeAndListOption.AutoSize = True
        Me.TreeAndListOption.Checked = True
        Me.TreeAndListOption.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.TreeAndList
        Me.TreeAndListOption.Location = New System.Drawing.Point(62, 6)
        Me.TreeAndListOption.Name = "TreeAndListOption"
        Me.TreeAndListOption.Size = New System.Drawing.Size(38, 22)
        Me.TreeAndListOption.TabIndex = 2
        Me.TreeAndListOption.TabStop = True
        Me.ToolTipControl.SetToolTip(Me.TreeAndListOption, "Tree & List")
        Me.TreeAndListOption.UseVisualStyleBackColor = True
        '
        'ListOnlyOption
        '
        Me.ListOnlyOption.Appearance = System.Windows.Forms.Appearance.Button
        Me.ListOnlyOption.AutoSize = True
        Me.ListOnlyOption.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.ListBox16
        Me.ListOnlyOption.Location = New System.Drawing.Point(34, 6)
        Me.ListOnlyOption.Name = "ListOnlyOption"
        Me.ListOnlyOption.Size = New System.Drawing.Size(22, 22)
        Me.ListOnlyOption.TabIndex = 1
        Me.ToolTipControl.SetToolTip(Me.ListOnlyOption, "List Only")
        Me.ListOnlyOption.UseVisualStyleBackColor = True
        '
        'TreeOnlyOption
        '
        Me.TreeOnlyOption.Appearance = System.Windows.Forms.Appearance.Button
        Me.TreeOnlyOption.AutoSize = True
        Me.TreeOnlyOption.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.SamplePlan16
        Me.TreeOnlyOption.Location = New System.Drawing.Point(6, 6)
        Me.TreeOnlyOption.Name = "TreeOnlyOption"
        Me.TreeOnlyOption.Size = New System.Drawing.Size(22, 22)
        Me.TreeOnlyOption.TabIndex = 0
        Me.TreeOnlyOption.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.ToolTipControl.SetToolTip(Me.TreeOnlyOption, "Tree Only")
        Me.TreeOnlyOption.UseVisualStyleBackColor = True
        '
        'MoveDownButton
        '
        Me.MoveDownButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.MoveDownButton.FlatAppearance.BorderSize = 0
        Me.MoveDownButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DownArrow16
        Me.MoveDownButton.Location = New System.Drawing.Point(6, 213)
        Me.MoveDownButton.Name = "MoveDownButton"
        Me.MoveDownButton.Size = New System.Drawing.Size(24, 26)
        Me.MoveDownButton.TabIndex = 1
        Me.MoveDownButton.Tag = ""
        Me.ToolTipControl.SetToolTip(Me.MoveDownButton, "Decrease priority")
        Me.MoveDownButton.UseVisualStyleBackColor = True
        '
        'MoveUpButton
        '
        Me.MoveUpButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.MoveUpButton.FlatAppearance.BorderSize = 0
        Me.MoveUpButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.UpArrow16
        Me.MoveUpButton.Location = New System.Drawing.Point(6, 181)
        Me.MoveUpButton.Name = "MoveUpButton"
        Me.MoveUpButton.Size = New System.Drawing.Size(24, 26)
        Me.MoveUpButton.TabIndex = 0
        Me.MoveUpButton.Tag = ""
        Me.ToolTipControl.SetToolTip(Me.MoveUpButton, "Increase priority")
        Me.MoveUpButton.UseVisualStyleBackColor = True
        '
        'AddAboveButton
        '
        Me.AddAboveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.AddAboveButton.FlatAppearance.BorderSize = 0
        Me.AddAboveButton.Image = CType(resources.GetObject("AddAboveButton.Image"), System.Drawing.Image)
        Me.AddAboveButton.Location = New System.Drawing.Point(7, 245)
        Me.AddAboveButton.Name = "AddAboveButton"
        Me.AddAboveButton.Size = New System.Drawing.Size(24, 26)
        Me.AddAboveButton.TabIndex = 2
        Me.AddAboveButton.Tag = ""
        Me.ToolTipControl.SetToolTip(Me.AddAboveButton, "Add new priority group above")
        Me.AddAboveButton.UseVisualStyleBackColor = True
        '
        'AddBelowButton
        '
        Me.AddBelowButton.FlatAppearance.BorderSize = 0
        Me.AddBelowButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.InsertBelow16
        Me.AddBelowButton.Location = New System.Drawing.Point(7, 3)
        Me.AddBelowButton.Name = "AddBelowButton"
        Me.AddBelowButton.Size = New System.Drawing.Size(24, 26)
        Me.AddBelowButton.TabIndex = 0
        Me.AddBelowButton.Tag = ""
        Me.ToolTipControl.SetToolTip(Me.AddBelowButton, "Add new priority group below")
        Me.AddBelowButton.UseVisualStyleBackColor = True
        '
        'CleanupButton
        '
        Me.CleanupButton.FlatAppearance.BorderSize = 0
        Me.CleanupButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Form16
        Me.CleanupButton.Location = New System.Drawing.Point(7, 67)
        Me.CleanupButton.Name = "CleanupButton"
        Me.CleanupButton.Size = New System.Drawing.Size(24, 26)
        Me.CleanupButton.TabIndex = 2
        Me.CleanupButton.Tag = ""
        Me.ToolTipControl.SetToolTip(Me.CleanupButton, "Remove empty priority groups and reorder priorities")
        Me.CleanupButton.UseVisualStyleBackColor = True
        '
        'DeleteGroupButton
        '
        Me.DeleteGroupButton.FlatAppearance.BorderSize = 0
        Me.DeleteGroupButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.DeleteGroupButton.Location = New System.Drawing.Point(6, 35)
        Me.DeleteGroupButton.Name = "DeleteGroupButton"
        Me.DeleteGroupButton.Size = New System.Drawing.Size(24, 26)
        Me.DeleteGroupButton.TabIndex = 1
        Me.DeleteGroupButton.Tag = ""
        Me.ToolTipControl.SetToolTip(Me.DeleteGroupButton, "Delete selected priority group")
        Me.DeleteGroupButton.UseVisualStyleBackColor = True
        '
        'MoveUpMenuItem
        '
        Me.MoveUpMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.UpArrow16
        Me.MoveUpMenuItem.Name = "MoveUpMenuItem"
        Me.MoveUpMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.MoveUpMenuItem.Text = "Move Up"
        '
        'MoveDownMenuItem
        '
        Me.MoveDownMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DownArrow16
        Me.MoveDownMenuItem.Name = "MoveDownMenuItem"
        Me.MoveDownMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.MoveDownMenuItem.Text = "Move Down"
        '
        'AddAboveMenuItem
        '
        Me.AddAboveMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.InsertAbove16
        Me.AddAboveMenuItem.Name = "AddAboveMenuItem"
        Me.AddAboveMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.AddAboveMenuItem.Text = "Add Group Above"
        '
        'AddBelowMenuItem
        '
        Me.AddBelowMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.InsertBelow16
        Me.AddBelowMenuItem.Name = "AddBelowMenuItem"
        Me.AddBelowMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.AddBelowMenuItem.Text = "Add Group Below"
        '
        'DeleteGroupMenuItem
        '
        Me.DeleteGroupMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.DeleteGroupMenuItem.Name = "DeleteGroupMenuItem"
        Me.DeleteGroupMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.DeleteGroupMenuItem.Text = "Delete Group"
        '
        'CleanupMenuItem
        '
        Me.CleanupMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Form16
        Me.CleanupMenuItem.Name = "CleanupMenuItem"
        Me.CleanupMenuItem.Size = New System.Drawing.Size(205, 22)
        Me.CleanupMenuItem.Text = "Remove Empty Groups"
        '
        'SampleUnitPrioritizer
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.Transparent
        Me.Controls.Add(Me.PrioritySampleUnitPanel)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.LeftPanel)
        Me.DoubleBuffered = True
        Me.Name = "SampleUnitPrioritizer"
        Me.Size = New System.Drawing.Size(802, 575)
        Me.LeftPanel.ResumeLayout(False)
        Me.CommandPanel.Panel1.ResumeLayout(False)
        Me.CommandPanel.Panel2.ResumeLayout(False)
        Me.CommandPanel.ResumeLayout(False)
        Me.HeaderStrip3.ResumeLayout(False)
        Me.HeaderStrip3.PerformLayout()
        Me.BottomPanel.ResumeLayout(False)
        Me.BottomPanel.PerformLayout()
        Me.PrioritySampleUnitPanel.Panel1.ResumeLayout(False)
        Me.PrioritySampleUnitPanel.Panel2.ResumeLayout(False)
        Me.PrioritySampleUnitPanel.ResumeLayout(False)
        Me.SampleUnitContextMenu.ResumeLayout(False)
        Me.HeaderStrip2.ResumeLayout(False)
        Me.HeaderStrip2.PerformLayout()
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.PriorityGroupContextMenu.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents LeftPanel As System.Windows.Forms.Panel
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents PrioritySampleUnitPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents ToolTipControl As System.Windows.Forms.ToolTip
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents SampleUnitTree As System.Windows.Forms.TreeView
    Friend WithEvents HeaderStrip2 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents PriorityGroupPanel As System.Windows.Forms.FlowLayoutPanel
    Friend WithEvents CommandPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents MoveDownButton As System.Windows.Forms.Button
    Friend WithEvents MoveUpButton As System.Windows.Forms.Button
    Friend WithEvents AddAboveButton As System.Windows.Forms.Button
    Friend WithEvents CleanupButton As System.Windows.Forms.Button
    Friend WithEvents DeleteGroupButton As System.Windows.Forms.Button
    Friend WithEvents HeaderStrip3 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel3 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents SampleUnitList As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ListOnlyOption As System.Windows.Forms.RadioButton
    Friend WithEvents TreeOnlyOption As System.Windows.Forms.RadioButton
    Friend WithEvents TreeAndListOption As System.Windows.Forms.RadioButton
    Friend WithEvents AddBelowButton As System.Windows.Forms.Button
    Friend WithEvents PriorityGroupContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents MoveUpMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MoveDownMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents AddAboveMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AddBelowMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteGroupMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents CleanupMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SampleUnitContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents MoveToMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem5 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SmallImageList As System.Windows.Forms.ImageList

End Class
