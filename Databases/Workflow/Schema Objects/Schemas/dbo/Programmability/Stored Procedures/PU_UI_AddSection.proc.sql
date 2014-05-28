/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_AddSection
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
CREATE PROCEDURE dbo.PU_UI_AddSection (
                       @PUReport_ID              int,
                       @AppendAfterSection_ID    int,
                       @Type                     tinyint,
                       @Title                    varchar(128)
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @SECTION_COMMENT             int,
          @FORMAT_TEXT                 int

  SET @SECTION_COMMENT = dbo.PU_CM_GetConstant('SECTION_COMMENT')
  SET @FORMAT_TEXT = dbo.PU_CM_GetConstant('FORMAT_TEXT')

  -- Variables
  DECLARE @Format                      int
  
  IF @Type = @SECTION_COMMENT
      SET @Format = @FORMAT_TEXT
  ELSE
      SET @Format = NULL
      
  BEGIN TRAN
  
  UPDATE PUR_Section
     SET Section_ID = Section_ID + 1
   WHERE PUReport_ID = @PUReport_ID
     AND Section_ID > @AppendAfterSection_ID
     
  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Title,
          Format
         )
  VALUES (
          @PUReport_ID,
          @AppendAfterSection_ID + 1,
          @Type,
          @Title,
          @Format
         )
  
  COMMIT TRAN
  
  RETURN -1


