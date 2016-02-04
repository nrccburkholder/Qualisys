<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ViewExportLogSection
    Inherits SurveyPointUtilities.Section

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
        Me.Label1 = New System.Windows.Forms.Label
        Me.MaxDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.UpdateEventLogRerunTSButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.MinDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.UpdateEventLogGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colExportLogFileID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportGroupID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportGroupName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStartDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEndDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMark2401RangeStartDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMark2401RangeEndDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUserName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQuestionFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQuestionFileRecordsExported = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAnswerFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAnswerFileRecordsExported = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colerrorMessage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStackTrace = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMarkSubmitted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RespondentsExported = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUserID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ExportFileLogGrid = New DevExpress.XtraGrid.GridControl
        Me.ExportGroupLogBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.UpdateEventLogSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ExportGroupLogToolStrip = New System.Windows.Forms.ToolStrip
        Me.UpdateEventLogExcelTSButton = New System.Windows.Forms.ToolStripButton
        Me.UpdateEventLogPrintTSButton = New System.Windows.Forms.ToolStripButton
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        CType(Me.UpdateEventLogGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExportFileLogGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExportGroupLogBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.UpdateEventLogSectionPanel.SuspendLayout()
        Me.ExportGroupLogToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(231, 282)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(216, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "View Export Log Section to be Implemented."
        '
        'MaxDateTimePicker
        '
        Me.MaxDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MaxDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.MaxDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.MaxDateTimePicker.Location = New System.Drawing.Point(580, 29)
        Me.MaxDateTimePicker.Name = "MaxDateTimePicker"
        Me.MaxDateTimePicker.Size = New System.Drawing.Size(85, 20)
        Me.MaxDateTimePicker.TabIndex = 6
        '
        'UpdateEventLogRerunTSButton
        '
        Me.UpdateEventLogRerunTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.GoLtr
        Me.UpdateEventLogRerunTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateEventLogRerunTSButton.Name = "UpdateEventLogRerunTSButton"
        Me.UpdateEventLogRerunTSButton.Size = New System.Drawing.Size(56, 22)
        Me.UpdateEventLogRerunTSButton.Text = "Rerun"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel1.Margin = New System.Windows.Forms.Padding(0, 1, 91, 2)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(70, 22)
        Me.ToolStripLabel1.Text = "To End Date:"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel2.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(88, 22)
        Me.ToolStripLabel2.Text = "From Start Date:"
        '
        'MinDateTimePicker
        '
        Me.MinDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MinDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.MinDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.MinDateTimePicker.Location = New System.Drawing.Point(411, 29)
        Me.MinDateTimePicker.Name = "MinDateTimePicker"
        Me.MinDateTimePicker.Size = New System.Drawing.Size(85, 20)
        Me.MinDateTimePicker.TabIndex = 5
        '
        'UpdateEventLogGridView
        '
        Me.UpdateEventLogGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colExportLogFileID, Me.colExportGroupID, Me.colExportGroupName, Me.colStartDate, Me.colEndDate, Me.colMark2401RangeStartDate, Me.colMark2401RangeEndDate, Me.colUserName, Me.colQuestionFileName, Me.colQuestionFileRecordsExported, Me.colAnswerFileName, Me.colAnswerFileRecordsExported, Me.colerrorMessage, Me.colStackTrace, Me.colMarkSubmitted, Me.colIsActive, Me.RespondentsExported, Me.colUserID})
        Me.UpdateEventLogGridView.GridControl = Me.ExportFileLogGrid
        Me.UpdateEventLogGridView.Name = "UpdateEventLogGridView"
        Me.UpdateEventLogGridView.OptionsCustomization.AllowColumnMoving = False
        Me.UpdateEventLogGridView.OptionsCustomization.AllowGroup = False
        Me.UpdateEventLogGridView.OptionsPrint.EnableAppearanceEvenRow = True
        Me.UpdateEventLogGridView.OptionsPrint.EnableAppearanceOddRow = True
        Me.UpdateEventLogGridView.OptionsView.ColumnAutoWidth = False
        Me.UpdateEventLogGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.UpdateEventLogGridView.OptionsView.EnableAppearanceOddRow = True
        Me.UpdateEventLogGridView.OptionsView.ShowGroupPanel = False
        '
        'colExportLogFileID
        '
        Me.colExportLogFileID.Caption = "LogID"
        Me.colExportLogFileID.FieldName = "ExportLogFileID"
        Me.colExportLogFileID.Name = "colExportLogFileID"
        Me.colExportLogFileID.OptionsColumn.AllowEdit = False
        Me.colExportLogFileID.OptionsColumn.ReadOnly = True
        Me.colExportLogFileID.OptionsFilter.AllowAutoFilter = False
        Me.colExportLogFileID.OptionsFilter.AllowFilter = False
        Me.colExportLogFileID.Visible = True
        Me.colExportLogFileID.VisibleIndex = 0
        Me.colExportLogFileID.Width = 40
        '
        'colExportGroupID
        '
        Me.colExportGroupID.Caption = "Export Group ID"
        Me.colExportGroupID.FieldName = "ExportGroupID"
        Me.colExportGroupID.Name = "colExportGroupID"
        Me.colExportGroupID.OptionsColumn.AllowEdit = False
        Me.colExportGroupID.Visible = True
        Me.colExportGroupID.VisibleIndex = 1
        Me.colExportGroupID.Width = 98
        '
        'colExportGroupName
        '
        Me.colExportGroupName.Caption = "Export Group Name"
        Me.colExportGroupName.FieldName = "ExportGroupName"
        Me.colExportGroupName.Name = "colExportGroupName"
        Me.colExportGroupName.OptionsColumn.AllowEdit = False
        Me.colExportGroupName.OptionsFilter.AllowAutoFilter = False
        Me.colExportGroupName.OptionsFilter.AllowFilter = False
        Me.colExportGroupName.Visible = True
        Me.colExportGroupName.VisibleIndex = 2
        Me.colExportGroupName.Width = 112
        '
        'colStartDate
        '
        Me.colStartDate.Caption = "Start Date"
        Me.colStartDate.FieldName = "StartDate"
        Me.colStartDate.Name = "colStartDate"
        Me.colStartDate.OptionsColumn.AllowEdit = False
        Me.colStartDate.OptionsFilter.AllowAutoFilter = False
        Me.colStartDate.OptionsFilter.AllowFilter = False
        Me.colStartDate.Visible = True
        Me.colStartDate.VisibleIndex = 3
        '
        'colEndDate
        '
        Me.colEndDate.Caption = "End Date"
        Me.colEndDate.FieldName = "EndDate"
        Me.colEndDate.Name = "colEndDate"
        Me.colEndDate.OptionsColumn.AllowEdit = False
        Me.colEndDate.OptionsFilter.AllowAutoFilter = False
        Me.colEndDate.OptionsFilter.AllowFilter = False
        Me.colEndDate.Visible = True
        Me.colEndDate.VisibleIndex = 4
        '
        'colMark2401RangeStartDate
        '
        Me.colMark2401RangeStartDate.Caption = "Mark 2401 Start Date"
        Me.colMark2401RangeStartDate.FieldName = "Mark2401RangeStartDate"
        Me.colMark2401RangeStartDate.Name = "colMark2401RangeStartDate"
        Me.colMark2401RangeStartDate.OptionsColumn.AllowEdit = False
        Me.colMark2401RangeStartDate.OptionsFilter.AllowAutoFilter = False
        Me.colMark2401RangeStartDate.OptionsFilter.AllowFilter = False
        Me.colMark2401RangeStartDate.Visible = True
        Me.colMark2401RangeStartDate.VisibleIndex = 5
        Me.colMark2401RangeStartDate.Width = 127
        '
        'colMark2401RangeEndDate
        '
        Me.colMark2401RangeEndDate.Caption = "Mark 2401 End Date"
        Me.colMark2401RangeEndDate.FieldName = "Mark2401RangeEndDate"
        Me.colMark2401RangeEndDate.Name = "colMark2401RangeEndDate"
        Me.colMark2401RangeEndDate.OptionsColumn.AllowEdit = False
        Me.colMark2401RangeEndDate.OptionsFilter.AllowAutoFilter = False
        Me.colMark2401RangeEndDate.OptionsFilter.AllowFilter = False
        Me.colMark2401RangeEndDate.Visible = True
        Me.colMark2401RangeEndDate.VisibleIndex = 6
        Me.colMark2401RangeEndDate.Width = 124
        '
        'colUserName
        '
        Me.colUserName.Caption = "User Name"
        Me.colUserName.FieldName = "UserName"
        Me.colUserName.Name = "colUserName"
        Me.colUserName.OptionsColumn.AllowEdit = False
        Me.colUserName.OptionsFilter.AllowAutoFilter = False
        Me.colUserName.OptionsFilter.AllowFilter = False
        Me.colUserName.Visible = True
        Me.colUserName.VisibleIndex = 7
        '
        'colQuestionFileName
        '
        Me.colQuestionFileName.Caption = "Question File Name"
        Me.colQuestionFileName.FieldName = "QuestionFileName"
        Me.colQuestionFileName.Name = "colQuestionFileName"
        Me.colQuestionFileName.OptionsColumn.AllowEdit = False
        Me.colQuestionFileName.OptionsFilter.AllowAutoFilter = False
        Me.colQuestionFileName.OptionsFilter.AllowFilter = False
        Me.colQuestionFileName.Visible = True
        Me.colQuestionFileName.VisibleIndex = 8
        '
        'colQuestionFileRecordsExported
        '
        Me.colQuestionFileRecordsExported.Caption = "Question File Records Exported"
        Me.colQuestionFileRecordsExported.FieldName = "QuestionFileRecordsExported"
        Me.colQuestionFileRecordsExported.Name = "colQuestionFileRecordsExported"
        Me.colQuestionFileRecordsExported.OptionsColumn.AllowEdit = False
        Me.colQuestionFileRecordsExported.OptionsFilter.AllowAutoFilter = False
        Me.colQuestionFileRecordsExported.OptionsFilter.AllowFilter = False
        Me.colQuestionFileRecordsExported.Visible = True
        Me.colQuestionFileRecordsExported.VisibleIndex = 9
        '
        'colAnswerFileName
        '
        Me.colAnswerFileName.Caption = "Result File Name"
        Me.colAnswerFileName.FieldName = "AnswerFileName"
        Me.colAnswerFileName.Name = "colAnswerFileName"
        Me.colAnswerFileName.OptionsColumn.AllowEdit = False
        Me.colAnswerFileName.OptionsFilter.AllowAutoFilter = False
        Me.colAnswerFileName.OptionsFilter.AllowFilter = False
        Me.colAnswerFileName.Visible = True
        Me.colAnswerFileName.VisibleIndex = 10
        '
        'colAnswerFileRecordsExported
        '
        Me.colAnswerFileRecordsExported.Caption = "Result File Records Exported"
        Me.colAnswerFileRecordsExported.FieldName = "AnswerFileRecordsExported"
        Me.colAnswerFileRecordsExported.Name = "colAnswerFileRecordsExported"
        Me.colAnswerFileRecordsExported.OptionsColumn.AllowEdit = False
        Me.colAnswerFileRecordsExported.OptionsFilter.AllowAutoFilter = False
        Me.colAnswerFileRecordsExported.OptionsFilter.AllowFilter = False
        Me.colAnswerFileRecordsExported.Visible = True
        Me.colAnswerFileRecordsExported.VisibleIndex = 11
        '
        'colerrorMessage
        '
        Me.colerrorMessage.Caption = "Error Message"
        Me.colerrorMessage.FieldName = "errorMessage"
        Me.colerrorMessage.Name = "colerrorMessage"
        Me.colerrorMessage.OptionsColumn.AllowEdit = False
        Me.colerrorMessage.OptionsFilter.AllowAutoFilter = False
        Me.colerrorMessage.OptionsFilter.AllowFilter = False
        Me.colerrorMessage.Visible = True
        Me.colerrorMessage.VisibleIndex = 12
        '
        'colStackTrace
        '
        Me.colStackTrace.Caption = "Stack Trace"
        Me.colStackTrace.FieldName = "StackTrace"
        Me.colStackTrace.Name = "colStackTrace"
        Me.colStackTrace.OptionsColumn.AllowEdit = False
        Me.colStackTrace.OptionsFilter.AllowAutoFilter = False
        Me.colStackTrace.OptionsFilter.AllowFilter = False
        Me.colStackTrace.Visible = True
        Me.colStackTrace.VisibleIndex = 13
        '
        'colMarkSubmitted
        '
        Me.colMarkSubmitted.Caption = "Mark Submitted"
        Me.colMarkSubmitted.FieldName = "MarkSubmitted"
        Me.colMarkSubmitted.Name = "colMarkSubmitted"
        Me.colMarkSubmitted.OptionsColumn.AllowEdit = False
        Me.colMarkSubmitted.OptionsFilter.AllowAutoFilter = False
        Me.colMarkSubmitted.OptionsFilter.AllowFilter = False
        Me.colMarkSubmitted.Visible = True
        Me.colMarkSubmitted.VisibleIndex = 14
        '
        'colIsActive
        '
        Me.colIsActive.Caption = "Is Active"
        Me.colIsActive.FieldName = "IsActive"
        Me.colIsActive.Name = "colIsActive"
        Me.colIsActive.OptionsColumn.AllowEdit = False
        Me.colIsActive.OptionsFilter.AllowAutoFilter = False
        Me.colIsActive.OptionsFilter.AllowFilter = False
        Me.colIsActive.Visible = True
        Me.colIsActive.VisibleIndex = 15
        '
        'RespondentsExported
        '
        Me.RespondentsExported.Caption = "Respondents Exported"
        Me.RespondentsExported.FieldName = "RespondentsExported"
        Me.RespondentsExported.Name = "RespondentsExported"
        Me.RespondentsExported.OptionsColumn.AllowEdit = False
        Me.RespondentsExported.OptionsColumn.ReadOnly = True
        Me.RespondentsExported.OptionsFilter.AllowAutoFilter = False
        Me.RespondentsExported.OptionsFilter.AllowFilter = False
        Me.RespondentsExported.Visible = True
        Me.RespondentsExported.VisibleIndex = 16
        '
        'colUserID
        '
        Me.colUserID.Caption = "UserID"
        Me.colUserID.FieldName = "UserID"
        Me.colUserID.Name = "colUserID"
        Me.colUserID.OptionsColumn.AllowEdit = False
        '
        'ExportFileLogGrid
        '
        Me.ExportFileLogGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportFileLogGrid.DataSource = Me.ExportGroupLogBindingSource
        Me.ExportFileLogGrid.EmbeddedNavigator.Name = ""
        Me.ExportFileLogGrid.Location = New System.Drawing.Point(3, 55)
        Me.ExportFileLogGrid.MainView = Me.UpdateEventLogGridView
        Me.ExportFileLogGrid.Name = "ExportFileLogGrid"
        Me.ExportFileLogGrid.Size = New System.Drawing.Size(663, 560)
        Me.ExportFileLogGrid.TabIndex = 3
        Me.ExportFileLogGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.UpdateEventLogGridView})
        '
        'ExportGroupLogBindingSource
        '
        Me.ExportGroupLogBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.ExportFileLog)
        '
        'UpdateEventLogSectionPanel
        '
        Me.UpdateEventLogSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.UpdateEventLogSectionPanel.Caption = "Export Group Log"
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.MaxDateTimePicker)
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.MinDateTimePicker)
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.ExportFileLogGrid)
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.ExportGroupLogToolStrip)
        Me.UpdateEventLogSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.UpdateEventLogSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.UpdateEventLogSectionPanel.Name = "UpdateEventLogSectionPanel"
        Me.UpdateEventLogSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.UpdateEventLogSectionPanel.ShowCaption = True
        Me.UpdateEventLogSectionPanel.Size = New System.Drawing.Size(672, 620)
        Me.UpdateEventLogSectionPanel.TabIndex = 1
        '
        'ExportGroupLogToolStrip
        '
        Me.ExportGroupLogToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ExportGroupLogToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateEventLogExcelTSButton, Me.UpdateEventLogPrintTSButton, Me.ToolStripLabel1, Me.ToolStripLabel2, Me.UpdateEventLogRerunTSButton})
        Me.ExportGroupLogToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.ExportGroupLogToolStrip.Name = "ExportGroupLogToolStrip"
        Me.ExportGroupLogToolStrip.Size = New System.Drawing.Size(670, 25)
        Me.ExportGroupLogToolStrip.TabIndex = 1
        '
        'UpdateEventLogExcelTSButton
        '
        Me.UpdateEventLogExcelTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Excel16
        Me.UpdateEventLogExcelTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateEventLogExcelTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.UpdateEventLogExcelTSButton.Name = "UpdateEventLogExcelTSButton"
        Me.UpdateEventLogExcelTSButton.Size = New System.Drawing.Size(100, 22)
        Me.UpdateEventLogExcelTSButton.Text = "Export to Excel"
        '
        'UpdateEventLogPrintTSButton
        '
        Me.UpdateEventLogPrintTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.TestPrint16
        Me.UpdateEventLogPrintTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateEventLogPrintTSButton.Name = "UpdateEventLogPrintTSButton"
        Me.UpdateEventLogPrintTSButton.Size = New System.Drawing.Size(49, 22)
        Me.UpdateEventLogPrintTSButton.Text = "Print"
        '
        'SaveFileDialog
        '
        Me.SaveFileDialog.DefaultExt = "xls"
        Me.SaveFileDialog.Filter = "Excel Files|*.xls"
        Me.SaveFileDialog.Title = "Update File Log"
        '
        'ViewExportLogSection
        '
        Me.Controls.Add(Me.UpdateEventLogSectionPanel)
        Me.Controls.Add(Me.Label1)
        Me.Name = "ViewExportLogSection"
        Me.Size = New System.Drawing.Size(672, 620)
        CType(Me.UpdateEventLogGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExportFileLogGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExportGroupLogBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.UpdateEventLogSectionPanel.ResumeLayout(False)
        Me.UpdateEventLogSectionPanel.PerformLayout()
        Me.ExportGroupLogToolStrip.ResumeLayout(False)
        Me.ExportGroupLogToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents MaxDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents UpdateEventLogRerunTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents MinDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents UpdateEventLogGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents ExportFileLogGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents UpdateEventLogSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ExportGroupLogToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents UpdateEventLogExcelTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateEventLogPrintTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents colQuestionFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStackTrace As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStartDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMarkSubmitted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAnswerFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEndDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAnswerFileRecordsExported As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMark2401RangeStartDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUserID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportGroupID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colerrorMessage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colQuestionFileRecordsExported As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMark2401RangeEndDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportGroupName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportLogFileID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUserName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ExportGroupLogBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents RespondentsExported As DevExpress.XtraGrid.Columns.GridColumn

End Class
