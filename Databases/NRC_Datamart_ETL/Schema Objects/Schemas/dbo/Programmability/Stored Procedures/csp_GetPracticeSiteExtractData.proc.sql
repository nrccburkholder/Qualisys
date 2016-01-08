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
