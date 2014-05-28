CREATE PROCEDURE dbo.sp_QPAddCriteriaClause  
    @CriteriaPhraseID int,   
    @CriteriaStmtID   int,   
    @TableID          int,   
    @FieldID          int,   
    @OperatorID       int,   
    @LowValue         varchar(42),   
    @HighValue        varchar(42),   
    @CriteriaClauseID int output  
  
AS  
  
INSERT INTO CriteriaClause (CriteriaPhrase_id, CriteriaStmt_id, Table_id, Field_id, intOperator, strLowValue, strHighValue)   
VALUES (@CriteriaPhraseID, @CriteriaStmtID, @TableID, @FieldID, @OperatorID, @LowValue, @HighValue)  
  
SELECT @CriteriaClauseID = SCOPE_IDENTITY()


