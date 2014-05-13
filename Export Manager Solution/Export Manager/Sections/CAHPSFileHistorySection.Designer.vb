<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CAHPSFileHistorySection
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
        Me.MainFileHistoryPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.FilterStartDate = New System.Windows.Forms.DateTimePicker
        Me.FilterEndDate = New System.Windows.Forms.DateTimePicker
        Me.FileHistoryPanel = New System.Windows.Forms.Panel
        Me.FileHistoryGridControl = New DevExpress.XtraGrid.GridControl
        Me.FileHistoryBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.FileHistoryGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colMedicareNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMedicareName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFacilityName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCreatedDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportStartDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportEndDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFilePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FilePathRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.colTPSFilePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.TPSFilePathRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.colSummaryFilePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.SummaryFilePathRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.colExceptionFilePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ExceptionFilePathRepositoryItemHyperLinkEdit = New DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
        Me.coldatSubmitted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coldatAccepted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coldatRejected = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colErrorMessage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStackTrace = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOverrideError = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coldatOverride = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOverrideErrorName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIgnore = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colClientGroupId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colClientGroupName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsClientGroupActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colClientId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colClientName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsClientActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStudyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStudyName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurveyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsStudyActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurveyName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSurveyActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSampleUnitId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSampleUnitName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMedicareExportSetId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportFileId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportSetTypeId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FileHistoryToolStrip = New System.Windows.Forms.ToolStrip
        Me.FilterToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.colIsMedicareActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.MainFileHistoryPanel.SuspendLayout()
        Me.FileHistoryPanel.SuspendLayout()
        CType(Me.FileHistoryGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FileHistoryBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FileHistoryGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.TPSFilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SummaryFilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExceptionFilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.FileHistoryToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainFileHistoryPanel
        '
        Me.MainFileHistoryPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainFileHistoryPanel.Caption = "Export File History"
        Me.MainFileHistoryPanel.Controls.Add(Me.FilterStartDate)
        Me.MainFileHistoryPanel.Controls.Add(Me.FilterEndDate)
        Me.MainFileHistoryPanel.Controls.Add(Me.FileHistoryPanel)
        Me.MainFileHistoryPanel.Controls.Add(Me.FileHistoryToolStrip)
        Me.MainFileHistoryPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainFileHistoryPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainFileHistoryPanel.Name = "MainFileHistoryPanel"
        Me.MainFileHistoryPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainFileHistoryPanel.ShowCaption = True
        Me.MainFileHistoryPanel.Size = New System.Drawing.Size(800, 600)
        Me.MainFileHistoryPanel.TabIndex = 2
        '
        'FilterStartDate
        '
        Me.FilterStartDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterStartDate.Location = New System.Drawing.Point(549, 29)
        Me.FilterStartDate.Name = "FilterStartDate"
        Me.FilterStartDate.Size = New System.Drawing.Size(98, 20)
        Me.FilterStartDate.TabIndex = 16
        '
        'FilterEndDate
        '
        Me.FilterEndDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterEndDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.FilterEndDate.Location = New System.Drawing.Point(676, 29)
        Me.FilterEndDate.Name = "FilterEndDate"
        Me.FilterEndDate.Size = New System.Drawing.Size(97, 20)
        Me.FilterEndDate.TabIndex = 15
        '
        'FileHistoryPanel
        '
        Me.FileHistoryPanel.Controls.Add(Me.FileHistoryGridControl)
        Me.FileHistoryPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileHistoryPanel.Location = New System.Drawing.Point(1, 52)
        Me.FileHistoryPanel.Name = "FileHistoryPanel"
        Me.FileHistoryPanel.Size = New System.Drawing.Size(798, 547)
        Me.FileHistoryPanel.TabIndex = 5
        '
        'FileHistoryGridControl
        '
        Me.FileHistoryGridControl.DataSource = Me.FileHistoryBindingSource
        Me.FileHistoryGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FileHistoryGridControl.Location = New System.Drawing.Point(0, 0)
        Me.FileHistoryGridControl.MainView = Me.FileHistoryGridView
        Me.FileHistoryGridControl.Name = "FileHistoryGridControl"
        Me.FileHistoryGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.FilePathRepositoryItemHyperLinkEdit, Me.TPSFilePathRepositoryItemHyperLinkEdit, Me.SummaryFilePathRepositoryItemHyperLinkEdit, Me.ExceptionFilePathRepositoryItemHyperLinkEdit})
        Me.FileHistoryGridControl.Size = New System.Drawing.Size(798, 547)
        Me.FileHistoryGridControl.TabIndex = 0
        Me.FileHistoryGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.FileHistoryGridView})
        '
        'FileHistoryBindingSource
        '
        Me.FileHistoryBindingSource.AllowNew = False
        Me.FileHistoryBindingSource.DataSource = GetType(Nrc.DataMart.Library.ExportFileView)
        '
        'FileHistoryGridView
        '
        Me.FileHistoryGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colMedicareNumber, Me.colMedicareName, Me.colIsMedicareActive, Me.colFacilityName, Me.colExportName, Me.colCreatedDate, Me.colExportStartDate, Me.colExportEndDate, Me.colFilePath, Me.colTPSFilePath, Me.colSummaryFilePath, Me.colExceptionFilePath, Me.coldatSubmitted, Me.coldatAccepted, Me.coldatRejected, Me.colErrorMessage, Me.colStackTrace, Me.colOverrideError, Me.coldatOverride, Me.colOverrideErrorName, Me.colIgnore, Me.colClientGroupId, Me.colClientGroupName, Me.colIsClientGroupActive, Me.colClientId, Me.colClientName, Me.colIsClientActive, Me.colStudyId, Me.colStudyName, Me.colSurveyId, Me.colIsStudyActive, Me.colSurveyName, Me.colIsSurveyActive, Me.colSampleUnitId, Me.colSampleUnitName, Me.colMedicareExportSetId, Me.colExportFileId, Me.colExportSetTypeId})
        Me.FileHistoryGridView.GridControl = Me.FileHistoryGridControl
        Me.FileHistoryGridView.Name = "FileHistoryGridView"
        Me.FileHistoryGridView.OptionsView.ColumnAutoWidth = False
        Me.FileHistoryGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colMedicareNumber
        '
        Me.colMedicareNumber.FieldName = "MedicareNumber"
        Me.colMedicareNumber.Name = "colMedicareNumber"
        Me.colMedicareNumber.OptionsColumn.AllowEdit = False
        Me.colMedicareNumber.OptionsColumn.ReadOnly = True
        Me.colMedicareNumber.Visible = True
        Me.colMedicareNumber.VisibleIndex = 0
        '
        'colMedicareName
        '
        Me.colMedicareName.FieldName = "MedicareName"
        Me.colMedicareName.Name = "colMedicareName"
        Me.colMedicareName.OptionsColumn.AllowEdit = False
        Me.colMedicareName.OptionsColumn.ReadOnly = True
        Me.colMedicareName.Visible = True
        Me.colMedicareName.VisibleIndex = 1
        '
        'colFacilityName
        '
        Me.colFacilityName.FieldName = "FacilityName"
        Me.colFacilityName.Name = "colFacilityName"
        Me.colFacilityName.OptionsColumn.AllowEdit = False
        Me.colFacilityName.OptionsColumn.ReadOnly = True
        Me.colFacilityName.Visible = True
        Me.colFacilityName.VisibleIndex = 2
        '
        'colExportName
        '
        Me.colExportName.FieldName = "ExportName"
        Me.colExportName.Name = "colExportName"
        Me.colExportName.OptionsColumn.AllowEdit = False
        Me.colExportName.OptionsColumn.ReadOnly = True
        Me.colExportName.Visible = True
        Me.colExportName.VisibleIndex = 3
        '
        'colCreatedDate
        '
        Me.colCreatedDate.FieldName = "CreatedDate"
        Me.colCreatedDate.Name = "colCreatedDate"
        Me.colCreatedDate.OptionsColumn.AllowEdit = False
        Me.colCreatedDate.OptionsColumn.ReadOnly = True
        Me.colCreatedDate.Visible = True
        Me.colCreatedDate.VisibleIndex = 4
        '
        'colExportStartDate
        '
        Me.colExportStartDate.FieldName = "ExportStartDate"
        Me.colExportStartDate.Name = "colExportStartDate"
        Me.colExportStartDate.OptionsColumn.AllowEdit = False
        Me.colExportStartDate.OptionsColumn.ReadOnly = True
        Me.colExportStartDate.Visible = True
        Me.colExportStartDate.VisibleIndex = 5
        '
        'colExportEndDate
        '
        Me.colExportEndDate.FieldName = "ExportEndDate"
        Me.colExportEndDate.Name = "colExportEndDate"
        Me.colExportEndDate.OptionsColumn.AllowEdit = False
        Me.colExportEndDate.OptionsColumn.ReadOnly = True
        Me.colExportEndDate.Visible = True
        Me.colExportEndDate.VisibleIndex = 6
        '
        'colFilePath
        '
        Me.colFilePath.ColumnEdit = Me.FilePathRepositoryItemHyperLinkEdit
        Me.colFilePath.FieldName = "FilePath"
        Me.colFilePath.Name = "colFilePath"
        Me.colFilePath.Visible = True
        Me.colFilePath.VisibleIndex = 8
        '
        'FilePathRepositoryItemHyperLinkEdit
        '
        Me.FilePathRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.FilePathRepositoryItemHyperLinkEdit.Name = "FilePathRepositoryItemHyperLinkEdit"
        '
        'colTPSFilePath
        '
        Me.colTPSFilePath.ColumnEdit = Me.TPSFilePathRepositoryItemHyperLinkEdit
        Me.colTPSFilePath.FieldName = "TPSFilePath"
        Me.colTPSFilePath.Name = "colTPSFilePath"
        Me.colTPSFilePath.Visible = True
        Me.colTPSFilePath.VisibleIndex = 9
        '
        'TPSFilePathRepositoryItemHyperLinkEdit
        '
        Me.TPSFilePathRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.TPSFilePathRepositoryItemHyperLinkEdit.Name = "TPSFilePathRepositoryItemHyperLinkEdit"
        '
        'colSummaryFilePath
        '
        Me.colSummaryFilePath.ColumnEdit = Me.SummaryFilePathRepositoryItemHyperLinkEdit
        Me.colSummaryFilePath.FieldName = "SummaryFilePath"
        Me.colSummaryFilePath.Name = "colSummaryFilePath"
        Me.colSummaryFilePath.Visible = True
        Me.colSummaryFilePath.VisibleIndex = 10
        '
        'SummaryFilePathRepositoryItemHyperLinkEdit
        '
        Me.SummaryFilePathRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.SummaryFilePathRepositoryItemHyperLinkEdit.Name = "SummaryFilePathRepositoryItemHyperLinkEdit"
        '
        'colExceptionFilePath
        '
        Me.colExceptionFilePath.ColumnEdit = Me.ExceptionFilePathRepositoryItemHyperLinkEdit
        Me.colExceptionFilePath.FieldName = "ExceptionFilePath"
        Me.colExceptionFilePath.Name = "colExceptionFilePath"
        Me.colExceptionFilePath.Visible = True
        Me.colExceptionFilePath.VisibleIndex = 11
        '
        'ExceptionFilePathRepositoryItemHyperLinkEdit
        '
        Me.ExceptionFilePathRepositoryItemHyperLinkEdit.AutoHeight = False
        Me.ExceptionFilePathRepositoryItemHyperLinkEdit.Name = "ExceptionFilePathRepositoryItemHyperLinkEdit"
        '
        'coldatSubmitted
        '
        Me.coldatSubmitted.Caption = "Submitted Date"
        Me.coldatSubmitted.FieldName = "datSubmitted"
        Me.coldatSubmitted.Name = "coldatSubmitted"
        Me.coldatSubmitted.OptionsColumn.AllowEdit = False
        Me.coldatSubmitted.OptionsColumn.ReadOnly = True
        Me.coldatSubmitted.Visible = True
        Me.coldatSubmitted.VisibleIndex = 11
        '
        'coldatAccepted
        '
        Me.coldatAccepted.Caption = "Accepted Date"
        Me.coldatAccepted.FieldName = "datAccepted"
        Me.coldatAccepted.Name = "coldatAccepted"
        Me.coldatAccepted.OptionsColumn.AllowEdit = False
        Me.coldatAccepted.OptionsColumn.ReadOnly = True
        Me.coldatAccepted.Visible = True
        Me.coldatAccepted.VisibleIndex = 12
        '
        'coldatRejected
        '
        Me.coldatRejected.Caption = "Rejected Date"
        Me.coldatRejected.FieldName = "datRejected"
        Me.coldatRejected.Name = "coldatRejected"
        Me.coldatRejected.OptionsColumn.AllowEdit = False
        Me.coldatRejected.OptionsColumn.ReadOnly = True
        Me.coldatRejected.Visible = True
        Me.coldatRejected.VisibleIndex = 13
        '
        'colErrorMessage
        '
        Me.colErrorMessage.FieldName = "ErrorMessage"
        Me.colErrorMessage.Name = "colErrorMessage"
        Me.colErrorMessage.OptionsColumn.AllowEdit = False
        Me.colErrorMessage.OptionsColumn.ReadOnly = True
        Me.colErrorMessage.Visible = True
        Me.colErrorMessage.VisibleIndex = 14
        '
        'colStackTrace
        '
        Me.colStackTrace.FieldName = "StackTrace"
        Me.colStackTrace.Name = "colStackTrace"
        Me.colStackTrace.OptionsColumn.AllowEdit = False
        Me.colStackTrace.OptionsColumn.ReadOnly = True
        Me.colStackTrace.Visible = True
        Me.colStackTrace.VisibleIndex = 15
        '
        'colOverrideError
        '
        Me.colOverrideError.Caption = "Error Overridden"
        Me.colOverrideError.FieldName = "OverrideError"
        Me.colOverrideError.Name = "colOverrideError"
        Me.colOverrideError.OptionsColumn.AllowEdit = False
        Me.colOverrideError.OptionsColumn.ReadOnly = True
        Me.colOverrideError.Visible = True
        Me.colOverrideError.VisibleIndex = 16
        '
        'coldatOverride
        '
        Me.coldatOverride.Caption = "Override Date"
        Me.coldatOverride.FieldName = "datOverride"
        Me.coldatOverride.Name = "coldatOverride"
        Me.coldatOverride.OptionsColumn.AllowEdit = False
        Me.coldatOverride.OptionsColumn.ReadOnly = True
        Me.coldatOverride.Visible = True
        Me.coldatOverride.VisibleIndex = 17
        '
        'colOverrideErrorName
        '
        Me.colOverrideErrorName.Caption = "Overridden By"
        Me.colOverrideErrorName.FieldName = "OverrideErrorName"
        Me.colOverrideErrorName.Name = "colOverrideErrorName"
        Me.colOverrideErrorName.OptionsColumn.AllowEdit = False
        Me.colOverrideErrorName.OptionsColumn.ReadOnly = True
        Me.colOverrideErrorName.Visible = True
        Me.colOverrideErrorName.VisibleIndex = 18
        '
        'colIgnore
        '
        Me.colIgnore.Caption = "Ignore"
        Me.colIgnore.FieldName = "Ignore"
        Me.colIgnore.Name = "colIgnore"
        Me.colIgnore.OptionsColumn.AllowEdit = False
        Me.colIgnore.OptionsColumn.ReadOnly = True
        Me.colIgnore.Visible = True
        Me.colIgnore.VisibleIndex = 19
        '
        'colClientGroupId
        '
        Me.colClientGroupId.FieldName = "ClientGroupId"
        Me.colClientGroupId.Name = "colClientGroupId"
        Me.colClientGroupId.OptionsColumn.AllowEdit = False
        Me.colClientGroupId.OptionsColumn.ReadOnly = True
        Me.colClientGroupId.Visible = True
        Me.colClientGroupId.VisibleIndex = 20
        '
        'colClientGroupName
        '
        Me.colClientGroupName.FieldName = "ClientGroupName"
        Me.colClientGroupName.Name = "colClientGroupName"
        Me.colClientGroupName.OptionsColumn.AllowEdit = False
        Me.colClientGroupName.OptionsColumn.ReadOnly = True
        Me.colClientGroupName.Visible = True
        Me.colClientGroupName.VisibleIndex = 21
        '
        'colIsClientGroupActive
        '
        Me.colIsClientGroupActive.FieldName = "IsClientGroupActive"
        Me.colIsClientGroupActive.Name = "colIsClientGroupActive"
        Me.colIsClientGroupActive.OptionsColumn.AllowEdit = False
        Me.colIsClientGroupActive.OptionsColumn.ReadOnly = True
        Me.colIsClientGroupActive.Visible = True
        Me.colIsClientGroupActive.VisibleIndex = 22
        '
        'colClientId
        '
        Me.colClientId.FieldName = "ClientId"
        Me.colClientId.Name = "colClientId"
        Me.colClientId.OptionsColumn.AllowEdit = False
        Me.colClientId.OptionsColumn.ReadOnly = True
        Me.colClientId.Visible = True
        Me.colClientId.VisibleIndex = 23
        '
        'colClientName
        '
        Me.colClientName.FieldName = "ClientName"
        Me.colClientName.Name = "colClientName"
        Me.colClientName.OptionsColumn.AllowEdit = False
        Me.colClientName.OptionsColumn.ReadOnly = True
        Me.colClientName.Visible = True
        Me.colClientName.VisibleIndex = 24
        '
        'colIsClientActive
        '
        Me.colIsClientActive.FieldName = "IsClientActive"
        Me.colIsClientActive.Name = "colIsClientActive"
        Me.colIsClientActive.OptionsColumn.AllowEdit = False
        Me.colIsClientActive.OptionsColumn.ReadOnly = True
        Me.colIsClientActive.Visible = True
        Me.colIsClientActive.VisibleIndex = 25
        '
        'colStudyId
        '
        Me.colStudyId.FieldName = "StudyId"
        Me.colStudyId.Name = "colStudyId"
        Me.colStudyId.OptionsColumn.AllowEdit = False
        Me.colStudyId.OptionsColumn.ReadOnly = True
        Me.colStudyId.Visible = True
        Me.colStudyId.VisibleIndex = 26
        '
        'colStudyName
        '
        Me.colStudyName.FieldName = "StudyName"
        Me.colStudyName.Name = "colStudyName"
        Me.colStudyName.OptionsColumn.AllowEdit = False
        Me.colStudyName.OptionsColumn.ReadOnly = True
        Me.colStudyName.Visible = True
        Me.colStudyName.VisibleIndex = 27
        '
        'colSurveyId
        '
        Me.colSurveyId.FieldName = "SurveyId"
        Me.colSurveyId.Name = "colSurveyId"
        Me.colSurveyId.OptionsColumn.AllowEdit = False
        Me.colSurveyId.OptionsColumn.ReadOnly = True
        Me.colSurveyId.Visible = True
        Me.colSurveyId.VisibleIndex = 28
        '
        'colIsStudyActive
        '
        Me.colIsStudyActive.FieldName = "IsStudyActive"
        Me.colIsStudyActive.Name = "colIsStudyActive"
        Me.colIsStudyActive.OptionsColumn.AllowEdit = False
        Me.colIsStudyActive.OptionsColumn.ReadOnly = True
        Me.colIsStudyActive.Visible = True
        Me.colIsStudyActive.VisibleIndex = 29
        '
        'colSurveyName
        '
        Me.colSurveyName.FieldName = "SurveyName"
        Me.colSurveyName.Name = "colSurveyName"
        Me.colSurveyName.OptionsColumn.AllowEdit = False
        Me.colSurveyName.OptionsColumn.ReadOnly = True
        Me.colSurveyName.Visible = True
        Me.colSurveyName.VisibleIndex = 30
        '
        'colIsSurveyActive
        '
        Me.colIsSurveyActive.FieldName = "IsSurveyActive"
        Me.colIsSurveyActive.Name = "colIsSurveyActive"
        Me.colIsSurveyActive.OptionsColumn.AllowEdit = False
        Me.colIsSurveyActive.OptionsColumn.ReadOnly = True
        Me.colIsSurveyActive.Visible = True
        Me.colIsSurveyActive.VisibleIndex = 31
        '
        'colSampleUnitId
        '
        Me.colSampleUnitId.FieldName = "SampleUnitId"
        Me.colSampleUnitId.Name = "colSampleUnitId"
        Me.colSampleUnitId.OptionsColumn.AllowEdit = False
        Me.colSampleUnitId.OptionsColumn.ReadOnly = True
        Me.colSampleUnitId.Visible = True
        Me.colSampleUnitId.VisibleIndex = 32
        '
        'colSampleUnitName
        '
        Me.colSampleUnitName.FieldName = "SampleUnitName"
        Me.colSampleUnitName.Name = "colSampleUnitName"
        Me.colSampleUnitName.OptionsColumn.AllowEdit = False
        Me.colSampleUnitName.OptionsColumn.ReadOnly = True
        Me.colSampleUnitName.Visible = True
        Me.colSampleUnitName.VisibleIndex = 33
        '
        'colMedicareExportSetId
        '
        Me.colMedicareExportSetId.FieldName = "MedicareExportSetId"
        Me.colMedicareExportSetId.Name = "colMedicareExportSetId"
        Me.colMedicareExportSetId.OptionsColumn.AllowEdit = False
        Me.colMedicareExportSetId.OptionsColumn.ReadOnly = True
        Me.colMedicareExportSetId.Visible = True
        Me.colMedicareExportSetId.VisibleIndex = 34
        '
        'colExportFileId
        '
        Me.colExportFileId.FieldName = "ExportFileId"
        Me.colExportFileId.Name = "colExportFileId"
        Me.colExportFileId.OptionsColumn.AllowEdit = False
        Me.colExportFileId.OptionsColumn.ReadOnly = True
        Me.colExportFileId.Visible = True
        Me.colExportFileId.VisibleIndex = 35
        '
        'colExportSetTypeId
        '
        Me.colExportSetTypeId.FieldName = "ExportSetTypeId"
        Me.colExportSetTypeId.Name = "colExportSetTypeId"
        Me.colExportSetTypeId.OptionsColumn.AllowEdit = False
        Me.colExportSetTypeId.OptionsColumn.ReadOnly = True
        Me.colExportSetTypeId.Visible = True
        Me.colExportSetTypeId.VisibleIndex = 36
        '
        'FileHistoryToolStrip
        '
        Me.FileHistoryToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.FileHistoryToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FilterToolStripButton, Me.ToolStripLabel2, Me.ToolStripLabel1})
        Me.FileHistoryToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.HorizontalStackWithOverflow
        Me.FileHistoryToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.FileHistoryToolStrip.Name = "FileHistoryToolStrip"
        Me.FileHistoryToolStrip.Size = New System.Drawing.Size(798, 25)
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
        'colIsMedicareActive
        '
        Me.colIsMedicareActive.FieldName = "IsMedicareActive"
        Me.colIsMedicareActive.Name = "colIsMedicareActive"
        Me.colIsMedicareActive.OptionsColumn.AllowEdit = False
        Me.colIsMedicareActive.OptionsColumn.ReadOnly = True
        Me.colIsMedicareActive.Visible = True
        Me.colIsMedicareActive.VisibleIndex = 2
        '
        'CAHPSFileHistorySection
        '
        Me.Controls.Add(Me.MainFileHistoryPanel)
        Me.Name = "CAHPSFileHistorySection"
        Me.Size = New System.Drawing.Size(800, 600)
        Me.MainFileHistoryPanel.ResumeLayout(False)
        Me.MainFileHistoryPanel.PerformLayout()
        Me.FileHistoryPanel.ResumeLayout(False)
        CType(Me.FileHistoryGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FileHistoryBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FileHistoryGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.TPSFilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SummaryFilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExceptionFilePathRepositoryItemHyperLinkEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.FileHistoryToolStrip.ResumeLayout(False)
        Me.FileHistoryToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainFileHistoryPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents FilterStartDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents FilterEndDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents FileHistoryPanel As System.Windows.Forms.Panel
    Friend WithEvents FileHistoryToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FilterToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents FileHistoryGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents FileHistoryGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents FileHistoryBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colMedicareNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMedicareName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colClientGroupName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFacilityName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colClientName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStudyName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurveyName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colClientGroupId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colClientId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStudyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurveyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatRejected As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatSubmitted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatAccepted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOverrideError As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOverrideErrorName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coldatOverride As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIgnore As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFilePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colTPSFilePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSummaryFilePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExceptionFilePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCreatedDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colErrorMessage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStackTrace As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSampleUnitName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsClientGroupActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsClientActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsStudyActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSurveyActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMedicareExportSetId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportFileId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportSetTypeId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportStartDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportEndDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSampleUnitId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FilePathRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents TPSFilePathRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents SummaryFilePathRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents ExceptionFilePathRepositoryItemHyperLinkEdit As DevExpress.XtraEditors.Repository.RepositoryItemHyperLinkEdit
    Friend WithEvents colIsMedicareActive As DevExpress.XtraGrid.Columns.GridColumn

End Class
