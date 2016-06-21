USE [QP_Prod]
GO

truncate table usps_acs_schemas

INSERT INTO [dbo].[USPS_ACS_Schemas]
           ([SchemaName]
           ,[FileVersion]
           ,[DetailRecordIndicator]
           ,[RecordLength]
           ,[ExpiryDate])
     VALUES
           ('ACS Fulfillment File Format'
           ,'00'
           ,'2'
           ,559
           ,CAST('2015-01-24 23:59:59.99' as datetime)
		   )
GO

INSERT INTO [dbo].[USPS_ACS_Schemas]
           ([SchemaName]
           ,[FileVersion]
           ,[DetailRecordIndicator]
           ,[RecordLength]
           ,[ExpiryDate])
     VALUES
           ('ACS Fulfillment File Format New'
           ,'01'
           ,'D'
           ,700
           ,CAST('9999-12-31 23:59:59.99' as datetime)
		   )
GO

