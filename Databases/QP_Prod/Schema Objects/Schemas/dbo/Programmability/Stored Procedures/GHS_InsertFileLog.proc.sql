/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_InsertFileLog
 *
 * Description:
 *           Save all the mail merge related files (data source, main doc, print
 *           file, archived file, etc.) to log table
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_InsertFileLog (
        @Job_ID        int,
        @FileType      tinyint,
        @SeqNum        smallint,
        @FileName      sysname,
        @FileSize      bigint
       )
AS
  INSERT INTO GHS_MailMergeFileLog (
          Job_ID,
          FileType,
          SeqNum,
          FileName,
          FileSize
         )
  VALUES (
          @Job_ID,
          @FileType,
          @SeqNum,
          @FileName,
          @FileSize
         )
         
  RETURN -1


