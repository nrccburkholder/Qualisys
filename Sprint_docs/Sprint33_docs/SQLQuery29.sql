USE [QP_Prod]
GO

DECLARE @ExtractFileId int = 594
	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	--EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;
	
	declare @EntityTypeID int
	set @EntityTypeID = 6 -- SampleUnit

SELECT [PracticeSite_ID]
      ,[AssignedID]
      ,[SiteGroup_ID]
      ,[PracticeName]
      ,[Addr1]
      ,[Addr2]
      ,[City]
      ,[ST]
      ,[Zip5]
      ,[Phone]
      ,[PracticeOwnership]
      ,[PatVisitsWeek]
      ,[ProvWorkWeek]
      ,[PracticeContactName]
      ,[PracticeContactPhone]
      ,[PracticeContactEmail]
      ,ps.[SampleUnit_id]
      ,[bitActive]
  FROM [dbo].[PracticeSite] ps
  inner join dbo.SAMPLEUNIT su with (NOLOCK) on ps.PracticeSite_ID = su.SUFacility_ID and su.[CAHPSType_id] = 4
  inner join (select distinct PKey1 
                        from ExtractHistory with (NOLOCK)
                        where ExtractFileID = @ExtractFileId
						and EntityTypeID = @EntityTypeID
						and IsDeleted = 0 ) eh  on su.SAMPLEUNIT_ID = eh.PKey1



