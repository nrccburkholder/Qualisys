CREATE PROCEDURE [dbo].[QSL_SelectQSIDataFormsByTemplateName]
    @Batch_ID      INT,
    @TemplateName  VARCHAR(62),
    @DataEntryMode INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
IF @DataEntryMode = 0  --0 = Entry, 1 = Verify
BEGIN
    SELECT Form_ID, Batch_ID, LithoCode, SentMail_ID, QuestionForm_ID, Survey_ID, TemplateCode, LangID, TemplateName, DateKeyed, KeyedBy, DateVerified, VerifiedBy
    FROM QSIDataForm
    WHERE Batch_ID = @Batch_ID
      AND TemplateName = @TemplateName
      AND DateKeyed IS NULL
END
ELSE
BEGIN
    SELECT Form_ID, Batch_ID, LithoCode, SentMail_ID, QuestionForm_ID, Survey_ID, TemplateCode, LangID, TemplateName, DateKeyed, KeyedBy, DateVerified, VerifiedBy
    FROM QSIDataForm
    WHERE Batch_ID = @Batch_ID
      AND TemplateName = @TemplateName
      AND DateKeyed IS NOT NULL
      AND DateVerified IS NULL
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


