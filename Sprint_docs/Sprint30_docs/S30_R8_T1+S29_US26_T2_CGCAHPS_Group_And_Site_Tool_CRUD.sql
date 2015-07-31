/*
-- =============================================
-- S30_R8_T1+S29_US26_T2_CGCAHPS_Group_And_Site_Tool_CRUD.sql
-- Create date: July, 2015
-- Description:	finish config manager group and sites tab with saves and updates and deactivation
--				Modify assign to clients tab to include groups; include CRUD

CREATE PROCEDURE QCL_SelectAllSiteGroups
CREATE PROCEDURE QCL_SelectAllSiteGroupsAndPracticeSites
CREATE PROCEDURE QCL_SelectPracticeSites
-- =============================================
*/
IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectAllSiteGroups')
	DROP PROCEDURE [dbo].[QCL_SelectAllSiteGroups] 
GO

CREATE PROCEDURE QCL_SelectAllSiteGroups
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [dbo].[QCL_SelectAllSiteGroupsAndPracticeSites] null, false

END

GO

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectAllSiteGroupsAndPracticeSites')
	DROP PROCEDURE [dbo].[QCL_SelectAllSiteGroupsAndPracticeSites] 
GO

CREATE PROCEDURE QCL_SelectAllSiteGroupsAndPracticeSites
	@SiteGroup_id int = null,
	@IncludePracticeSites bit = true
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
	  where (@SiteGroup_id is null) or (SiteGroup_ID = @SiteGroup_id)

	if (@IncludePracticeSites = 1)
		EXEC [dbo].[QCL_SelectPracticeSites]

END

GO

-- =============================================

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectPracticeSites')
	DROP PROCEDURE [dbo].[QCL_SelectPracticeSites] 
GO

CREATE PROCEDURE QCL_SelectPracticeSites
	-- Add the parameters for the stored procedure here
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
	  where (@SiteGroup_id is null) or (SiteGroup_ID = @SiteGroup_id)


END

GO
