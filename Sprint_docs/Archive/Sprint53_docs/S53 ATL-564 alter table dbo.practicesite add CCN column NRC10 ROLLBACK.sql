/*
	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S53 ATL-564 Add Hospital CCN Field to Practice Site Table & UI

	As a Research Associate, I want a column added to the Practice Site table for Affiliated Hospital CCN, so that I can link practices to Billians data for relevant benchmarks.

	Tim Butler

		QP_PROD
		alter CCN column to PracticeSite tables
		QCL_PracticeSiteInsert
		QCL_PracticeSiteSelect
		QCL_PracticeSiteUpdate

	NRC_Datamart_ETL
		csp_GetPracticeSiteExtractData

*/
use qp_prod
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'practicesite' 
					   AND sc.NAME = 'CCN' )
	alter table [dbo].[practicesite] drop column CCN
go

commit tran

go

USE [QP_Prod]
GO


ALTER PROCEDURE [dbo].[QCL_PracticeSiteInsert]

@AssignedID nvarchar(20),
@SiteGroup_ID int,
@PracticeName nvarchar(255),
@Addr1 nvarchar(255),
@Addr2 nvarchar(42),
@City nvarchar(42),
@ST nvarchar(2),
@Zip5 nvarchar(5),
@Phone nvarchar(10),
@PracticeOwnership nvarchar(2),
@PatVisitsWeek int,
@ProvWorkWeek int,
@PracticeContactName nvarchar(255),
@PracticeContactPhone nvarchar(10),
@PracticeContactEmail nvarchar(255),
@SampleUnit_id int,
@bitActive bit

AS

BEGIN

INSERT INTO [dbo].[PracticeSite]
           ([AssignedID]
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
           ,[SampleUnit_id]
           ,[bitActive])
     VALUES
           (@AssignedID
		   ,@SiteGroup_ID
           ,@PracticeName
           ,@Addr1
           ,@Addr2
           ,@City
           ,@ST
           ,@Zip5
           ,@Phone
           ,@PracticeOwnership
           ,@PatVisitsWeek
           ,@ProvWorkWeek
           ,@PracticeContactName
           ,@PracticeContactPhone
           ,@PracticeContactEmail
           ,@SampleUnit_id
           ,@bitActive)

SELECT SCOPE_IDENTITY()

END

GO

USE [QP_Prod]
GO


ALTER PROCEDURE [dbo].[QCL_PracticeSiteSelect]
	@bitActive bit = null,
	@SiteGroup_id int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
		  ,[SampleUnit_id]
		  ,[bitActive]
	  FROM [dbo].[PracticeSite]
	  where ((@bitActive is null) or (bitActive = @bitActive)) AND
		  ((@SiteGroup_id is null) or (SiteGroup_ID = @SiteGroup_id))

END

GO

USE [QP_Prod]
GO


ALTER PROCEDURE [dbo].[QCL_PracticeSiteUpdate]

@PracticeSite_ID int,
@bitActive bit,
@AssignedID nvarchar(20) = null,
@SiteGroup_ID int = null,
@PracticeName nvarchar(255) = null,
@Addr1 nvarchar(255) = null,
@Addr2 nvarchar(42) = null,
@City nvarchar(42) = null,
@ST nvarchar(2) = null,
@Zip5 nvarchar(5) = null,
@Phone nvarchar(10) = null,
@PracticeOwnership nvarchar(2) = null,
@PatVisitsWeek int = null,
@ProvWorkWeek int = null,
@PracticeContactName nvarchar(255) = null,
@PracticeContactPhone nvarchar(10) = null,
@PracticeContactEmail nvarchar(255) = null,
@SampleUnit_id int = null

AS
BEGIN

UPDATE [dbo].[PracticeSite]
   SET [bitActive] = @bitActive
      ,[AssignedID] = IsNull(@AssignedID, [AssignedID]) 
      ,[SiteGroup_ID] = IsNull(@SiteGroup_ID, [SiteGroup_ID])
      ,[PracticeName] = IsNull(@PracticeName, [PracticeName])
      ,[Addr1] = IsNull(@Addr1, [Addr1])
      ,[Addr2] = IsNull(@Addr2, [Addr2])
      ,[City] = IsNull(@City, [City])
      ,[ST] = IsNull(@ST, [ST])
      ,[Zip5] = IsNull(@Zip5, [Zip5])
      ,[Phone] = IsNull(@Phone, [Phone])
      ,[PracticeOwnership] = IsNull(@PracticeOwnership, [PracticeOwnership])
      ,[PatVisitsWeek] = IsNull(@PatVisitsWeek, [PatVisitsWeek])
      ,[ProvWorkWeek] = IsNull(@ProvWorkWeek, [ProvWorkWeek])
      ,[PracticeContactName] = IsNull(@PracticeContactName, [PracticeContactName])
      ,[PracticeContactPhone] = IsNull(@PracticeContactPhone, [PracticeContactPhone])
      ,[PracticeContactEmail] = IsNull(@PracticeContactEmail, [PracticeContactEmail])
      ,[SampleUnit_id] = IsNull(@SampleUnit_id, [SampleUnit_id])
 WHERE [PracticeSite_ID] = @PracticeSite_ID

END

GO

USE [NRC_DataMart_ETL]
GO


ALTER PROCEDURE [dbo].[csp_GetPracticeSiteExtractData] 
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
	  inner join QP_PROD.dbo.SAMPLEPLAN sp on su.SamplePlan_ID = sp.SamplePlan_ID
	  inner join (select distinct PKey1 
							from ExtractHistory with (NOLOCK)
							where ExtractFileID = @ExtractFileId
							and EntityTypeID = @EntityTypeID
							and IsDeleted = 0 ) eh  on su.SAMPLEUNIT_ID = eh.PKey1
	  where QP_PROD.dbo.SurveyProperty('FacilitiesArePracticeSites',null,sp.Survey_ID) = 1
	for xml auto


	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2;

END

GO
