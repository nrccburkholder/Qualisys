�
 TDETAILCOMBOFORM 0m	  TPF0TDetailComboFormDetailComboFormLeft!TopzActiveControlCustomerComboBorderStylebsDialogCaption.Fill the drop-down list from a detail TwwTableClientHeight� ClientWidthw
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold PositionpoScreenCenterPixelsPerInch`
TextHeight TLabelLabel1LeftTopWidth]HeightCaptionSelect Customer  TLabelLabel2Left� TopWidth� HeightCaptionSelect Customer Invoice  TwwDBLookupComboInvoiceComboLeft� TopWidth� HeightDropDownAlignmenttaLeftJustifySelected.StringsInvoice No	3	NoPurchase Date	10	Purchase DateTotal Invoice	6	Total LookupTablewwTable2LookupField
Invoice NoOptions
loColLinesloTitles TabOrderAutoDropDown
ShowButton	SeqSearchOptions
ssoEnabledssoCaseSensitive AllowClearKey  TwwDBLookupComboCustomerComboLeftTopWidth� HeightDropDownAlignmenttaLeftJustifySelected.StringsCompany Name	20	Company Name LookupTablewwTable1LookupFieldCustomer NoTabOrder AutoDropDown	
ShowButton	SeqSearchOptions
ssoEnabledssoCaseSensitive AllowClearKey
OnDropDownCustomerComboDropDown	OnCloseUpCustomerComboCloseUp  TMemoMemo1LeftTop@WidthjHeight� 
Font.ColorclBlackFont.Height�	Font.NameTimes New Roman
Font.Style Lines.Strings>Cick on the drop-down icon to select an invoice for the given ;customer.  The 2nd lookupCombo will show only invoices for the customer you selected. 8The following example demonstrates how you can attach a BLookupCombo directly to a detail table.  By attaching to a detail @table, the drop-down list will only show records related to the @current record of the master table. This example uses 2 unbound :LookupCombos: one looking up a master table (IP2CUST.DB), 7and the other looking up the detail table (IP2INV.DB).   
ParentFontTabOrder  TButtonButton1Left� TopWidth=HeightCancel	CaptionCancelModalResultTabOrder  TwwDataSourcewwDataSource1DataSetwwTable1LeftpTop@  TwwTablewwTable1Active	DatabaseNameInfoDemo	TableName
IP2CUST.DBSyncSQLByRange	NarrowSearchValidateWithMask	LeftpTop`  TwwTablewwTable2Active	DatabaseNameInfoDemoIndexFieldNamesCustomer No;Invoice NoMasterFieldsCustomer NoMasterSourcewwDataSource1	TableName	IP2INV.DBSyncSQLByRange	NarrowSearchValidateWithMask	LeftpTop�    