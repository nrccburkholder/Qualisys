/*******************************************************************************
 *
 * Procedure Name:
 *           CM_DropTable
 *
 * Description:
 *           Drop table
 *
 * Parameters:
 *           @TableName    sysname
 *               table name
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_DropTable (
         @TableName   sysname
       )
AS
  DECLARE @bitExist           bit,
          @Sql                varchar(512)
  
  IF (dbo.CM_IsTableExisted(@TableName) = 1) BEGIN
      SET @Sql = 'DROP TABLE ' + @TableName
      EXEC(@Sql)
  END
  
  RETURN 0


