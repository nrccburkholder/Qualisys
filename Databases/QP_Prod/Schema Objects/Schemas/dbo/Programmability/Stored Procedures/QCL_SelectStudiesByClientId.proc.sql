CREATE PROCEDURE [dbo].[QCL_SelectStudiesByClientId]
@ClientId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT Study_id, strStudy_nm, strStudy_dsc, Client_id, ADEmployee_id,
	DATCREATE_DT, BITCLEANADDR, bitProperCase, Active
FROM Study   
WHERE Client_id = @ClientId
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


