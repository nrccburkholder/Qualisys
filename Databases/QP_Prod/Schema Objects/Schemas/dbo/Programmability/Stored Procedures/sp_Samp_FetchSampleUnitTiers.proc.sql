/****** Object:  Stored Procedure dbo.sp_Samp_FetchSampleUnitTiers    Script Date: 9/28/99 2:57:14 PM ******/  
/***********************************************************************************************************************************  
SP Name: sp_Samp_FetchSampleUnitTiers  
Part of:  Sampling Tool  
Purpose:    
Input:    
   
Output:    
Creation Date: 09/08/1999  
Author(s): DA, RC   
Revision: First build - 09/08/1999  
v2.0.1 - Brian Dohmen - 7/7/2003  
   Update SamplePlanWorkSheet table  
v2.0.2 - MWB 9/29/09
	Modified *= syntax to left outer join for SQL 2008 Upgrade.   
***********************************************************************************************************************************/  
CREATE    PROCEDURE sp_Samp_FetchSampleUnitTiers  
 @intSurvey_id int  
AS  
  
 CREATE TABLE #SampleUnit_Tier  
  (SampleUnit_id int, ParentSampleUnit_id int, Tier int)  
 INSERT INTO #SampleUnit_Tier  
  SELECT SU.SampleUnit_id, SU.ParentSampleUnit_id,   
   CASE WHEN su.ParentSampleUnit_id IS NULL   
    THEN 1   
    ELSE count(*) + 1   
   END AS Tier  
  FROM dbo.SampleUnit SU left outer join dbo.SampleUnitTreeIndex SUTI on SU.SampleUnit_id=SUTI.SampleUnit_id
						 inner join dbo.SamplePlan SP on SP.SamplePlan_id = SU.SamplePlan_id
  WHERE SP.Survey_id = @intSurvey_id  
  GROUP BY SU.SampleUnit_id, SU.ParentSampleUnit_id  
  ORDER BY COUNT(*)  
 CREATE TABLE #SampleUnit_Tier_Count  
  (SampleUnit_id int, ParentSampleUnit_id int, Tier int, numUniverseCount int)  
   
 INSERT INTO #SampleUnit_Tier_Count  
  SELECT SUT.SampleUnit_id, SUT.ParentSampleUnit_id, SUT.Tier, COUNT(*)  
   FROM #SampleUnit_Tier SUT, #SampleUnit_Universe SUU  
   WHERE SUT.SampleUnit_id = SUU.SampleUnit_id  
    AND SUU.Removed_Rule = 0  
   GROUP BY SUT.SampleUnit_id, SUT.ParentSampleUnit_id, SUT.Tier  
  
 SELECT SampleUnit_id   
  FROM #SampleUnit_Tier_Count  
  ORDER BY Tier, numUniverseCount  
  
 UPDATE spw  
 SET spw.intTier = sut.Tier  
  FROM SamplePlanWorkSheet spw, #SampleUnit_Tier sut  
  WHERE spw.SampleUnit_id = sut.SampleUnit_id  
   AND spw.intTier IS NULL  
  
 DROP TABLE #SampleUnit_Tier  
 DROP TABLE #SampleUnit_Tier_Count


