/****** Object:  Stored Procedure dbo.sp_QPAddCriteriaStmt    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddCriteriaStmt    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddCriteriaStmt    Script Date: 12/7/98 2:34:55 PM ******/
CREATE PROCEDURE sp_QPAddCriteriaStmt 
@mintStudy_ID int,
@mstrStmtName varchar(8),
@IDKey int OUTPUT
AS
BEGIN TRANSACTION
INSERT INTO CriteriaStmt 
(Study_ID,strCriteriaStmt_nm)
VALUES
(@mintStudy_ID, @mstrStmtName)
SELECT @IDKey = SCOPE_IDENTITY()  
COMMIT TRANSACTION


