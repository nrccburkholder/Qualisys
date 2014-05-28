CREATE PROCEDURE SP_SYS_SampledNotScheduled_RN AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm AD, ss.SampleSet_id, datSampleCreate_dt, COUNT(*) Sampled
INTO ##Email5847584a
FROM QP_Prod..SampleSet ss, QP_Prod..SamplePop sp, QP_Prod..Client c, QP_Prod..Study s, QP_Prod..Survey_def sd, QP_Prod..Employee e
WHERE datLastMailed IS NULL
AND datSampleCreate_dt BETWEEN DATEADD(MONTH,-2,GETDATE()) AND DATEADD(DAY,-7,GETDATE())
AND ss.SampleSet_id=sp.SampleSet_id
AND NOT EXISTS (Select * from QP_Prod..ScheduledMailing schm where sp.Samplepop_id = schm.Samplepop_id)
AND ss.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id
AND s.Client_id=c.Client_id
AND s.ADEmployee_id=e.Employee_id
GROUP BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm, ss.SampleSet_id, datSampleCreate_dt
ORDER BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm, ss.SampleSet_id, datSampleCreate_dt


IF @@ROWCOUNT = 0 
   BEGIN
	DROP TABLE ##Email5847584
	return
   END

--EXEC master.dbo.XP_SendMail @Recipients='Project Managers;JFortune', @Subject='Sampled not Scheduled', @Query='SELECT * FROM ##Email5847584', 
--EXEC master.dbo.XP_SendMail @Recipients='RNIEWOHNER', @Subject='Sampled not Scheduled', @Query='SELECT * FROM ##Email5847584', 
--@Message='These are Samples that are between one week and 2 months old and have not been scheduled.', @Attach_Results='True' , @width=500

EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',
@recipients='RNIEWOHNER',
@subject='Sampled not Scheduled',
@body='These are Samples that are between one week and 2 months old and have not been scheduled.',
@body_format='HTML',
@importance='High',
@execute_query_database = 'qp_prod',
@attach_query_result_as_file = 1, 
@Query='SELECT * FROM ##Email5847584'

DROP TABLE ##Email5847584


