CREATE PROCEDURE [dbo].[QCL_SelectAllEmployees]
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Employee_id, strEmployee_First_nm, strEmployee_Last_nm, strEmployee_Title, strNTLogin_nm, strEmail
FROM Employee
WHERE bitActive = 1
ORDER BY strEmployee_First_nm, strEmployee_Last_nm

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


