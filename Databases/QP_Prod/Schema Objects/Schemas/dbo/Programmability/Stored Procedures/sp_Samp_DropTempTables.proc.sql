/****** Object:  Stored Procedure dbo.sp_Samp_DropTempTables    Script Date: 9/28/99 2:57:13 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_DropTempTables
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
          1/7/2003 modified by BM
            add a record into the teamstatus_sampleinfo table
***********************************************************************************************************************************/
CREATE           PROCEDURE sp_Samp_DropTempTables
 @bitHouseholdingApplied bit = 0
AS
 DECLARE @intSurvey_id int, @intSampleset_id int

 SELECT TOP 1 @intSurvey_id=SP.Survey_id
 FROM #SampleUnit_Universe  SUU, SampleUnit SU, SamplePlan SP
 WHERE SUU.SampleUnit_id IS NOT NULL
 and SUU.SampleUnit_id=SU.SampleUnit_id
 and SU.SamplePlan_id=SP.SamplePlan_id

 IF @intSurvey_id IS NOT NULL 
 BEGIN
   SELECT @intSampleSet_id = max(SampleSet_id)
   FROM SampleSet
   WHERE Survey_id=@intSurvey_id

/*   UPDATE DBL
     SET ProcedureEnd = getdate(), Sampleset=(select datsamplecreate_dt from sampleset where sampleset_id = @intSampleSet_id), 
		days=(select count(*) from samplepop where sampleset_id = @intsampleset_id)
     FROM DashboardLog DBL,  Client C, Study S, Survey_def SD
     WHERE C.Client_id=S.Client_id
     and S.Study_id=SD.Study_id
     and SD.Survey_id=@intSurvey_id
     and DBL.Report = 'Sampling Tool'
     and DBL.Client = C.strClient_nm
     and DBL.Study = S.strStudy_nm
     and DBL.Survey = SD.strSurvey_nm
     and ProcedureEnd IS NULL
     and Sampleset IS NULL
*/
   /* 
    * Add by BMao, 1/8/03
    * Create a record to TeamStatus_SampleInfo
    */
   DECLARE @intSamplePulled    int,
           @intTotalRolledBack int

   SELECT @intSamplePulled = COUNT(*)
     FROM dbo.SampleSet
    WHERE Survey_ID = @intSurvey_id
      AND datSampleCreate_Dt >= (
            SELECT ISNULL(MAX(DatPeriodDate),'1/1/1900') 
              FROM dbo.Period
             WHERE Survey_ID = @intSurvey_id
          )
     
   SELECT @intTotalRolledBack = 
          ISNULL((
                  SELECT TOP 1
                         TotalRolledback + Rolledback
                    FROM dbo.TeamStatus_SampleInfo
                   WHERE Survey_ID = 1609
                   ORDER BY SampleSet_ID DESC
                  ), 0)

   INSERT INTO dbo.TeamStatus_SampleInfo (
           AD,
           ProjectNum,
           Survey_id,
           FirstApply,
           SampleSet_id,
           SampleDate,
           MailFrequency,
           SamplesInPeriod,
           SamplesPulled,
           RolledBack,
           TotalRolledBack
          )
   SELECT e.StrNTLogin_Nm AS AD,
          LEFT(sd.StrSurvey_Nm, 4) ProjectNum,
          sd.Survey_ID,
          MIN(ds.DatLoad_Dt) AS FirstApply,
          ss.SampleSet_ID,
          ss.DatSampleCreate_Dt,
          sd.StrMailFreq,
          sd.IntSamplesInPeriod,
          @intSamplePulled AS SamplesPulled,
          0 AS RolledBack,
          @intSamplePulled AS TotalRolledBack
     FROM dbo.SampleSet ss,
          dbo.SampleDataSet sds,
          dbo.Data_Set ds,
          dbo.Survey_Def sd,
          dbo.Study s,
          dbo.Employee e
    WHERE ss.sampleset_id = @intSampleSet_id
      AND ss.sampleset_id = sds.sampleset_id
      AND sds.dataset_id = ds.dataset_id
      AND ss.survey_id = sd.survey_id
      AND sd.study_id = s.study_id
      AND s.ademployee_id = e.employee_id
    GROUP BY
          e.StrNTLogin_Nm,
          LEFT(sd.StrSurvey_Nm, 4),
          sd.Survey_ID,
          ss.SampleSet_ID,
          ss.DatSampleCreate_Dt,
          sd.StrMailFreq,
          sd.IntSamplesInPeriod

   /* End of add by BMao */
   
 END

--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dc_testsampleunit_universe]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].[dc_testsampleunit_universe]

--Select *
--into dc_testsampleunit_universe
--from #sampleunit_universe

 --DROP TABLE #Universe 

 DROP TABLE #SampleUnit_Universe 
 DROP TABLE #DataSet
 DROP TABLE #DD_Dups
 DROP TABLE #DD_ChildSample
 DROP TABLE #Presample
 
 IF @bitHouseholdingApplied = 1
 BEGIN
  DROP TABLE #Max_MailingDate
  DROP TABLE #HH_Dup_Fields
  DROP TABLE #HH_Dup_People
  DROP TABLE #Minor_Exclude
  DROP TABLE #Household_Dups
  DROP TABLE #Minor_Universe
 END

Insert into #Timer (PostSampleEnd) values (getdate()) 

Update sampleset
set PreSampleTime=datediff(ss, PreSampleStart,PreSampleEnd),
	PostSampleTime=datediff(ss, PostSampleStart,PostSampleEnd)
from sampleset s, #Timer t
where sampleset_id=@intSampleSet_id

DROP table #Timer


