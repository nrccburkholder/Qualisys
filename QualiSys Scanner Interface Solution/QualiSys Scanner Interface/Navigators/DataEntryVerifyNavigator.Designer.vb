<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DataEntryVerifyNavigator
    Inherits QualiSys_Scanner_Interface.Navigator

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
        Dim TreeNode1 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("2013X01 (12)")
        Dim TreeNode2 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Apr 15 2012 2:57:34.051PM", New System.Windows.Forms.TreeNode() {TreeNode1})
        Me.DataEntryImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.LegendToolStrip = New System.Windows.Forms.ToolStrip
        Me.LegendBatchTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendSurveyTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendControlToolStrip = New System.Windows.Forms.ToolStrip
        Me.LegendControlTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendControlHideTSButton = New System.Windows.Forms.ToolStripButton
        Me.LegendControlShowTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryTreeToolStrip = New System.Windows.Forms.ToolStrip
        Me.DataEntryBeginTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryDeleteTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryNewBatchTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryUnlockTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryFinalizeTSButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.DataEntryRefreshTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryTSSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.DataEntryFontDownTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryFontUpTSButton = New System.Windows.Forms.ToolStripButton
        Me.DataEntryTreeView = New System.Windows.Forms.TreeView
        Me.LegendToolStrip.SuspendLayout()
        Me.LegendControlToolStrip.SuspendLayout()
        Me.DataEntryTreeToolStrip.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'DataEntryImageList
        '
        Me.DataEntryImageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.DataEntryImageList.ImageSize = New System.Drawing.Size(16, 16)
        Me.DataEntryImageList.TransparentColor = System.Drawing.Color.Magenta
        '
        'LegendToolStrip
        '
        Me.LegendToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.LegendToolStrip.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LegendToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.LegendToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LegendBatchTSLabel, Me.LegendSurveyTSLabel})
        Me.LegendToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.Table
        Me.LegendToolStrip.Location = New System.Drawing.Point(0, 430)
        Me.LegendToolStrip.Name = "LegendToolStrip"
        Me.LegendToolStrip.Size = New System.Drawing.Size(250, 38)
        Me.LegendToolStrip.TabIndex = 3
        Me.LegendToolStrip.Text = "ToolStrip1"
        '
        'LegendBatchTSLabel
        '
        Me.LegendBatchTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Batch
        Me.LegendBatchTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendBatchTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendBatchTSLabel.Name = "LegendBatchTSLabel"
        Me.LegendBatchTSLabel.Size = New System.Drawing.Size(50, 16)
        Me.LegendBatchTSLabel.Text = "Batch"
        Me.LegendBatchTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendSurveyTSLabel
        '
        Me.LegendSurveyTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Survey
        Me.LegendSurveyTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendSurveyTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendSurveyTSLabel.Name = "LegendSurveyTSLabel"
        Me.LegendSurveyTSLabel.Size = New System.Drawing.Size(57, 16)
        Me.LegendSurveyTSLabel.Text = "Survey"
        Me.LegendSurveyTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendControlToolStrip
        '
        Me.LegendControlToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.LegendControlToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.LegendControlToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LegendControlTSLabel, Me.LegendControlHideTSButton, Me.LegendControlShowTSButton})
        Me.LegendControlToolStrip.Location = New System.Drawing.Point(0, 405)
        Me.LegendControlToolStrip.Name = "LegendControlToolStrip"
        Me.LegendControlToolStrip.Size = New System.Drawing.Size(250, 25)
        Me.LegendControlToolStrip.TabIndex = 4
        Me.LegendControlToolStrip.Text = "ToolStrip1"
        '
        'LegendControlTSLabel
        '
        Me.LegendControlTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendControlTSLabel.Name = "LegendControlTSLabel"
        Me.LegendControlTSLabel.Size = New System.Drawing.Size(72, 22)
        Me.LegendControlTSLabel.Text = "Tree Legend"
        '
        'LegendControlHideTSButton
        '
        Me.LegendControlHideTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.LegendControlHideTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.LegendControlHideTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.MoveDown
        Me.LegendControlHideTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendControlHideTSButton.Margin = New System.Windows.Forms.Padding(0, 1, 5, 2)
        Me.LegendControlHideTSButton.Name = "LegendControlHideTSButton"
        Me.LegendControlHideTSButton.Size = New System.Drawing.Size(23, 22)
        Me.LegendControlHideTSButton.Text = "Hide"
        '
        'LegendControlShowTSButton
        '
        Me.LegendControlShowTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.LegendControlShowTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.LegendControlShowTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.MoveUp
        Me.LegendControlShowTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendControlShowTSButton.Margin = New System.Windows.Forms.Padding(0, 1, 5, 2)
        Me.LegendControlShowTSButton.Name = "LegendControlShowTSButton"
        Me.LegendControlShowTSButton.Size = New System.Drawing.Size(23, 22)
        Me.LegendControlShowTSButton.Text = "Show"
        '
        'DataEntryTreeToolStrip
        '
        Me.DataEntryTreeToolStrip.CanOverflow = False
        Me.DataEntryTreeToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.DataEntryTreeToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DataEntryBeginTSButton, Me.DataEntryDeleteTSButton, Me.DataEntryNewBatchTSButton, Me.DataEntryUnlockTSButton, Me.DataEntryFinalizeTSButton})
        Me.DataEntryTreeToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.DataEntryTreeToolStrip.Name = "DataEntryTreeToolStrip"
        Me.DataEntryTreeToolStrip.Size = New System.Drawing.Size(250, 25)
        Me.DataEntryTreeToolStrip.TabIndex = 6
        Me.DataEntryTreeToolStrip.Text = "ToolStrip1"
        '
        'DataEntryBeginTSButton
        '
        Me.DataEntryBeginTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GoLtr
        Me.DataEntryBeginTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryBeginTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.DataEntryBeginTSButton.Name = "DataEntryBeginTSButton"
        Me.DataEntryBeginTSButton.Size = New System.Drawing.Size(57, 22)
        Me.DataEntryBeginTSButton.Text = "Begin"
        '
        'DataEntryDeleteTSButton
        '
        Me.DataEntryDeleteTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.DataEntryDeleteTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DataEntryDeleteTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DeleteRed16
        Me.DataEntryDeleteTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryDeleteTSButton.Name = "DataEntryDeleteTSButton"
        Me.DataEntryDeleteTSButton.Size = New System.Drawing.Size(23, 22)
        Me.DataEntryDeleteTSButton.Text = "Delete"
        '
        'DataEntryNewBatchTSButton
        '
        Me.DataEntryNewBatchTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.DataEntryNewBatchTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.New16
        Me.DataEntryNewBatchTSButton.ImageTransparentColor = System.Drawing.Color.Transparent
        Me.DataEntryNewBatchTSButton.Name = "DataEntryNewBatchTSButton"
        Me.DataEntryNewBatchTSButton.Size = New System.Drawing.Size(51, 22)
        Me.DataEntryNewBatchTSButton.Text = "New"
        '
        'DataEntryUnlockTSButton
        '
        Me.DataEntryUnlockTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DataEntryUnlockTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Lock
        Me.DataEntryUnlockTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryUnlockTSButton.Name = "DataEntryUnlockTSButton"
        Me.DataEntryUnlockTSButton.Size = New System.Drawing.Size(23, 22)
        Me.DataEntryUnlockTSButton.Text = "Unlock"
        '
        'DataEntryFinalizeTSButton
        '
        Me.DataEntryFinalizeTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DataEntryFinalizeTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DownArrow16
        Me.DataEntryFinalizeTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryFinalizeTSButton.Name = "DataEntryFinalizeTSButton"
        Me.DataEntryFinalizeTSButton.Size = New System.Drawing.Size(23, 22)
        Me.DataEntryFinalizeTSButton.Text = "Finalize"
        '
        'ToolStrip1
        '
        Me.ToolStrip1.CanOverflow = False
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DataEntryRefreshTSButton, Me.DataEntryTSSeparator1, Me.DataEntryFontDownTSButton, Me.DataEntryFontUpTSButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 25)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(250, 25)
        Me.ToolStrip1.TabIndex = 8
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'DataEntryRefreshTSButton
        '
        Me.DataEntryRefreshTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DataEntryRefreshTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Refresh16
        Me.DataEntryRefreshTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryRefreshTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.DataEntryRefreshTSButton.Name = "DataEntryRefreshTSButton"
        Me.DataEntryRefreshTSButton.Size = New System.Drawing.Size(23, 22)
        Me.DataEntryRefreshTSButton.Text = "Refresh"
        '
        'DataEntryTSSeparator1
        '
        Me.DataEntryTSSeparator1.Name = "DataEntryTSSeparator1"
        Me.DataEntryTSSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'DataEntryFontDownTSButton
        '
        Me.DataEntryFontDownTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DataEntryFontDownTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GroupCollapse15
        Me.DataEntryFontDownTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryFontDownTSButton.Name = "DataEntryFontDownTSButton"
        Me.DataEntryFontDownTSButton.Size = New System.Drawing.Size(23, 22)
        Me.DataEntryFontDownTSButton.Text = "Smaller Font"
        '
        'DataEntryFontUpTSButton
        '
        Me.DataEntryFontUpTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DataEntryFontUpTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GroupExpand15
        Me.DataEntryFontUpTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DataEntryFontUpTSButton.Name = "DataEntryFontUpTSButton"
        Me.DataEntryFontUpTSButton.Size = New System.Drawing.Size(23, 22)
        Me.DataEntryFontUpTSButton.Text = "Larger Font"
        '
        'DataEntryTreeView
        '
        Me.DataEntryTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.DataEntryTreeView.HideSelection = False
        Me.DataEntryTreeView.ImageIndex = 0
        Me.DataEntryTreeView.ImageList = Me.DataEntryImageList
        Me.DataEntryTreeView.Location = New System.Drawing.Point(0, 50)
        Me.DataEntryTreeView.Name = "DataEntryTreeView"
        TreeNode1.Name = "Node1"
        TreeNode1.Text = "2013X01 (12)"
        TreeNode2.Name = "Node0"
        TreeNode2.Text = "Apr 15 2012 2:57:34.051PM"
        Me.DataEntryTreeView.Nodes.AddRange(New System.Windows.Forms.TreeNode() {TreeNode2})
        Me.DataEntryTreeView.SelectedImageIndex = 0
        Me.DataEntryTreeView.Size = New System.Drawing.Size(250, 355)
        Me.DataEntryTreeView.TabIndex = 9
        '
        'DataEntryVerifyNavigator
        '
        Me.Controls.Add(Me.DataEntryTreeView)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.DataEntryTreeToolStrip)
        Me.Controls.Add(Me.LegendControlToolStrip)
        Me.Controls.Add(Me.LegendToolStrip)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "DataEntryVerifyNavigator"
        Me.Size = New System.Drawing.Size(250, 468)
        Me.LegendToolStrip.ResumeLayout(False)
        Me.LegendToolStrip.PerformLayout()
        Me.LegendControlToolStrip.ResumeLayout(False)
        Me.LegendControlToolStrip.PerformLayout()
        Me.DataEntryTreeToolStrip.ResumeLayout(False)
        Me.DataEntryTreeToolStrip.PerformLayout()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents DataEntryImageList As System.Windows.Forms.ImageList
    Friend WithEvents LegendToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LegendBatchTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendSurveyTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendControlToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LegendControlTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendControlHideTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents LegendControlShowTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryTreeToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents DataEntryNewBatchTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryBeginTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents DataEntryRefreshTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryTSSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DataEntryFontDownTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryFontUpTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryUnlockTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryFinalizeTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DataEntryTreeView As System.Windows.Forms.TreeView

End Class
