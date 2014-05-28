CREATE PROCEDURE dbo.sp_QPUpdateCriteriaStmt
    @CriteriaStmtID   int, 
    @CriteriaStmtName varchar(8)

AS

--Update the Statement
UPDATE CriteriaStmt 
SET strCriteriaStmt_Nm = @CriteriaStmtName
WHERE CriteriaStmt_id = @CriteriaStmtID
    
--Delete everything from CriteriaInList for this statement
DELETE FROM CriteriaInList 
FROM CriteriaClause 
WHERE CriteriaInList.CriteriaClause_id = CriteriaClause.CriteriaClause_id 
  AND CriteriaClause.CriteriaStmt_id = @CriteriaStmtID
    
--Delete everything from CriteriaClause for this statement
DELETE 
FROM CriteriaClause 
WHERE CriteriaStmt_id = @CriteriaStmtID


