CREATE PROCEDURE dbo.sp_QPGetCriteriaStmt
    @CriteriaStmtID int

AS

SELECT Study_id, strCriteriaStmt_Nm 
FROM CriteriaStmt 
WHERE CriteriaStmt_id = @CriteriaStmtID


