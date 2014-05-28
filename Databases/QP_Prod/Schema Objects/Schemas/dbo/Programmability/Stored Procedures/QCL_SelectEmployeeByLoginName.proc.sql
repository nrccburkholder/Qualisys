/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     record of employee data associated with the given NT Login Name				 */
/*                       										 */  
/* Date Created:  1/27/2006                  								 */  
/*                       										 */  
/* Created by:  Dan Christensen                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE [dbo].[QCL_SelectEmployeeByLoginName]
@LoginName varchar(100)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Employee_id, strEmployee_First_nm, strEmployee_Last_nm, strEmployee_Title, strNTLogin_nm, strEmail
FROM Employee
WHERE strNTLogin_nm = @LoginName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


