/*******************************************************************************
 *
 * Procedure Name:
 *           PU_CM_DropTable
 *
 * Description:
 *           Check table's existance. If exists, drop the table
 *
 * Parameters:
 *           @TableName    varchar(256)
 *             Table to be dropped
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_CM_DropTable (
         @pstrTableName   varchar(256)
       )
AS
  DECLARE @intError              int,
          @strTable              varchar(256),
          @bitExist              bit,
          @strSQL                varchar(512)
  
  SET @bitExist = 0
  IF (SUBSTRING(@pstrTableName, 1, 1) = '#') BEGIN  -- temp table
      SET @strTable = @pstrTableName + '%'
      IF EXISTS(SELECT name FROM tempdb..sysobjects WHERE name LIKE @strTable)
          SET @bitExist = 1
  END
  ELSE BEGIN 
      IF EXISTS (SELECT *
                    FROM dbo.sysobjects
                   WHERE ID = OBJECT_ID(@pstrTableName)
                     AND OBJECTPROPERTY(ID, N'IsUserTable') = 1
                 )
          SET @bitExist = 1
  END

  IF (@bitExist = 1) BEGIN
      SET @strSQL = 'DROP TABLE ' + @pstrTableName
      EXEC(@strSQL)

      IF @@ERROR <> 0 RETURN 1
  END
  
  RETURN -1


