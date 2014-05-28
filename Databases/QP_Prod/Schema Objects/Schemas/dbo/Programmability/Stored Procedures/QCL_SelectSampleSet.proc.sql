CREATE PROCEDURE [dbo].[QCL_SelectSampleSet]
@SampleSet_Id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT st.Client_id, st.Study_id, sd.Survey_id, sd.strSurvey_nm, pd.PeriodDef_id, pd.strPeriodDef_nm, 
       ss.SampleSet_id, ss.datSampleCreate_dt, ss.Employee_Id, pd.datExpectedEncStart, pd.datExpectedEncEnd, 
       ss.SamplePlan_Id, ss.intSample_Seed, ss.tiNewPeriod_flag, ss.tiOversample_flag, ss.datScheduled, 
       ss.SamplingAlgorithmId, ss.HCAHPSOverSample, ss.datDateRange_FromDate, ss.datDateRange_ToDate
FROM SampleSet ss, PeriodDates pt, PeriodDef pd, Survey_Def sd, Study st
WHERE ss.SampleSet_id = pt.SampleSet_id
  AND pt.PeriodDef_id = pd.PeriodDef_id
  AND ss.Survey_id = sd.Survey_id
  AND sd.Study_id = st.Study_id
  AND sd.Survey_id = ss.Survey_id
  AND ss.SampleSet_id = @SampleSet_id
ORDER BY ss.datSampleCreate_dt

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


