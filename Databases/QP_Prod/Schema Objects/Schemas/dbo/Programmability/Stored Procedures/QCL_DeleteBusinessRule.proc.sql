/*
Business Purpose: 

This procedure is used to Delete a BusinessRule  

Created:  03/13/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteBusinessRule]
@BusinessRule_Id INT
AS

DELETE BusinessRule
WHERE BusinessRule_ID=@BusinessRule_Id


