-- ================================================================================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetClientGroupExtractData
-- Create date: 3/22/2011 
-- Description:	Extracts client group data from QP_Prod tables
-- History: 1.0  3/22/2011   by Kathi Nussralalh
-- =================================================================================================
CREATE PROCEDURE [dbo].[csp_GetClientGroupExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 16 -- ClientGroup Entity

	select distinct clientGroup.ClientGroup_ID as id, clientGroup.ClientGroup_nm as name,clientGroup.ClientGroupReporting_nm,clientGroup.Active as activeFlag,'false' as deleteEntity
	  from QP_PROD.dbo.ClientGroups clientGroup with (NOLOCK)
			inner join (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) client on clientGroup.ClientGroup_ID = client.PKey1
	      
	                  	
	for xml auto


