<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class TransferResultsNavigator
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
        Me.TransferResultsToolStripTop = New System.Windows.Forms.ToolStrip
        Me.TransferResultsFromTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.TransferResultsFilterComboBox = New System.Windows.Forms.ComboBox
        Me.TransferResultsFromDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.TransferResultsImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.LegendToolStrip = New System.Windows.Forms.ToolStrip
        Me.LegendVendorTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileBadLithoTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileSurveyErrorTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileBothTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendSurveyTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendSurveyErrorTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendControlToolStrip = New System.Windows.Forms.ToolStrip
        Me.LegendControlTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendControlHideTSButton = New System.Windows.Forms.ToolStripButton
        Me.LegendControlShowTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsToolStripBottom = New System.Windows.Forms.ToolStrip
        Me.TransferResultsRefreshTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsTSSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.TransferResultsFontDownTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsFontUpTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsTSSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.TransferResultsSortIDTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsSortNameTSButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.TransferResultsHideTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsShowTSButton = New System.Windows.Forms.ToolStripButton
        Me.TransferResultsTreeView = New System.Windows.Forms.TreeView
        Me.TransferResultsToolStripTop.SuspendLayout()
        Me.LegendToolStrip.SuspendLayout()
        Me.LegendControlToolStrip.SuspendLayout()
        Me.TransferResultsToolStripBottom.SuspendLayout()
        Me.SuspendLayout()
        '
        'TransferResultsToolStripTop
        '
        Me.TransferResultsToolStripTop.CanOverflow = False
        Me.TransferResultsToolStripTop.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.TransferResultsToolStripTop.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TransferResultsFromTSLabel})
        Me.TransferResultsToolStripTop.Location = New System.Drawing.Point(0, 0)
        Me.TransferResultsToolStripTop.Name = "TransferResultsToolStripTop"
        Me.TransferResultsToolStripTop.Size = New System.Drawing.Size(250, 25)
        Me.TransferResultsToolStripTop.TabIndex = 0
        Me.TransferResultsToolStripTop.Text = "ToolStrip1"
        '
        'TransferResultsFromTSLabel
        '
        Me.TransferResultsFromTSLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.TransferResultsFromTSLabel.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.TransferResultsFromTSLabel.Name = "TransferResultsFromTSLabel"
        Me.TransferResultsFromTSLabel.Size = New System.Drawing.Size(38, 22)
        Me.TransferResultsFromTSLabel.Text = "From:"
        '
        'TransferResultsFilterComboBox
        '
        Me.TransferResultsFilterComboBox.FormattingEnabled = True
        Me.TransferResultsFilterComboBox.Location = New System.Drawing.Point(5, 1)
        Me.TransferResultsFilterComboBox.Name = "TransferResultsFilterComboBox"
        Me.TransferResultsFilterComboBox.Size = New System.Drawing.Size(75, 21)
        Me.TransferResultsFilterComboBox.TabIndex = 1
        '
        'TransferResultsFromDateTimePicker
        '
        Me.TransferResultsFromDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TransferResultsFromDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.TransferResultsFromDateTimePicker.Location = New System.Drawing.Point(149, 1)
        Me.TransferResultsFromDateTimePicker.Name = "TransferResultsFromDateTimePicker"
        Me.TransferResultsFromDateTimePicker.Size = New System.Drawing.Size(95, 21)
        Me.TransferResultsFromDateTimePicker.TabIndex = 2
        '
        'TransferResultsImageList
        '
        Me.TransferResultsImageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.TransferResultsImageList.ImageSize = New System.Drawing.Size(16, 16)
        Me.TransferResultsImageList.TransparentColor = System.Drawing.Color.Magenta
        '
        'LegendToolStrip
        '
        Me.LegendToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.LegendToolStrip.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LegendToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.LegendToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LegendVendorTSLabel, Me.LegendFileTSLabel, Me.LegendFileBadLithoTSLabel, Me.LegendFileSurveyErrorTSLabel, Me.LegendFileBothTSLabel, Me.LegendSurveyTSLabel, Me.LegendSurveyErrorTSLabel})
        Me.LegendToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.Table
        Me.LegendToolStrip.Location = New System.Drawing.Point(0, 316)
        Me.LegendToolStrip.Name = "LegendToolStrip"
        Me.LegendToolStrip.Size = New System.Drawing.Size(250, 152)
        Me.LegendToolStrip.TabIndex = 3
        Me.LegendToolStrip.Text = "ToolStrip1"
        '
        'LegendVendorTSLabel
        '
        Me.LegendVendorTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Member32
        Me.LegendVendorTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendVendorTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendVendorTSLabel.Name = "LegendVendorTSLabel"
        Me.LegendVendorTSLabel.Size = New System.Drawing.Size(57, 16)
        Me.LegendVendorTSLabel.Text = "Vendor"
        Me.LegendVendorTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileTSLabel
        '
        Me.LegendFileTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DocumentGreen16
        Me.LegendFileTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFileTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileTSLabel.Name = "LegendFileTSLabel"
        Me.LegendFileTSLabel.Size = New System.Drawing.Size(94, 16)
        Me.LegendFileTSLabel.Text = "File - No Errors"
        Me.LegendFileTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileBadLithoTSLabel
        '
        Me.LegendFileBadLithoTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Document16
        Me.LegendFileBadLithoTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileBadLithoTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileBadLithoTSLabel.Name = "LegendFileBadLithoTSLabel"
        Me.LegendFileBadLithoTSLabel.Size = New System.Drawing.Size(121, 16)
        Me.LegendFileBadLithoTSLabel.Text = "File - Bad Litho Code"
        Me.LegendFileBadLithoTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileSurveyErrorTSLabel
        '
        Me.LegendFileSurveyErrorTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DocumentYellow16
        Me.LegendFileSurveyErrorTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileSurveyErrorTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFileSurveyErrorTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileSurveyErrorTSLabel.Name = "LegendFileSurveyErrorTSLabel"
        Me.LegendFileSurveyErrorTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFileSurveyErrorTSLabel.Text = "File - Survey Error"
        Me.LegendFileSurveyErrorTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileBothTSLabel
        '
        Me.LegendFileBothTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DocumentRed16
        Me.LegendFileBothTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileBothTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFileBothTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileBothTSLabel.Name = "LegendFileBothTSLabel"
        Me.LegendFileBothTSLabel.Size = New System.Drawing.Size(178, 16)
        Me.LegendFileBothTSLabel.Text = "File - Bad Litho and Survey Error"
        Me.LegendFileBothTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendSurveyTSLabel
        '
        Me.LegendSurveyTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Validation16
        Me.LegendSurveyTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendSurveyTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendSurveyTSLabel.Name = "LegendSurveyTSLabel"
        Me.LegendSurveyTSLabel.Size = New System.Drawing.Size(112, 16)
        Me.LegendSurveyTSLabel.Text = "Survey - No Errors"
        Me.LegendSurveyTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendSurveyErrorTSLabel
        '
        Me.LegendSurveyErrorTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.NoWay16
        Me.LegendSurveyErrorTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendSurveyErrorTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendSurveyErrorTSLabel.Name = "LegendSurveyErrorTSLabel"
        Me.LegendSurveyErrorTSLabel.Size = New System.Drawing.Size(117, 16)
        Me.LegendSurveyErrorTSLabel.Text = "Survey - Has Errors"
        Me.LegendSurveyErrorTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendControlToolStrip
        '
        Me.LegendControlToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.LegendControlToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.LegendControlToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LegendControlTSLabel, Me.LegendControlHideTSButton, Me.LegendControlShowTSButton})
        Me.LegendControlToolStrip.Location = New System.Drawing.Point(0, 291)
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
        'TransferResultsToolStripBottom
        '
        Me.TransferResultsToolStripBottom.CanOverflow = False
        Me.TransferResultsToolStripBottom.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.TransferResultsToolStripBottom.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TransferResultsRefreshTSButton, Me.TransferResultsTSSeparator1, Me.TransferResultsFontDownTSButton, Me.TransferResultsFontUpTSButton, Me.TransferResultsTSSeparator2, Me.TransferResultsSortIDTSButton, Me.TransferResultsSortNameTSButton, Me.ToolStripSeparator1, Me.TransferResultsHideTSButton, Me.TransferResultsShowTSButton})
        Me.TransferResultsToolStripBottom.Location = New System.Drawing.Point(0, 25)
        Me.TransferResultsToolStripBottom.Name = "TransferResultsToolStripBottom"
        Me.TransferResultsToolStripBottom.Size = New System.Drawing.Size(250, 25)
        Me.TransferResultsToolStripBottom.TabIndex = 6
        Me.TransferResultsToolStripBottom.Text = "ToolStrip1"
        '
        'TransferResultsRefreshTSButton
        '
        Me.TransferResultsRefreshTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsRefreshTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Refresh16
        Me.TransferResultsRefreshTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsRefreshTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.TransferResultsRefreshTSButton.Name = "TransferResultsRefreshTSButton"
        Me.TransferResultsRefreshTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsRefreshTSButton.Text = "Refresh"
        '
        'TransferResultsTSSeparator1
        '
        Me.TransferResultsTSSeparator1.Name = "TransferResultsTSSeparator1"
        Me.TransferResultsTSSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'TransferResultsFontDownTSButton
        '
        Me.TransferResultsFontDownTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsFontDownTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GroupCollapse15
        Me.TransferResultsFontDownTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsFontDownTSButton.Name = "TransferResultsFontDownTSButton"
        Me.TransferResultsFontDownTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsFontDownTSButton.Text = "Smaller Font"
        '
        'TransferResultsFontUpTSButton
        '
        Me.TransferResultsFontUpTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsFontUpTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GroupExpand15
        Me.TransferResultsFontUpTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsFontUpTSButton.Name = "TransferResultsFontUpTSButton"
        Me.TransferResultsFontUpTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsFontUpTSButton.Text = "Larger Font"
        '
        'TransferResultsTSSeparator2
        '
        Me.TransferResultsTSSeparator2.Name = "TransferResultsTSSeparator2"
        Me.TransferResultsTSSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'TransferResultsSortIDTSButton
        '
        Me.TransferResultsSortIDTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsSortIDTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DownArrow16
        Me.TransferResultsSortIDTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsSortIDTSButton.Name = "TransferResultsSortIDTSButton"
        Me.TransferResultsSortIDTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsSortIDTSButton.Text = "Sort By Date Loaded"
        '
        'TransferResultsSortNameTSButton
        '
        Me.TransferResultsSortNameTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsSortNameTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.UpArrow16
        Me.TransferResultsSortNameTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsSortNameTSButton.Name = "TransferResultsSortNameTSButton"
        Me.TransferResultsSortNameTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsSortNameTSButton.Text = "Sort by File Name"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'TransferResultsHideTSButton
        '
        Me.TransferResultsHideTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsHideTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.YellowLight
        Me.TransferResultsHideTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsHideTSButton.Name = "TransferResultsHideTSButton"
        Me.TransferResultsHideTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsHideTSButton.Text = "Hide/UnHide File"
        '
        'TransferResultsShowTSButton
        '
        Me.TransferResultsShowTSButton.CheckOnClick = True
        Me.TransferResultsShowTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TransferResultsShowTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GreenLight
        Me.TransferResultsShowTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TransferResultsShowTSButton.Name = "TransferResultsShowTSButton"
        Me.TransferResultsShowTSButton.Size = New System.Drawing.Size(23, 22)
        Me.TransferResultsShowTSButton.Text = "Show Hidden Files"
        '
        'TransferResultsTreeView
        '
        Me.TransferResultsTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TransferResultsTreeView.HideSelection = False
        Me.TransferResultsTreeView.ImageIndex = 0
        Me.TransferResultsTreeView.ImageList = Me.TransferResultsImageList
        Me.TransferResultsTreeView.Location = New System.Drawing.Point(0, 50)
        Me.TransferResultsTreeView.Name = "TransferResultsTreeView"
        Me.TransferResultsTreeView.SelectedImageIndex = 0
        Me.TransferResultsTreeView.Size = New System.Drawing.Size(250, 241)
        Me.TransferResultsTreeView.TabIndex = 7
        '
        'TransferResultsNavigator
        '
        Me.Controls.Add(Me.TransferResultsTreeView)
        Me.Controls.Add(Me.TransferResultsToolStripBottom)
        Me.Controls.Add(Me.LegendControlToolStrip)
        Me.Controls.Add(Me.LegendToolStrip)
        Me.Controls.Add(Me.TransferResultsFromDateTimePicker)
        Me.Controls.Add(Me.TransferResultsFilterComboBox)
        Me.Controls.Add(Me.TransferResultsToolStripTop)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "TransferResultsNavigator"
        Me.Size = New System.Drawing.Size(250, 468)
        Me.TransferResultsToolStripTop.ResumeLayout(False)
        Me.TransferResultsToolStripTop.PerformLayout()
        Me.LegendToolStrip.ResumeLayout(False)
        Me.LegendToolStrip.PerformLayout()
        Me.LegendControlToolStrip.ResumeLayout(False)
        Me.LegendControlToolStrip.PerformLayout()
        Me.TransferResultsToolStripBottom.ResumeLayout(False)
        Me.TransferResultsToolStripBottom.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TransferResultsToolStripTop As System.Windows.Forms.ToolStrip
    Friend WithEvents TransferResultsFilterComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents TransferResultsFromTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents TransferResultsFromDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents TransferResultsImageList As System.Windows.Forms.ImageList
    Friend WithEvents LegendToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LegendVendorTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileBadLithoTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileSurveyErrorTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileBothTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendSurveyTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendSurveyErrorTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendControlToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LegendControlTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendControlHideTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents LegendControlShowTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TransferResultsToolStripBottom As System.Windows.Forms.ToolStrip
    Friend WithEvents TransferResultsRefreshTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TransferResultsTreeView As System.Windows.Forms.TreeView
    Friend WithEvents TransferResultsTSSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents TransferResultsFontDownTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TransferResultsFontUpTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TransferResultsTSSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents TransferResultsSortIDTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TransferResultsSortNameTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents TransferResultsHideTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TransferResultsShowTSButton As System.Windows.Forms.ToolStripButton

End Class
