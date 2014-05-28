CREATE PROCEDURE [dbo].[QSL_SaveLithoCodeToQualiSys]
@SentMailID INT,
@QuestionFormID INT,
@DateReturned DATETIME,
@BatchNumber VARCHAR(8),
@ReceiptTypeID INT
AS

SET NOCOUNT ON

--Update the SentMailing record
UPDATE SentMailing
SET datUndeliverable = NULL
WHERE SentMail_ID = @SentMailID

--Update the QuestionForm record
UPDATE QuestionForm
SET datReturned = @DateReturned, 
    datResultsImported = GetDate(), 
    strSTRBatchNumber = @BatchNumber, 
    intSTRLineNumber = NULL,
    ReceiptType_id = @ReceiptTypeID
WHERE QuestionForm_id = @QuestionFormID

SET NOCOUNT OFF


