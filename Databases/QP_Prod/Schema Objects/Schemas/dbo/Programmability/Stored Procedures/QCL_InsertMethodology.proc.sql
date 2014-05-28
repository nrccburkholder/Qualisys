CREATE PROCEDURE QCL_InsertMethodology
@SurveyId INT,
@Name VARCHAR(42),
@StandardMethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

INSERT INTO MailingMethodology (Survey_id, bitActiveMethodology, strMethodology_nm, datCreate_dt, StandardMethodologyID)
SELECT @SurveyId, 0, @Name, GETDATE(), @StandardMethodologyId

SELECT SCOPE_IDENTITY()


