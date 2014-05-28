/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_ChangeUpdateTeam
 *
 * Description:
 *           Pull update report list that client user can access
 *
 * Parameters:
 *           @PU_ID           int
 *                Project Update ID
 *           @CurrentTeam_ID  int
 *                Update's current Team ID
 *           @NewTeam_ID      int
 *                Change to Team ID
 *
 * Return:
 *           0:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  3/15/2007 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[PU_UI_ChangeUpdateTeam] (
                       @PU_ID           int,
                       @CurrentTeam_ID  int,
                       @NewTeam_ID      int
) AS

  SET NOCOUNT ON
  SET XACT_ABORT ON

  IF (@CurrentTeam_ID = @NewTeam_ID) RETURN 0

  IF NOT EXISTS (
      SELECT PU_ID
        FROM PU_Plan
       WHERE PU_ID = @PU_ID
         AND Team_ID = @CurrentTeam_ID
     ) BEGIN
      RAISERROR('Can not find Update with the given PU_ID and Team_ID', 16, 1)
      RETURN 1
  END
  
  IF NOT EXISTS (
      SELECT Team_ID
        FROM Team
       WHERE Team_ID = @NewTeam_ID
     ) BEGIN
      RAISERROR('The new Team_ID is not valid', 16, 1)
      RETURN 1
  END
  
  BEGIN TRAN
      
  UPDATE PU_Plan
     SET Team_ID = @NewTeam_ID
   WHERE PU_ID = @PU_ID

  IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 2
  END
  
  UPDATE Datamart.QP_Comments.dbo.PU_Plan
     SET Team_ID = @NewTeam_ID
   WHERE PU_ID = @PU_ID
  
  IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 2
  END
  
  COMMIT TRAN

  RETURN 0


