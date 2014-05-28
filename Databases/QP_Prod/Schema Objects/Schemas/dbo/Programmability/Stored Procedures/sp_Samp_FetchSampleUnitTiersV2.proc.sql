/***********************************************************************************************************************************
SP Name: sp_Samp_FetchSampleUnitTiersV2
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 02/05/2004
Author(s): DC 
Revision: First build - 02/05/2004
9/29/09 MWB modified *= syntax to left outer join for sql 2008 upgrade
***********************************************************************************************************************************/
CREATE    PROCEDURE sp_Samp_FetchSampleUnitTiersV2
 @intSurvey_id int,
 @intsampleset_id int
AS

	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_FetchSampleUnitTiers', getdate())

 CREATE TABLE #SampleUnit_Tier
  (SampleUnit_id int, ParentSampleUnit_id int, Tier int)
 INSERT INTO #SampleUnit_Tier
  SELECT SU.SampleUnit_id, SU.ParentSampleUnit_id, 
   CASE WHEN su.ParentSampleUnit_id IS NULL 
    THEN 1 
    ELSE count(*) + 1 
   END AS Tier
  FROM  dbo.SampleUnit SU 
		left outer join dbo.SampleUnitTreeIndex SUTI on SU.SampleUnit_id = SUTI.SampleUnit_id 
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

  SELECT sampleunit_Id, intTarget as intOutgo
  INTO #unitTargets
  FROM dbo.samplesetunittarget 
  WHERE SampleSet_id = @intSampleSet_id

 SELECT stc.SampleUnit_id, IntOutgo
  FROM #SampleUnit_Tier_Count stc, #unitTargets ut
  WHERE stc.sampleunit_id=ut.sampleunit_id
  ORDER BY Tier, numUniverseCount

 UPDATE spw
 SET spw.intTier = sut.Tier
  FROM SamplePlanWorkSheet spw, #SampleUnit_Tier sut
  WHERE spw.SampleUnit_id = sut.SampleUnit_id
   AND spw.intTier IS NULL


--drop table dc_tierstest
 --SELECT stc.SampleUnit_id, Tier, numUniverseCount, IntOutgo
 --INTO dc_tierstest
 -- FROM #SampleUnit_Tier_Count stc, #unitTargets ut
 -- WHERE stc.sampleunit_id=ut.sampleunit_id
 -- ORDER BY Tier, numUniverseCount

 DROP TABLE #SampleUnit_Tier
 DROP TABLE #SampleUnit_Tier_Count


