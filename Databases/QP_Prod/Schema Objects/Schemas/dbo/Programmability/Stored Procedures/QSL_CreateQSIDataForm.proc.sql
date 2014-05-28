CREATE PROCEDURE [dbo].[QSL_CreateQSIDataForm]
    @BatchID   INT, 
    @LithoCode VARCHAR(10)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare the required variables
DECLARE @FormID         INT
DECLARE @BatchName      VARCHAR(85)
DECLARE @QuestionFormID INT

--Get the batch name
SELECT @BatchName = BatchName
FROM QSIDataBatch
WHERE Batch_ID = @BatchID

--Get the QuestionForm_ID
SELECT @QuestionFormID = qf.QuestionForm_ID
FROM SentMailing sm, QuestionForm qf
WHERE sm.SentMail_id = qf.SentMail_id
  AND sm.strLithoCode = @LithoCode

--Insert the new data form
INSERT INTO QSIDataForm (Batch_ID, LithoCode, SentMail_ID, QuestionForm_ID, Survey_ID, TemplateCode, LangID)
SELECT TOP 1 @BatchID, sm.strLithoCode, sm.SentMail_ID, qf.QuestionForm_ID, qf.Survey_ID, ps.strTemplateCode, sm.LangID
FROM SentMailing sm, QuestionForm qf, PaperConfigSheet pc, PaperSize ps
WHERE sm.SentMail_ID = qf.SentMail_ID
  AND sm.PaperConfig_id = pc.PaperConfig_id         
  AND pc.PaperSize_id = ps.PaperSize_id         
  AND sm.strLithoCode = @LithoCode
ORDER BY pc.intSheet_Num DESC        

--Get the FormID
SELECT @FormID = SCOPE_IDENTITY()

--Mark the scan batch
UPDATE QuestionForm 
SET strScanBatch = 'QSIDataEntry - ' + @BatchName 
WHERE QuestionForm_id = @QuestionFormID

--Get the resultset
SELECT Form_ID, Batch_ID, LithoCode, SentMail_ID, QuestionForm_ID, Survey_ID, TemplateCode, LangID, TemplateName, DateKeyed, KeyedBy, DateVerified, VerifiedBy
FROM QSIDataForm
WHERE Form_ID = @FormID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


