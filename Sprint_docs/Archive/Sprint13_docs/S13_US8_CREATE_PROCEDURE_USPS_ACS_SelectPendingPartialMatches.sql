/*
S13.US8	USPS Service Notification
		USPS Service Notification - remove PII from email
 

Tim Butler

CREATE PROCEDURE [dbo].[USPS_ACS_SelectPendingPartialMatches]

*/

USE [QP_Prod]
GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'USPS_ACS_SelectPendingPartialMatches')
	DROP PROCEDURE dbo.USPS_ACS_SelectPendingPartialMatches
GO


/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectPendingPartialMatches]    Script Date: 11/13/2014 9:45:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_SelectPendingPartialMatches]
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
	  ,pm.[UpdateStatus]
	  ,pm.[DateUpdated]
	  ,ef.DateCreated
	  ,CASE 
		WHEN DATEDIFF(dd,ef.DateCreated, GETDATE()) BETWEEN 7 AND 14 THEN 1
		WHEN DATEDIFF(dd,ef.DateCreated, GETDATE()) BETWEEN 15 AND 21 THEN 2
		WHEN DATEDIFF(dd,ef.DateCreated, GETDATE()) BETWEEN 22 AND 28 THEN 3
		WHEN DATEDIFF(dd,ef.DateCreated, GETDATE()) BETWEEN 29 AND 56 THEN 4
		WHEN DATEDIFF(dd,ef.DateCreated, GETDATE()) > 56 THEN  5
		ELSE 0
	  END AgeAlert
	  ,ef.IsNotified
	INTO #PartialMatches
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
	WHERE pm.UpdateStatus = 0

	-- set IsNotified to 1 for each partial match returned
	if @MarkNotified = 1
	begin
		Update ef
			SET IsNotified = 1
		FROM USPS_ACS_ExtractFile ef
		INNER JOIN #PartialMatches pm ON pm.USPS_ACS_ExtractFile_ID = ef.USPS_ACS_ExtractFile_ID
		WHERE pm.IsNotified = 0
	end

	SELECT *
	FROM #PartialMatches

	DROP TABLE #PartialMatches
END
