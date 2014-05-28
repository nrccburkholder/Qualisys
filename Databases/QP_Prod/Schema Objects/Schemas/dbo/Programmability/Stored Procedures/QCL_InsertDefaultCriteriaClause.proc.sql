/****** Object:  Stored Procedure dbo.sp_DQ_CriteriaClause    Script Date: 6/9/99 4:36:39 PM ******/
/******		Modified 06/02/03 BD Changed @@Identity to Scope_Identity().                    ******/
CREATE PROCEDURE [dbo].[QCL_InsertDefaultCriteriaClause] 
 @CriteriaPhrase_id int, 
 @CriteriaStmt_id int, 
 @Table_id int, 
 @Field_str varchar(32), 
 @Operator varchar(20), 
 @LowValue varchar(20),
 @HighValue varchar(20),
 @CriteriaClause_id int OUTPUT
AS
 DECLARE @field_id int, @operator_num int
 SELECT @field_id = mf.Field_id
 FROM dbo.metafield mf
 WHERE mf.strfield_nm = @Field_Str
 SELECT @operator_num = Operator_Num
 FROM dbo.operator
 WHERE strOperator = @Operator

 BEGIN TRANSACTION
	 INSERT INTO CriteriaClause(criteriaphrase_id, criteriastmt_id, table_id, field_id, intoperator, strlowvalue, strhighvalue)
	 VALUES(@CriteriaPhrase_id, @CriteriaStmt_id, @Table_id, @Field_id, @Operator_Num, @LowValue, @HighValue)

	 SELECT @CriteriaClause_id = SCOPE_IDENTITY()
 COMMIT TRANSACTION


