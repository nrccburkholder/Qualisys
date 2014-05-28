CREATE PROCEDURE sp_OffTR_OtherStepImported
    @intQuestionFormID int
--  ,@intSamplePop_id INT
AS

SELECT Count(QF2.datReturned) AS QtyRec 
FROM QuestionForm QF, QuestionForm QF2 
WHERE QF.QuestionForm_id = @intQuestionFormID 
  AND QF2.QuestionForm_id <> QF.QuestionForm_id 
  AND QF2.SamplePop_id = QF.SamplePop_id 
  AND QF2.datResultsImported IS NOT NULL

/*
SELECT Count(datReturned) AS QtyRec 
FROM QuestionForm QF
WHERE SamplePop_id = @intSamplePop_id
  AND QuestionForm_id <> @intQuestionFormID 
  AND datResultsImported > '1/1/1900'
*/


