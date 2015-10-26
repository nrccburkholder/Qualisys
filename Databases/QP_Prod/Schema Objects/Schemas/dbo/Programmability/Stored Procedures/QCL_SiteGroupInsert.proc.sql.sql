CREATE PROCEDURE QCL_SiteGroupInsert

@AssignedID nvarchar(20),
@GroupName nvarchar(50),
@Addr1 nvarchar(60),
@Addr2 nvarchar(42),
@City nvarchar(42),
@ST nvarchar(2),
@Zip5 nvarchar(5),
@Phone nvarchar(13),
@GroupOwnership nvarchar(2),
@GroupContactName nvarchar(50),
@GroupContactPhone nvarchar(10),
@GroupContactEmail nvarchar(50),
@MasterGroupID int,
@MasterGroupName varchar(50),
@bitActive bit

AS
BEGIN

INSERT INTO [dbo].[SiteGroup]
           ([AssignedId]
		   ,[GroupName]
           ,[Addr1]
           ,[Addr2]
           ,[City]
           ,[ST]
           ,[Zip5]
           ,[Phone]
           ,[GroupOwnership]
           ,[GroupContactName]
           ,[GroupContactPhone]
           ,[GroupContactEmail]
           ,[MasterGroupID]
           ,[MasterGroupName]
           ,[bitActive])
     VALUES
           (@AssignedId
		   ,@GroupName
           ,@Addr1
           ,@Addr2
           ,@City
           ,@ST
           ,@Zip5
           ,@Phone
           ,@GroupOwnership
           ,@GroupContactName
           ,@GroupContactPhone
           ,@GroupContactEmail
           ,@MasterGroupID
           ,@MasterGroupName
           ,@bitActive
		   )

SELECT SCOPE_IDENTITY()

END