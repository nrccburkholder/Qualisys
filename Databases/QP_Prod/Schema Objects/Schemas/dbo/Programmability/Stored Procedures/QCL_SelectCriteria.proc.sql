/*
Business Purpose: 

This procedure is used to get information about a Criteria Statement.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteria]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  CriteriaStmt_Id, STUDY_ID, STRCRITERIASTMT_NM, strCriteriaString
FROM CRITERIASTMT
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


