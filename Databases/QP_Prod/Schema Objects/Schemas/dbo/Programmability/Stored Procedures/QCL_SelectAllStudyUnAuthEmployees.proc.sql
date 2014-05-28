CREATE PROCEDURE [dbo].[QCL_SelectAllStudyUnAuthEmployees]
@StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

IF @StudyId = 0 --New Study
	SELECT Employee_id, strEmployee_First_nm, strEmployee_Last_nm, strEmployee_Title, strNTLogin_nm, strEmail
	FROM Employee
	WHERE bitActive = 1
		AND Employee_id NOT IN (
			SELECT Employee_id
			FROM Employee
			WHERE FullAccess = 1)
	ORDER BY strEmployee_First_nm, strEmployee_Last_nm
	
ELSE --Existing Study
	SELECT Employee_id, strEmployee_First_nm, strEmployee_Last_nm, strEmployee_Title, strNTLogin_nm, strEmail
	FROM Employee
	WHERE bitActive = 1
		AND Employee_id NOT IN (
			SELECT Employee_id FROM Study_Employee
			WHERE Study_id = @StudyId)
	ORDER BY strEmployee_First_nm, strEmployee_Last_nm


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


