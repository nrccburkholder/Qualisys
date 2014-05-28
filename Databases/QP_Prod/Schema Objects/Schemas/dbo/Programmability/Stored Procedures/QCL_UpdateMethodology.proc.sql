CREATE PROCEDURE QCL_UpdateMethodology
@MethodologyId INT,
@SurveyId INT,
@Name VARCHAR(42),
@StandardMethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE MailingMethodology 
SET Survey_id=@SurveyId,
	strMethodology_nm=@Name,
	StandardMethodologyId=@StandardMethodologyId
WHERE Methodology_id=@MethodologyId


