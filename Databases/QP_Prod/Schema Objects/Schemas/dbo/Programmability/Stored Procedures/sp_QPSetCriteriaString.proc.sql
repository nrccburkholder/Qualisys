CREATE PROCEDURE dbo.sp_QPSetCriteriaString
    @CriteriaStmtID int, 
    @CriteriaString varchar(7990)

AS

--Update the Statement
UPDATE CriteriaStmt 
SET strCriteriaString = @CriteriaString
WHERE CriteriaStmt_id = @CriteriaStmtID


