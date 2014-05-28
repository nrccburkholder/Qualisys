/*
Business Purpose: 

This procedure is used to Insert a record into Criteria Statement 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertCriteria]
@study_Id INT,
@STRCRITERIASTMT_NM varchar(42),
@strCriteriaString text
AS

INSERT INTO CriteriaStmt (STUDY_ID, STRCRITERIASTMT_NM, strCriteriaString)
VALUES (@study_Id, @STRCRITERIASTMT_NM, @strCriteriaString)

SELECT SCOPE_IDENTITY() as criteriastmt_id


