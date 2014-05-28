CREATE PROCEDURE [dbo].[QSL_SelectBedsideLithoCodeByVisitNumAdmitDateVisitType]    
    @VisitNum  VARCHAR(100),
    @AdmitDate DATETIME, 
    @VisitType VARCHAR(100), 
	@StudyID   INT,
	@SurveyID  INT
AS

--Setup the environment
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    

--Declare required variables
DECLARE @Sql AS VARCHAR(1000)
DECLARE @Enc_Mtch AS VARCHAR(42)

--Calculate the Enc_Mtch value
SET @Enc_Mtch = @VisitNum + CONVERT(VARCHAR, @AdmitDate, 101) + @VisitType

--Build the query
SET @Sql = 'SELECT TOP 1 sm.strLithoCode ' + CHAR(13) +
           'FROM s' + CONVERT(VARCHAR, @StudyID) + '.Population po, s' + CONVERT(VARCHAR, @StudyID) + '.Encounter en, ' + CHAR(13) +
           '     SamplePop sp, SentMailing sm, QuestionForm qf, SelectedSample ss ' + CHAR(13) +
           'WHERE po.Pop_id = en.Pop_id ' + CHAR(13) + 
           '  AND po.Pop_id = sp.Pop_id ' + CHAR(13) + 
           '  AND en.Enc_Mtch = ''' + @Enc_Mtch  + ''' ' + CHAR(13) +
           '  AND sp.Study_id = ' + CONVERT(VARCHAR, @StudyID) + ' ' + CHAR(13) +
           '  AND sp.SamplePop_id = qf.SamplePop_id ' + CHAR(13) +
           '  AND qf.Survey_id = ' + CONVERT(VARCHAR, @SurveyID) + ' ' + CHAR(13) +
           '  AND sm.SentMail_id = qf.SentMail_id ' + CHAR(13) +
           '  AND ss.Pop_id = po.Pop_id ' + CHAR(13) +
           '  AND ss.Enc_id = en.Enc_id ' + CHAR(13) +
           '  AND ss.Pop_id = sp.Pop_id ' + CHAR(13) +
           '  AND ss.SampleSet_id = sp.SampleSet_id ' + CHAR(13) +
           'ORDER BY sm.SentMail_id DESC'
PRINT (@Sql)
EXEC (@Sql)

--Reset the environment
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


