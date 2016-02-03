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
