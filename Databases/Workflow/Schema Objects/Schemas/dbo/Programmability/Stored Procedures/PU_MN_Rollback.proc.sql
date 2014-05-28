/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_Rollback
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
CREATE PROCEDURE [dbo].[PU_MN_Rollback] (
                       @PUReport_ID   int
) AS

  -- Constants
  DECLARE @RPT_STATUS_SETUP           int,
          @RPT_STATUS_POSTED          int,
          @RPT_STATUS_SKIPPED         int

  SET @RPT_STATUS_SETUP = dbo.sp_PU_CM_GetConstant('RPT_STATUS_SETUP')
  SET @RPT_STATUS_POSTED = dbo.sp_PU_CM_GetConstant('RPT_STATUS_POSTED')
  SET @RPT_STATUS_SKIPPED = dbo.sp_PU_CM_GetConstant('RPT_STATUS_SKIPPED')

  DECLARE @PU_ID              int,
          @LastPUReport_ID    int
  
  SET NOCOUNT ON
  SET XACT_ABORT ON
  
  -- Check if @PUReport_ID exists
  IF NOT EXISTS (
        SELECT *
          FROM PUR_Report
         WHERE PUReport_ID = @PUReport_ID
     ) BEGIN
  
      PRINT CONVERT(varchar, @PUReport_ID) + ' is not a existing PU Report ID.'
      RETURN 1
  END
  
  -- Check if @PUReport_ID is posted or skipped
  SELECT @PU_ID = PU_ID
    FROM PUR_Report
   WHERE PUReport_ID = @PUReport_ID
     AND Status IN (@RPT_STATUS_SKIPPED, @RPT_STATUS_POSTED)
  
  IF (@@ROWCOUNT = 0) BEGIN
      PRINT 'Project Update ' + CONVERT(varchar, @PUReport_ID) + ' hasn''t been posted or skipped.'
      RETURN 2
  END
  
  -- Check if PU is deleted
  IF NOT EXISTS (
        SELECT *
          FROM PU_Plan
         WHERE PU_ID = @PU_ID
           AND Status = 0
     ) BEGIN
  
      PRINT 'This project Update (PU ID#' + CONVERT(varchar, @PU_ID) + ') has been deleted.'
      RETURN 3
  END
  
  -- Get the prevous PUReport ID
  SELECT TOP 1 
         @LastPUReport_ID = MAX(PUReport_ID)
    FROM PUR_Report
   WHERE PU_ID = @PU_ID
     AND PUReport_ID < @PUReport_ID
     AND Status = @RPT_STATUS_POSTED
  
  -- Pull the PUReport ID that after the @PUReport_ID.
  -- These PUReport ID need to be deleted
  CREATE TABLE #DeletePUReport (
         PUReport_ID   int NOT NULL
  )
  
  INSERT INTO #DeletePUReport
  SELECT PUReport_ID
    FROM PUR_Report
   WHERE PU_ID = @PU_ID
     AND PUReport_ID > @PUReport_ID


  -- Check
  SELECT @PU_ID AS PU_ID,
         @LastPUReport_ID AS LastPUReport_ID

  SELECT rp.*
    FROM #DeletePUReport dr,
         PUR_Report rp
   WHERE dr.PUReport_ID = rp.PUReport_ID
   ORDER BY rp.PUReport_ID


  SET NOCOUNT OFF

  BEGIN TRAN

  ------------------------------
  -- Rollback on Workflow
  ------------------------------
  
  -- PU_Plan: set last report info
  UPDATE PU_Plan
     SET LastDueDate = NULL,
         LastUpdateSent = NULL,
         LastPUReport_ID = NULL
   WHERE PU_ID = @PU_ID

  UPDATE pl
     SET LastDueDate = rp.DueDate,
         LastUpdateSent = rp.DatePosted,
         LastPUReport_ID = rp.PUReport_ID
    FROM PU_Plan pl,
         PUR_Report rp
   WHERE pl.PU_ID = @PU_ID
     AND rp.PUReport_ID = @LastPUReport_ID
  
  -- PU_Plan: set current report info
  UPDATE pl
     SET NextDueDate = rp.DueDate,
         NextPUReport_ID = rp.PUReport_ID
    FROM PU_Plan pl,
         PUR_Report rp
   WHERE pl.PU_ID = @PU_ID
     AND rp.PUReport_ID = @PUReport_ID

  -- Update PUR_Report
  UPDATE PUR_Report
     SET Status = @RPT_STATUS_SETUP,
         PostedBy = NULL,
         DatePosted = NULL,
         SkippedBy = NULL,
         DateSkipped = NULL
   WHERE PUReport_ID = @PUReport_ID
  
  -- Delete PUR_Addressee
  DELETE FROM rp
    FROM PUR_Addressee rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID
  
  -- Delete PUR_Attachment
  DELETE FROM rp
    FROM PUR_Attachment rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Period
  DELETE FROM rp
    FROM PUR_Period rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_PeriodCustom
  DELETE FROM rp
    FROM PUR_PeriodCustom rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Report
  DELETE FROM rp
    FROM PUR_Report rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultHeadInfo
  DELETE FROM rp
    FROM PUR_ResultHeadInfo rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultHeadInfoAddressee
  DELETE FROM rp
    FROM PUR_ResultHeadInfoAddressee rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultLoading
  DELETE FROM rp
    FROM PUR_ResultLoading rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultResponseRate
  DELETE FROM rp
    FROM PUR_ResultResponseRate rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultResponseRateCutOffField
  DELETE FROM rp
    FROM PUR_ResultResponseRateCutOffField rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultSampling
  DELETE FROM rp
    FROM PUR_ResultSampling rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Section
  DELETE FROM rp
    FROM PUR_Section rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Survey
  DELETE FROM rp
    FROM PUR_Survey rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ViewHistory
  DELETE FROM rp
    FROM PUR_ViewHistory rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID


  ------------------------------------
  -- Rollback on datamart
  ------------------------------------
  
  -- Delete this and following reports from datamart
  INSERT INTO #DeletePUReport
  VALUES (@PUReport_ID)
  
  -- PU_Plan: set last report info
  UPDATE dm
     SET LastDueDate = wf.LastDueDate,
         LastUpdateSent = wf.LastUpdateSent,
         LastPUReport_ID = wf.LastPUReport_ID,
         NextDueDate = wf.NextDueDate,
         NextPUReport_ID = wf.NextPUReport_ID
    FROM DATAMART.QP_Comments.dbo.PU_Plan dm,
         PU_Plan wf
   WHERE dm.PU_ID = @PU_ID
     AND wf.PU_ID = @PU_ID

  -- Delete PUR_Report
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_Report rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Addressee
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_Addressee rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID
  
  -- Delete PUR_ResultHeadInfo
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_ResultHeadInfo rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultHeadInfoAddressee
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_ResultHeadInfoAddressee rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultLoading
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_ResultLoading rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultResponseRate
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_ResultResponseRate rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultResponseRateCutOffField
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_ResultResponseRateCutOffField rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_ResultSampling
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_ResultSampling rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Section
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_Section rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID

  -- Delete PUR_Survey
  DELETE FROM rp
    FROM DATAMART.QP_Comments.dbo.PUR_Survey rp,
         #DeletePUReport dr
   WHERE rp.PUReport_ID = dr.PUReport_ID


  COMMIT TRAN
  -- ROLLBACK TRAN
  
  RETURN -1


