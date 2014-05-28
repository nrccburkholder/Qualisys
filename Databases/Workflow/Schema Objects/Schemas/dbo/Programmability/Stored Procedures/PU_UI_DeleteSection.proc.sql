/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_DeleteSection
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
CREATE PROCEDURE dbo.PU_UI_DeleteSection (
                       @PUReport_ID   int,
                       @Section_ID    int
) AS

  SET NOCOUNT ON

  BEGIN TRAN
  
  DELETE PUR_Section
   WHERE PUReport_ID = @PUReport_ID
     AND Section_ID = @Section_ID

  UPDATE PUR_Section
     SET Section_ID = Section_ID - 1
   WHERE PUReport_ID = @PUReport_ID
     AND Section_ID > @Section_ID
     
  COMMIT TRAN
  
  RETURN -1


