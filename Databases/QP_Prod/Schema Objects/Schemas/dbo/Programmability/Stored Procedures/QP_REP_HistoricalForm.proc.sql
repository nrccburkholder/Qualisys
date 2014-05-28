CREATE PROCEDURE QP_REP_HistoricalForm
@Associate VARCHAR(50),
@Client VARCHAR(50),
@Study VARCHAR(50),
@Survey VARCHAR(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @SurveyID INT, @sql VARCHAR(1000), @Server VARCHAR(100)
CREATE TABLE #DataMartCores (QstnCore INT, Label VARCHAR(100))
CREATE TABLE #NRC10Cores (QstnCore INT)

SELECT @SurveyID=Survey_id
FROM Client c, Study s, Survey_def sd
WHERE c.strClient_nm=@Client
AND c.Client_id=s.Client_id
AND s.strStudy_nm=@Study
AND s.Study_id=sd.Study_id
AND sd.strSurvey_nm=@Survey

SELECT @Server=strParam_Value
FROM QualPro_Params
WHERE strParam_nm='DataMart'

SELECT @sql='INSERT INTO #DataMartCores (QstnCore, Label)
SELECT QstnCore, Label
FROM '+@Server+'.QP_Comments.dbo.Questions
WHERE Survey_id='+LTRIM(STR(@SurveyID))

EXEC (@sql)

INSERT INTO #NRC10Cores (QstnCore)
SELECT QstnCore
FROM Sel_Qstns 
WHERE Survey_id=@SurveyID
AND SubType=1
AND Language=1

SELECT d.QstnCore QstnCore, CASE WHEN n.QstnCore IS NULL THEN 0 ELSE 1 END CurrentForm, Label
FROM #NRC10Cores n RIGHT JOIN #DataMartCores d
ON d.QstnCore=n.QstnCore
ORDER BY 2

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


