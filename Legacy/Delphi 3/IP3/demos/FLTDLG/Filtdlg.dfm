�
 TFILTERDIALOGFORM 0=  TPF0TFilterDialogFormFilterDialogFormLeftTop� ActiveControlBitBtn1BorderStylebsDialogCaption#InfoPower's Visual Filtering DialogClientHeight�ClientWidthu
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style PositionpoScreenCenter
PrintScalepoNonePixelsPerInch`
TextHeight TLabelLabel1Left`Top WidthDHeightCaptionVisual Query 2Visible  TLabelLabel2LeftxTopPWidthbHeightCaptionVisual Filter on TableVisible  TLabelLabel3Left`Top� WidthDHeightCaptionVisual Query 1Visible  TBitBtnBitBtn1Left�Top_Width� HeightCaptionSpecify CriteriaTabOrder OnClickBitBtn1Click
Glyph.Data
�  �  BM�      v   (                                      �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� wwwwwwwwwwwwwwwwwwwwwwwwx          x����������x����������x����� ��x�������x�������x� � ��x��������p� ����� ��������� ���������p���������x   ������x��w������x� �x����x�ww������x�wwp����x��wp    x����w���x���wx�����www��wwwwwwwwwx �wwwwww  	TGroupBox	GroupBox1Left�TopWidth� Height~CaptionDisplay OptionsTabOrder 	TCheckBoxSearchTypeCheckboxLeftTopWidth� HeightCaptionSearch Type Tab ControlState	cbCheckedTabOrder OnClickSearchTypeCheckboxClick  	TCheckBoxShowFieldOrderCheckboxLeftTop(Width� HeightCaptionField Order Radio ButtonState	cbCheckedTabOrderOnClickShowFieldOrderCheckboxClick  	TCheckBoxViewSummaryCheckboxLeftTop<Width� HeightCaptionView Summary ButtonState	cbCheckedTabOrderOnClickViewSummaryCheckboxClick  	TCheckBox	CheckBox1LeftTopPWidth� HeightCaptionOK and Cancel ButtonsState	cbCheckedTabOrderOnClickCheckBox1Click  	TCheckBox	CheckBox2LeftTopdWidth� HeightCaptionShow Nonmatching RecordsTabOrderOnClickCheckBox2Click   TTabbedNotebookTabbedNotebook1LeftTop Width�Height�
TabsPerRowTabFont.Color	clBtnTextTabFont.Height�TabFont.NameMS Sans SerifTabFont.Style TabOrderOnChangeTabbedNotebook1Change TTabPage LeftTopCaptionLocal Filtering 	TwwDBGrid	wwDBGrid1LeftTopWidth�Height� Selected.StringsCustomer No	6	Cust~NoBuyer	5	BuyerCompany Name	9	Company~NameFirst Name	10	First NameLast Name	10	Last NameStreet	15	StreetCity	11	CityState	25	State
Zip	15	Zip(First Contact Date	15	First Contact DatePhone Number	20	Phone NumberInformation	10	Information Requested Demo	14	Requested DemoLogical	6	Logical 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSource
CustomerDSOptions	dgEditingdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit RowHeightPercent� TabOrder TitleAlignmenttaCenterTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsIndicatorColoricBlack  TwwDBRichEditwwDBRichEdit3LeftTop� Width�Height� Lines.Strings  {\rtf1\ansi\deff0\deftab720{\fonttbl{\f0\fswiss MS Sans Serif;}{\f1\froman\fcharset2 Symbol;}{\f2\froman Times New Roman;}{\f3\froman Times New Roman;}{\f4\froman\fcharset1 Times New Roman;}{\f5\fswiss\fcharset1 MS Sans Serif;}{\f6\froman\fprq2 Times New Roman;}}�{\colortbl\red0\green0\blue0;\red0\green0\blue128;\red255\green0\blue0;\red0\green128\blue128;\red0\green128\blue0;\red8\green0\blue0;}�  \deflang1033\pard\li72\plain\f3\fs20\cf5 InfoPower allows your end-users to visually perform a local filter on a Table, Query, Stored Procedure, Client DataSet or QBE. Filter criteria can be specified as a value, a substring, or a range. When using local filtering on a Query, Stored Procedure, or QBE, the query is not re-executed, but simply re-filtered.  This means that the back-end does not need to do any additional processing. \par K\par Local filtering on tables guarantees a live editable view of the data.\par \par \par } TabOrderEditorCaptionEdit Rich TextMeasurementUnitsmuInchesPrintMargins.Top       ��?PrintMargins.Bottom       ��?PrintMargins.Left       ��?PrintMargins.Right       ��?   TTabPage LeftTopCaptionVisual Querying 1 	TwwDBGrid	wwDBGrid4LeftTop Width�Height� Selected.StringsCustomer No	9	Customer NoBuyer	4	BuyerCompany Name	14	Company NameFirst Name	8	First NameLast Name	9	Last NameStreet	60	StreetCity	25	CityState	25	State
Zip	10	Zip(First Contact Date	13	First Contact DatePhone Number	20	Phone NumberInformation	10	Information Requested Demo	12	Requested DemoLogical	5	Logical 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSourceCustomer1QueryDSOptions	dgEditingdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit TabOrder TitleAlignmenttaLeftJustifyTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsIndicatorColoricBlack  TwwDBRichEditwwDBRichEdit2LeftTop� Width�Height� Lines.Strings  {\rtf1\ansi\deff0\deftab720{\fonttbl{\f0\fswiss MS Sans Serif;}{\f1\froman\fcharset2 Symbol;}{\f2\froman Times New Roman;}{\f3\froman Times New Roman;}{\f4\froman\fcharset1 Times New Roman;}{\f5\fswiss\fcharset1 MS Sans Serif;}{\f6\froman\fprq2 Times New Roman;}}�{\colortbl\red0\green0\blue0;\red0\green0\blue128;\red255\green0\blue0;\red0\green128\blue128;\red0\green128\blue0;\red8\green0\blue0;}O  \deflang1033\pard\plain\f3\fs20 InfoPower's visual query mechanism performs remote filtering by utilizing existing SQL queries, and modifying them according to a user defined search criteria. Though functionally very similar to local filtering, the actual mechanism of filteriing is not performed locally, but instead at the back-end. \par �\par The back-end can then efficiently perform the search by utilizing available indexes.  Visual Querying also has the advantage of reducing network traffic since the filtering is performed on the same machine that contains \par the data.\par \par \plain\f3\fs20\cf0 \par } TabOrderEditorCaptionEdit Rich TextMeasurementUnitsmuInchesPrintMargins.Top       ��?PrintMargins.Bottom       ��?PrintMargins.Left       ��?PrintMargins.Right       ��?   TTabPage LeftTopCaptionVisual Querying 2 	TGroupBox	GroupBox2LeftTop� Width�HeightaCaptionOrders for CustomerTabOrder  	TwwDBGrid	wwDBGrid3LeftTopWidth�HeightHSelected.StringsInvoice No	10	Invoice NoPayment Method	14	Pay MethodTotal Invoice	12	Total InvoicePurchase Date	12	DateBalance Due	12	Balance Due 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSource	CustInvDSOptions	dgEditingdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit TabOrder TitleAlignmenttaLeftJustifyTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsOnCalcCellColorswwDBGrid3CalcCellColorsIndicatorColoricBlack   	TGroupBox	GroupBox3LeftTopWidth�Height}Caption	CustomersTabOrder 	TwwDBGrid	wwDBGrid2LeftTopWidth�HeightYSelected.StringsCustomer No	9	Customer NoBuyer	4	BuyerCity	8	CityCompany Name	14	Company Name(First Contact Date	13	First Contact DateFirst Name	25	First NameInformation	10	InformationLast Name	25	Last NameLogical	5	LogicalPhone Number	20	Phone Number Requested Demo	12	Requested DemoState	25	StateStreet	60	Street
Zip	10	Zip 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSourceCustomer2QueryDSOptions	dgEditingdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit TabOrder TitleAlignmenttaLeftJustifyTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsIndicatorColoricBlack   TMemoMemo3LeftTop� Width�Height~
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.StringsFInfoPower performs remote filtering with multi-table sql queries, and Lmodifies them according to a user defined search criteria.  As a result you 2can even specify search criteria in joined tables. MFor instance click on the "Specify Criteria" button to the right and enter a G"Starting Range" of 25 for the "Balance Due" field.  Then click the OK Ebutton. You will then see only customers who have at least one order -where the balance due field is more than $25. 
ParentFontTabOrder   TTabPage LeftTopCaptionAnd, Or, Not, Null 	TwwDBGrid	wwDBGrid5LeftTopWidth�Height� Selected.StringsCustomer No	6	Cust~NoBuyer	5	BuyerCompany Name	9	Company~NameFirst Name	10	First NameLast Name	10	Last NameStreet	15	StreetCity	11	CityState	25	State
Zip	15	Zip(First Contact Date	15	First Contact DatePhone Number	20	Phone NumberInformation	10	Information Requested Demo	14	Requested DemoLogical	6	Logical 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSource
CustomerDSTabOrder TitleAlignmenttaLeftJustifyTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsIndicatorColoricBlack  TwwDBRichEditwwDBRichEdit1LeftTop� Width�Height� Lines.Strings  {\rtf1\ansi\deff0\deftab720{\fonttbl{\f0\fswiss MS Sans Serif;}{\f1\froman\fcharset2 Symbol;}{\f2\froman Times New Roman;}{\f3\froman Times New Roman;}{\f4\froman\fcharset1 Times New Roman;}{\f5\fswiss\fcharset1 MS Sans Serif;}{\f6\froman\fprq2 Times New Roman;}}�{\colortbl\red0\green0\blue0;\red0\green0\blue128;\red255\green0\blue0;\red0\green128\blue128;\red0\green128\blue0;\red8\green0\blue0;}�\deflang1033\pard\plain\f3\fs20\b New in InfoPower 3\plain\f3\fs20  - Programmable keywords for AND, OR, and NULL support.  This allows you to specify multiple filter values for each field, such as John OR Paul.\par n\par \plain\f3\fs20\b New in InfoPower 3 \plain\f3\fs20 - A new option has been added to handle NOT support.  �\par When fdShowNonMatching is set to True, a checkbox appears in the Filterdialog which, when enabled, will show all the records that do \plain\f3\fs20\b\i not\plain\f3\fs20  fit the entered condition.\par \par \plain\f3\fs20\cf0 \par } TabOrderEditorCaptionEdit Rich TextMeasurementUnitsmuInchesPrintMargins.Top       ��?PrintMargins.Bottom       ��?PrintMargins.Left       ��?PrintMargins.Right       ��?    TwwFilterDialogwwFilterDialog1
DataSource
CustomerDSSortByfdSortByFieldNoCaptionSearch using local filteringFilterMethod
fdByFilterDefaultMatchTypefdMatchStartDefaultFilterByfdSmartFilterFieldOperators.OrCharorFieldOperators.AndCharandFieldOperators.NullCharnullFilterOptimizationfdNoneLeftxTop`  TwwDataSource
CustomerDSDataSetCustomerTblLeftxTop�   TwwTableCustomerTblActive	DatabaseNameInfoDemo	TableName
IP2CUST.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top�   TwwDataSourceCustomer2QueryDSDataSetCustomer2QueryLeft`Top0  TwwQueryCustomer2QueryActive	DatabaseNameInfoDemoSQL.StringsSELECT  DISTINCT  IP2CUST."Customer No", IP2CUST."Buyer" ,  IP2CUST."Company Name" ,  IP2CUST."First Name" , * IP2CUST."Last Name" , IP2CUST."Street" , $ IP2CUST."City" , IP2CUST."State" ,  IP2CUST."Zip" ,   IP2CUST."First Contact Date" ,  IP2CUST."Phone Number" ,  IP2CUST."Information" ,  IP2CUST."Requested Demo" ,  IP2CUST."Logical".FROM "IP2CUST.DB" IP2CUST , "IP2INV.DB" IP2INV2WHERE (IP2CUST."CUSTOMER NO"=IP2INV."CUSTOMER NO") ValidateWithMask	OnFilterOptions Left�Top0 TIntegerFieldCustomer2QueryCUSTOMERNODisplayLabelCustomer NoDisplayWidth		FieldNameCUSTOMER NO  TStringFieldCustomer2QueryBuyerDisplayWidth	FieldNameBuyerSize  TStringFieldCustomer2QueryCityDisplayWidth	FieldNameCitySize  TStringFieldCustomer2QueryCompanyNameDisplayWidth	FieldNameCompany NameSize(  
TDateFieldCustomer2QueryFirstContactDateDisplayWidth	FieldNameFirst Contact Date  TStringFieldCustomer2QueryFirstNameDisplayWidth	FieldName
First NameSize  
TMemoFieldCustomer2QueryInformationDisplayWidth
	FieldNameInformationBlobTypeftMemoSizeP  TStringFieldCustomer2QueryLastNameDisplayWidth	FieldName	Last NameSize  TBooleanFieldCustomer2QueryLogicalDisplayWidth	FieldNameLogical  TStringFieldCustomer2QueryPhoneNumberDisplayWidth	FieldNamePhone Number  TStringFieldCustomer2QueryRequestedDemoDisplayWidth	FieldNameRequested DemoSize  TStringFieldCustomer2QueryStateDisplayWidth	FieldNameStateSize  TStringFieldCustomer2QueryStreetDisplayWidth<	FieldNameStreetSize<  TStringFieldCustomer2QueryZipDisplayWidth
	FieldNameZipSize
   TwwFilterDialogwwFilterDialog3
DataSourceCustomer2QueryDSSortByfdSortByFieldNoCaption.Search on multiple tables using a visual queryFilterMethodfdByQueryModifyDefaultMatchTypefdMatchStartDefaultFilterByfdSmartFilterFieldOperators.OrCharorFieldOperators.AndCharandFieldOperators.NullCharnullSelectedFields.StringsBalance Due;Balance DueBuyer;Buyer?CityCompany NameCustomer NoFirst Contact Date
First NameInformation
Invoice No	Last NameLogicalPayment MethodPhone NumberPurchase DateRequested DemoStateStreetTotal InvoiceZip FilterOptimizationfdNoneLeft`Top  TwwDataSource	CustInvDSDataSetCustInvoiceTableLeft`TopR  TwwTableCustInvoiceTableActive	DatabaseNameInfoDemoIndexFieldNamesCustomer NoMasterFieldsCustomer NoMasterSourceCustomer2QueryDS	TableName	IP2INV.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left�TopR  TwwFilterDialogwwFilterDialog2
DataSourceCustomer1QueryDSSortByfdSortByFieldNoCaption#Search query using remote filteringFilterMethodfdByQueryModifyDefaultMatchTypefdMatchStartDefaultFilterByfdSmartFilterFieldOperators.OrCharorFieldOperators.AndCharandFieldOperators.NullCharnullFilterOptimizationfdNoneLeft`Top�   TwwDataSourceCustomer1QueryDSDataSetCustomer1QueryLeft`Top�   TwwQueryCustomer1QueryDatabaseNameInfoDemoSQL.StringsSelect * from IP2CUST ValidateWithMask	OnFilterOptions Left�Top�  TIntegerFieldCustomer1QueryCustomerNoDisplayWidth		FieldNameCustomer No  TStringFieldCustomer1QueryBuyerDisplayWidth	FieldNameBuyerSize  TStringFieldCustomer1QueryCompanyNameDisplayWidth	FieldNameCompany NameSize(  TStringFieldCustomer1QueryFirstNameDisplayWidth	FieldName
First NameSize  TStringFieldCustomer1QueryLastNameDisplayWidth		FieldName	Last NameSize  TStringFieldCustomer1QueryStreetDisplayWidth<	FieldNameStreetSize<  TStringFieldCustomer1QueryCityDisplayWidth	FieldNameCitySize  TStringFieldCustomer1QueryStateDisplayWidth	FieldNameStateSize  TStringFieldCustomer1QueryZipDisplayWidth
	FieldNameZipSize
  
TDateFieldCustomer1QueryFirstContactDateDisplayWidth	FieldNameFirst Contact Date  TStringFieldCustomer1QueryPhoneNumberDisplayWidth	FieldNamePhone Number  
TMemoFieldCustomer1QueryInformationDisplayWidth
	FieldNameInformationBlobTypeftMemoSizeP  TStringFieldCustomer1QueryRequestedDemoDisplayWidth	FieldNameRequested DemoSize  TBooleanFieldCustomer1QueryLogicalDisplayWidth	FieldNameLogical    