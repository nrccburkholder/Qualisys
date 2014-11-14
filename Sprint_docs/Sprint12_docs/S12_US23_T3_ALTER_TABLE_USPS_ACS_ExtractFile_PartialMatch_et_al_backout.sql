/*
S12.US23 USPS Partial and multiple match resolution
		 USPS Partial and multiple match resolution in Qualisys Explorer rather than emailing 

	Add UpdateStatus and DateUpdated columns to USPS_ACS_ExtractFile_PartialMatch

Tim Butler


*** BACKOUTS for the following ***
ALTER TABLE [dbo].[USPS_ACS_ExtractFile_PartialMatch]
CREATE FUNCTION USPS_ACS_FormatUSPSAddress1
CREATE FUNCTION USPS_ACS_FormatUSPSAddress2 
INSERT INTO [dbo].[ReceiptType]
CREATE PROCEDURE USPS_ACS_UpdatePartialMatchStatus
CREATE PROCEDURE [dbo].[USPS_ACS_SelectPartialMatchesDataSetByStatus]

*/
use qp_prod
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'UpdateStatus' )

	alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch] drop column UpdateStatus
go

if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'DateUpdated' )

	alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch] drop column DateUpdated
go
commit tran

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USPS_ACS_FormatUSPSAddress1]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))	
	DROP FUNCTION [dbo].[USPS_ACS_FormatUSPSAddress1]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USPS_ACS_FormatUSPSAddress2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))	
	DROP FUNCTION [dbo].[USPS_ACS_FormatUSPSAddress2]
GO

begin tran
go

IF EXISTS(Select 1 FROM [dbo].[ReceiptType] WHERE ReceiptType_nm = 'USPS Address Change')
	DELETE FROM [dbo].[ReceiptType]
	WHERE ReceiptType_nm = 'USPS Address Change'

commit tran

GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'USPS_ACS_UpdatePartialMatchStatus')
	DROP PROCEDURE dbo.USPS_ACS_UpdatePartialMatchStatus
GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'USPS_ACS_SelectPartialMatchesDataSetByStatus')
	DROP PROCEDURE dbo.USPS_ACS_SelectPartialMatchesDataSetByStatus
GO

GO