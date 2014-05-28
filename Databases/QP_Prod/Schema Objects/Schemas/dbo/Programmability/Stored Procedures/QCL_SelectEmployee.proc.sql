/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     record of employee data associated with the given ID				 */
/*                       										 */  
/* Date Created:  10/17/2005                  								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE QCL_SelectEmployee
@Employee_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Employee_id, strEmployee_First_nm, strEmployee_Last_nm, strEmployee_Title, strNTLogin_nm, strEmail
FROM Employee
WHERE Employee_id = @Employee_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


