CREATE PROCEDURE SP_DBA_AcctOutgo @date datetime = '1/1/1990'  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
IF @date = '1/1/1990'  
SET @date = getdate()  
  
DECLARE @date1 DATETIME, @date2 DATETIME  
  
--Get the daterange.  
SET @date1 = CONVERT(VARCHAR(10),@date,120)  
SET @date2 = DATEADD(DAY,1,@date1)  
  
--Check to see if this day is already in the table  
IF EXISTS (select * from acctoutgolog where dateranfor = @date1)  
 BEGIN  
  
  PRINT 'This date already exists in the AcctOutgoLog table.'  
  RETURN  
  
 END  
  
--Accumulate the days information  
SELECT sentmail_id  
INTO #sent  
FROM sentmailing  
WHERE datmailed BETWEEN @date1 AND @date2  
  
--figure outgo  
SELECT ss.survey_id, strmailingstep_nm, ms.intsequence, strsamplesurvey_nm, datsamplecreate_dt, count(*) outgo  
INTO #mail  
FROM #sent t(NOLOCK), scheduledmailing schm(NOLOCK), mailingstep ms(NOLOCK), samplepop sp(NOLOCK), sampleset ss(NOLOCK)  
WHERE t.sentmail_id = schm.sentmail_id  
AND schm.mailingstep_id = ms.mailingstep_id  
AND schm.samplepop_id = sp.samplepop_id  
AND sp.sampleset_id = ss.sampleset_id  
GROUP BY ss.survey_id, strmailingstep_nm, ms.intsequence, strsamplesurvey_nm, datsamplecreate_dt  
  
--add in returns  
INSERT INTO #mail  
SELECT qf.survey_id, 'Returns', 9999, strsamplesurvey_nm, datsamplecreate_dt, count(*)   
FROM questionform qf(NOLOCK), samplepop sp(NOLOCK), sampleset ss(NOLOCK)  
WHERE qf.datreturned BETWEEN @date1 AND @date2  
AND qf.samplepop_id = sp.samplepop_id  
AND sp.sampleset_id = ss.sampleset_id  
GROUP BY qf.survey_id, strsamplesurvey_nm, datsamplecreate_dt  
  
  
--We now need to loop through the table one row at a time to determine if it already exists  
--If it exists, we want to add the values to the current record, if not, add the record  
CREATE TABLE #AcctOutgo (  
  [MONTH]   INT,  
  [YEAR]   INT,  
  Client_id   INT,   
  Study_id   INT,   
  Survey_id   INT,   
  SampleSurvey_nm  VARCHAR(10),   
  SampleCreate_dt  DATETIME,   
  Mailingstep   VARCHAR(50),   
  [Sequence]   INT,   
  total    INT  
)  
  
WHILE (SELECT COUNT(*) FROM #mail) > 0  
BEGIN  
  
 INSERT INTO #acctoutgo  
 SELECT TOP 1 MONTH(@date1), YEAR(@date1), client_id, s.study_id, sd.survey_id, t.strsamplesurvey_nm, t.datsamplecreate_dt, strmailingstep_nm, intsequence, outgo  
 FROM #mail t, survey_def sd, study s  
 WHERE t.survey_id = sd.survey_id  
 AND sd.study_id = s.study_id  
  
 DELETE m  
 FROM #acctoutgo t, #mail m  
 WHERE t.survey_id = m.survey_id  
 AND t.samplecreate_dt = m.datsamplecreate_dt  
 AND t.[sequence] = m.intsequence  
  
 --Now to check if we will add values to a current record or to insert the new record  
 IF NOT EXISTS(SELECT *   
  FROM acctoutgo a, #acctoutgo t   
  WHERE a.survey_id = t.survey_id   
  AND a.samplecreate_dt = t.samplecreate_dt  
  AND a.[sequence] = t.[sequence]   
  AND a.YEAR = YEAR(@date1)   
  AND a.MONTH = MONTH(@date1))  
   
 BEGIN  
  
  INSERT INTO acctoutgo  
  SELECT MONTH(@date1), YEAR(@date1), Client_id, Study_id, Survey_id, SampleSurvey_nm, SampleCreate_dt, Mailingstep, [Sequence], total  
  FROM #acctoutgo  
  
 END  
  
 ELSE  
  
 BEGIN  
  
  UPDATE a  
  SET a.total = a.total + t.total  
  FROM acctoutgo a, #acctoutgo t  
  WHERE a.survey_id = t.survey_id  
  AND a.samplecreate_dt = t.samplecreate_dt  
  AND a.[sequence] = t.[sequence]  
  
 END  
  
TRUNCATE TABLE #acctoutgo  
  
END  
  
INSERT INTO acctoutgolog SELECT GETDATE(), @date1  
  
DROP TABLE #sent  
DROP TABLE #mail  
DROP TABLE #acctoutgo


