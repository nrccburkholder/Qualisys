/*
    ATL-718 Remove Systematic Sampling target record - rollback.sql

	Chris Burkholder

	9/15/2016

sp_helptext QCL_DeleteSampleSet
sp_helptext QCL_DeleteSystematicOutgo
sp_helptext QCL_CalculateSystematicSamplingOutgo
select top 1 * from SampleSet

ALTER PROCEDURE [dbo].[QCL_DeleteSampleSet]  
ALTER PROCEDURE dbo.QCL_DeleteSystematicOutgo
*/
Use [QP_Prod]
GO

ALTER PROCEDURE [dbo].[QCL_DeleteSampleSet]    
 @intSampleSet_id INT    
AS    
/*    
Business Purpose:     
    
This procedure is used to Remove a SampleSet.  This can only be executed IF the sample    
has not been Scheduled.    
    
Created:  1/30/2006 BY Dan Christensen    
    
Modified:    
   4/13/2010     added logic to delete from HHCAHPS_PatinFileCnt table when sampleset is deleted  
   4/15/2010     added logic to delete from HHCAHPSEligEncLog table when sampleset is deleted  
   9/27/2011 DRM added code to delete seeded mailing info
   5/14/2013 DRM added check for existence of encounter table before deleting from it
*/       
DECLARE @intStudy_id INT    
DECLARE @vcSQL VARCHAR(8000)    
DECLARE @intSurvey_ID INT    
DECLARE @intNotRollbackSampleSet_id INT    
    
SELECT @intStudy_id=SD.Study_id    
FROM dbo.Survey_def SD, dbo.SampleSet SS    
WHERE SD.Survey_id=SS.Survey_id    
AND SS.SampleSet_id=@intSampleSet_id    
    
IF EXISTS (SELECT schm.*    
FROM SamplePop sp, ScheduledMailing schm    
WHERE sp.SamplePop_id=schm.SamplePop_id    
AND Study_id=@intStudy_id    
AND SampleSet_id=@intSampleSet_id)    
    
BEGIN     
 RAISERROR ('This sample set is scheduled and cannot be deleted.', 16, 1)    
 RETURN    
END    
    
-- SET @vcSQL='DELETE    
-- FROM S' + CONVERT(varchar, @intStudy_id) + '.Unikeys    
-- WHERE SampleSet_id=' + CONVERT(varchar, @intSampleSet_id)    
-- EXECUTE (@vcSQL)    
    
INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, Rollbacktype, cnt, datSampleCreate_dt)    
SELECT ss.Survey_id, sp.Study_id, GETDATE(), 'Sampling' , COUNT(*), datSampleCreate_dt    
FROM SampleSet ss, SamplePop sp    
WHERE ss.SampleSet_id=@intSampleSet_id    
AND ss.SampleSet_id=sp.SampleSet_id    
GROUP BY ss.Survey_id, sp.Study_id, ss.datSampleCreate_dt    
    
IF @@ROWCOUNT=0 -- Implies there was nobody sampled    
    
INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, Rollbacktype, cnt, datSampleCreate_dt)    
SELECT ss.Survey_id, sd.Study_id, GETDATE(), 'Sampling' , 0, datSampleCreate_dt    
FROM SampleSet ss, Survey_def sd    
WHERE ss.SampleSet_id=@intSampleSet_id    
AND ss.Survey_id=sd.Survey_id    
    
/*     
* Update TeamStatus_SampleInfo    
*/    
SELECT @intSurvey_ID=Survey_id    
FROM dbo.SampleSet    
WHERE SampleSet_id=@intSampleSet_id    
           
UPDATE dbo.TeamStatus_SampleInfo    
SET Rolledback=1    
WHERE SampleSet_id=@intSampleSet_id    
    
UPDATE dbo.TeamStatus_SampleInfo    
SET SamplesPulled=SamplesPulled - 1    
WHERE Survey_id=@intSurvey_ID    
AND SampleSet_id>@intSampleSet_id    
    
