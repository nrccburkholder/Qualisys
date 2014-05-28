CREATE PROCEDURE sp_OffTR_GetAdditionalInfo
    @strLithoCode varchar(10)

AS
/*
SELECT sm.SentMail_id, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id 
FROM SentMailing sm (nolock), QuestionForm qf (NOLOCK), SamplePop sp (NOLOCK)
WHERE sm.strLithoCode = @strLithoCode
AND sm.SentMail_id = qf.SentMail_id
AND qf.SamplePop_id = sp.SamplePop_Id
*/

SELECT sm.SentMail_id, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id 
FROM (SentMailing sm (NOLOCK) LEFT JOIN QuestionForm qf (NOLOCK) ON sm.SentMail_id = qf.SentMail_id)
                              LEFT JOIN SamplePop sp (NOLOCK) ON qf.SamplePop_id = sp.SamplePop_Id
WHERE sm.strLithoCode = @strLithoCode


