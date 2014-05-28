CREATE PROCEDURE [dbo].[QP_Rep_SampledNotScheduled] 
	@Associate	VARCHAR(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Employee_id INT

SELECT @Employee_id=Employee_id
FROM Employee
WHERE strNTLogin_nm=@Associate

SELECT ss.Survey_id, ss.SampleSet_id, MIN(sp.SamplePop_id) SamplePop_id, ss.datSampleCreate_dt, CONVERT(BIT,0) Scheduled, ss.EMPLOYEE_ID
INTO #ss
FROM SampleSet ss, SamplePop sp, Survey_def sd, Study_Employee se
WHERE se.Employee_id=@Employee_id
AND se.Study_id=sd.Study_id
AND sd.Survey_id=ss.Survey_id
AND datLastMailed IS NULL
AND datSampleCreate_dt BETWEEN DATEADD(MONTH,-2,GETDATE()) AND GETDATE()
AND ss.SampleSet_id=sp.SampleSet_id
AND Web_Extract_Flg IS NULL
GROUP BY ss.Survey_id, ss.SampleSet_id, ss.datSampleCreate_dt, ss.EMPLOYEE_ID

UPDATE t
SET t.Scheduled=1
FROM #ss t, ScheduledMailing schm(NOLOCK)
WHERE t.SamplePop_id=schm.SamplePop_id

SELECT strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm AD, t.SampleSet_id, t.datSampleCreate_dt, COUNT(*) Sampled
FROM #ss t, SamplePop sp, Survey_def sd, Study s, Client c, Employee e
WHERE t.Scheduled=0
AND t.SampleSet_id=sp.SampleSet_id
AND t.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id
AND s.Client_id=c.Client_id
--AND s.ADEmployee_id=e.Employee_id    
AND t.EMPLOYEE_ID = e.EMPLOYEE_ID
GROUP BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm, t.SampleSet_id, t.datSampleCreate_dt
ORDER BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm, t.SampleSet_id, t.datSampleCreate_dt

DROP TABLE #ss


