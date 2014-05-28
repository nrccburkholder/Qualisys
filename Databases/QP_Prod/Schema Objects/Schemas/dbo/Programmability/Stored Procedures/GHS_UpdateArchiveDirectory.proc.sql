/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_UpdateArchiveDirectory
 *
 * Description:
 *           Update archive directory name
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
CREATE PROCEDURE dbo.GHS_UpdateArchiveDirectory (
        @Job_ID                int,
        @ArchiveDirectory      sysname
       )
AS
  UPDATE GHS_MailMergeLog
     SET ArchiveDirectory = @ArchiveDirectory
   WHERE Job_ID = @Job_ID
  
  RETURN -1


