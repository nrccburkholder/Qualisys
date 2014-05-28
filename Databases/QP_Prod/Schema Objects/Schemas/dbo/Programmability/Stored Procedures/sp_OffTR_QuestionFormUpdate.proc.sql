CREATE PROCEDURE sp_OffTR_QuestionFormUpdate
    @intQuestionFormID int,
    @datDateReturned   datetime

AS

UPDATE QuestionForm 
SET datResultsImported = getdate(), 
    datReturned = @datDateReturned, 
    strSTRBatchNumber = 'OffTR', 
    intSTRLineNumber = NULL 
WHERE QuestionForm_id = @intQuestionFormID


