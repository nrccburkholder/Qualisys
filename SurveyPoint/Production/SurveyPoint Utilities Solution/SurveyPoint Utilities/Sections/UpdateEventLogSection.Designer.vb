<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class UpdateEventLogSection
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
        Me.UpdateEventLogSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.MaxDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.MinDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.UpdateEventLogGrid = New DevExpress.XtraGrid.GridControl
        Me.UpdateEventLogBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.UpdateEventLogGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUpdateTypeName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumRecords = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumUpdated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumMissingCodes = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateLoaded = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUserName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUpdateTypeID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUserID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFileLogID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.UpdateEventLogToolStrip = New System.Windows.Forms.ToolStrip
        Me.UpdateEventLogExcelTSButton = New System.Windows.Forms.ToolStripButton
        Me.UpdateEventLogPrintTSButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        Me.UpdateEventLogRerunTSButton = New System.Windows.Forms.ToolStripButton
        Me.UpdateEventLogSectionPanel.SuspendLayout()
        CType(Me.UpdateEventLogGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UpdateEventLogBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UpdateEventLogGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.UpdateEventLogToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'UpdateEventLogSectionPanel
        '
        Me.UpdateEventLogSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.UpdateEventLogSectionPanel.Caption = "Update Event Codes Log"
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.MaxDateTimePicker)
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.MinDateTimePicker)
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.UpdateEventLogGrid)
        Me.UpdateEventLogSectionPanel.Controls.Add(Me.UpdateEventLogToolStrip)
        Me.UpdateEventLogSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.UpdateEventLogSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.UpdateEventLogSectionPanel.Name = "UpdateEventLogSectionPanel"
        Me.UpdateEventLogSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.UpdateEventLogSectionPanel.ShowCaption = True
        Me.UpdateEventLogSectionPanel.Size = New System.Drawing.Size(529, 474)
        Me.UpdateEventLogSectionPanel.TabIndex = 0
        '
        'MaxDateTimePicker
        '
        Me.MaxDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MaxDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.MaxDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.MaxDateTimePicker.Location = New System.Drawing.Point(437, 29)
        Me.MaxDateTimePicker.Name = "MaxDateTimePicker"
        Me.MaxDateTimePicker.Size = New System.Drawing.Size(85, 21)
        Me.MaxDateTimePicker.TabIndex = 6
        '
        'MinDateTimePicker
        '
        Me.MinDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MinDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.MinDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.MinDateTimePicker.Location = New System.Drawing.Point(313, 29)
        Me.MinDateTimePicker.Name = "MinDateTimePicker"
        Me.MinDateTimePicker.Size = New System.Drawing.Size(85, 21)
        Me.MinDateTimePicker.TabIndex = 5
        '
        'UpdateEventLogGrid
        '
        Me.UpdateEventLogGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateEventLogGrid.DataSource = Me.UpdateEventLogBindingSource
        Me.UpdateEventLogGrid.EmbeddedNavigator.Name = ""
        Me.UpdateEventLogGrid.Location = New System.Drawing.Point(5, 56)
        Me.UpdateEventLogGrid.MainView = Me.UpdateEventLogGridView
        Me.UpdateEventLogGrid.Name = "UpdateEventLogGrid"
        Me.UpdateEventLogGrid.Size = New System.Drawing.Size(520, 414)
        Me.UpdateEventLogGrid.TabIndex = 3
        Me.UpdateEventLogGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.UpdateEventLogGridView})
        '
        'UpdateEventLogBindingSource
        '
        Me.UpdateEventLogBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.UpdateFileLog)
        '
        'UpdateEventLogGridView
        '
        Me.UpdateEventLogGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFileName, Me.colUpdateTypeName, Me.colNumRecords, Me.colNumUpdated, Me.colNumMissingCodes, Me.colDateLoaded, Me.colUserName, Me.colUpdateTypeID, Me.colUserID, Me.colFileLogID})
        Me.UpdateEventLogGridView.GridControl = Me.UpdateEventLogGrid
        Me.UpdateEventLogGridView.Name = "UpdateEventLogGridView"
        Me.UpdateEventLogGridView.OptionsBehavior.Editable = False
        Me.UpdateEventLogGridView.OptionsCustomization.AllowColumnMoving = False
        Me.UpdateEventLogGridView.OptionsCustomization.AllowGroup = False
        Me.UpdateEventLogGridView.OptionsPrint.EnableAppearanceEvenRow = True
        Me.UpdateEventLogGridView.OptionsPrint.EnableAppearanceOddRow = True
        Me.UpdateEventLogGridView.OptionsView.ColumnAutoWidth = False
        Me.UpdateEventLogGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.UpdateEventLogGridView.OptionsView.EnableAppearanceOddRow = True
        Me.UpdateEventLogGridView.OptionsView.ShowAutoFilterRow = True
        Me.UpdateEventLogGridView.OptionsView.ShowGroupPanel = False
        '
        'colFileName
        '
        Me.colFileName.Caption = "File Name"
        Me.colFileName.FieldName = "FileName"
        Me.colFileName.Name = "colFileName"
        Me.colFileName.Visible = True
        Me.colFileName.VisibleIndex = 0
        Me.colFileName.Width = 230
        '
        'colUpdateTypeName
        '
        Me.colUpdateTypeName.Caption = "Update Type"
        Me.colUpdateTypeName.FieldName = "UpdateTypeName"
        Me.colUpdateTypeName.Name = "colUpdateTypeName"
        Me.colUpdateTypeName.Visible = True
        Me.colUpdateTypeName.VisibleIndex = 1
        Me.colUpdateTypeName.Width = 150
        '
        'colNumRecords
        '
        Me.colNumRecords.Caption = "Qty Records"
        Me.colNumRecords.FieldName = "NumRecords"
        Me.colNumRecords.Name = "colNumRecords"
        Me.colNumRecords.Visible = True
        Me.colNumRecords.VisibleIndex = 2
        Me.colNumRecords.Width = 85
        '
        'colNumUpdated
        '
        Me.colNumUpdated.Caption = "Qty Updated"
        Me.colNumUpdated.FieldName = "NumUpdated"
        Me.colNumUpdated.Name = "colNumUpdated"
        Me.colNumUpdated.Visible = True
        Me.colNumUpdated.VisibleIndex = 3
        Me.colNumUpdated.Width = 85
        '
        'colNumMissingCodes
        '
        Me.colNumMissingCodes.Caption = "Qty Missing"
        Me.colNumMissingCodes.FieldName = "NumMissingCodes"
        Me.colNumMissingCodes.Name = "colNumMissingCodes"
        Me.colNumMissingCodes.Visible = True
        Me.colNumMissingCodes.VisibleIndex = 4
        Me.colNumMissingCodes.Width = 85
        '
        'colDateLoaded
        '
        Me.colDateLoaded.Caption = "Date Updated"
        Me.colDateLoaded.DisplayFormat.FormatString = "MM/dd/yyyy hh:mm"
        Me.colDateLoaded.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colDateLoaded.FieldName = "DateLoaded"
        Me.colDateLoaded.Name = "colDateLoaded"
        Me.colDateLoaded.Visible = True
        Me.colDateLoaded.VisibleIndex = 5
        Me.colDateLoaded.Width = 100
        '
        'colUserName
        '
        Me.colUserName.Caption = "User Name"
        Me.colUserName.FieldName = "UserName"
        Me.colUserName.Name = "colUserName"
        Me.colUserName.Visible = True
        Me.colUserName.VisibleIndex = 6
        Me.colUserName.Width = 100
        '
        'colUpdateTypeID
        '
        Me.colUpdateTypeID.Caption = "UpdateTypeID"
        Me.colUpdateTypeID.FieldName = "UpdateTypeID"
        Me.colUpdateTypeID.Name = "colUpdateTypeID"
        '
        'colUserID
        '
        Me.colUserID.Caption = "UserID"
        Me.colUserID.FieldName = "UserID"
        Me.colUserID.Name = "colUserID"
        '
        'colFileLogID
        '
        Me.colFileLogID.Caption = "FileLogID"
        Me.colFileLogID.FieldName = "FileLogID"
        Me.colFileLogID.Name = "colFileLogID"
        Me.colFileLogID.OptionsColumn.ReadOnly = True
        '
        'UpdateEventLogToolStrip
        '
        Me.UpdateEventLogToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.UpdateEventLogToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateEventLogExcelTSButton, Me.UpdateEventLogPrintTSButton, Me.ToolStripLabel1, Me.ToolStripLabel2, Me.UpdateEventLogRerunTSButton})
        Me.UpdateEventLogToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.UpdateEventLogToolStrip.Name = "UpdateEventLogToolStrip"
        Me.UpdateEventLogToolStrip.Size = New System.Drawing.Size(527, 25)
        Me.UpdateEventLogToolStrip.TabIndex = 1
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
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel1.Margin = New System.Windows.Forms.Padding(0, 1, 91, 2)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(23, 22)
        Me.ToolStripLabel1.Text = "To:"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel2.Margin = New System.Windows.Forms.Padding(0, 1, 100, 2)
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(35, 22)
        Me.ToolStripLabel2.Text = "From:"
        '
        'SaveFileDialog
        '
        Me.SaveFileDialog.DefaultExt = "xls"
        Me.SaveFileDialog.Filter = "Excel Files|*.xls"
        Me.SaveFileDialog.Title = "Update File Log"
        '
        'UpdateEventLogRerunTSButton
        '
        Me.UpdateEventLogRerunTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.GoLtr
        Me.UpdateEventLogRerunTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateEventLogRerunTSButton.Name = "UpdateEventLogRerunTSButton"
        Me.UpdateEventLogRerunTSButton.Size = New System.Drawing.Size(56, 22)
        Me.UpdateEventLogRerunTSButton.Text = "Rerun"
        '
        'UpdateEventLogSection
        '
        Me.Controls.Add(Me.UpdateEventLogSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "UpdateEventLogSection"
        Me.Size = New System.Drawing.Size(529, 474)
        Me.UpdateEventLogSectionPanel.ResumeLayout(False)
        Me.UpdateEventLogSectionPanel.PerformLayout()
        CType(Me.UpdateEventLogGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UpdateEventLogBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UpdateEventLogGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.UpdateEventLogToolStrip.ResumeLayout(False)
        Me.UpdateEventLogToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents UpdateEventLogSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents UpdateEventLogToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents UpdateEventLogExcelTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateEventLogPrintTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateEventLogGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents UpdateEventLogGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents UpdateEventLogBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colNumMissingCodes As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateLoaded As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUpdateTypeID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUserID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileLogID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNumRecords As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUpdateTypeName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents MinDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents MaxDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents colUserName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNumUpdated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents UpdateEventLogRerunTSButton As System.Windows.Forms.ToolStripButton

End Class
