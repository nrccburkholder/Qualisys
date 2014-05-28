/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It will return all facility regions.
    
Created: 3/14/2006 by DC
    
Modified:    
		

*/        
CREATE PROCEDURE [dbo].[QCL_SelectAllFacilityRegions]
AS

SELECT region_id, strRegion_nm
FROM Region 
ORDER BY strRegion_nm


