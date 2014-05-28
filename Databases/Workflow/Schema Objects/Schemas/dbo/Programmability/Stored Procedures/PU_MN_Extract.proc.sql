/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_Extract
 *
 * Description:
 *           Extract the following data that will be used for Project Update.
 *           This SP will be scheduled as a routine job in the DB server to be
 *           run at least once a day.
 *           (1) Employee
 *           (2) Teams and their client list
 *           (3) Survey's current and previous sample period
 *           (4) Sample unit tree
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
CREATE PROCEDURE dbo.PU_MN_Extract
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  DECLARE @intReturn      int


--  BEGIN TRAN

  ---------------------------
  -- Employee
  ---------------------------
  EXEC @intReturn = dbo.PU_MN_ExtractEmployee
  IF (@intReturn <> -1) BEGIN
--      ROLLBACK TRAN
      PRINT 'Error: Failed to extract employee. (PU_MN_ExtractEmployee)'
      RETURN 1
  END

  ---------------------------
  -- Teams and their clients
  ---------------------------
  EXEC @intReturn = dbo.PU_MN_ExtractTeamClient
  IF (@intReturn <> -1) BEGIN
--      ROLLBACK TRAN
      PRINT 'Error: Failed to extract teams and their client list . (PU_MN_ExtractTeamClient)'
      RETURN 2
  END
      
  ---------------------------
  -- Sample unit tree
  ---------------------------
  EXEC @intReturn = QP_Prod.dbo.PU_MN_ExtractSampleUnitTree
  IF (@intReturn <> -1) BEGIN
--      ROLLBACK TRAN
      PRINT 'Error: Failed to create sample unit tree . (PU_MN_ExtractSampleUnitTree)'
      RETURN 4
  END
      
  
  ---------------------------
  -- Extraction finished
  ---------------------------
--  COMMIT TRAN

  RETURN -1


