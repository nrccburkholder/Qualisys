/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_SkipPUReport
 *
 * Description:
 *           Create a new PU Report
 *
 * Parameters:
 *           @PU_ID          int
 *             Project Update ID
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_UI_SkipPUReport (
                       @PU_ID          int,
                       @Employee_ID    int
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @RPT_STATUS_SKIPPED          int

  SET @RPT_STATUS_SKIPPED = dbo.PU_CM_GetConstant('RPT_STATUS_SKIPPED')
  
  DECLARE @intReturn              int,
          @NextPUReport_ID        int
          
  SELECT @NextPUReport_ID = NextPUReport_ID
    FROM PU_Plan
   WHERE PU_ID = @PU_ID

  -- Check if PU_ID exists
  IF @@ROWCOUNT = 0 RETURN 1
  
  -- Check if PUReport exists
  IF @NextPUReport_ID IS NULL RETURN 2
  
  BEGIN TRAN
  
  -- Clear the next project update report in table PU_Plan.
  -- Add 1 week to the NextDueDate
  UPDATE PU_Plan
     SET NextPUReport_ID = NULL,
         NextDueDate = DATEADD(wk, 1, NextDueDate)
   WHERE PU_ID = @PU_ID
   
  -- Set update report's status to "skip"
  UPDATE PUR_Report
     SET Status = @RPT_STATUS_SKIPPED,
         SkippedBy = @Employee_ID,
         DateSkipped = GETDATE()
   WHERE PUReport_ID = @NextPUReport_ID
  
  -- Create the next update report 
  EXEC @intReturn = dbo.PU_UI_NextPUReport @PU_ID, @Employee_ID

  IF (@intReturn <> -1) BEGIN
      ROLLBACK TRAN
      RETURN 3
  END

  COMMIT TRAN
  
  RETURN -1


