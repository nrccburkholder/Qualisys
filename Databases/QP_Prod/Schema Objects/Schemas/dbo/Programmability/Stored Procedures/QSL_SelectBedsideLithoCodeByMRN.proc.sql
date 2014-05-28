CREATE PROCEDURE [dbo].[QSL_SelectBedsideLithoCodeByMRN]    
    @MRN       varchar(100),
    @AdmitDate datetime, 
	@StudyID   int,
	@SurveyID  int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    

DECLARE @Sql as varchar(1000)

SET @Sql = 'SELECT TOP 1 sm.strLithoCode ' + CHAR(13) +
           'FROM s' + convert(varchar, @StudyID) + '.Population po, s' + CONVERT(varchar, @StudyID) + '.Encounter en, ' + CHAR(13) +
           '     SamplePop sp, SentMailing sm, QuestionForm qf, SelectedSample ss ' + CHAR(13) +
           'WHERE po.Pop_id = en.Pop_id ' + CHAR(13) + 
           '  AND po.Pop_id = sp.Pop_id ' + CHAR(13) + 
           '  AND po.MRN = ''' + @MRN  + ''' ' + CHAR(13) +
           '  AND convert(varchar, en.AdmitDate, 110) = ''' + convert(varchar, @AdmitDate, 110) + ''' ' + CHAR(13) + 
           '  AND sp.Study_id = ' + convert(varchar, @StudyID) + ' ' + CHAR(13) +
           '  AND sp.SamplePop_id = qf.SamplePop_id ' + CHAR(13) +
           '  AND qf.Survey_id = ' + convert(varchar, @SurveyID) + ' ' + CHAR(13) +
           '  AND sm.SentMail_id = qf.SentMail_id ' + CHAR(13) +
           '  AND ss.Pop_id = po.Pop_id ' + CHAR(13) +
           '  AND ss.Enc_id = en.Enc_id ' + CHAR(13) +
           '  AND ss.Pop_id = sp.Pop_id ' + CHAR(13) +
           '  AND ss.SampleSet_id = sp.SampleSet_id ' + CHAR(13) +
           'ORDER BY sm.SentMail_id DESC'
EXEC (@Sql)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


