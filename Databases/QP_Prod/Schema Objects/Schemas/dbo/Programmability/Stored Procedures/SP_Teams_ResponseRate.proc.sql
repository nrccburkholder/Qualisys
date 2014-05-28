CREATE PROCEDURE SP_Teams_ResponseRate
AS
SET NOCOUNT ON
TRUNCATE TABLE teamstatus_resprate

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT survey_id, MAX(datperioddate) AS datperioddate 
INTO #period
FROM period (NOLOCK)
GROUP BY survey_id

INSERT INTO #period
SELECT survey_id, GETDATE() 
FROM survey_def (NOLOCK)
WHERE survey_id NOT IN (SELECT survey_id FROM #period)

SELECT ss.survey_id, (SUM(intreturned)*100.00)/CASE WHEN (SUM(intsampled) - SUM(intud))=0 THEN 1 ELSE (SUM(intsampled) - SUM(intud)) END AS historical
INTO #historical 
FROM respratecount rrc(NOLOCK), sampleset ss(NOLOCK)
WHERE ss.sampleset_id = rrc.sampleset_id
AND ss.datsamplecreate_dt between DATEADD(yy,-1,GETDATE()) and DATEADD(dd,-14,GETDATE())
GROUP BY ss.survey_id
ORDER BY ss.survey_id

INSERT INTO #historical
SELECT survey_id, 0.00
FROM survey_def (NOLOCK)
WHERE survey_id NOT IN (SELECT survey_id FROM #historical)

SELECT ss.survey_id, ((SUM(intreturned)*100.00)/(CASE WHEN (SUM(intsampled)-SUM(intud))=0 THEN 1 
			ELSE (SUM(intsampled)-SUM(intud)) END)) AS currentperiod
INTO #currentperiod
FROM respratecount rrc(NOLOCK), sampleset ss(NOLOCK), #period tp(NOLOCK)
WHERE ss.sampleset_id = rrc.sampleset_id
AND tp.survey_id = ss.survey_id
AND ss.datsamplecreate_dt > datperioddate
GROUP BY ss.survey_id
ORDER BY ss.survey_id

INSERT INTO #currentperiod
SELECT survey_id, 0.00
FROM survey_def (NOLOCK)
WHERE survey_id NOT IN (SELECT survey_id FROM #currentperiod)

INSERT INTO teamstatus_resprate
SELECT strclient_nm, s.strstudy_nm, s.study_id, sd.strsurvey_nm, p.survey_id, ISNULL(h.historical,0.00), ISNULL(c.currentperiod,0.00)
FROM #period p(NOLOCK), #historical h(NOLOCK), #currentperiod c(NOLOCK), survey_def sd(NOLOCK), study s(NOLOCK), client cl(NOLOCK)
WHERE p.survey_id = h.survey_id
AND p.survey_id = c.survey_id
AND p.survey_id = sd.survey_id
AND sd.study_id = s.study_id
AND s.client_id = cl.client_id
ORDER BY strclient_nm, strstudy_nm, strsurvey_nm

DROP TABLE #period
DROP TABLE #historical
DROP TABLE #currentperiod


