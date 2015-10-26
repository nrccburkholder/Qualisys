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