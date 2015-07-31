/*
-- =============================================
-- S30_R8_T1+S29_US26_T2_CGCAHPS_Group_And_Site_Tool_CRUD.sql
-- Create date: July, 2015
-- Description:	finish config manager group and sites tab with saves and updates and deactivation
--				Modify assign to clients tab to include groups; include CRUD

CREATE PROCEDURE QCL_SiteGroupSelect
CREATE PROCEDURE QCL_SiteGroupsAndPracticeSitesSelect
CREATE PROCEDURE QCL_PracticeSiteSelect
CREATE PROCEDURE QCL_SiteGroupUpdate
CREATE PROCEDURE QCL_SiteGroupInsert
CREATE PROCEDURE QCL_PracticeSiteUpdate
CREATE PROCEDURE QCL_PracticeSiteInsert
-- =============================================
*/
IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SiteGroupSelect')
	DROP PROCEDURE [dbo].[QCL_SiteGroupSelect] 
GO

CREATE PROCEDURE QCL_SiteGroupSelect
	@bitActive bit = null,
	@SiteGroup_id int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [SiteGroup_ID]
		  ,[AssignedID]
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
		  ,[bitActive]
		  ,0 as RecordState

	  FROM [dbo].[SiteGroup]
	  where ((@bitActive is null) or (bitActive = @bitActive)) AND
		  ((@SiteGroup_id is null) or (SiteGroup_ID = @SiteGroup_id))

END

GO

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_PracticeSiteSelect')
	DROP PROCEDURE [dbo].[QCL_PracticeSiteSelect] 
GO

CREATE PROCEDURE QCL_PracticeSiteSelect
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

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SiteGroupsAndPracticeSitesSelect')
	DROP PROCEDURE [dbo].[QCL_SiteGroupsAndPracticeSitesSelect] 
GO

CREATE PROCEDURE QCL_SiteGroupsAndPracticeSitesSelect
	@bitActive bit = null,
	@SiteGroup_id int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [dbo].[QCL_SiteGroupSelect] @bitActive, @SiteGroup_id

	EXEC [dbo].[QCL_PracticeSiteSelect] @bitActive, @SiteGroup_id

END

GO

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SiteGroupUpdate')
	DROP PROCEDURE [dbo].[QCL_SiteGroupUpdate] 
GO

CREATE PROCEDURE QCL_SiteGroupUpdate

@SiteGroup_Id int,
@bitActive bit,
@AssignedID int = null,
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
   SET [bitActive] = @bitActive
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

GO

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SiteGroupInsert')
	DROP PROCEDURE [dbo].[QCL_SiteGroupInsert] 
GO

CREATE PROCEDURE QCL_SiteGroupInsert

@AssignedID int,
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
END

GO

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_PracticeSiteUpdate')
	DROP PROCEDURE [dbo].[QCL_PracticeSiteUpdate] 
GO

CREATE PROCEDURE QCL_PracticeSiteUpdate

@PracticeSite_ID int,
@bitActive bit,
@AssignedID int = null,
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

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_PracticeSiteInsert')
	DROP PROCEDURE [dbo].[QCL_PracticeSiteInsert] 
GO

CREATE PROCEDURE QCL_PracticeSiteInsert

@AssignedID int,
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
END

GO