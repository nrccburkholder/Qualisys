--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/***********************************************************************************************************************************
SP Name: sp_CFG_FullAccessEmp
Part of:  Configuration Manager
Purpose:  Grants employees access to study if employees have full access
Input:  Study ID
Output:  
Creation Date: 02/14/2000
Author(s): DS
Revision: 
***********************************************************************************************************************************/

CREATE PROCEDURE sp_CFG_FullAccessEmp 
@new_study int
AS

INSERT INTO Study_Employee (Employee_id, Study_id)
	SELECT Employee_id, @new_study
	FROM Employee
	WHERE FullAccess = 1
	AND Employee_id NOT IN (
		SELECT Employee_id FROM Study_Employee
		WHERE Study_id = @new_study)


