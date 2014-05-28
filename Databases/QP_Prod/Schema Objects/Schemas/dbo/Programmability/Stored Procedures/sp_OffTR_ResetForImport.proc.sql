CREATE PROCEDURE sp_OffTR_ResetForImport
    @intSentMailID     int,
    @intQuestionFormID int

AS

--Reset the datUndeliverable
UPDATE SentMailing 
SET datUndeliverable = NULL 
WHERE SentMail_id = @intSentMailID

--Reset the QuestionForm record
UPDATE QuestionForm 
SET datReturned = NULL, UnusedReturn_id = NULL, datUnusedReturn = NULL, datResultsImported = NULL, 
    strSTRBatchNumber = NULL, intSTRLineNumber = NULL, intPhoneAttempts = NULL 
WHERE QuestionForm_id = @intQuestionFormID

--Remove any existing question results
DELETE FROM QuestionResult 
WHERE QuestionForm_id = @intQuestionFormID

DELETE FROM QuestionResult2 
WHERE QuestionForm_id = @intQuestionFormID

--Remove all comment data
CREATE TABLE #CmntIDs (Cmnt_id int)

INSERT INTO #CmntIDs (Cmnt_id)
SELECT Cmnt_id 
FROM Comments 
WHERE QuestionForm_id = @intQuestionFormID

DELETE FROM Comments
WHERE QuestionForm_id = @intQuestionFormID

DELETE FROM CommentSelCodes
WHERE Cmnt_id IN (Select Cmnt_id FROM #CmntIDs)

DROP TABLE #CmntIDs


