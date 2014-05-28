CREATE PROCEDURE [dbo].[QSL_InsertQSIDataForm]
    @Batch_ID        INT,
    @LithoCode       VARCHAR(10),
    @SentMail_ID     INT,
    @QuestionForm_ID INT,
    @Survey_ID       INT,
    @TemplateCode    CHAR(1),
    @LangID          INT,
    @DateKeyed       DATETIME,
    @KeyedBy         VARCHAR(50),
    @DateVerified    DATETIME,
    @VerifiedBy      VARCHAR(50)
AS

--Setup the environment
SET NOCOUNT ON

--Insert the new form
INSERT INTO [dbo].QSIDataForm (Batch_ID, LithoCode, SentMail_ID, QuestionForm_ID, Survey_ID, TemplateCode, LangID, DateKeyed, KeyedBy, DateVerified, VerifiedBy)
VALUES (@Batch_ID, @LithoCode, @SentMail_ID, @QuestionForm_ID, @Survey_ID, @TemplateCode, @LangID, @DateKeyed, @KeyedBy, @DateVerified, @VerifiedBy)

--Return the form_id
SELECT SCOPE_IDENTITY()

--Reset the environment
SET NOCOUNT OFF


