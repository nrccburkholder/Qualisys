/*
Business Purpose: 

This procedure is used to Delete All the criteria Phrases  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteCriteriaPhrases]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DELETE ci
FROM CRITERIAInList ci, criteriaClause cp
WHERE cp.CRITERIASTMT_ID=@CriteriaStatement_Id
	AND ci.criteriaClause_id=cp.criteriaClause_Id

DELETE criteriaClause
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


