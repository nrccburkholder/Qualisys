CREATE PROCEDURE [dbo].[QSL_UpdateQSIDataForm]
    @Form_ID         INT,
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

--Update the form
UPDATE [dbo].QSIDataForm SET
	Batch_ID = @Batch_ID,
	LithoCode = @LithoCode,
	SentMail_ID = @SentMail_ID,
	QuestionForm_ID = @QuestionForm_ID,
	Survey_ID = @Survey_ID,
	TemplateCode = @TemplateCode,
	LangID = @LangID,
	DateKeyed = @DateKeyed,
	KeyedBy = @KeyedBy,
	DateVerified = @DateVerified,
	VerifiedBy = @VerifiedBy
WHERE Form_ID = @Form_ID

--Reset the environment
SET NOCOUNT OFF


