<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportSection
    Inherits QualiSys_Scanner_Interface.Section

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ImportSection))
        Me.MainSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ImportStatusPanel = New System.Windows.Forms.Panel
        Me.ImportProgressBar = New System.Windows.Forms.ProgressBar
        Me.ImageCountErrorLabel = New System.Windows.Forms.Label
        Me.ImageCountGoodLabel = New System.Windows.Forms.Label
        Me.ImageErrorLabel = New System.Windows.Forms.Label
        Me.ImageGoodLabel = New System.Windows.Forms.Label
        Me.ImageCountTotalLabel = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.ImageCountCurrentLabel = New System.Windows.Forms.Label
        Me.ImageCountLabel = New System.Windows.Forms.Label
        Me.MainToolStrip = New System.Windows.Forms.ToolStrip
        Me.ImageFolderTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.ImageFolderTSTextBox = New System.Windows.Forms.ToolStripTextBox
        Me.ImageCountPostTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.ImageCountTSTextBox = New System.Windows.Forms.ToolStripTextBox
        Me.ImageCountPreTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.ImportButton = New System.Windows.Forms.Button
        Me.OutputTypeGroupBox = New System.Windows.Forms.GroupBox
        Me.OutputTypeLithoCodesRadioButton = New System.Windows.Forms.RadioButton
        Me.OutputTypeBarcodesRadioButton = New System.Windows.Forms.RadioButton
        Me.OutputTypeCreateDLVRadioButton = New System.Windows.Forms.RadioButton
        Me.BarcodeEntrySectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.BarcodeEntryToolStrip = New System.Windows.Forms.ToolStrip
        Me.BarcodeTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.BarcodeTSTextBox = New System.Windows.Forms.ToolStripTextBox
        Me.NextTSButton = New System.Windows.Forms.ToolStripButton
        Me.SkipTSButton = New System.Windows.Forms.ToolStripButton
        Me.RotateCounterClockwiseTSButton = New System.Windows.Forms.ToolStripButton
        Me.RotateClockwiseTSButton = New System.Windows.Forms.ToolStripButton
        Me.ZoomOutTSButton = New System.Windows.Forms.ToolStripButton
        Me.ZoomInTSButton = New System.Windows.Forms.ToolStripButton
        Me.SurveyPanel = New System.Windows.Forms.Panel
        Me.SurveyPictureBox = New System.Windows.Forms.PictureBox
        Me.MainSectionPanel.SuspendLayout()
        Me.ImportStatusPanel.SuspendLayout()
        Me.MainToolStrip.SuspendLayout()
        Me.OutputTypeGroupBox.SuspendLayout()
        Me.BarcodeEntrySectionPanel.SuspendLayout()
        Me.BarcodeEntryToolStrip.SuspendLayout()
        Me.SurveyPanel.SuspendLayout()
        CType(Me.SurveyPictureBox, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MainSectionPanel
        '
        Me.MainSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainSectionPanel.Caption = "Import Images"
        Me.MainSectionPanel.Controls.Add(Me.ImportStatusPanel)
        Me.MainSectionPanel.Controls.Add(Me.MainToolStrip)
        Me.MainSectionPanel.Controls.Add(Me.ImportButton)
        Me.MainSectionPanel.Controls.Add(Me.OutputTypeGroupBox)
        Me.MainSectionPanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.MainSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainSectionPanel.Name = "MainSectionPanel"
        Me.MainSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainSectionPanel.ShowCaption = True
        Me.MainSectionPanel.Size = New System.Drawing.Size(542, 173)
        Me.MainSectionPanel.TabIndex = 0
        '
        'ImportStatusPanel
        '
        Me.ImportStatusPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImportStatusPanel.Controls.Add(Me.ImportProgressBar)
        Me.ImportStatusPanel.Controls.Add(Me.ImageCountErrorLabel)
        Me.ImportStatusPanel.Controls.Add(Me.ImageCountGoodLabel)
        Me.ImportStatusPanel.Controls.Add(Me.ImageErrorLabel)
        Me.ImportStatusPanel.Controls.Add(Me.ImageGoodLabel)
        Me.ImportStatusPanel.Controls.Add(Me.ImageCountTotalLabel)
        Me.ImportStatusPanel.Controls.Add(Me.Label3)
        Me.ImportStatusPanel.Controls.Add(Me.ImageCountCurrentLabel)
        Me.ImportStatusPanel.Controls.Add(Me.ImageCountLabel)
        Me.ImportStatusPanel.Location = New System.Drawing.Point(234, 66)
        Me.ImportStatusPanel.Name = "ImportStatusPanel"
        Me.ImportStatusPanel.Size = New System.Drawing.Size(304, 100)
        Me.ImportStatusPanel.TabIndex = 15
        '
        'ImportProgressBar
        '
        Me.ImportProgressBar.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImportProgressBar.Location = New System.Drawing.Point(7, 72)
        Me.ImportProgressBar.Name = "ImportProgressBar"
        Me.ImportProgressBar.Size = New System.Drawing.Size(287, 23)
        Me.ImportProgressBar.TabIndex = 31
        '
        'ImageCountErrorLabel
        '
        Me.ImageCountErrorLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImageCountErrorLabel.Location = New System.Drawing.Point(245, 51)
        Me.ImageCountErrorLabel.Name = "ImageCountErrorLabel"
        Me.ImageCountErrorLabel.Size = New System.Drawing.Size(49, 13)
        Me.ImageCountErrorLabel.TabIndex = 30
        Me.ImageCountErrorLabel.Text = "0"
        Me.ImageCountErrorLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'ImageCountGoodLabel
        '
        Me.ImageCountGoodLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImageCountGoodLabel.Location = New System.Drawing.Point(245, 30)
        Me.ImageCountGoodLabel.Name = "ImageCountGoodLabel"
        Me.ImageCountGoodLabel.Size = New System.Drawing.Size(49, 13)
        Me.ImageCountGoodLabel.TabIndex = 29
        Me.ImageCountGoodLabel.Text = "0"
        Me.ImageCountGoodLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'ImageErrorLabel
        '
        Me.ImageErrorLabel.AutoSize = True
        Me.ImageErrorLabel.Location = New System.Drawing.Point(9, 51)
        Me.ImageErrorLabel.Name = "ImageErrorLabel"
        Me.ImageErrorLabel.Size = New System.Drawing.Size(132, 13)
        Me.ImageErrorLabel.TabIndex = 28
        Me.ImageErrorLabel.Text = "Barcodes Unable to Read:"
        '
        'ImageGoodLabel
        '
        Me.ImageGoodLabel.AutoSize = True
        Me.ImageGoodLabel.Location = New System.Drawing.Point(9, 30)
        Me.ImageGoodLabel.Name = "ImageGoodLabel"
        Me.ImageGoodLabel.Size = New System.Drawing.Size(144, 13)
        Me.ImageGoodLabel.TabIndex = 27
        Me.ImageGoodLabel.Text = "Barcodes Read Successfully:"
        '
        'ImageCountTotalLabel
        '
        Me.ImageCountTotalLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImageCountTotalLabel.Location = New System.Drawing.Point(245, 9)
        Me.ImageCountTotalLabel.Name = "ImageCountTotalLabel"
        Me.ImageCountTotalLabel.Size = New System.Drawing.Size(49, 13)
        Me.ImageCountTotalLabel.TabIndex = 26
        Me.ImageCountTotalLabel.Text = "0"
        Me.ImageCountTotalLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'Label3
        '
        Me.Label3.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(221, 9)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(17, 13)
        Me.Label3.TabIndex = 25
        Me.Label3.Text = "of"
        '
        'ImageCountCurrentLabel
        '
        Me.ImageCountCurrentLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImageCountCurrentLabel.Location = New System.Drawing.Point(168, 9)
        Me.ImageCountCurrentLabel.Name = "ImageCountCurrentLabel"
        Me.ImageCountCurrentLabel.Size = New System.Drawing.Size(49, 13)
        Me.ImageCountCurrentLabel.TabIndex = 24
        Me.ImageCountCurrentLabel.Text = "0"
        Me.ImageCountCurrentLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'ImageCountLabel
        '
        Me.ImageCountLabel.AutoSize = True
        Me.ImageCountLabel.Location = New System.Drawing.Point(9, 9)
        Me.ImageCountLabel.Name = "ImageCountLabel"
        Me.ImageCountLabel.Size = New System.Drawing.Size(143, 13)
        Me.ImageCountLabel.TabIndex = 23
        Me.ImageCountLabel.Text = "Currently Processing Image:"
        '
        'MainToolStrip
        '
        Me.MainToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.MainToolStrip.ImageScalingSize = New System.Drawing.Size(16, 24)
        Me.MainToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ImageFolderTSLabel, Me.ImageFolderTSTextBox, Me.ImageCountPostTSLabel, Me.ImageCountTSTextBox, Me.ImageCountPreTSLabel})
        Me.MainToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.MainToolStrip.MinimumSize = New System.Drawing.Size(0, 33)
        Me.MainToolStrip.Name = "MainToolStrip"
        Me.MainToolStrip.Size = New System.Drawing.Size(540, 33)
        Me.MainToolStrip.TabIndex = 14
        Me.MainToolStrip.Text = "ToolStrip1"
        '
        'ImageFolderTSLabel
        '
        Me.ImageFolderTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.ImageFolderTSLabel.Name = "ImageFolderTSLabel"
        Me.ImageFolderTSLabel.Size = New System.Drawing.Size(41, 30)
        Me.ImageFolderTSLabel.Text = "Folder:"
        '
        'ImageFolderTSTextBox
        '
        Me.ImageFolderTSTextBox.Name = "ImageFolderTSTextBox"
        Me.ImageFolderTSTextBox.ReadOnly = True
        Me.ImageFolderTSTextBox.Size = New System.Drawing.Size(250, 33)
        '
        'ImageCountPostTSLabel
        '
        Me.ImageCountPostTSLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ImageCountPostTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 5, 2)
        Me.ImageCountPostTSLabel.Name = "ImageCountPostTSLabel"
        Me.ImageCountPostTSLabel.Size = New System.Drawing.Size(40, 30)
        Me.ImageCountPostTSLabel.Text = "images"
        '
        'ImageCountTSTextBox
        '
        Me.ImageCountTSTextBox.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ImageCountTSTextBox.Name = "ImageCountTSTextBox"
        Me.ImageCountTSTextBox.ReadOnly = True
        Me.ImageCountTSTextBox.Size = New System.Drawing.Size(100, 33)
        '
        'ImageCountPreTSLabel
        '
        Me.ImageCountPreTSLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ImageCountPreTSLabel.Margin = New System.Windows.Forms.Padding(0, 1, 2, 2)
        Me.ImageCountPreTSLabel.Name = "ImageCountPreTSLabel"
        Me.ImageCountPreTSLabel.Size = New System.Drawing.Size(53, 30)
        Me.ImageCountPreTSLabel.Text = "Contains:"
        '
        'ImportButton
        '
        Me.ImportButton.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ImportButton.Location = New System.Drawing.Point(153, 73)
        Me.ImportButton.Name = "ImportButton"
        Me.ImportButton.Size = New System.Drawing.Size(75, 88)
        Me.ImportButton.TabIndex = 4
        Me.ImportButton.Text = "Import Images"
        Me.ImportButton.UseVisualStyleBackColor = True
        '
        'OutputTypeGroupBox
        '
        Me.OutputTypeGroupBox.Controls.Add(Me.OutputTypeLithoCodesRadioButton)
        Me.OutputTypeGroupBox.Controls.Add(Me.OutputTypeBarcodesRadioButton)
        Me.OutputTypeGroupBox.Controls.Add(Me.OutputTypeCreateDLVRadioButton)
        Me.OutputTypeGroupBox.Location = New System.Drawing.Point(12, 66)
        Me.OutputTypeGroupBox.Name = "OutputTypeGroupBox"
        Me.OutputTypeGroupBox.Size = New System.Drawing.Size(126, 95)
        Me.OutputTypeGroupBox.TabIndex = 3
        Me.OutputTypeGroupBox.TabStop = False
        Me.OutputTypeGroupBox.Text = " Output Type "
        '
        'OutputTypeLithoCodesRadioButton
        '
        Me.OutputTypeLithoCodesRadioButton.AutoSize = True
        Me.OutputTypeLithoCodesRadioButton.Location = New System.Drawing.Point(12, 67)
        Me.OutputTypeLithoCodesRadioButton.Name = "OutputTypeLithoCodesRadioButton"
        Me.OutputTypeLithoCodesRadioButton.Size = New System.Drawing.Size(78, 17)
        Me.OutputTypeLithoCodesRadioButton.TabIndex = 2
        Me.OutputTypeLithoCodesRadioButton.TabStop = True
        Me.OutputTypeLithoCodesRadioButton.Text = "LithoCodes"
        Me.OutputTypeLithoCodesRadioButton.UseVisualStyleBackColor = True
        '
        'OutputTypeBarcodesRadioButton
        '
        Me.OutputTypeBarcodesRadioButton.AutoSize = True
        Me.OutputTypeBarcodesRadioButton.Location = New System.Drawing.Point(12, 44)
        Me.OutputTypeBarcodesRadioButton.Name = "OutputTypeBarcodesRadioButton"
        Me.OutputTypeBarcodesRadioButton.Size = New System.Drawing.Size(69, 17)
        Me.OutputTypeBarcodesRadioButton.TabIndex = 1
        Me.OutputTypeBarcodesRadioButton.TabStop = True
        Me.OutputTypeBarcodesRadioButton.Text = "Barcodes"
        Me.OutputTypeBarcodesRadioButton.UseVisualStyleBackColor = True
        '
        'OutputTypeCreateDLVRadioButton
        '
        Me.OutputTypeCreateDLVRadioButton.AutoSize = True
        Me.OutputTypeCreateDLVRadioButton.Location = New System.Drawing.Point(12, 20)
        Me.OutputTypeCreateDLVRadioButton.Name = "OutputTypeCreateDLVRadioButton"
        Me.OutputTypeCreateDLVRadioButton.Size = New System.Drawing.Size(96, 17)
        Me.OutputTypeCreateDLVRadioButton.TabIndex = 0
        Me.OutputTypeCreateDLVRadioButton.TabStop = True
        Me.OutputTypeCreateDLVRadioButton.Text = "Create DLV file"
        Me.OutputTypeCreateDLVRadioButton.UseVisualStyleBackColor = True
        '
        'BarcodeEntrySectionPanel
        '
        Me.BarcodeEntrySectionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodeEntrySectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.BarcodeEntrySectionPanel.Caption = "Barcode Entry"
        Me.BarcodeEntrySectionPanel.Controls.Add(Me.BarcodeEntryToolStrip)
        Me.BarcodeEntrySectionPanel.Controls.Add(Me.SurveyPanel)
        Me.BarcodeEntrySectionPanel.Location = New System.Drawing.Point(0, 179)
        Me.BarcodeEntrySectionPanel.Name = "BarcodeEntrySectionPanel"
        Me.BarcodeEntrySectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.BarcodeEntrySectionPanel.ShowCaption = True
        Me.BarcodeEntrySectionPanel.Size = New System.Drawing.Size(542, 446)
        Me.BarcodeEntrySectionPanel.TabIndex = 1
        '
        'BarcodeEntryToolStrip
        '
        Me.BarcodeEntryToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.BarcodeEntryToolStrip.ImageScalingSize = New System.Drawing.Size(16, 24)
        Me.BarcodeEntryToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BarcodeTSLabel, Me.BarcodeTSTextBox, Me.NextTSButton, Me.SkipTSButton, Me.RotateCounterClockwiseTSButton, Me.RotateClockwiseTSButton, Me.ZoomOutTSButton, Me.ZoomInTSButton})
        Me.BarcodeEntryToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.BarcodeEntryToolStrip.MinimumSize = New System.Drawing.Size(0, 33)
        Me.BarcodeEntryToolStrip.Name = "BarcodeEntryToolStrip"
        Me.BarcodeEntryToolStrip.Size = New System.Drawing.Size(540, 33)
        Me.BarcodeEntryToolStrip.TabIndex = 15
        Me.BarcodeEntryToolStrip.Text = "ToolStrip2"
        '
        'BarcodeTSLabel
        '
        Me.BarcodeTSLabel.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.BarcodeTSLabel.Name = "BarcodeTSLabel"
        Me.BarcodeTSLabel.Size = New System.Drawing.Size(50, 30)
        Me.BarcodeTSLabel.Text = "Barcode:"
        '
        'BarcodeTSTextBox
        '
        Me.BarcodeTSTextBox.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.BarcodeTSTextBox.MaxLength = 8
        Me.BarcodeTSTextBox.Name = "BarcodeTSTextBox"
        Me.BarcodeTSTextBox.Size = New System.Drawing.Size(100, 33)
        '
        'NextTSButton
        '
        Me.NextTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.NextTSButton.Image = CType(resources.GetObject("NextTSButton.Image"), System.Drawing.Image)
        Me.NextTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NextTSButton.Name = "NextTSButton"
        Me.NextTSButton.Size = New System.Drawing.Size(34, 30)
        Me.NextTSButton.Text = "Next"
        '
        'SkipTSButton
        '
        Me.SkipTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.SkipTSButton.Image = CType(resources.GetObject("SkipTSButton.Image"), System.Drawing.Image)
        Me.SkipTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SkipTSButton.Name = "SkipTSButton"
        Me.SkipTSButton.Size = New System.Drawing.Size(30, 30)
        Me.SkipTSButton.Text = "Skip"
        '
        'RotateCounterClockwiseTSButton
        '
        Me.RotateCounterClockwiseTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.RotateCounterClockwiseTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.RotateCounterClockwiseTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Rotate_Counterclockwise
        Me.RotateCounterClockwiseTSButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None
        Me.RotateCounterClockwiseTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.RotateCounterClockwiseTSButton.Name = "RotateCounterClockwiseTSButton"
        Me.RotateCounterClockwiseTSButton.Size = New System.Drawing.Size(23, 30)
        Me.RotateCounterClockwiseTSButton.Text = "ToolStripButton3"
        '
        'RotateClockwiseTSButton
        '
        Me.RotateClockwiseTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.RotateClockwiseTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.RotateClockwiseTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Rotate_Clockwise
        Me.RotateClockwiseTSButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None
        Me.RotateClockwiseTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.RotateClockwiseTSButton.Name = "RotateClockwiseTSButton"
        Me.RotateClockwiseTSButton.Size = New System.Drawing.Size(23, 30)
        Me.RotateClockwiseTSButton.Text = "ToolStripButton4"
        '
        'ZoomOutTSButton
        '
        Me.ZoomOutTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ZoomOutTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ZoomOutTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Zoom_Out
        Me.ZoomOutTSButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None
        Me.ZoomOutTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.ZoomOutTSButton.Name = "ZoomOutTSButton"
        Me.ZoomOutTSButton.Size = New System.Drawing.Size(23, 30)
        Me.ZoomOutTSButton.Text = "ToolStripButton5"
        '
        'ZoomInTSButton
        '
        Me.ZoomInTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ZoomInTSButton.AutoSize = False
        Me.ZoomInTSButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ZoomInTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Zoom_In
        Me.ZoomInTSButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None
        Me.ZoomInTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.ZoomInTSButton.Name = "ZoomInTSButton"
        Me.ZoomInTSButton.Size = New System.Drawing.Size(23, 30)
        Me.ZoomInTSButton.Text = "ToolStripButton6"
        '
        'SurveyPanel
        '
        Me.SurveyPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SurveyPanel.AutoScroll = True
        Me.SurveyPanel.Controls.Add(Me.SurveyPictureBox)
        Me.SurveyPanel.Location = New System.Drawing.Point(1, 60)
        Me.SurveyPanel.Name = "SurveyPanel"
        Me.SurveyPanel.Size = New System.Drawing.Size(540, 385)
        Me.SurveyPanel.TabIndex = 17
        '
        'SurveyPictureBox
        '
        Me.SurveyPictureBox.Location = New System.Drawing.Point(0, 0)
        Me.SurveyPictureBox.Name = "SurveyPictureBox"
        Me.SurveyPictureBox.Size = New System.Drawing.Size(20, 20)
        Me.SurveyPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize
        Me.SurveyPictureBox.TabIndex = 0
        Me.SurveyPictureBox.TabStop = False
        '
        'ImportSection
        '
        Me.Controls.Add(Me.BarcodeEntrySectionPanel)
        Me.Controls.Add(Me.MainSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ImportSection"
        Me.Size = New System.Drawing.Size(542, 625)
        Me.MainSectionPanel.ResumeLayout(False)
        Me.MainSectionPanel.PerformLayout()
        Me.ImportStatusPanel.ResumeLayout(False)
        Me.ImportStatusPanel.PerformLayout()
        Me.MainToolStrip.ResumeLayout(False)
        Me.MainToolStrip.PerformLayout()
        Me.OutputTypeGroupBox.ResumeLayout(False)
        Me.OutputTypeGroupBox.PerformLayout()
        Me.BarcodeEntrySectionPanel.ResumeLayout(False)
        Me.BarcodeEntrySectionPanel.PerformLayout()
        Me.BarcodeEntryToolStrip.ResumeLayout(False)
        Me.BarcodeEntryToolStrip.PerformLayout()
        Me.SurveyPanel.ResumeLayout(False)
        Me.SurveyPanel.PerformLayout()
        CType(Me.SurveyPictureBox, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents OutputTypeGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents OutputTypeLithoCodesRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents OutputTypeBarcodesRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents OutputTypeCreateDLVRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents ImportButton As System.Windows.Forms.Button
    Friend WithEvents MainToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ImageFolderTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ImageFolderTSTextBox As System.Windows.Forms.ToolStripTextBox
    Friend WithEvents ImageCountPostTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ImageCountTSTextBox As System.Windows.Forms.ToolStripTextBox
    Friend WithEvents ImageCountPreTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ImportStatusPanel As System.Windows.Forms.Panel
    Friend WithEvents BarcodeEntrySectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ImportProgressBar As System.Windows.Forms.ProgressBar
    Friend WithEvents ImageCountErrorLabel As System.Windows.Forms.Label
    Friend WithEvents ImageCountGoodLabel As System.Windows.Forms.Label
    Friend WithEvents ImageErrorLabel As System.Windows.Forms.Label
    Friend WithEvents ImageGoodLabel As System.Windows.Forms.Label
    Friend WithEvents ImageCountTotalLabel As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents ImageCountCurrentLabel As System.Windows.Forms.Label
    Friend WithEvents ImageCountLabel As System.Windows.Forms.Label
    Friend WithEvents BarcodeEntryToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents BarcodeTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents BarcodeTSTextBox As System.Windows.Forms.ToolStripTextBox
    Friend WithEvents NextTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SkipTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RotateCounterClockwiseTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RotateClockwiseTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ZoomOutTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ZoomInTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SurveyPanel As System.Windows.Forms.Panel
    Friend WithEvents SurveyPictureBox As System.Windows.Forms.PictureBox

End Class
