CREATE PROC QP_REP_ClientOutgo
@Associate 	VARCHAR(42),
@Client		VARCHAR(42),
@BeginDate	DATETIME,
@EndDate	DATETIME

AS

DECLARE @sql VARCHAR(8000), @Client_id INT

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT @Client_id=Client_id
FROM Client
WHERE strClient_nm=@Client

SELECT strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, COUNT(*) OutGo
FROM Study s, Survey_def sd, SampleSet ss, SamplePop sp
WHERE s.Client_id=@Client_id
AND s.Study_id=sd.Study_id
AND sd.Survey_id=ss.Survey_id
AND ss.datDateRange_FromDate>=@BeginDate
AND ss.datDateRange_ToDate<=@EndDate
AND ss.SampleSet_id=sp.SampleSet_id
GROUP BY strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id
ORDER BY 1,3


