CREATE PROCEDURE dbo.sp_QPAddCriteriaInList
    @CriteriaClauseID int, 
    @ListValue        varchar(42)

AS

INSERT INTO CriteriaInList (CriteriaClause_id, strListValue) 
VALUES (@CriteriaClauseID, @ListValue)


