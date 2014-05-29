<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ACOCAHPSDefinitionSection
    Inherits DataMart.ExportManager.Section

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ACOCAHPSDefinitionSection))
        Me.CCNBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.SplitContainer = New System.Windows.Forms.SplitContainer
        Me.MainDefinitionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.DefinitionPanel = New System.Windows.Forms.Panel
        Me.DefinitionSplitContainer = New System.Windows.Forms.SplitContainer
        Me.InputPanel = New System.Windows.Forms.TableLayoutPanel
        Me.YearLabel = New System.Windows.Forms.Label
        Me.YearList = New System.Windows.Forms.ComboBox
        Me.MonthLabel = New System.Windows.Forms.Label
        Me.MonthList = New System.Windows.Forms.ComboBox
        Me.ExportButton = New System.Windows.Forms.Button
        Me.InterimFileCheckBox = New System.Windows.Forms.CheckBox
        Me.CCNPanel = New System.Windows.Forms.Panel
        Me.CCNGridControl = New DevExpress.XtraGrid.GridControl
        Me.CCNGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colSelected = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colClientName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurveyName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurveyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.CCNSelectCheckEdit = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.CCNToolStrip = New System.Windows.Forms.ToolStrip
        Me.ToolStripLabel = New System.Windows.Forms.ToolStripLabel
        Me.ViewToolStripComboBox = New System.Windows.Forms.ToolStripComboBox
        Me.DeselectAllToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.SelectAllToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.MainFileHistoryPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.FilterStartDate = New System.Windows.Forms.DateTimePicker
        Me.FilterEndDate = New System.Windows.Forms.DateTimePicker
        Me.FileHistoryPanel = New System.Windows.Forms.Panel
        Me.FileHistoryGridControl = New DevExpress.XtraGrid.GridControl
        Me.FileHistoryBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.FileHistoryGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colExportName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsInterim = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFilePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FilePathRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.colCreatedDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coldatSubmitted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coldatAccepted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coldatRejected = New DevExpress.XtraGrid.Columns.GridColumn
        Me.TPSRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.FileRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.SummaryRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.ExceptionRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.OverrideRepositoryItemCheckEdit = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.IgnoreRepositoryItemCheckEdit = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.FileHistoryBottomPanel = New System.Windows.Forms.Panel
        Me.CancelButton = New System.Windows.Forms.Button
        Me.SaveButton = New System.Windows.Forms.Button
        Me.FileHistoryToolStrip = New System.Windows.Forms.ToolStrip
        Me.FilterToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.SubmittedToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.AcceptedStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.RejectedToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.FileTypeComboBox = New System.Windows.Forms.ComboBox
        CType(Me.CCNBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer.Panel1.SuspendLayout()
        Me.SplitContainer.Panel2.SuspendLayout()
        Me.SplitContainer.SuspendLayout()
        Me.MainDefinitionPanel.SuspendLayout()
        Me.DefinitionPanel.SuspendLayout()
        Me.DefinitionSplitContainer.Panel1.SuspendLayout()
        Me.DefinitionSplitContainer.Panel2.SuspendLayout()
        Me.DefinitionSplitContainer.SuspendLayout()
        Me.InputPanel.SuspendLayout()
        Me.CCNPanel.SuspendLayout()
        CType(Me.CCNGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CCNGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CCNSelectCheckEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.CCNToolStrip.SuspendLayout()
        Me.MainFileHistoryPanel.SuspendLayout()
        Me.FileHistoryPanel.SuspendLayout()
        CType(Me.FileHistoryGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FileHistoryBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FileHistoryGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.TPSRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FileRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SummaryRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExceptionRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OverrideRepositoryItemCheckEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.IgnoreRepositoryItemCheckEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.FileHistoryBottomPanel.SuspendLayout()
        Me.FileHistoryToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'CCNBindingSource
        '
        Me.CCNBindingSource.DataSource = GetType(Nrc.DataMart.Library.MedicareExport)
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
        Me.SplitContainer.Panel1.Controls.Add(Me.MainDefinitionPanel)
        Me.SplitContainer.Panel1.Padding = New System.Windows.Forms.Padding(0, 0, 0, 1)
        '
        'SplitContainer.Panel2
        '
        Me.SplitContainer.Panel2.Controls.Add(Me.MainFileHistoryPanel)
        Me.SplitContainer.Size = New System.Drawing.Size(700, 600)
        Me.SplitContainer.SplitterDistance = 233
        Me.SplitContainer.TabIndex = 0
        '
        'MainDefinitionPanel
        '
        Me.MainDefinitionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainDefinitionPanel.Caption = "ACO CAHPS Export Definition"
        Me.MainDefinitionPanel.Controls.Add(Me.DefinitionPanel)
        Me.MainDefinitionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainDefinitionPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainDefinitionPanel.Name = "MainDefinitionPanel"
        Me.MainDefinitionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainDefinitionPanel.ShowCaption = True
        Me.MainDefinitionPanel.Size = New System.Drawing.Size(700, 232)
        Me.MainDefinitionPanel.TabIndex = 1
        '
        'DefinitionPanel
        '
        Me.DefinitionPanel.Controls.Add(Me.DefinitionSplitContainer)
        Me.DefinitionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.DefinitionPanel.Location = New System.Drawing.Point(1, 27)
        Me.DefinitionPanel.Name = "DefinitionPanel"
        Me.DefinitionPanel.Size = New System.Drawing.Size(698, 204)
        Me.DefinitionPanel.TabIndex = 5
        '
        'DefinitionSplitContainer
        '
        Me.DefinitionSplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.DefinitionSplitContainer.FixedPanel = System.Windows.Forms.FixedPanel.Panel1
        Me.DefinitionSplitContainer.Location = New System.Drawing.Point(0, 0)
        Me.DefinitionSplitContainer.Name = "DefinitionSplitContainer"
        '
        'DefinitionSplitContainer.Panel1
        '
        Me.DefinitionSplitContainer.Panel1.Controls.Add(Me.InputPanel)
        '
        'DefinitionSplitContainer.Panel2
        '
        Me.DefinitionSplitContainer.Panel2.Controls.Add(Me.CCNPanel)
        Me.DefinitionSplitContainer.Size = New System.Drawing.Size(698, 204)
        Me.DefinitionSplitContainer.SplitterDistance = 232
        Me.DefinitionSplitContainer.TabIndex = 0
        '
        'InputPanel
        '
        Me.InputPanel.AutoSize = True
        Me.InputPanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.InputPanel.ColumnCount = 2
        Me.InputPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 73.0!))
        Me.InputPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 153.0!))
        Me.InputPanel.Controls.Add(Me.YearLabel, 0, 1)
        Me.InputPanel.Controls.Add(Me.YearList, 1, 1)
        Me.InputPanel.Controls.Add(Me.MonthLabel, 0, 0)
        Me.InputPanel.Controls.Add(Me.MonthList, 1, 0)
        Me.InputPanel.Controls.Add(Me.ExportButton, 1, 3)
        Me.InputPanel.Controls.Add(Me.InterimFileCheckBox, 1, 2)
        Me.InputPanel.Location = New System.Drawing.Point(3, 3)
        Me.InputPanel.Name = "InputPanel"
        Me.InputPanel.RowCount = 4
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.Size = New System.Drawing.Size(226, 106)
        Me.InputPanel.TabIndex = 21
        '
        'YearLabel
        '
        Me.YearLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.YearLabel.AutoSize = True
        Me.YearLabel.Location = New System.Drawing.Point(3, 34)
        Me.YearLabel.Name = "YearLabel"
        Me.YearLabel.Size = New System.Drawing.Size(29, 13)
        Me.YearLabel.TabIndex = 19
        Me.YearLabel.Text = "Year"
        Me.YearLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'YearList
        '
        Me.YearList.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.YearList.DropDownHeight = 158
        Me.YearList.FormattingEnabled = True
        Me.YearList.IntegralHeight = False
        Me.YearList.Location = New System.Drawing.Point(76, 30)
        Me.YearList.Name = "YearList"
        Me.YearList.Size = New System.Drawing.Size(147, 21)
        Me.YearList.TabIndex = 16
        '
        'MonthLabel
        '
        Me.MonthLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.MonthLabel.AutoSize = True
        Me.MonthLabel.Location = New System.Drawing.Point(3, 7)
        Me.MonthLabel.Name = "MonthLabel"
        Me.MonthLabel.Size = New System.Drawing.Size(37, 13)
        Me.MonthLabel.TabIndex = 18
        Me.MonthLabel.Text = "Month"
        Me.MonthLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MonthList
        '
        Me.MonthList.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MonthList.DropDownHeight = 158
        Me.MonthList.FormattingEnabled = True
        Me.MonthList.IntegralHeight = False
        Me.MonthList.Location = New System.Drawing.Point(76, 3)
        Me.MonthList.Name = "MonthList"
        Me.MonthList.Size = New System.Drawing.Size(147, 21)
        Me.MonthList.TabIndex = 15
        '
        'ExportButton
        '
        Me.ExportButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportButton.Location = New System.Drawing.Point(134, 80)
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(89, 23)
        Me.ExportButton.TabIndex = 20
        Me.ExportButton.Text = "Export"
        Me.ExportButton.UseVisualStyleBackColor = True
        '
        'InterimFileCheckBox
        '
        Me.InterimFileCheckBox.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.InterimFileCheckBox.AutoSize = True
        Me.InterimFileCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.InterimFileCheckBox.Location = New System.Drawing.Point(76, 57)
        Me.InterimFileCheckBox.Name = "InterimFileCheckBox"
        Me.InterimFileCheckBox.Size = New System.Drawing.Size(147, 17)
        Me.InterimFileCheckBox.TabIndex = 22
        Me.InterimFileCheckBox.Text = "Interim File"
        Me.InterimFileCheckBox.UseVisualStyleBackColor = True
        '
        'CCNPanel
        '
        Me.CCNPanel.Controls.Add(Me.CCNGridControl)
        Me.CCNPanel.Controls.Add(Me.CCNToolStrip)
        Me.CCNPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CCNPanel.Location = New System.Drawing.Point(0, 0)
        Me.CCNPanel.Name = "CCNPanel"
        Me.CCNPanel.Size = New System.Drawing.Size(462, 204)
        Me.CCNPanel.TabIndex = 0
        '
        'CCNGridControl
        '
        Me.CCNGridControl.DataSource = Me.CCNBindingSource
        Me.CCNGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CCNGridControl.Location = New System.Drawing.Point(0, 25)
        Me.CCNGridControl.MainView = Me.CCNGridView
        Me.CCNGridControl.Name = "CCNGridControl"
        Me.CCNGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.CCNSelectCheckEdit})
        Me.CCNGridControl.Size = New System.Drawing.Size(462, 179)
        Me.CCNGridControl.TabIndex = 2
        Me.CCNGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.CCNGridView})
        '
        'CCNGridView
        '
        Me.CCNGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colSelected, Me.colClientName, Me.colSurveyName, Me.colSurveyId})
        Me.CCNGridView.GridControl = Me.CCNGridControl
        Me.CCNGridView.Name = "CCNGridView"
        Me.CCNGridView.OptionsSelection.MultiSelect = True
        Me.CCNGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colSelected
        '
        Me.colSelected.FieldName = "Selected"
        Me.colSelected.Name = "colSelected"
        Me.colSelected.Visible = True
        Me.colSelected.VisibleIndex = 0
        '
        'colClientName
        '
        Me.colClientName.Caption = "Client"
        Me.colClientName.FieldName = "ClientName"
        Me.colClientName.Name = "colClientName"
        Me.colClientName.OptionsColumn.AllowEdit = False
        Me.colClientName.OptionsColumn.ReadOnly = True
        Me.colClientName.Visible = True
        Me.colClientName.VisibleIndex = 1
        '
        'colSurveyName
        '
        Me.colSurveyName.Caption = "Survey"
        Me.colSurveyName.FieldName = "SurveyName"
        Me.colSurveyName.Name = "colSurveyName"
        Me.colSurveyName.OptionsColumn.AllowEdit = False
        Me.colSurveyName.OptionsColumn.ReadOnly = True
        Me.colSurveyName.Visible = True
        Me.colSurveyName.VisibleIndex = 2
        '
        'colSurveyId
        '
        Me.colSurveyId.Caption = "Survey ID"
        Me.colSurveyId.FieldName = "SurveyId"
        Me.colSurveyId.Name = "colSurveyId"
        Me.colSurveyId.OptionsColumn.AllowEdit = False
        Me.colSurveyId.OptionsColumn.ReadOnly = True
        Me.colSurveyId.Visible = True
        Me.colSurveyId.VisibleIndex = 3
        '
        'CCNSelectCheckEdit
        '
        Me.CCNSelectCheckEdit.AutoHeight = False
        Me.CCNSelectCheckEdit.Name = "CCNSelectCheckEdit"
        '
        'CCNToolStrip
        '
        Me.CCNToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.CCNToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel, Me.ViewToolStripComboBox, Me.DeselectAllToolStripButton, Me.ToolStripSeparator1, Me.SelectAllToolStripButton})
        Me.CCNToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.CCNToolStrip.Name = "CCNToolStrip"
        Me.CCNToolStrip.Size = New System.Drawing.Size(462, 25)
        Me.CCNToolStrip.TabIndex = 0
        Me.CCNToolStrip.Text = "ToolStrip1"
        '
        'ToolStripLabel
        '
        Me.ToolStripLabel.Name = "ToolStripLabel"
        Me.ToolStripLabel.Size = New System.Drawing.Size(32, 22)
        Me.ToolStripLabel.Text = "View"
        '
        'ViewToolStripComboBox
        '
        Me.ViewToolStripComboBox.Name = "ViewToolStripComboBox"
        Me.ViewToolStripComboBox.Size = New System.Drawing.Size(150, 25)
        '
        'DeselectAllToolStripButton
        '
        Me.DeselectAllToolStripButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.DeselectAllToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.DeselectAllToolStripButton.Image = CType(resources.GetObject("DeselectAllToolStripButton.Image"), System.Drawing.Image)
        Me.DeselectAllToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeselectAllToolStripButton.Name = "DeselectAllToolStripButton"
        Me.DeselectAllToolStripButton.Size = New System.Drawing.Size(72, 22)
        Me.DeselectAllToolStripButton.Text = "Deselect All"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'SelectAllToolStripButton
        '
        Me.SelectAllToolStripButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.SelectAllToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.SelectAllToolStripButton.Image = CType(resources.GetObject("SelectAllToolStripButton.Image"), System.Drawing.Image)
        Me.SelectAllToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SelectAllToolStripButton.Name = "SelectAllToolStripButton"
        Me.SelectAllToolStripButton.Size = New System.Drawing.Size(59, 22)
        Me.SelectAllToolStripButton.Text = "Select All"
        '
        'MainFileHistoryPanel
        '
        Me.MainFileHistoryPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainFileHistoryPanel.Caption = "Export File Tracking"
        Me.MainFileHistoryPanel.Controls.Add(Me.FilterStartDate)
        Me.MainFileHistoryPanel.Controls.Add(Me.FilterEndDate)
        Me.MainFileHistoryPanel.Controls.Add(Me.FileHistoryPanel)
        Me.MainFileHistoryPanel.Controls.Add(Me.FileHistoryToolStrip)
        Me.MainFileHistoryPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainFileHistoryPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainFileHistoryPanel.Name = "MainFileHistoryPanel"
        Me.MainFileHistoryPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainFileHistoryPanel.ShowCaption = True
        Me.MainFileHistoryPanel.Size = New System.Drawing.Size(700, 363)
        Me.MainFileHistoryPanel.TabIndex = 1
        '
        'FilterStartDate
        '
        Me.FilterStartDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterStartDate.Location = New System.Drawing.Point(449, 29)
        Me.FilterStartDate.Name = "FilterStartDate"
        Me.FilterStartDate.Size = New System.Drawing.Size(98, 20)
        Me.FilterStartDate.TabIndex = 16
        '
        'FilterEndDate
        '
        Me.FilterEndDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterEndDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterEndDate.Location = New System.Drawing.Point(576, 29)
        Me.FilterEndDate.Name = "FilterEndDate"
        Me.FilterEndDate.Size = New System.Drawing.Size(97, 20)
        Me.FilterEndDate.TabIndex = 15
        '
        'FileHistoryPanel
        '
        Me.FileHistoryPanel.Controls.Add(Me.FileHistoryGridControl)
        Me.FileHistoryPanel.Controls.Add(Me.FileHistoryBottomPanel)
        Me.FileHistoryPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileHistoryPanel.Location = New System.Drawing.Point(1, 52)
        Me.FileHistoryPanel.Name = "FileHistoryPanel"
        Me.FileHistoryPanel.Size = New System.Drawing.Size(698, 310)
        Me.FileHistoryPanel.TabIndex = 5
        '
        'FileHistoryGridControl
        '
        Me.FileHistoryGridControl.DataSource = Me.FileHistoryBindingSource
        Me.FileHistoryGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileHistoryGridControl.Location = New System.Drawing.Point(0, 0)
        Me.FileHistoryGridControl.MainView = Me.FileHistoryGridView
        Me.FileHistoryGridControl.Name = "FileHistoryGridControl"
        Me.FileHistoryGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.TPSRepositoryItemHyperLinkEdit, Me.FileRepositoryItemHyperLinkEdit, Me.SummaryRepositoryItemHyperLinkEdit, Me.ExceptionRepositoryItemHyperLinkEdit, Me.OverrideRepositoryItemCheckEdit, Me.IgnoreRepositoryItemCheckEdit, Me.FilePathRepositoryItemHyperLinkEdit})
        Me.FileHistoryGridControl.Size = New System.Drawing.Size(698, 274)
        Me.FileHistoryGridControl.TabIndex = 2
        Me.FileHistoryGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.FileHistoryGridView})
        '
        'FileHistoryBindingSource
        '
        Me.FileHistoryBindingSource.DataSource = GetType(Nrc.DataMart.Library.ExportFileView)
        '
        'FileHistoryGridView
        '
        Me.FileHistoryGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colExportName, Me.colIsInterim, Me.colFilePath, Me.colCreatedDate, Me.coldatSubmitted, Me.coldatAccepted, Me.coldatRejected})
        Me.FileHistoryGridView.GridControl = Me.FileHistoryGridControl
        Me.FileHistoryGridView.Name = "FileHistoryGridView"
        Me.FileHistoryGridView.OptionsSelection.MultiSelect = True
        Me.FileHistoryGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colExportName
        '
        Me.colExportName.Caption = "File Name"
        Me.colExportName.FieldName = "ExportName"
        Me.colExportName.Name = "colExportName"
        Me.colExportName.OptionsColumn.AllowEdit = False
        Me.colExportName.OptionsColumn.ReadOnly = True
        Me.colExportName.Visible = True
        Me.colExportName.VisibleIndex = 0
        '
        'colIsInterim
        '
        Me.colIsInterim.Caption = "Interim"
        Me.colIsInterim.FieldName = "Ignore"
        Me.colIsInterim.Name = "colIsInterim"
        Me.colIsInterim.OptionsColumn.AllowEdit = False
        Me.colIsInterim.OptionsColumn.ReadOnly = True
        Me.colIsInterim.Visible = True
        Me.colIsInterim.VisibleIndex = 1
        '
        'colFilePath
        '
        Me.colFilePath.Caption = "File Path"
        Me.colFilePath.ColumnEdit = Me.FilePathRepositoryItemHyperLinkEdit
        Me.colFilePath.FieldName = "FilePath"
        Me.colFilePath.Name = "colFilePath"
        Me.colFilePath.Visible = True
        Me.colFilePath.VisibleIndex = 2
        '
        'FilePathRepositoryItemHyperLinkEdit
        '
        Me.FilePathRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.FilePathRepositoryItemHyperLinkEdit.Name = "FilePathRepositoryItemHyperLinkEdit"
        '
        'colCreatedDate
        '
        Me.colCreatedDate.Caption = "Date Created"
        Me.colCreatedDate.FieldName = "CreatedDate"
        Me.colCreatedDate.Name = "colCreatedDate"
        Me.colCreatedDate.OptionsColumn.AllowEdit = False
        Me.colCreatedDate.OptionsColumn.ReadOnly = True
        Me.colCreatedDate.Visible = True
        Me.colCreatedDate.VisibleIndex = 3
        '
        'coldatSubmitted
        '
        Me.coldatSubmitted.Caption = "Submitted"
        Me.coldatSubmitted.FieldName = "datSubmitted"
        Me.coldatSubmitted.Name = "coldatSubmitted"
        Me.coldatSubmitted.Visible = True
        Me.coldatSubmitted.VisibleIndex = 4
        '
        'coldatAccepted
        '
        Me.coldatAccepted.Caption = "Accepted"
        Me.coldatAccepted.FieldName = "datAccepted"
        Me.coldatAccepted.Name = "coldatAccepted"
        Me.coldatAccepted.Visible = True
        Me.coldatAccepted.VisibleIndex = 5
        '
        'coldatRejected
        '
        Me.coldatRejected.Caption = "Rejected"
        Me.coldatRejected.FieldName = "datRejected"
        Me.coldatRejected.Name = "coldatRejected"
        Me.coldatRejected.Visible = True
        Me.coldatRejected.VisibleIndex = 6
        '
        'TPSRepositoryItemHyperLinkEdit
        '
        Me.TPSRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.TPSRepositoryItemHyperLinkEdit.Name = "TPSRepositoryItemHyperLinkEdit"
        '
        'FileRepositoryItemHyperLinkEdit
        '
        Me.FileRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.FileRepositoryItemHyperLinkEdit.Name = "FileRepositoryItemHyperLinkEdit"
        '
        'SummaryRepositoryItemHyperLinkEdit
        '
        Me.SummaryRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.SummaryRepositoryItemHyperLinkEdit.Name = "SummaryRepositoryItemHyperLinkEdit"
        '
        'ExceptionRepositoryItemHyperLinkEdit
        '
        Me.ExceptionRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.ExceptionRepositoryItemHyperLinkEdit.Name = "ExceptionRepositoryItemHyperLinkEdit"
        '
        'OverrideRepositoryItemCheckEdit
        '
        Me.OverrideRepositoryItemCheckEdit.AutoHeight = False
        Me.OverrideRepositoryItemCheckEdit.Name = "OverrideRepositoryItemCheckEdit"
        '
        'IgnoreRepositoryItemCheckEdit
        '
        Me.IgnoreRepositoryItemCheckEdit.AutoHeight = False
        Me.IgnoreRepositoryItemCheckEdit.Name = "IgnoreRepositoryItemCheckEdit"
        '
        'FileHistoryBottomPanel
        '
        Me.FileHistoryBottomPanel.Controls.Add(Me.CancelButton)
        Me.FileHistoryBottomPanel.Controls.Add(Me.SaveButton)
        Me.FileHistoryBottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.FileHistoryBottomPanel.Location = New System.Drawing.Point(0, 274)
        Me.FileHistoryBottomPanel.Name = "FileHistoryBottomPanel"
        Me.FileHistoryBottomPanel.Size = New System.Drawing.Size(698, 36)
        Me.FileHistoryBottomPanel.TabIndex = 1
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(539, 6)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 25)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'SaveButton
        '
        Me.SaveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SaveButton.Location = New System.Drawing.Point(620, 6)
        Me.SaveButton.Name = "SaveButton"
        Me.SaveButton.Size = New System.Drawing.Size(75, 25)
        Me.SaveButton.TabIndex = 0
        Me.SaveButton.Text = "Save"
        Me.SaveButton.UseVisualStyleBackColor = True
        '
        'FileHistoryToolStrip
        '
        Me.FileHistoryToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.FileHistoryToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FilterToolStripButton, Me.ToolStripLabel2, Me.ToolStripLabel1, Me.SubmittedToolStripButton, Me.ToolStripSeparator2, Me.AcceptedStripButton, Me.ToolStripSeparator3, Me.RejectedToolStripButton})
        Me.FileHistoryToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.HorizontalStackWithOverflow
        Me.FileHistoryToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.FileHistoryToolStrip.Name = "FileHistoryToolStrip"
        Me.FileHistoryToolStrip.Size = New System.Drawing.Size(698, 25)
        Me.FileHistoryToolStrip.TabIndex = 2
        Me.FileHistoryToolStrip.Text = "ToolStrip1"
        '
        'FilterToolStripButton
        '
        Me.FilterToolStripButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterToolStripButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.GoLtr
        Me.FilterToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterToolStripButton.Name = "FilterToolStripButton"
        Me.FilterToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.FilterToolStripButton.Text = "Filter"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel2.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(27, 22)
        Me.ToolStripLabel2.Text = "and"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel1.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(96, 22)
        Me.ToolStripLabel1.Text = "Created between"
        '
        'SubmittedToolStripButton
        '
        Me.SubmittedToolStripButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.GoLtr
        Me.SubmittedToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SubmittedToolStripButton.Name = "SubmittedToolStripButton"
        Me.SubmittedToolStripButton.Size = New System.Drawing.Size(82, 22)
        Me.SubmittedToolStripButton.Text = "Submitted"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'AcceptedStripButton
        '
        Me.AcceptedStripButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.Validation16
        Me.AcceptedStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.AcceptedStripButton.Name = "AcceptedStripButton"
        Me.AcceptedStripButton.Size = New System.Drawing.Size(77, 22)
        Me.AcceptedStripButton.Text = "Accepted"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'RejectedToolStripButton
        '
        Me.RejectedToolStripButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.DeleteRed16
        Me.RejectedToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RejectedToolStripButton.Name = "RejectedToolStripButton"
        Me.RejectedToolStripButton.Size = New System.Drawing.Size(72, 22)
        Me.RejectedToolStripButton.Text = "Rejected"
        '
        'FileTypeComboBox
        '
        Me.FileTypeComboBox.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.FileTypeComboBox.DropDownHeight = 158
        Me.FileTypeComboBox.FormattingEnabled = True
        Me.FileTypeComboBox.IntegralHeight = False
        Me.FileTypeComboBox.Location = New System.Drawing.Point(76, 57)
        Me.FileTypeComboBox.Name = "FileTypeComboBox"
        Me.FileTypeComboBox.Size = New System.Drawing.Size(35, 21)
        Me.FileTypeComboBox.TabIndex = 22
        '
        'ACOCAHPSDefinitionSection
        '
        Me.Controls.Add(Me.SplitContainer)
        Me.Name = "ACOCAHPSDefinitionSection"
        Me.Size = New System.Drawing.Size(700, 600)
        CType(Me.CCNBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer.Panel1.ResumeLayout(False)
        Me.SplitContainer.Panel2.ResumeLayout(False)
        Me.SplitContainer.ResumeLayout(False)
        Me.MainDefinitionPanel.ResumeLayout(False)
        Me.DefinitionPanel.ResumeLayout(False)
        Me.DefinitionSplitContainer.Panel1.ResumeLayout(False)
        Me.DefinitionSplitContainer.Panel1.PerformLayout()
        Me.DefinitionSplitContainer.Panel2.ResumeLayout(False)
        Me.DefinitionSplitContainer.ResumeLayout(False)
        Me.InputPanel.ResumeLayout(False)
        Me.InputPanel.PerformLayout()
        Me.CCNPanel.ResumeLayout(False)
        Me.CCNPanel.PerformLayout()
        CType(Me.CCNGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CCNGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CCNSelectCheckEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.CCNToolStrip.ResumeLayout(False)
        Me.CCNToolStrip.PerformLayout()
        Me.MainFileHistoryPanel.ResumeLayout(False)
        Me.MainFileHistoryPanel.PerformLayout()
        Me.FileHistoryPanel.ResumeLayout(False)
        CType(Me.FileHistoryGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FileHistoryBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FileHistoryGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.TPSRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FileRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SummaryRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExceptionRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OverrideRepositoryItemCheckEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.IgnoreRepositoryItemCheckEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.FileHistoryBottomPanel.ResumeLayout(False)
        Me.FileHistoryToolStrip.ResumeLayout(False)
        Me.FileHistoryToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents MainDefinitionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents DefinitionPanel As System.Windows.Forms.Panel
    Friend WithEvents MainFileHistoryPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents FileHistoryPanel As System.Windows.Forms.Panel
    Friend WithEvents FileHistoryToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents DefinitionSplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents CCNPanel As System.Windows.Forms.Panel
    Friend WithEvents CCNToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents SelectAllToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeselectAllToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents InputPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents YearLabel As System.Windows.Forms.Label
    Friend WithEvents YearList As System.Windows.Forms.ComboBox
    Friend WithEvents MonthLabel As System.Windows.Forms.Label
    Friend WithEvents MonthList As System.Windows.Forms.ComboBox
    Friend WithEvents ExportButton As System.Windows.Forms.Button
    Friend WithEvents FilterStartDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents FilterEndDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents FilterToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ViewToolStripComboBox As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents CCNBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents FileHistoryBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents SubmittedToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents AcceptedStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RejectedToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FileHistoryBottomPanel As System.Windows.Forms.Panel
    Friend WithEvents FileHistoryGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents FileHistoryGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents FileRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents TPSRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents SummaryRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents ExceptionRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents OverrideRepositoryItemCheckEdit As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents IgnoreRepositoryItemCheckEdit As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents CCNGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents CCNSelectCheckEdit As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents SaveButton As System.Windows.Forms.Button
    Friend WithEvents CCNGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents InterimFileCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents FileTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents colExportName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFilePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsInterim As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCreatedDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatSubmitted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatAccepted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatRejected As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSelected As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colClientName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurveyName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurveyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FilePathRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit

End Class
