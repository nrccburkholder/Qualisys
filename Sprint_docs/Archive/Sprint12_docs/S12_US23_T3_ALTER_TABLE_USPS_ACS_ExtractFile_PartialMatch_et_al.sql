/*
S12.US23 USPS Partial and multiple match resolution
		 USPS Partial and multiple match resolution in Qualisys Explorer rather than emailing 

	Add UpdateStatus and DateUpdated columns to USPS_ACS_ExtractFile_PartialMatch

Tim Butler

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
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'UpdateStatus' )

	alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch] add UpdateStatus tinyint NOT NULL default(0)
go

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'DateUpdated' )

	alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch] add DateUpdated datetime
go
commit tran
go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USPS_ACS_FormatUSPSAddress1]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))	
	DROP FUNCTION [dbo].[USPS_ACS_FormatUSPSAddress1]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Butler
-- Create date: 2014.10.31
-- Description:	Concatenate address elements for the USPS ACS addresses
-- =============================================
CREATE FUNCTION USPS_ACS_FormatUSPSAddress1 
(
	@PrimaryNumber varchar(10),
	@PreDirectional varchar(2),
	@StreetName varchar(28),
	@StreetSuffix varchar(4),
	@PostDirectional varchar(2)
)
RETURNS VARCHAR(66)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(66)

	SET @ResultVar = ''

	IF LEN(LTRIM(RTRIM(@PrimaryNumber))) > 0
		SET @ResultVar = @ResultVar + @PrimaryNumber + ' '

	IF LEN(LTRIM(RTRIM(@PreDirectional))) > 0
	SET @ResultVar = @ResultVar + @PreDirectional + ' '

	IF LEN(LTRIM(RTRIM(@StreetName))) > 0
	SET @ResultVar = @ResultVar + @StreetName + ' '

	IF LEN(LTRIM(RTRIM(@StreetSuffix))) > 0
	SET @ResultVar = @ResultVar + @StreetSuffix + ' '

	IF LEN(LTRIM(RTRIM(@PostDirectional))) > 0
	SET @ResultVar = @ResultVar + @PostDirectional

	-- Return the result of the function
	RETURN @ResultVar

END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USPS_ACS_FormatUSPSAddress2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))	
	DROP FUNCTION [dbo].[USPS_ACS_FormatUSPSAddress2]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Butler
-- Create date: 2014.10.31
-- Description:	Concatenate address elements for the USPS ACS addresses
-- =============================================
CREATE FUNCTION USPS_ACS_FormatUSPSAddress2 
(
	@UnitDesignator varchar(4),
	@SecondaryNumber varchar(10)
)
RETURNS VARCHAR(14)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(66)

	SET @ResultVar = ''

	IF LEN(LTRIM(RTRIM(@UnitDesignator))) > 0
		SET @ResultVar = @ResultVar + @UnitDesignator + ' '

	IF LEN(LTRIM(RTRIM(@SecondaryNumber))) > 0
	SET @ResultVar = @ResultVar + @SecondaryNumber

	-- Return the result of the function
	RETURN @ResultVar

END
GO

begin tran
go


IF NOT EXISTS(Select 1 FROM [dbo].[ReceiptType] WHERE ReceiptType_nm = 'USPS Address Change')
	INSERT INTO [dbo].[ReceiptType]
			   ([ReceiptType_nm]
			   ,[ReceiptType_dsc]
			   ,[bitUIDisplay]
			   ,[TranslationCode])
		 VALUES
			   ('USPS Address Change'
			   ,'USPS Address Change'
			   ,0
			   ,NULL)
GO
commit tran

GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'USPS_ACS_UpdatePartialMatchStatus')
	DROP PROCEDURE dbo.USPS_ACS_UpdatePartialMatchStatus
GO

CREATE PROCEDURE USPS_ACS_UpdatePartialMatchStatus
	@Id as int
	,@status as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE [dbo].[USPS_ACS_ExtractFile_PartialMatch]
	   SET[UpdateStatus] = @status
		  ,[DateUpdated] = Getdate()
	 WHERE USPS_ACS_ExtractFile_PartialMatch_id = @Id


END
GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'USPS_ACS_SelectPartialMatchesDataSetByStatus')
	DROP PROCEDURE dbo.USPS_ACS_SelectPartialMatchesDataSetByStatus
GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectPartialMatchesDataSetByStatus]    Script Date: 10/31/2014 11:35:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_SelectPartialMatchesDataSetByStatus]
@Status as int = 0
,@FromDate as varchar(10)
,@ToDate as varchar(10)

AS
BEGIN

	CREATE TABLE #PartialMatches 
	(USPS_ACS_ExtractFile_PartialMatch_id int,
     DateCreated datetime ) 

	 IF LEN(@FromDate) = 0 or LEN(@ToDate) = 0
		INSERT INTO #PartialMatches
		SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id], ef.DateCreated
		FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
		INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
		WHERE pm.UpdateStatus = @status
	ELSE
		INSERT INTO #PartialMatches
		SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id], ef.DateCreated
		FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
		INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
		WHERE pm.UpdateStatus = @status
		AND ef.DateCreated between @FromDate and @ToDate
	
	
	SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id] Id
	  ,tpm.DateCreated
      ,pm.[Study_id]
      ,pm.[Pop_id]
      ,PM.[strLithocode] Lithocode
      ,pm.[Status]
      ,pm.[FullMatch]
      ,pm.[USPS_ACS_ExtractFile_Work_ID]
      ,pm.[USPS_ACS_ExtractFile_ID] 
	  ,CASE pm.UpdateStatus WHEN 1 THEN CAST(pm.UpdateStatus as varchar) ELSE '0' END Updated -- placeholder for binding to the Updated checkbox in the Qualisys Explorer Grid
	  ,CASE pm.UpdateStatus WHEN 2 THEN '1' ELSE '0' END Ignored -- placeholder for binding to the Ignored checkbox in the Qualisys Explorer Grid
	  ,pm.UpdateStatus
	  ,pm.DateUpdated
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN #PartialMatches tpm ON tpm.USPS_ACS_ExtractFile_PartialMatch_id = pm.USPS_ACS_ExtractFile_PartialMatch_id


	SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id] Id
		,1 [Order]
	  ,'Qualisys' AddressType     
      ,pm.[popFname] FName
      ,pm.[popLname] LName
      ,pm.[popAddr] Addr
      ,pm.[popAddr2] Addr2
      ,pm.[popCity] City
      ,pm.[popSt] [State]
      ,pm.[popZip5] Zip5
	  ,'' Plus4Zip
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN #PartialMatches tpm ON tpm.USPS_ACS_ExtractFile_PartialMatch_id = pm.USPS_ACS_ExtractFile_PartialMatch_id
	UNION
		SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id] Id
		,2 [Order]
	  ,'USPS Old' AddressType     
      ,pm.[FName]
      ,pm.[LName]
      ,dbo.USPS_ACS_FormatUSPSAddress1(pm.[PrimaryNumberOld] 
									  ,pm.[PreDirectionalOld]
									  ,pm.[StreetNameOld]
									  ,pm.[StreetSuffixOld] 
									  ,pm.[PostDirectionalOld]) Addr
      ,dbo.USPS_ACS_FormatUSPSAddress2(pm.[UnitDesignatorOld] 
									   ,pm.[SecondaryNumberOld]) Addr2
      ,pm.[CityOld] City
      ,pm.[StateOld] [State]
      ,pm.[Zip5Old] Zip5
	  ,'' Plus4Zip
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN #PartialMatches tpm ON tpm.USPS_ACS_ExtractFile_PartialMatch_id = pm.USPS_ACS_ExtractFile_PartialMatch_id
	UNION
		SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id] Id
		,3 [Order]
		,'USPS New' AddressType   
      ,pm.[FName]
      ,pm.[LName]
       ,dbo.USPS_ACS_FormatUSPSAddress1(pm.[PrimaryNumberNew] 
									  ,pm.[PreDirectionalNew]
									  ,pm.[StreetNameNew]
									  ,pm.[StreetSuffixNew] 
									  ,pm.[PostDirectionalNew]) Addr
      ,dbo.USPS_ACS_FormatUSPSAddress2(pm.[UnitDesignatorNew] 
									   ,pm.[SecondaryNumberNew]) Addr2
      ,pm.[CityNew] City
      ,pm.[StateNew] [State]
      ,pm.[Zip5New] Zip5
      ,pm.[Plus4ZipNew] Plus4Zip
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN #PartialMatches tpm ON tpm.USPS_ACS_ExtractFile_PartialMatch_id = pm.USPS_ACS_ExtractFile_PartialMatch_id
	ORDER BY Id, [Order]

	DROP TABLE #PartialMatches

END
GO