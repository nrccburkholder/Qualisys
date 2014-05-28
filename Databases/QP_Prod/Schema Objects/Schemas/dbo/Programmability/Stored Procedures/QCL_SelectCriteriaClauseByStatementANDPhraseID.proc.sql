/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteriaClauseByStatementANDPhraseID]
@CriteriaStatement_Id INT,
@CriteriaPhrase_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT CRITERIACLAUSE_ID, CRITERIAPHRASE_ID, CRITERIASTMT_ID, TABLE_ID, FIELD_ID, INTOPERATOR, STRLOWVALUE, STRHIGHVALUE
FROM CriteriaClause
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id
	AND CriteriaPhrase_Id=@CriteriaPhrase_Id


