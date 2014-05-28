/*******************************************************************************
 *
 * Procedure Name:
 *           CM_DropIndex
 *
 * Description:
 *           Drop specified index
 *
 * Parameters:
 *           @TableName       sysname
 *               table name
 *           @pstrIndexName   sysname
 *               index name
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_DropIndex (
         @TableName       sysname,
         @pstrIndexName   sysname
       )
AS
  DECLARE @Sql   varchar(1000)

  -- Check if specified index exists
  IF (dbo.CM_IsIndexExisted(@TableName, @pstrIndexName) = 1) BEGIN
      SET @Sql = 'DROP INDEX ' + @TableName + '.' + @pstrIndexName
      EXEC(@Sql)
  END
    
  RETURN 0


