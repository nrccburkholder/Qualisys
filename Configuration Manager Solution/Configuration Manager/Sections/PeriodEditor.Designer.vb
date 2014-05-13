<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PeriodEditor
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim GridLevelNode1 As DevExpress.XtraGrid.GridLevelNode = New DevExpress.XtraGrid.GridLevelNode
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PeriodEditor))
        Me.ScheduledSamplesGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colSampleNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colScheduledSampleDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ScheduledSampleDateEditRepositoryItem = New DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
        Me.colActualSampleDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCanceled = New DevExpress.XtraGrid.Columns.GridColumn
        Me.SamplePeriodGridControl = New DevExpress.XtraGrid.GridControl
        Me.SamplePeriodBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.SamplePeriodGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colSamplingMethodLabel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.SamplingMethodRepositoryItemComboBox = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.colExpectedEndDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ExpectedDateEditRepositoryItem = New DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
        Me.colExpectedStartDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.NameRepositoryItemTextEdit = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
        Me.colMonth = New DevExpress.XtraGrid.Columns.GridColumn
        Me.MonthComboBoxRepositoryItem = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.colYear = New DevExpress.XtraGrid.Columns.GridColumn
        Me.YearComboBoxRepositoryItem = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.colPeriodTimeFrame = New DevExpress.XtraGrid.Columns.GridColumn
        Me.WorkAreaPanel = New System.Windows.Forms.Panel
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.NewSamplePeriodButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.SchedulingWizardButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator6 = New System.Windows.Forms.ToolStripSeparator
        Me.CancelSamplesButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator4 = New System.Windows.Forms.ToolStripSeparator
        Me.UnCancelSamplesButton = New System.Windows.Forms.ToolStripButton
        Me.MassCreatePeriodsButton = New System.Windows.Forms.ToolStripButton
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.ApplyButton = New System.Windows.Forms.Button
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar
        CType(Me.ScheduledSamplesGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ScheduledSampleDateEditRepositoryItem, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SamplePeriodGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SamplePeriodBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SamplePeriodGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SamplingMethodRepositoryItemComboBox, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExpectedDateEditRepositoryItem, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NameRepositoryItemTextEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MonthComboBoxRepositoryItem, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.YearComboBoxRepositoryItem, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.WorkAreaPanel.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'ScheduledSamplesGridView
        '
        Me.ScheduledSamplesGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colSampleNumber, Me.colScheduledSampleDate, Me.colActualSampleDate, Me.colCanceled})
        Me.ScheduledSamplesGridView.GridControl = Me.SamplePeriodGridControl
        Me.ScheduledSamplesGridView.Name = "ScheduledSamplesGridView"
        Me.ScheduledSamplesGridView.OptionsCustomization.AllowFilter = False
        Me.ScheduledSamplesGridView.OptionsCustomization.AllowGroup = False
        Me.ScheduledSamplesGridView.OptionsCustomization.AllowSort = False
        Me.ScheduledSamplesGridView.OptionsMenu.EnableColumnMenu = False
        Me.ScheduledSamplesGridView.OptionsView.ColumnAutoWidth = False
        Me.ScheduledSamplesGridView.OptionsView.ShowGroupPanel = False
        Me.ScheduledSamplesGridView.ViewCaption = "Projected Samples"
        '
        'colSampleNumber
        '
        Me.colSampleNumber.Caption = "Sample Number"
        Me.colSampleNumber.FieldName = "SampleNumber"
        Me.colSampleNumber.Name = "colSampleNumber"
        Me.colSampleNumber.OptionsColumn.AllowEdit = False
        Me.colSampleNumber.Visible = True
        Me.colSampleNumber.VisibleIndex = 0
        Me.colSampleNumber.Width = 96
        '
        'colScheduledSampleDate
        '
        Me.colScheduledSampleDate.Caption = "Projected Sample Date"
        Me.colScheduledSampleDate.ColumnEdit = Me.ScheduledSampleDateEditRepositoryItem
        Me.colScheduledSampleDate.DisplayFormat.FormatString = "D"
        Me.colScheduledSampleDate.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colScheduledSampleDate.FieldName = "ScheduledSampleDate"
        Me.colScheduledSampleDate.Name = "colScheduledSampleDate"
        Me.colScheduledSampleDate.Visible = True
        Me.colScheduledSampleDate.VisibleIndex = 1
        Me.colScheduledSampleDate.Width = 167
        '
        'ScheduledSampleDateEditRepositoryItem
        '
        Me.ScheduledSampleDateEditRepositoryItem.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.ScheduledSampleDateEditRepositoryItem.AutoHeight = False
        Me.ScheduledSampleDateEditRepositoryItem.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo, "", -1, True, False, False, DevExpress.Utils.HorzAlignment.Center, Nothing)})
        Me.ScheduledSampleDateEditRepositoryItem.DisplayFormat.FormatString = "D"
        Me.ScheduledSampleDateEditRepositoryItem.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.ScheduledSampleDateEditRepositoryItem.EditFormat.FormatString = "D"
        Me.ScheduledSampleDateEditRepositoryItem.EditFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.ScheduledSampleDateEditRepositoryItem.Mask.EditMask = "D"
        Me.ScheduledSampleDateEditRepositoryItem.Name = "ScheduledSampleDateEditRepositoryItem"
        Me.ScheduledSampleDateEditRepositoryItem.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        '
        'colActualSampleDate
        '
        Me.colActualSampleDate.Caption = "Actual Sample Date"
        Me.colActualSampleDate.DisplayFormat.FormatString = "D"
        Me.colActualSampleDate.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colActualSampleDate.FieldName = "ActualSampleDate"
        Me.colActualSampleDate.Name = "colActualSampleDate"
        Me.colActualSampleDate.OptionsColumn.AllowEdit = False
        Me.colActualSampleDate.OptionsColumn.ReadOnly = True
        Me.colActualSampleDate.Visible = True
        Me.colActualSampleDate.VisibleIndex = 2
        Me.colActualSampleDate.Width = 149
        '
        'colCanceled
        '
        Me.colCanceled.Caption = "Canceled"
        Me.colCanceled.FieldName = "Canceled"
        Me.colCanceled.Name = "colCanceled"
        Me.colCanceled.OptionsColumn.AllowEdit = False
        Me.colCanceled.Visible = True
        Me.colCanceled.VisibleIndex = 3
        '
        'SamplePeriodGridControl
        '
        Me.SamplePeriodGridControl.DataSource = Me.SamplePeriodBindingSource
        Me.SamplePeriodGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SamplePeriodGridControl.EmbeddedNavigator.Name = ""
        GridLevelNode1.LevelTemplate = Me.ScheduledSamplesGridView
        GridLevelNode1.RelationName = "SamplePeriodScheduledSamples"
        Me.SamplePeriodGridControl.LevelTree.Nodes.AddRange(New DevExpress.XtraGrid.GridLevelNode() {GridLevelNode1})
        Me.SamplePeriodGridControl.Location = New System.Drawing.Point(0, 25)
        Me.SamplePeriodGridControl.MainView = Me.SamplePeriodGridView
        Me.SamplePeriodGridControl.Name = "SamplePeriodGridControl"
        Me.SamplePeriodGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.ScheduledSampleDateEditRepositoryItem, Me.ExpectedDateEditRepositoryItem, Me.YearComboBoxRepositoryItem, Me.MonthComboBoxRepositoryItem, Me.SamplingMethodRepositoryItemComboBox, Me.NameRepositoryItemTextEdit})
        Me.SamplePeriodGridControl.ShowOnlyPredefinedDetails = True
        Me.SamplePeriodGridControl.Size = New System.Drawing.Size(731, 377)
        Me.SamplePeriodGridControl.TabIndex = 16
        Me.SamplePeriodGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.SamplePeriodGridView, Me.ScheduledSamplesGridView})
        '
        'SamplePeriodBindingSource
        '
        Me.SamplePeriodBindingSource.DataSource = GetType(Nrc.Qualisys.Library.SamplePeriod)
        '
        'SamplePeriodGridView
        '
        Me.SamplePeriodGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colSamplingMethodLabel, Me.colExpectedEndDate, Me.colExpectedStartDate, Me.colName, Me.colMonth, Me.colYear, Me.colPeriodTimeFrame})
        Me.SamplePeriodGridView.GridControl = Me.SamplePeriodGridControl
        Me.SamplePeriodGridView.Name = "SamplePeriodGridView"
        Me.SamplePeriodGridView.OptionsCustomization.AllowGroup = False
        Me.SamplePeriodGridView.OptionsDetail.AllowExpandEmptyDetails = True
        Me.SamplePeriodGridView.OptionsSelection.MultiSelect = True
        Me.SamplePeriodGridView.OptionsView.ShowGroupPanel = False
        '
        'colSamplingMethodLabel
        '
        Me.colSamplingMethodLabel.Caption = "Sampling Method"
        Me.colSamplingMethodLabel.ColumnEdit = Me.SamplingMethodRepositoryItemComboBox
        Me.colSamplingMethodLabel.FieldName = "SamplingMethodLabel"
        Me.colSamplingMethodLabel.Name = "colSamplingMethodLabel"
        Me.colSamplingMethodLabel.Visible = True
        Me.colSamplingMethodLabel.VisibleIndex = 5
        '
        'SamplingMethodRepositoryItemComboBox
        '
        Me.SamplingMethodRepositoryItemComboBox.AutoHeight = False
        Me.SamplingMethodRepositoryItemComboBox.Name = "SamplingMethodRepositoryItemComboBox"
        Me.SamplingMethodRepositoryItemComboBox.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        '
        'colExpectedEndDate
        '
        Me.colExpectedEndDate.Caption = "Encounter End Date"
        Me.colExpectedEndDate.ColumnEdit = Me.ExpectedDateEditRepositoryItem
        Me.colExpectedEndDate.DisplayFormat.FormatString = "D"
        Me.colExpectedEndDate.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colExpectedEndDate.FieldName = "ExpectedEndDate"
        Me.colExpectedEndDate.Name = "colExpectedEndDate"
        Me.colExpectedEndDate.Visible = True
        Me.colExpectedEndDate.VisibleIndex = 2
        '
        'ExpectedDateEditRepositoryItem
        '
        Me.ExpectedDateEditRepositoryItem.AutoHeight = False
        Me.ExpectedDateEditRepositoryItem.DisplayFormat.FormatString = "D"
        Me.ExpectedDateEditRepositoryItem.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.ExpectedDateEditRepositoryItem.EditFormat.FormatString = "D"
        Me.ExpectedDateEditRepositoryItem.EditFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.ExpectedDateEditRepositoryItem.Mask.EditMask = "D"
        Me.ExpectedDateEditRepositoryItem.Name = "ExpectedDateEditRepositoryItem"
        Me.ExpectedDateEditRepositoryItem.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        '
        'colExpectedStartDate
        '
        Me.colExpectedStartDate.Caption = "Encounter Start Date"
        Me.colExpectedStartDate.ColumnEdit = Me.ExpectedDateEditRepositoryItem
        Me.colExpectedStartDate.DisplayFormat.FormatString = "D"
        Me.colExpectedStartDate.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colExpectedStartDate.FieldName = "ExpectedStartDate"
        Me.colExpectedStartDate.Name = "colExpectedStartDate"
        Me.colExpectedStartDate.Visible = True
        Me.colExpectedStartDate.VisibleIndex = 1
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.ColumnEdit = Me.NameRepositoryItemTextEdit
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 0
        '
        'NameRepositoryItemTextEdit
        '
        Me.NameRepositoryItemTextEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.NameRepositoryItemTextEdit.AutoHeight = False
        Me.NameRepositoryItemTextEdit.Name = "NameRepositoryItemTextEdit"
        '
        'colMonth
        '
        Me.colMonth.Caption = "Month"
        Me.colMonth.ColumnEdit = Me.MonthComboBoxRepositoryItem
        Me.colMonth.DisplayFormat.FormatString = "MMMM"
        Me.colMonth.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colMonth.FieldName = "ExpectedStartDate"
        Me.colMonth.GroupFormat.FormatString = "MMMM"
        Me.colMonth.GroupFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colMonth.Name = "colMonth"
        Me.colMonth.Visible = True
        Me.colMonth.VisibleIndex = 3
        '
        'MonthComboBoxRepositoryItem
        '
        Me.MonthComboBoxRepositoryItem.AutoHeight = False
        Me.MonthComboBoxRepositoryItem.DisplayFormat.FormatString = "MMMM"
        Me.MonthComboBoxRepositoryItem.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.MonthComboBoxRepositoryItem.EditFormat.FormatString = "MMMM"
        Me.MonthComboBoxRepositoryItem.EditFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.MonthComboBoxRepositoryItem.Items.AddRange(New Object() {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"})
        Me.MonthComboBoxRepositoryItem.Mask.EditMask = "MMMM"
        Me.MonthComboBoxRepositoryItem.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.DateTime
        Me.MonthComboBoxRepositoryItem.Mask.UseMaskAsDisplayFormat = True
        Me.MonthComboBoxRepositoryItem.Name = "MonthComboBoxRepositoryItem"
        Me.MonthComboBoxRepositoryItem.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        '
        'colYear
        '
        Me.colYear.Caption = "Year"
        Me.colYear.ColumnEdit = Me.YearComboBoxRepositoryItem
        Me.colYear.DisplayFormat.FormatString = "yyyy"
        Me.colYear.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colYear.FieldName = "ExpectedStartDate"
        Me.colYear.Name = "colYear"
        Me.colYear.Visible = True
        Me.colYear.VisibleIndex = 4
        '
        'YearComboBoxRepositoryItem
        '
        Me.YearComboBoxRepositoryItem.AutoHeight = False
        Me.YearComboBoxRepositoryItem.DisplayFormat.FormatString = "yyyy"
        Me.YearComboBoxRepositoryItem.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.YearComboBoxRepositoryItem.EditFormat.FormatString = "yyyy"
        Me.YearComboBoxRepositoryItem.EditFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.YearComboBoxRepositoryItem.Items.AddRange(New Object() {"1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"})
        Me.YearComboBoxRepositoryItem.Mask.EditMask = "yyyy"
        Me.YearComboBoxRepositoryItem.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.DateTime
        Me.YearComboBoxRepositoryItem.Mask.UseMaskAsDisplayFormat = True
        Me.YearComboBoxRepositoryItem.Name = "YearComboBoxRepositoryItem"
        Me.YearComboBoxRepositoryItem.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        '
        'colPeriodTimeFrame
        '
        Me.colPeriodTimeFrame.Caption = "Status"
        Me.colPeriodTimeFrame.FieldName = "PeriodTimeFrame"
        Me.colPeriodTimeFrame.Name = "colPeriodTimeFrame"
        Me.colPeriodTimeFrame.OptionsColumn.AllowEdit = False
        Me.colPeriodTimeFrame.Visible = True
        Me.colPeriodTimeFrame.VisibleIndex = 6
        '
        'WorkAreaPanel
        '
        Me.WorkAreaPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkAreaPanel.Controls.Add(Me.SamplePeriodGridControl)
        Me.WorkAreaPanel.Controls.Add(Me.ToolStrip1)
        Me.WorkAreaPanel.Location = New System.Drawing.Point(0, 21)
        Me.WorkAreaPanel.Name = "WorkAreaPanel"
        Me.WorkAreaPanel.Size = New System.Drawing.Size(731, 402)
        Me.WorkAreaPanel.TabIndex = 2
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1, Me.ToolStripSeparator1, Me.NewSamplePeriodButton, Me.ToolStripSeparator2, Me.DeleteButton, Me.ToolStripSeparator3, Me.SchedulingWizardButton, Me.ToolStripSeparator6, Me.CancelSamplesButton, Me.ToolStripSeparator4, Me.UnCancelSamplesButton, Me.MassCreatePeriodsButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(731, 25)
        Me.ToolStrip1.TabIndex = 16
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(105, 22)
        Me.ToolStripLabel1.Text = "Period Properties"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'NewSamplePeriodButton
        '
        Me.NewSamplePeriodButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.NewSamplePeriodButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.New16
        Me.NewSamplePeriodButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NewSamplePeriodButton.Name = "NewSamplePeriodButton"
        Me.NewSamplePeriodButton.Size = New System.Drawing.Size(23, 22)
        Me.NewSamplePeriodButton.ToolTipText = "Add New Period"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'DeleteButton
        '
        Me.DeleteButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.DeleteButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.DeleteButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteButton.Name = "DeleteButton"
        Me.DeleteButton.Size = New System.Drawing.Size(23, 22)
        Me.DeleteButton.Text = "Delete"
        Me.DeleteButton.ToolTipText = "Delete Period"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'SchedulingWizardButton
        '
        Me.SchedulingWizardButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.SchedulingWizardButton.Image = CType(resources.GetObject("SchedulingWizardButton.Image"), System.Drawing.Image)
        Me.SchedulingWizardButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SchedulingWizardButton.Name = "SchedulingWizardButton"
        Me.SchedulingWizardButton.Size = New System.Drawing.Size(98, 22)
        Me.SchedulingWizardButton.Text = "Scheduling Wizard"
        '
        'ToolStripSeparator6
        '
        Me.ToolStripSeparator6.Name = "ToolStripSeparator6"
        Me.ToolStripSeparator6.Size = New System.Drawing.Size(6, 25)
        '
        'CancelSamplesButton
        '
        Me.CancelSamplesButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.CancelSamplesButton.Image = CType(resources.GetObject("CancelSamplesButton.Image"), System.Drawing.Image)
        Me.CancelSamplesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.CancelSamplesButton.Name = "CancelSamplesButton"
        Me.CancelSamplesButton.Size = New System.Drawing.Size(137, 22)
        Me.CancelSamplesButton.Text = "Cancel Remaining Samples"
        '
        'ToolStripSeparator4
        '
        Me.ToolStripSeparator4.Name = "ToolStripSeparator4"
        Me.ToolStripSeparator4.Size = New System.Drawing.Size(6, 25)
        '
        'UnCancelSamplesButton
        '
        Me.UnCancelSamplesButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.UnCancelSamplesButton.Image = CType(resources.GetObject("UnCancelSamplesButton.Image"), System.Drawing.Image)
        Me.UnCancelSamplesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UnCancelSamplesButton.Name = "UnCancelSamplesButton"
        Me.UnCancelSamplesButton.Size = New System.Drawing.Size(71, 22)
        Me.UnCancelSamplesButton.Text = "Undo Cancel"
        '
        'MassCreatePeriodsButton
        '
        Me.MassCreatePeriodsButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.MassCreatePeriodsButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.MassCreatePeriodsButton.Image = CType(resources.GetObject("MassCreatePeriodsButton.Image"), System.Drawing.Image)
        Me.MassCreatePeriodsButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MassCreatePeriodsButton.Name = "MassCreatePeriodsButton"
        Me.MassCreatePeriodsButton.Size = New System.Drawing.Size(109, 22)
        Me.MassCreatePeriodsButton.Text = "Mass Create Periods"
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.ApplyButton)
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 425)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(731, 32)
        Me.BottomPanel.TabIndex = 33
        '
        'ApplyButton
        '
        Me.ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplyButton.Location = New System.Drawing.Point(379, 3)
        Me.ApplyButton.Name = "ApplyButton"
        Me.ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.ApplyButton.TabIndex = 35
        Me.ApplyButton.Text = "Apply"
        Me.ApplyButton.UseVisualStyleBackColor = True
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(552, 3)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 33
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(633, 3)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 34
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = "Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(731, 20)
        Me.InformationBar.TabIndex = 34
        Me.InformationBar.TabStop = False
        '
        'PeriodEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.WorkAreaPanel)
        Me.Name = "PeriodEditor"
        Me.Size = New System.Drawing.Size(731, 457)
        CType(Me.ScheduledSamplesGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ScheduledSampleDateEditRepositoryItem, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SamplePeriodGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SamplePeriodBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SamplePeriodGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SamplingMethodRepositoryItemComboBox, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExpectedDateEditRepositoryItem, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NameRepositoryItemTextEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MonthComboBoxRepositoryItem, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.YearComboBoxRepositoryItem, System.ComponentModel.ISupportInitialize).EndInit()
        Me.WorkAreaPanel.ResumeLayout(False)
        Me.WorkAreaPanel.PerformLayout()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.BottomPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents WorkAreaPanel As System.Windows.Forms.Panel
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents NewSamplePeriodButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SchedulingWizardButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SamplePeriodGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents SamplePeriodBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents SamplePeriodGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colSamplingMethodLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExpectedEndDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExpectedStartDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ScheduledSamplesGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colSampleNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colScheduledSampleDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colActualSampleDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ScheduledSampleDateEditRepositoryItem As DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
    Friend WithEvents ExpectedDateEditRepositoryItem As DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
    Friend WithEvents colMonth As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colYear As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents YearComboBoxRepositoryItem As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents MonthComboBoxRepositoryItem As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents colCanceled As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ToolStripSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents CancelSamplesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents colPeriodTimeFrame As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ToolStripSeparator6 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents UnCancelSamplesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SamplingMethodRepositoryItemComboBox As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents NameRepositoryItemTextEdit As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
    Friend WithEvents MassCreatePeriodsButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar

End Class
