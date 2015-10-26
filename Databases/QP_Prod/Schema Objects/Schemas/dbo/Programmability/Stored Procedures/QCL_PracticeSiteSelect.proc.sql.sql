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