-- ================================================================================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetClientExtractData
-- Create date: 3/01/2009 
-- Description:	Extracts client data from QP_Prod tables
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 3/22/2011 kmn modifed logic to extact client group data and removed logic for deletes
-- =================================================================================================
CREATE PROCEDURE [dbo].[csp_GetClientExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 1 -- Client Entity

	select distinct client.CLIENT_ID as id, client.STRCLIENT_NM as name,client.ClientGroup_ID AS clientGroup_ID, client.Active as activeFlag,'false' as deleteEntity
	  from QP_PROD.dbo.CLIENT client with (NOLOCK)
			inner join (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh on client.CLIENT_ID = eh.PKey1	        
	                  	
	for xml auto


