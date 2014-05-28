CREATE PROCEDURE [dbo].[QSL_SelectQSIDataFormsByBatchId]
    @Batch_ID INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT Form_ID, Batch_ID, LithoCode, SentMail_ID, QuestionForm_ID, Survey_ID, TemplateCode, LangID, TemplateName, DateKeyed, KeyedBy, DateVerified, VerifiedBy
FROM QSIDataForm
WHERE Batch_ID = @Batch_ID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


