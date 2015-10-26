CREATE PROCEDURE QCL_PracticeSiteUpdate

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