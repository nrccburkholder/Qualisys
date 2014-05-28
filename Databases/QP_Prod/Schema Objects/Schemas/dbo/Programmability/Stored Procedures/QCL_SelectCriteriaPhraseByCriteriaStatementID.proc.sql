/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteriaPhraseByCriteriaStatementID]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  DISTINCT CRITERIASTMT_ID, CriteriaPhrase_Id
FROM CriteriaClause
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


