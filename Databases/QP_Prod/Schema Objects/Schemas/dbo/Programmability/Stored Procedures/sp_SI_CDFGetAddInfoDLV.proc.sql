CREATE PROCEDURE dbo.sp_SI_CDFGetAddInfoDLV 
    @LithoInList varchar(7000)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @Sql varchar(8000)

--Build the select statement
/* Modified 08-07-05 JJF
SET @Sql = 'SELECT sm.strLithoCode, sm.SentMail_id, sm.datUndeliverable, sm.datExpire, ' +
           '       qf.QuestionForm_id, qf.datReturned, qf.datResultsImported, ' + 
           '       qf.Survey_id AS QFSurveyID, sd.bitMultReturns, cs.Survey_id ' + 
           'FROM ((SentMailing sm LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id) ' + 
           '                      LEFT JOIN Survey_Def sd ON qf.Survey_id = sd.Survey_id) ' + 
           '                      LEFT JOIN CommentSkipSurveys cs ON qf.Survey_id = cs.Survey_id ' +
           'WHERE sm.strLithoCode IN (' + @LithoInList + ')'
*/
SET @Sql = 'SELECT sm.strLithoCode, sm.SentMail_id, sm.datUndeliverable, sm.datExpire, ' +
           '       qf.QuestionForm_id, qf.datReturned, qf.datResultsImported, ' + 
           '       qf.Survey_id AS QFSurveyID, sd.bitMultReturns, cs.Survey_id, sm.Country_id ' + 
           'FROM ((SentMailing sm LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id) ' + 
           '                      LEFT JOIN Survey_Def sd ON qf.Survey_id = sd.Survey_id) ' + 
           '                      LEFT JOIN CommentSkipSurveys cs ON qf.Survey_id = cs.Survey_id ' +
           'WHERE sm.strLithoCode IN (' + @LithoInList + ')'
--PRINT @Sql
EXEC (@Sql)

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


