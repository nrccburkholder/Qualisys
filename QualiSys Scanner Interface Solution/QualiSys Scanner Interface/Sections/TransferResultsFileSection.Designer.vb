<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class TransferResultsFileSection
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
        Me.components = New System.ComponentModel.Container
        Me.FileSplitContainer = New System.Windows.Forms.SplitContainer
        Me.FileInfoSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.FileInfoTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.FileInfoRightPanel = New System.Windows.Forms.Panel
        Me.DispositionUpdateTextBox = New System.Windows.Forms.TextBox
        Me.DispositionUpdateLabel = New System.Windows.Forms.Label
        Me.RecordCountTextBox = New System.Windows.Forms.TextBox
        Me.SurveyCountTextBox = New System.Windows.Forms.TextBox
        Me.RecordCountLabel = New System.Windows.Forms.Label
        Me.SurveyCountLabel = New System.Windows.Forms.Label
        Me.FileInfoLeftPanel = New System.Windows.Forms.Panel
        Me.DateLoadedTextBox = New System.Windows.Forms.TextBox
        Me.DisplayNameTextBox = New System.Windows.Forms.TextBox
        Me.OriginalFileNameTextBox = New System.Windows.Forms.TextBox
        Me.DateLoadedLabel = New System.Windows.Forms.Label
        Me.DisplayNameLabel = New System.Windows.Forms.Label
        Me.OriginalFileNameLabel = New System.Windows.Forms.Label
        Me.FileDetailSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.FileDetailTabControl = New System.Windows.Forms.TabControl
        Me.BadLithoCodeDataTabPage = New System.Windows.Forms.TabPage
        Me.BadLithoCodeDataGrid = New DevExpress.XtraGrid.GridControl
        Me.BadLithoCodeDataBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.BadLithoCodeDataGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colBadLithoId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDataLoadId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colBadLithoCode = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FileDetailToolStrip = New System.Windows.Forms.ToolStrip
        Me.FileDetailExcelTSButton = New System.Windows.Forms.ToolStripButton
        Me.FileDetailSaveFileDialog = New System.Windows.Forms.SaveFileDialog
        Me.FileImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.FileSplitContainer.Panel1.SuspendLayout()
        Me.FileSplitContainer.Panel2.SuspendLayout()
        Me.FileSplitContainer.SuspendLayout()
        Me.FileInfoSectionPanel.SuspendLayout()
        Me.FileInfoTableLayoutPanel.SuspendLayout()
        Me.FileInfoRightPanel.SuspendLayout()
        Me.FileInfoLeftPanel.SuspendLayout()
        Me.FileDetailSectionPanel.SuspendLayout()
        Me.FileDetailTabControl.SuspendLayout()
        Me.BadLithoCodeDataTabPage.SuspendLayout()
        CType(Me.BadLithoCodeDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.BadLithoCodeDataBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.BadLithoCodeDataGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.FileDetailToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'FileSplitContainer
        '
        Me.FileSplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileSplitContainer.Location = New System.Drawing.Point(0, 0)
        Me.FileSplitContainer.Name = "FileSplitContainer"
        Me.FileSplitContainer.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'FileSplitContainer.Panel1
        '
        Me.FileSplitContainer.Panel1.Controls.Add(Me.FileInfoSectionPanel)
        Me.FileSplitContainer.Panel1MinSize = 130
        '
        'FileSplitContainer.Panel2
        '
        Me.FileSplitContainer.Panel2.Controls.Add(Me.FileDetailSectionPanel)
        Me.FileSplitContainer.Size = New System.Drawing.Size(645, 514)
        Me.FileSplitContainer.SplitterDistance = 130
        Me.FileSplitContainer.TabIndex = 0
        '
        'FileInfoSectionPanel
        '
        Me.FileInfoSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.FileInfoSectionPanel.Caption = "File Information"
        Me.FileInfoSectionPanel.Controls.Add(Me.FileInfoTableLayoutPanel)
        Me.FileInfoSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileInfoSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.FileInfoSectionPanel.Name = "FileInfoSectionPanel"
        Me.FileInfoSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.FileInfoSectionPanel.ShowCaption = True
        Me.FileInfoSectionPanel.Size = New System.Drawing.Size(645, 130)
        Me.FileInfoSectionPanel.TabIndex = 0
        '
        'FileInfoTableLayoutPanel
        '
        Me.FileInfoTableLayoutPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileInfoTableLayoutPanel.ColumnCount = 2
        Me.FileInfoTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FileInfoTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FileInfoTableLayoutPanel.Controls.Add(Me.FileInfoRightPanel, 1, 0)
        Me.FileInfoTableLayoutPanel.Controls.Add(Me.FileInfoLeftPanel, 0, 0)
        Me.FileInfoTableLayoutPanel.Location = New System.Drawing.Point(4, 30)
        Me.FileInfoTableLayoutPanel.Name = "FileInfoTableLayoutPanel"
        Me.FileInfoTableLayoutPanel.RowCount = 1
        Me.FileInfoTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FileInfoTableLayoutPanel.Size = New System.Drawing.Size(637, 96)
        Me.FileInfoTableLayoutPanel.TabIndex = 1
        '
        'FileInfoRightPanel
        '
        Me.FileInfoRightPanel.Controls.Add(Me.DispositionUpdateTextBox)
        Me.FileInfoRightPanel.Controls.Add(Me.DispositionUpdateLabel)
        Me.FileInfoRightPanel.Controls.Add(Me.RecordCountTextBox)
        Me.FileInfoRightPanel.Controls.Add(Me.SurveyCountTextBox)
        Me.FileInfoRightPanel.Controls.Add(Me.RecordCountLabel)
        Me.FileInfoRightPanel.Controls.Add(Me.SurveyCountLabel)
        Me.FileInfoRightPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileInfoRightPanel.Location = New System.Drawing.Point(321, 3)
        Me.FileInfoRightPanel.Name = "FileInfoRightPanel"
        Me.FileInfoRightPanel.Size = New System.Drawing.Size(313, 90)
        Me.FileInfoRightPanel.TabIndex = 1
        '
        'DispositionUpdateTextBox
        '
        Me.DispositionUpdateTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DispositionUpdateTextBox.Location = New System.Drawing.Point(119, 62)
        Me.DispositionUpdateTextBox.Name = "DispositionUpdateTextBox"
        Me.DispositionUpdateTextBox.ReadOnly = True
        Me.DispositionUpdateTextBox.Size = New System.Drawing.Size(186, 21)
        Me.DispositionUpdateTextBox.TabIndex = 16
        '
        'DispositionUpdateLabel
        '
        Me.DispositionUpdateLabel.AutoSize = True
        Me.DispositionUpdateLabel.Location = New System.Drawing.Point(8, 65)
        Me.DispositionUpdateLabel.Name = "DispositionUpdateLabel"
        Me.DispositionUpdateLabel.Size = New System.Drawing.Size(105, 13)
        Me.DispositionUpdateLabel.TabIndex = 15
        Me.DispositionUpdateLabel.Text = "Disposition Updates:"
        '
        'RecordCountTextBox
        '
        Me.RecordCountTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RecordCountTextBox.Location = New System.Drawing.Point(119, 35)
        Me.RecordCountTextBox.Name = "RecordCountTextBox"
        Me.RecordCountTextBox.ReadOnly = True
        Me.RecordCountTextBox.Size = New System.Drawing.Size(186, 21)
        Me.RecordCountTextBox.TabIndex = 14
        '
        'SurveyCountTextBox
        '
        Me.SurveyCountTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SurveyCountTextBox.Location = New System.Drawing.Point(119, 8)
        Me.SurveyCountTextBox.Name = "SurveyCountTextBox"
        Me.SurveyCountTextBox.ReadOnly = True
        Me.SurveyCountTextBox.Size = New System.Drawing.Size(186, 21)
        Me.SurveyCountTextBox.TabIndex = 13
        '
        'RecordCountLabel
        '
        Me.RecordCountLabel.AutoSize = True
        Me.RecordCountLabel.Location = New System.Drawing.Point(8, 38)
        Me.RecordCountLabel.Name = "RecordCountLabel"
        Me.RecordCountLabel.Size = New System.Drawing.Size(77, 13)
        Me.RecordCountLabel.TabIndex = 10
        Me.RecordCountLabel.Text = "Record Count:"
        '
        'SurveyCountLabel
        '
        Me.SurveyCountLabel.AutoSize = True
        Me.SurveyCountLabel.Location = New System.Drawing.Point(8, 11)
        Me.SurveyCountLabel.Name = "SurveyCountLabel"
        Me.SurveyCountLabel.Size = New System.Drawing.Size(77, 13)
        Me.SurveyCountLabel.TabIndex = 11
        Me.SurveyCountLabel.Text = "Survey Count:"
        '
        'FileInfoLeftPanel
        '
        Me.FileInfoLeftPanel.Controls.Add(Me.DateLoadedTextBox)
        Me.FileInfoLeftPanel.Controls.Add(Me.DisplayNameTextBox)
        Me.FileInfoLeftPanel.Controls.Add(Me.OriginalFileNameTextBox)
        Me.FileInfoLeftPanel.Controls.Add(Me.DateLoadedLabel)
        Me.FileInfoLeftPanel.Controls.Add(Me.DisplayNameLabel)
        Me.FileInfoLeftPanel.Controls.Add(Me.OriginalFileNameLabel)
        Me.FileInfoLeftPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileInfoLeftPanel.Location = New System.Drawing.Point(3, 3)
        Me.FileInfoLeftPanel.Name = "FileInfoLeftPanel"
        Me.FileInfoLeftPanel.Size = New System.Drawing.Size(312, 90)
        Me.FileInfoLeftPanel.TabIndex = 0
        '
        'DateLoadedTextBox
        '
        Me.DateLoadedTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DateLoadedTextBox.Location = New System.Drawing.Point(104, 62)
        Me.DateLoadedTextBox.Name = "DateLoadedTextBox"
        Me.DateLoadedTextBox.ReadOnly = True
        Me.DateLoadedTextBox.Size = New System.Drawing.Size(201, 21)
        Me.DateLoadedTextBox.TabIndex = 9
        '
        'DisplayNameTextBox
        '
        Me.DisplayNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DisplayNameTextBox.Location = New System.Drawing.Point(104, 35)
        Me.DisplayNameTextBox.Name = "DisplayNameTextBox"
        Me.DisplayNameTextBox.ReadOnly = True
        Me.DisplayNameTextBox.Size = New System.Drawing.Size(201, 21)
        Me.DisplayNameTextBox.TabIndex = 8
        '
        'OriginalFileNameTextBox
        '
        Me.OriginalFileNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OriginalFileNameTextBox.Location = New System.Drawing.Point(104, 8)
        Me.OriginalFileNameTextBox.Name = "OriginalFileNameTextBox"
        Me.OriginalFileNameTextBox.ReadOnly = True
        Me.OriginalFileNameTextBox.Size = New System.Drawing.Size(201, 21)
        Me.OriginalFileNameTextBox.TabIndex = 7
        '
        'DateLoadedLabel
        '
        Me.DateLoadedLabel.AutoSize = True
        Me.DateLoadedLabel.Location = New System.Drawing.Point(8, 65)
        Me.DateLoadedLabel.Name = "DateLoadedLabel"
        Me.DateLoadedLabel.Size = New System.Drawing.Size(72, 13)
        Me.DateLoadedLabel.TabIndex = 5
        Me.DateLoadedLabel.Text = "Date Loaded:"
        '
        'DisplayNameLabel
        '
        Me.DisplayNameLabel.AutoSize = True
        Me.DisplayNameLabel.Location = New System.Drawing.Point(8, 38)
        Me.DisplayNameLabel.Name = "DisplayNameLabel"
        Me.DisplayNameLabel.Size = New System.Drawing.Size(75, 13)
        Me.DisplayNameLabel.TabIndex = 1
        Me.DisplayNameLabel.Text = "Display Name:"
        '
        'OriginalFileNameLabel
        '
        Me.OriginalFileNameLabel.AutoSize = True
        Me.OriginalFileNameLabel.Location = New System.Drawing.Point(8, 11)
        Me.OriginalFileNameLabel.Name = "OriginalFileNameLabel"
        Me.OriginalFileNameLabel.Size = New System.Drawing.Size(99, 13)
        Me.OriginalFileNameLabel.TabIndex = 3
        Me.OriginalFileNameLabel.Text = "Original File Name: "
        '
        'FileDetailSectionPanel
        '
        Me.FileDetailSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.FileDetailSectionPanel.Caption = "File Details"
        Me.FileDetailSectionPanel.Controls.Add(Me.FileDetailTabControl)
        Me.FileDetailSectionPanel.Controls.Add(Me.FileDetailToolStrip)
        Me.FileDetailSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileDetailSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.FileDetailSectionPanel.Name = "FileDetailSectionPanel"
        Me.FileDetailSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.FileDetailSectionPanel.ShowCaption = True
        Me.FileDetailSectionPanel.Size = New System.Drawing.Size(645, 380)
        Me.FileDetailSectionPanel.TabIndex = 0
        '
        'FileDetailTabControl
        '
        Me.FileDetailTabControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileDetailTabControl.Controls.Add(Me.BadLithoCodeDataTabPage)
        Me.FileDetailTabControl.Location = New System.Drawing.Point(6, 56)
        Me.FileDetailTabControl.Name = "FileDetailTabControl"
        Me.FileDetailTabControl.SelectedIndex = 0
        Me.FileDetailTabControl.Size = New System.Drawing.Size(633, 318)
        Me.FileDetailTabControl.TabIndex = 4
        '
        'BadLithoCodeDataTabPage
        '
        Me.BadLithoCodeDataTabPage.AutoScroll = True
        Me.BadLithoCodeDataTabPage.Controls.Add(Me.BadLithoCodeDataGrid)
        Me.BadLithoCodeDataTabPage.Location = New System.Drawing.Point(4, 22)
        Me.BadLithoCodeDataTabPage.Name = "BadLithoCodeDataTabPage"
        Me.BadLithoCodeDataTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.BadLithoCodeDataTabPage.Size = New System.Drawing.Size(625, 292)
        Me.BadLithoCodeDataTabPage.TabIndex = 4
        Me.BadLithoCodeDataTabPage.Text = "Bad Litho Code Data"
        Me.BadLithoCodeDataTabPage.UseVisualStyleBackColor = True
        '
        'BadLithoCodeDataGrid
        '
        Me.BadLithoCodeDataGrid.DataSource = Me.BadLithoCodeDataBindingSource
        Me.BadLithoCodeDataGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.BadLithoCodeDataGrid.EmbeddedNavigator.Name = ""
        Me.BadLithoCodeDataGrid.Location = New System.Drawing.Point(3, 3)
        Me.BadLithoCodeDataGrid.MainView = Me.BadLithoCodeDataGridView
        Me.BadLithoCodeDataGrid.MinimumSize = New System.Drawing.Size(400, 200)
        Me.BadLithoCodeDataGrid.Name = "BadLithoCodeDataGrid"
        Me.BadLithoCodeDataGrid.Size = New System.Drawing.Size(619, 286)
        Me.BadLithoCodeDataGrid.TabIndex = 4
        Me.BadLithoCodeDataGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.BadLithoCodeDataGridView})
        '
        'BadLithoCodeDataBindingSource
        '
        Me.BadLithoCodeDataBindingSource.DataSource = GetType(Nrc.QualiSys.Scanning.Library.BadLitho)
        '
        'BadLithoCodeDataGridView
        '
        Me.BadLithoCodeDataGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colBadLithoId, Me.colDataLoadId, Me.colBadLithoCode, Me.colDateCreated})
        Me.BadLithoCodeDataGridView.GridControl = Me.BadLithoCodeDataGrid
        Me.BadLithoCodeDataGridView.Name = "BadLithoCodeDataGridView"
        Me.BadLithoCodeDataGridView.OptionsBehavior.Editable = False
        Me.BadLithoCodeDataGridView.OptionsView.ColumnAutoWidth = False
        '
        'colBadLithoId
        '
        Me.colBadLithoId.Caption = "Bad Litho Id"
        Me.colBadLithoId.FieldName = "BadLithoId"
        Me.colBadLithoId.Fixed = DevExpress.XtraGrid.Columns.FixedStyle.Left
        Me.colBadLithoId.Name = "colBadLithoId"
        Me.colBadLithoId.OptionsColumn.ReadOnly = True
        Me.colBadLithoId.Visible = True
        Me.colBadLithoId.VisibleIndex = 0
        Me.colBadLithoId.Width = 92
        '
        'colDataLoadId
        '
        Me.colDataLoadId.Caption = "DataLoadId"
        Me.colDataLoadId.FieldName = "DataLoadId"
        Me.colDataLoadId.Name = "colDataLoadId"
        Me.colDataLoadId.Visible = True
        Me.colDataLoadId.VisibleIndex = 1
        Me.colDataLoadId.Width = 94
        '
        'colBadLithoCode
        '
        Me.colBadLithoCode.Caption = "Bad Litho Code"
        Me.colBadLithoCode.FieldName = "BadLithoCode"
        Me.colBadLithoCode.Name = "colBadLithoCode"
        Me.colBadLithoCode.Visible = True
        Me.colBadLithoCode.VisibleIndex = 2
        Me.colBadLithoCode.Width = 117
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "Date Created"
        Me.colDateCreated.DisplayFormat.FormatString = "MM/dd/yyyy HH:mm:ss"
        Me.colDateCreated.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        Me.colDateCreated.Visible = True
        Me.colDateCreated.VisibleIndex = 3
        Me.colDateCreated.Width = 123
        '
        'FileDetailToolStrip
        '
        Me.FileDetailToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.FileDetailToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileDetailExcelTSButton})
        Me.FileDetailToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.FileDetailToolStrip.Name = "FileDetailToolStrip"
        Me.FileDetailToolStrip.Size = New System.Drawing.Size(643, 25)
        Me.FileDetailToolStrip.TabIndex = 1
        Me.FileDetailToolStrip.Text = "FileDetailToolStrip"
        '
        'FileDetailExcelTSButton
        '
        Me.FileDetailExcelTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FileDetailExcelTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Excel16
        Me.FileDetailExcelTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FileDetailExcelTSButton.Name = "FileDetailExcelTSButton"
        Me.FileDetailExcelTSButton.Size = New System.Drawing.Size(102, 22)
        Me.FileDetailExcelTSButton.Text = "Export To Excel"
        '
        'FileImageList
        '
        Me.FileImageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.FileImageList.ImageSize = New System.Drawing.Size(16, 16)
        Me.FileImageList.TransparentColor = System.Drawing.Color.Transparent
        '
        'TransferResultsFileSection
        '
        Me.Controls.Add(Me.FileSplitContainer)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "TransferResultsFileSection"
        Me.Size = New System.Drawing.Size(645, 514)
        Me.FileSplitContainer.Panel1.ResumeLayout(False)
        Me.FileSplitContainer.Panel2.ResumeLayout(False)
        Me.FileSplitContainer.ResumeLayout(False)
        Me.FileInfoSectionPanel.ResumeLayout(False)
        Me.FileInfoTableLayoutPanel.ResumeLayout(False)
        Me.FileInfoRightPanel.ResumeLayout(False)
        Me.FileInfoRightPanel.PerformLayout()
        Me.FileInfoLeftPanel.ResumeLayout(False)
        Me.FileInfoLeftPanel.PerformLayout()
        Me.FileDetailSectionPanel.ResumeLayout(False)
        Me.FileDetailSectionPanel.PerformLayout()
        Me.FileDetailTabControl.ResumeLayout(False)
        Me.BadLithoCodeDataTabPage.ResumeLayout(False)
        CType(Me.BadLithoCodeDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.BadLithoCodeDataBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.BadLithoCodeDataGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.FileDetailToolStrip.ResumeLayout(False)
        Me.FileDetailToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents FileSplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents FileInfoSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents FileDetailSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents FileInfoTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents FileInfoRightPanel As System.Windows.Forms.Panel
    Friend WithEvents FileInfoLeftPanel As System.Windows.Forms.Panel
    Friend WithEvents DateLoadedTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DisplayNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalFileNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DateLoadedLabel As System.Windows.Forms.Label
    Friend WithEvents DisplayNameLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalFileNameLabel As System.Windows.Forms.Label
    Friend WithEvents RecordCountTextBox As System.Windows.Forms.TextBox
    Friend WithEvents SurveyCountTextBox As System.Windows.Forms.TextBox
    Friend WithEvents RecordCountLabel As System.Windows.Forms.Label
    Friend WithEvents SurveyCountLabel As System.Windows.Forms.Label
    Friend WithEvents DispositionUpdateTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DispositionUpdateLabel As System.Windows.Forms.Label
    Friend WithEvents FileDetailToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FileDetailExcelTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FileDetailSaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents FileDetailTabControl As System.Windows.Forms.TabControl
    Friend WithEvents BadLithoCodeDataTabPage As System.Windows.Forms.TabPage
    Friend WithEvents BadLithoCodeDataBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents BadLithoCodeDataGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents BadLithoCodeDataGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colBadLithoId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDataLoadId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colBadLithoCode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FileImageList As System.Windows.Forms.ImageList

End Class
