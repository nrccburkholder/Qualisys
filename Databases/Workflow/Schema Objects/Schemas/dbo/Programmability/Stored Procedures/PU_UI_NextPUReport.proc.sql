/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_NextPUReport
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
CREATE PROCEDURE dbo.PU_UI_NextPUReport (
                       @PU_ID          int,
                       @Employee_ID    int
) AS

  SET NOCOUNT ON
  
  DECLARE @intReturn              int,
          @LastPUReport_ID        int
          


  -- Check if PU_ID exists
  IF NOT EXISTS (
      SELECT PU_ID
        FROM PU_Plan
       WHERE PU_ID = @PU_ID
     )
      RETURN 1

  -- Check if PUReport exists
  IF EXISTS (
      SELECT PU_ID
        FROM PU_Plan
       WHERE PU_ID = @PU_ID
         AND NextPUReport_ID IS NOT NULL
     )
      RETURN 2
  
  -- Check if last PUReport exists
  SELECT @LastPUReport_ID = LastPUReport_ID
    FROM PU_Plan
   WHERE PU_ID = @PU_ID
  
  -- If last PUReport exists, copy from last PUReport
  IF @LastPUReport_ID IS NOT NULL
      EXEC @intReturn = dbo.PU_UI_CopyPUReport @PU_ID, @LastPUReport_ID, @Employee_ID
      
  -- If last PUReport doesn't exist, create PUReport from scratch
  ELSE
      EXEC @intReturn =  dbo.PU_UI_NewPUReport @PU_ID, @Employee_ID 
  
  IF (@intReturn <> -1) RETURN 3
  
  RETURN -1


