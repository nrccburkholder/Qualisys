CREATE PROCEDURE QP_Rep_QuestionsBySurvey
@QuestionList VARCHAR(2000)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @strSQL VARCHAR(2000)

SET @strSQL='SELECT DISTINCT sq.QstnCore,c.strClient_nm,s.strStudy_nm,sd.strSurvey_nm,s.Study_id,sd.Survey_id 
FROM Sel_Qstns sq,Client c, Study s, Survey_def sd
WHERE c.Client_id=s.Client_id AND s.Study_id=sd.Study_id AND sd.Survey_id=sq.Survey_id AND sq.SubType=1
AND sq.QstnCore IN ('+@questionlist+')
ORDER BY sq.QstnCore,c.strClient_nm,s.strStudy_nm,sd.strSurvey_nm,s.Study_id,sd.Survey_id '

EXEC (@strSQL)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


