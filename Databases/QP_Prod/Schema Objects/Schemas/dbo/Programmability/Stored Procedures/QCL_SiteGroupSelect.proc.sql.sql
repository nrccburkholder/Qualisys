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