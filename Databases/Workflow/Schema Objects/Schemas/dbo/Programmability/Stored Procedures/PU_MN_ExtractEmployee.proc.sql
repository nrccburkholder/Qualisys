/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractEmployee
 *
 * Description:
 *           Extract Employee table from Qualisys to Workflow database
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_MN_ExtractEmployee
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  DECLARE @intReturn      int
  
  ---------------------------
  -- Employee
  ---------------------------
  EXEC @intReturn = PU_CM_DropTable 'Employee'
  IF (@intReturn <> -1) RETURN 1
  
  SELECT *
    INTO Employee
    FROM QP_Prod.dbo.Employee

  IF (@@ERROR <> 0) RETURN 2

  ALTER TABLE dbo.Employee WITH NOCHECK ADD 
	CONSTRAINT PK_Employee PRIMARY KEY  CLUSTERED 
	(
		Employee_ID
	) ON 'PRIMARY' 

  IF (@@ERROR <> 0) RETURN 3

  CREATE UNIQUE INDEX idx_ntlogin 
      ON dbo.Employee(strNtLogin_Nm) 
      ON 'PRIMARY'

  IF (@@ERROR <> 0) RETURN 4

  UPDATE STATISTICS Employee WITH FULLSCAN
  
  RETURN -1


