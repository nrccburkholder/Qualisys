CREATE PROCEDURE [dbo].[QCL_InsertMM_EmailBlast]
@MAILINGSTEP_ID INT,
@EmailBlast_ID INT,
@DaysFromStepGen INT,
@DateSent DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].MM_EmailBlast (MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent)
VALUES (@MAILINGSTEP_ID, @EmailBlast_ID, @DaysFromStepGen, @DateSent)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


