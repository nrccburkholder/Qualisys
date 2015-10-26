/*              
Business Purpose:               
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.          
              
Created: 3/14/2006 by DC          
              
Modified:              
            
          
*/    
CREATE PROCEDURE [dbo].[QCL_SelectFacilityByClientId]
@Client_id int,
@IncludePracticeSite bit = null
AS
EXEC [dbo].[QCL_SelectAllFacilities] @IncludePracticeSite, null, @Client_id


