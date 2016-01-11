CREATE PROCEDURE QCL_SiteGroupUpdate

@SiteGroup_Id int,
@isActive bit,
@AssignedID nvarchar(20) = null,
@GroupName nvarchar(50) = null,
@Addr1 nvarchar(60) = null,
@Addr2 nvarchar(42) = null,
@City nvarchar(42) = null,
@ST nvarchar(2) = null,
@Zip5 nvarchar(5) = null,
@Phone nvarchar(13) = null,
@GroupOwnership nvarchar(2) = null,
@GroupContactName nvarchar(50) = null,
@GroupContactPhone nvarchar(10) = null,
@GroupContactEmail nvarchar(50) = null,
@MasterGroupID int = null,
@MasterGroupName varchar(50) = null

AS
BEGIN

UPDATE [dbo].[SiteGroup]
   SET [bitActive] = @isActive
      ,[AssignedID] = IsNull(@AssignedID, [AssignedId])
      ,[GroupName] = IsNull(@GroupName, [GroupName])
      ,[Addr1] = IsNull(@Addr1, [Addr1])
      ,[Addr2] = IsNull(@Addr2, [Addr2])
      ,[City] = IsNull(@City, [City])
      ,[ST] = IsNull(@ST, [ST])
      ,[Zip5] = IsNull(@Zip5, [Zip5])
      ,[Phone] = IsNull(@Phone, [Phone])
      ,[GroupOwnership] = IsNull(@GroupOwnership, [GroupOwnership])
      ,[GroupContactName] = IsNull(@GroupContactName, [GroupContactName])
      ,[GroupContactPhone] = IsNull(@GroupContactPhone, [GroupContactPhone])
      ,[GroupContactEmail] = IsNull(@GroupContactEmail, [GroupContactEmail])
      ,[MasterGroupID] = IsNull(@MasterGroupID, [MasterGroupID])
      ,[MasterGroupName] = IsNull(@MasterGroupName, [MasterGroupName])
 WHERE 
     [SiteGroup_Id] = @SiteGroup_Id
END