/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_PostUpdate
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
CREATE PROCEDURE dbo.PU_UI_PostUpdate (
                       @PUReport_ID    int,
                       @Employee_ID    int
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @RPT_STATUS_SETUP           int,
          @RPT_STATUS_POSTED          int

  SET @RPT_STATUS_SETUP = dbo.PU_CM_GetConstant('RPT_STATUS_SETUP')
  SET @RPT_STATUS_POSTED = dbo.PU_CM_GetConstant('RPT_STATUS_POSTED')

  -- Variables
  DECLARE @PU_ID           int,
          @Status          tinyint,
          @DueDate         datetime,
          @NextDueDate     datetime,
          @ReportDay       tinyint,
          @WaitDays        smallint
          
  
  -- Check if the report's status is correct
  SELECT @PU_ID = PU_ID,
         @Status = Status
    FROM PUR_Report
   WHERE PUReport_ID = @PUReport_ID
  
  IF @@ROWCOUNT = 0 RETURN 1
  
  IF @Status <> @RPT_STATUS_SETUP RETURN 2

  -- Calculate the next due date
  SELECT @DueDate = NextDueDate,
         @ReportDay = ReportDay
    FROM PU_Plan
   WHERE PU_ID = @PU_ID
  
  SET @WaitDays = @ReportDay - DATEPART(dw, @DueDate)
  
  IF @WaitDays <= 0
      SET @WaitDays = @WaitDays + 7
  
  SET @NextDueDate = CONVERT(varchar, DATEADD(d, @WaitDays, @DueDate), 101)
  
  -- PRINT '@NextDueDate=' + CONVERT(varchar, @NextDueDate)
  
  BEGIN TRAN
      UPDATE PU_Plan
         SET LastDueDate = NextDueDate,
             LastUpdateSent = GETDATE(),
             LastPUReport_ID = NextPUReport_ID
       WHERE PU_ID = @PU_ID
       
      UPDATE PU_Plan
         SET NextDueDate = @NextDueDate,
             NextPUReport_ID = NULL
       WHERE PU_ID = @PU_ID

      UPDATE PUR_Report
         SET Status = @RPT_STATUS_POSTED,
             PostedBy = @Employee_ID,
             DatePosted = GETDATE()
       WHERE PUReport_ID = @PUReport_ID
  
  COMMIT TRAN
  
  RETURN -1


