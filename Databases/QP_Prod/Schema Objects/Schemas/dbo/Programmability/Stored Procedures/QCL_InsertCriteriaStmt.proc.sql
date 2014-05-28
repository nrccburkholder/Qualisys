/****** Object:  Stored Procedure dbo.sp_DQ_CriteriaStmt    Script Date: 6/9/99 4:36:39 PM ******/
/******		Modified 06/02/03 BD Changed @@Identity to Scope_Identity().                  ******/
/**    Modified: 5/06/2004 - Dan Christensen - Added strcriteriastring  */
CREATE  PROCEDURE [dbo].[QCL_InsertCriteriaStmt]
 @Study_id int, 
 @CriteriaStmt_nm CHAR(8),
 @strcriteriaString varchar(8000),
 @CriteriaStmt_id INT OUTPUT
AS
 DECLARE @a VARCHAR(20)
 BEGIN TRANSACTION
 INSERT INTO CriteriaStmt (study_id, strcriteriastmt_nm, strCriteriaString)
 VALUES (@Study_id, @CriteriaStmt_nm, @strcriteriaString)
 SELECT @CriteriaStmt_id = SCOPE_IDENTITY()
 COMMIT TRANSACTION


