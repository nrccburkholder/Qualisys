�
 TBITMAPFORM 0I  TPF0TBitmapForm
BitmapFormLeft� Top� ActiveControlDBNavigator1BorderStylebsDialogCaptionCompany DatabaseClientHeightWClientWidth�
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold PixelsPerInch`PositionpoScreenCenter
TextHeight TDBTextDBText1LeftTopWidthHeightAutoSize		DataField	Full Name
DataSource
CustomerDS
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TDBTextDBText2LeftTop0WidthHeightAutoSize		DataFieldFull Address
DataSource
CustomerDS  TDBTextDBText3LeftTop Width� HeightAutoSize		DataFieldStreet
DataSource
CustomerDS  	TwwDBGridInvoiceGridLeftTopHWidth�Height^Selected.StringsInvoice No	8	Invoice~NoTotal Invoice	10	Total~InvoicePurchase Date	14	Purchase~DateBalance Due	11	Balance~DuePayBitmap	6	Pay Payment Method	20	Payment~Method 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSource	InvoiceDS
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
KeyOptionsdgEnterToTabdgAllowDeletedgAllowInsert RowHeightPercentxOptions	dgEditingdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExitdgPerfectRowFit 
ParentFontTabOrder TitleAlignmenttaCenterTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.StylefsBold 
TitleLinesTitleButtonsOnCalcCellColorsInvoiceGridCalcCellColorsOnCalcTitleAttributesInvoiceGridCalcTitleAttributes
OnDblClickInvoiceGridDblClick	OnKeyDownInvoiceGridKeyDownOnKeyUpInvoiceGridKeyUpIndicatorColoricBlack  TwwDBComboboxPayMethComboLeft�Top`WidthHeight
ShowButton	StylecsDropDownListMapList	AllowClearKeyDropDownCount
ItemHeight Items.StringsAmerican Express	AMasterCard	MVisa	V 	MaxLength Sorted	TabOrderVisible	OnCloseUpPayMethComboCloseUp  TwwDBSpinEditInvoiceSpinEditLeft�Top`WidthHeight	Increment       ��?	MaxLength TabOrder  TDBNavigatorDBNavigator1Left(TopWidth� Height
DataSource
CustomerDSVisibleButtonsnbFirstnbPriornbNextnbLast TabOrderTabStop	  TMemoMemo1LeftTop� Width�Height� 
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.Strings5This demo uses the following InfoPower functionality: V1. Using a lookup table to retrieve the bitmap for the Payment method field.  You can 8enter the spacebar to cycle through the payment methods. O2. Using an InfoPower SpinEdit for the Purchase Date field.  You can enter the 6spacekey in the SpinEdit to AutoFill the current date. L3. Using an InfoPower mapped ComboBox to display a long description for the -Payment Method, but store a single character. 
ParentFontTabOrder  TwwDataSource
CustomerDSDataSetCustomerTableLeft`Top  TwwTableCustomerTableActive	OnCalcFieldsCustomerTableCalcFieldsDatabaseNameInfoDemo	TableName
IP2CUST.DBControlType.StringsBuyer;CheckBox;Yes;NoRequested Demo;CheckBox;Yes;No PictureMasks.Strings(First Contact Date	#[#]/#[#]/##[##]	T		F#Phone Number	*3{#}-*3{#}-*4{#}	T		F SyncSQLByRange	NarrowSearchValidateWithMask	Left�Top TIntegerFieldCustomerTableCustomerNoDisplayLabelNoDisplayWidth	FieldNameCustomer No  TStringFieldCustomerTableCompanyNameDisplayWidth	FieldNameCompany NameSize(  TStringFieldCustomerTableFirstNameDisplayWidth		FieldName
First NameSize  TStringFieldCustomerTableLastNameDisplayWidth		FieldName	Last NameSize  TStringFieldCustomerTableCityDisplayWidth		FieldNameCitySize  TStringFieldCustomerTableStateDisplayWidth	FieldNameStateSize  TStringFieldCustomerTableZipDisplayWidth	FieldNameZipSize
  TStringFieldCustomerTableBuyerDisplayWidth	FieldNameBuyerSize  TStringFieldCustomerTableStreetDisplayWidth	FieldNameStreetSize<  
TDateFieldCustomerTableFirstContactDateDisplayLabel1st DateDisplayWidth	FieldNameFirst Contact Date  TStringFieldCustomerTablePhoneNumberDisplayWidth	FieldNamePhone Number  
TMemoFieldCustomerTableInformationDisplayWidth	FieldNameInformationSizeP  TStringFieldCustomerTableRequestedDemoDisplayLabelDemoDisplayWidth	FieldNameRequested DemoVisibleSize  TBooleanFieldCustomerTableLogicalDisplayWidth	FieldNameLogicalVisible  TStringFieldCustomerTableFullName
Calculated		FieldName	Full NameVisible  TStringFieldCustomerTableFullAddress
Calculated		FieldNameFull AddressVisible   TwwDataSource	InvoiceDSDataSetInvoiceTableOnDataChangeInvoiceDSDataChangeLeft�Top  TwwTableInvoiceTableActive	AutoCalcFieldsDatabaseNameInfoDemoIndexFieldNamesCustomer NoMasterFieldsCustomer NoMasterSource
CustomerDS	TableName	IP2INV.DBLookupFields.StringsCPayBitmap;InfoDemo;GRDBITMP.DB;Credit Card Bitmap;;Payment Method;Y LookupLinks.StringsPayment Method;Payment Method ControlType.Strings(Purchase Date;CustomEdit;InvoiceSpinEdit&Payment Method;CustomEdit;PayMethCombo+PayBitmap;Bitmap;Stretch To Fit;Source Copy SyncSQLByRange	NarrowSearchValidateWithMask	Left�Top TFloatFieldInvoiceTableInvoiceNoDisplayLabel
Invoice~NoDisplayWidth	FieldName
Invoice No  TCurrencyFieldInvoiceTableTotalInvoiceDisplayLabelTotal~InvoiceDisplayWidth
	FieldNameTotal InvoiceCurrency	  
TDateFieldInvoiceTablePurchaseDateDisplayLabelPurchase~DateDisplayWidth	FieldNamePurchase Date  TCurrencyFieldInvoiceTableBalanceDueDisplayLabelBalance~DueDisplayWidth	FieldNameBalance DueCurrency	  TStringFieldInvoiceTablePayBitmap
Calculated	DisplayLabelPayDisplayWidth	FieldName	PayBitmap  TStringFieldInvoiceTablePaymentMethodDisplayLabelPayment~MethodDisplayWidth	FieldNamePayment MethodSize  TIntegerFieldInvoiceTableCustomerNoDisplayLabelNoDisplayWidth	FieldNameCustomer NoVisible    