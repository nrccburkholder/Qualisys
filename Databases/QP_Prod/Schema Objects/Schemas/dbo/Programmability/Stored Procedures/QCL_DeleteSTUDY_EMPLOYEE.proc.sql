﻿CREATE PROCEDURE [dbo].[QCL_DeleteSTUDY_EMPLOYEE]
@EMPLOYEE_ID INT,
@STUDY_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].STUDY_EMPLOYEE
WHERE EMPLOYEE_ID = @EMPLOYEE_ID
	AND STUDY_ID = @STUDY_ID

SET NOCOUNT OFF


