CREATE PROCEDURE [dbo].[QCL_UpdateMM_EmailBlast]
@MM_EmailBlast_ID INT,
@MAILINGSTEP_ID INT,
@EmailBlast_ID INT,
@DaysFromStepGen INT,
@DateSent DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].MM_EmailBlast SET
	MAILINGSTEP_ID = @MAILINGSTEP_ID,
	EmailBlast_ID = @EmailBlast_ID,
	DaysFromStepGen = @DaysFromStepGen,
	DateSent = @DateSent
WHERE MM_EmailBlast_ID = @MM_EmailBlast_ID

SET NOCOUNT OFF


