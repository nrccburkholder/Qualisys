/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_DeleteUpdate
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
CREATE PROCEDURE dbo.PU_UI_DeleteUpdate (
                       @PU_ID         int,
                       @Employee_ID   int
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @PLAN_STATUS_USING           int,
          @PLAN_STATUS_DELETED         int

  SET @PLAN_STATUS_USING = dbo.PU_CM_GetConstant('PLAN_STATUS_USING')
  SET @PLAN_STATUS_DELETED = dbo.PU_CM_GetConstant('PLAN_STATUS_DELETED')

  UPDATE PU_Plan
     SET Status = @PLAN_STATUS_DELETED,
         DeletedBy = @Employee_ID,
         DateDeleted = GETDATE()
   WHERE PU_ID = @PU_ID
  
  RETURN -1


