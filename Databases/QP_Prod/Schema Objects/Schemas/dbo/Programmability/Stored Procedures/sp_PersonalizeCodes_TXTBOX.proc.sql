/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_TXTBOX    Script Date: 3/31/99 1:03:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_TXTBOX    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_TXTBOX    Script Date: 1/27/99 10:13:09 AM ******/
/* This procedure personalizes all the entries in TextBox_individual */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
/* DV 8/25/1999 - Added WITH LOG to UPDATETEXT so we can run with transaction logging */
CREATE PROCEDURE sp_PersonalizeCodes_TXTBOX
AS
 DECLARE @ptrval varbinary(16)
 DECLARE @IndivTextBox_id int
 DECLARE @strCodeValue varchar(255)
 DECLARE @intStartPos int
 DECLARE @intLength int

 DECLARE PopCodeTxtBox_Cursor CURSOR FOR
             SELECT IndivTextBox_id, strCodeValue, 
                    intStartPos, intLength
      FROM dbo.PopCodeTextBox
      ORDER BY IndivTextBox_id ASC, intStartPos DESC
 OPEN PopCodeTxtBox_Cursor
 FETCH NEXT FROM PopCodeTxtBox_Cursor INTO 
  @IndivTextBox_id, @strCodeValue, @intStartPos, @intLength
 WHILE (@@FETCH_STATUS = 0)
 BEGIN
  SELECT @ptrval = TEXTPTR(RichText)
  FROM dbo.TextBox_Individual
  WHERE IndivTextBox_id = @IndivTextBox_id
  UPDATETEXT dbo.TextBox_Individual.RichText @ptrval @intStartPos @intLength  WITH LOG @strCodeValue
  FETCH NEXT FROM PopCodeTxtBox_Cursor INTO 
   @IndivTextBox_id, @strCodeValue, @intStartPos, @intLength
 END
 CLOSE PopCodeTxtBox_Cursor
 DEALLOCATE PopCodeTxtBox_Cursor


