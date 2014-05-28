CREATE PROCEDURE sp_Samp_RollbackSample    
 @intSampleSet_id int    
AS    
 DECLARE @intStudy_id int    
 DECLARE @vcSQL varchar(8000)    
 DECLARE @intSurvey_ID int    
 DECLARE @intNotRollbackSampleSet_id int    
     
 SELECT @intStudy_id = SD.Study_id    
  FROM dbo.Survey_def SD, dbo.SampleSet SS    
  WHERE SD.Survey_id = SS.Survey_id    
   AND SS.SampleSet_id = @intSampleSet_id    
    
if exists (select schm.*    
from samplepop sp, scheduledmailing schm    
where sp.samplepop_id = schm.samplepop_id    
and study_id = @intstudy_id    
and sampleset_id = @intsampleset_id)    
    
   begin     
 print 'This is still scheduled you big dummy.'    
 return    
   end    
    
--  SET @vcSQL = 'DELETE    
--     FROM S' + CONVERT(varchar, @intStudy_id) + '.Unikeys    
--     WHERE SampleSet_id = ' + CONVERT(varchar, @intSampleSet_id)    
--  EXECUTE (@vcSQL)    
    
insert into rollbacks (survey_id, study_id, datrollback_dt, rollbacktype, cnt, datSampleCreate_dt)    
select ss.survey_id, sp.study_id, getdate(), 'Sampling' , count(*), datSampleCreate_dt    
from sampleset ss, samplepop sp    
where ss.sampleset_id = @intsampleset_id    
and ss.sampleset_id = sp.sampleset_id    
group by ss.survey_id, sp.study_id, ss.datSampleCreate_dt    
    
 /*     
  * Add by BMao, 1/8/03    
  * Update TeamStatus_SampleInfo    
  */    
 SELECT @intSurvey_ID = Survey_id    
   FROM dbo.SampleSet    
  WHERE SampleSet_id = @intSampleSet_id    
               
 UPDATE dbo.TeamStatus_SampleInfo    
    SET Rolledback = 1    
  WHERE SampleSet_id = @intSampleSet_id    
      
 UPDATE dbo.TeamStatus_SampleInfo    
    SET SamplesPulled = SamplesPulled - 1    
  WHERE Survey_id = @intSurvey_ID    
    AND SampleSet_id > @intSampleSet_id    
    
 SELECT @intNotRollbackSampleSet_id = MIN(SampleSet_id)    
   FROM dbo.TeamStatus_SampleInfo    
  WHERE Survey_id = @intSurvey_ID    
    AND SampleSet_id > @intSampleSet_id    
    AND RolledBack = 0    
     
 IF (@intNotRollbackSampleSet_id IS NULL)    
     UPDATE dbo.TeamStatus_SampleInfo    
        SET TotalRolledBack = TotalRolledBack + 1    
      WHERE Survey_id = @intSurvey_ID    
        AND SampleSet_id > @intSampleSet_id    
 ELSE    
     UPDATE dbo.TeamStatus_SampleInfo    
        SET TotalRolledBack = TotalRolledBack + 1    
      WHERE Survey_id = @intSurvey_ID    
        AND SampleSet_id > @intSampleSet_id    
        AND SampleSet_id <= @intNotRollbackSampleSet_id    
     
 /* End of add by BMao */    
                
 DELETE FROM dbo.SampleDataSet    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SelectedSample    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SamplePop    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SampleSet    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SamplePlanWorkSheet    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SPWDQCounts    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.Sampling_ExclusionLog    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.HCAHPSEligibleEncLog    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.HHCAHPSEligibleEncLog    
  WHERE SampleSet_id = @intSampleSet_id   
 DELETE FROM dbo.HHCAHPS_PatInfileCount
  WHERE SampleSet_id = @intSampleSet_id   
 
         
 --Added by DC 2-25-2004    
 --update the info in PeriodDates if it's not an oversample    
 --If this is an oversample, we want to delete the whole record    
IF EXISTS (SELECT SampleNumber    
    FROM perioddates pds, perioddef pd    
    WHERE pds.sampleset_id=@intSampleSet_id and    
    pds.perioddef_id=pd.perioddef_id and    
    pd.intexpectedsamples < sampleNumber)    
BEGIN    
 DELETE    
 FROM perioddates    
 WHERE sampleset_id=@intSampleSet_id    
END    
ELSE     
BEGIN    
  UPDATE dbo.PeriodDates    
  SET sampleset_id=null,    
  datsamplecreate_dt=null    
  WHERE SampleSet_id = @intSampleSet_id     
END    
 --End of Add DC


