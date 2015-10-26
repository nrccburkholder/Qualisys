/*          
Business Purpose:           
This procedure is used to support the Qualisys Class Library.  It will return all facilities for an AHAId.      
          
Created: 3/14/2006 by DC      
          
Modified: 7/30/08 MB Removed join to MedicareLookup as it is no longer needed
        
      
*/              
CREATE PROCEDURE [dbo].[QCL_SelectFacilityByAHAId]
@AHA_ID int
AS
EXEC [dbo].[QCL_SelectAllFacilities] null, null, null, @AHA_id


