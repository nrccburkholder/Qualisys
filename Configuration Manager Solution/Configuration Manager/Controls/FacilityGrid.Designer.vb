<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FacilityGrid
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.MedicareNumberBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.FacilityRegionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.FacilityStateBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.FacilityBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.FacilitiesGrid = New DevExpress.XtraGrid.GridControl
        Me.FacilityGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFacilityName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFacilityMedicareNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.MedicareNumberGridLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colMedicareNumberLookup = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNameLookup = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCity = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colState = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FacilityStateGridLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
        Me.RepositoryItemGridLookUpEdit1View = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colStateName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAbbreviation1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colRegionId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FacilityRegionLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.colCountry = New DevExpress.XtraGrid.Columns.GridColumn
        Me.CountryComboBox = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.colAhaId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAdmitNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colBedSize = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsCancerCenter = New DevExpress.XtraGrid.Columns.GridColumn
        Me.TriStateComboBoxEdit = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.colIsForProfit = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsFreeStanding = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsGovernment = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsPediatric = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsPicker = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsRehab = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsReligious = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsRural = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsTrauma = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsTeaching = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAbbreviation = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPENumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.PENumberLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        CType(Me.MedicareNumberBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilityRegionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilityStateBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilityBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilitiesGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilityGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MedicareNumberGridLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilityStateGridLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemGridLookUpEdit1View, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FacilityRegionLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CountryComboBox, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.TriStateComboBoxEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PENumberLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MedicareNumberBindingSource
        '
        Me.MedicareNumberBindingSource.DataSource = GetType(Nrc.Qualisys.Library.MedicareNumber)
        '
        'FacilityRegionBindingSource
        '
        Me.FacilityRegionBindingSource.DataSource = GetType(Nrc.Qualisys.Library.FacilityRegion)
        '
        'FacilityStateBindingSource
        '
        Me.FacilityStateBindingSource.DataSource = GetType(Nrc.Qualisys.Library.FacilityState)
        '
        'FacilityBindingSource
        '
        Me.FacilityBindingSource.DataSource = GetType(Nrc.Qualisys.Library.Facility)
        '
        'FacilitiesGrid
        '
        Me.FacilitiesGrid.DataSource = Me.FacilityBindingSource
        Me.FacilitiesGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FacilitiesGrid.EmbeddedNavigator.Name = ""
        Me.FacilitiesGrid.Location = New System.Drawing.Point(0, 0)
        Me.FacilitiesGrid.MainView = Me.FacilityGridView
        Me.FacilitiesGrid.Name = "FacilitiesGrid"
        Me.FacilitiesGrid.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.TriStateComboBoxEdit, Me.MedicareNumberGridLookUpEdit, Me.FacilityRegionLookUpEdit, Me.FacilityStateGridLookUpEdit, Me.CountryComboBox, Me.PENumberLookUpEdit})
        Me.FacilitiesGrid.Size = New System.Drawing.Size(547, 498)
        Me.FacilitiesGrid.TabIndex = 1
        Me.FacilitiesGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.FacilityGridView})
        '
        'FacilityGridView
        '
        Me.FacilityGridView.ActiveFilterEnabled = False
        Me.FacilityGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFacilityName, Me.colFacilityMedicareNumber, Me.colPENumber, Me.colCity, Me.colState, Me.colRegionId, Me.colCountry, Me.colAhaId, Me.colAdmitNumber, Me.colBedSize, Me.colIsCancerCenter, Me.colIsForProfit, Me.colIsFreeStanding, Me.colIsGovernment, Me.colIsPediatric, Me.colIsPicker, Me.colIsRehab, Me.colIsReligious, Me.colIsRural, Me.colIsTrauma, Me.colIsTeaching})
        Me.FacilityGridView.GridControl = Me.FacilitiesGrid
        Me.FacilityGridView.HorzScrollVisibility = DevExpress.XtraGrid.Views.Base.ScrollVisibility.Always
        Me.FacilityGridView.Name = "FacilityGridView"
        Me.FacilityGridView.NewItemRowText = "Click Here to Add a New Facility"
        Me.FacilityGridView.OptionsView.ColumnAutoWidth = False
        Me.FacilityGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.FacilityGridView.OptionsView.ShowAutoFilterRow = True
        Me.FacilityGridView.OptionsView.ShowGroupPanel = False
        Me.FacilityGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colFacilityName, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colFacilityName
        '
        Me.colFacilityName.Caption = "Name"
        Me.colFacilityName.FieldName = "Name"
        Me.colFacilityName.Name = "colFacilityName"
        Me.colFacilityName.Visible = True
        Me.colFacilityName.VisibleIndex = 0
        Me.colFacilityName.Width = 170
        '
        'colFacilityMedicareNumber
        '
        Me.colFacilityMedicareNumber.Caption = "Medicare Number"
        Me.colFacilityMedicareNumber.ColumnEdit = Me.MedicareNumberGridLookUpEdit
        Me.colFacilityMedicareNumber.FieldName = "MedicareNumber"
        Me.colFacilityMedicareNumber.Name = "colFacilityMedicareNumber"
        Me.colFacilityMedicareNumber.Visible = True
        Me.colFacilityMedicareNumber.VisibleIndex = 1
        Me.colFacilityMedicareNumber.Width = 104
        '
        'MedicareNumberGridLookUpEdit
        '
        Me.MedicareNumberGridLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[True]
        Me.MedicareNumberGridLookUpEdit.AutoHeight = False
        Me.MedicareNumberGridLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo), New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Delete, "Delete Previous Selection")})
        Me.MedicareNumberGridLookUpEdit.DataSource = Me.MedicareNumberBindingSource
        Me.MedicareNumberGridLookUpEdit.DisplayMember = "MedicareNumber"
        Me.MedicareNumberGridLookUpEdit.Name = "MedicareNumberGridLookUpEdit"
        Me.MedicareNumberGridLookUpEdit.NullText = ""
        Me.MedicareNumberGridLookUpEdit.PopupFormWidth = 450
        Me.MedicareNumberGridLookUpEdit.View = Me.GridView1
        '
        'GridView1
        '
        Me.GridView1.BestFitMaxRowCount = 100
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colMedicareNumberLookup, Me.colNameLookup})
        Me.GridView1.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.GridView1.OptionsView.ColumnAutoWidth = False
        Me.GridView1.OptionsView.ShowAutoFilterRow = True
        Me.GridView1.OptionsView.ShowGroupPanel = False
        Me.GridView1.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colMedicareNumberLookup, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colMedicareNumberLookup
        '
        Me.colMedicareNumberLookup.Caption = "Medicare Number"
        Me.colMedicareNumberLookup.FieldName = "MedicareNumber"
        Me.colMedicareNumberLookup.Name = "colMedicareNumberLookup"
        Me.colMedicareNumberLookup.Visible = True
        Me.colMedicareNumberLookup.VisibleIndex = 0
        Me.colMedicareNumberLookup.Width = 125
        '
        'colNameLookup
        '
        Me.colNameLookup.Caption = "Name"
        Me.colNameLookup.FieldName = "Name"
        Me.colNameLookup.Name = "colNameLookup"
        Me.colNameLookup.Visible = True
        Me.colNameLookup.VisibleIndex = 1
        Me.colNameLookup.Width = 551
        '
        'colCity
        '
        Me.colCity.Caption = "City"
        Me.colCity.FieldName = "City"
        Me.colCity.Name = "colCity"
        Me.colCity.Visible = True
        Me.colCity.VisibleIndex = 3
        Me.colCity.Width = 122
        '
        'colState
        '
        Me.colState.Caption = "State"
        Me.colState.ColumnEdit = Me.FacilityStateGridLookUpEdit
        Me.colState.FieldName = "State"
        Me.colState.Name = "colState"
        Me.colState.Visible = True
        Me.colState.VisibleIndex = 4
        Me.colState.Width = 81
        '
        'FacilityStateGridLookUpEdit
        '
        Me.FacilityStateGridLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[True]
        Me.FacilityStateGridLookUpEdit.AutoHeight = False
        Me.FacilityStateGridLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.FacilityStateGridLookUpEdit.DataSource = Me.FacilityStateBindingSource
        Me.FacilityStateGridLookUpEdit.DisplayMember = "Abbreviation"
        Me.FacilityStateGridLookUpEdit.Name = "FacilityStateGridLookUpEdit"
        Me.FacilityStateGridLookUpEdit.NullText = ""
        Me.FacilityStateGridLookUpEdit.ValueMember = "Abbreviation"
        Me.FacilityStateGridLookUpEdit.View = Me.RepositoryItemGridLookUpEdit1View
        '
        'RepositoryItemGridLookUpEdit1View
        '
        Me.RepositoryItemGridLookUpEdit1View.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colStateName, Me.colAbbreviation1})
        Me.RepositoryItemGridLookUpEdit1View.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.RepositoryItemGridLookUpEdit1View.Name = "RepositoryItemGridLookUpEdit1View"
        Me.RepositoryItemGridLookUpEdit1View.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.RepositoryItemGridLookUpEdit1View.OptionsView.ColumnAutoWidth = False
        Me.RepositoryItemGridLookUpEdit1View.OptionsView.ShowGroupPanel = False
        Me.RepositoryItemGridLookUpEdit1View.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colAbbreviation1, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colStateName
        '
        Me.colStateName.Caption = "Name"
        Me.colStateName.FieldName = "Name"
        Me.colStateName.Name = "colStateName"
        Me.colStateName.Visible = True
        Me.colStateName.VisibleIndex = 1
        Me.colStateName.Width = 808
        '
        'colAbbreviation1
        '
        Me.colAbbreviation1.Caption = "Abbreviation"
        Me.colAbbreviation1.FieldName = "Abbreviation"
        Me.colAbbreviation1.Name = "colAbbreviation1"
        Me.colAbbreviation1.Visible = True
        Me.colAbbreviation1.VisibleIndex = 0
        Me.colAbbreviation1.Width = 98
        '
        'colRegionId
        '
        Me.colRegionId.Caption = "Region"
        Me.colRegionId.ColumnEdit = Me.FacilityRegionLookUpEdit
        Me.colRegionId.FieldName = "RegionId"
        Me.colRegionId.Name = "colRegionId"
        Me.colRegionId.OptionsColumn.ReadOnly = True
        Me.colRegionId.Visible = True
        Me.colRegionId.VisibleIndex = 5
        Me.colRegionId.Width = 109
        '
        'FacilityRegionLookUpEdit
        '
        Me.FacilityRegionLookUpEdit.AutoHeight = False
        Me.FacilityRegionLookUpEdit.DataSource = Me.FacilityRegionBindingSource
        Me.FacilityRegionLookUpEdit.DisplayMember = "Name"
        Me.FacilityRegionLookUpEdit.Name = "FacilityRegionLookUpEdit"
        Me.FacilityRegionLookUpEdit.NullText = ""
        Me.FacilityRegionLookUpEdit.ValueMember = "Id"
        '
        'colCountry
        '
        Me.colCountry.Caption = "Country"
        Me.colCountry.ColumnEdit = Me.CountryComboBox
        Me.colCountry.FieldName = "Country"
        Me.colCountry.Name = "colCountry"
        Me.colCountry.Visible = True
        Me.colCountry.VisibleIndex = 6
        '
        'CountryComboBox
        '
        Me.CountryComboBox.AutoHeight = False
        Me.CountryComboBox.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.CountryComboBox.Items.AddRange(New Object() {"US", "Canada", "American Samoa", "Guam", "Marshall Islands", "Puerto Rico", "Virgin Islands", "Other"})
        Me.CountryComboBox.Name = "CountryComboBox"
        '
        'colAhaId
        '
        Me.colAhaId.Caption = "AHA Number"
        Me.colAhaId.FieldName = "AhaId"
        Me.colAhaId.Name = "colAhaId"
        Me.colAhaId.Visible = True
        Me.colAhaId.VisibleIndex = 7
        Me.colAhaId.Width = 83
        '
        'colAdmitNumber
        '
        Me.colAdmitNumber.Caption = "Admit Number"
        Me.colAdmitNumber.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric
        Me.colAdmitNumber.FieldName = "AdmitNumber"
        Me.colAdmitNumber.Name = "colAdmitNumber"
        Me.colAdmitNumber.Visible = True
        Me.colAdmitNumber.VisibleIndex = 8
        Me.colAdmitNumber.Width = 89
        '
        'colBedSize
        '
        Me.colBedSize.Caption = "Bed Size"
        Me.colBedSize.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric
        Me.colBedSize.FieldName = "BedSize"
        Me.colBedSize.Name = "colBedSize"
        Me.colBedSize.Visible = True
        Me.colBedSize.VisibleIndex = 9
        Me.colBedSize.Width = 62
        '
        'colIsCancerCenter
        '
        Me.colIsCancerCenter.Caption = "Cancer Center"
        Me.colIsCancerCenter.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsCancerCenter.FieldName = "IsCancerCenter"
        Me.colIsCancerCenter.Name = "colIsCancerCenter"
        Me.colIsCancerCenter.Visible = True
        Me.colIsCancerCenter.VisibleIndex = 10
        Me.colIsCancerCenter.Width = 92
        '
        'TriStateComboBoxEdit
        '
        Me.TriStateComboBoxEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.TriStateComboBoxEdit.AutoHeight = False
        Me.TriStateComboBoxEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.TriStateComboBoxEdit.Name = "TriStateComboBoxEdit"
        Me.TriStateComboBoxEdit.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        '
        'colIsForProfit
        '
        Me.colIsForProfit.Caption = "For Profit"
        Me.colIsForProfit.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsForProfit.FieldName = "IsForProfit"
        Me.colIsForProfit.Name = "colIsForProfit"
        Me.colIsForProfit.Visible = True
        Me.colIsForProfit.VisibleIndex = 11
        Me.colIsForProfit.Width = 80
        '
        'colIsFreeStanding
        '
        Me.colIsFreeStanding.Caption = "Free Standing"
        Me.colIsFreeStanding.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsFreeStanding.FieldName = "IsFreeStanding"
        Me.colIsFreeStanding.Name = "colIsFreeStanding"
        Me.colIsFreeStanding.Visible = True
        Me.colIsFreeStanding.VisibleIndex = 12
        Me.colIsFreeStanding.Width = 89
        '
        'colIsGovernment
        '
        Me.colIsGovernment.Caption = "Government"
        Me.colIsGovernment.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsGovernment.FieldName = "IsGovernment"
        Me.colIsGovernment.Name = "colIsGovernment"
        Me.colIsGovernment.Visible = True
        Me.colIsGovernment.VisibleIndex = 13
        Me.colIsGovernment.Width = 81
        '
        'colIsPediatric
        '
        Me.colIsPediatric.Caption = "Pediatric"
        Me.colIsPediatric.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsPediatric.FieldName = "IsPediatric"
        Me.colIsPediatric.Name = "colIsPediatric"
        Me.colIsPediatric.Visible = True
        Me.colIsPediatric.VisibleIndex = 14
        Me.colIsPediatric.Width = 63
        '
        'colIsPicker
        '
        Me.colIsPicker.Caption = "Picker"
        Me.colIsPicker.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsPicker.FieldName = "IsPicker"
        Me.colIsPicker.Name = "colIsPicker"
        Me.colIsPicker.Visible = True
        Me.colIsPicker.VisibleIndex = 15
        Me.colIsPicker.Width = 63
        '
        'colIsRehab
        '
        Me.colIsRehab.Caption = "Rehab"
        Me.colIsRehab.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsRehab.FieldName = "IsRehab"
        Me.colIsRehab.Name = "colIsRehab"
        Me.colIsRehab.Visible = True
        Me.colIsRehab.VisibleIndex = 16
        Me.colIsRehab.Width = 53
        '
        'colIsReligious
        '
        Me.colIsReligious.Caption = "Religious"
        Me.colIsReligious.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsReligious.FieldName = "IsReligious"
        Me.colIsReligious.Name = "colIsReligious"
        Me.colIsReligious.Visible = True
        Me.colIsReligious.VisibleIndex = 17
        Me.colIsReligious.Width = 64
        '
        'colIsRural
        '
        Me.colIsRural.Caption = "Rural"
        Me.colIsRural.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsRural.FieldName = "IsRural"
        Me.colIsRural.Name = "colIsRural"
        Me.colIsRural.Visible = True
        Me.colIsRural.VisibleIndex = 18
        Me.colIsRural.Width = 60
        '
        'colIsTrauma
        '
        Me.colIsTrauma.Caption = "Trauma"
        Me.colIsTrauma.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsTrauma.FieldName = "IsTrauma"
        Me.colIsTrauma.Name = "colIsTrauma"
        Me.colIsTrauma.Visible = True
        Me.colIsTrauma.VisibleIndex = 19
        Me.colIsTrauma.Width = 58
        '
        'colIsTeaching
        '
        Me.colIsTeaching.Caption = "Teaching"
        Me.colIsTeaching.ColumnEdit = Me.TriStateComboBoxEdit
        Me.colIsTeaching.FieldName = "IsTeaching"
        Me.colIsTeaching.Name = "colIsTeaching"
        Me.colIsTeaching.Visible = True
        Me.colIsTeaching.VisibleIndex = 20
        Me.colIsTeaching.Width = 67
        '
        'colAbbreviation
        '
        Me.colAbbreviation.Caption = "Abbreviation"
        Me.colAbbreviation.FieldName = "Abbreviation"
        Me.colAbbreviation.Name = "colAbbreviation"
        Me.colAbbreviation.Visible = True
        Me.colAbbreviation.VisibleIndex = 0
        '
        'colPENumber
        '
        Me.colPENumber.Caption = "PE Number"
        Me.colPENumber.ColumnEdit = Me.PENumberLookUpEdit
        Me.colPENumber.FieldName = "MedicareNumber"
        Me.colPENumber.Name = "colPENumber"
        Me.colPENumber.OptionsColumn.ReadOnly = True
        Me.colPENumber.Visible = True
        Me.colPENumber.VisibleIndex = 2
        '
        'PENumberLookUpEdit
        '
        Me.PENumberLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[True]
        Me.PENumberLookUpEdit.AutoHeight = False
        Me.PENumberLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.PENumberLookUpEdit.DataSource = Me.MedicareNumberBindingSource
        Me.PENumberLookUpEdit.DisplayMember = "PENumber"
        Me.PENumberLookUpEdit.Name = "PENumberLookUpEdit"
        Me.PENumberLookUpEdit.NullText = ""
        '
        'FacilityGrid
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.FacilitiesGrid)
        Me.Name = "FacilityGrid"
        Me.Size = New System.Drawing.Size(547, 498)
        CType(Me.MedicareNumberBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilityRegionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilityStateBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilityBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilitiesGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilityGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MedicareNumberGridLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilityStateGridLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemGridLookUpEdit1View, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FacilityRegionLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CountryComboBox, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.TriStateComboBoxEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PENumberLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MedicareNumberBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents FacilityRegionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents FacilityStateBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents FacilityBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents FacilitiesGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents FacilityGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colFacilityName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFacilityMedicareNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents MedicareNumberGridLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colMedicareNumberLookup As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNameLookup As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAhaId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCity As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colState As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FacilityStateGridLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
    Friend WithEvents RepositoryItemGridLookUpEdit1View As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colStateName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colRegionId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FacilityRegionLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents colCountry As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAdmitNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colBedSize As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsCancerCenter As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsForProfit As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsFreeStanding As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsGovernment As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsPediatric As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsPicker As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsRehab As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsReligious As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsRural As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsTrauma As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsTeaching As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents TriStateComboBoxEdit As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents CountryComboBox As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents colAbbreviation As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAbbreviation1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPENumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents PENumberLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit

End Class
