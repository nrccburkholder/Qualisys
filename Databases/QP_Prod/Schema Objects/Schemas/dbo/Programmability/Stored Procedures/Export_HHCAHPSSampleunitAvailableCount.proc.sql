/*    
Business Purpose:     
This procedure is used to calculate the number of eligible discharges.  It    
is used IN the header record of the CMS export    
    
Created:	06/22/2006 by DC    
     
Modified:   
			4/15/2010 MWB: changed logic to count distinct pop_ID only instead of pop_ID,enc_ID 
			(which esentially counted distinct Enc_IDs)    
    
    
*/      
CREATE PROCEDURE [dbo].[Export_HHCAHPSSampleunitAvailableCount]    
 @Sampleunit_id INT,     
    @startDate DATETIME,     
    @EndDate DATETIME    
AS    
    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
select count(*)    
from (select distinct pop_id   
  from HHCAHPSEligibleEncLog    
  where sampleunit_id=@sampleunit_id    
   and SampleEncounterDate between @startDate and dateadd(s,-1,dateadd(d,1,@EndDate))) p


