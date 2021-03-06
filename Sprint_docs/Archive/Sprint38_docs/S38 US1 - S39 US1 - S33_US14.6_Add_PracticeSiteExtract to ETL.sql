/*

S38 US1 - S39 US1 - S33_US14.6_Add_PracticeSiteExtract to ETL

Move CGCAHPS sites and groups from datamart tables into stage for Rachel and flip the QualPro param to turn this on See note on this task..

S33 US14 CG SUFacility Update	As a Research Associate, I want the SUFacility field populated for all CG-CAHPS units, so that the data is available for benchmarks. notes: Populate based on sampleunit in Medusa practice table where available. Depending on volume of remaining unmapped units, may want a mass update/bulk insert.

TASK 14.6	Cue the PracticeSite table to be sent in the Catalyst ETL for hook-up alongside SUFacility

Chris Burkholder / Tim Butler

DROP / CREATE TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_PracticeSite] 
DROP / CREATE PROCEDURE [dbo].[csp_GetPracticeSiteExtractData] 
DROP / CREATE TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SiteGroup] 
DROP / CREATE PROCEDURE [dbo].[csp_GetSiteGroupExtractData] 


*/

/* PracticeSite */

USE [QP_Prod]
GO


IF EXISTS (SELECT *   
               FROM   sys.objects   
               WHERE  [type] = 'TR'  
               AND    [name] = 'trg_NRC_DataMart_ETL_dbo_PracticeSite')   
	DROP TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_PracticeSite]
GO

CREATE TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_PracticeSite] 
   ON  [dbo].[PracticeSite] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON

	insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)
		select 6, su.SAMPLEUNIT_ID, NULL, 1 ,'trg_NRC_DataMart_ETL_dbo_PracticeSite'
		  from INSERTED ps
				inner join SAMPLEUNIT su on su.SUFacility_ID =  ps.PracticeSite_ID
				inner join SAMPLEPLAN sp on su.SamplePlan_ID = sp.SamplePlan_ID
				where dbo.SurveyProperty('FacilitiesArePracticeSites',null,sp.Survey_ID) = 1
END

GO




USE [NRC_DataMart_ETL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'csp_GetPracticeSiteExtractData')
DROP PROCEDURE [dbo].[csp_GetPracticeSiteExtractData] 

USE [NRC_DataMart_ETL]
GO

CREATE PROCEDURE [dbo].[csp_GetPracticeSiteExtractData] 
	@ExtractFileID int
AS
BEGIN
	SET NOCOUNT ON 


	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;
	
	declare @EntityTypeID int
	set @EntityTypeID = 6

		SELECT practiceSite.[PracticeSite_ID] as practiceSite_id
		  ,practiceSite.[AssignedID] as assignedid
		  ,practiceSite.[SiteGroup_ID] as sitegroup_id
		  ,practiceSite.[PracticeName] as practiceName
		  ,practiceSite.[Addr1] as addr1
		  ,practiceSite.[Addr2] as addr2
		  ,practiceSite.[City] as city
		  ,practiceSite.[ST] as state
		  ,practiceSite.[Zip5] as zip5
		  ,practiceSite.[Phone] as phone
		  ,practiceSite.[PracticeOwnership] as practiceOwnership
		  ,practiceSite.[PatVisitsWeek] as patVisitsWeek
		  ,practiceSite.[ProvWorkWeek] as provWorkWeek
		  ,practiceSite.[PracticeContactName] as practiceContactName
		  ,practiceSite.[PracticeContactPhone] as practiceContactPhone
		  ,practiceSite.[PracticeContactEmail] as practiceContactEmail
		  ,isnull(practiceSite.[SampleUnit_id], su.SampleUnit_id)	as sampleunit_id
		  ,practiceSite.[bitActive] as isActive
	  FROM QP_Prod.[dbo].[PracticeSite] practiceSite
	  inner join QP_Prod.dbo.SAMPLEUNIT su with (NOLOCK) on practiceSite.PracticeSite_ID = su.SUFacility_ID
	  inner join (select distinct PKey1 
							from ExtractHistory with (NOLOCK)
							where ExtractFileID = @ExtractFileId
							and EntityTypeID = @EntityTypeID
							and IsDeleted = 0 ) eh  on su.SAMPLEUNIT_ID = eh.PKey1
	 
	for xml auto


	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2;

END


GO


/*  SiteGroup */

USE [QP_Prod]
GO


IF EXISTS (SELECT *   
               FROM   sys.objects   
               WHERE  [type] = 'TR'  
               AND    [name] = 'trg_NRC_DataMart_ETL_dbo_SiteGroup')   
	DROP TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SiteGroup]
GO



CREATE TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SiteGroup] 
   ON  [dbo].[SiteGroup] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON

	insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)
		select 6, su.SAMPLEUNIT_ID, NULL, 1 ,'trg_NRC_DataMart_ETL_dbo_SiteGroup'
		  from INSERTED sg
				inner join PracticeSite ps on ps.SiteGroup_ID = sg.SiteGroup_ID
				inner join SAMPLEUNIT su on su.SUFacility_ID =  ps.PracticeSite_ID
				inner join SAMPLEPLAN sp on su.SamplePlan_ID = sp.SamplePlan_ID
				where dbo.SurveyProperty('FacilitiesArePracticeSites',null,sp.Survey_ID) = 1
END

GO

USE [NRC_DataMart_ETL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'csp_GetSiteGroupExtractData')
DROP PROCEDURE [dbo].[csp_GetSiteGroupExtractData] 


USE [NRC_DataMart_ETL]

GO
CREATE PROCEDURE [dbo].[csp_GetSiteGroupExtractData] 
	@ExtractFileID int
AS
BEGIN
	SET NOCOUNT ON 


	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;
	
	declare @EntityTypeID int
	set @EntityTypeID = 6


	SELECT distinct siteGroup.[SiteGroup_ID] as sitegroup_id
		  ,siteGroup.[AssignedID] as assignedid
		  ,siteGroup.[GroupName] as groupName
		  ,siteGroup.[Addr1] as addr1
		  ,siteGroup.[Addr2] as addr2
		  ,siteGroup.[City] as city
		  ,siteGroup.[ST] as state
		  ,siteGroup.[Zip5] as zip5
		  ,siteGroup.[Phone] as phone
		  ,siteGroup.[GroupOwnership] as groupOwnership
		  ,siteGroup.[GroupContactName] as groupContactName
		  ,siteGroup.[GroupContactPhone] as groupContactPhone
		  ,siteGroup.[GroupContactEmail] as groupContactEmail
		  ,siteGroup.[MasterGroupID] as masterGroupid
		  ,siteGroup.[MasterGroupName] as masterGroupName
		  ,siteGroup.[bitActive] as isActive
	  FROM QP_Prod.[dbo].[SiteGroup] siteGroup
	  inner join QP_Prod.dbo.PracticeSite ps on ps.SiteGroup_Id = siteGroup.SiteGroup_Id
	  inner join QP_Prod.dbo.SAMPLEUNIT su with (NOLOCK) on ps.PracticeSite_ID = su.SUFacility_ID
	  inner join (select distinct PKey1 
							from ExtractHistory with (NOLOCK)
							where ExtractFileID = @ExtractFileId
							and EntityTypeID = @EntityTypeID
							and IsDeleted = 0 ) eh  on su.SAMPLEUNIT_ID = eh.PKey1

	 
	for xml auto


	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2;

END


GO