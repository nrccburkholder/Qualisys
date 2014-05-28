/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_UndoPost
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
CREATE PROCEDURE dbo.PU_UI_UndoPost (
                       @PUReport_ID   int
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @RPT_STATUS_SETUP           int,
          @RPT_STATUS_POSTED          int

  SET @RPT_STATUS_SETUP = dbo.PU_CM_GetConstant('RPT_STATUS_SETUP')
  SET @RPT_STATUS_POSTED = dbo.PU_CM_GetConstant('RPT_STATUS_POSTED')

  -- Variables
  DECLARE @PU_ID           int,
          @LastDueDate     datetime,
          @LastUpdateSent  datetime,
          @LastPUReport_ID int,
          @NextDueDate     datetime

  -- Check if this report has been posted
  IF NOT EXISTS (
      SELECT 1
        FROM PUR_Report
       WHERE PUReport_ID = @PUReport_ID
         AND Status = @RPT_STATUS_POSTED
     ) BEGIN
      PRINT 'This update hasn''t been posted'
      RETURN 1
  END
  
  -- Check if there is any report posted after this one
  IF EXISTS (
      SELECT 1
        FROM PUR_Report rp1,
             PUR_Report rp2
       WHERE rp1.PUReport_ID = @PUReport_ID
         AND rp2.PU_ID = rp1.PU_ID
         AND rp2.PUReport_ID > @PUReport_ID
         AND rp2.Status = @RPT_STATUS_POSTED
     ) BEGIN
      PRINT 'Some update posted after this one. Only the last posted update can be undo.'
      RETURN 2
  END
  
  -- Get info of this report
  SELECT @PU_ID = PU_ID,
         @NextDueDate = DueDate
    FROM PUR_Report
   WHERE PUReport_ID = @PUReport_ID
  
  -- Get info of previous posted report
  SELECT @LastDueDate = DueDate,
         @LastUpdateSent = DatePosted,
         @LastPUReport_ID = PUReport_ID
    FROM PUR_Report
   WHERE PUReport_ID IN (
                       SELECT MAX(PUReport_ID)
                         FROM PUR_Report
                        WHERE PU_ID = @PU_ID
                          AND PUReport_ID < @PUReport_ID
                          AND Status = @RPT_STATUS_POSTED
                     )

  BEGIN TRAN
  
  UPDATE PU_Plan
     SET LastDueDate = @LastDueDate,
         LastUpdateSent = @LastUpdateSent,
         LastPUReport_ID = @LastPUReport_ID,
         NextDueDate = @NextDueDate,
         NextPUReport_ID = @PUReport_ID
   WHERE PU_ID = @PU_ID

  UPDATE PUR_Report
     SET Status = @RPT_STATUS_SETUP,
         PostedBy = NULL,
         DatePosted = NULL
   WHERE PUReport_ID = @PUReport_ID
     
  COMMIT TRAN
  
  RETURN -1


