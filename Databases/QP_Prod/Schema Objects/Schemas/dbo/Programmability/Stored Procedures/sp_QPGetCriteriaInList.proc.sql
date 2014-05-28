CREATE PROCEDURE dbo.sp_QPGetCriteriaInList
    @CriteriaClauseID int

AS

SELECT CriteriaInList_id, strListValue 
FROM CriteriaInList 
WHERE CriteriaClause_id = @CriteriaClauseID 
ORDER BY CriteriaInList_id


