SET ANSI_NULLS OFF
GO  

IF (ObjectProperty(Object_Id('dbo.APB_OT_OverrideOldReport'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.APB_OT_OverrideOldReport
GO


/*******************************************************************************
 *
 * Procedure Name:
 *           APB_OT_OverrideOldReport
 *
 * Description:
 *           Set override flag for the previous jobs of the same AP
 *
 * Parameters:
 *           @Job_ID       current job ID
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           1.0  02/06/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.APB_OT_OverrideOldReport (
        @Job_ID     int
       )
AS
  -- Constants
  DECLARE
      @JOB_PDF_GENERATED                    int
          
  SET @JOB_PDF_GENERATED                    = dbo.APB_CM_Constant('JOB_PDF_GENERATED')

  -- Variables
  DECLARE @AP_ID     char(20)
  
  
  --
  -- Check if job exists, status is "PDF generated"
  --
  IF NOT EXISTS (
      SELECT 1
        FROM tbl_ApJobList
       WHERE Job_ID = @Job_ID
         AND Status = @JOB_PDF_GENERATED
     )
      RETURN 1
  
  --
  -- Set its "OverriddenByJob_ID" to 0
  --
  UPDATE tbl_ApJobList
     SET OverriddenByJob_ID = 0
   WHERE Job_ID = @Job_ID
  
  --
  -- Set "OverriddenByJob_ID" for jobs that has the same AP_ID
  -- and haven't been overridden
  --
  SELECT @AP_ID = AP_ID
    FROM tbl_ApJobList
   WHERE Job_ID = @Job_ID
  
  UPDATE tbl_ApJobList
     SET OverriddenByJob_ID = @Job_ID
   WHERE Job_ID <> @Job_ID
     AND AP_ID = @AP_ID
     AND Status = @JOB_PDF_GENERATED
     AND OverriddenByJob_ID = 0


  RETURN 0
  
GO