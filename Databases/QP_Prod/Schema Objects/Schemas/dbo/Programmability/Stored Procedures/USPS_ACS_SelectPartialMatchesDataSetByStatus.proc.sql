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