/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectPartialMatches]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_SelectPartialMatches]
@MarkNotified as bit = 0

AS
BEGIN
	SELECT [USPS_ACS_ExtractFile_PartialMatch_id]
      ,pm.[Study_id]
      ,pm.[Pop_id]
      ,PM.[strLithocode]
      ,pm.[Status]
      ,pm.[FullMatch]
      ,pm.[popFname]
      ,pm.[popLname]
      ,pm.[popAddr]
      ,pm.[popAddr2]
      ,pm.[popCity]
      ,pm.[popSt]
      ,pm.[popZip5]
      ,pm.[USPS_ACS_ExtractFile_Work_ID]
      ,pm.[USPS_ACS_ExtractFile_ID]
      ,pm.[FName]
      ,pm.[LName]
      ,pm.[PrimaryNumberOld]
      ,pm.[PreDirectionalOld]
      ,pm.[StreetNameOld]
      ,pm.[StreetSuffixOld]
      ,pm.[PostDirectionalOld]
      ,pm.[UnitDesignatorOld]
      ,pm.[SecondaryNumberOld]
      ,pm.[CityOld]
      ,pm.[StateOld]
      ,pm.[Zip5Old]
      ,pm.[PrimaryNumberNew]
      ,pm.[PreDirectionalNew]
      ,pm.[StreetNameNew]
      ,pm.[StreetSuffixNew]
      ,pm.[PostDirectionalNew]
      ,pm.[UnitDesignatorNew]
      ,pm.[SecondaryNumberNew]
      ,pm.[CityNew]
      ,pm.[StateNew]
      ,pm.[Zip5New]
      ,pm.[Plus4ZipNew]
      ,pm.[AddressNew]
      ,pm.[Address2New]
	INTO #PartialMatches
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
	WHERE ef.IsNotified = 0

	-- set IsNotified to 1 for each partial match returned
	if @MarkNotified = 1
	begin
		Update ef
			SET IsNotified = 1
		FROM USPS_ACS_ExtractFile ef
		INNER JOIN #PartialMatches pm ON pm.USPS_ACS_ExtractFile_ID = ef.USPS_ACS_ExtractFile_ID
	end

	SELECT *
	FROM #PartialMatches

	DROP TABLE #PartialMatches

END

GO