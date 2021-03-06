�
 TGRIDDEMO 0�$  TPF0	TGridDemoGridDemoLeftRTop� HorzScrollBar.VisibleVertScrollBar.VisibleBorderStylebsDialogCaption!InfoPower - Lookup Combos in GridClientHeightwClientWidth�
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
KeyPreview	PixelsPerInch`PositionpoScreenCenterOnCloseQueryFormCloseQueryOnShowFormShow
TextHeight TTabbedNotebookTabbedNotebook1LeftTopWidth�HeightY	PageIndexTabFont.Color	clBtnTextTabFont.Height�TabFont.NameMS Sans SerifTabFont.Style TabOrderOnChangeTabbedNotebook1Change TTabPage LeftTopCaptionLookupCombo 	TwwDBGrid	wwDBGrid1LeftTop Width�Height� Selected.StringsLast Name	10	Last NameFirst Name	9	First NameBuyer	6	Buyer?
Zip	11	ZipCompany Name	17	Company Name 
TitleColorclNavy	FixedColsShowHorzScrollBar	Color	clBtnFaceCtl3D	
DataSourceCustomerSource
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
KeyOptionsdgEnterToTabdgAllowDeletedgAllowInsert Options	dgEditingdgAlwaysShowEditordgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit ParentCtl3D
ParentFontTabOrder TitleAlignmenttaCenterTitleFont.ColorclWhiteTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.StylefsBold 
TitleLinesTitleButtons
UseTFieldsOnKeyUpwwDBGrid1KeyUpIndicatorColoricYellow  TMemoMemo2LeftTop� Width�Height� Ctl3D	
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.StringsEThis example attaches a lookup combo to an InfoPower data-aware grid.KClick in the grid's field column "Zip" to display the lookup combo control. KThe combo control uses the value from field "Zip" in customer.db to lookup Ozip.db.  The drop-down displays the zip, city, and state from the lookup table. QYou can incrementally search through the lookup list by directly typing into the 1combo control while the lookup list is displayed. ParentCtl3D
ParentFont
ScrollBars
ssVerticalTabOrder   TTabPage LeftTopCaptionLinked LookupCombo 	TwwDBGrid	wwDBGrid2LeftTop Width�Height� Selected.StringsLast Name	10	Last NameFirst Name	9	First Name	NoBuyer	6	Buyer?	NoZipCity	20	ZipCityCompany Name	17	Company Name	No 
TitleColorclNavy	FixedColsShowHorzScrollBarColor	clBtnFace
DataSourceCustomerSource
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
KeyOptionsdgEnterToTabdgAllowDeletedgAllowInsert Options	dgEditingdgAlwaysShowEditordgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit 
ParentFontTabOrder TitleAlignmenttaCenterTitleFont.ColorclWhiteTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.StylefsBold 
TitleLinesTitleButtons
UseTFieldsIndicatorColoricYellow  TMemoMemo1LeftTop� Width�Height� 
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.StringsFThis example attaches a lookup combo to a linked field in a InfoPower Odata-aware grid.  Click the City field in the grid to display the lookup combo Pcontrol.  Type in characters to perform incremental searches on the lookup list. BThis grid is actually displaying values from two different tables.PThe combo control uses the value from "Zip" in customer.db to look up zip.db to Tretrieve and display its corresponding "City" value.. The displayed field "City" in Kthe above grid comes from the zip.db table. When the end-user selects a newM"City", he/she is actually changing the "Zip" field value from "Customer.db". 
ParentFont
ScrollBars
ssVerticalTabOrder   TTabPage LeftTopCaptionComboDlg - Calendar 	TwwDBGrid	wwDBGrid3LeftTop Width�Height� Selected.StringsLast Name	10	Last NameFirst Name	9	First Name	NoBuyer	6	Buyer?	NoCompany Name	17	Company Name(First Contact Date	10	First Contact Date 
TitleColorclNavy	FixedColsShowHorzScrollBarShowVertScrollBarColor	clBtnFace
DataSourceCustomerSource
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold Options	dgEditingdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrapdgPerfectRowFit 
ParentFontTabOrder TitleAlignmenttaLeftJustifyTitleFont.ColorclWhiteTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.StylefsBold 
TitleLinesTitleButtons
UseTFieldsIndicatorColoricYellow  TMemoMemo3LeftTop� Width�Height� 
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.StringsKInfoPower's TwwDBComboDlg component gives you the ability to significantly 'extend the grid's editing capabilities. IIn this example, the grid's "Contact Date" column uses the TwwDBComboDlg Tto link to a customized calendar dialog.  Just click in the "Contact Date" field to Msee this.  You can also easily create your own dialogs that get called.  The MTwwDBComboDlg also supports auto-filling of the current date by entering the spacebar a few times. LThis demo also shows that you can turn off both the horizontal and vertical scrollbars. 
ParentFont
ScrollBars
ssVerticalTabOrder    TwwDBLookupCombowwDBLookupCombo2Left<TopWidthHeightDropDownAlignmenttaLeftJustifySelected.Strings	ZIP	5	ZIPCITY	15	CITYSTATE	5	STATE LookupTableZipTableLookupFieldZIPOptions
loColLinesloTitles TabOrderAutoDropDown	
ShowButton	SeqSearchOptions
ssoEnabledssoCaseSensitive AllowClearKeyShowMatchText	  TwwDBLookupCombowwDBLookupCombo1Left,TopWidthHeightDropDownAlignmenttaLeftJustifySelected.StringsCITY	11	CITY	ZIP	5	ZIPSTATE	5	STATECityDesc	20	CityDesc LookupTableZipTableLookupFieldZIPOptions
loColLinesloTitles TabOrder AutoDropDown	
ShowButton	SeqSearchOptions
ssoEnabledssoCaseSensitive AllowClearKeyShowMatchText	  TButtonButton1LeftTopWidthgHeightCaptionLookup and FillTabOrderOnClickButton1Click  TwwDBComboDlgwwDBComboDlg1LeftPTopWidthHeightOnCustomDlgwwDBComboDlg1CustomDlg
ShowButton	Style
csDropDown	MaxLength TabOrderUnboundDataType	wwDefault  TBitBtnBitBtn2Left�TopWidth]HeightCaptionExitTabOrderOnClickBitBtn2Click
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 3     33wwwww33333333333333333333333333333333333333333333333?33�33333s3333333333333���33��337ww�33��337���33��337ww3333333333333����33     33wwwwws3	NumGlyphs  TwwTableCustomerTableActive	DatabaseNameInfoDemo	IndexName	iLastName	TableName
IP2CUST.DBLookupFields.Strings&ZipCity;InfoDemo;IP2ZIP.DB;CITY;;ZIP;Y LookupLinks.StringsZip;ZIP ControlType.StringsBuyer;CheckBox;Yes;NoRequested Demo;CheckBox;Yes;NoZip;CustomEdit;wwDBLookupCombo2,First Contact Date;LookupCombo;wwDBComboDlg1#ZipCity;CustomEdit;wwDBLookupCombo1 SyncSQLByRange	NarrowSearchValidateWithMask	Left� Top TStringFieldCustomerTableLastNameDisplayWidth
	FieldName	Last NameSize  TStringFieldCustomerTableFirstNameDisplayWidth		FieldName
First NameSize  TStringFieldCustomerTableBuyerDisplayLabelBuyer?DisplayWidth	FieldNameBuyerSize  TStringFieldCustomerTableZipDisplayWidth	FieldNameZipSize
  TStringFieldCustomerTableZipCity
Calculated	DisplayWidth	FieldNameZipCity  TStringFieldCustomerTableCompanyNameDisplayWidth	FieldNameCompany NameSize(  TIntegerFieldCustomerTableCustomerNo	FieldNameCustomer NoVisible  TStringFieldCustomerTableStreet	FieldNameStreetVisibleSize<  TStringFieldCustomerTableCity	FieldNameCityVisibleSize  TStringFieldCustomerTableState	FieldNameStateVisibleSize  
TDateFieldCustomerTableFirstContactDate	FieldNameFirst Contact DateVisible  TStringFieldCustomerTablePhoneNumber	FieldNamePhone NumberVisible  
TMemoFieldCustomerTableInformation	FieldNameInformationVisibleSizeP  TStringFieldCustomerTableRequestedDemo	FieldNameRequested DemoVisibleSize  TBooleanFieldCustomerTableLogical	FieldNameLogicalVisible   TwwTableZipTableActive	DatabaseNameInfoDemo	TableName	IP2ZIP.DBLookupFields.Strings+CityDesc;InfoDemo;CITY.DB;City Description; LookupLinks.Strings	CITY;City SyncSQLByRange	NarrowSearchValidateWithMask	LeftTop TStringFieldZipTableZIPDisplayWidth	FieldNameZIPSize
  TStringFieldZipTableCITYDisplayWidth	FieldNameCITYSize  TStringFieldZipTableSTATEDisplayWidth	FieldNameSTATESize   TwwDataSourceCustomerSourceDataSetCustomerTableLeft� Top  TwwLookupDialogwwLookupDialog1Selected.Strings	ZIP	6	ZIPCITY	11	CITYSTATE	2	STATE GridTitleAlignmenttaLeftJustify	GridColorclWhiteOptionsopShowOKCancelopShowSearchByopGroupControlsopFixFirstColumnopShowStatusBar GridOptionsdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgAlwaysShowSelectiondgConfirmDelete LookupTableZipTableCaptionLookupMaxWidth 	MaxHeight� CharCaseecNormalUserButton1Caption&User ButtonOnUserButton1ClickwwLookupDialog1UserButton1ClickLeft� Top   