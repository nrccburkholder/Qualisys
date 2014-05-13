<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VendorFileValidationNavigator
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
        Me.VendorFileFromDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.VendorFileFilterComboBox = New System.Windows.Forms.ComboBox
        Me.VendorFileToolStripTop = New System.Windows.Forms.ToolStrip
        Me.VendorFileFromTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.VendorFileToolStripBottom = New System.Windows.Forms.ToolStrip
        Me.VendorFileTSSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.VendorFileTSSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.LegendToolStrip = New System.Windows.Forms.ToolStrip
        Me.LegendControlToolStrip = New System.Windows.Forms.ToolStrip
        Me.LegendControlTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.VendorFileTreeView = New System.Windows.Forms.TreeView
        Me.VendorFileImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.LegendControlHideTSButton = New System.Windows.Forms.ToolStripButton
        Me.LegendControlShowTSButton = New System.Windows.Forms.ToolStripButton
        Me.LegendRootPhoneTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendRootWebTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendRootIVRTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendRootMailWebTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.LegendClientTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendStudyTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendSurveyTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileProcessingTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileProcessingFailTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFilePendingTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileApprovedTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileTelematchingTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendFileSentTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.LegendRootLetterWebTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.VendorFileRefreshTSButton = New System.Windows.Forms.ToolStripButton
        Me.VendorFileFontDownTSButton = New System.Windows.Forms.ToolStripButton
        Me.VendorFileFontUpTSButton = New System.Windows.Forms.ToolStripButton
        Me.VendorFileHideTSButton = New System.Windows.Forms.ToolStripButton
        Me.VendorFileShowTSButton = New System.Windows.Forms.ToolStripButton
        Me.VendorFileToolStripTop.SuspendLayout()
        Me.VendorFileToolStripBottom.SuspendLayout()
        Me.LegendToolStrip.SuspendLayout()
        Me.LegendControlToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'VendorFileFromDateTimePicker
        '
        Me.VendorFileFromDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileFromDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.VendorFileFromDateTimePicker.Location = New System.Drawing.Point(137, 1)
        Me.VendorFileFromDateTimePicker.Name = "VendorFileFromDateTimePicker"
        Me.VendorFileFromDateTimePicker.Size = New System.Drawing.Size(95, 21)
        Me.VendorFileFromDateTimePicker.TabIndex = 5
        '
        'VendorFileFilterComboBox
        '
        Me.VendorFileFilterComboBox.DropDownWidth = 90
        Me.VendorFileFilterComboBox.FormattingEnabled = True
        Me.VendorFileFilterComboBox.Location = New System.Drawing.Point(5, 1)
        Me.VendorFileFilterComboBox.Name = "VendorFileFilterComboBox"
        Me.VendorFileFilterComboBox.Size = New System.Drawing.Size(75, 21)
        Me.VendorFileFilterComboBox.TabIndex = 4
        '
        'VendorFileToolStripTop
        '
        Me.VendorFileToolStripTop.CanOverflow = False
        Me.VendorFileToolStripTop.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.VendorFileToolStripTop.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.VendorFileFromTSLabel})
        Me.VendorFileToolStripTop.Location = New System.Drawing.Point(0, 0)
        Me.VendorFileToolStripTop.Name = "VendorFileToolStripTop"
        Me.VendorFileToolStripTop.Size = New System.Drawing.Size(238, 25)
        Me.VendorFileToolStripTop.TabIndex = 3
        Me.VendorFileToolStripTop.Text = "ToolStrip1"
        '
        'VendorFileFromTSLabel
        '
        Me.VendorFileFromTSLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.VendorFileFromTSLabel.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.VendorFileFromTSLabel.Name = "VendorFileFromTSLabel"
        Me.VendorFileFromTSLabel.Size = New System.Drawing.Size(38, 22)
        Me.VendorFileFromTSLabel.Text = "From:"
        '
        'VendorFileToolStripBottom
        '
        Me.VendorFileToolStripBottom.CanOverflow = False
        Me.VendorFileToolStripBottom.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.VendorFileToolStripBottom.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.VendorFileRefreshTSButton, Me.VendorFileTSSeparator1, Me.VendorFileFontDownTSButton, Me.VendorFileFontUpTSButton, Me.VendorFileTSSeparator2, Me.VendorFileHideTSButton, Me.VendorFileShowTSButton})
        Me.VendorFileToolStripBottom.Location = New System.Drawing.Point(0, 25)
        Me.VendorFileToolStripBottom.Name = "VendorFileToolStripBottom"
        Me.VendorFileToolStripBottom.Size = New System.Drawing.Size(238, 25)
        Me.VendorFileToolStripBottom.TabIndex = 7
        Me.VendorFileToolStripBottom.Text = "ToolStrip1"
        '
        'VendorFileTSSeparator1
        '
        Me.VendorFileTSSeparator1.Name = "VendorFileTSSeparator1"
        Me.VendorFileTSSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'VendorFileTSSeparator2
        '
        Me.VendorFileTSSeparator2.Name = "VendorFileTSSeparator2"
        Me.VendorFileTSSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'LegendToolStrip
        '
        Me.LegendToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.LegendToolStrip.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LegendToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.LegendToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LegendRootPhoneTSLabel, Me.LegendRootWebTSLabel, Me.LegendRootIVRTSLabel, Me.LegendRootMailWebTSLabel, Me.LegendRootLetterWebTSLabel, Me.ToolStripLabel1, Me.LegendClientTSLabel, Me.LegendStudyTSLabel, Me.LegendSurveyTSLabel, Me.LegendFileProcessingTSLabel, Me.LegendFileProcessingFailTSLabel, Me.LegendFilePendingTSLabel, Me.LegendFileApprovedTSLabel, Me.LegendFileTelematchingTSLabel, Me.LegendFileSentTSLabel})
        Me.LegendToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.Flow
        Me.LegendToolStrip.Location = New System.Drawing.Point(0, 316)
        Me.LegendToolStrip.Name = "LegendToolStrip"
        Me.LegendToolStrip.Size = New System.Drawing.Size(238, 152)
        Me.LegendToolStrip.TabIndex = 8
        Me.LegendToolStrip.Text = "ToolStrip1"
        '
        'LegendControlToolStrip
        '
        Me.LegendControlToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.LegendControlToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.LegendControlToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LegendControlTSLabel, Me.LegendControlHideTSButton, Me.LegendControlShowTSButton})
        Me.LegendControlToolStrip.Location = New System.Drawing.Point(0, 291)
        Me.LegendControlToolStrip.Name = "LegendControlToolStrip"
        Me.LegendControlToolStrip.Size = New System.Drawing.Size(238, 25)
        Me.LegendControlToolStrip.TabIndex = 9
        Me.LegendControlToolStrip.Text = "ToolStrip1"
        '
        'LegendControlTSLabel
        '
        Me.LegendControlTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendControlTSLabel.Name = "LegendControlTSLabel"
        Me.LegendControlTSLabel.Size = New System.Drawing.Size(72, 22)
        Me.LegendControlTSLabel.Text = "Tree Legend"
        '
        'VendorFileTreeView
        '
        Me.VendorFileTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorFileTreeView.HideSelection = False
        Me.VendorFileTreeView.ImageIndex = 0
        Me.VendorFileTreeView.ImageList = Me.VendorFileImageList
        Me.VendorFileTreeView.Location = New System.Drawing.Point(0, 50)
        Me.VendorFileTreeView.Name = "VendorFileTreeView"
        Me.VendorFileTreeView.SelectedImageIndex = 0
        Me.VendorFileTreeView.Size = New System.Drawing.Size(238, 241)
        Me.VendorFileTreeView.TabIndex = 10
        '
        'VendorFileImageList
        '
        Me.VendorFileImageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.VendorFileImageList.ImageSize = New System.Drawing.Size(16, 16)
        Me.VendorFileImageList.TransparentColor = System.Drawing.Color.Magenta
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
        'LegendRootPhoneTSLabel
        '
        Me.LegendRootPhoneTSLabel.AutoSize = False
        Me.LegendRootPhoneTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Phone
        Me.LegendRootPhoneTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendRootPhoneTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendRootPhoneTSLabel.Name = "LegendRootPhoneTSLabel"
        Me.LegendRootPhoneTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendRootPhoneTSLabel.Text = "Phone Surveys"
        Me.LegendRootPhoneTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendRootWebTSLabel
        '
        Me.LegendRootWebTSLabel.AutoSize = False
        Me.LegendRootWebTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Web
        Me.LegendRootWebTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendRootWebTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendRootWebTSLabel.Name = "LegendRootWebTSLabel"
        Me.LegendRootWebTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendRootWebTSLabel.Text = "Web Surveys"
        Me.LegendRootWebTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendRootIVRTSLabel
        '
        Me.LegendRootIVRTSLabel.AutoSize = False
        Me.LegendRootIVRTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.IVR
        Me.LegendRootIVRTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendRootIVRTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendRootIVRTSLabel.Name = "LegendRootIVRTSLabel"
        Me.LegendRootIVRTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendRootIVRTSLabel.Text = "IVR Surveys"
        Me.LegendRootIVRTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendRootMailWebTSLabel
        '
        Me.LegendRootMailWebTSLabel.AutoSize = False
        Me.LegendRootMailWebTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.MailWeb
        Me.LegendRootMailWebTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendRootMailWebTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendRootMailWebTSLabel.Name = "LegendRootMailWebTSLabel"
        Me.LegendRootMailWebTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendRootMailWebTSLabel.Text = "Mail/Web"
        Me.LegendRootMailWebTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.AutoSize = False
        Me.ToolStripLabel1.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Bedside
        Me.ToolStripLabel1.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.ToolStripLabel1.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(110, 16)
        Me.ToolStripLabel1.Text = "Bedside Surveys"
        Me.ToolStripLabel1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendClientTSLabel
        '
        Me.LegendClientTSLabel.AutoSize = False
        Me.LegendClientTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Member32
        Me.LegendClientTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendClientTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendClientTSLabel.Name = "LegendClientTSLabel"
        Me.LegendClientTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendClientTSLabel.Text = "Client"
        Me.LegendClientTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendStudyTSLabel
        '
        Me.LegendStudyTSLabel.AutoSize = False
        Me.LegendStudyTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Study
        Me.LegendStudyTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendStudyTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendStudyTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendStudyTSLabel.Name = "LegendStudyTSLabel"
        Me.LegendStudyTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendStudyTSLabel.Text = "Study"
        Me.LegendStudyTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendSurveyTSLabel
        '
        Me.LegendSurveyTSLabel.AutoSize = False
        Me.LegendSurveyTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Survey
        Me.LegendSurveyTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendSurveyTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendSurveyTSLabel.Name = "LegendSurveyTSLabel"
        Me.LegendSurveyTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendSurveyTSLabel.Text = "Survey"
        Me.LegendSurveyTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileProcessingTSLabel
        '
        Me.LegendFileProcessingTSLabel.AutoSize = False
        Me.LegendFileProcessingTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DocumentRed16
        Me.LegendFileProcessingTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileProcessingTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFileProcessingTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileProcessingTSLabel.Name = "LegendFileProcessingTSLabel"
        Me.LegendFileProcessingTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFileProcessingTSLabel.Text = "File - Processing"
        Me.LegendFileProcessingTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileProcessingFailTSLabel
        '
        Me.LegendFileProcessingFailTSLabel.AutoSize = False
        Me.LegendFileProcessingFailTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.NoWay16
        Me.LegendFileProcessingFailTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileProcessingFailTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFileProcessingFailTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileProcessingFailTSLabel.Name = "LegendFileProcessingFailTSLabel"
        Me.LegendFileProcessingFailTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFileProcessingFailTSLabel.Text = "File - Proc Failed"
        Me.LegendFileProcessingFailTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFilePendingTSLabel
        '
        Me.LegendFilePendingTSLabel.AutoSize = False
        Me.LegendFilePendingTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DocumentYellow16
        Me.LegendFilePendingTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFilePendingTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFilePendingTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFilePendingTSLabel.Name = "LegendFilePendingTSLabel"
        Me.LegendFilePendingTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFilePendingTSLabel.Text = "File - Pending"
        Me.LegendFilePendingTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileApprovedTSLabel
        '
        Me.LegendFileApprovedTSLabel.AutoSize = False
        Me.LegendFileApprovedTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DocumentGreen16
        Me.LegendFileApprovedTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileApprovedTSLabel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LegendFileApprovedTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileApprovedTSLabel.Name = "LegendFileApprovedTSLabel"
        Me.LegendFileApprovedTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFileApprovedTSLabel.Text = "File - Approved"
        Me.LegendFileApprovedTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileTelematchingTSLabel
        '
        Me.LegendFileTelematchingTSLabel.AutoSize = False
        Me.LegendFileTelematchingTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Document16
        Me.LegendFileTelematchingTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileTelematchingTSLabel.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None
        Me.LegendFileTelematchingTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileTelematchingTSLabel.Name = "LegendFileTelematchingTSLabel"
        Me.LegendFileTelematchingTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFileTelematchingTSLabel.Text = "File - Telematch"
        Me.LegendFileTelematchingTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendFileSentTSLabel
        '
        Me.LegendFileSentTSLabel.AutoSize = False
        Me.LegendFileSentTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Validation16
        Me.LegendFileSentTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendFileSentTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendFileSentTSLabel.Name = "LegendFileSentTSLabel"
        Me.LegendFileSentTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendFileSentTSLabel.Text = "File - Sent"
        Me.LegendFileSentTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LegendRootLetterWebTSLabel
        '
        Me.LegendRootLetterWebTSLabel.AutoSize = False
        Me.LegendRootLetterWebTSLabel.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.LetterWeb
        Me.LegendRootLetterWebTSLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LegendRootLetterWebTSLabel.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None
        Me.LegendRootLetterWebTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.LegendRootLetterWebTSLabel.Name = "LegendRootLetterWebTSLabel"
        Me.LegendRootLetterWebTSLabel.Size = New System.Drawing.Size(110, 16)
        Me.LegendRootLetterWebTSLabel.Text = "Letter/Web"
        Me.LegendRootLetterWebTSLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'VendorFileRefreshTSButton
        '
        Me.VendorFileRefreshTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.VendorFileRefreshTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Refresh16
        Me.VendorFileRefreshTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.VendorFileRefreshTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.VendorFileRefreshTSButton.Name = "VendorFileRefreshTSButton"
        Me.VendorFileRefreshTSButton.Size = New System.Drawing.Size(23, 22)
        Me.VendorFileRefreshTSButton.Text = "Refresh"
        '
        'VendorFileFontDownTSButton
        '
        Me.VendorFileFontDownTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.VendorFileFontDownTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GroupCollapse15
        Me.VendorFileFontDownTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.VendorFileFontDownTSButton.Name = "VendorFileFontDownTSButton"
        Me.VendorFileFontDownTSButton.Size = New System.Drawing.Size(23, 22)
        Me.VendorFileFontDownTSButton.Text = "Smaller Font"
        '
        'VendorFileFontUpTSButton
        '
        Me.VendorFileFontUpTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.VendorFileFontUpTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GroupExpand15
        Me.VendorFileFontUpTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.VendorFileFontUpTSButton.Name = "VendorFileFontUpTSButton"
        Me.VendorFileFontUpTSButton.Size = New System.Drawing.Size(23, 22)
        Me.VendorFileFontUpTSButton.Text = "Larger Font"
        '
        'VendorFileHideTSButton
        '
        Me.VendorFileHideTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.VendorFileHideTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.YellowLight
        Me.VendorFileHideTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.VendorFileHideTSButton.Name = "VendorFileHideTSButton"
        Me.VendorFileHideTSButton.Size = New System.Drawing.Size(23, 22)
        Me.VendorFileHideTSButton.Text = "Hide/UnHide File"
        '
        'VendorFileShowTSButton
        '
        Me.VendorFileShowTSButton.CheckOnClick = True
        Me.VendorFileShowTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.VendorFileShowTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.GreenLight
        Me.VendorFileShowTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.VendorFileShowTSButton.Name = "VendorFileShowTSButton"
        Me.VendorFileShowTSButton.Size = New System.Drawing.Size(23, 22)
        Me.VendorFileShowTSButton.Text = "Show Hidden Files"
        '
        'VendorFileValidationNavigator
        '
        Me.Controls.Add(Me.VendorFileTreeView)
        Me.Controls.Add(Me.LegendControlToolStrip)
        Me.Controls.Add(Me.LegendToolStrip)
        Me.Controls.Add(Me.VendorFileToolStripBottom)
        Me.Controls.Add(Me.VendorFileFromDateTimePicker)
        Me.Controls.Add(Me.VendorFileFilterComboBox)
        Me.Controls.Add(Me.VendorFileToolStripTop)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "VendorFileValidationNavigator"
        Me.Size = New System.Drawing.Size(238, 468)
        Me.VendorFileToolStripTop.ResumeLayout(False)
        Me.VendorFileToolStripTop.PerformLayout()
        Me.VendorFileToolStripBottom.ResumeLayout(False)
        Me.VendorFileToolStripBottom.PerformLayout()
        Me.LegendToolStrip.ResumeLayout(False)
        Me.LegendToolStrip.PerformLayout()
        Me.LegendControlToolStrip.ResumeLayout(False)
        Me.LegendControlToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents VendorFileFromDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents VendorFileFilterComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents VendorFileToolStripTop As System.Windows.Forms.ToolStrip
    Friend WithEvents VendorFileFromTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents VendorFileToolStripBottom As System.Windows.Forms.ToolStrip
    Friend WithEvents VendorFileRefreshTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents VendorFileTSSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents VendorFileFontDownTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents VendorFileFontUpTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents VendorFileTSSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents VendorFileHideTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents VendorFileShowTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents LegendToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LegendClientTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendStudyTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendSurveyTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileProcessingTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFilePendingTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileApprovedTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileTelematchingTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendControlToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents LegendControlTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendControlHideTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents LegendControlShowTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents VendorFileTreeView As System.Windows.Forms.TreeView
    Friend WithEvents VendorFileImageList As System.Windows.Forms.ImageList
    Friend WithEvents LegendFileSentTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendRootPhoneTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendRootWebTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendRootIVRTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendRootMailWebTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendFileProcessingFailTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents LegendRootLetterWebTSLabel As System.Windows.Forms.ToolStripLabel

End Class