SELECT @intNotRollbackSampleSet_id=MIN(SampleSet_id)    
FROM dbo.TeamStatus_SampleInfo    
WHERE Survey_id=@intSurvey_ID    
AND SampleSet_id>@intSampleSet_id    
AND RolledBack=0    
    
IF (@intNotRollbackSampleSet_id IS NULL)    
 UPDATE dbo.TeamStatus_SampleInfo    
    SET TotalRolledBack=TotalRolledBack+1    
  WHERE Survey_id=@intSurvey_ID    
    AND SampleSet_id>@intSampleSet_id    
ELSE    
 UPDATE dbo.TeamStatus_SampleInfo    
    SET TotalRolledBack=TotalRolledBack+1    
  WHERE Survey_id=@intSurvey_ID    
    AND SampleSet_id>@intSampleSet_id    
    AND SampleSet_id<=@intNotRollbackSampleSet_id    
    
--DRM 09/23/2011  Remove seeded mailing data if sampleset is rolled back.

--print 'sampleset_id = ' + cast(@intsampleset_id as varchar)
--print 'survey_id = ' + cast(@intsurvey_id as varchar)


select @vcSQL = 'delete s' + cast(@intStudy_id as varchar) + '.population
where pop_id in 
(select pop_id from samplepop 
where pop_id < 0 and sampleset_id = ' + cast(@intSampleSet_id as varchar) + ')'
--print @vcSQL
exec (@vcSQL)

--DRM 5/14/2013 Add check for existence of encounter table before deleting from it.
if exists (select 1 from sys.tables t inner join sys.schemas s on t.schema_id = s.schema_id where s.name = 's' + cast(@intStudy_id as varchar) and t.name = 'encounter')
begin
	select @vcSQL = 'delete s' + cast(@intStudy_id as varchar) + '.encounter
	where pop_id in 
	(select pop_id from samplepop 
	where pop_id < 0 and sampleset_id = ' + cast(@intSampleSet_id as varchar) + ')'
	--print @vcSQL
	exec (@vcSQL)
end

delete seedmailingsamplepop
where samplepop_id in 
(select samplepop_id from samplepop 
 where sampleset_id = @intSampleSet_id)


update tobeseeded set 
	isseeded = 0, 
	datseeded = null
where survey_id = @intSurvey_ID
and yearqtr = (select replace(dbo.yearqtr(isnull(datdaterange_fromdate,getdate())),'_','Q') from sampleset where sampleset_id = @intSampleSet_id)
and isseeded = 1

--End of add DRM


DELETE FROM dbo.SampleDataSet    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SELECTedSample    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SamplePop    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SampleSet    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SamplePlanWorkSheet    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SPWDQCounts    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.EligibleEncLog    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.CAHPS_PatInfileCount  
WHERE SampleSet_id = @intSampleSet_id     
    
    
--update the info in PeriodDates IF it's not an oversample    
--IF this is an oversample, we want to delete the whole record    
IF EXISTS (SELECT SampleNumber    
   FROM PeriodDates pds, PeriodDef pd    
   WHERE pds.SampleSet_id=@intSampleSet_id AND    
   pds.PeriodDef_id=pd.PeriodDef_id AND    
   pd.intExpectedSamples<SampleNumber)    
BEGIN    
DELETE    
FROM PeriodDates    
WHERE SampleSet_id=@intSampleSet_id    
END    
ELSE     
BEGIN    
UPDATE dbo.PeriodDates    
SET SampleSet_id=NULL,    
 datSampleCreate_dt=NULL    
WHERE SampleSet_id=@intSampleSet_id     
END

GO

ALTER PROCEDURE dbo.QCL_DeleteSystematicOutgo
@sampleset_id INT
AS 
delete
FROM SystematicSamplingProportion 
WHERE sampleset_id = @sampleset_id

GO

