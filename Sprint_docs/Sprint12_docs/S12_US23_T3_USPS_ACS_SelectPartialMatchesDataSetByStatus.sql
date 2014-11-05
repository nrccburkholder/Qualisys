USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectPartialMatchesDataSetByStatus]    Script Date: 10/31/2014 11:35:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USPS_ACS_SelectPartialMatchesDataSetByStatus]
@Status as int = 0

AS
BEGIN

	SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id], ef.DateCreated
	INTO #PartialMatches
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
	WHERE pm.UpdateStatus = @status
	
	
	SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id] Id
	  ,tpm.DateCreated
      ,pm.[Study_id]
      ,pm.[Pop_id]
      ,PM.[strLithocode] Lithocode
      ,pm.[Status]
      ,pm.[FullMatch]
      ,pm.[popFname] FirstName
      ,pm.[popLname] LastName
      ,pm.[popAddr] Addr
      ,pm.[popAddr2] Addr2
      ,pm.[popCity] City
      ,pm.[popSt] [State]
      ,pm.[popZip5] Zip
      ,pm.[USPS_ACS_ExtractFile_Work_ID]
      ,pm.[USPS_ACS_ExtractFile_ID] 
	  ,CAST(UpdateStatus as varchar) [Action]  -- needs to be cast as varchar otherwise the radiogroup column doesn't recognize the value
	  ,pm.DateUpdated
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN #PartialMatches tpm ON tpm.USPS_ACS_ExtractFile_PartialMatch_id = pm.USPS_ACS_ExtractFile_PartialMatch_id


		SELECT pm.[USPS_ACS_ExtractFile_PartialMatch_id] Id
		,1 [Order]
	  ,'OLD' AddressType     
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
		,2 [Order]
		,'NEW' AddressType   
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
