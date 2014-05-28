CREATE PROCEDURE SP_Teams_SamplingStatus
AS
SET NOCOUNT ON
TRUNCATE TABLE teamstatus_sampling

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @quarter INT, @year INT, @date VARCHAR(20), @month INT, @strsql VARCHAR(100)
SET @quarter = DATEPART(q,DATEADD(dd,-14,GETDATE()))
--print @quarter
SET @year = DATEPART(yy,DATEADD(dd,-14,GETDATE()))
--print @year

SELECT @quarter = CASE @quarter WHEN 1 THEN 1 WHEN 2 THEN 4 WHEN 3 THEN 7 WHEN 4 THEN 9 END
--print @quarter

SET @date = CONVERT(VARCHAR,@quarter) + '/14/' + CONVERT(VARCHAR,@year) 
--print @date

SELECT p.survey_id, MAX(datperioddate) AS dat, MAX(datsamplecreate_dt) AS lastsample
INTO #period
FROM period p, sampleSET ss
WHERE p.survey_id = ss.survey_id
GROUP BY p.survey_id

INSERT INTO teamstatus_sampling 
(AD, Client,Study,Study_ID,Survey,Survey_ID,strMailFreq,intSamplesInPeriod,DateNewPeriod,SampledThisPeriod,RemainingSamples, LastSample)
SELECT strNTLogin_nm, strclient_nm, strstudy_nm, s.study_id, strsurvey_nm, sd.survey_id, strmailfreq, intsamplesinperiod, dat, 
COUNT(*) AS sampledthisperiod, (intsamplesinperiod - COUNT(*)) AS remainingsamples, lastsample
FROM survey_def sd, sampleSET ss, #period p, study s, client c, employee e
WHERE sd.survey_id = ss.survey_id
AND sd.survey_id = p.survey_id
AND datsamplecreate_dt > dat
AND GETDATE() between DATSURVEY_START_DT AND DATSURVEY_END_DT
AND sd.study_id = s.study_id
AND s.client_id = c.client_id
AND s.ademployee_id = e.employee_id
GROUP BY strNTLogin_nm, strclient_nm, strstudy_nm, s.study_id, strsurvey_nm, sd.survey_id, strmailfreq, intsamplesinperiod, dat, lastsample
ORDER BY strNTLogin_nm, strclient_nm, strstudy_nm, s.study_id, strsurvey_nm

UPDATE teamstatus_sampling
SET ShouldhaveSampled = DATEDIFF(ww,@date,GETDATE())
WHERE strmailfreq = 'weekly'

UPDATE teamstatus_sampling
SET ShouldhaveSampled = (DATEDIFF(mm,@date,GETDATE()) - 1)
WHERE strmailfreq = 'monthly'

UPDATE teamstatus_sampling
SET ShouldhaveSampled = (DATEDIFF(ww,@date,GETDATE())/2)
WHERE strmailfreq = 'bi-weekly'

UPDATE teamstatus_sampling
SET ShouldhaveSampled = DATEDIFF(q,@date,GETDATE())
WHERE strmailfreq = 'quarterly'

--INSERT INTO teamstatus_sampling (client)
--SELECT 'No Current Samples'

DROP TABLE #period

SELECT * FROM teamstatus_sampling


