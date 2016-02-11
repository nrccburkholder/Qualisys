<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class UpdateEventCodesSection
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
        Me.MissingCodesSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.MissingCodesToolStrip = New System.Windows.Forms.ToolStrip
        Me.MissingCodesExcelTSButton = New System.Windows.Forms.ToolStripButton
        Me.MissingCodesPrintTSButton = New System.Windows.Forms.ToolStripButton
        Me.MissingCodesGrid = New DevExpress.XtraGrid.GridControl
        Me.MissingCodesBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MissingCodesGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colLastName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFirstName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colRespondentID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStatusString = New DevExpress.XtraGrid.Columns.GridColumn
        Me.UpdateOptionsSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.Label1 = New System.Windows.Forms.Label
        Me.ImportDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.FileCountNameLabel = New System.Windows.Forms.Label
        Me.FileCountTotalLabel = New System.Windows.Forms.Label
        Me.FileCountOfLabel = New System.Windows.Forms.Label
        Me.FileCountCurrentLabel = New System.Windows.Forms.Label
        Me.FileCountLabel = New System.Windows.Forms.Label
        Me.EventTypeComboBox = New System.Windows.Forms.ComboBox
        Me.EventTypeLabel = New System.Windows.Forms.Label
        Me.UpdateMappingGrid = New DevExpress.XtraGrid.GridControl
        Me.UpdateMappingBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.UpdateMappingGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colUpdateTypeID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUpdateMappingID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOrder = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNewEventID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colComplete = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOldEventID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCompleteString = New DevExpress.XtraGrid.Columns.GridColumn
        Me.UpdateCodesProgressBar = New System.Windows.Forms.ProgressBar
        Me.UpdateCodesButton = New System.Windows.Forms.Button
        Me.UpdateTypeComboBox = New System.Windows.Forms.ComboBox
        Me.UpdateTypeLabel = New System.Windows.Forms.Label
        Me.FileNameLabel = New System.Windows.Forms.Label
        Me.FileNameButton = New System.Windows.Forms.Button
        Me.FileNameTextBox = New System.Windows.Forms.TextBox
        Me.UpdateCodesOpenFileDialog = New System.Windows.Forms.OpenFileDialog
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        Me.MissingCodesSectionPanel.SuspendLayout()
        Me.MissingCodesToolStrip.SuspendLayout()
        CType(Me.MissingCodesGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MissingCodesBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MissingCodesGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.UpdateOptionsSectionPanel.SuspendLayout()
        CType(Me.UpdateMappingGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UpdateMappingBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UpdateMappingGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MissingCodesSectionPanel
        '
        Me.MissingCodesSectionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MissingCodesSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MissingCodesSectionPanel.Caption = "Respondants with Missing Event Codes"
        Me.MissingCodesSectionPanel.Controls.Add(Me.MissingCodesToolStrip)
        Me.MissingCodesSectionPanel.Controls.Add(Me.MissingCodesGrid)
        Me.MissingCodesSectionPanel.Location = New System.Drawing.Point(0, 286)
        Me.MissingCodesSectionPanel.Name = "MissingCodesSectionPanel"
        Me.MissingCodesSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MissingCodesSectionPanel.ShowCaption = True
        Me.MissingCodesSectionPanel.Size = New System.Drawing.Size(578, 294)
        Me.MissingCodesSectionPanel.TabIndex = 11
        '
        'MissingCodesToolStrip
        '
        Me.MissingCodesToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.MissingCodesToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MissingCodesExcelTSButton, Me.MissingCodesPrintTSButton})
        Me.MissingCodesToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.MissingCodesToolStrip.Name = "MissingCodesToolStrip"
        Me.MissingCodesToolStrip.Size = New System.Drawing.Size(576, 25)
        Me.MissingCodesToolStrip.TabIndex = 12
        '
        'MissingCodesExcelTSButton
        '
        Me.MissingCodesExcelTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Excel16
        Me.MissingCodesExcelTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MissingCodesExcelTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.MissingCodesExcelTSButton.Name = "MissingCodesExcelTSButton"
        Me.MissingCodesExcelTSButton.Size = New System.Drawing.Size(100, 22)
        Me.MissingCodesExcelTSButton.Text = "Export to Excel"
        '
        'MissingCodesPrintTSButton
        '
        Me.MissingCodesPrintTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.TestPrint16
        Me.MissingCodesPrintTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MissingCodesPrintTSButton.Name = "MissingCodesPrintTSButton"
        Me.MissingCodesPrintTSButton.Size = New System.Drawing.Size(49, 22)
        Me.MissingCodesPrintTSButton.Text = "Print"
        '
        'MissingCodesGrid
        '
        Me.MissingCodesGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MissingCodesGrid.DataSource = Me.MissingCodesBindingSource
        Me.MissingCodesGrid.EmbeddedNavigator.Name = ""
        Me.MissingCodesGrid.Location = New System.Drawing.Point(4, 55)
        Me.MissingCodesGrid.MainView = Me.MissingCodesGridView
        Me.MissingCodesGrid.Name = "MissingCodesGrid"
        Me.MissingCodesGrid.Size = New System.Drawing.Size(571, 235)
        Me.MissingCodesGrid.TabIndex = 18
        Me.MissingCodesGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.MissingCodesGridView})
        '
        'MissingCodesBindingSource
        '
        Me.MissingCodesBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.UpdateRespondent)
        '
        'MissingCodesGridView
        '
        Me.MissingCodesGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colLastName, Me.colFirstName, Me.colRespondentID, Me.colStatusString})
        Me.MissingCodesGridView.GridControl = Me.MissingCodesGrid
        Me.MissingCodesGridView.Name = "MissingCodesGridView"
        Me.MissingCodesGridView.OptionsBehavior.Editable = False
        Me.MissingCodesGridView.OptionsCustomization.AllowColumnMoving = False
        Me.MissingCodesGridView.OptionsCustomization.AllowFilter = False
        Me.MissingCodesGridView.OptionsCustomization.AllowGroup = False
        Me.MissingCodesGridView.OptionsCustomization.AllowSort = False
        Me.MissingCodesGridView.OptionsMenu.EnableColumnMenu = False
        Me.MissingCodesGridView.OptionsPrint.EnableAppearanceOddRow = True
        Me.MissingCodesGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.MissingCodesGridView.OptionsView.EnableAppearanceOddRow = True
        Me.MissingCodesGridView.OptionsView.ShowGroupPanel = False
        Me.MissingCodesGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colStatusString, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colLastName
        '
        Me.colLastName.Caption = "Last Name"
        Me.colLastName.FieldName = "LastName"
        Me.colLastName.Name = "colLastName"
        Me.colLastName.Visible = True
        Me.colLastName.VisibleIndex = 2
        '
        'colFirstName
        '
        Me.colFirstName.Caption = "First Name"
        Me.colFirstName.FieldName = "FirstName"
        Me.colFirstName.Name = "colFirstName"
        Me.colFirstName.Visible = True
        Me.colFirstName.VisibleIndex = 1
        '
        'colRespondentID
        '
        Me.colRespondentID.Caption = "Respondent ID"
        Me.colRespondentID.FieldName = "RespondentID"
        Me.colRespondentID.Name = "colRespondentID"
        Me.colRespondentID.OptionsColumn.ReadOnly = True
        Me.colRespondentID.Visible = True
        Me.colRespondentID.VisibleIndex = 0
        '
        'colStatusString
        '
        Me.colStatusString.Caption = "Status"
        Me.colStatusString.FieldName = "StatusString"
        Me.colStatusString.Name = "colStatusString"
        Me.colStatusString.Visible = True
        Me.colStatusString.VisibleIndex = 3
        '
        'UpdateOptionsSectionPanel
        '
        Me.UpdateOptionsSectionPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateOptionsSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.UpdateOptionsSectionPanel.Caption = "Update Options"
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.Label1)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.ImportDateTimePicker)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileCountNameLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileCountTotalLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileCountOfLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileCountCurrentLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileCountLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.EventTypeComboBox)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.EventTypeLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.UpdateMappingGrid)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.UpdateCodesProgressBar)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.UpdateCodesButton)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.UpdateTypeComboBox)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.UpdateTypeLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileNameLabel)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileNameButton)
        Me.UpdateOptionsSectionPanel.Controls.Add(Me.FileNameTextBox)
        Me.UpdateOptionsSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.UpdateOptionsSectionPanel.Name = "UpdateOptionsSectionPanel"
        Me.UpdateOptionsSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.UpdateOptionsSectionPanel.ShowCaption = True
        Me.UpdateOptionsSectionPanel.Size = New System.Drawing.Size(578, 280)
        Me.UpdateOptionsSectionPanel.TabIndex = 0
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(358, 45)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(104, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "ImportUpdate Date:"
        '
        'ImportDateTimePicker
        '
        Me.ImportDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImportDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.ImportDateTimePicker.Location = New System.Drawing.Point(468, 42)
        Me.ImportDateTimePicker.Name = "ImportDateTimePicker"
        Me.ImportDateTimePicker.Size = New System.Drawing.Size(94, 21)
        Me.ImportDateTimePicker.TabIndex = 5
        '
        'FileCountNameLabel
        '
        Me.FileCountNameLabel.AutoEllipsis = True
        Me.FileCountNameLabel.Location = New System.Drawing.Point(201, 253)
        Me.FileCountNameLabel.Name = "FileCountNameLabel"
        Me.FileCountNameLabel.Size = New System.Drawing.Size(261, 13)
        Me.FileCountNameLabel.TabIndex = 16
        Me.FileCountNameLabel.Text = "FileName"
        '
        'FileCountTotalLabel
        '
        Me.FileCountTotalLabel.Location = New System.Drawing.Point(160, 253)
        Me.FileCountTotalLabel.Name = "FileCountTotalLabel"
        Me.FileCountTotalLabel.Size = New System.Drawing.Size(35, 13)
        Me.FileCountTotalLabel.TabIndex = 15
        Me.FileCountTotalLabel.Text = "9999"
        '
        'FileCountOfLabel
        '
        Me.FileCountOfLabel.Location = New System.Drawing.Point(135, 253)
        Me.FileCountOfLabel.Name = "FileCountOfLabel"
        Me.FileCountOfLabel.Size = New System.Drawing.Size(19, 13)
        Me.FileCountOfLabel.TabIndex = 14
        Me.FileCountOfLabel.Text = "of"
        Me.FileCountOfLabel.TextAlign = System.Drawing.ContentAlignment.TopCenter
        '
        'FileCountCurrentLabel
        '
        Me.FileCountCurrentLabel.Location = New System.Drawing.Point(94, 253)
        Me.FileCountCurrentLabel.Name = "FileCountCurrentLabel"
        Me.FileCountCurrentLabel.Size = New System.Drawing.Size(35, 13)
        Me.FileCountCurrentLabel.TabIndex = 13
        Me.FileCountCurrentLabel.Text = "9999"
        Me.FileCountCurrentLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'FileCountLabel
        '
        Me.FileCountLabel.AutoSize = True
        Me.FileCountLabel.Location = New System.Drawing.Point(15, 253)
        Me.FileCountLabel.Name = "FileCountLabel"
        Me.FileCountLabel.Size = New System.Drawing.Size(73, 13)
        Me.FileCountLabel.TabIndex = 12
        Me.FileCountLabel.Text = "Updating File:"
        '
        'EventTypeComboBox
        '
        Me.EventTypeComboBox.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EventTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.EventTypeComboBox.FormattingEnabled = True
        Me.EventTypeComboBox.Location = New System.Drawing.Point(468, 78)
        Me.EventTypeComboBox.Name = "EventTypeComboBox"
        Me.EventTypeComboBox.Size = New System.Drawing.Size(94, 21)
        Me.EventTypeComboBox.TabIndex = 9
        '
        'EventTypeLabel
        '
        Me.EventTypeLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EventTypeLabel.AutoSize = True
        Me.EventTypeLabel.Location = New System.Drawing.Point(396, 81)
        Me.EventTypeLabel.Name = "EventTypeLabel"
        Me.EventTypeLabel.Size = New System.Drawing.Size(66, 13)
        Me.EventTypeLabel.TabIndex = 8
        Me.EventTypeLabel.Text = "Event Type:"
        '
        'UpdateMappingGrid
        '
        Me.UpdateMappingGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateMappingGrid.DataSource = Me.UpdateMappingBindingSource
        Me.UpdateMappingGrid.EmbeddedNavigator.Name = ""
        Me.UpdateMappingGrid.Location = New System.Drawing.Point(18, 115)
        Me.UpdateMappingGrid.MainView = Me.UpdateMappingGridView
        Me.UpdateMappingGrid.Name = "UpdateMappingGrid"
        Me.UpdateMappingGrid.Size = New System.Drawing.Size(544, 94)
        Me.UpdateMappingGrid.TabIndex = 10
        Me.UpdateMappingGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.UpdateMappingGridView})
        '
        'UpdateMappingBindingSource
        '
        Me.UpdateMappingBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.UpdateMapping)
        '
        'UpdateMappingGridView
        '
        Me.UpdateMappingGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colUpdateTypeID, Me.colUpdateMappingID, Me.colOrder, Me.colNewEventID, Me.colComplete, Me.colOldEventID, Me.colCompleteString})
        Me.UpdateMappingGridView.GridControl = Me.UpdateMappingGrid
        Me.UpdateMappingGridView.Name = "UpdateMappingGridView"
        Me.UpdateMappingGridView.OptionsBehavior.Editable = False
        Me.UpdateMappingGridView.OptionsCustomization.AllowColumnMoving = False
        Me.UpdateMappingGridView.OptionsCustomization.AllowFilter = False
        Me.UpdateMappingGridView.OptionsCustomization.AllowGroup = False
        Me.UpdateMappingGridView.OptionsCustomization.AllowSort = False
        Me.UpdateMappingGridView.OptionsMenu.EnableColumnMenu = False
        Me.UpdateMappingGridView.OptionsPrint.EnableAppearanceEvenRow = True
        Me.UpdateMappingGridView.OptionsPrint.EnableAppearanceOddRow = True
        Me.UpdateMappingGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.UpdateMappingGridView.OptionsView.EnableAppearanceOddRow = True
        Me.UpdateMappingGridView.OptionsView.ShowGroupPanel = False
        '
        'colUpdateTypeID
        '
        Me.colUpdateTypeID.Caption = "UpdateTypeID"
        Me.colUpdateTypeID.FieldName = "UpdateTypeID"
        Me.colUpdateTypeID.Name = "colUpdateTypeID"
        '
        'colUpdateMappingID
        '
        Me.colUpdateMappingID.Caption = "UpdateMappingID"
        Me.colUpdateMappingID.FieldName = "UpdateMappingID"
        Me.colUpdateMappingID.Name = "colUpdateMappingID"
        Me.colUpdateMappingID.OptionsColumn.ReadOnly = True
        '
        'colOrder
        '
        Me.colOrder.Caption = "Order"
        Me.colOrder.FieldName = "Order"
        Me.colOrder.Name = "colOrder"
        '
        'colNewEventID
        '
        Me.colNewEventID.Caption = "New Event"
        Me.colNewEventID.FieldName = "NewEventID"
        Me.colNewEventID.Name = "colNewEventID"
        Me.colNewEventID.Visible = True
        Me.colNewEventID.VisibleIndex = 2
        '
        'colComplete
        '
        Me.colComplete.Caption = "Complete"
        Me.colComplete.FieldName = "Complete"
        Me.colComplete.Name = "colComplete"
        '
        'colOldEventID
        '
        Me.colOldEventID.Caption = "Old Event"
        Me.colOldEventID.FieldName = "OldEventID"
        Me.colOldEventID.Name = "colOldEventID"
        Me.colOldEventID.Visible = True
        Me.colOldEventID.VisibleIndex = 1
        '
        'colCompleteString
        '
        Me.colCompleteString.Caption = "Event Type"
        Me.colCompleteString.FieldName = "CompleteString"
        Me.colCompleteString.Name = "colCompleteString"
        Me.colCompleteString.OptionsColumn.ReadOnly = True
        Me.colCompleteString.Visible = True
        Me.colCompleteString.VisibleIndex = 0
        '
        'UpdateCodesProgressBar
        '
        Me.UpdateCodesProgressBar.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateCodesProgressBar.Location = New System.Drawing.Point(18, 227)
        Me.UpdateCodesProgressBar.Name = "UpdateCodesProgressBar"
        Me.UpdateCodesProgressBar.Size = New System.Drawing.Size(444, 23)
        Me.UpdateCodesProgressBar.TabIndex = 11
        '
        'UpdateCodesButton
        '
        Me.UpdateCodesButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateCodesButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Check
        Me.UpdateCodesButton.Location = New System.Drawing.Point(477, 227)
        Me.UpdateCodesButton.Name = "UpdateCodesButton"
        Me.UpdateCodesButton.Size = New System.Drawing.Size(85, 39)
        Me.UpdateCodesButton.TabIndex = 17
        Me.UpdateCodesButton.Text = "Update Codes"
        Me.UpdateCodesButton.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.UpdateCodesButton.UseVisualStyleBackColor = True
        '
        'UpdateTypeComboBox
        '
        Me.UpdateTypeComboBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.UpdateTypeComboBox.FormattingEnabled = True
        Me.UpdateTypeComboBox.Location = New System.Drawing.Point(113, 78)
        Me.UpdateTypeComboBox.Name = "UpdateTypeComboBox"
        Me.UpdateTypeComboBox.Size = New System.Drawing.Size(242, 21)
        Me.UpdateTypeComboBox.TabIndex = 7
        '
        'UpdateTypeLabel
        '
        Me.UpdateTypeLabel.AutoSize = True
        Me.UpdateTypeLabel.Location = New System.Drawing.Point(15, 81)
        Me.UpdateTypeLabel.Name = "UpdateTypeLabel"
        Me.UpdateTypeLabel.Size = New System.Drawing.Size(73, 13)
        Me.UpdateTypeLabel.TabIndex = 6
        Me.UpdateTypeLabel.Text = "Update Type:"
        '
        'FileNameLabel
        '
        Me.FileNameLabel.AutoSize = True
        Me.FileNameLabel.Location = New System.Drawing.Point(15, 45)
        Me.FileNameLabel.Name = "FileNameLabel"
        Me.FileNameLabel.Size = New System.Drawing.Size(70, 13)
        Me.FileNameLabel.TabIndex = 1
        Me.FileNameLabel.Text = "File Name(s):"
        '
        'FileNameButton
        '
        Me.FileNameButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileNameButton.Location = New System.Drawing.Point(327, 41)
        Me.FileNameButton.Name = "FileNameButton"
        Me.FileNameButton.Size = New System.Drawing.Size(28, 23)
        Me.FileNameButton.TabIndex = 3
        Me.FileNameButton.Text = "..."
        Me.FileNameButton.UseVisualStyleBackColor = True
        '
        'FileNameTextBox
        '
        Me.FileNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileNameTextBox.Location = New System.Drawing.Point(113, 42)
        Me.FileNameTextBox.Name = "FileNameTextBox"
        Me.FileNameTextBox.ReadOnly = True
        Me.FileNameTextBox.Size = New System.Drawing.Size(216, 21)
        Me.FileNameTextBox.TabIndex = 2
        '
        'UpdateCodesOpenFileDialog
        '
        Me.UpdateCodesOpenFileDialog.DefaultExt = "str"
        Me.UpdateCodesOpenFileDialog.Filter = "STR Files|*.str|All Files|*.*"
        Me.UpdateCodesOpenFileDialog.Multiselect = True
        Me.UpdateCodesOpenFileDialog.Title = "Select File(s) To Be Updated"
        '
        'SaveFileDialog
        '
        Me.SaveFileDialog.DefaultExt = "xls"
        Me.SaveFileDialog.Filter = "Excel Files|*.xls"
        Me.SaveFileDialog.Title = "Respondents with Missing Event Codes"
        '
        'UpdateEventCodesSection
        '
        Me.Controls.Add(Me.MissingCodesSectionPanel)
        Me.Controls.Add(Me.UpdateOptionsSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "UpdateEventCodesSection"
        Me.Size = New System.Drawing.Size(578, 580)
        Me.MissingCodesSectionPanel.ResumeLayout(False)
        Me.MissingCodesSectionPanel.PerformLayout()
        Me.MissingCodesToolStrip.ResumeLayout(False)
        Me.MissingCodesToolStrip.PerformLayout()
        CType(Me.MissingCodesGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MissingCodesBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MissingCodesGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.UpdateOptionsSectionPanel.ResumeLayout(False)
        Me.UpdateOptionsSectionPanel.PerformLayout()
        CType(Me.UpdateMappingGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UpdateMappingBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UpdateMappingGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MissingCodesSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents UpdateOptionsSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents FileNameLabel As System.Windows.Forms.Label
    Friend WithEvents FileNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents FileNameButton As System.Windows.Forms.Button
    Friend WithEvents UpdateTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents UpdateTypeLabel As System.Windows.Forms.Label
    Friend WithEvents UpdateCodesButton As System.Windows.Forms.Button
    Friend WithEvents UpdateCodesProgressBar As System.Windows.Forms.ProgressBar
    Friend WithEvents MissingCodesGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents MissingCodesGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents MissingCodesToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents MissingCodesExcelTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MissingCodesPrintTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateMappingGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents UpdateMappingGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents UpdateMappingBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colUpdateTypeID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUpdateMappingID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOrder As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNewEventID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colComplete As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOldEventID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCompleteString As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents EventTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents EventTypeLabel As System.Windows.Forms.Label
    Friend WithEvents UpdateCodesOpenFileDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents MissingCodesBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colLastName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFirstName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colRespondentID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FileCountNameLabel As System.Windows.Forms.Label
    Friend WithEvents FileCountTotalLabel As System.Windows.Forms.Label
    Friend WithEvents FileCountOfLabel As System.Windows.Forms.Label
    Friend WithEvents FileCountCurrentLabel As System.Windows.Forms.Label
    Friend WithEvents FileCountLabel As System.Windows.Forms.Label
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents ImportDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents colStatusString As DevExpress.XtraGrid.Columns.GridColumn

End Class
