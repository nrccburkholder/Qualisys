CREATE PROCEDURE QCL_PracticeSiteInsert

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