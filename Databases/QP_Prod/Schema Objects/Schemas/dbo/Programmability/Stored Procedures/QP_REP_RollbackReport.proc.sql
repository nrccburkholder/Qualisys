CREATE PROCEDURE QP_REP_RollbackReport 
	@Associate VARCHAR(42),
	@BeginDate DATETIME, 
	@EndDate DATETIME
AS

SELECT @EndDate=@EndDate+'23:59:59'

SELECT Survey_id,Study_id,CONVERT(DATETIME,CONVERT(VARCHAR(10),datRollback_dt,120)+' '+CONVERT(VARCHAR,DATEPART(HOUR,datRollback_dt))+':00') datRollback_dt,RollBackType,Cnt,datSampleCreate_dt
INTO #rb
FROM Rollbacks 
WHERE datRollback_dt BETWEEN @BeginDate AND @EndDate
GROUP BY Survey_id,Study_id,CONVERT(DATETIME,CONVERT(VARCHAR(10),datRollback_dt,120)+' '+CONVERT(VARCHAR,DATEPART(HOUR,datRollback_dt))+':00'),RollBackType,Cnt,datSampleCreate_dt

SELECT strNTLogin_nm AD,strClient_nm,c.Client_id,strStudy_nm,s.Study_id,strSurvey_nm,sd.Survey_id,datRollback_dt,RollbackType,Cnt
FROM Employee e, Client c, Study s, Survey_def sd, #rb t
WHERE t.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id
AND s.Client_id=c.Client_id
AND s.ADEmployee_id=e.Employee_id
AND RollbackType='Generation'
GROUP BY strntlogin_nm,strClient_nm,c.Client_id,strStudy_nm,s.Study_id,strSurvey_nm,sd.Survey_id,datRollback_dt,RollbackType,Cnt
UNION ALL
SELECT strNTLogin_nm,strClient_nm,c.Client_id,strStudy_nm,s.Study_id,NULL,NULL,datRollback_dt,RollbackType,Cnt
FROM Employee e, Client c, Study s, #rb t
WHERE t.Study_id=s.Study_id
AND s.Client_id=c.Client_id
AND s.ADEmployee_id=e.Employee_id
AND RollbackType='Apply'
UNION ALL
SELECT strNTLogin_nm,strClient_nm,c.Client_id,strStudy_nm,s.Study_id,strSurvey_nm,sd.Survey_id,datRollback_dt,RollbackType,Cnt
FROM Employee e, Client c, Study s, Survey_def sd, #rb t
WHERE t.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id
AND s.Client_id=c.Client_id
AND s.ADEmployee_id=e.Employee_id
AND RollbackType='Sampling'
ORDER BY 1,3,5,7,8,9,10

DROP TABLE #rb


