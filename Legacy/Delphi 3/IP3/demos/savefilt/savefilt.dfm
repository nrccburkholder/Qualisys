�
 TSAVEFILTERDEMO 0�  TPF0TSaveFilterDemoSaveFilterDemoLeft1Top� Width�HeightBCaptionSaving and restoring a filter
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Menu	MainMenu1PixelsPerInch`OnShowFormShow
TextHeight 	TwwDBGrid	wwDBGrid1Left Top Width�Height� Selected.StringsCustomer No	10	Customer NoBuyer	5	BuyerCompany Name	26	Company NameFirst Name	25	First NameLast Name	25	Last NameStreet	60	StreetCity	25	CityState	25	State
Zip	10	Zip(First Contact Date	14	First Contact DatePhone Number	20	Phone NumberInformation	10	Information Requested Demo	14	Requested DemoLogical	6	Logical 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	AlignalTop
DataSourcewwDataSource1TabOrder TitleAlignmenttaLeftJustifyTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsIndicatorColoricBlack  TMemoMemo1LeftTop� Width�HeightI
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.StringsHYour end-users may wish to use the InfoPower FilterDialog to create someEcommon search criteria that they wish to restore later.  This example@shows how you can save and restore named filters to a text file. )Just click on the Filter Menu at the top. 
ParentFontTabOrder  TwwFilterDialogwwFilterDialog1
DataSourcewwDataSource1SortByfdSortByFieldNoFilterMethod
fdByFilterDefaultMatchTypefdMatchStartDefaultFilterByfdSmartFilterFieldOperators.OrCharorFieldOperators.AndCharandFieldOperators.NullCharnullFilterOptimizationfdNoneLeft0Top  TwwDataSourcewwDataSource1DataSetwwTable1LeftTop0  TwwTablewwTable1Active	DatabaseNameInfoDemo	TableName
ip2cust.dbSyncSQLByRange	NarrowSearchValidateWithMask	Left0Top0  	TMainMenu	MainMenu1LeftTop 	TMenuItemFilter1Caption&Filter 	TMenuItemFilter2Caption
Filter ...OnClickFilter2Click  	TMenuItemClearFilter1CaptionClear FilterOnClickClearFilter1Click  	TMenuItemLoadFilter1CaptionLoad Filter ...OnClickLoadFilter1Click  	TMenuItemSaveFilter1Caption&Save Filter ...OnClickSaveFilter1Click  	TMenuItemExit1CaptionE&xitOnClick
Exit1Click     