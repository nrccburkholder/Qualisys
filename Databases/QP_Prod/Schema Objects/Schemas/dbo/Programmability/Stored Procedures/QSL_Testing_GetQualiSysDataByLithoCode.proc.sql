CREATE PROCEDURE [dbo].[QSL_Testing_GetQualiSysDataByLithoCode]
@LithoCode VARCHAR(10)
AS

--SentMailing and QuestionForm changes
SELECT sm.strLithoCode, sm.SentMail_id, qf.QuestionForm_id, qf.Survey_id, 
       sm.datMailed, sm.datUndeliverable, sm.datExpire, qf.datUnusedReturn, 
       qf.UnusedReturn_id, qf.datReturned, qf.datResultsImported, sm.LangID, 
       qf.strSTRBatchNumber, qf.ReceiptType_id
FROM SentMailing sm, QuestionForm qf
WHERE sm.SentMail_id = qf.SentMail_id
  AND sm.strLithoCode = @LithoCode

--QuestionResult changes
SELECT sm.strLithoCode, sm.SentMail_id, qr.*
FROM SentMailing sm, QuestionForm qf, QuestionResult qr
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.QuestionForm_id = qr.QuestionForm_id
  AND sm.strLithoCode = @LithoCode

--Comments Changes
SELECT qf.strLithoCode, qf.SentMail_id, qf.QuestionForm_id, qf.Survey_id, qc.QstnCore, qc.strCmntText, qb.Batch_id, qb.strBatchName, qb.BatchType_id, qb.datEntered, qb.strEnteredBy 
FROM QDEBatch qb, QDEForm qf, QDEComments qc
WHERE qb.Batch_id = qf.Batch_id
  AND qf.Form_id = qc.Form_id
  AND qf.strLithoCode = @LithoCode

--Dispositions
SELECT sm.strLithoCode, dl.* 
FROM SentMailing sm, DispositionLog dl
WHERE sm.SentMail_id = dl.SentMail_id
  AND sm.strLithoCode = @LithoCode

--HandEntries
DECLARE @StudyID INT
DECLARE @Sql VARCHAR(8000)

SELECT @StudyID = sp.Study_id
FROM SentMailing sm, QuestionForm qf, SamplePop sp
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sm.strLithoCode = @LithoCode

SET @Sql = 'SELECT sm.strLithoCode, sm.SentMail_id, qf.QuestionForm_id, qf.SamplePop_id, po.* ' +
           'FROM SentMailing sm, QuestionForm qf, SamplePop sp, s' + CONVERT(varchar, @StudyID) + '.Population po ' +
           'WHERE sm.SentMail_id = qf.SentMail_id ' +
           '  AND qf.SamplePop_id = sp.SamplePop_id ' +
           '  AND sp.Pop_id = po.Pop_id ' +
           '  AND sm.strLithoCode = ''' + @LithoCode + ''''
EXEC (@Sql)


