CREATE PROCEDURE [dbo].[SP_SYS_SampledNotScheduled] AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SELECT Survey_id, ss.SampleSet_id, SamplePop_id, datSampleCreate_dt, CONVERT(BIT,0) Scheduled, ss.EMPLOYEE_ID    
INTO #ss    
FROM SampleSet ss, SamplePop sp    
WHERE datLastMailed IS NULL    
AND datSampleCreate_dt BETWEEN DATEADD(MONTH,-2,GETDATE()) AND DATEADD(DAY,-7,GETDATE())    
AND ss.SampleSet_id=sp.SampleSet_id    
    
UPDATE t    
SET t.Scheduled=1    
FROM #ss t, ScheduledMailing schm(NOLOCK)    
WHERE t.SamplePop_id=schm.SamplePop_id    
    
SELECT strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm AD, SampleSet_id, datSampleCreate_dt, COUNT(*) Sampled    
INTO ##Email5847584    
FROM #ss t, Survey_def sd, Study s, Client c, Employee e    
WHERE t.Scheduled=0    
AND t.Survey_id=sd.Survey_id    
AND sd.Study_id=s.Study_id    
AND s.Client_id=c.Client_id    
--AND s.ADEmployee_id=e.Employee_id    
AND t.EMPLOYEE_ID = e.EMPLOYEE_ID
AND s.bitExtractToDataMart=1    
GROUP BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm, SampleSet_id, datSampleCreate_dt    
ORDER BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, strNTLogin_nm, SampleSet_id, datSampleCreate_dt    
    
IF (SELECT COUNT(*) FROM ##Email5847584)>0    
BEGIN    
 --EXEC master.dbo.XP_SendMail @Recipients='SQL-AllManagementServices', @Subject='Sampled not Scheduled', @Query='SELECT * FROM ##Email5847584',     
 --@Message='These are Samples that are between one week and 2 months old and have not been scheduled.', @Attach_Results='True' , @width=500    

declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
declare @vsubject nvarchar(255)
exec qp_prod.dbo.sp_getemailsubject 'Sampled not Scheduled',@country, @environment, 'Qualisys', @osubject=@vsubject output

declare @to nvarchar(255)
SET @to='itsoftwareengineeringlincoln@nationalresearch.com;'

IF @environment = 'PRODUCTION'
BEGIN
	IF @country = 'CA'
		SET @to=@to+'SampledNotScheduledCA@nationalresearch.com;' --'Project Managers; CChen;EMatovic;'	-- invalid except for CChen ... cchen@nationalresearch.ca
	ELSE
		SET @to=@to+'SampledNotScheduledUS@nationalresearch.com;' --'MeasurementServices@nrcpicker.com;mstech@nrcpicker.com'	-- former invalid; latter should probably be QualisysDBAEmailAlerts@NationalResearch.com
END

EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',  
@recipients=@to,
@subject=@vsubject,  
@body='These are Samples that are between one week and 2 months old and have not been scheduled.  NOTE:  AD now reflects the sample creator, not study owner.',  
@body_format='HTML',  
@importance='High',  
@execute_query_database = 'qp_prod',  
@attach_query_result_as_file = 1,   
@Query='SELECT * FROM ##Email5847584'  
   
END    
    
DROP TABLE #ss    
DROP TABLE ##Email5847584


