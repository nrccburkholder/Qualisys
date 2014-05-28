CREATE PROCEDURE dbo.sp_QPGetCriteriaPhrase
    @CriteriaStmtID int

AS

SELECT Distinct CriteriaPhrase_id 
FROM CriteriaClause 
WHERE CriteriaStmt_id = @CriteriaStmtID
ORDER BY CriteriaPhrase_id


