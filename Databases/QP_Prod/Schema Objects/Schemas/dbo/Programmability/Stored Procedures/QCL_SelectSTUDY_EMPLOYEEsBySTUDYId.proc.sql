﻿CREATE PROCEDURE [dbo].[QCL_SelectSTUDY_EMPLOYEEsBySTUDYId]
@STUDY_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT  a.EMPLOYEE_ID, STUDY_ID, b.STREMPLOYEE_FIRST_NM + ' ' + b.STREMPLOYEE_LAST_NM EMPLOYEENAME
FROM [dbo].STUDY_EMPLOYEE a INNER JOIN [dbo].EMPLOYEE b
	ON a.EMPLOYEE_ID = b.EMPLOYEE_ID
WHERE STUDY_ID = @STUDY_ID
ORDER BY b.STREMPLOYEE_FIRST_NM + ' ' + b.STREMPLOYEE_LAST_NM

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


