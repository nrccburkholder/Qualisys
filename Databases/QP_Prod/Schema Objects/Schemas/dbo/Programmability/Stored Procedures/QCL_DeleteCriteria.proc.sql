/*
Business Purpose: 

This procedure is used to Delete a criteria  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteCriteria]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

EXEC QCL_DeleteCriteriaPhrases @CriteriaStatement_Id

DELETE criteriaStmt
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


