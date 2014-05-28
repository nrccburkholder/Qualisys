/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_DeleteTeam
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
CREATE PROCEDURE dbo.PU_UI_DeleteTeam (
                       @Team_ID       int
) AS

  SET NOCOUNT ON

  BEGIN TRAN
  
  DELETE Team
   WHERE Team_ID = @Team_ID

  DELETE TeamMember
   WHERE Team_ID = @Team_ID
     
  COMMIT TRAN
  
  RETURN -1


