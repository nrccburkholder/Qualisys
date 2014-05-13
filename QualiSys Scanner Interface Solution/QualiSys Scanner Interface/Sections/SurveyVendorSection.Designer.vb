<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SurveyVendorSection
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SurveyVendorSection))
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.ApplyButton = New System.Windows.Forms.Button
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.MethSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.MethGridControl = New DevExpress.XtraGrid.GridControl
        Me.MethBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MethGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurveyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStandardMethodologyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemLookUpEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.StandardMethBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colIsActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAllowEdit = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAllowDelete = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsCustomizable = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStandardMethodology = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsDirty = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsNew = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurvey = New DevExpress.XtraGrid.Columns.GridColumn
        Me.MethToolStrip = New System.Windows.Forms.ToolStrip
        Me.MethEditTSButton = New System.Windows.Forms.ToolStripButton
        Me.SplitContainer2 = New System.Windows.Forms.SplitContainer
        Me.MethStepSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.MethStepGridControl = New DevExpress.XtraGrid.GridControl
        Me.MethStepBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MethStepGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colId1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMethodologyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSurveyId1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSequenceNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCoverLetterId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemLookUpEdit2 = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.CoverLetterBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colDaysSincePreviousStep = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSurvey = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsThankYouLetter = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsFirstSurvey = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOverrideLanguageId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemLookUpEdit3 = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.LanguageBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colLinkedStepId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colLinkedStep = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStepMethodId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExpirationDays = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQuotaID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQuotaIDAllReturns = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQuotaIDStopReturns = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQuotaStopCollectionAt = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDaysInField = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumberOfAttempts = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsWeekDayDayCall = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsWeekDayEveCall = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSaturdayDayCall = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSaturdayEveCall = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSundayDayCall = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSundayEveCall = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsCallBackOtherLang = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsCallBackUsingTTY = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsAcceptPartial = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsEmailBlast = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExpireFromStepId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExpireFromStep = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIncludeWithPrevStep = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExpireFromStepName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colVendorID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.VendorGridLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
        Me.VendorBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colVendorId1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colVendorCode = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colVendorName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPhone = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAddr1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAddr2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCity = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStateCode = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colProvince = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colZip5 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colZip4 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateModified = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAcceptFilesFromVendor = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNoResponseChar = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSkipResponseChar = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMultiRespItemNotPickedChar = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colLocalFTPLoginName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colVendorSurveyID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.VendorSurveyLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.VendorSurveyBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MethStepToolStrip = New System.Windows.Forms.ToolStrip
        Me.MethStepApplyTSButton = New System.Windows.Forms.ToolStripButton
        Me.MethStepUndoTSButton = New System.Windows.Forms.ToolStripButton
        Me.MethPropsSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.MethodologyPropsWebPanel = New System.Windows.Forms.Panel
        Me.WebEmailBlastGridControl = New DevExpress.XtraGrid.GridControl
        Me.EmailBlastBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.WebEmailBlastGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colEmailBlastId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.EmailBlastNameLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.EmailBlastOptionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colDaysFromStepGen = New DevExpress.XtraGrid.Columns.GridColumn
        Me.DaysFromStepGenTextEdit = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
        Me.EmailBlastNameComboBox = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.EmailBlastNameGridLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
        Me.RepositoryItemGridLookUpEdit1View = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.WebEmailBlastCheckBox = New System.Windows.Forms.CheckBox
        Me.WebQuotasGroupBox = New System.Windows.Forms.GroupBox
        Me.WebReturnsLabel = New System.Windows.Forms.Label
        Me.WebQuotasStopReturnsTextBox = New System.Windows.Forms.TextBox
        Me.WebQuotasStopReturnsRadioButton = New System.Windows.Forms.RadioButton
        Me.WebQuotasAllReturnsRadioButton = New System.Windows.Forms.RadioButton
        Me.WebDaysInFieldLabel = New System.Windows.Forms.Label
        Me.WebAcceptPartialCheckBox = New System.Windows.Forms.CheckBox
        Me.WebDaysInFieldTextBox = New System.Windows.Forms.TextBox
        Me.MethodologyPropsIVRPanel = New System.Windows.Forms.Panel
        Me.IVRDaysInFieldLabel = New System.Windows.Forms.Label
        Me.IVRAcceptPartialCheckBox = New System.Windows.Forms.CheckBox
        Me.IVRDaysInFieldTextBox = New System.Windows.Forms.TextBox
        Me.MethodologyPropsPhonePanel = New System.Windows.Forms.Panel
        Me.PhoneEveningSunCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneDaySunCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneEveningSatCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneDaySatCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneSundayLabel = New System.Windows.Forms.Label
        Me.PhoneSaturdayLabel = New System.Windows.Forms.Label
        Me.PhoneMFLabel = New System.Windows.Forms.Label
        Me.PhoneEveningMFCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneNumberOfAttemptsLabel = New System.Windows.Forms.Label
        Me.PhoneNumberOfAttemptsTextBox = New System.Windows.Forms.TextBox
        Me.PhoneTTYCallbackCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneLangCallbackCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneQuotasGroupBox = New System.Windows.Forms.GroupBox
        Me.PhoneReturnsLabel = New System.Windows.Forms.Label
        Me.PhoneQuotasStopReturnsTextBox = New System.Windows.Forms.TextBox
        Me.PhoneQuotasStopReturnsRadioButton = New System.Windows.Forms.RadioButton
        Me.PhoneQuotasAllReturnsRadioButton = New System.Windows.Forms.RadioButton
        Me.PhoneDaysInFieldLabel = New System.Windows.Forms.Label
        Me.PhoneDayMFCheckBox = New System.Windows.Forms.CheckBox
        Me.PhoneDaysInFieldTextBox = New System.Windows.Forms.TextBox
        Me.GridColumn1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GridColumn2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GridColumn3 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.CancelButton = New System.Windows.Forms.Button
        Me.BottomPanel.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.MethSectionPanel.SuspendLayout()
        CType(Me.MethGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MethBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MethGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemLookUpEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.StandardMethBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MethToolStrip.SuspendLayout()
        Me.SplitContainer2.Panel1.SuspendLayout()
        Me.SplitContainer2.Panel2.SuspendLayout()
        Me.SplitContainer2.SuspendLayout()
        Me.MethStepSectionPanel.SuspendLayout()
        CType(Me.MethStepGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MethStepBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MethStepGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemLookUpEdit2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CoverLetterBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemLookUpEdit3, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.LanguageBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorGridLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorSurveyLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorSurveyBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MethStepToolStrip.SuspendLayout()
        Me.MethPropsSectionPanel.SuspendLayout()
        Me.MethodologyPropsWebPanel.SuspendLayout()
        CType(Me.WebEmailBlastGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.WebEmailBlastGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastNameLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastOptionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DaysFromStepGenTextEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastNameComboBox, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastNameGridLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemGridLookUpEdit1View, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.WebQuotasGroupBox.SuspendLayout()
        Me.MethodologyPropsIVRPanel.SuspendLayout()
        Me.MethodologyPropsPhonePanel.SuspendLayout()
        Me.PhoneQuotasGroupBox.SuspendLayout()
        Me.SuspendLayout()
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Controls.Add(Me.ApplyButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 656)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(814, 35)
        Me.BottomPanel.TabIndex = 4
        '
        'ApplyButton
        '
        Me.ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplyButton.Location = New System.Drawing.Point(649, 5)
        Me.ApplyButton.Name = "ApplyButton"
        Me.ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.ApplyButton.TabIndex = 0
        Me.ApplyButton.Text = "Apply"
        Me.ApplyButton.UseVisualStyleBackColor = True
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.MethSectionPanel)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.SplitContainer2)
        Me.SplitContainer1.Panel2.Enabled = False
        Me.SplitContainer1.Size = New System.Drawing.Size(814, 656)
        Me.SplitContainer1.SplitterDistance = 230
        Me.SplitContainer1.TabIndex = 5
        '
        'MethSectionPanel
        '
        Me.MethSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MethSectionPanel.Caption = "Survey Methodologies"
        Me.MethSectionPanel.Controls.Add(Me.MethGridControl)
        Me.MethSectionPanel.Controls.Add(Me.MethToolStrip)
        Me.MethSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MethSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.MethSectionPanel.Name = "MethSectionPanel"
        Me.MethSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethSectionPanel.ShowCaption = True
        Me.MethSectionPanel.Size = New System.Drawing.Size(814, 230)
        Me.MethSectionPanel.TabIndex = 6
        '
        'MethGridControl
        '
        Me.MethGridControl.DataSource = Me.MethBindingSource
        Me.MethGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MethGridControl.EmbeddedNavigator.Name = ""
        Me.MethGridControl.Location = New System.Drawing.Point(1, 52)
        Me.MethGridControl.MainView = Me.MethGridView
        Me.MethGridControl.Name = "MethGridControl"
        Me.MethGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemLookUpEdit1})
        Me.MethGridControl.Size = New System.Drawing.Size(812, 177)
        Me.MethGridControl.TabIndex = 5
        Me.MethGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.MethGridView})
        '
        'MethBindingSource
        '
        Me.MethBindingSource.AllowNew = False
        Me.MethBindingSource.DataSource = GetType(Nrc.QualiSys.Library.Methodology)
        '
        'MethGridView
        '
        Me.MethGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colId, Me.colSurveyId, Me.colName, Me.colStandardMethodologyId, Me.colIsActive, Me.colAllowEdit, Me.colAllowDelete, Me.colDateCreated, Me.colIsCustomizable, Me.colStandardMethodology, Me.colIsDirty, Me.colIsNew, Me.colSurvey})
        Me.MethGridView.GridControl = Me.MethGridControl
        Me.MethGridView.Name = "MethGridView"
        Me.MethGridView.OptionsBehavior.Editable = False
        Me.MethGridView.OptionsView.ShowDetailButtons = False
        Me.MethGridView.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.MethGridView.OptionsView.ShowGroupPanel = False
        '
        'colId
        '
        Me.colId.Caption = "Id"
        Me.colId.FieldName = "Id"
        Me.colId.Name = "colId"
        Me.colId.OptionsColumn.ReadOnly = True
        '
        'colSurveyId
        '
        Me.colSurveyId.Caption = "SurveyId"
        Me.colSurveyId.FieldName = "SurveyId"
        Me.colSurveyId.Name = "colSurveyId"
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        '
        'colStandardMethodologyId
        '
        Me.colStandardMethodologyId.Caption = "Type"
        Me.colStandardMethodologyId.ColumnEdit = Me.RepositoryItemLookUpEdit1
        Me.colStandardMethodologyId.FieldName = "StandardMethodologyId"
        Me.colStandardMethodologyId.Name = "colStandardMethodologyId"
        Me.colStandardMethodologyId.Visible = True
        Me.colStandardMethodologyId.VisibleIndex = 2
        '
        'RepositoryItemLookUpEdit1
        '
        Me.RepositoryItemLookUpEdit1.AutoHeight = False
        Me.RepositoryItemLookUpEdit1.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemLookUpEdit1.DataSource = Me.StandardMethBindingSource
        Me.RepositoryItemLookUpEdit1.DisplayMember = "Name"
        Me.RepositoryItemLookUpEdit1.Name = "RepositoryItemLookUpEdit1"
        Me.RepositoryItemLookUpEdit1.ValueMember = "Id"
        '
        'StandardMethBindingSource
        '
        Me.StandardMethBindingSource.DataSource = GetType(Nrc.QualiSys.Library.StandardMethodology)
        '
        'colIsActive
        '
        Me.colIsActive.Caption = "Active"
        Me.colIsActive.FieldName = "IsActive"
        Me.colIsActive.Name = "colIsActive"
        Me.colIsActive.Visible = True
        Me.colIsActive.VisibleIndex = 0
        '
        'colAllowEdit
        '
        Me.colAllowEdit.Caption = "AllowEdit"
        Me.colAllowEdit.FieldName = "AllowEdit"
        Me.colAllowEdit.Name = "colAllowEdit"
        Me.colAllowEdit.OptionsColumn.ReadOnly = True
        '
        'colAllowDelete
        '
        Me.colAllowDelete.Caption = "AllowDelete"
        Me.colAllowDelete.FieldName = "AllowDelete"
        Me.colAllowDelete.Name = "colAllowDelete"
        Me.colAllowDelete.OptionsColumn.ReadOnly = True
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "Date Created"
        Me.colDateCreated.DisplayFormat.FormatString = "MM/dd/yyyy hh:mm:ss tt"
        Me.colDateCreated.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        Me.colDateCreated.OptionsColumn.ReadOnly = True
        Me.colDateCreated.Visible = True
        Me.colDateCreated.VisibleIndex = 3
        '
        'colIsCustomizable
        '
        Me.colIsCustomizable.Caption = "IsCustomizable"
        Me.colIsCustomizable.FieldName = "IsCustomizable"
        Me.colIsCustomizable.Name = "colIsCustomizable"
        Me.colIsCustomizable.OptionsColumn.ReadOnly = True
        '
        'colStandardMethodology
        '
        Me.colStandardMethodology.Caption = "StandardMethodology"
        Me.colStandardMethodology.FieldName = "StandardMethodology"
        Me.colStandardMethodology.Name = "colStandardMethodology"
        '
        'colIsDirty
        '
        Me.colIsDirty.Caption = "IsDirty"
        Me.colIsDirty.FieldName = "IsDirty"
        Me.colIsDirty.Name = "colIsDirty"
        Me.colIsDirty.OptionsColumn.ReadOnly = True
        '
        'colIsNew
        '
        Me.colIsNew.Caption = "IsNew"
        Me.colIsNew.FieldName = "IsNew"
        Me.colIsNew.Name = "colIsNew"
        Me.colIsNew.OptionsColumn.ReadOnly = True
        '
        'colSurvey
        '
        Me.colSurvey.Caption = "Survey"
        Me.colSurvey.FieldName = "Survey"
        Me.colSurvey.Name = "colSurvey"
        Me.colSurvey.OptionsColumn.ReadOnly = True
        '
        'MethToolStrip
        '
        Me.MethToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MethEditTSButton})
        Me.MethToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.MethToolStrip.Name = "MethToolStrip"
        Me.MethToolStrip.Size = New System.Drawing.Size(812, 25)
        Me.MethToolStrip.TabIndex = 3
        Me.MethToolStrip.Text = "ToolStrip1"
        '
        'MethEditTSButton
        '
        Me.MethEditTSButton.Enabled = False
        Me.MethEditTSButton.Image = CType(resources.GetObject("MethEditTSButton.Image"), System.Drawing.Image)
        Me.MethEditTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethEditTSButton.Name = "MethEditTSButton"
        Me.MethEditTSButton.Size = New System.Drawing.Size(75, 22)
        Me.MethEditTSButton.Text = "Edit Steps"
        '
        'SplitContainer2
        '
        Me.SplitContainer2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer2.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer2.Name = "SplitContainer2"
        Me.SplitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer2.Panel1
        '
        Me.SplitContainer2.Panel1.Controls.Add(Me.MethStepSectionPanel)
        Me.SplitContainer2.Panel1.Enabled = False
        '
        'SplitContainer2.Panel2
        '
        Me.SplitContainer2.Panel2.Controls.Add(Me.MethPropsSectionPanel)
        Me.SplitContainer2.Panel2.Enabled = False
        Me.SplitContainer2.Size = New System.Drawing.Size(814, 422)
        Me.SplitContainer2.SplitterDistance = 226
        Me.SplitContainer2.TabIndex = 0
        '
        'MethStepSectionPanel
        '
        Me.MethStepSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MethStepSectionPanel.Caption = "Methodology Steps"
        Me.MethStepSectionPanel.Controls.Add(Me.MethStepGridControl)
        Me.MethStepSectionPanel.Controls.Add(Me.MethStepToolStrip)
        Me.MethStepSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MethStepSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.MethStepSectionPanel.Name = "MethStepSectionPanel"
        Me.MethStepSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethStepSectionPanel.ShowCaption = True
        Me.MethStepSectionPanel.Size = New System.Drawing.Size(814, 226)
        Me.MethStepSectionPanel.TabIndex = 7
        '
        'MethStepGridControl
        '
        Me.MethStepGridControl.DataSource = Me.MethStepBindingSource
        Me.MethStepGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MethStepGridControl.EmbeddedNavigator.Name = ""
        Me.MethStepGridControl.Location = New System.Drawing.Point(1, 52)
        Me.MethStepGridControl.MainView = Me.MethStepGridView
        Me.MethStepGridControl.Name = "MethStepGridControl"
        Me.MethStepGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemLookUpEdit2, Me.RepositoryItemLookUpEdit3, Me.VendorGridLookUpEdit, Me.VendorSurveyLookUpEdit})
        Me.MethStepGridControl.Size = New System.Drawing.Size(812, 173)
        Me.MethStepGridControl.TabIndex = 7
        Me.MethStepGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.MethStepGridView})
        '
        'MethStepBindingSource
        '
        Me.MethStepBindingSource.AllowNew = False
        Me.MethStepBindingSource.DataSource = GetType(Nrc.QualiSys.Library.MethodologyStep)
        '
        'MethStepGridView
        '
        Me.MethStepGridView.Appearance.HeaderPanel.Options.UseTextOptions = True
        Me.MethStepGridView.Appearance.HeaderPanel.TextOptions.WordWrap = DevExpress.Utils.WordWrap.Wrap
        Me.MethStepGridView.ColumnPanelRowHeight = 35
        Me.MethStepGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colId1, Me.colName1, Me.colMethodologyId, Me.colSurveyId1, Me.colSequenceNumber, Me.colCoverLetterId, Me.colDaysSincePreviousStep, Me.colIsSurvey, Me.colIsThankYouLetter, Me.colIsFirstSurvey, Me.colOverrideLanguageId, Me.colLinkedStepId, Me.colLinkedStep, Me.colStepMethodId, Me.colExpirationDays, Me.colQuotaID, Me.colQuotaIDAllReturns, Me.colQuotaIDStopReturns, Me.colQuotaStopCollectionAt, Me.colDaysInField, Me.colNumberOfAttempts, Me.colIsWeekDayDayCall, Me.colIsWeekDayEveCall, Me.colIsSaturdayDayCall, Me.colIsSaturdayEveCall, Me.colIsSundayDayCall, Me.colIsSundayEveCall, Me.colIsCallBackOtherLang, Me.colIsCallBackUsingTTY, Me.colIsAcceptPartial, Me.colIsEmailBlast, Me.colExpireFromStepId, Me.colExpireFromStep, Me.colIncludeWithPrevStep, Me.colExpireFromStepName, Me.colVendorID, Me.colVendorSurveyID})
        Me.MethStepGridView.GridControl = Me.MethStepGridControl
        Me.MethStepGridView.Name = "MethStepGridView"
        Me.MethStepGridView.OptionsView.ShowDetailButtons = False
        Me.MethStepGridView.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.MethStepGridView.OptionsView.ShowGroupPanel = False
        '
        'colId1
        '
        Me.colId1.Caption = "Id"
        Me.colId1.FieldName = "Id"
        Me.colId1.Name = "colId1"
        Me.colId1.OptionsColumn.ReadOnly = True
        '
        'colName1
        '
        Me.colName1.Caption = "Step Type"
        Me.colName1.FieldName = "Name"
        Me.colName1.Name = "colName1"
        Me.colName1.OptionsColumn.ReadOnly = True
        Me.colName1.Visible = True
        Me.colName1.VisibleIndex = 0
        '
        'colMethodologyId
        '
        Me.colMethodologyId.Caption = "MethodologyId"
        Me.colMethodologyId.FieldName = "MethodologyId"
        Me.colMethodologyId.Name = "colMethodologyId"
        '
        'colSurveyId1
        '
        Me.colSurveyId1.Caption = "SurveyId"
        Me.colSurveyId1.FieldName = "SurveyId"
        Me.colSurveyId1.Name = "colSurveyId1"
        '
        'colSequenceNumber
        '
        Me.colSequenceNumber.Caption = "SequenceNumber"
        Me.colSequenceNumber.FieldName = "SequenceNumber"
        Me.colSequenceNumber.Name = "colSequenceNumber"
        Me.colSequenceNumber.OptionsColumn.ReadOnly = True
        '
        'colCoverLetterId
        '
        Me.colCoverLetterId.Caption = "Cover Letter"
        Me.colCoverLetterId.ColumnEdit = Me.RepositoryItemLookUpEdit2
        Me.colCoverLetterId.FieldName = "CoverLetterId"
        Me.colCoverLetterId.Name = "colCoverLetterId"
        Me.colCoverLetterId.OptionsColumn.ReadOnly = True
        Me.colCoverLetterId.Visible = True
        Me.colCoverLetterId.VisibleIndex = 4
        '
        'RepositoryItemLookUpEdit2
        '
        Me.RepositoryItemLookUpEdit2.AutoHeight = False
        Me.RepositoryItemLookUpEdit2.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemLookUpEdit2.DataSource = Me.CoverLetterBindingSource
        Me.RepositoryItemLookUpEdit2.DisplayMember = "Name"
        Me.RepositoryItemLookUpEdit2.Name = "RepositoryItemLookUpEdit2"
        Me.RepositoryItemLookUpEdit2.NullText = "N/A"
        Me.RepositoryItemLookUpEdit2.ValueMember = "Id"
        '
        'CoverLetterBindingSource
        '
        Me.CoverLetterBindingSource.DataSource = GetType(Nrc.QualiSys.Library.CoverLetter)
        '
        'colDaysSincePreviousStep
        '
        Me.colDaysSincePreviousStep.Caption = "Days Since Previous Step"
        Me.colDaysSincePreviousStep.FieldName = "DaysSincePreviousStep"
        Me.colDaysSincePreviousStep.Name = "colDaysSincePreviousStep"
        Me.colDaysSincePreviousStep.OptionsColumn.ReadOnly = True
        Me.colDaysSincePreviousStep.Visible = True
        Me.colDaysSincePreviousStep.VisibleIndex = 3
        '
        'colIsSurvey
        '
        Me.colIsSurvey.Caption = "IsSurvey"
        Me.colIsSurvey.FieldName = "IsSurvey"
        Me.colIsSurvey.Name = "colIsSurvey"
        '
        'colIsThankYouLetter
        '
        Me.colIsThankYouLetter.Caption = "IsThankYouLetter"
        Me.colIsThankYouLetter.FieldName = "IsThankYouLetter"
        Me.colIsThankYouLetter.Name = "colIsThankYouLetter"
        '
        'colIsFirstSurvey
        '
        Me.colIsFirstSurvey.Caption = "IsFirstSurvey"
        Me.colIsFirstSurvey.FieldName = "IsFirstSurvey"
        Me.colIsFirstSurvey.Name = "colIsFirstSurvey"
        '
        'colOverrideLanguageId
        '
        Me.colOverrideLanguageId.Caption = "Language"
        Me.colOverrideLanguageId.ColumnEdit = Me.RepositoryItemLookUpEdit3
        Me.colOverrideLanguageId.FieldName = "OverrideLanguageId"
        Me.colOverrideLanguageId.Name = "colOverrideLanguageId"
        Me.colOverrideLanguageId.OptionsColumn.ReadOnly = True
        Me.colOverrideLanguageId.Visible = True
        Me.colOverrideLanguageId.VisibleIndex = 6
        '
        'RepositoryItemLookUpEdit3
        '
        Me.RepositoryItemLookUpEdit3.AutoHeight = False
        Me.RepositoryItemLookUpEdit3.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemLookUpEdit3.DataSource = Me.LanguageBindingSource
        Me.RepositoryItemLookUpEdit3.DisplayMember = "Name"
        Me.RepositoryItemLookUpEdit3.Name = "RepositoryItemLookUpEdit3"
        Me.RepositoryItemLookUpEdit3.NullText = "Use Lang ID"
        Me.RepositoryItemLookUpEdit3.ValueMember = "Id"
        '
        'LanguageBindingSource
        '
        Me.LanguageBindingSource.AllowNew = False
        Me.LanguageBindingSource.DataSource = GetType(Nrc.QualiSys.Library.Language)
        '
        'colLinkedStepId
        '
        Me.colLinkedStepId.Caption = "LinkedStepId"
        Me.colLinkedStepId.FieldName = "LinkedStepId"
        Me.colLinkedStepId.Name = "colLinkedStepId"
        Me.colLinkedStepId.OptionsColumn.ReadOnly = True
        '
        'colLinkedStep
        '
        Me.colLinkedStep.Caption = "LinkedStep"
        Me.colLinkedStep.FieldName = "LinkedStep"
        Me.colLinkedStep.Name = "colLinkedStep"
        '
        'colStepMethodId
        '
        Me.colStepMethodId.Caption = "StepMethodId"
        Me.colStepMethodId.FieldName = "StepMethodId"
        Me.colStepMethodId.Name = "colStepMethodId"
        '
        'colExpirationDays
        '
        Me.colExpirationDays.Caption = "Days Until Expiration"
        Me.colExpirationDays.FieldName = "ExpirationDays"
        Me.colExpirationDays.Name = "colExpirationDays"
        Me.colExpirationDays.OptionsColumn.ReadOnly = True
        Me.colExpirationDays.Visible = True
        Me.colExpirationDays.VisibleIndex = 7
        '
        'colQuotaID
        '
        Me.colQuotaID.Caption = "QuotaID"
        Me.colQuotaID.FieldName = "QuotaID"
        Me.colQuotaID.Name = "colQuotaID"
        '
        'colQuotaIDAllReturns
        '
        Me.colQuotaIDAllReturns.Caption = "QuotaIDAllReturns"
        Me.colQuotaIDAllReturns.FieldName = "QuotaIDAllReturns"
        Me.colQuotaIDAllReturns.Name = "colQuotaIDAllReturns"
        '
        'colQuotaIDStopReturns
        '
        Me.colQuotaIDStopReturns.Caption = "QuotaIDStopReturns"
        Me.colQuotaIDStopReturns.FieldName = "QuotaIDStopReturns"
        Me.colQuotaIDStopReturns.Name = "colQuotaIDStopReturns"
        '
        'colQuotaStopCollectionAt
        '
        Me.colQuotaStopCollectionAt.Caption = "QuotaStopCollectionAt"
        Me.colQuotaStopCollectionAt.FieldName = "QuotaStopCollectionAt"
        Me.colQuotaStopCollectionAt.Name = "colQuotaStopCollectionAt"
        '
        'colDaysInField
        '
        Me.colDaysInField.Caption = "DaysInField"
        Me.colDaysInField.FieldName = "DaysInField"
        Me.colDaysInField.Name = "colDaysInField"
        '
        'colNumberOfAttempts
        '
        Me.colNumberOfAttempts.Caption = "NumberOfAttempts"
        Me.colNumberOfAttempts.FieldName = "NumberOfAttempts"
        Me.colNumberOfAttempts.Name = "colNumberOfAttempts"
        '
        'colIsWeekDayDayCall
        '
        Me.colIsWeekDayDayCall.Caption = "IsWeekDayDayCall"
        Me.colIsWeekDayDayCall.FieldName = "IsWeekDayDayCall"
        Me.colIsWeekDayDayCall.Name = "colIsWeekDayDayCall"
        '
        'colIsWeekDayEveCall
        '
        Me.colIsWeekDayEveCall.Caption = "IsWeekDayEveCall"
        Me.colIsWeekDayEveCall.FieldName = "IsWeekDayEveCall"
        Me.colIsWeekDayEveCall.Name = "colIsWeekDayEveCall"
        '
        'colIsSaturdayDayCall
        '
        Me.colIsSaturdayDayCall.Caption = "IsSaturdayDayCall"
        Me.colIsSaturdayDayCall.FieldName = "IsSaturdayDayCall"
        Me.colIsSaturdayDayCall.Name = "colIsSaturdayDayCall"
        '
        'colIsSaturdayEveCall
        '
        Me.colIsSaturdayEveCall.Caption = "IsSaturdayEveCall"
        Me.colIsSaturdayEveCall.FieldName = "IsSaturdayEveCall"
        Me.colIsSaturdayEveCall.Name = "colIsSaturdayEveCall"
        '
        'colIsSundayDayCall
        '
        Me.colIsSundayDayCall.Caption = "IsSundayDayCall"
        Me.colIsSundayDayCall.FieldName = "IsSundayDayCall"
        Me.colIsSundayDayCall.Name = "colIsSundayDayCall"
        '
        'colIsSundayEveCall
        '
        Me.colIsSundayEveCall.Caption = "IsSundayEveCall"
        Me.colIsSundayEveCall.FieldName = "IsSundayEveCall"
        Me.colIsSundayEveCall.Name = "colIsSundayEveCall"
        '
        'colIsCallBackOtherLang
        '
        Me.colIsCallBackOtherLang.Caption = "IsCallBackOtherLang"
        Me.colIsCallBackOtherLang.FieldName = "IsCallBackOtherLang"
        Me.colIsCallBackOtherLang.Name = "colIsCallBackOtherLang"
        '
        'colIsCallBackUsingTTY
        '
        Me.colIsCallBackUsingTTY.Caption = "IsCallBackUsingTTY"
        Me.colIsCallBackUsingTTY.FieldName = "IsCallBackUsingTTY"
        Me.colIsCallBackUsingTTY.Name = "colIsCallBackUsingTTY"
        '
        'colIsAcceptPartial
        '
        Me.colIsAcceptPartial.Caption = "IsAcceptPartial"
        Me.colIsAcceptPartial.FieldName = "IsAcceptPartial"
        Me.colIsAcceptPartial.Name = "colIsAcceptPartial"
        '
        'colIsEmailBlast
        '
        Me.colIsEmailBlast.Caption = "IsEmailBlast"
        Me.colIsEmailBlast.FieldName = "IsEmailBlast"
        Me.colIsEmailBlast.Name = "colIsEmailBlast"
        '
        'colExpireFromStepId
        '
        Me.colExpireFromStepId.Caption = "ExpireFromStepId"
        Me.colExpireFromStepId.FieldName = "ExpireFromStepId"
        Me.colExpireFromStepId.Name = "colExpireFromStepId"
        Me.colExpireFromStepId.OptionsColumn.ReadOnly = True
        '
        'colExpireFromStep
        '
        Me.colExpireFromStep.Caption = "ExpireFromStep"
        Me.colExpireFromStep.FieldName = "ExpireFromStep"
        Me.colExpireFromStep.Name = "colExpireFromStep"
        '
        'colIncludeWithPrevStep
        '
        Me.colIncludeWithPrevStep.Caption = "Include With Previous Step"
        Me.colIncludeWithPrevStep.FieldName = "IncludeWithPrevStep"
        Me.colIncludeWithPrevStep.Name = "colIncludeWithPrevStep"
        Me.colIncludeWithPrevStep.OptionsColumn.ReadOnly = True
        Me.colIncludeWithPrevStep.Visible = True
        Me.colIncludeWithPrevStep.VisibleIndex = 5
        '
        'colExpireFromStepName
        '
        Me.colExpireFromStepName.Caption = "Expire From Step"
        Me.colExpireFromStepName.FieldName = "ExpireFromStepName"
        Me.colExpireFromStepName.Name = "colExpireFromStepName"
        Me.colExpireFromStepName.OptionsColumn.ReadOnly = True
        Me.colExpireFromStepName.Visible = True
        Me.colExpireFromStepName.VisibleIndex = 8
        '
        'colVendorID
        '
        Me.colVendorID.Caption = "Vendor Name"
        Me.colVendorID.ColumnEdit = Me.VendorGridLookUpEdit
        Me.colVendorID.FieldName = "VendorID"
        Me.colVendorID.Name = "colVendorID"
        Me.colVendorID.OptionsColumn.ReadOnly = True
        Me.colVendorID.Visible = True
        Me.colVendorID.VisibleIndex = 1
        '
        'VendorGridLookUpEdit
        '
        Me.VendorGridLookUpEdit.AutoHeight = False
        Me.VendorGridLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.VendorGridLookUpEdit.DataSource = Me.VendorBindingSource
        Me.VendorGridLookUpEdit.DisplayMember = "VendorName"
        Me.VendorGridLookUpEdit.Name = "VendorGridLookUpEdit"
        Me.VendorGridLookUpEdit.NullText = ""
        Me.VendorGridLookUpEdit.ValueMember = "VendorId"
        Me.VendorGridLookUpEdit.View = Me.GridView1
        '
        'VendorBindingSource
        '
        Me.VendorBindingSource.DataSource = GetType(Nrc.QualiSys.Scanning.Library.Vendor)
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colVendorId1, Me.colVendorCode, Me.colVendorName, Me.colPhone, Me.colAddr1, Me.colAddr2, Me.colCity, Me.colStateCode, Me.colProvince, Me.colZip5, Me.colZip4, Me.colDateCreated1, Me.colDateModified, Me.colAcceptFilesFromVendor, Me.colNoResponseChar, Me.colSkipResponseChar, Me.colMultiRespItemNotPickedChar, Me.colLocalFTPLoginName})
        Me.GridView1.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'colVendorId1
        '
        Me.colVendorId1.Caption = "VendorId"
        Me.colVendorId1.FieldName = "VendorId"
        Me.colVendorId1.Name = "colVendorId1"
        Me.colVendorId1.OptionsColumn.ReadOnly = True
        '
        'colVendorCode
        '
        Me.colVendorCode.Caption = "VendorCode"
        Me.colVendorCode.FieldName = "VendorCode"
        Me.colVendorCode.Name = "colVendorCode"
        Me.colVendorCode.OptionsColumn.ReadOnly = True
        Me.colVendorCode.Visible = True
        Me.colVendorCode.VisibleIndex = 0
        '
        'colVendorName
        '
        Me.colVendorName.Caption = "VendorName"
        Me.colVendorName.FieldName = "VendorName"
        Me.colVendorName.Name = "colVendorName"
        Me.colVendorName.OptionsColumn.ReadOnly = True
        Me.colVendorName.Visible = True
        Me.colVendorName.VisibleIndex = 1
        '
        'colPhone
        '
        Me.colPhone.Caption = "Phone"
        Me.colPhone.FieldName = "Phone"
        Me.colPhone.Name = "colPhone"
        Me.colPhone.OptionsColumn.ReadOnly = True
        '
        'colAddr1
        '
        Me.colAddr1.Caption = "Addr1"
        Me.colAddr1.FieldName = "Addr1"
        Me.colAddr1.Name = "colAddr1"
        Me.colAddr1.OptionsColumn.ReadOnly = True
        '
        'colAddr2
        '
        Me.colAddr2.Caption = "Addr2"
        Me.colAddr2.FieldName = "Addr2"
        Me.colAddr2.Name = "colAddr2"
        Me.colAddr2.OptionsColumn.ReadOnly = True
        '
        'colCity
        '
        Me.colCity.Caption = "City"
        Me.colCity.FieldName = "City"
        Me.colCity.Name = "colCity"
        Me.colCity.OptionsColumn.ReadOnly = True
        '
        'colStateCode
        '
        Me.colStateCode.Caption = "StateCode"
        Me.colStateCode.FieldName = "StateCode"
        Me.colStateCode.Name = "colStateCode"
        Me.colStateCode.OptionsColumn.ReadOnly = True
        '
        'colProvince
        '
        Me.colProvince.Caption = "Province"
        Me.colProvince.FieldName = "Province"
        Me.colProvince.Name = "colProvince"
        Me.colProvince.OptionsColumn.ReadOnly = True
        '
        'colZip5
        '
        Me.colZip5.Caption = "Zip5"
        Me.colZip5.FieldName = "Zip5"
        Me.colZip5.Name = "colZip5"
        Me.colZip5.OptionsColumn.ReadOnly = True
        '
        'colZip4
        '
        Me.colZip4.Caption = "Zip4"
        Me.colZip4.FieldName = "Zip4"
        Me.colZip4.Name = "colZip4"
        Me.colZip4.OptionsColumn.ReadOnly = True
        '
        'colDateCreated1
        '
        Me.colDateCreated1.Caption = "DateCreated"
        Me.colDateCreated1.FieldName = "DateCreated"
        Me.colDateCreated1.Name = "colDateCreated1"
        Me.colDateCreated1.OptionsColumn.ReadOnly = True
        '
        'colDateModified
        '
        Me.colDateModified.Caption = "DateModified"
        Me.colDateModified.FieldName = "DateModified"
        Me.colDateModified.Name = "colDateModified"
        Me.colDateModified.OptionsColumn.ReadOnly = True
        '
        'colAcceptFilesFromVendor
        '
        Me.colAcceptFilesFromVendor.Caption = "AcceptFilesFromVendor"
        Me.colAcceptFilesFromVendor.FieldName = "AcceptFilesFromVendor"
        Me.colAcceptFilesFromVendor.Name = "colAcceptFilesFromVendor"
        Me.colAcceptFilesFromVendor.OptionsColumn.ReadOnly = True
        '
        'colNoResponseChar
        '
        Me.colNoResponseChar.Caption = "NoResponseChar"
        Me.colNoResponseChar.FieldName = "NoResponseChar"
        Me.colNoResponseChar.Name = "colNoResponseChar"
        Me.colNoResponseChar.OptionsColumn.ReadOnly = True
        '
        'colSkipResponseChar
        '
        Me.colSkipResponseChar.Caption = "SkipResponseChar"
        Me.colSkipResponseChar.FieldName = "SkipResponseChar"
        Me.colSkipResponseChar.Name = "colSkipResponseChar"
        Me.colSkipResponseChar.OptionsColumn.ReadOnly = True
        '
        'colMultiRespItemNotPickedChar
        '
        Me.colMultiRespItemNotPickedChar.Caption = "MultiRespItemNotPickedChar"
        Me.colMultiRespItemNotPickedChar.FieldName = "MultiRespItemNotPickedChar"
        Me.colMultiRespItemNotPickedChar.Name = "colMultiRespItemNotPickedChar"
        Me.colMultiRespItemNotPickedChar.OptionsColumn.ReadOnly = True
        '
        'colLocalFTPLoginName
        '
        Me.colLocalFTPLoginName.Caption = "LocalFTPLoginName"
        Me.colLocalFTPLoginName.FieldName = "LocalFTPLoginName"
        Me.colLocalFTPLoginName.Name = "colLocalFTPLoginName"
        Me.colLocalFTPLoginName.OptionsColumn.ReadOnly = True
        '
        'colVendorSurveyID
        '
        Me.colVendorSurveyID.Caption = "Vendor Survey Name"
        Me.colVendorSurveyID.ColumnEdit = Me.VendorSurveyLookUpEdit
        Me.colVendorSurveyID.FieldName = "VendorSurveyID"
        Me.colVendorSurveyID.Name = "colVendorSurveyID"
        Me.colVendorSurveyID.OptionsColumn.ReadOnly = True
        Me.colVendorSurveyID.Visible = True
        Me.colVendorSurveyID.VisibleIndex = 2
        '
        'VendorSurveyLookUpEdit
        '
        Me.VendorSurveyLookUpEdit.AutoHeight = False
        Me.VendorSurveyLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.VendorSurveyLookUpEdit.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Name", "Survey Name", 35, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near)})
        Me.VendorSurveyLookUpEdit.DataSource = Me.VendorSurveyBindingSource
        Me.VendorSurveyLookUpEdit.DisplayMember = "Name"
        Me.VendorSurveyLookUpEdit.Name = "VendorSurveyLookUpEdit"
        Me.VendorSurveyLookUpEdit.NullText = ""
        Me.VendorSurveyLookUpEdit.ValueMember = "id"
        '
        'MethStepToolStrip
        '
        Me.MethStepToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MethStepApplyTSButton, Me.MethStepUndoTSButton})
        Me.MethStepToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.MethStepToolStrip.Name = "MethStepToolStrip"
        Me.MethStepToolStrip.Size = New System.Drawing.Size(812, 25)
        Me.MethStepToolStrip.TabIndex = 5
        Me.MethStepToolStrip.Text = "ToolStrip1"
        '
        'MethStepApplyTSButton
        '
        Me.MethStepApplyTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Save16
        Me.MethStepApplyTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepApplyTSButton.Name = "MethStepApplyTSButton"
        Me.MethStepApplyTSButton.Size = New System.Drawing.Size(99, 22)
        Me.MethStepApplyTSButton.Text = "Apply Changes"
        '
        'MethStepUndoTSButton
        '
        Me.MethStepUndoTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Undo16
        Me.MethStepUndoTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepUndoTSButton.Name = "MethStepUndoTSButton"
        Me.MethStepUndoTSButton.Size = New System.Drawing.Size(97, 22)
        Me.MethStepUndoTSButton.Text = "Undo Changes"
        '
        'MethPropsSectionPanel
        '
        Me.MethPropsSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MethPropsSectionPanel.Caption = "Methodology Step Properties"
        Me.MethPropsSectionPanel.Controls.Add(Me.MethodologyPropsWebPanel)
        Me.MethPropsSectionPanel.Controls.Add(Me.MethodologyPropsIVRPanel)
        Me.MethPropsSectionPanel.Controls.Add(Me.MethodologyPropsPhonePanel)
        Me.MethPropsSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MethPropsSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.MethPropsSectionPanel.Name = "MethPropsSectionPanel"
        Me.MethPropsSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethPropsSectionPanel.ShowCaption = True
        Me.MethPropsSectionPanel.Size = New System.Drawing.Size(814, 192)
        Me.MethPropsSectionPanel.TabIndex = 8
        '
        'MethodologyPropsWebPanel
        '
        Me.MethodologyPropsWebPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebEmailBlastGridControl)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebEmailBlastCheckBox)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebQuotasGroupBox)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebDaysInFieldLabel)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebAcceptPartialCheckBox)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebDaysInFieldTextBox)
        Me.MethodologyPropsWebPanel.Enabled = False
        Me.MethodologyPropsWebPanel.Location = New System.Drawing.Point(4, 27)
        Me.MethodologyPropsWebPanel.Name = "MethodologyPropsWebPanel"
        Me.MethodologyPropsWebPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethodologyPropsWebPanel.Size = New System.Drawing.Size(806, 161)
        Me.MethodologyPropsWebPanel.TabIndex = 10
        Me.MethodologyPropsWebPanel.Visible = False
        '
        'WebEmailBlastGridControl
        '
        Me.WebEmailBlastGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WebEmailBlastGridControl.DataSource = Me.EmailBlastBindingSource
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.EndEdit.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.First.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.Last.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.Next.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.NextPage.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.Prev.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.PrevPage.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Name = ""
        Me.WebEmailBlastGridControl.EmbeddedNavigator.TextStringFormat = ""
        Me.WebEmailBlastGridControl.Enabled = False
        Me.WebEmailBlastGridControl.Location = New System.Drawing.Point(388, 35)
        Me.WebEmailBlastGridControl.MainView = Me.WebEmailBlastGridView
        Me.WebEmailBlastGridControl.Name = "WebEmailBlastGridControl"
        Me.WebEmailBlastGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.EmailBlastNameComboBox, Me.EmailBlastNameGridLookUpEdit, Me.DaysFromStepGenTextEdit, Me.EmailBlastNameLookUpEdit})
        Me.WebEmailBlastGridControl.Size = New System.Drawing.Size(414, 122)
        Me.WebEmailBlastGridControl.TabIndex = 15
        Me.WebEmailBlastGridControl.UseEmbeddedNavigator = True
        Me.WebEmailBlastGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.WebEmailBlastGridView})
        '
        'EmailBlastBindingSource
        '
        Me.EmailBlastBindingSource.AllowNew = False
        Me.EmailBlastBindingSource.DataSource = GetType(Nrc.QualiSys.Library.EmailBlast)
        '
        'WebEmailBlastGridView
        '
        Me.WebEmailBlastGridView.ActiveFilterEnabled = False
        Me.WebEmailBlastGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colEmailBlastId, Me.colDaysFromStepGen})
        Me.WebEmailBlastGridView.GridControl = Me.WebEmailBlastGridControl
        Me.WebEmailBlastGridView.Name = "WebEmailBlastGridView"
        Me.WebEmailBlastGridView.NewItemRowText = "Click Here to Add a New Email Blast Record"
        Me.WebEmailBlastGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.WebEmailBlastGridView.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        Me.WebEmailBlastGridView.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.WebEmailBlastGridView.OptionsView.ShowGroupPanel = False
        Me.WebEmailBlastGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colDaysFromStepGen, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colEmailBlastId
        '
        Me.colEmailBlastId.Caption = "Blast Name"
        Me.colEmailBlastId.ColumnEdit = Me.EmailBlastNameLookUpEdit
        Me.colEmailBlastId.FieldName = "EmailBlastId"
        Me.colEmailBlastId.Name = "colEmailBlastId"
        Me.colEmailBlastId.Visible = True
        Me.colEmailBlastId.VisibleIndex = 0
        '
        'EmailBlastNameLookUpEdit
        '
        Me.EmailBlastNameLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.EmailBlastNameLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.EmailBlastNameLookUpEdit.DataSource = Me.EmailBlastOptionBindingSource
        Me.EmailBlastNameLookUpEdit.DisplayMember = "Value"
        Me.EmailBlastNameLookUpEdit.Name = "EmailBlastNameLookUpEdit"
        Me.EmailBlastNameLookUpEdit.NullText = ""
        Me.EmailBlastNameLookUpEdit.ValueMember = "EmailBlastId"
        '
        'EmailBlastOptionBindingSource
        '
        Me.EmailBlastOptionBindingSource.AllowNew = False
        Me.EmailBlastOptionBindingSource.DataSource = GetType(Nrc.QualiSys.Library.EmailBlastOption)
        '
        'colDaysFromStepGen
        '
        Me.colDaysFromStepGen.Caption = "Days From Step Gen"
        Me.colDaysFromStepGen.ColumnEdit = Me.DaysFromStepGenTextEdit
        Me.colDaysFromStepGen.FieldName = "DaysFromStepGen"
        Me.colDaysFromStepGen.Name = "colDaysFromStepGen"
        Me.colDaysFromStepGen.SortMode = DevExpress.XtraGrid.ColumnSortMode.Value
        Me.colDaysFromStepGen.Visible = True
        Me.colDaysFromStepGen.VisibleIndex = 1
        '
        'DaysFromStepGenTextEdit
        '
        Me.DaysFromStepGenTextEdit.AutoHeight = False
        Me.DaysFromStepGenTextEdit.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric
        Me.DaysFromStepGenTextEdit.Name = "DaysFromStepGenTextEdit"
        '
        'EmailBlastNameComboBox
        '
        Me.EmailBlastNameComboBox.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.EmailBlastNameComboBox.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.EmailBlastNameComboBox.Name = "EmailBlastNameComboBox"
        '
        'EmailBlastNameGridLookUpEdit
        '
        Me.EmailBlastNameGridLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.EmailBlastNameGridLookUpEdit.DisplayMember = "Value"
        Me.EmailBlastNameGridLookUpEdit.Name = "EmailBlastNameGridLookUpEdit"
        Me.EmailBlastNameGridLookUpEdit.ValueMember = "EmailBlastId"
        Me.EmailBlastNameGridLookUpEdit.View = Me.RepositoryItemGridLookUpEdit1View
        '
        'RepositoryItemGridLookUpEdit1View
        '
        Me.RepositoryItemGridLookUpEdit1View.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.RepositoryItemGridLookUpEdit1View.Name = "RepositoryItemGridLookUpEdit1View"
        Me.RepositoryItemGridLookUpEdit1View.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.RepositoryItemGridLookUpEdit1View.OptionsView.ShowGroupPanel = False
        '
        'WebEmailBlastCheckBox
        '
        Me.WebEmailBlastCheckBox.AutoSize = True
        Me.WebEmailBlastCheckBox.Location = New System.Drawing.Point(388, 9)
        Me.WebEmailBlastCheckBox.Name = "WebEmailBlastCheckBox"
        Me.WebEmailBlastCheckBox.Size = New System.Drawing.Size(77, 17)
        Me.WebEmailBlastCheckBox.TabIndex = 4
        Me.WebEmailBlastCheckBox.Text = "Email Blast"
        Me.WebEmailBlastCheckBox.UseVisualStyleBackColor = True
        '
        'WebQuotasGroupBox
        '
        Me.WebQuotasGroupBox.Controls.Add(Me.WebReturnsLabel)
        Me.WebQuotasGroupBox.Controls.Add(Me.WebQuotasStopReturnsTextBox)
        Me.WebQuotasGroupBox.Controls.Add(Me.WebQuotasStopReturnsRadioButton)
        Me.WebQuotasGroupBox.Controls.Add(Me.WebQuotasAllReturnsRadioButton)
        Me.WebQuotasGroupBox.Location = New System.Drawing.Point(31, 57)
        Me.WebQuotasGroupBox.Name = "WebQuotasGroupBox"
        Me.WebQuotasGroupBox.Size = New System.Drawing.Size(304, 64)
        Me.WebQuotasGroupBox.TabIndex = 3
        Me.WebQuotasGroupBox.TabStop = False
        Me.WebQuotasGroupBox.Text = "Quotas"
        '
        'WebReturnsLabel
        '
        Me.WebReturnsLabel.AutoSize = True
        Me.WebReturnsLabel.Location = New System.Drawing.Point(176, 43)
        Me.WebReturnsLabel.Name = "WebReturnsLabel"
        Me.WebReturnsLabel.Size = New System.Drawing.Size(101, 13)
        Me.WebReturnsLabel.TabIndex = 3
        Me.WebReturnsLabel.Text = "Returns Per Sample"
        '
        'WebQuotasStopReturnsTextBox
        '
        Me.WebQuotasStopReturnsTextBox.Enabled = False
        Me.WebQuotasStopReturnsTextBox.Location = New System.Drawing.Point(130, 37)
        Me.WebQuotasStopReturnsTextBox.Name = "WebQuotasStopReturnsTextBox"
        Me.WebQuotasStopReturnsTextBox.Size = New System.Drawing.Size(43, 20)
        Me.WebQuotasStopReturnsTextBox.TabIndex = 2
        '
        'WebQuotasStopReturnsRadioButton
        '
        Me.WebQuotasStopReturnsRadioButton.AutoSize = True
        Me.WebQuotasStopReturnsRadioButton.Location = New System.Drawing.Point(20, 41)
        Me.WebQuotasStopReturnsRadioButton.Name = "WebQuotasStopReturnsRadioButton"
        Me.WebQuotasStopReturnsRadioButton.Size = New System.Drawing.Size(109, 17)
        Me.WebQuotasStopReturnsRadioButton.TabIndex = 1
        Me.WebQuotasStopReturnsRadioButton.Text = "Stop Collection At"
        Me.WebQuotasStopReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'WebQuotasAllReturnsRadioButton
        '
        Me.WebQuotasAllReturnsRadioButton.AutoSize = True
        Me.WebQuotasAllReturnsRadioButton.Checked = True
        Me.WebQuotasAllReturnsRadioButton.Location = New System.Drawing.Point(20, 20)
        Me.WebQuotasAllReturnsRadioButton.Name = "WebQuotasAllReturnsRadioButton"
        Me.WebQuotasAllReturnsRadioButton.Size = New System.Drawing.Size(113, 17)
        Me.WebQuotasAllReturnsRadioButton.TabIndex = 0
        Me.WebQuotasAllReturnsRadioButton.TabStop = True
        Me.WebQuotasAllReturnsRadioButton.Text = "Accept All Returns"
        Me.WebQuotasAllReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'WebDaysInFieldLabel
        '
        Me.WebDaysInFieldLabel.AutoSize = True
        Me.WebDaysInFieldLabel.Location = New System.Drawing.Point(29, 11)
        Me.WebDaysInFieldLabel.Name = "WebDaysInFieldLabel"
        Me.WebDaysInFieldLabel.Size = New System.Drawing.Size(68, 13)
        Me.WebDaysInFieldLabel.TabIndex = 2
        Me.WebDaysInFieldLabel.Text = "Days In Field"
        Me.WebDaysInFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'WebAcceptPartialCheckBox
        '
        Me.WebAcceptPartialCheckBox.AutoSize = True
        Me.WebAcceptPartialCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.WebAcceptPartialCheckBox.Location = New System.Drawing.Point(27, 35)
        Me.WebAcceptPartialCheckBox.Name = "WebAcceptPartialCheckBox"
        Me.WebAcceptPartialCheckBox.Size = New System.Drawing.Size(92, 17)
        Me.WebAcceptPartialCheckBox.TabIndex = 1
        Me.WebAcceptPartialCheckBox.Text = "Accept Partial"
        Me.WebAcceptPartialCheckBox.UseVisualStyleBackColor = True
        '
        'WebDaysInFieldTextBox
        '
        Me.WebDaysInFieldTextBox.Location = New System.Drawing.Point(104, 7)
        Me.WebDaysInFieldTextBox.Name = "WebDaysInFieldTextBox"
        Me.WebDaysInFieldTextBox.Size = New System.Drawing.Size(64, 20)
        Me.WebDaysInFieldTextBox.TabIndex = 0
        '
        'MethodologyPropsIVRPanel
        '
        Me.MethodologyPropsIVRPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethodologyPropsIVRPanel.Controls.Add(Me.IVRDaysInFieldLabel)
        Me.MethodologyPropsIVRPanel.Controls.Add(Me.IVRAcceptPartialCheckBox)
        Me.MethodologyPropsIVRPanel.Controls.Add(Me.IVRDaysInFieldTextBox)
        Me.MethodologyPropsIVRPanel.Enabled = False
        Me.MethodologyPropsIVRPanel.Location = New System.Drawing.Point(4, 27)
        Me.MethodologyPropsIVRPanel.Name = "MethodologyPropsIVRPanel"
        Me.MethodologyPropsIVRPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethodologyPropsIVRPanel.Size = New System.Drawing.Size(806, 161)
        Me.MethodologyPropsIVRPanel.TabIndex = 7
        Me.MethodologyPropsIVRPanel.Visible = False
        '
        'IVRDaysInFieldLabel
        '
        Me.IVRDaysInFieldLabel.AutoSize = True
        Me.IVRDaysInFieldLabel.Location = New System.Drawing.Point(29, 15)
        Me.IVRDaysInFieldLabel.Name = "IVRDaysInFieldLabel"
        Me.IVRDaysInFieldLabel.Size = New System.Drawing.Size(68, 13)
        Me.IVRDaysInFieldLabel.TabIndex = 2
        Me.IVRDaysInFieldLabel.Text = "Days In Field"
        Me.IVRDaysInFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'IVRAcceptPartialCheckBox
        '
        Me.IVRAcceptPartialCheckBox.AutoSize = True
        Me.IVRAcceptPartialCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.IVRAcceptPartialCheckBox.Location = New System.Drawing.Point(27, 39)
        Me.IVRAcceptPartialCheckBox.Name = "IVRAcceptPartialCheckBox"
        Me.IVRAcceptPartialCheckBox.Size = New System.Drawing.Size(92, 17)
        Me.IVRAcceptPartialCheckBox.TabIndex = 1
        Me.IVRAcceptPartialCheckBox.Text = "Accept Partial"
        Me.IVRAcceptPartialCheckBox.UseVisualStyleBackColor = True
        '
        'IVRDaysInFieldTextBox
        '
        Me.IVRDaysInFieldTextBox.Location = New System.Drawing.Point(104, 11)
        Me.IVRDaysInFieldTextBox.Name = "IVRDaysInFieldTextBox"
        Me.IVRDaysInFieldTextBox.Size = New System.Drawing.Size(64, 20)
        Me.IVRDaysInFieldTextBox.TabIndex = 0
        '
        'MethodologyPropsPhonePanel
        '
        Me.MethodologyPropsPhonePanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneEveningSunCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaySunCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneEveningSatCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaySatCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneSundayLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneSaturdayLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneMFLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneEveningMFCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneNumberOfAttemptsLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneNumberOfAttemptsTextBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneTTYCallbackCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneLangCallbackCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneQuotasGroupBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaysInFieldLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDayMFCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaysInFieldTextBox)
        Me.MethodologyPropsPhonePanel.Enabled = False
        Me.MethodologyPropsPhonePanel.Location = New System.Drawing.Point(4, 27)
        Me.MethodologyPropsPhonePanel.Name = "MethodologyPropsPhonePanel"
        Me.MethodologyPropsPhonePanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethodologyPropsPhonePanel.Size = New System.Drawing.Size(806, 161)
        Me.MethodologyPropsPhonePanel.TabIndex = 12
        Me.MethodologyPropsPhonePanel.Visible = False
        '
        'PhoneEveningSunCheckBox
        '
        Me.PhoneEveningSunCheckBox.AutoSize = True
        Me.PhoneEveningSunCheckBox.Location = New System.Drawing.Point(205, 97)
        Me.PhoneEveningSunCheckBox.Name = "PhoneEveningSunCheckBox"
        Me.PhoneEveningSunCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneEveningSunCheckBox.TabIndex = 7
        Me.PhoneEveningSunCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneDaySunCheckBox
        '
        Me.PhoneDaySunCheckBox.AutoSize = True
        Me.PhoneDaySunCheckBox.Location = New System.Drawing.Point(205, 78)
        Me.PhoneDaySunCheckBox.Name = "PhoneDaySunCheckBox"
        Me.PhoneDaySunCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneDaySunCheckBox.TabIndex = 4
        Me.PhoneDaySunCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneEveningSatCheckBox
        '
        Me.PhoneEveningSatCheckBox.AutoSize = True
        Me.PhoneEveningSatCheckBox.Location = New System.Drawing.Point(182, 97)
        Me.PhoneEveningSatCheckBox.Name = "PhoneEveningSatCheckBox"
        Me.PhoneEveningSatCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneEveningSatCheckBox.TabIndex = 6
        Me.PhoneEveningSatCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneDaySatCheckBox
        '
        Me.PhoneDaySatCheckBox.AutoSize = True
        Me.PhoneDaySatCheckBox.Location = New System.Drawing.Point(182, 78)
        Me.PhoneDaySatCheckBox.Name = "PhoneDaySatCheckBox"
        Me.PhoneDaySatCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneDaySatCheckBox.TabIndex = 3
        Me.PhoneDaySatCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneSundayLabel
        '
        Me.PhoneSundayLabel.AutoSize = True
        Me.PhoneSundayLabel.Location = New System.Drawing.Point(204, 62)
        Me.PhoneSundayLabel.Name = "PhoneSundayLabel"
        Me.PhoneSundayLabel.Size = New System.Drawing.Size(26, 13)
        Me.PhoneSundayLabel.TabIndex = 21
        Me.PhoneSundayLabel.Text = "Sun"
        '
        'PhoneSaturdayLabel
        '
        Me.PhoneSaturdayLabel.AutoSize = True
        Me.PhoneSaturdayLabel.Location = New System.Drawing.Point(181, 62)
        Me.PhoneSaturdayLabel.Name = "PhoneSaturdayLabel"
        Me.PhoneSaturdayLabel.Size = New System.Drawing.Size(23, 13)
        Me.PhoneSaturdayLabel.TabIndex = 20
        Me.PhoneSaturdayLabel.Text = "Sat"
        '
        'PhoneMFLabel
        '
        Me.PhoneMFLabel.AutoSize = True
        Me.PhoneMFLabel.Location = New System.Drawing.Point(148, 62)
        Me.PhoneMFLabel.Name = "PhoneMFLabel"
        Me.PhoneMFLabel.Size = New System.Drawing.Size(31, 13)
        Me.PhoneMFLabel.TabIndex = 19
        Me.PhoneMFLabel.Text = "M - F"
        '
        'PhoneEveningMFCheckBox
        '
        Me.PhoneEveningMFCheckBox.AutoSize = True
        Me.PhoneEveningMFCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.PhoneEveningMFCheckBox.Location = New System.Drawing.Point(9, 96)
        Me.PhoneEveningMFCheckBox.Name = "PhoneEveningMFCheckBox"
        Me.PhoneEveningMFCheckBox.Size = New System.Drawing.Size(163, 17)
        Me.PhoneEveningMFCheckBox.TabIndex = 5
        Me.PhoneEveningMFCheckBox.Text = "Evening (5:00 PM - 9:00 PM)"
        Me.PhoneEveningMFCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneNumberOfAttemptsLabel
        '
        Me.PhoneNumberOfAttemptsLabel.AutoSize = True
        Me.PhoneNumberOfAttemptsLabel.Location = New System.Drawing.Point(29, 38)
        Me.PhoneNumberOfAttemptsLabel.Name = "PhoneNumberOfAttemptsLabel"
        Me.PhoneNumberOfAttemptsLabel.Size = New System.Drawing.Size(102, 13)
        Me.PhoneNumberOfAttemptsLabel.TabIndex = 17
        Me.PhoneNumberOfAttemptsLabel.Text = "Number Of Attempts"
        Me.PhoneNumberOfAttemptsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PhoneNumberOfAttemptsTextBox
        '
        Me.PhoneNumberOfAttemptsTextBox.Location = New System.Drawing.Point(156, 33)
        Me.PhoneNumberOfAttemptsTextBox.Name = "PhoneNumberOfAttemptsTextBox"
        Me.PhoneNumberOfAttemptsTextBox.Size = New System.Drawing.Size(64, 20)
        Me.PhoneNumberOfAttemptsTextBox.TabIndex = 1
        '
        'PhoneTTYCallbackCheckBox
        '
        Me.PhoneTTYCallbackCheckBox.AutoSize = True
        Me.PhoneTTYCallbackCheckBox.Location = New System.Drawing.Point(308, 96)
        Me.PhoneTTYCallbackCheckBox.Name = "PhoneTTYCallbackCheckBox"
        Me.PhoneTTYCallbackCheckBox.Size = New System.Drawing.Size(210, 17)
        Me.PhoneTTYCallbackCheckBox.TabIndex = 10
        Me.PhoneTTYCallbackCheckBox.Text = "Callback Using TTY (Hearing Impaired)"
        Me.PhoneTTYCallbackCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneLangCallbackCheckBox
        '
        Me.PhoneLangCallbackCheckBox.AutoSize = True
        Me.PhoneLangCallbackCheckBox.Location = New System.Drawing.Point(308, 77)
        Me.PhoneLangCallbackCheckBox.Name = "PhoneLangCallbackCheckBox"
        Me.PhoneLangCallbackCheckBox.Size = New System.Drawing.Size(159, 17)
        Me.PhoneLangCallbackCheckBox.TabIndex = 9
        Me.PhoneLangCallbackCheckBox.Text = "Callback In Other Language"
        Me.PhoneLangCallbackCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneQuotasGroupBox
        '
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneReturnsLabel)
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneQuotasStopReturnsTextBox)
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneQuotasStopReturnsRadioButton)
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneQuotasAllReturnsRadioButton)
        Me.PhoneQuotasGroupBox.Location = New System.Drawing.Point(288, 3)
        Me.PhoneQuotasGroupBox.Name = "PhoneQuotasGroupBox"
        Me.PhoneQuotasGroupBox.Size = New System.Drawing.Size(304, 64)
        Me.PhoneQuotasGroupBox.TabIndex = 8
        Me.PhoneQuotasGroupBox.TabStop = False
        Me.PhoneQuotasGroupBox.Text = "Quotas"
        '
        'PhoneReturnsLabel
        '
        Me.PhoneReturnsLabel.AutoSize = True
        Me.PhoneReturnsLabel.Location = New System.Drawing.Point(176, 43)
        Me.PhoneReturnsLabel.Name = "PhoneReturnsLabel"
        Me.PhoneReturnsLabel.Size = New System.Drawing.Size(101, 13)
        Me.PhoneReturnsLabel.TabIndex = 3
        Me.PhoneReturnsLabel.Text = "Returns Per Sample"
        '
        'PhoneQuotasStopReturnsTextBox
        '
        Me.PhoneQuotasStopReturnsTextBox.Enabled = False
        Me.PhoneQuotasStopReturnsTextBox.Location = New System.Drawing.Point(130, 37)
        Me.PhoneQuotasStopReturnsTextBox.Name = "PhoneQuotasStopReturnsTextBox"
        Me.PhoneQuotasStopReturnsTextBox.Size = New System.Drawing.Size(43, 20)
        Me.PhoneQuotasStopReturnsTextBox.TabIndex = 2
        '
        'PhoneQuotasStopReturnsRadioButton
        '
        Me.PhoneQuotasStopReturnsRadioButton.AutoSize = True
        Me.PhoneQuotasStopReturnsRadioButton.Location = New System.Drawing.Point(20, 41)
        Me.PhoneQuotasStopReturnsRadioButton.Name = "PhoneQuotasStopReturnsRadioButton"
        Me.PhoneQuotasStopReturnsRadioButton.Size = New System.Drawing.Size(109, 17)
        Me.PhoneQuotasStopReturnsRadioButton.TabIndex = 1
        Me.PhoneQuotasStopReturnsRadioButton.Text = "Stop Collection At"
        Me.PhoneQuotasStopReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'PhoneQuotasAllReturnsRadioButton
        '
        Me.PhoneQuotasAllReturnsRadioButton.AutoSize = True
        Me.PhoneQuotasAllReturnsRadioButton.Checked = True
        Me.PhoneQuotasAllReturnsRadioButton.Location = New System.Drawing.Point(20, 20)
        Me.PhoneQuotasAllReturnsRadioButton.Name = "PhoneQuotasAllReturnsRadioButton"
        Me.PhoneQuotasAllReturnsRadioButton.Size = New System.Drawing.Size(113, 17)
        Me.PhoneQuotasAllReturnsRadioButton.TabIndex = 0
        Me.PhoneQuotasAllReturnsRadioButton.TabStop = True
        Me.PhoneQuotasAllReturnsRadioButton.Text = "Accept All Returns"
        Me.PhoneQuotasAllReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'PhoneDaysInFieldLabel
        '
        Me.PhoneDaysInFieldLabel.AutoSize = True
        Me.PhoneDaysInFieldLabel.Location = New System.Drawing.Point(29, 11)
        Me.PhoneDaysInFieldLabel.Name = "PhoneDaysInFieldLabel"
        Me.PhoneDaysInFieldLabel.Size = New System.Drawing.Size(68, 13)
        Me.PhoneDaysInFieldLabel.TabIndex = 2
        Me.PhoneDaysInFieldLabel.Text = "Days In Field"
        Me.PhoneDaysInFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PhoneDayMFCheckBox
        '
        Me.PhoneDayMFCheckBox.AutoSize = True
        Me.PhoneDayMFCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.PhoneDayMFCheckBox.Location = New System.Drawing.Point(27, 77)
        Me.PhoneDayMFCheckBox.Name = "PhoneDayMFCheckBox"
        Me.PhoneDayMFCheckBox.Size = New System.Drawing.Size(143, 17)
        Me.PhoneDayMFCheckBox.TabIndex = 2
        Me.PhoneDayMFCheckBox.Text = "Day (9:00 AM - 5:00 PM)"
        Me.PhoneDayMFCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneDaysInFieldTextBox
        '
        Me.PhoneDaysInFieldTextBox.Location = New System.Drawing.Point(156, 7)
        Me.PhoneDaysInFieldTextBox.Name = "PhoneDaysInFieldTextBox"
        Me.PhoneDaysInFieldTextBox.Size = New System.Drawing.Size(64, 20)
        Me.PhoneDaysInFieldTextBox.TabIndex = 0
        '
        'GridColumn1
        '
        Me.GridColumn1.Caption = "GridColumn1"
        Me.GridColumn1.Name = "GridColumn1"
        Me.GridColumn1.Visible = True
        Me.GridColumn1.VisibleIndex = 0
        '
        'GridColumn2
        '
        Me.GridColumn2.Caption = "GridColumn2"
        Me.GridColumn2.Name = "GridColumn2"
        Me.GridColumn2.Visible = True
        Me.GridColumn2.VisibleIndex = 1
        '
        'GridColumn3
        '
        Me.GridColumn3.Caption = "GridColumn3"
        Me.GridColumn3.Name = "GridColumn3"
        Me.GridColumn3.Visible = True
        Me.GridColumn3.VisibleIndex = 2
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(730, 5)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'SurveyVendorSection
        '
        Me.Controls.Add(Me.SplitContainer1)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "SurveyVendorSection"
        Me.Size = New System.Drawing.Size(814, 691)
        Me.BottomPanel.ResumeLayout(False)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.MethSectionPanel.ResumeLayout(False)
        Me.MethSectionPanel.PerformLayout()
        CType(Me.MethGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MethBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MethGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemLookUpEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.StandardMethBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MethToolStrip.ResumeLayout(False)
        Me.MethToolStrip.PerformLayout()
        Me.SplitContainer2.Panel1.ResumeLayout(False)
        Me.SplitContainer2.Panel2.ResumeLayout(False)
        Me.SplitContainer2.ResumeLayout(False)
        Me.MethStepSectionPanel.ResumeLayout(False)
        Me.MethStepSectionPanel.PerformLayout()
        CType(Me.MethStepGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MethStepBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MethStepGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemLookUpEdit2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CoverLetterBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemLookUpEdit3, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.LanguageBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorGridLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorSurveyLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorSurveyBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MethStepToolStrip.ResumeLayout(False)
        Me.MethStepToolStrip.PerformLayout()
        Me.MethPropsSectionPanel.ResumeLayout(False)
        Me.MethodologyPropsWebPanel.ResumeLayout(False)
        Me.MethodologyPropsWebPanel.PerformLayout()
        CType(Me.WebEmailBlastGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.WebEmailBlastGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastNameLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastOptionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DaysFromStepGenTextEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastNameComboBox, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastNameGridLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemGridLookUpEdit1View, System.ComponentModel.ISupportInitialize).EndInit()
        Me.WebQuotasGroupBox.ResumeLayout(False)
        Me.WebQuotasGroupBox.PerformLayout()
        Me.MethodologyPropsIVRPanel.ResumeLayout(False)
        Me.MethodologyPropsIVRPanel.PerformLayout()
        Me.MethodologyPropsPhonePanel.ResumeLayout(False)
        Me.MethodologyPropsPhonePanel.PerformLayout()
        Me.PhoneQuotasGroupBox.ResumeLayout(False)
        Me.PhoneQuotasGroupBox.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents SplitContainer2 As System.Windows.Forms.SplitContainer
    Friend WithEvents MethSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MethToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents MethEditTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethStepSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MethStepToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents MethStepApplyTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethStepUndoTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents MethGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents MethStepGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents MethStepGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents MethBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents MethStepBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurveyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStandardMethodologyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAllowEdit As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAllowDelete As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsCustomizable As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStandardMethodology As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsDirty As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsNew As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurvey As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colId1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMethodologyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSurveyId1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSequenceNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCoverLetterId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDaysSincePreviousStep As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSurvey As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsThankYouLetter As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsFirstSurvey As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOverrideLanguageId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colLinkedStepId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colLinkedStep As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStepMethodId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExpirationDays As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colQuotaID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colQuotaIDAllReturns As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colQuotaIDStopReturns As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colQuotaStopCollectionAt As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDaysInField As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNumberOfAttempts As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsWeekDayDayCall As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsWeekDayEveCall As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSaturdayDayCall As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSaturdayEveCall As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSundayDayCall As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSundayEveCall As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsCallBackOtherLang As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsCallBackUsingTTY As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsAcceptPartial As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsEmailBlast As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExpireFromStepId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExpireFromStep As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents StandardMethBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents RepositoryItemLookUpEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents CoverLetterBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents LanguageBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents RepositoryItemLookUpEdit2 As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents RepositoryItemLookUpEdit3 As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents MethPropsSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MethodologyPropsWebPanel As System.Windows.Forms.Panel
    Friend WithEvents WebEmailBlastGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents WebEmailBlastGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colEmailBlastId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents EmailBlastNameLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents colDaysFromStepGen As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents DaysFromStepGenTextEdit As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
    Friend WithEvents EmailBlastNameComboBox As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents EmailBlastNameGridLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
    Friend WithEvents RepositoryItemGridLookUpEdit1View As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents WebEmailBlastCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents WebQuotasGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents WebReturnsLabel As System.Windows.Forms.Label
    Friend WithEvents WebQuotasStopReturnsTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WebQuotasStopReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents WebQuotasAllReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents WebDaysInFieldLabel As System.Windows.Forms.Label
    Friend WithEvents WebAcceptPartialCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents WebDaysInFieldTextBox As System.Windows.Forms.TextBox
    Friend WithEvents MethodologyPropsIVRPanel As System.Windows.Forms.Panel
    Friend WithEvents IVRDaysInFieldLabel As System.Windows.Forms.Label
    Friend WithEvents IVRAcceptPartialCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents IVRDaysInFieldTextBox As System.Windows.Forms.TextBox
    Friend WithEvents MethodologyPropsPhonePanel As System.Windows.Forms.Panel
    Friend WithEvents PhoneEveningSunCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneDaySunCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneEveningSatCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneDaySatCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneSundayLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneSaturdayLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneMFLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneEveningMFCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneNumberOfAttemptsLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneNumberOfAttemptsTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PhoneTTYCallbackCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneLangCallbackCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneQuotasGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents PhoneReturnsLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneQuotasStopReturnsTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PhoneQuotasStopReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents PhoneQuotasAllReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents PhoneDaysInFieldLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneDayMFCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneDaysInFieldTextBox As System.Windows.Forms.TextBox
    Friend WithEvents EmailBlastBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents EmailBlastOptionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colIncludeWithPrevStep As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExpireFromStepName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents VendorBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colVendorID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents VendorGridLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridColumn1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn3 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorId1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorCode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPhone As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAddr1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAddr2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCity As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStateCode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colProvince As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colZip5 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colZip4 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateModified As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAcceptFilesFromVendor As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNoResponseChar As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSkipResponseChar As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMultiRespItemNotPickedChar As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colLocalFTPLoginName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorSurveyID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents VendorSurveyLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents VendorSurveyBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents CancelButton As System.Windows.Forms.Button

End Class
