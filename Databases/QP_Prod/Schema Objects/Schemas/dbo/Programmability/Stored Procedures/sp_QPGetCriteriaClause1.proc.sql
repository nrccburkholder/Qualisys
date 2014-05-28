CREATE PROCEDURE dbo.sp_QPGetCriteriaClause1
    @CriteriaStmtID   int, 
    @CriteriaPhraseID int

AS

SELECT CriteriaClause_id, Table_id, Field_id, intOperator, strLowValue, strHighValue 
FROM CriteriaClause 
WHERE CriteriaStmt_id = @CriteriaStmtID 
  AND CriteriaPhrase_id = @CriteriaPhraseID 
ORDER BY CriteriaClause_id


