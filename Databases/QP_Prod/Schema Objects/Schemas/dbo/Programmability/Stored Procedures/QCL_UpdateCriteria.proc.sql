/*
Business Purpose: 

This procedure is used to Update a record in Criteria Statement 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_UpdateCriteria]
@criteriaStmt_id INT,
@STRCRITERIASTMT_NM varchar(42),
@strCriteriaString text
AS

UPDATE CriteriaStmt 
SET STRCRITERIASTMT_NM=@STRCRITERIASTMT_NM, 
	strCriteriaString=@strCriteriaString
WHERE criteriaStmt_id=@criteriaStmt_id


