USE [QP_Prod]
GO


truncate table [dbo].[USPS_ACS_SchemaMapping]


DECLARE @Schema_ID int


SELECT @Schema_ID = USPS_ACS_Schema_ID
FROM [USPS_ACS_Schemas]
WHERE FileVersion = '00'


INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CustomerID',2,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CreateDate',8,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalACSRecordCount',16,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalCOACount',25,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalNIXIECount',34,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','ShipmentNumber',43,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','Class',51,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','MediaType',52,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','FILLER',53,507)


INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','SequenceNumber',2,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','SixDigitMailerID',10,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',16,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','MailpieceIdentifier',17,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',26,7)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','MoveEffectiveDate',33,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','MoveType',39,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','DelivierabilityCode',40,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','PostalServiceSiteID',41,3)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','LastName',44,20)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FirstName-MiddleName-INITIALS',64,15)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','Prefix',79,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','Suffix',85,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','AddressTypeOld',91,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UbanizationNameOld',92,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PrimaryNumberOld',120,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PreDirectionalOld',130,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetNameOld',132,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetSuffixOld',160,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PostDirectionalOld',164,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UnitDesignatorOld',166,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','SecondaryNumberOld',170,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','CityOld',180,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StateOld',208,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','FiveDigitZipCodeOld',210,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','AddressTypeNew',215,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UbanizationNameNew',216,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PrimaryNumberNew',244,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PreDirectionalNew',254,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetNameNew',256,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetSuffixNew',284,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PostDirectionalNew',288,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UnitDesignatorNew',290,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','SecondaryNumberNew',294,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','CityNew',304,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StateNew',332,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','FiveDigitZipCodeNew',334,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','HYPHEN','Hypen',339,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','Plus4CodeNew',340,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','DPBCNew',344,3)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','LabelFormatNewAddress',347,66)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FeeNotification',413,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',414,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','PostageDue',415,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PMB',419,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','NotificationType',427,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','IntelligentMailBarcode',428,31)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',459,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','NineDigitMailerID',460,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','IMPackageBarcode',469,35)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',504,56)



SELECT @Schema_ID = USPS_ACS_Schema_ID
FROM [USPS_ACS_Schemas]
WHERE FileVersion = '01'

INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','FileVersion',2,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CustomerID',4,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CreateDate',10,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','ShipmentNumber',18,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalACSRecordCount',28,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalCOACount',37,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalNIXIECount',46,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDRecordCount',55,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDACSFeeAmount',64,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDCOACount',75,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDCOAACSFeeAmount',84,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDNixieCount',95,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDNixieACSFeeAmount',104,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDRecordCount',115,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDACSFeeAmount',124,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDCOACount',135,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDCOAACSFeeAmount',144,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDNixieCount',155,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDNixieACSFeeAmount',164,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSRecordCount',175,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSACSFeeAmount',184,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSCOACount',195,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSCOAACSFeeAmount',204,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSNixieCount',215,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSNixieFeeAmount',224,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbRecordCount',235,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbACSFeeAmount',244,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbCOACount',255,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbCOAFeeAmount',264,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbNixieCount',275,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbNixieFeeAmount',284,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','Filler',295,405)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','EndMarker',700,1)

INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','FileVersion',2,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','SequenceNumber',4,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','ParticipantID',12,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Sequence',21,16)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','MoveEffectiveDate',37,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','MoveType',45,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','DelivierabilityCode',46,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','PostalServiceSiteID',47,3)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','LastName',50,20)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','FirstName-MiddleName-INITIALS',70,15)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Prefix',85,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Suffix',91,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','AddressTypeOld',97,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UbanizationNameOld',98,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PrimaryNumberOld',126,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PreDirectionalOld',136,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetNameOld',138,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetSuffixOld',166,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PostDirectionalOld',170,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UnitDesignatorOld',172,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','SecondaryNumberOld',176,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','CityOld',186,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StateOld',214,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','FiveDigitZipCodeOld',216,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','AddressTypeNew',221,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PRBNew',222,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UbanizationNameNew',230,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PrimaryNumberNew',258,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PreDirectionalNew',268,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetNameNew',270,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetSuffixNew',298,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PostDirectionalNew',302,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UnitDesignatorNew',304,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','SecondaryNumberNew',308,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','CityNew',318,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StateNew',346,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','FiveDigitZipCodeNew',348,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','HYPHEN','Hypen',353,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','Plus4CodeNew',354,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','NewDeliveryPoint',358,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT ','NewAbbreviateCityName',360,13)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','NewAddressLabel',373,66)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','FeeNotification',439,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXTS','NotificationType',440,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','IntelligentMailBarcode(IMb)',441,31)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','IntelligentMailpackagebarcode(IMpb)',472,35)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','IDTag_UPU',507,16)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','HardcopytoElectronicFlag',523,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','TypeofACS(T_O_F_I)',524,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','FulfillmentDate',525,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','ProcessingType(C_P_R_F)',533,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','CaptureType(I_C_F_Blank)',534,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','MadeAvailableDate',535,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','ShapeofMail(L_F_P)',543,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','MailActionCode(F_R_D_X_U)',544,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','COA_NixieFlag(C_N)',545,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode1',546,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee1',552,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode2',558,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee2',564,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode3',570,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee3',576,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode4',582,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee4',588,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode5',594,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee5',600,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode6',606,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee6',612,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Filler',618,82)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','EndMarker',700,1)

GO

select *
from [dbo].[USPS_ACS_SchemaMapping]